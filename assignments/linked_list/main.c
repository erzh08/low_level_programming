#include "link_list.h"

int main(int argc, char **argv){
	struct list *st;
	int val, num, sum = 0;

	scanf("%d", &num);
	st = list_create(num);

	while(scanf("%d", &num) != EOF){
		list_add_front(num, &st);
	}

	list_print(st);

	if(sum = list_sum(st))
		printf("Sum = %d\n", sum);
	else
		puts("No elements at list!");

	if(val = list_get(st, 3))
		printf("list[3] = %d\n", val);
	else
		puts("Index out of bounds");

	list_free(&st);

	return 0;
}

