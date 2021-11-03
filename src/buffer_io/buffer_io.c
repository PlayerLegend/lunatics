#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <assert.h>
#include <stdarg.h>
#define FLAT_INCLUDES
#include "../array/range.h"
#include "../array/buffer.h"
#include "buffer_io.h"

long int _buffer_read(struct buffer_read_args args)
{
    assert (args.buffer);
    
    size_t have_size = range_count(*args.buffer);

    if (args.max_buffer_size && have_size >= args.max_buffer_size)
    {
	return 0;
    }
    
    size_t add_size = have_size;

    if (!add_size)
    {
	add_size = args.initial_alloc_size ? args.initial_alloc_size : 1000;
    }

    size_t new_size = have_size + add_size + 1;

    if (args.max_buffer_size && new_size > args.max_buffer_size)
    {
	new_size = args.max_buffer_size + 1;
	add_size = (new_size - 1) - have_size;
	assert (new_size > have_size);
    }

    buffer_resize (*args.buffer, new_size);

    char * new = args.buffer->begin + have_size;

    long int retval = read (args.fd, new, add_size);

    if (retval >= 0)
    {
	args.buffer->end = args.buffer->begin + have_size + retval;
    }
    else
    {
	args.buffer->end = args.buffer->begin + have_size;
    }

    *args.buffer->end = '\0';

    return retval;
}

long int _buffer_write(struct buffer_write_args args)
{
    assert (args.buffer);
    assert (args.wrote_size);

    char * write_point = args.buffer->begin + *args.wrote_size;

    if (write_point >= args.buffer->end)
    {
	assert (write_point == args.buffer->end);
	return 0;
    }

    ssize_t retval = write (args.fd, write_point, args.buffer->end - write_point);

    if (retval >= 0)
    {
	*args.wrote_size += retval;
    }

    return retval;
}

long int buffer_printf(buffer_char * buffer, const char * str, ...)
{
    va_list list;
    va_start(list, str);
    size_t len = vsnprintf(NULL, 0, str, list);
    va_end(list);

    size_t new_size = len + 1;

    buffer_realloc(*buffer, new_size); 

    va_start(list, str);
    vsprintf(buffer->begin, str, list);
    va_end(list);

    buffer->end = buffer->begin + len;
    *buffer->end = '\0';

    return len;
}

long int buffer_printf_append(buffer_char * buffer, const char * str, ...)
{
    va_list list;
    va_start(list, str);
    size_t len = vsnprintf(NULL, 0, str, list);
    va_end(list);

    size_t old_size = range_count(*buffer);

    size_t new_size = old_size + len + 1;

    buffer_realloc(*buffer, new_size); 

    va_start(list, str);
    vsprintf(buffer->begin + old_size, str, list);
    va_end(list);

    buffer->end = buffer->begin + new_size - 1;
    *buffer->end = '\0';

    return len;
}
