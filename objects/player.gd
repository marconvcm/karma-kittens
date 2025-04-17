class_name Player extends Actor

@export var player_index: int = 1

@onready var current_controller: InputController = GlobalInputControllerManager.get_controller(player_index)

func get_direction() -> Vector3:
   var direction = current_controller.get_axis()
   return Vector3(direction.x, 0, direction.y)

func before_move(delta: float) -> void:
   var jump_action = "jump"
   var is_just_jumping := current_controller.is_action_just_pressed(jump_action) and is_on_floor()
   var is_air_boosting := current_controller.is_action_pressed(jump_action) and not is_on_floor() and velocity.y > 0.0
   
   if is_just_jumping:
      velocity.y += jump_initial_impulse
   elif is_air_boosting:
      velocity.y += jump_additional_force * delta
