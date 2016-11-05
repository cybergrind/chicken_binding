#include "bindme.h"

int main(int argc, char* argv[]){

  const char *hw = "hello world";
  echo_str(hw);
  echo_str2(&hw);

  word_count wk = {2, hw};
  echo_struct(&wk);

  word_count *wk2 = malloc(sizeof(word_count));
  const char *hw2 = "dlrow olleh";
  wk2->count = 3;
  wk2->str = hw2;
  echo_struct(wk2);
  free(wk2);

  return 0;
}
