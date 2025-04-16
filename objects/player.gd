class_name Player extends Actor

@export var player_index: int = 1

@onready var current_controller: InputController = GlobalInputControllerManager.get_controller(player_index)

func get_direction() -> Vector3:
   var direction = current_controller.get_axis()
   return Vector3(direction.x, 0, direction.y)

