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

static bool load_file (buffer_char * buffer, const char * filename)
{
    int fd = open (filename, O_RDONLY);

    if (fd == -1)
    {
	if (errno == ENOENT)
	{
	    return true;
	}
	
	perror (filename);
	return false;
    }
    
    size_t size;
    
    while ( 0 < (size = buffer_read (.fd = fd, .buffer = buffer)) )
    {}

    if (size != 0)
    {
	perror (filename);
	goto fail;
    }

    close (fd);
    return true;
    
fail:
    close (fd);
    return false;
}

bool read_logfile (table * map, const char * path)
{
    buffer_char file = {};

    if (!load_file (&file, path))
    {
	return false;
    }
    
    if (!file.begin)
    {
	return true;
    }
    
    range_char line = { .begin = file.begin };

    char * path_name;
    char * package_name;

    while ( (line.end = strchr (line.begin, '\n')) )
    {
	*line.end = '\0';

	package_name = line.begin;
	path_name = line.begin;
	while (*path_name && !isspace (*path_name))
	{
	    path_name++;
	}

	if (!*path_name)
	{
	    log_error ("malformated line, missing pathname");
	    continue;
	}

	*path_name = '\0';
	path_name++;

	while (*path_name && isspace (*path_name))
	{
	    path_name++;
	}

	table_include_element (map, path_name)->child.package_name = immutable_string (NULL, package_name);

	line.begin = line.end + 1;
    }
    
    return true;
}

bool write_logfile (const char * path, table * map)
{
    if (!create_path(path))
    {
	return false;
    }
    
    log_debug ("Writing log file %s", path);
    
    FILE * file = fopen (path, "w");

    if (!file)
    {
	perror (path);
	return false;
    }

    table_element * element;
    table_bucket * bucket;

    for_table (element, bucket, *map)
    {
	if (!element->child.package_name)
	{
	    continue;
	}
	
	if (-1 == fprintf (file, "%s %s\n", element->child.package_name, element->child.key))
	{
	    perror (path);
	    fclose (file);
	    return false;
	}
    }

    fclose (file);

    table_clear (map);
    return true;
}
