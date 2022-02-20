#include <stdio.h>

// DO NOT MODIFY THIS FILE

struct node {
    int val;
    struct node* next;
};

struct node* sort(int n, struct node* node);

int main() {
    int n;
    scanf("%d", &n);

    struct node nodes[n];
    // printf("node address %p\n", nodes);
    for (int i = 0; i < n; i++) {
        scanf("%d", &(nodes[i].val));
        nodes[i].next = NULL;
    }
    // for (int i = 0; i < n; i++) {
    //     printf("I = %d\n", i);
    //     printf("Value of node %d\n",nodes[i].val);
    //     printf("node address with & %p\n", &(nodes[i]));
    //     printf("node address %p\n", nodes[i]);
    //     printf("value address %p\n", &(nodes[i].val));
    //     printf("adress of next %p\n", &(nodes[i].next));
    //     printf("struct next value %p\n", nodes[i].next);
    //     printf("\n\n");

    // }
    struct node* head = sort(n, nodes);

    //     printf("END ==> head == %p\n", head);
    // for (int i = 0; i < n; i++) {
    //     printf("I = %d\n", i);
    //     printf("Value of node %d\n",nodes[i].val);
    //     printf("node address with & %p\n", &(nodes[i]));
    //     printf("node address %p\n", nodes[i]);
    //     printf("value address %p\n", &(nodes[i].val));
    //     printf("adress of next %p\n", &(nodes[i].next));
    //     printf("struct next value %p\n", nodes[i].next);
    //     printf("\n\n");

    // }
    // printf("\n");
    while (head != NULL) {
        printf("%d ", head->val);
        head = head->next;
    }

    return 0;
}
