# ModelElement

ModelElement is the absolute base class of every model element in NMF. In NMeta, this is reflected by the ModelElement metaclass instantiating the metaclass Class. Thus, every instance of a Class is a ModelElement. Consequently, the **class** ModelElement (located in the namespace NMF.Models) serves as the base class for every generated code for any metamodel. 

ModelElement provides some addressing features like an absolute Uri and a relative Uri. Thus, it is possible to refer to any model element explicitly. If a model element is contained in a persistent model (i.e. a model saved somewhere e.g. on the hard disk), the model element is addressable through a Uri. For more details on the model element addressing, please check out the [Addressing model elements](Addressing-model-elements) wiki page.

Furthermore, every model elements have a reference to extensions, as _ModelElement_ has a composite reference to _ModelElementExtension_, which instantiates _Extension_. This extension mechanism can be used to extend metamodels already in use. See [Extending metamodels](Extending-metamodels) for details.