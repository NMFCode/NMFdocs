# Record Changes

NMF contains a generic change recorder. This change recorder hooks into the events raised by any NMF model element when a property or collection changes. The events are recorded and can be transformed into a change model.

Furthermore, the change recorder can be configured to record any changes of URIs such that the resulting change model can be serialized with the URIs that the model elements had before the
change has been applied. Therefore, the change models can be deserialized on another instance that has a copy of the model and can be applied there as well. 

In particular, the other instance can decide whether the change
model should be applied, possibly after inspection. The change model is detailed enough to also include changes that are implicit with the NMF model representation. Therefore, the change models can also be read by other
modeling frameworks.

Last, the change models also support a function to invert themselves. This does not have any effect on the actual model but produces an inverted change model.

To start recording changes of a given element `railway`, just use the following line of code:

```csharp
var rec = new ModelChangeRecorder();
rec.Start(railway);
...
var changes = rec.GetModelChanges();
```