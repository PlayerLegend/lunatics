#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#define FLAT_INCLUDES
#include "../../array/range.h"
#include "../../array/buffer.h"
#include "../../buffer_io/buffer_io.h"
#include "../../list/list.h"
#define TABLE_STRING
#define TABLE_VALUE const char* package_name
#include "../../table/table.h"
#include "logfile.h"
#include "../../log/log.h"
#include "../../immutable/immutable.h"
#include "path.h"

bool pkg_uninstall (const char * name)
{
    table map = {};

    if (!read_logfile (&map, LOGFILE_PATH_DEFAULT))
    {
	return false;
    }

    const char * name_immutable = immutable_string (NULL, name);
    
    table_element * element;
    table_bucket * bucket;

    for_table (element, bucket, map)
    {
	if (element->child.package_name == name_immutable)
	{
	    if (-1 == remove (element->child.key) && errno != ENOENT)
	    {
		goto fail;
	    }
	    
	    element->child.package_name = NULL;

	    log_normal ("Removed %s", element->child.key);
	}
    }

    if (!write_logfile (LOGFILE_PATH_DEFAULT, &map))
    {
	goto fail;
    }

    return true;

fail:
    write_logfile (LOGFILE_PATH_DEFAULT, &map);
    return false;
}

int main (int argc, char * argv[])
{
    if (!chdir_pkg_root())
    {
	return 1;
    }
    
    for (int i = 1; i < argc; i++)
    {
	pkg_uninstall (argv[i]);
    }

    return 0;
}
