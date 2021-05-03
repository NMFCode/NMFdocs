# Change Recording

NMF allows users to record, serialize, deserialize, replay and invert changes made to a model generically. For this, a dedicated class **[ModelChangeRecorder](api/NMF.Models.Changes.ModelChangeRecorder.yml)** is used. An instance of this class will automatically register to [bubbled events](ModelElement.md) and save the events temporarily. Upon user request, the captured events are interpreted and converted into a dedicated change model. This change model is (almost) a regular model and has builtin functionality to apply or invert it.

## Recording model changes

To start recording changes to a model, you need an instance of the **ModelChangeRecorder** class and tell it which model elements you want to track. Because the elementary model changes will get bubbled upwards in the containment hierarchy, it usually suffices to track the root model element (or the model itself) of all trees you want to track. Model change recorders support the simultaneous tracking of multiple model elements and multiple model recorders can be attached to the same model elements. However, whenever the user requests to interpret the recorded change events, the resulting change model will contain changes of all model elements tracked by this change recorder (because the extraction works based on captured events).

The following code suffices to start tracking a model called *model*.

>
```csharp
var recorder = new ModelChangeRecorder();
recorder.Start(model);
```

Be aware that attaching a model change recorder to a model will set an internal flag that bubbled change events will contain URIs of the involved model elements. This has the consequence that these URIs have to be recomputed. These URIs are exclusively required if the change model needs to be serialized later on. Therefore, this behavior can be disabled in the constructor of the model change recorder.

## Extracting model change sequences

The extraction of a model change sequence is supported through the method **GetModelChanges** or its asynchronous cousin **GetModelChangesAsync**. In this process, the captured events will be processed and a model change sequence is reconstructed. The result is a **[ModelChangeSet](api/NMF.Models.Changes.ModelchangeSet.yml)** model element that is already encapsulated in a model.

This works very well, if the captured events are complete. This is the case if all model elements that have been subject to changes have been under the scope of a tracked model element or have been newly created. It does not work as well, if model elements are moved outside the scope of tracked model elements and then changed outside this boundary, because the model change recorder does not fully understand what change sequence is going on. However, the extraction logic of model change sequences has some reconstruction logic built in that will detect a range of problems of this kind.

## Serializing model changes

From an API perspective, the resulting model change sequences are just a regular model, which means it can be serialized using the standard model serializer. The models created for a model change sequence have some specialities, though. These include:

1. Meanwhile containment references are usually persisted in the *Parent* reference of a model element and therefore, model elements can only be contained in a single other model element, this behavior is intentionally disabled for model changes. This means, a model element contained somewhere in the model hierarchy can simultaneously be contained in an elementary model change element that describes the insertion of this element.
2. References to other model elements are serialized with the URI these model elements had before the model change sequence was applied.

## Deserializing model changes

As a consequence of the last two properties, it is easily possible to deserialize a model change using the standard model serializer. Note that the model change sets loaded using this way will be in the standard **Model** class.

Deserializing a change model will not execute the actual model changes. Instead, it will populate a **ModelChangeSet** with model elements describing the elementary model changes.

## Applying model changes

Applying a change set to an unmodified copy of the model is as easy as calling the **Apply** method on the respective change set.

## Inverting model changes

