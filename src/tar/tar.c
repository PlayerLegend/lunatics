#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <stdint.h>
#define FLAT_INCLUDES
#include "../array/range.h"
#include "../array/buffer.h"
#include "../buffer_io/buffer_io.h"
#include "spec.h"
#include "../log/log.h"
#include "tar.h"

#define BLOCK_SIZE 512
#define fatal(...) { log_error (__VA_ARGS__); goto fail; }

bool tar_is_dir (buffer_char * buffer)
{
    log_debug ("typeflag: %c", ((struct posix_header*) buffer->begin)->typeflag);
    return ( (struct posix_header*) buffer->begin )->typeflag == DIRTYPE;
}

bool tar_is_file (buffer_char * buffer)
{
    return ( (struct posix_header*) buffer->begin )->typeflag == REGTYPE;
}

bool tar_is_hardlink (buffer_char * buffer)
{
    return ( (struct posix_header*) buffer->begin )->typeflag == LNKTYPE;
}

bool tar_is_symlink (buffer_char * buffer)
{
    return ( (struct posix_header*) buffer->begin )->typeflag == '2';
}

bool tar_is_longname (buffer_char * buffer)
{
    return ( (struct posix_header*) buffer->begin )->typeflag == 'L';
}

bool tar_is_longlink (buffer_char * buffer)
{
    return ( (struct posix_header*) buffer->begin )->typeflag == 'K';
}

bool tar_read_header (buffer_char * output, int fd)
{
    size_t size;

    buffer_rewrite (*output);

    while ( 0 < (size = buffer_read (.buffer = output, .fd = fd, .max_buffer_size = BLOCK_SIZE)) )
    {}

    if (size != 0)
    {
	log_error ("Failed to read tar header");
	return false;
    }

    if (range_count (*output) != BLOCK_SIZE)
    {
	log_error ("Read incorrect header size %zu, should be %zu", range_count(*output), BLOCK_SIZE);
	return false;
    }

    return true;
}

bool tar_get_size (size_t * size, buffer_char * buffer)
{
    char * endptr;

    struct posix_header * header = (void*) buffer->begin;

    if (header->size[0] & 128) // base 256 encoding
    {
	log_error ("base 256 not implemented");
	return false;
    }
    else // null terminated octal encoding
    {
	*size = strtol (header->size, &endptr, 8);
	if (!*header->size || *endptr)
	{
	    log_error ("could not parse size");
	    return false;
	}
    }

    return true;
}

void tar_get_name (buffer_char * output, buffer_char * header)
{
    size_t size = strlen (header->begin) + 1;
    buffer_resize (*output, size);
    memcpy (output->begin, header->begin, size);
    output->end--;
    *output->end = '\0';
    assert (!strchr (output->begin, '\n'));
}

void tar_get_linkname (buffer_char * output, buffer_char * header)
{
    const char * string = ((struct posix_header*) header->begin)->linkname;
    size_t size = strlen (string) + 1;
    buffer_resize (*output, size);
    memcpy (output->begin, string, size);
    output->end--;
    *output->end = '\0';
    assert (!strchr (output->begin, '\n'));
}

bool tar_read_file (buffer_char * output, buffer_char * header, int fd)
{
    size_t size;

    size_t file_size;

    if (!tar_get_size(&file_size, header))
    {
	return false;
    }

    if (file_size == 0)
    {
	buffer_resize (*output, 1);
	*output->begin = '\0';
	output->end--;
	return true;
    }

    size_t block_size = BLOCK_SIZE * (( (file_size - 1) / BLOCK_SIZE) + 1);

    buffer_rewrite (*output);

    while ( 0 < (size = buffer_read (.buffer = output, .fd = fd, .max_buffer_size = block_size)) )
    {}

    if (size != 0)
    {
	log_error ("Failed to read tar file");
	return false;
    }

    if ((size_t) range_count (*output) != block_size)
    {
	log_error ("Read incorrect file size %zu, should be %zu", range_count(*output), block_size);
	return false;
    }

    buffer_resize (*output, file_size);
    *output->end = '\0';

    return true;
}

static bool block_is_zero (buffer_char * header)
{
    for (uint64_t *test = (void*) header->begin; (void*) test < (void*) header->end; test++)
    {
	if (*test != 0)
	{
	    return false;
	}
    }

    return true;
}

bool tar_is_done (buffer_char * header, int fd)
{
    if (!block_is_zero (header))
    {
	return false;
    }

    if (!tar_read_header (header, fd))
    {
	return false;
    }

    if (!block_is_zero (header))
    {
	return false;
    }

    return true;
}

bool tar_next_sub (tar_state * state, int fd, bool longname, bool longlink)
{
    state->type = TAR_INVALID;
    
    if (!tar_read_header(&state->header, fd))
    {
	return false;
    }

    if (tar_is_done (&state->header, fd))
    {
	state->type = TAR_END;
	return true;
    }

    switch ( ((struct posix_header*) state->header.begin)->typeflag )
    {
    case DIRTYPE:
	if (!longname)
	{
	    tar_get_name(&state->name, &state->header);
	}
	state->type = TAR_DIR;
	return true;
	
    case REGTYPE:
	if (!longname)
	{
	    tar_get_name(&state->name, &state->header);
	}
	if (!tar_read_file (&state->file, &state->header, fd))
	{
	    goto fail;
	}
	state->type = TAR_FILE;
	return true;
	
    case LNKTYPE:
	if (!longname)
	{
	    tar_get_name(&state->name, &state->header);
	}
	if (!longlink)
	{
	    tar_get_linkname(&state->linkname, &state->header);
	}
	state->type = TAR_HARDLINK;
	return true;
	
    case SYMTYPE:
	if (!longname)
	{
	    tar_get_name(&state->name, &state->header);
	}
	if (!longlink)
	{
	    tar_get_linkname(&state->linkname, &state->header);
	}
	state->type = TAR_SYMLINK;
	return true;
	
    case GNUTYPE_LONGNAME:
	if (longname)
	{
	    fatal ("Double longname in tar");
	}

	tar_read_file (&state->name, &state->header, fd);

	return tar_next_sub (state, fd, true, longlink);
	
    case GNUTYPE_LONGLINK:
	if (longname)
	{
	    fatal ("Double longlink in tar");
	}

	tar_read_file (&state->linkname, &state->header, fd);

	return tar_next_sub (state, fd, longname, true);
    }

fail:
    state->type = TAR_INVALID;
    return false;
}

bool tar_next (tar_state * state, int fd)
{
    bool retval = tar_next_sub (state, fd, false, false);
    assert ( retval == (state->type != TAR_INVALID) );
    return retval;
}
