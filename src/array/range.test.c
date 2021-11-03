#include <stdio.h>
#include <sys/types.h>
#define FLAT_INCLUDES
#include "range.h"
#include "../test/debug.h"

int main (int argc, char * argv[])
{
    struct range(int) range = {0};
    assert (range_count (range) == 0);
    assert (range_is_empty (range));

    int range_body[5];
    range.begin = range_body;
    range.end = range_body + 5;

    assert (range_count (range) == 5);
    assert (!range_is_empty (range));

    for (int i = 0; i < 5; i++)
    {
	int set = 5 - i;
	printf ("set element %d: %d\n", i, set);
	range_body [i] = set;
    }

    int * element;
    
    for_range (element, range)
    {
	printf ("element %zd: %d\n", (ssize_t)(element - range.begin), *element);
    }

    return 0;
}
