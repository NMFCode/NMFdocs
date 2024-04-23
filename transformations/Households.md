# Using NTL Relational: Households

**This tutorial is based on the [Persons to FamilyRelations](Persons2FamilyRelations.md) tutorial. You may want to visit that one first, if you have not already done so.**

In some cases it is necessary to transform elements based on rather complex patterns. NTL supports such patterns, where you can specify patterns using LINQ through the language extension NTL Relational.

In the scenario of Persons and FamilyRelations, suppose you want to find households. A household may be represented by a person of at leats 18 years plus his spouse, if any. To find these households, we match males and females and check whether they are spouses. Note that this is a very inefficient solution, but in practice, it happens from time to time that one needs to create matches and this is only a tutorial.

To implement this with NTL Relations, add the following code:

>
```csharp
public class Households : TransformationRule<Ps.Person, Ps.Person, Households>
{
      public override void RegisterDependencies()
      {
          var possibleMoms = Rule<Person2Female>().ToComputationSource(
              allowNull: true,
              filter: c => c.Input.Age >= 18);
          var possibleDads = Rule<Person2Male>().ToComputationSource(
              allowNull: true,
              filter: c => c.Input.Age >= 18);

          WithPattern(from mom in possibleMoms
                      from dad in possibleDads
                      where mom.Input.Spouse == dad.Input
                      select Tuple.Create(mom.Input, dad.Input));
      }
}
```

The advantage here is that we can call _Person2Person_ for another model element in _Households_ and the LINQ statement recognizes this as well considers it for the further matching.

However, NTL Relations does not employ any query optimization technique, such as understanding that any _Female_ model element can be part of at most one pair. What NTL does is really match all combinations of the specified sets (all computations of _Person2Female_ where the age of the input Person object is at least 18, or null, and the _Male_ elements respectively) and tries to match them.