#include <errno.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>
#define FLAT_INCLUDES
#include "path.h"
#include "../../array/range.h"
#include "../../array/buffer.h"
#include "../../buffer_io/buffer_io.h"
#include "../../log/log.h"

static void buffer_copy_range (buffer_char * to, const range_const_char * from)
{
    size_t size = range_count (*from) + 1;
    buffer_resize (*to, size);
    memcpy (to->begin, from->begin, size - 1);
    to->end--;
    *to->end = '\0';
}

bool create_path (const char * file_path)
{
    range_const_char name = { .begin = file_path };
    const char * cursor = *file_path == PATH_SEP ? file_path + 1 : file_path;
    buffer_char name_buffer = {};

    while ( (name.end = strchr (cursor, PATH_SEP)) )
    {
	buffer_copy_range (&name_buffer, &name);
	
	if (-1 == mkdir (name_buffer.begin, 0755) && errno != EEXIST)
	{
	    log_error ("Could not create directory %s in %s", name_buffer.begin, file_path);
	    perror (file_path);
	    goto fail;
	}

	cursor = name.end + 1;
    }

    free (name_buffer.begin);
    return true;

fail:
    free (name_buffer.begin);
    return false;
}

bool chdir_pkg_root ()
{
    char * pkg_root = getenv ("PKG_ROOT");

    buffer_char path = {};

    if (!pkg_root)
    {
	buffer_printf (&path, "%c", PATH_SEP);
    }
    else if (pkg_root[strlen (pkg_root)] != PATH_SEP)
    {
	buffer_printf (&path, "%s/", pkg_root);
    }
    else
    {
	buffer_printf (&path, "%s", pkg_root);
    }
    
    if (!create_path (path.begin))
    {
	goto fail;
    }

    if (-1 == chdir (path.begin))
    {
	goto fail;
    }

    free (path.begin);
    
    return true;

fail:
    free (path.begin);

    return false;
}
