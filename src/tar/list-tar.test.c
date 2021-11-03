#include "tar.c"


int main()
{
    buffer_char buffer = {};
    buffer_char name = {};

    int fd = STDIN_FILENO;
    size_t size;

    while (true)
    {
	if (!tar_read_header(&buffer, fd))
	{
	    return 1;
	}
	
	if (tar_is_done (&buffer, fd))
	{
	    return 0;
	}

	tar_get_name (&name, &buffer);
	if (!tar_get_size (&size, &buffer))
	{
	    return 1;
	}

	log_normal ("[%zu] %s", size, name.begin);

	if (tar_is_file(&buffer))
	{
	    if (!tar_read_file(&buffer, &buffer, fd))
	    {
		return 1;
	    }

	    log_normal ("contents: %s", buffer.begin);
	}
	else if (tar_is_dir (&buffer))
	{
	    log_normal ("is directory");
	}
	else
	{
	    log_error ("not a file or directory");
	}

	log_normal("");
    }

    return 1;
}
