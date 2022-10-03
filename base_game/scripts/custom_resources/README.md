# Destruction
This folder contains all Scripts for custom Resources. The Resources themselves are in [resources/custom](/base_game/resources/custom).

### Contents
[array_resource](#array_resourcegd)<br>
[player_controls](#player_controlsgd)<br>



## array_resource.gd
extends Resource<br>
This Resource stores an Array.

### Properties
| Type | Name |
|---|---|
| Array | [array](#--array-array) |

### Property Descriptions
#### - Array array
Yes.



## player_controls.gd
extends Resource<br>
This Resource stores one player's actions of the InputMap.

### Properties
| Type | Name |
|---|---|
| Export String | [various](#--export-string-various) |

### Property Descriptions
#### - Export String various
Each String is the name of an action on the InputMap. The default value of each is the action for player one.
