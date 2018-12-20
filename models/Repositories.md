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