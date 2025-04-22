class_name Actor extends CharacterBody3D

@onready var rotation_root: Node3D = $RotationRoot
@onready var label: Label3D = $RotationRoot/Label

@onready var _last_strong_direction := Vector3.FORWARD

var speed: float = 5.0
var child_look_at
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
@export var rotation_speed := 12.0

func _ready() -> void:
   # Called when the node enters the scene tree for the first time.
   # You can use this function to initialize variables or set up the node's state.
   label.text = self.name
   child_look_at = Marker3D.new()
   add_child(child_look_at)
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
   _push_away_rigid_bodies()
   move_and_slide()
   after_move(delta)

func _orient_character_to_direction(direction: Vector3, delta: float) -> void:
   var left_axis := Vector3.UP.cross(direction)
   var rotation_basis := Basis(left_axis, Vector3.UP, direction).get_rotation_quaternion()
   var model_scale := rotation_root.transform.basis.get_scale()
   rotation_root.transform.basis = Basis(rotation_root.transform.basis.get_rotation_quaternion().slerp(rotation_basis, delta * rotation_speed)).scaled(
      model_scale
   )


func _push_away_rigid_bodies():
   for i in get_slide_collision_count():
      var c := get_slide_collision(i)
      if c.get_collider() is RigidBody3D:
         var push_dir = -c.get_normal()
         # How much velocity the object needs to increase to match player velocity in the push direction
         var velocity_diff_in_push_dir = self.velocity.dot(push_dir) - c.get_collider().linear_velocity.dot(push_dir)
         # Only count velocity towards push dir, away from character
         velocity_diff_in_push_dir = max(0., velocity_diff_in_push_dir)
         # Objects with more mass than us should be harder to push. But doesn't really make sense to push faster than we are going
         const MY_APPROX_MASS_KG = 20
         var mass_ratio = min(1., MY_APPROX_MASS_KG / c.get_collider().mass)
         # Optional add: Don't push object at all if it's 4x heavier or more
         if mass_ratio < 0.25:
            continue
         # Don't push object from above/below
         push_dir.y = 0
         # 5.0 is a magic number, adjust to your needs
         var push_force = mass_ratio * 5.0
         c.get_collider().apply_impulse(push_dir * velocity_diff_in_push_dir * push_force, c.get_position() - c.get_collider().global_position)
