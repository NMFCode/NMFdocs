# Change Propagation Mode
NMF Synchronizations supports multiple change propagation modes. The modes are listed below with their explanation.

## None
Setting the change propagation mode to none tells NMF Synchronizations that no change propagation is to perfomed.

## OneWay
This change propagation mode means that only model changes of the input side are considered. The input side is determined by the [synchronization direction](SynchronizationDirection.md). 

## TwoWay
The change propagation mode TwoWay specifies that model updates of both input and output model can trigger updates in the synchronization process.