# NMF Synchronizations

Based on [NTL](../transformations/index.md) and [NMF Expressions](../expressions/index.md), NMF also contains a language to synchronize models of heterogeneous metamodels, named **NMF Synchronizations**. Like NTL, it is also implemented as an internal DSL so that developers can
familiarize quickly. This synchronization language is able to support 18 different operation modes out of a single specification: One may choose between three different [change propagation modes](ChangePropagationMode.md) (none, one-way and two-way) and six different
[directions](SynchronizationDirection.md) (left-to-right and right-to-left in three different variants each).

Similar to NTL, a synchronization rule in NMF Synchronizations is represented by a class, inferring the synchronization rules by the public nested classes.
The synchronization rules each define an isomorphism between the classes they
are to synchronize, referred to as left-hand-side (LHS) and right-hand-side (RHS)
class. These classes are passed as generic type parameters.
