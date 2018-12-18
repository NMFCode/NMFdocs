# NMF Transformations

NMF Transformations consists of [NMF Transformations Core](NMF-Transformations-Core)(NMF-Transformations-Core) and [NMF Transformations Language](NMF-Transformations-Language)(NMF-Transformations-Language). [NMF Transformations Core](NMF-Transformations-Core)(NMF-Transformations-Core) is a framework for model transformations whereas [NMF Transformations Language](NMF-Transformations-Language)(NMF-Transformations-Language) is an internal DSL built on top of this framework to provide a type-safe access through C#.

## Getting Started

Technically, NMF Transformations is a set of assemblies, **NMF.Transformations.dll** and **NMF.Transformations.Core.dll**. The easiest way to get these libraries is by downloading the corresponding [NuGet Package](https://www.nuget.org/packages?q=nmf). So in Visual Studio, simply type into the NuGet package console

{code:c#}
PM> Install-Package NMFTransformations
{code:c#}

Having installed NMF Transformations, you might want to see the [tutorials](TransformationTutorials). Alternatively, you can take a more top-down approach and start by reading the documentation for the core transformation framework [NMF Transformations Core](NMF-Transformations-Core).

Currently, the documentation is just built up, so if you are missing something, it is likely to appear in the near future. Further documentation can be found in the master thesis, where NMF Transformations was first presented [(pdf, 2.81MB)](http://sdqweb.ipd.kit.edu/publications/pdfs/hinkel2013a.pdf). Alternatively, you can always send an email to [Georg Hinkel](mailto:georg.hinkel@kit.edu) for any enquiries regarding NMF.

## Roadmap

NMF Transformations is actually quite stable. Current work merely focusses on the parallel execution of model transformations created with NMF Transformations. Responsible for this is the project **Transformations.Parallel.dll**. However, this work is still in progress.