#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define FLAT_INCLUDES
#include "../array/range.h"
#include "../array/buffer.h"
#include "buffer_io.h"
#include "../test/debug.h"

void test_buffer_printf()
{
    buffer_char buffer = {0};

    buffer_printf (&buffer, "ab %s %d", "cd", 10);

    assert (0 == strcmp (buffer.begin, "ab cd 10"));
    
    buffer_printf (&buffer, "ab %s %d", "cd", 53);

    assert (0 == strcmp (buffer.begin, "ab cd 53"));
}

void test_buffer_printf_append()
{
    buffer_char buffer = {0};

    buffer_printf_append (&buffer, "ab %s %d", "cd", 10);

    assert (0 == strcmp (buffer.begin, "ab cd 10"));
    
    buffer_printf_append (&buffer, "ab %s %d", "cd", 64);

    assert (0 == strcmp (buffer.begin, "ab cd 10ab cd 64"));
}

int main() {
    long int size;
    buffer_char buffer = {0};

    while ( 0 < (size = buffer_read (.buffer = &buffer, .fd = STDIN_FILENO)) )
    {
    }

    assert (size == 0);

    size_t wrote_size = 0;
    
    while ( 0 < (size = buffer_write (.buffer = &buffer, .wrote_size = &wrote_size, .fd = STDOUT_FILENO )) )
    {
    }

    assert (size == 0);

    assert (wrote_size == (size_t)range_count(buffer));

    test_buffer_printf();
    test_buffer_printf_append();

    return 0;
}
