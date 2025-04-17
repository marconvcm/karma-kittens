class_name Actor extends CharacterBody3D

@export var world_settings: WorldSettings

var speed: float = 5.0

## Jump impulse
@export var jump_initial_impulse:float = 12.0
## Jump impulse when player keeps pressing jump
@export var jump_additional_force:float = 4.5
## Movement acceleration (how fast character achieve maximum speed)
@export var acceleration:float = 4.0
## Minimum horizontal speed on the ground. This controls when the character's animation tree changes
## between the idle and running states.
@export var stopping_speed:float = 1.0

var camera_rotation: float = 0.0

func get_direction() -> Vector3:
   return Vector3.ZERO

func _physics_process(_delta: float) -> void:
   var direction = get_direction()   
   #velocity = direction * speed

   var y_velocity := velocity.y
   velocity.y = 0.0
   velocity = velocity.lerp(direction * speed, acceleration * _delta)
   if direction.length() == 0 and velocity.length() < stopping_speed:
      velocity = Vector3.ZERO
   velocity.y = y_velocity
      
   velocity.y += world_settings.gravity * _delta

   if self is Player:
      var jump_action = str("player_[%s]_jump" % [(self as Player).player_index])
      var is_just_jumping := Input.is_action_just_pressed(jump_action) and is_on_floor()
      var is_air_boosting := Input.is_action_pressed(jump_action) and not is_on_floor() and velocity.y > 0.0
      
      if is_just_jumping:
         velocity.y += jump_initial_impulse
      elif is_air_boosting:
         velocity.y += jump_additional_force * _delta
      
   move_and_slide()
      
