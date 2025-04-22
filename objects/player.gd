class_name Player extends Actor

@export var player_index: int = 1

@onready var ray_cast_3d: RayCast3D = $RotationRoot/RayCast3D

@onready var current_controller: InputController = GlobalInputControllerManager.get_controller(player_index)

var nearbyInteracts:Array = []

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

   # get pullable objects
   if ray_cast_3d.is_colliding():
      var obj:Node3D = ray_cast_3d.get_collider()
      var desiredLayer:int = 9
      var cl:int = pow(2, desiredLayer - 1)

      if obj != null && (obj.collision_layer - 1) == cl: # -1 for layer 1
         if !obj in nearbyInteracts:
            nearbyInteracts.append(obj)
      else:
         return
         
   elif nearbyInteracts.size() > 0:
      nearbyInteracts.clear()
      
   
   var direction = get_direction() 
   var is_grabbing = current_controller.is_key_pressed(InputController.Keys.ACTION_1)
   if is_grabbing: print(nearbyInteracts.size())
   
   if is_grabbing and nearbyInteracts.size() > 0:
      for obj:Node3D in nearbyInteracts:
         const MY_APPROX_MASS_KG = 20
         var mass_ratio = min(1., MY_APPROX_MASS_KG / obj.mass)
         # Optional add: Don't push object at all if it's 4x heavier or more
         if mass_ratio < 0.25:
            continue
            
         # 5.0 is a magic number, adjust to your needs
         var push_force = mass_ratio * 3
         obj.linear_velocity = push_force * (global_position - obj.global_position)
   else:   
      if direction.length() > 0.2:
         _last_strong_direction = direction.normalized()
         _orient_character_to_direction(_last_strong_direction, delta)
