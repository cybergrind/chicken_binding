exec: c_src/bindme.o c_src/exec.c
	clang -I./include c_src/exec.c c_src/bindme.o -o exec
	./exec

c_src/bindme.o: c_src/bindme.c include/bindme.h
	clang -I./include -c c_src/bindme.c -o c_src/bindme.o
