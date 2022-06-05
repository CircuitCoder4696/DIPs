# `__LOCAL__` special token

| Field           | Value                                                           |
|-----------------|-----------------------------------------------------------------|
| DIP:            | (number/id -- assigned by DIP Manager)                          |
| Review Count:   | 0 (edited by DIP Manager)                                       |
| Author:         | monkyyy, monkyyy@shitposting.expert                                    |
| Co-author(s):   | CircuitCoder4696                                    |
| Implementation: | (links to implementation PR if any)                             |
| Status:         | Will be set by the DIP manager (e.g. "Approved" or "Rejected")  |

## Abstract

Returns user-defined local symbols, that are defined before the token call site.

```
int foo;
float bar;
static assert(is(__LOCAL__==AliasSeq!(foo,bar));
```


## Contents
* [Rationale](#rationale)
* [Prior Work](#prior-work)
* [Description](#description)
* [Breaking Changes and Deprecations](#breaking-changes-and-deprecations)
* [Reference](#reference)
* [Examples](#example)
* [Copyright & License](#copyright--license)
* [Reviews](#reviews)

## Rationale

Often while meta-programming you want a list of symbols, this can be hard if not impossible to get thru traits or require the user to maintain a separate list.

Only grabbing symbols before itself is to avoid circular reference, and to give users an easy filter.

## Prior Work

I am unaware of any compiled languages that allow D's level introspection or any interpreted languages that would use template-like syntax or restrictions.

## Description

`__LOCAL__` is added to the list of reserve keywords.

The `__LOCAL__` token is replaced with an `AliasSquence` of variables, functions, aliases, enums, and types declared after the current `BlockStatement` but before the `__LOCAL__`'s token position in the `StatementList`.

```d
int ignored;
int referenced;
void main(){
    alias foo=referenced;
    struct bar{}
    alias faz=sometemplate!int;
    alias firstcopy=__LOCAL__;//foo,bar,faz
    int baz;
    alias secondcopy=__LOCAL__;//foo,bar,faz,firstcopy,baz
}
```

## Examples

```d
void debugprinter(alias symbols= __LOCAL__){
	foreach(s;symbols){
		s.stringof.writeln(" : ",s);
}}

void main(){
	int a=1;
	int b=1;
	alias dp=debugprinter!();
	while(true){
		a=a+b;
		b=a-b;
		dp();
	}
}
```<!-- Unfortunately running into difficulties with this one.  
    onlineapp.d(3): Error: found `:` when expecting `)`
    Also, `symbols:__LOCAL__` as a parameter for `debugprinter` doesn't look right to me.  
 -->

```d

import std;

struct Vector2 {
    enum maxcount= 2;
    public double x;
    public double y;
}

struct player{
	enum maxcount=4;
	int x;
	int y;
}

struct asteroid{
	enum maxcount=100;
	int x;
	int y;
	Vector2[] shape;
}

struct bullet{
	enum maxcount=500;
	int x;
	int y;
	int xv;
	int yv;
}

// The compiler would treat the code in the next line by generating something like alias `AliasSeq!(`{local variables listed in an alias-sequence}`)`.  
alias mytypes=__LOCAL__;
    AliasSeq!(Vector2, player, asteroid, bullet);
struct myarray(T){
	T[T.maxcount] me;
}

void main() {
    foreach(T;mytypes){
	    mixin("myarray!T "~T.stringof~"s;");
    };
};

```


## Criticisms of Alternatives

#### Mix Files

Given mixin and string imports, you can mixin a block of code while maintaining a copy of the string to parse out symbols. Mimicking C style imports and allows any introspection imaginable.

Such code is often described as "clever but ugly", fragile, and this 3rd party parsing limits D's syntax to what the library writer cares to support. It's possible but generally violates style guides.

#### `__MODULE__` and restrict to global scope

```d
template foo(string where:__MODULE__){

}//todo
```

This requires knowledge of special tokens, recursive templates to filter the list, and `__traits`. To produce a non-flexible solution that asks the user to pollute their global namespace.

#### Additional `__traits` and a `__LOCAL_SCOPE__`

```d
void main(){
    int foo;
    int bar;
    static foreach(A;__traits(getFunctions,__LOCAL_SCOPE__)){
        //some mixin
    }
}
```

It's unclear if the static foreach would be processed or not, and neither case is it ideal.

In the event the products of the mixin are included, the user will need to filter out their mixins so they don't cause an infinite loop.

In the event the products of the mixin are excluded, your defining `__LOCAL_SCOPE__` to be a snapshot in time that may be mutating under the user, same as `__LOCAL_VARS__`, with the additional complexity of wondering which `__traits` are lazy or greedy.


## Breaking Changes and Deprecations

User code with `__LOCAL_VARS__` will need to pick a new name.  

## Reference
Optional links to reference material such as existing discussions, research papers
or any other supplementary materials.

## Copyright & License
Copyright (c) 2020 by the D Language Foundation

Licensed under [Creative Commons Zero 1.0](https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt)

## Reviews
The DIP Manager will supplement this section with a summary of each review stage
of the DIP process beyond the Draft Review.
