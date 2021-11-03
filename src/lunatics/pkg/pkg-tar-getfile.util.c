#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#define FLAT_INCLUDES
#include "../../array/range.h"
#include "../../array/buffer.h"
#include "../../buffer_io/buffer_io.h"
#include "../../tar/spec.h"
#include "../../log/log.h"
#include "../../tar/tar.h"

int main(int argc, char * argv[])
{
    if (argc != 2)
    {
	log_error ("usage: %s [basename]", argv[0]);
    }
    
    long size;
    size_t wrote_size = 0;
    tar_state state = {};

    const char * want_basename = argv[1];

    while (tar_next (&state, STDIN_FILENO))
    {
	if (state.type != TAR_FILE)
	{
	    continue;
	}

	const char * test_basename = strrchr (state.name.begin, '/');

	if (!test_basename)
	{
	    test_basename = state.name.begin;
	}

	if (*test_basename == '/')
	{
	    test_basename++;
	}

	if (0 == strcmp (test_basename, want_basename))
	{
	    goto dump;
	}
    }

    log_error ("basename not found in tar: %s", want_basename);
    goto fail;
    
dump:
    while (0 < (size = buffer_write (.fd = STDOUT_FILENO, .buffer = &state.file, .wrote_size = &wrote_size)))
    {}

    if (-1 == size)
    {
	perror ("stdout");
	goto fail;
    }
    
    return 0;

fail:
    return 1;
}
