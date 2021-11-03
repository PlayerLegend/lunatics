#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/file.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
int symlink(const char *target, const char *linkpath);
#define FLAT_INCLUDES
#include "../../array/range.h"
#include "../../array/buffer.h"
#include "../../buffer_io/buffer_io.h"
#include "../../tar/spec.h"
#include "../../log/log.h"
#include "../../tar/tar.h"
#include "../../list/list.h"
#include "../../immutable/immutable.h"

#define TABLE_STRING
#define TABLE_VALUE const char* package_name
#include "../../table/table.h"

#include "logfile.h"
#include "path.h"

bool write_file (const char * file_path, buffer_char * buffer)
{
    //log_normal ("Writing: %s", file_path);

    size_t wrote_size = 0;
    int fd = open (file_path, O_WRONLY | O_CREAT, 0755);

    if (-1 == fd)
    {
	perror (file_path);
	return false;
    }

    long long size;

    while ( 0 < (size = buffer_write (.fd = fd, .buffer = buffer, .wrote_size = &wrote_size)) )
    {}

    close (fd);
    
    if (-1 == size)
    {
	perror (file_path);
	return false;
    }
    
    return true;
}

bool file_exists (const char * file_path)
{
    struct stat s;

    if (-1 == stat (file_path, &s))
    {
	return false;
    }

    return true;
}

const char * get_package_name (char * name)
{
    if (name[0] == '.' && name[1] == PATH_SEP)
    {
	name += 2;
    }
    else if (name[0] == PATH_SEP)
    {
	name += 1;
    }

    char * end = strchr (name, PATH_SEP);

    if (!end)
    {
	return NULL;
    }

    *end = '\0';

    if (0 != strcmp (name, "pkg"))
    {
	return NULL;
    }

    name = end + 1;
    end = strchr (name, PATH_SEP);

    if (!end)
    {
	return NULL;
    }

    *end = '\0';

    return immutable_string (NULL, name);
}

void remove_target (const char * path)
{
    struct stat s;

    //if (S_ISREG (s.st_mode) || S_ISLNK (s.st_mode))
    {
	if (-1 == remove (path) && errno != ENOENT)
	{
	    perror (path);
	    log_error ("Failed when removing %s", path);
	}
    }
}

bool should_write_path (table * map, const char * package_name, const char * path)
{
    table_element * element = table_include_element(map, path);

    if (element->child.package_name)
    {
	if (element->child.package_name != package_name)
	{
	    log_error ("\rPath is owned by package '%s': %s", element->child.package_name, path);
	    //printf ("package: %p, %s\n", element->child.package_name, element->child.package_name);
	    assert (element->child.package_name);
	    return false;
	}
    }
    else
    {
	if (file_exists (path))
	{
	    return false;
	}
	    
	element->child.package_name = package_name;
    }

    return true;
}

int main()
{
    if (!chdir_pkg_root())
    {
	return 1;
    }
    
    table map = {};

    table_element * element;
    const char * package_name = NULL;
    
    if (!read_logfile(&map, LOGFILE_PATH_DEFAULT))
    {
	goto fail;
    }

    tar_state state = {};

    while (tar_next (&state, STDIN_FILENO))
    {
	if (state.type == TAR_END)
	{
	    goto done;
	}
	
	if (!create_path (state.name.begin))
	{
	    goto fail;
	}
        
	if (!package_name)
	{
	    if (state.type != TAR_DIR)
	    {
		log_error ("./pkg/[pkgname]/ did not appear before the first non-directory in the input tar");
		goto fail;
	    }

	    package_name = get_package_name (state.name.begin);
	    continue;
	}
	
	if (state.type == TAR_DIR)
	{
	    continue;
	}

	if (!should_write_path (&map, package_name, state.name.begin))
	{
	    log_normal ("\rSkipped: %s", state.name.begin);
	    continue;
	}

	remove_target (state.name.begin);
	
	switch (state.type)
	{
	case TAR_FILE:
	    if (!write_file (state.name.begin, &state.file))
	    {
		goto fail;
	    }
	    break;

	case TAR_HARDLINK:
	    
	    //log_normal ("Creating hardlink: %s -> %s", state.name.begin, state.linkname.begin);
	    
	    if (-1 == link (state.linkname.begin, state.name.begin))
	    {
		perror (state.name.begin);
		goto fail;
	    }
	    break;
	case TAR_SYMLINK:
	    
	    //log_normal ("Creating symlink: %s -> %s", state.name.begin, state.linkname.begin);
	    
	    if (-1 == symlink (state.linkname.begin, state.name.begin))
	    {
		perror (state.name.begin);
		goto fail;
	    }
	    break;

	default:
	    log_error ("debug: Invalid switch state");
	    goto fail;
	}
	
    }

    goto fail;

done:
    if (!write_logfile (LOGFILE_PATH_DEFAULT, &map))
    {
	goto fail;
    }
    
    return 0;
    
fail:
    write_logfile (LOGFILE_PATH_DEFAULT, &map);

    log_error ("Failed to install package");
    
    return 1;
}
