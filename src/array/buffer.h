#ifndef FLAT_INCLUDES
#include <stdio.h>
#include <stdlib.h>
#define FLAT_INCLUDES
#include "range.h"
#endif

#define buffer(type) { struct range(type); type * max; }
typedef struct buffer(void) buffer_void;

inline static int _buffer_resize (buffer_void * expand_buffer, size_t type_size, size_t new_count)
{
    size_t new_size = type_size * new_count;
    void * new_region = realloc (expand_buffer->begin, new_size);
    if (!new_region)
    {
	perror ("realloc");
	return -1;
    }
    size_t range_size = range_count (*expand_buffer);
    *expand_buffer = (buffer_void) { .begin = new_region,
				     .end = new_region + range_size,
				     .max = new_region + new_size };
    return 0;
}

#define buffer_realloc(buffer, count)                   \
    {                                                                   \
	if ( (size_t)((buffer).max - (buffer).begin) <= (size_t)(count) ) \
        {                                                               \
            _buffer_resize ((buffer_void*)&(buffer), sizeof (*(buffer).begin), (count) * 2); \
        }                                                               \
    }

#define buffer_resize(buffer, count)            \
    {                                           \
        buffer_realloc (buffer, count);         \
        (buffer).end = (buffer).begin + (count);        \
    }

#define buffer_push(buffer)			\
    ((buffer).end == (buffer).max ? _buffer_resize ( (buffer_void*)&(buffer), sizeof (*(buffer).begin), 10 + ((buffer).max - (buffer).begin) * 3 ), (buffer).end++ : (buffer).end++)

#define buffer_rewrite(buffer)			\
    { (buffer).end = (buffer).begin; }

typedef struct buffer(char) buffer_char;
typedef struct buffer(char*) buffer_string;
