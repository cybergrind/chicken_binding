# Writting chicken scheme binding

Learning how to create Chicken bindings to C libraries.

## Reading list

* [Guide how to call Chicken <-> C](http://www.more-magic.net/posts/scheme-c-integration.html)
* [Good example repo: lmdb binding](https://github.com/iraikov/chicken-lmdb/blob/master/lmdb.scm)


## Writting binding for C library

I'm using my own example library library to control whole codebase here and make it as simple as possible. `C` sources are in `c_src` and `include` directories.

Also there is `Makefile` to check that everything is ok, so you can also check it to find exact commands to build sources.

### Simple bindings

#### Building sources basics

You can check `Makefile` to find out exact commands.

Some gotchas for building:

* `-I<directory>` - `directory` must be written without space
* You should include files when compile, linking - you may be done without includes
* `csc -c <filename.scm>` will produce only `<filename.o>`
* `csc <filename.scm> -o` will produce executable `<filename>`, by default first filename will be used as pattern


#### Simplest binding

`echo_str` just prints passed string:

```c
void echo_str(const char *str){
  printf("echo_str: %s\n", str);
}
```

So to call it you should do two things:

1. Include headers
```scheme
(foreign-declare "#include \"bindme.h\"")
```
2. Declare [foreign-lambda](http://wiki.call-cc.org/man/4/Accessing%20external%20objects#foreign-lambda) binding in your scheme code
```scheme
(define echo-str
  (foreign-lambda void echo_str c-string))
```

#### Types declaration

Use [foreign types specifiers](http://wiki.call-cc.org/man/4/Foreign%20type%20specifiers#user-defined-c-types) page to declare types in different bindings. Also make sure that you've scrolled it down to [map of foreign types to C types](http://wiki.call-cc.org/man/4/Foreign%20type%20specifiers#map-of-foreign-types-to-c-types) it's usuall very helpfull when you starting.

Some gotchas:

* If you need some type with qualifiers (like: `const`) you should declare it like this `(const TYPE)`:

```scheme
;; non-const version
(foreign-lambda void echo_str c-string)

;; const version
(foreign-lambda void echo_str (const c-string))
```

#### Type conversions

Sometimes you cannot just pass scheme type to C function and you need to convert it type. You have several options how to do this:

* Simplest way is to convert type by writting C code and using [foreign-lambda*](http://wiki.call-cc.org/man/4/Accessing%20external%20objects#foreign-lambda)

```scheme
(define echo-str2
  (foreign-safe-lambda* void (((const c-string) str))
    "echo_str2(&str);"))
```
* You may define some helpers an use [foreign-primitive](http://wiki.call-cc.org/man/4/Accessing%20external%20objects#foreign-primitive), it would allocate it on stack, so be aware

```scheme
(define str-to-pointer
  (lambda (str)
    ((foreign-primitive (c-pointer c-string) ((c-string str)) "C_return(&str);") str)))
```

#### `foreign-lambda` vs `foreign-lambda*`

You should use `foreign-lambda` when you don't need any additional convertational steps to call external code. In `foreign-lambda*` you may write additional pieces of C code when you cannot do direct call.
