# More relatives: Adding aunts and uncles

**This tutorial assumes that you have already finished the [Persons to FamilyRelations](Persons2FamilyRelations.md) tutorial. If not, you may do so now as this tutorial depends on the first.**

Consider that the _FamilyRelations_ metamodel also had a reference to uncles and aunts. While this information is completely redundant, it is also slightly difficult to obtain from the Persons metamodel and could be saved in a reference of each person object.

If one already has the information of the FamilyRelations model, the information is very easy to obtain, as aunts are simply the sisters of either mother or father and uncles likewise their brothers. Thus, such a reference is a good candidate for a post-processing step. However, it might be necessary to include this in the model transformation, e.g. in order to keep the code closely together or because other rules rely on these references.

Thus, this tutorial is mainly about how transformation rules can be delayed.

## SetRelatives: An in-place transformation rule

Unlike the [Persons to FamilyRelations](Persons2FamilyRelations.md) tutorial, we don't need to transform model elements. We just need code to be executed. Transformations like this are called **in-place transformations** and are thus represented in NTL by classes derived from **InPlaceTransformationRule**. To implement this scenario, just add the following transformation rule:

>
```csharp
public class SetRelatives : InPlaceTransformationRule<Fam.Person>
{
      public override void Transform(Fam.Person person, ITransformationContext context)
      {
          if (person.Father != null)
          {
              person.Uncles.AddRange(person.Father.Brothers);
              person.Aunts.AddRange(person.Father.Sisters);
          }
          if (person.Mother != null)
          {
              person.Uncles.AddRange(person.Mother.Brothers);
              person.Aunts.AddRange(person.Mother.Sisters);
          }
      }

      public override void RegisterDependencies()
      {
          TransformationDelayLevel = 1;
      }
}
```

The last line is the most important one here. Instead of specifying dependencies, we set the transformation delay of the transformation rule. This means, the _Transform_ method of _SetRelatives_ is one level delayed. That is, it will be executed only when all previous delay levels (namely only 0, the default delay level) is executed. Thus, we can be sure that the _Transform_ method of all applications of _Person2Person_ have already been called and thus, mothers, fathers, sisters and brothers are already initialized.

In-place transformation rules execute like normal transformation rules. Especially, they can specify dependencies and also may be instantiated. Thus, we could add new rules to set the relatives specifically for Female model elements, for instance.

## Output-sensitive dependencies

How do we make sure that our new rule _SetRelatives_ is called for each Person model element? In usual dependencies, we may only specify selectors dependent on the input of transformation rules.

The answer is that there is a special kind of dependencies for such purposes, called **output-sensitive dependencies**. To specify such a dependency, add the following line to the _RegisterDependencies_ method of _Person2Person_:

>
```csharp
CallOutputSensitive(Rule<SetRelatives>(), (ps, fam) => fam);
```

Since this is an output-sensitive dependency, we are allowed to have a selector with two parameters. The first one specifies the input (here, a Person of the _Persons_ metamodel), the second one is the output of the current rule (in this case the Person model element of the _FamilyRelations_ metamodel).
