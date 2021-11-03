#ifndef FLAT_INCLUDES
#include <stdbool.h>
#define FLAT_INCLUDES
#endif

#define PATH_SEP '/'

bool create_path (const char * file_path);
bool chdir_pkg_root ();
