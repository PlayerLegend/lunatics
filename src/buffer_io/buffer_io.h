#ifndef FLAT_INCLUDES
#include <stdio.h>
#include <stdlib.h>
#define FLAT_INCLUDES
#include "../array/range.h"
#include "../array/buffer.h"
#endif

#ifndef STDIN_FILENO
#define STDIN_FILENO 0
#endif

#ifndef STDOUT_FILENO
#define STDOUT_FILENO 1
#endif

#ifndef STDERR_FILENO
#define STDERR_FILENO 2
#endif

struct buffer_read_args {buffer_char * buffer; size_t max_buffer_size; size_t initial_alloc_size; int fd;};
long int _buffer_read(struct buffer_read_args args);
#define buffer_read(...) _buffer_read((struct buffer_read_args){__VA_ARGS__})

struct buffer_write_args {buffer_char * buffer; size_t * wrote_size; int fd;};
long int _buffer_write(struct buffer_write_args args);
#define buffer_write(...) _buffer_write((struct buffer_write_args){__VA_ARGS__})

long int buffer_printf(buffer_char * buffer, const char * str, ...);
long int buffer_printf_append(buffer_char * buffer, const char * str, ...);
