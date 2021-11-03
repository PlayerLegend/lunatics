#include "buffer.h"
#include "../test/debug.h"

void test_push ()
{
    struct buffer(char) test_buffer = {0};

    for (int i = 0; i < 20; i++)
    {
	*buffer_push (test_buffer) = 'a';
    }

    for (int i = 0; i < 20; i++)
    {
	assert (test_buffer.begin [i] == 'a');
    }

    free (test_buffer.begin);
}

int main (int argc, char * argv[])
{
    test_push ();

    return 0;
}
