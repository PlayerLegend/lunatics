#include "immutable.c"
#include "../test/debug.h"

void test_immutable_string()
{
    const char * asdf[3] = { "asdf", immutable_string(NULL, asdf[0]), immutable_string(NULL, asdf[1]) };

    assert (0 == strcmp(asdf[0], asdf[1]));
    assert (0 == strcmp(asdf[0], asdf[2]));

    assert (asdf[0] != asdf[1]);
    assert (asdf[1] == asdf[2]);
}

void test_immutable_path()
{
    const char * path[4] = { "/", "////", immutable_path(NULL, path[0]), immutable_path(NULL, path[1]) };

    assert (0 != strcmp (path[0], path[1]));
    
    assert (0 == strcmp (path[0], path[2]));
    assert (0 == strcmp (path[0], path[3]));

    assert (path[0] != path[1]);
    assert (path[1] != path[2]);
    assert (path[0] != path[2]);
    assert (path[2] == path[3]);
}

int main()
{
    test_immutable_string();
    test_immutable_path();

    return 0;
}
