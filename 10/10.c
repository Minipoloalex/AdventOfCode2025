#include "stdio.h"
#include "stdlib.h"
#include "stdbool.h"
#include "string.h"

typedef struct node {
    struct node *nxt;
    int val;
} node;

typedef struct {
    node *st, *last;
    int len;
} queue;

bool empty(queue *cur) {
    return cur->st == NULL;
}
queue *pushq(queue *cur, int val) {
    cur->len++;
    node *n = malloc(sizeof(node));
    n->nxt = NULL;
    n->val = val;
    if (empty(cur)) {
        cur->st = n;
    }
    if (cur->last != NULL) {
        cur->last->nxt = n;
    }
    cur->last = n;
}
queue *popq(queue *cur, int *val) { // assumes queue not empty
    cur->len--;
    node *n = cur->st;
    *val = n->val;
    cur->st = n->nxt;
    free(n);
    if (empty(cur)) {
        cur->st = cur->last = NULL;
    }
    return cur;
}

int bfs(int lights, int len, int *a, int sza) {
    unsigned *dist = malloc(sizeof(unsigned) << len);
    memset(dist, -1, sizeof(unsigned) << len);
    queue q;
    q.last = q.st = NULL;
    q.len = 0;
    dist[0] = 0;
    pushq(&q, 0);
    while (!empty(&q)) {
        int mask;
        popq(&q, &mask);
        unsigned d = dist[mask];
        // printf("len: %d, mask: %d, dist: %u\n", q.len, mask, d);
        for (int i = 0; i < sza; i++) {
            int nxtmask = mask ^ a[i];
            // printf("%u\n", dist[nxtmask]);
            if (d + 1 < dist[nxtmask]) {
                dist[nxtmask] = d + 1;
                // printf("here\n");
                pushq(&q, nxtmask);
            }
        }
    }
    unsigned ans = dist[lights];
    free(dist);
    return (int)ans;
}

int main() {
    const int MAX_ACTIONS = 20;
    int acts[MAX_ACTIONS];
    int ans = 0;
    while (true) {
        char *buf = NULL;
        size_t len;
        int read = getline(&buf, &len, stdin);
        if (read == -1) break;

        char lights[30];
        char actions[100];
        sscanf(buf, "[%[^]]]", lights);

        int lights_nr = 0;
        int lights_len = (int)strlen(lights);

        for (int i = 0; lights[i]; i++) {
            int bit = lights[i] == '.' ? 0 : 1;
            lights_nr |= bit << i;
        }

        int offset = lights_len + 3;
        char *token;
        int id = 0;
        while (true) {
            int matched = sscanf(buf+offset, "(%[^)])", actions);
            if (matched == 0) break;

            offset += strlen(actions) + 3;
            int act_mask = 0;
            char *act = actions;
            while ((token = strtok(act, ",")) != NULL) {
                act_mask |= 1 << atoi(token);
                act = NULL;
            }
            acts[id++] = act_mask;
        }
        ans += bfs(lights_nr, lights_len, acts, id);
        free(buf);
    }
    printf("%d\n", ans);
    return 0;
}
