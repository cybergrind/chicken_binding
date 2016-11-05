#include <stdlib.h>

void echo_str(const char *str);
void echo_str2(const char **str);

typedef struct {
  unsigned int count;
  const char *str;
} word_count;

void echo_struct(const word_count *wk);
