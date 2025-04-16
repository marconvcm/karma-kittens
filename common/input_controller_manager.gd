class_name InputControllerManager extends Node

var controllers: Array[InputController] = [
   InputController.new(),
   InputController.new(),
]

signal controller_enabled(index: int)
signal controller_disabled(index: int)

func _ready() -> void:
   for i in range(controllers.size()):
      controllers[i].index = i
      controllers[i].name = "player_" + str(i)
      controllers[i].set_process(false)
      controllers[i].set_process_input(false) 

func get_controller(index: int) -> InputController:
   if index < 0 or index >= controllers.size():
      return null
   return controllers[index]

func disable_controller(index: int) -> void:
   if index < 0 or index >= controllers.size():
      return
   var controller = controllers[index]
   controller.set_process(false)
   controller.set_process_input(false)
   controller_disabled.emit(index)

func enable_controller(index: int) -> void:
   if index < 0 or index >= controllers.size():
      return
   var controller = controllers[index]
   controller.set_process(true)
   controller.set_process_input(true)
   controller_enabled.emit(index)