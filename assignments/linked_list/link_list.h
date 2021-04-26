#ifndef _LINK_LIST_H_
#define _LINK_LIST_H_

#include <stdio.h>
#include <stdlib.h>

struct list {
	int val;
	struct list *next;
};

struct list *list_create(int val);
void list_add_front(int val, struct list *st);
void list_add_back(int val, struct list *st);
int list_get(struct list *st, int ind);
void list_free(struct list *st);
size_t list_length(struct list *st);
struct list *list_node_at(struct list *st, int ind);
int list_sum(struct list *st);

#endif
