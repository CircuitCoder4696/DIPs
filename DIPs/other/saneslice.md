# Un-discourage/un-deprecate the sane opSlice

| Field           | Value                                                           |
|-----------------|-----------------------------------------------------------------|
| DIP:            | (number/id -- assigned by DIP Manager)                          |
| Review Count:   | 0 (edited by DIP Manager)                                       |
| Author:         |monkyyy(crazymonkyy / monkyyy.science)|
| Implementation: | already works|
| Status:         | Will be set by the DIP manager (e.g. "Approved" or "Rejected")  |

## Abstract

The current status of the d1 opSlice overload is unclear, dispite being the most concise and staightforward usefor none multidementional slicing.


## Contents
* [Rationale](#rationale)
* [Prior Work](#prior-work)
* [Description](#description)
* [Breaking Changes and Deprecations](#breaking-changes-and-deprecations)
* [Reference](#reference)
* [Copyright & License](#copyright--license)
* [Reviews](#reviews)

## Rationale

The status of using this feature is confusing, and I like it consideraly better then the 2 step proccess designed for signifigently more complex and rare situations.

## Prior Work

Already exists in d.

## Description
```d
struct foo{
	void opSlice(int i,int j){
		i.writeln;
		j.writeln;
	}
}
unittest{
	foo bar;
	bar[1..2];//calls opSlice
}
```
taken litterly, the d2 operator documentation sugests this is "discouraged"(does that mean depercated?), dispite being so simple. Futhermore the d1 documentation on the issue, is short and sweet, unlike the d2 ones on the matter.

## Breaking Changes and Deprecations

None.

## Reference

https://digitalmars.com/d/1.0/operatoroverloading.html

## Copyright & License
Copyright (c) 2020 by the D Language Foundation

Licensed under [Creative Commons Zero 1.0](https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt)

## Reviews
The DIP Manager will supplement this section with a summary of each review stage
of the DIP process beyond the Draft Review.
