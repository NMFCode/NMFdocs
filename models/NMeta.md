# NMeta

NMF contains its own meta-metamodel called NMeta. NMeta is similar to Ecore
but contains dedicated support for type system features widely used on the .NET
platform such as structures or events. Furthermore, it also supports an extension
mechanism closely related to stereotypes as well as refinements. The semantics
of NMeta is clearly defined through a mapping to category theory. Though there
is a high semantic overlap with the Essential Meta Object Facility (EMOF) standard, there are also some features that do not have a counterpart in NMeta, in
particular factories and generic types.

However, since Ecore is the meta-metamodel most often used in MDE, NMF
contains a model transformation from Ecore to NMeta. This transformation is
based on the extensible Model Transformation Language [NTL](../transformations/index.md) and thus support for other types can be easily extended.

The resulting NMeta metamodel is compliant with the original Ecore metamodel if the latter only contains basic structures (packages, classes, attributes
and references). Here, compliant means that serialized instances of the original
Ecore metamodel can be deserialized with the NMeta metamodel (if no custom
XMI handlers are used) and vive versa. In particular, the XMI serialization of
the metamodels is equivalent and the NMF serializer uses the same addressing
scheme for cross references as the EMF serializer uses for Ecore.

Similar to Ecore, NMeta is bootstrapped and the classes ModelElement and
Model are the only ones with a custom implementation, the implementation of
all other classes originate directly from the code generator.

The most distinguishing features of NMeta are:
* Builtin addressing scheme (every model element has an absolute and a relative Uri)
* Metamodel extensions through the _Extension_ metaclass and the reference to model element extensions
* Explicit modeling of events
* Deep modeling (classes can instantiate other classes)

To get more details, the following wiki pages contain more details:
* [ModelElement](ModelElement.md)
* [MetaElement](MetaElement.md)

More documentation, including especially how metamodels are generated to code will be coming soon.