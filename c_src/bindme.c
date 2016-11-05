#include <stdio.h>
#include "bindme.h"


void echo_str(const char *str){
  printf("echo_str: %s\n", str);
}

void echo_str2(const char **str){
  printf("echo_str2: %s\n", *str);
}


void echo_struct(const word_count *wk){
  for (int i=0; i < wk->count; i++){
    printf("echo_struct %i: %s\n", i, wk->str);
  }
}
