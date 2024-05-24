## Tutorial
![EMF Diagrams](images/EMFDiagrams.png)

We generate the corresponding Ecore files from the two class diagrams shown above. One for the family model and one for the person model. 
We then generate the NMF models and classes, configure our .csproj file and load our models into the Program.cs file analogous to 
[Starting our first project](../models/FirstNmfProject.md)

The first step is to create a file in which we define the synchronization logic of the two models. We name this file `Families2PersonsSynchronization.cs`.

Let's think about what we need for our example. For this, let's look at the class diagram and draw the following conclusions. We need the FamilyRegister, the PersonRegister, and the Synchronization class where the synchronization logic between Family and Person is defined.
```csharp
class Program
    {
        private FamilyRegister familyRegister;
        private PersonRegister personRegister;

        private ModelRepository repository = new ModelRepository();

        private Families2PersonsSynchronization synchronization = new Families2PersonsSynchronization();

        static void Main(string[] args)
        {
        }
    }
```

Next, we need to consider how the initialization should look. In our example, this will take place in the class constructor.

```csharp
public Program()
        {
            var familyRootModel = new Model();
            var personRootModel = new Model();

            familyRegister = new FamilyRegister();
            personRegister = new PersonRegister();

            synchronization.Synchronize(
                synchronization.SynchronizationRule<Families2PersonsSynchronization.FamilyRegisterToPersonRegister>(),
                ref familyRegister, // Familyregister is the left model
                ref personRegister, // Personregister is the right model
                SynchronizationDirection.LeftWins, // prioritizes the left synchronization of left model (without shouldCorrespond it has no impact)
                ChangePropagationMode.TwoWay); // TwoWay means Bidirectional synchronization 

            familyRootModel.RootElements.Add(familyRegister);
            personRootModel.RootElements.Add(personRegister);

            repository.Models.Add(new Uri("ttc:source"), familyRootModel);
            repository.Models.Add(new Uri("ttc:target"), personRootModel);
        }
```

Here, we are creating two instances of the [Model](../models/api/NMF.Models.Model.yml) class. These instances, `familyRootModel` and `personRootModel`, are initially empty. In our case, these models represent the root nodes in a tree-like structure.

We then create instances of `FamilyRegister` and `PersonRegister`. These registers are child nodes of the models, and they manage specific types of data, in our case Familymembers and Persons:
- `FamilyRegister`: As the name suggests, this register manages families. A family, in this context, consists of a parent couple (mother and father) and can have children.
- `PersonRegister`: This register manages individual persons. These persons form the foundation for families, as each family is composed of individuals.


```csharp
synchronization.Synchronize(
                synchronization.SynchronizationRule<Families2PersonsSynchronization.FamilyRegisterToPersonRegister>(), // synchronization block/rule
                ref familyRegister, // Familyregister is the left model
                ref personRegister, // Personregister is the right model
                SynchronizationDirection.LeftWins, // prioritizes the left synchronization of left model (without shouldCorrespond it has no impact)
                ChangePropagationMode.TwoWay); // TwoWay means Bidirectional synchronization
```                
Synchronization Method Call:
    The `Synchronize()` method is invoked on the synchronization object to establish synchronization between two models.
    This method configures how data is synchronized between the models.
Synchronization Rule:
    The synchronization rule, `FamilyRegisterToPersonRegister`, is specified from the `Families2PersonsSynchronization` class.
    It defines the logic for mapping data between the family register and the person register.
Adding Registers:
    Both the family register and the person register are passed as parameters to the Synchronize method.
    The family register is considered the left model, and the person register is considered the right model.
Synchronization Direction:
    The synchronization direction is set to LeftWins, indicating that the left model's values take precedence during synchronization.
    This ensures that conflicts are resolved in favor of the left model's data.
Change Propagation Mode:
    The change propagation mode is set to TwoWay, indicating bidirectional synchronization.
    Changes can propagate in both directions, allowing both models to react to each other's updates.


```csharp
familyRootModel.RootElements.Add(familyRegister);
personRootModel.RootElements.Add(personRegister);

repository.Models.Add(new Uri("ttc:source"), familyRootModel);
repository.Models.Add(new Uri("ttc:target"), personRootModel);
```
In the next step, we will build our 'tree' by storing the registries in the models. Subsequently, these generated and populated models will be saved.


Then, our Program.cs looks like this.
```csharp
class Program
    {
        private FamilyRegister familyRegister;
        private PersonRegister personRegister;

        private ModelRepository repository = new ModelRepository();

        private Families2PersonsSynchronization synchronization = new Families2PersonsSynchronization();

        public Program()
        {
            var familyRootModel = new Model();
            var personRootModel = new Model();

            familyRegister = new FamilyRegister();
            personRegister = new PersonRegister();

            synchronization.Synchronize(
                synchronization.SynchronizationRule<Families2PersonsSynchronization.FamilyRegisterToPersonRegister>(),
                ref familyRegister, // Familyregister is the left model
                ref personRegister, // Personregister is the right model
                SynchronizationDirection.LeftWins, // prioritizes the left synchronization of left model (without shouldCorrespond it has no impact)
                ChangePropagationMode.TwoWay); // TwoWay means Bidirectional synchronization 

            familyRootModel.RootElements.Add(familyRegister);
            personRootModel.RootElements.Add(personRegister);

            repository.Models.Add(new Uri("ttc:source"), familyRootModel);
            repository.Models.Add(new Uri("ttc:target"), personRootModel);
        }

        static void Main(string[] args)
        {}
    }
```

## Synchronization

As described above, in this section, we specifically address the synchronization rule/block.

```csharp 
synchronization.SynchronizationRule<Families2PersonsSynchronization.FamilyRegisterToPersonRegister>()
```

The line signifies that a synchronization rule is being invoked, with its type being `Families2PersonsSynchronization.FamilyRegisterToPersonRegister`. This rule leverages the synchronization block, which is defined within the Families2PersonsSynchronization class.

Lets take a closer a look at the synchronization block. 
```csharp
public class FamilyRegisterToPersonRegister : SynchronizationRule<FamilyRegister, PersonRegister>
        {
            // Synchronization Block
            public override void DeclareSynchronization()
            {
                SynchronizeMany(SyncRule<MemberToMember>(),
                    fam => new FamilyMemberCollection(fam),
                    persons => persons.Persons);
            }
        }
```
This method named [SynchronizeMany](../synchronizations/api/NMF.Synchronizations.SynchronizationRuleBase.yml) facilitates bidirectional synchronization, implying that the method itself defines a dependency between both models. It synchronizes dependent elements using a synchronization rule, accepting a rule, left and right selectors in the model, and the types of dependent elements. Then, it initiates synchronization using the provided parameters.


```csharp
public class MemberToMember : SynchronizationRule<IFamilyMember, IPerson>
        {
            // Synchronization block for a familymember and a person
            public override void DeclareSynchronization()
            {
                Synchronize(m => m.GetFullName(), p => p.Name);
            }
        }
```
The block defines how individual objects should be synchronized with each other. 
In this example, people and family members are being synchronized. The synchronization is based on one or more attributes that are the same. A shared attribute between Person and FamilyMember is the attribute `name`, which is why the synchronization is based on the `name` attribute of both classes.

<aside class="note">

**Note:**

At this point, it can be added that when synchronizing between a family and a person register that are already populated, the collision rule applies. For example, there is a man named Smith who marries a woman named Muster. As a result, the woman appears as Smith in the family register and as Muster in the person register. This leads to a collision, and the left side (family register) wins, so the woman's name in the person register is changed to Smith.

</aside>

Next, let's take a closer look at the `GetFullName` method.

```csharp
[LensPut(typeof(Helpers), "SetFullName")] // is called when GetFullName is called
[ObservableProxy(typeof(Helpers), "GetFullNameInc")] // connected mit INotifyValue
public static string GetFullName(this IFamilyMember member)
{
    return fullName.Evaluate(member);
}
```

Let's first have a look at the fullName attribute
```csharp
private static ObservingFunc<IFamilyMember, string> fullName = new ObservingFunc<IFamilyMember, string>(m => m.Name == null ? null : ((IFamily)m.Parent).Name + ", " + m.Name);
```
This expression defines a static field `fullName` of type `ObservingFunc<IFamilyMember, string>`. It's initialized with a lambda function that takes an `IFamilyMember` object m and returns a string representing the member's full name. If the member's name is not null, it concatenates the family name with the member's name, separated by a comma. If the member's name is null, it returns null.

```csharp
[LensPut(typeof(Helpers), "SetFullName")] // is called when GetFullName is called
[ObservableProxy(typeof(Helpers), "GetFullNameInc")] // connected with INotifyValue
```   
`ObservableProxy`:
    The annotations indicate that the `fullName` variable is constantly observed. This means that through the `GetFullNameInc` function with the parameter type `INotifyValue`, the `fullName` of the family member is continuously monitored. Upon any changes, the family member is notified, and the changes are propagated in real-time.
`LensPut`:
    `LensPut` ensures that the `SetFullName` method is always executed whenever the `GetFullName` method is used.

```csharp
public static void SetFullName(this IFamilyMember member, string newName)
{
    var family = member.Parent as IFamily;
    var separator = newName.IndexOf(", ");
    var lastName = newName.Substring(0, separator);
    var firstName = newName.Substring(separator + 2);
    member.Name = firstName;
    if (family != null && family.Name != lastName)
    {
        var isMale = member.FatherInverse != null || member.SonsInverse != null;
        member.AddToFamily(family.FamiliesInverse, isMale, lastName);
    }
}
```
The `SetFullName` method is an extension method designed for objects implementing the `IFamilyMember` interface. When invoked, it first retrieves the associated family of the member. Assuming the full name is structured as "Last Name, First Name", it parses the `newName` parameter to extract the last and first names accordingly. Subsequently, it updates the member's Name property with the extracted first name. Additionally, if the associated family exists and its name differs from the extracted last name, it determines the member's gender based on familial relationships and adds the member to the family's collection, specifying the gender and the extracted last name. This method effectively manages the synchronization of the full name and family association of a family member.

## Github Tutorial: [here](https://github.com/Cemtk6246/Family2Person)