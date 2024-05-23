# Family 2 Person

## Introduction to biderictional transformations
Bidirectional transformations (bx) are transformations that can be executed both from the source to the target and vice versa. This means that not only is one data structure transformed into another, but there is also the capability to restore the original structure through the reverse transformation. Bidirectional transformations are crucial in various applications, especially when data needs to be exchanged between different representations or models. Examples of scenarios where bidirectional transformations are relevant include bidirectional data converters, round-trip engineering in software development, or view updates in databases. The use of bidirectional transformations enables consistent and complete synchronization between different data representations.

`Example`: Imagine you have an online calendar on your computer and another one on your smartphone. Bidirectional transformation allows appointments and events to seamlessly transfer between your computer and smartphone, ensuring both calendars stay updated.

For example, when you add an appointment on your computer, it automatically syncs to your smartphone. Likewise, if you edit an appointment on your smartphone, the change is mirrored on your computer. Bidirectional transformation ensures synchronization in both directions, keeping your schedule consistent and current across both devices.

## Use Case
![Visualization of Family 2 Persons](images/Family2PersonDiagram.png)

The models assume a unique root in each model, where a family register stores families, and a person register maintains a flat collection of individuals. The metamodel specifies roles, allowing for at most one father and one mother, along with an arbitrary number of daughters and sons. The models lack key property assumptions, permitting multiple families with the same name, clashes within a family, and multiple persons with the same name and birthday. All collections are assumed to be unordered.

Consistency between the families and persons models is defined by a bijective mapping, ensuring mothers/daughters and fathers/sons are paired with females/males. After a transformation, this consistency must be maintained. For batch transformations, a forward transformation maps family members to persons based on gender, while the backward transformation introduces configurability through boolean parameters, controlling mappings to parents or children and preference for existing families or new ones.

In incremental transformations, various updates are considered. Forward updates involve the insertion, deletion, renaming, or moving of families and members. Backward updates, affected by dynamic configuration parameters, include deletion, insertion, and changes in name, but not birthdays. These transformations exemplify a round-trip engineering scenario, requiring bidirectional updates.
[Click here to see the complete TTC solution](https://sdq.kastel.kit.edu/publications/pdfs/hinkel2017f.pdf)

[Click here to get to the Tutorial](./Synchronization.md)