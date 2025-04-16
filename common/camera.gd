class_name Camera extends Camera3D

@export var target: Actor


func _physics_process(delta):
   if target:
      var target_position = target.global_position
      
      # Rotate the camera to look at the target
      look_at(target_position, Vector3.UP)

      target.camera_rotation = rotation_degrees.y
      
     