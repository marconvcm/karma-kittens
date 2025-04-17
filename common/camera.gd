class_name Camera extends Camera3D

@export var target1: Actor
@export var target2: Actor

# Called every physics frame
func _physics_process(_delta: float) -> void:
   if target1 and target2:
      # Calculate the center position between the two targets
      var target_position = _find_center_between_two_points(target1.global_transform.origin, target2.global_transform.origin)
      # Adjust the Y position to be slightly above the higher target
      
      
      # Rotate the camera to look at the target position
      look_at(target_position, Vector3.UP)
      
      # Adjust the field of view based on the distance between the targets
      fov = _calculate_fov()

# Helper function to find the center point between two positions
func _find_center_between_two_points(p1: Vector3, p2: Vector3) -> Vector3:
   return (p1 + p2) * 0.5

# Helper function to calculate the distance between two positions
func _distance_between_two_points(p1: Vector3, p2: Vector3) -> float:
   return p1.distance_to(p2)

# Helper function to calculate the field of view based on distance
func _fov_based_on_distance(distance: float) -> float:
   const MIN_DISTANCE = 1.0
   const MAX_DISTANCE = 100.0
   const MIN_FOV = 30.0
   const MAX_FOV = 40.0

   if distance < MIN_DISTANCE:
      return MIN_FOV
   elif distance > MAX_DISTANCE:
      return MAX_FOV

   # Linearly interpolate the FOV based on the distance
   return lerp(MIN_FOV, MAX_FOV, (distance - MIN_DISTANCE) / (MAX_DISTANCE - MIN_DISTANCE))

# Calculate the next field of view based on the distance between the two targets
func _calculate_fov() -> float:
   var distance = _distance_between_two_points(target1.global_transform.origin, target2.global_transform.origin)
   return _fov_based_on_distance(distance)
