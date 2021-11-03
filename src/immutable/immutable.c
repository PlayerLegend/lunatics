#include <assert.h>
#include <limits.h>
#include <pthread.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <linux/limits.h>
char *realpath(const char *path, char *resolved_path);
#define FLAT_INCLUDES
#include "immutable.h"
#include "../list/list.h"
#include "../array/range.h"

#define TABLE_STRING

#include "../table/table.h"

struct table_string
{
    table table;
    pthread_mutex_t mutex;
};

static table_string _default_table = { .mutex = PTHREAD_MUTEX_INITIALIZER };

const char * immutable_string (table_string * table, const char * input)
{
    assert (input);

    if (!table)
    {
	table = &_default_table;
    }
    
    const char * ret;
    pthread_mutex_lock (&table->mutex);
    ret = table_include (&table->table, input);
    pthread_mutex_unlock (&table->mutex);
    return ret;
}

const char * immutable_path (table_string * table, const char * path)
{
    assert (path);
    
    if (!table)
    {
	table = &_default_table;
    }
    
    const char * ret;
    static char resolved[PATH_MAX];
    assert (path);
    pthread_mutex_lock (&table->mutex);
    
    if (realpath (path, resolved))
    {
	ret = table_include (&table->table, resolved);
    }
    else
    {
	ret = table_include (&table->table, "");
	perror (path);
    }
    pthread_mutex_unlock (&table->mutex);
    return ret;
}
