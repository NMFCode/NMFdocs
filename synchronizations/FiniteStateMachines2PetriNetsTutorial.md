# Synchronizing finite state machines with Petri Nets

**If you have not already done so, it might be a good idea to start by reading the scenario, [transforming finite state machines to Petri Nets](FiniteStateMachines2PetriNets.md).**

## Setting up the environment

Currently, there is no NuGet package for NMF Synchronization, as it is still in incubation. Thus, you will have to download the code through SVN and compile it to get the assemblies necessary for NMF Synchronizations.

If you have done so, create a new project and add the **NMF.Synchronizations.dll** as well as its dependencies. Furthermore, add the metamodels. These are different to [the NTL ones](~/transformations/FSM2PNTransformation.md), as the model representation needs to support the view model interfaces _INotifyPropertyChanged_ and _INotifyCollectionChanged_.

## Creating a new synchronization

Similar to NTL, synchronizations in NMF Synchronizations are represented as classes, derived from ReflectiveSynchronization. Thus, create a new class _FSM2PN_ and let it inherit from _ReflectiveSynchronization_.

Add the following using statements:


>
```csharp
using NMF.Expressions.Linq;
using NMF.Synchronizations;
using NMF.Transformations;
```

As indicated by the using statements, NMF Synchronization basically combines the two projects [Transformations](~/transformations/index.md) and [Expressions](~/expressions/index.md) to obtain a synchronization language. We will see how the benefits of both projects are used in NMF Synchronizations.

## Synchronizing machines

We start by defining a synchronization rule for the automata itself. Again, synchronization rules are represented by public nested classes. Thus, create a new nested class within _FSM2PN_ with the following code:


>
```csharp
        public class AutomataToNet : SynchronizationRule<FSM.FiniteStateMachine, PN.PetriNet>
        {
            public override bool ShouldCorrespond(FSM.FiniteStateMachine left, PN.PetriNet right, ISynchronizationContext context)
            {
                return true;
            }

            public override void DeclareSynchronization()
            {
                Synchronize(fsm => fsm.Id, pn => pn.Id);
            }
        }
```

The method **ShouldCorrespond** decides whether a correspondence link between the given finite state machine and the Petri Net should be established within the given synchronization context. The synchronization context is basically a transformation context with a [change propagation mode](ChangePropagationMode.md) and a [synchronization direction](SynchronizationDirection.md).

The **DeclareSynchronization** method specifies the body of the synchronization rule. In this case, the ids of the finite state machine and the Petri Net should be synchronized. Whether the id from the finite state machine is written to the Petri Net or vice versa, or how updates of either property are propagated is up to the synchronization engine and this is dependent on the mode, in which the synchronization is run.

## Synchronizing states and places

Next, we synchronize the states of the finite state machine with the places of the Petri Net. For this to work, add the following synchronization rule:


>
```csharp
        public class StateToPlace : SynchronizationRule<FSM.State, PN.Place>
        {
            public override bool ShouldCorrespond(FSM.State left, PN.Place right, ISynchronizationContext context)
            {
                return left.Name == right.Id;
            }

            public override void DeclareSynchronization()
            {
                Synchronize(state => state.Name, place => place.Id);
            }
        }
```

Thus, a state should correspond to a place if the name of the state matches the Id of the place. The synchronization then synchronizes these names. The latter is required to support change propagation.

Now that we have specified a synchronization rule how to synchronize states and places, we need to make sure that this rule is called appropriately. Thus, add the following line **into the DeclareSynchronization method of AutomataToNet**:


>
```csharp
SynchronizeMany(SyncRule<StateToPlace>(),
        fsm => fsm.States, pn => pn.Places);
```

This statement tells NMF Synchronization, that the states of a state machine should correspond to the places of a Petri Net through the synchronization rule _StateToPlace_. Depending on the change propagation mode, the synchronization engine will automatically react on new states in the States collection by adding a new place to the Petri Net (or vice versa).

The dependency also gives a hint to NMF Synchronizations where to look for candidates. The dependency is only executed when the correspondence of a state machine and a Petri Net is already clear. Then, each state in the States collection has to correspond to a Place in the Places collection. Thus, the synchronization engine will try to match the existing entries. However, this also means that the dependency limits the candidates for corresponding places for a state that is contained in the States collection of the state machine to the places contained in the Places collection, at least unless there is already a correspondence known.

Internally, NMF Synchronization creates two transformation rules, one for either main [synchronization direction](SynchronizationDirection.md). What _SynchronizeMany_ called with a synchronization rule does is basically to wire up transformation rules underneath and add dependencies. However, it is also possible to directly specify the dependencies of the underneath transformation rules directly, if you wish to add more complex synchronization topologies. If one has a synchronization rule object (like the _this_ pointer in within a _DeclareSynchronization_ method for instance), the transformation rules for the synchronization directions are stored in the properties _LeftToRight_ and _RightToLeft_.

**Note:** We rely on the _LeftToRight_ transformation rule here, independent of the synchronization direction the synchronization process is executed. This is possible because an established correspondence link between two model elements always results in trace entries for both directions, i.e. the synchronization direction does not matter for tracing purposes.

## Synchronizing Transitions

To synchronize the transitions, add the following code:


>
```csharp
        public class TransitionToTransition : SynchronizationRule<FSM.Transition, PN.Transition>
        {

            public override void DeclareSynchronization()
            {
                Synchronize(t => t.Input, t => t.Input);

                Synchronize(SyncRule<StateToPlace>(),
                    t => t.StartState,
                    t => t.From.FirstOrDefault());

                Synchronize(SyncRule<StateToPlace>(),
                    t => t.EndState,
                    t => t.To.FirstOrDefault());
            }

            public override bool ShouldCorrespond(FSM.Transition left, PN.Transition right, ISynchronizationContext context)
            {
                var stateToPlace = SyncRule<StateToPlace>().LeftToRight;
                return left.Input == right.Input
                    && right.From.Contains(context.Trace.ResolveIn(stateToPlace, left.StartState))
                    && right.To.Contains(context.Trace.ResolveIn(stateToPlace, left.EndState));
            }
        }
```

Now, the **DeclareSynchronization** method seems to be pretty much OK, since we have already seen such synchronization commands. But the synchronization of start and target states needs a bit more explanation. 

The direction from right to left is pretty much self-explanatory, we just take the first target place that is available assign the corresponding state to the target state of the corresponding transition.

The other way round is more complicated. What we are actually doing is to assign the corresponding place to the target state of the transition to - to the first or default of the target places? In fact, yes, we do. This is perfectly fine, because the extension method _FirstOrDefault_ has a decorator attribute that is used by [Expressions](~/expressions/index.md) to make the expression that we see a reversable expression. Thus, if FirstOrDefault is assigned a value, then the reverse expression makes sure that this element is in fact contained in the collection (if not, it is added). If the assigned value is the default value, then the collection is cleared.

The **ShouldCorrespond** basically states that we want to have a correspondence link between transitions, if and only if we already have a correspondence link between the source and target state (or place, respectively). For this, it uses the trace functionality of the synchronization context, querying the LeftToRight transformation rule of the _StateToPlace_ synchronization rule.

Next, we need to make sure that transitions are also synchronized. In the **Automata2Net**, please add the following line to **DeclareSynchronization**. The lines must be added **after** the synchronization call of _StateToPlace_. 


>
```csharp
SynchronizeMany(SyncRule<TransitionToTransition>(),
         fsm => fsm.Transitions, pn => pn.Transitions.Where(t => t.To.Count > 0));
```

The reason that this line must be added **after** the synchronization of _StateToPlace_ is that we do want to have synchronization links of states and places if we look for corresponding transitions. If we swap the order, the synchronization would not find correspondences and duplicate these elements to enforce correspondence.

## End states

Similar to the [transformation](~/transformations/FSM2PNTransformation.md) of finite state machines to Petri Nets, we use a synchronization rule to synchronize end states with swallowing transitions of the Petri Net. Thus, add the following rule to the synchronization specification:

>
```csharp
public class EndStateToTransition : SynchronizationRule<FSM.State, PN.Transition>
{
}
```

We begin with the specification when this new synchronization rule is going to called. Add the following line to the **DeclareSynchronization** method of the **AutomataToNet** rule:

>
```csharp
SynchronizeMany(SyncRule<EndStateToTransition>(),
       fsm => fsm.States.Where(state => state.IsEndState),
       pn => pn.Transitions.Where(t => t.To.Count == 0));
```

Thus, we only consider transitions of the Petri Net that have no target place. We can thus identify correspondence by the first and only source place of a transition. Thus, add the **ShouldCorrespond** method to **EndStateToTransition** as follows:

>
```csharp
    public override bool ShouldCorrespond(FSM.State left, PN.Transition right, ISynchronizationContext context)
   {
       return context.Trace.ResolveIn(SyncRule<StateToPlace>().LeftToRight, left) == right.From.FirstOrDefault();
   }
```

Because the synchronization context is basically just a transformation context, we can use its tracing component like we did when synchronizing transitions.

Thus, whenever there is an end state, we make sure that there is a corresponding transition. There condition inside the _Where_ clause states that this new transition has no target place. However, this condition is not enforced, because _Count_ is a read-only property and thus cannot be set to 0. We still need to add the corresponding place of our end state to the new transition.

Generally spoken, how is it possible to synchronize the value of an attribute (_IsEndState_) with the existence of a model element (the loose transition)? A helpful hint is the idea what should happen in each case. If a state was made an end state, it is automatically added to the collection of end states and thus, the dependency in _AutomataToNet_ causes a transition to be created that needs to start at the corresponding place. If an endstate is no longer marked as an endstate, the transition is removed from its container and cease to exist, is therefore deleted from the model. However, if we hide this implementation detail of the model representation for a moment, we would have to remove the transition from the outgoing transitions of our corresponding place. We can do this, by setting the _FirstOrDefault_ to null.

Thus, add the following **DeclareSynchronization** method to _EndStateToTransition_:


>
```csharp
public override void DeclareSynchronization()
{
   Synchronize(SyncRule<StateToPlace>(),
       state => state.IsEndState ? state : null,
       transition => transition.From.FirstOrDefault());
}
```

This will cause a runtime exception, if the synchronization is run from right to left. Why? Because the ternary operator in the left selector is not inversable. As a simple solution, we can restrict this synchronization job to left to right directions. Thus, change the method to the following:


>
```csharp
public override void DeclareSynchronization()
{
   SynchronizeLeftToRightOnly(SyncRule<StateToPlace>(),
       state => state.IsEndState ? state : null,
       transition => transition.From.FirstOrDefault());
}
```

However, what happens the other way around? In particular, how are the states right states found for transitions that have no target place? The dependency that we specified in _AutomataToNet_ for this purpose will try to find state candidates for the transition within the end states of the finite state machine. Currently, it is not possible to specify directly that the synchronization engine should look for candidate states in _all_ states of the state machine.

What we can do, however, and it's even more efficient, we can override the creation of correspondent lefts directly. There, we could use the trace to find out the place corresponding to the source place of the transition. This is more efficient, because the NMF Transformations trace has an average effort of O(1). Thus, add the following method to _EndStateToTransition_:


>
```csharp
protected override FSM.State CreateLeftOutput(PN.Transition transition, IEnumerable<FSM.State> candidates, ISynchronizationContext context)
{
    if (transition.From.Count == 0) throw new InvalidOperationException();
    return context.Trace.ResolveIn(SyncRule<StateToPlace>().RightToLeft, transition.From.FirstOrDefault());
}
```

## Limitations

The example of Petri Nets and state charts shows some limitations of NMF Synchronizations. The problem is exactly with the transitions. Once a correspondence is determined, it is currently fixed. This assumption is necessary for tracing purposes. In this scenario, it means that NMF Synchrionizations is unable to register that a transition can be used in multiple roles, either as a representation of finite state machine transitions or as a characterization of end states.

However, NMF Synchronizations is still in incubation, so this limitation might eventually cease.