# NMF Collections

The goal of NMF Collections is to provide a library of collection classes that are missing in the .NET framework base class library. These classes are:

* In the namespace **NMF.Collections.Generic**
	* **DecoratedSet**: A decorator implementation around the _HashSet<T>_ from the BCL
	* **OrderedSet**: An implementation of an ordered set, i.e. the collections keeps track of the order in which items are added to the collection but acts as a set (no duplicate entries, fast Contains operation)
	* **ReadOnlyListSelection**: This class provides a readonly _IList<T>_ implementation given a list of items and a selector. Basically, this class can be used to maintain the _IList<T>_ interface when using the _Select_ Query operator.
	* **ReadOnlyOrderedSet**: A read-only wrapper for ordered sets
* In the namespace **NMF.Collections.ObjectModel**
	* **ObservableList**: A thin layer upon _ObservableCollection<T>_ (which in fact is a list) implementing _INotifyCollection_ from the [Expressions](../expressions/index.md) project
	* **ObservableOrderedSet**: An observable implementation of an ordered set
	* **ObservableReadOnlyOrderedSet**: A read-only wrapper for observable ordered sets
	* **ObservableSet**: An implementation for observable hash sets
	* Opposite collections **OppositeList**, **OppositeSet** and **OppositeOrderedSet**
	* Observable variants of the opposite lists

Opposite collections are collections that allow to easily set an indicator if an element is added to or removed from the collection.

All collections implement the _ICollection_ interface. Lists and ordered sets implement the _IList_ interface. Ordered sets and sets implement the _ISet_ interface. Additionally, all collections also implement the _INotifyCollection_ interface from the [Expressions](http://nmfexpressions.codeplex.com) project.