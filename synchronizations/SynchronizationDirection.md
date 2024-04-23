# Synchronization Directions
NMF Synchronizations supports multiple synchronization directions. The direction of a synchronization determines, which model is used as the main input, which one is used as the main output and how these models should be merged. The direction distinguishes between a left side and a right side. These sides correspond to the left and right side in the synchronization specification.

## LeftToRight
The direction left to right means that the left side is used as the input, while the right side is used as the output. The synchronization leaves the left side untouched, while the right side is merged with the left side. That is, the synchronization makes sure that every model element in the left side has a correspondence in the right side. However, model elements may reside in the right side that do not have a corespondence on the left side. These elements are simply ignored.

For attributes like e.g. names, the direction LeftToRight means that the name is initially taken from the left side and copied to the right side. This does not influence the [change propagation](ChangePropagationMode.md), so if the change propagation is set to TwoWay and the right side updates its name, then this name is copied to the left side. The synchronization direction only specifies that initially (when the synchronization engine establishes the correspondence) the name of the left side is copied to the right side.

## LeftToRightForced
Again, the left side is used as the input and the right side is used as the output. But unlike LeftToRight, elements of the right hand side that do not have a correspondence in the left hand side are deleted from the right hand side.

## LeftWins
Similar to LeftToRight and LeftToRightForced, LeftWins specifies that the left hand side is used as input and the right hand side is used as output. Unlike the first two, if the synchronization finds an element on the right side, where there is no corresponding element on the left side, a corresponding element on the left side is established. 

## RightToLeft, RightToLeftForced, RightWins
These directions are the counterparts of LeftToRight, LeftToRightForced, LeftWins, but with interchanged meanings of the left and right side.