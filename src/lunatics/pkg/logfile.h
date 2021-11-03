#ifndef FLAT_INCLUDES
#include <stdbool.h>
#include <stddef.h>
#define FLAT_INCLUDES
#include "../../array/range.h"
#include "../../array/buffer.h"
#include "../../list/list.h"
#define TABLE_STRING
#define TABLE_VALUE const char* package_name
#include "../../table/table.h"
#endif

#define LOGFILE_PATH_DEFAULT "pkg/files.log"
bool read_logfile (table * map, const char * path);
bool write_logfile (const char * path, table * map);
