#ifndef FLAT_INCLUDES
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#define FLAT_INCLUDES
#include "../array/range.h"
#include "../array/buffer.h"
#include "../buffer_io/buffer_io.h"
#include "spec.h"
#include "../log/log.h"
#endif

typedef enum tar_type tar_type;
enum tar_type { TAR_DIR, TAR_FILE, TAR_SYMLINK, TAR_HARDLINK, TAR_END, TAR_INVALID };

typedef struct tar_state tar_state;
struct tar_state
{
    tar_type type;
    buffer_char file;
    buffer_char header;
    buffer_char name;
    buffer_char linkname;
};

bool tar_is_dir (buffer_char * buffer);
bool tar_is_file (buffer_char * buffer);
bool tar_is_hardlink (buffer_char * buffer);
bool tar_is_symlink (buffer_char * buffer);
bool tar_is_longname (buffer_char * buffer);
bool tar_is_longlink (buffer_char * buffer);
bool tar_read_header (buffer_char * output, int fd);
bool tar_get_size (size_t * size, buffer_char * buffer);
void tar_get_name (buffer_char * output, buffer_char * header);
void tar_get_linkname (buffer_char * output, buffer_char * header);
bool tar_read_file (buffer_char * output, buffer_char * header, int fd);
bool tar_is_done (buffer_char * header, int fd);

bool tar_next (tar_state * state, int fd);
