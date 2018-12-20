# NMF Transformations Core

NMF Transformations Core is a model transformation framework for M2M-transformations. It provides a simple abstract syntax for model transformations. However, the metaclasses involved in the abstract syntax have function-typed attributes that allow easy integration of arbitrary code.

A transformation can consist of multiple transformation rules. Transformation rules describe that several input elements are transformed in an output element. Transformation rules have a signature that mark their input and output types.

Furthermore, they may have dependencies between each other. Dependencies specify that whenever a transformation rule is executed, also another transformation rule has to be executed, either before or after the current transformation rule.

Transformation rules can also instatiate each other. This means that a transformation rule can mark that it can create the output for another transformation rule under additional conditions.  This technique supports the transformation of inheritance hierarchies.
