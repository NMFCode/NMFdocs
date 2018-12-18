# Finite States to Petri Nets with NTL

This tutorial shows how to transform [finite state machines to Petri Nets](FiniteStateMachines2PetriNets) using NTL.

## Setting up the environment

Create a new project in your IDE. Download the [metamodels (zip, 804 Bytes)](FSM2PNTransformation_metamodels.zip) and add the two files contained in there to your project. They contain very simple implementations of the finite state machine and Petri Net metamodels. 

**Note:** See that both of these metamodels do not hold any reference to NMF. In fact, their implementation is super-straight-forward. The implementation of the models is also not reflected, so you can use arbitrary CLR objects within NMF Transformations. 

## Adding a reference to NMF Transformations
We will need to add a reference to NMF Transformations in order to use it. Thus, add a reference to the assemblies **NMF.Transformations.Core.dll** (this is [NMF Transformations Core](NMF-Transformations-Core)) and **NMF.Transformations.dll** (the [NMF Transformations Language](NMF-Transformations-Language)).

## Create a transformation file
Create a new file and name **FSM2PN.cs** (or any other name if you wish). Inside the file, we will work with NTL. Thus, add the following using statements on top of the transformation file:

{code:c#}
using NMF.Transformations;
using NMF.Transformations.Core;
{code:c#}

## Create a new transformation class
Our transformation will use the default behavior and simply inherit from **ReflectiveTransformation**. As a consequence, NTL will infere the rules of our transformation by the public nested classes. So, add the following class:

{code:c#}
public class FSM2PN : ReflectiveTransformation
{
}
{code:c#}

Of course, you can embrace the transformation class in a namespace as you wish. It is also perfectly legal to make the transformation class itself internal.

## Transforming Finite State Machines to Petri Nets
We start by adding a rule to transform finite state machines to Petri Nets. Add the following code as nested class inside the previous _FSM2PN_ class:

{code:c#}
        public class AutomataToNet : TransformationRule<FSM.FiniteStateMachine, PN.PetriNet>
        {
            public override void Transform(FSM.FiniteStateMachine input, PN.PetriNet output, ITransformationContext context)
            {
                output.ID = input.ID;
            }
        }
{code:c#}

This tells NTL how to transform finite state machines to Petri Nets. By inheriting from **TransformationRule**, we tell NTL that this class is a transformation rule and what this rule takes as input and output. In the **Transform** method, we specify what shall be done, if a state machine is transformed to a Petri Net. Here, we only copy the ID. However, this is not really suprising and would be better done without NTL, so far. Thus, we go ahead and add rules to transform places and transitions.

## Transforming states
To transform states to places, just add the following lines of code as another nested class of **FSM2PN**:

{code:c#}
        public class StateToPlace : TransformationRule<FSM.State, PN.Place>
        {
            public override void Transform(FSM.State input, PN.Place output, ITransformationContext context)
            {
                output.ID = input.Name;

                if (input.IsStartState)
                {
                    output.TokenCount = 1;
                }
                else
                {
                    output.TokenCount = 0;
                }
            }
        }
{code:c#}

In the **Transform** method, we again just copy the very simplest data from the finite state machine to the Petri Net.

## Adding dependencies

However, if we called our new transformation to transform a finite state machine to a Petri Net, NTL would not know when to use the new rule _State2Place_. Thus, we need to add a dependency. We can do so on two spots: Either in _Automata2Net_ to specify what other rules should be called (forward dependency) or in _State2Place_ to specify when it will be called (reversed dependency). In this tutorial, we will use a reversed dependency. In that way, the code belonging to the transformation of states is all stored in _State2Place_. Dependencies are generally specified in the **RegisterDependencies** method. Thus, add the following method in the _State2Place_ rule:

{code:c#}
            public override void RegisterDependencies()
            {
                CallForEach(Rule<AutomataToNet>(),
                    selector: fsm => fsm.States,
                    persistor: (pn, places) => pn.Places.AddRange(places));
            }
{code:c#}

The method Rule<> simply gets the instance of the rule with the specified rule type. As a consequence, the compiler is aware of the input type and can provide IntelliSense support for specifying the lambda predicates.

As you can see, dependencies can have a row of lambda expressions, specifying their behavior. The names are according to their functionality. If a finite state machine is transformed into a Petri Net using _Automata2Net_, then the selector specifies which states the current rule (_State2Place_) should be called. If all states of the finite state machine are transformed, the persistor specifies how the transformed elements should be persisted. Here, we just add the places to the places collection of the Petri Net.

## Transforming Transitions

Now, we have transformed the places of our state machine. However, we still need to transform the transitions. Thus, add the following code as a new nested class of _FSM2PN_:

{code:c#}
        public class TransitionToTransition : TransformationRule<FSM.Transition, PN.Transition>
        {
            public override void Transform(FSM.Transition input, PN.Transition output, ITransformationContext context)
            {
                output.Input = input.Input;
            }

            public override void RegisterDependencies()
            {
                CallForEach(Rule<AutomataToNet>(),
                    (fsm => fsm.Transitions,
                    (pn, transitions) => pn.Transitions.AddRange(transitions));
            }
        }
{code:c#}
Again, we have a rule how transistions are transformed to transitions of the Petri Net. We copy the inputs and create a reversed dependency to let NTL know which transitions to transform and add the transformed transitions to the Transitions collection of the Petri Net. 

What is left is to fill the transitions start and end places. So if a state machine transition has had a start state, we want the Petri Net transition to have exactly the output of the _State2Place_ added to the From collection. The same holds for the target state and the To collection.

To do this, just add the following code next to the existing reversed dependency in _Transition2Transition_:

{code:c#}
                Require(Rule<StateToPlace>(),
                    t => t.StartState, (t, p) =>
                    {
                        t.From.Add(p);
                        p.Outgoing.Add(t);
                    });

                Require(Rule<StateToPlace>(),
                    t => t.EndState, (t, p) =>
                    {
                        t.To.Add(p);
                        p.Incoming.Add(t);
                    });
{code:c#}

This will do. We specify that _Transition2Transition_ needs the start state eventually transformed to a place (using _State2Place_). We already triggered this transformation elsewhere, thus the states are already transformed and NTL just takes the already transformed places.

**Note:** We assume here that the model representation has no direct support for opposite references. We made this assumption for brevity of the example. In reality, the To reference of transitions and the Incoming reference would better be true opposite references and thus, only one of the two statements in the dependencies would be required.

## End states

Finally, we still need to transform the information that some states are end states. Thus, we add a new transformation rule that transforms end states to transitions.

{code:c#}
        public class EndStateToTransition : TransformationRule<FSM.State, PN.Transition>
        {
            public override void Transform(FSM.State input, PN.Transition output, ITransformationContext context)
            {
                output.Input = "";
            }

            public override void RegisterDependencies()
            {
                CallForEach(Rule<AutomataToNet>(),
                    selector: fsm => fsm.States.Where(s => s.IsEndState),
                    persistor: (pn, endTransitions) => pn.Transitions.AddRange(endTransitions));
            }
        }
{code:c#}

Now, the created transition currently is not starting from the place corresponding to our end state. We could of course solve this problem by adding a new dependency (if you want to practice, just try that!). However, in some cases, these persistors eventually get very complex.

For such circumstances, NTL provides a trace. The trace allows to look up the corresponding model elements for certain elements directly. The trace is exposed through the **Trace** property of the transformation context that comes as argument to the **Transform** method. Thus, in the **Transform** method of the _EndState2Transition_ rule, add the following lines:

{code:c#}
                var from = context.Trace.ResolveIn(Rule<StateToPlace>(), input);
                output.From.Add(from);
                from.Outgoing.Add(output);
{code:c#}

## Triggering the transformation

We are done with our transformation, so let's try it out! The simplest way to do this is by using the **TransformationEngine** class. Anywhere in your client, just call add the following line:

{code:c#}
var pn = TransformationEngine.Transform<FSM.FiniteStateMachine, PN.PetriNet>(fsm, new FSM2PN());
{code:c#}

This tells NTL to call the transformation with the finite state machine of the variable _fsm_. In this example, we created a new transformation just for this call. If you want to make frequent calls to use the transformation, you can also reuse the transformation initialization by using the same transformation instance several times. Transformations are even thread-safe, once they are initialized, as the data of a transformation run is only saved in the transformation context.

So start create some finite state machines and see how they are transformed to Petri Nets!