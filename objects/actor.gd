class_name Actor extends CharacterBody3D

@export var world_settings: WorldSettings

var speed: float = 5.0
var camera_rotation: float = 0.0

func get_direction() -> Vector3:
   return Vector3.ZERO

func _physics_process(_delta: float) -> void:
   var direction = get_direction()   
   velocity = direction * speed
   velocity.y += world_settings.gravity
   if is_on_floor():
       velocity.y = 0
   move_and_slide()
      
