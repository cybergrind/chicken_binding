#include "bindme.h"

int main(int argc, char* argv[]){

  const char *hw = "hello world";
  echo_str(hw);
  echo_str2(&hw);
  return 0;
}
