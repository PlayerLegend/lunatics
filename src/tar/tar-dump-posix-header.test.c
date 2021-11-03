#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#define FLAT_INCLUDES
#include "../array/range.h"
#include "../array/buffer.h"
#include "../buffer_io/buffer_io.h"
#include "spec.h"
#include "../log/log.h"

#define print_string_field(field) printf ("%.*s\n", (int) sizeof (field), field)

size_t read_size (struct posix_header * header)
{
    char * endptr;
    size_t retval = 0;

    if (header->size[0] & 128) // base 256 encoding
    {
	log_error ("base 256 not implemented");
	assert (0);
	
    }
    else // null terminated octal encoding
    {
	retval = strtol (header->size, &endptr, 8);
	if (!*header->size || *endptr)
	{
	    log_error ("could not parse size");
	    assert (0);
	}
    }

    return retval;
}

void print_header (struct posix_header * header)
{
    print_string_field (header->name);
    print_string_field (header->magic);
    printf ("%zu\n", read_size (header));
}

int main()
{
    buffer_char buffer = {};

    size_t size;

    while ( 0 < (size = buffer_read (.buffer = &buffer, .fd = STDIN_FILENO)) )
    {
    }

    assert (size == 0);

    struct posix_header * header = (void*) buffer.begin;

    print_header (header);
}
