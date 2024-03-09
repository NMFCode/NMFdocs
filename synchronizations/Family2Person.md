# Family 2 Person

## Introduction to biderictional transformations
Bidirectional transformations (bx) are transformations that can be executed both from the source to the target and vice versa. This means that not only is one data structure transformed into another, but there is also the capability to restore the original structure through the reverse transformation. Bidirectional transformations are crucial in various applications, especially when data needs to be exchanged between different representations or models. Examples of scenarios where bidirectional transformations are relevant include bidirectional data converters, round-trip engineering in software development, or view updates in databases. The use of bidirectional transformations enables consistent and complete synchronization between different data representations.

`Example`: Assuming you have an online calendar on your computer and another one on your smartphone. Bidirectional transformation enables the transfer of appointments and events from your computer to your smartphone and vice versa, ensuring both calendars are always up-to-date.

For instance, if you add an appointment on your computer, it will automatically be transferred to your smartphone, and if you edit an appointment on your smartphone, this change will also be reflected on your computer. Bidirectional transformation ensures synchronization in both directions, maintaining a consistent and current representation of your schedule on both devices.

## Use Case
![Visualization of Family 2 Persons](images/Family2PersonDiagram.png)

The models assume a unique root in each model, where a family register stores families, and a person register maintains a flat collection of individuals. The metamodel specifies roles, allowing for at most one father and one mother, along with an arbitrary number of daughters and sons. The models lack key property assumptions, permitting multiple families with the same name, clashes within a family, and multiple persons with the same name and birthday. All collections are assumed to be unordered.

Consistency between the families and persons models is defined by a bijective mapping, ensuring mothers/daughters and fathers/sons are paired with females/males. After a transformation, this consistency must be maintained. For batch transformations, a forward transformation maps family members to persons based on gender, while the backward transformation introduces configurability through boolean parameters, controlling mappings to parents or children and preference for existing families or new ones.

In incremental transformations, various updates are considered. Forward updates involve the insertion, deletion, renaming, or moving of families and members. Backward updates, affected by dynamic configuration parameters, include deletion, insertion, and changes in name, but not birthdays. These transformations exemplify a round-trip engineering scenario, requiring bidirectional updates.

## Tutorial
![EMF Diagrams](images/EMFDiagrams.png)

We generate the corresponding Ecore files from the two class diagrams shown above. One for the family model and one for the person model. 
We then generate the NMF models and classes, configure our .csproj file and load our models into the Program.cs file analogous to 
[Starting our first project](../models/FirstNmfProject.md)

We modify the Program.cs as follows:
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
        {
        }
    }
}
```
A short explanation to the code. 
1. Attributes
- `familyRegister` and `personRegister` are private class members representing instances of classes, used for managing family and person
registrations.
- `repository` is an instance of the ModelRepository class, responsible for managing models.
- `synchronization` is an instance of the Families2PersonsSynchronization class, designed for synchronizing data between family and person registers.

2. Constructor
- Two instances of the Model class (`familyRootModel` and `personRootModel`) are created. These will serve as root models for family and person registers.
- Instances of classes (FamilyRegister and PersonRegister) are created and assigned to familyRegister and personRegister.
- ## Synchonization:
    -   The `Synchronize` method is called on the `synchronization` instance.
    -   It uses the synchronization rule `Families2PersonsSynchronization.FamilyRegisterToPersonRegister`.
    -   `ref familyRegister` represents the left model, and `ref personRegister` represents the right model.
    -   `SynchronizationDirection.LeftWins` is used, prioritizing changes from the left model (familyRegister) in case of conflicts. (without shouldCorrespond it has no impact)
    -   `ChangePropagationMode.TwoWay` indicates bidirectional (two-way) synchronization, allowing changes in both directions.

    - `FamilyRegisterToPersonRegister` Class:
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
    -   This class extends `SynchronizationRule<FamilyRegister, PersonRegister>` and is designed for synchronizing instances of `FamilyRegister` to `PersonRegister`. 
    -   The `DeclareSynchronization` method is overridden, and it declares synchronization instructions using `SynchronizeMany`
    - `MemberToMember` Class:
        ```csharp
        public class MemberToMember : SynchronizationRule<IFamilyMember, IPerson>
        {
            public override void DeclareSynchronization()
            {
                Synchronize(m => m.GetFullName(), p => p.Name);
            }
        }
        ```
    -   This class extends `SynchronizationRule<IFamilyMember, IPerson>` and is designed for synchronizing instances of types implementing `IFamilyMember` to `IPerson`
    -   The `DeclareSynchronization` method is overridden, and it declares `synchronization` instructions using `Synchronize`.
    -   It synchronizes the result of calling `m.GetFullName()` on the left side to `p.Name` on the right side.
    -   Summary: In summary, the synchronization process involves calling the Synchronize method on the synchronization instance, using specific synchronization rules (FamilyRegisterToPersonRegister and MemberToMember) to synchronize data between instances of FamilyRegister, PersonRegister, IFamilyMember, and IPerson. The synchronization is bidirectional and prioritizes changes from the left model (familyRegister).
- The rest of the constructor is equivalent to the FirstNmfProject initialization. Adding the registry classes as RootElements and Adding the empty Models.