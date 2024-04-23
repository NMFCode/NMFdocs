# NMF Expressions

NMF Expressions is a framework for incremental expression evaluation. Instead of executing a function, it returns an observable value, basically an object that throws an event whenever the result of that function changes. Observable Expressions are based on Linq Expressions and are thus only supported for single-line lambda expressions that do not have side-effects.

>
```csharp
var test = Observable.Expression(() => person.Addresses.Count > 0 ? person.Addresses[0](0).Street : "(No address provided)");

test.ValueChanged += SomeEventHandler;

// will cause the ValueChanged event to be fired
person.Address.Add(new Address() {...});
```

NMF Expressions is particularly good at letting you customize the incrementalization and provide custom incrementalizations for commonly used functions.

# NMF Expressions Linq

NMF Expressions Linq is a new Linq implementation that results in an enumerable that provides an event to notify clients whenever the results of the Linq query change. Besides index-based operations (overloads of e.g. Select and Where that take an index parameter as well as Take, Skip), almost the entire Standard Query Operations Library is implemented. The exceptions to this include GroupJoin, some overloads of GroupBy, Single and Last. FirstOrDefault is implemented. Aggregators do not throw exceptions if collections are emty as collections are allowed to be emptied during status updates. This may happen for example as part of a reset of a child collection for e,g. Concat.

NMF Expressions Linq is based on a newly introduced monad INotifyEnumerable that is joint of IEnumerable and INotifyCollectionChanged that further knows the parameterless methods Attach() and Detach() to attach or detach from or to an object model. If attached, the implementations will collect any changes tracable by INotifyCollectionChanged, INotifyPropertyChanged or custom proxies. In order to not interfere with the Linq implementation from the System.Linq namespace, NMF Expressions Linq does include a unit function called WithUpdates that generates an adapter to INotifyEnumerable. When using this adapter, the compiler will automatically choose a different set of extension methods enabling the query syntax, so you can write code as intuitive as this:

>
```csharp
var violations = from employee in employees.WithUpdates()
                             where employee.WorkItems > 2 *
                                (from collegue in employees
                                 where collegue.Team == employee.Team
                                 select collegue.WorkItems).Average()
                             select employee.Name;

violations.CollectionChanged += ViolationsChanged;

employees.Add(name: "John", workItems: 20, team: "A");
employees.Add(name: "Susan", workItems: 5, team: "A");
// this will cause an event saying that John now has too many work items assigned to him
employees.Add(name: "Joe", workItems: 3, team: "A");
```

All you have to do for this magic to work is really just including a new using statements to import NMF.Expressions.Linq and of course download and add a package reference to NMF-Expressions.