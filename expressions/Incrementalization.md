# Model-based Incrementalization

NMF provides elementary change notifications, offered
through the industry standard interfaces INotifyPropertyChanged and INotifyCollectionChanged. These interfaces are required by many modern user interface
libraries, hence the model representation code can directly be used for these
techniques.

However, NMF is also able to combine these elementary change notifications
to determine when the result of analyses based on a model has changed. Furthermore, an incremental algorithm is inferred to recalculate the analysis upon
a model change more efficiently by the implicit introduction and management
of buffers to save intermediate results. This incrementalization works online, i.e.
the model needs to be kept in memory and changes must be made on the model
elements in memory

The incrementalization has a sound theoretical foundation based on category
theory and is implemented in NMF Expressions. NMF Expressions operates
on lambda expressions, supported by many .NET languages such as C# and
VB.NET in their regular syntax. To realize the incrementalization, the abstract
syntax tree is converted into a dynamic dependency graph on a high abstraction
level. Changes of the model under analysis are then propagated through the
dependency graph, ultimately updating the analysis result.

var faultyPositions = from route in routes
        where route.Entry != null && route.Entry.Signal == Signal.GO
3 from swP in route.Follows
4 where swP.Switch.CurrentPosition != swP.Position
5 select swP;

As an example, consider the code in Listing 1, taken from the NMF solution
of the TTC Train Benchmark [ 3]. NMF allows the user to specify queries like
this in regular C# code with all of the tool support provided for this language
and is able to implicitly deduct an incremental evaluation.

The high abstraction level in the dynamic dependency graph is achieved by a
manual incrementalization of analysis operators yielding valid results as a consequence of the underlying formalization as a categorial functor. NMF Expressions
includes a library of such manually incrementalized operators, including most of
the Standard Query Operators (SQO)4. As a consequence, developers can specify query analyses conveniently through the query syntax such as used in Listing
1.