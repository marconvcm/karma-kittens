class_name InputController extends Node

const input_prefix: String = "player_[%s]_"

@export var index: int = 0

enum Keys {
   UP,
   DOWN,
   LEFT,
   RIGHT,
   ACTION_0,
   ACTION_1,
   ACTION_2,
   ACTION_3,
}

func _prefix() -> String:
    return input_prefix % str(index)

func _is_action_pressed(action: String) -> bool:
    return Input.is_action_pressed(_prefix() + action)

func _is_action_just_pressed(action: String) -> bool:
   return Input.is_action_just_pressed(_prefix() + action)

func _is_action_just_released(action: String) -> bool:
   return Input.is_action_just_released(_prefix() + action)

func _get_action_strength(action: String) -> float:
    return Input.get_action_strength(_prefix() + action)

func _get_axis(negative_action: String, positive_action) -> float:
   return Input.get_axis(_prefix() + negative_action, _prefix() + positive_action)
    
func get_direction() -> Vector2:
    var direction: Vector2 = Vector2.ZERO
    if _is_action_pressed("right"):
        direction.x += 1
    if _is_action_pressed("left"):
        direction.x -= 1
    if _is_action_pressed("down"):
        direction.y += 1
    if _is_action_pressed("up"):
        direction.y -= 1
    return direction.normalized()

func get_axis() -> Vector2:
   return Vector2(
      _get_axis("axis_x_positive", "axis_x_negative"), 
      _get_axis("axis_y_negative", "axis_y_positive"))

func get_strength(action: String) -> float:
    return _get_action_strength(action)

func is_action_pressed(key: Keys) -> bool:
    match key:
        Keys.ACTION_0:
            return _is_action_pressed("action_0")
        Keys.ACTION_1:
            return _is_action_pressed("action_1")
        Keys.ACTION_2:
            return _is_action_pressed("action_2")
        Keys.ACTION_3:
            return _is_action_pressed("action_3")
    return false