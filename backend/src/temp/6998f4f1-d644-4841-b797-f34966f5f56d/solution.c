#include <stdio.h>
#include <string.h>

void reverseWords(char *s) {
    char words[100][100];
    int wordCount = 0;
    char *token = strtok(s, " ");
    while(token != NULL) {
        strcpy(words[wordCount++], token);
        token = strtok(NULL, " ");
    }
    for(int i = wordCount-1; i >= 0; i--) {
        printf("%s", words[i]);
        if(i > 0) printf(" ");
    }
    printf("\n");
}

int main() {
    char s[1000];
    fgets(s, 1000, stdin);
    reverseWords(s);
    return 0;
}