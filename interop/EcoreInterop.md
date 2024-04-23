# NMF EcoreInterop
NMF EcoreInterop is a subproject that supports the interopability with Ecore from [EMF](http://www.eclipse.org/modeling/emf/). As such, it contains [NMeta](../models/NMeta.md) specified in Ecore, Ecore specified in NMeta, an Ecore model generated from the latter model and a transformation to transform Ecore (meta-)models into NMeta. The other direction is not as easy, as NMeta is semantically richer than Ecore.

## Ecore2Code

The latter transformation is used in a small command line tool, [Ecore2Code](../models/Ecore2Code.md), that generates model representation code for Ecore metamodels. This is done by transforming the Ecore metamodel into NMeta, transforming the NMeta model into _System.CodeDOM_ and generate code for this model in multiple languages. The supported languages are C#, VB.NET, C++/CLI, F# and JavaScript.NET.