#define TEST_LIST_H
#include "list.h"
#include "../test/debug.h"
#include <stdio.h>

#define TEST_COUNT 10

void test1()
{
    typedef struct list_element(int) element_int;
    typedef list_handle(element_int) handle_int;
    element_int elements[TEST_COUNT];
    handle_int handle = {0};

    for (int i = 0; i < TEST_COUNT; i++)
    {
	elements[i].child = i;
	list_push (handle, elements[i]);
    }

    element_int * element;

    for_list (element, handle)
    {
	printf ("element: %d\n", element->child);
    }

    while ((element = list_pop (handle)))
    {
	printf ("pop: %d\n", element->child);
    }

    assert (!handle);
}

void test2()
{
    typedef struct list_element(int) element_int;
    typedef struct list_bounds(element_int) bounds_int;

    element_int elements[TEST_COUNT];
    bounds_int bounds = {0};

    for (int i = 0; i < TEST_COUNT; i++)
    {
	elements[i].child = i;
	list_bounds_push_end (bounds, elements[i]);
    }

    element_int * element;

    for_list (element, bounds.begin)
    {
	printf ("element: %d\n", element->child);
    }
    
    while ((element = list_pop (bounds.begin)))
    {
	printf ("pop: %d\n", element->child);
    }

    assert (!bounds.begin);
}

int main (int argc, char * argv[])
{
    test1();
    test2();
    return 0;
}
