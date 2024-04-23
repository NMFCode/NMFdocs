# Generating code with NTL

## Generating code using System.CodeDOM

NMF Transformations does not have any restrictions regarding the input or output models regarding conformance to a framework (such as [Models](../models/index.md)). Thus, it is a neat approach to reuse code models that are widely accepted, such as the code model of the **System.CodeDOM** namespace. The advantage of this code model is that there are plenty of code generators available that transform these models in a variety of languages. These languages include:

* C#
* VB.NET
* C++/CLI
* F#
* JavaScript.NET

Thus, it is not by chance that these languages are exactly the languages supported by [Ecore2Code](../models/Ecore2Code.md), the code generator for Ecore metamodels provided by [EcoreInterop](../interop/EcoreInterop/index.md). 

To specify such a code generator, one simply has to write a model transformation that transforms a model into a _System.CodeDOM_ model and then transform this model into code by using a suitable predefined code generator.

(An example is to follow)

## Roslyn

However, _System.CodeDOM_ has some strong limitations, as it supports neither lambda expressions nor operator overloading nor a biwise Xor operator. This is due to the fact that _System.CodeDom_ was initially created rather to represent the common concepts of multiple languages, only.

One way out of this dilemma is Roslyn, the brand new open compiler API from Microsoft. The code model used by Roslyn is specific to the used language, so all features of the language can be used. The model is also more fine-grained, so the code generation can be more precise.

However, the code model is also immutable, mainly for reasons of clean parallel programming. This makes the Roslyn model absolutely unsuitable for code generation. So, to use Roslyn and NTL, the very best idea is to wait for some mutable Roslyn wrapper.
