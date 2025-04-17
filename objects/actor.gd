class_name Actor extends CharacterBody3D

@onready var label: Label3D = $Label

var speed: float = 5.0

var camera_rotation: float = 0.0

@export var world_settings: WorldSettings
## Jump impulse
@export var jump_initial_impulse:float = 12.0
## Jump impulse when player keeps pressing jump
@export var jump_additional_force:float = 4.5
## Movement acceleration (how fast character achieve maximum speed)
@export var acceleration:float = 4.0
## Minimum horizontal speed on the ground. This controls when the character's animation tree changes
## between the idle and running states.
@export var stopping_speed:float = 1.0

func _ready() -> void:
   # Called when the node enters the scene tree for the first time.
   # You can use this function to initialize variables or set up the node's state.
   label.text = self.name
   pass


func get_direction() -> Vector3:
   return Vector3.ZERO

func before_move(_delta: float) -> void:
   # This function is called before the move_and_slide() function
   # It can be used to set up the character's state before moving
   # For example, you can set the camera rotation or other properties here
   pass

func after_move(_delta: float) -> void:
   # This function is called after the move_and_slide() function
   # It can be used to reset the character's state after moving
   # For example, you can reset the camera rotation or other properties here
   pass

func _physics_process(delta: float) -> void:
   var direction = get_direction()   
   
   var y_velocity := velocity.y
   velocity.y = 0.0
   velocity = velocity.lerp(direction * speed, acceleration * delta)
   if direction.length() == 0 and velocity.length() < stopping_speed:
      velocity = Vector3.ZERO
   velocity.y = y_velocity      
   velocity.y += world_settings.gravity * delta

   before_move(delta)
   move_and_slide()
   after_move(delta)
