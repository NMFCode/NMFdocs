# .NET Modeling Framework (NMF)

The .Net Modeling Framework (NMF) is a framework to support model-driven engineering using .NET technologies. It consists of several subprojects that ease various model-driven tasks, such as generating code for model representation, or languages to support model transformation, synchronization and optimization.

[!Video https://www.youtube.com/watch?v=NIMYuwTltVs&feature=youtu.be]

## NuGet Packages

There are a range of NuGet-packages available that bundle some of the functionality of NMF. These packages are potentially more stable than the source code, but may not contain the latest features of NMF.
The packages are:
* NMF-Expressions [![Downloads](https://img.shields.io/nuget/dt/NMF-Expressions.svg)](https://www.nuget.org/packages/NMF-Expressions/): Contains the NMF library for incremental computation. This package has no other dependencies and can even be used independently of the modeling framework.
* NMF-Repository [![Downloads](https://img.shields.io/nuget/dt/NMF-Repository.svg)](https://www.nuget.org/packages/NMF-Repository/): Conatins the repository management of NMF (depends on NMF-Expressions)
* NMF-Basics [![Downloads](https://img.shields.io/nuget/dt/NMF-Basics.svg)](https://www.nuget.org/packages/NMF-Basics/): Contains the latter two plus a code generator to generate model representation code from any Ecore or NMeta metamodel. The code generator integrates with the Nuget Package Console.
* NMF-Expressions-Utilities [![Downloads](https://img.shields.io/nuget/dt/NMF-Expressions-Utilities.svg)](https://www.nuget.org/packages/NMF-Expressions-Utilities/): Contains some utility classes for NMF Expressions such as dictionary of incremental values
* NMF-Transformations [![Downloads](https://img.shields.io/nuget/dt/NMF-Transformations.svg)](https://www.nuget.org/packages/NMF-Transformations/): Contains the model transformation language NTL used in NMF
* NMF-Synchronizations [![Downloads](	https://img.shields.io/nuget/dt/NMF-Synchronizations.svg)](https://www.nuget.org/packages/NMF-Synchronizations/): Contains the incremental, uni- and bidirectional model transformation language NMF Synchronizations

## Tutorials

* [NMF Introductory video](https://www.youtube.com/watch?v=NIMYuwTltVs&feature=youtu.be)
* [NMF Transformations](transformations/TransformationTutorials.md)
* [NMF Synchronizations](synchronizations/SynchronizationTutorials.md)

Besides, there is a range of [solutions to various cases of the Transformation Tool Contest (TTC)](publications/ttc.md). They can serve to describe how to solve specific problems using NMF and each come with a GitHub repository that includes the code.
Further, the [journal publications](publications/article.md) contain rich documentation on select topics. Lastly, the [PhD thesis of Georg Hinkel](https://dx.doi.org/10.5445/IR/1000084464) is probably the richest documentation available.

## Detailed Project information

Detailed project information to the sub-projects of NMF can be found on the wiki pages to these projects:

* [Models](models/index.md)
* [Transformations](transformations/index.md)
* [Expressions](expressions/index.md)
* [Synchronizations](synchronizations/index.md)
* [Optimizations](optimizations/index.md)
* [Interop](interop/index.md)
* [Collections](collections/index.md)

## Publications

The publications about NMF are available on [a separate section](publications/index.md)

## Roadmap

At the moment, the lack of documentation is the biggest hurdle, so work in the near future will go either into resolving issues or adding documentation. Any help here is welcome! Further points of development will be a benchmark of the parallel change propagation and testing of dynamic deep modelling support.

NMF has been the PhD project of Georg Hinkel. Further development is done at the moment rather as kind of a hobby.

## Contribute

Developers are dear welcome to contribute to NMF in various ways. Please just write an Email to [Georg Hinkel](mailto:georg.hinkel@gmail.com).