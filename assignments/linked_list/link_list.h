#ifndef _LINK_LIST_H_
#define _LINK_LIST_H_

#include <stdio.h>
#include <stdlib.h>

struct list {
	int val;
	struct list *next;
};

struct list *list_node_at(struct list * const st, int ind);
struct list *list_create(int const val);
size_t list_length(struct list * const st);
int list_get(struct list * const st, int const ind);
int list_sum(struct list * const st);
void list_add_front(int const val, struct list **st);
void list_add_back(int const val, struct list * const st);
void list_free(struct list **st);
void list_print(struct list * const st);

#endif
