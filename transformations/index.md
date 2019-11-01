# NMF Transformations

To support model transformation, NMF contains the **NMF Transformations Language (NTL)**, an internal model transformation language integrated in C#,
reusing the tool support for C#. This transformation language allows to
specify extensible rule-based model transformations with explicit dependencies
between the transformation rules. The underlying transformation engine is not
restricted to NMeta models as input or output models such that also arbitrary
CLR objects can be transformed where the CLR denotes the .NET virtual machine, similar to the JVM in Java.

Model transformations in NTL are essentially classes whose transformation
rules are inferred by the public nested classes. These are encoded also as separate classes that inherit from a set of generic base classes and the generic type
parameters specify the source and target model elements. These transformation
rule classes may override a method to define their dependencies. Inside this
method, transformation rules may define dependencies to other transformation
rules, their instantiation or patterns that declaratively specify when the transformation rule should be called. Other than that, the transformation rules may
override a method that is called to initialize the transformation rule result. Similar to ATL, NTL also allows transformations to be based on other transformation
rules overriding some of their transformation rules. This technique is called superimposition in ATL, in NTL it is called transformation rule inheritance as
it is realized in inheriting the transformation rule classes.

NMF Transformations consists of [NMF Transformations Core](NMF-Transformations-Core.md) and [NMF Transformations Language](NMF-Transformations-Language.md). [NMF Transformations Core](NMF-Transformations-Core.md) is a framework for model transformations whereas [NMF Transformations Language](NMF-Transformations-Language.md) is an internal DSL built on top of this framework to provide a type-safe access through C#.

## Getting Started

Technically, NMF Transformations is a set of assemblies, **NMF.Transformations.dll** and **NMF.Transformations.Core.dll**. The easiest way to get these libraries is by downloading the corresponding [NuGet Package](https://www.nuget.org/packages?q=nmf). So in Visual Studio, simply type into the NuGet package console

>
```powershell
PM> Install-Package NMF-Transformations
```

Having installed NMF Transformations, you might want to see the [tutorials](TransformationTutorials.md). Alternatively, you can take a more top-down approach and start by reading the documentation for the core transformation framework [NMF Transformations Core](NMF-Transformations-Core.md).

Currently, the documentation is just built up, so if you are missing something, it is likely to appear in the near future. Further documentation can be found in the master thesis, where NMF Transformations was first presented [(pdf, 2.81MB)](http://sdqweb.ipd.kit.edu/publications/pdfs/hinkel2013a.pdf). Alternatively, you can always send an email to [Georg Hinkel](mailto:georg.hinkel@gmail.com) for any enquiries regarding NMF.
