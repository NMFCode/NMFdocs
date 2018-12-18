# NMF Utilities

NMF Utilities is a very small library that provides some cross-cutting functionality in the form of extension methods. These extension methods include:

* Overloads for _Except_ and _Concat_ that accept a single concatenation or exception element
* Set operators like _SetEquals_ defined on _IEnumerable_ instead of _ISet_
* Functionality to obtain a Pascal cased or Camel cased version of a string
* Operators to compute the transitive-reflexive closure

To use this functionality, one simply has to add a reference to **NMF.Utilities.dll** and add a namespace import (using) statement to _NMF.Utilities_. 