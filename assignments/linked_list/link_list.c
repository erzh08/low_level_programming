#include "link_list.h"

struct list *list_create(int const val){
	struct list *node = malloc(sizeof(struct list));

	node->val = val;
	node->next = NULL;

	return node;
}

void list_add_front(int const val, struct list **st){
	struct list *nnode = list_create(val);

	nnode->next = *st;

	*st = nnode;
}

void list_add_back(int const val, struct list * const st){
	struct list *nnode = list_create(val);
	struct list *tmp;

	nnode->next = NULL;

	tmp = st;
	while(tmp->next != NULL){
		tmp = tmp->next;
	}

	tmp->next = nnode;
}

int list_get(struct list * const st, int const ind){
	struct list *tmp = st;
	int ret = 0, i = -1;

	while(tmp != NULL){
		if(++i == ind){
			ret = tmp->val;
			break;
		}

		tmp = tmp->next;
	}

	return ret;
}

void list_free(struct list **st){
	struct list *tmp1 = *st, *tmp2;

	while(tmp1 != NULL){
		tmp2 = tmp1;
		tmp1 = tmp1->next;
		free(tmp2);
	}

	*st = NULL;
}

size_t list_length(struct list * const st){
	size_t size = 0;
	struct list *tmp = st;

	while(tmp != NULL){
		size++;
		tmp = tmp->next;
	}

	return size;
}

struct list *list_node_at(struct list * const st, int const ind){
	struct list *dnode = NULL;
	struct list *tmp = st;
	int i = -1;

	while(tmp != NULL){
		if(++i == ind){
			dnode = tmp;
			break;
		}

		tmp = tmp->next;
	}

	return dnode;
}

int list_sum(struct list * const st){
	struct list *tmp = st;
	int sum = 0;

	while(tmp != NULL){
		sum += tmp->val;
		tmp = tmp->next;
	}

	return sum;
}

void list_print(struct list * const st){
	struct list *tmp = st;

	while(tmp != NULL){
		if(tmp->next == NULL)
			printf("%d\n", tmp->val);
		else
			printf("%d - ", tmp->val);
		tmp = tmp->next;
	}
}

