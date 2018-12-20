# Transformations
So far, NMF only consists only of a M2M-Transformation framework (NMF.Transformations) that transforms any CLR object structure into another. The transformation engine does not rely on any Attributes, so it can also transform arbitrary CLR-Objects. To transform instancies, it uses a QVT-like syntax. The main benefit of NMF.Transformations compared to handwritten transformations are:

* NMF.Transformations provides a trace model. Transformation rules can easily rely on other transformation rules output.
* NMF.Transformations supports dependencies in both directions. Transformation rules can require other transformation rules to be executed before them or they can force them to be executed afterwards.
* NMF.Transformations supports something that is currently called a calling dependency. A transformation rule can specify that is to be executed, as soon as a certain parent object is transformed.