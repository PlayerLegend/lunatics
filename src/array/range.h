#ifndef FLAT_INCLUDES
#define FLAT_INCLUDES
#endif

#define range(type,...)				\
    { type *begin; type *end; }

#define range_count(range)			\
    ( (range).end - (range).begin )

#define range_is_empty(range)			\
    ( (range).end == (range).begin )

#define for_range(iter_name, object)					\
    for (iter_name = (object).begin; iter_name != (object).end; iter_name++)

#define for_range_redo(iter_name)		\
    { (iter_name)--; continue; }

#define range_index(element,container)		\
    ( (element) - (container).begin )

#define range_alloc(range, count)		\
    {									\
	(range).begin = malloc (sizeof (*(range).begin) * count);	\
	(range).end = (range).begin + count;				\
    }

#define range_calloc(range, count)		\
    {									\
	(range).begin = calloc (count, sizeof (*(range).begin));		\
	(range).end = (range).begin + count;				\
    }

typedef struct range(char) range_char;
typedef struct range(const char) range_const_char;
typedef struct range(void) range_void;
