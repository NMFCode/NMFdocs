# Model Repositories

In NMeta, all model elements have both an absolute and a relative URI that allow
developers to easily reference model elements in a defined way. The addressing
scheme is based on the containment hierarchy where the elements are identified
by their identifier or by the collection index. The syntax is the same as used in
the EMF serializer to push interoperability to EMF.

NMF is able to resolve URIs from different sources, including files, embedded resources and network streams. To resolve a model, NMF uses a singleton
meta repository (which itself is a model repository) where all metamodels are
loaded and linked to the implementation, if available. The registration of model
representation code is done simply through an assembly annotation that links a
namespace to an assembly embedded resource where the metamodel is formally
described. Here, assemblies are the components of the .NET component model.
When the meta-repository is loaded for the first time, it iterates through the
loaded assemblies and finds all metamodels registered, so that a repository is
able to load a model just in case the assembly containing the model representation classes is referenced.

## URIs for model elements

The absolute URIs of model elements are constructed at runtime using the containment hierarchy of a model element or a global identifier, if applicable.

In particular, the relative URI of a model element is constructed as follows:

1. If the model element has a global identifier, the relative URI is simply the global identifier.
2. If the model element has a local identifier, the relative URI is the relative URI of its parent model element plus the local identifier. The local identifier may be prepended with a # symbol.
3. If the model element is a single-valued or ordered collection-valued container reference, the relative URI is the relative URI of its parent model element plus a segment started with @, followed by the container reference name, a . symbol and the index of the model element in the container collection (if the model element appears in a collection, otherwise the . and the index are omitted).
4. Any other case (like the parent model element not being set or the container reference being an unordered collection) will lead to a null value for the relative URI.

The relative URI is always meant as relative to the root model element in the resource that the model element is contained in. It always is a fragment (starting with a # symbol). The absolute URI is the URI of the containing model plus the relative URI.