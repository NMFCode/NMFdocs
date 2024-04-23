# NMF Transformations Language (NTL)

NTL is an internal DSL for C# to provide an easier access to the framework provided by [NMF Transformations Core](NMF-Transformations-Core.md). Although the code is CLS-compliant and thus could be used in any .NET language, it is specifically designed for a usage in C#. It has not been tested yet for a usage with F#.

In NTL, model transformations are created through the declaration of a class inheriting _ReflectiveTransformation_. What _ReflectiveTransformation_ does is to infer the transformation rules of this model transformation by reflecting its public nested classes. Any non-abstract nested class that eventually inherits from _GeneralTransformationRule_ from the Core library is assumed to be a transformation rule.

Furthermore, NTL provides more sophisticated transformation rule types to provide convenient methods to specify dependencies in a type-safe manner.
