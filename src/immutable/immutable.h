#ifndef FLAT_INCLUDES
#define FLAT_INCLUDES
#endif

typedef struct table_string table_string;

const char * immutable_string (table_string * table, const char * input);
const char * immutable_path (table_string * table, const char * path);
