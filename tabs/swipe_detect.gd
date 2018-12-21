#=======================#
#    SWIPE_DETECT.GD    #
#=======================#

extends Control

signal screen_dragged


func _ready():
	set_process_unhandled_input(true)


func _unhandled_input(event):
	if glb.fl_screen_p:
		glb.fl_dragging = (event is InputEventScreenDrag) or (event is InputEventMouseMotion)
		if glb.fl_dragging:
			emit_signal("screen_dragged",event.relative.x)
	
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		glb.fl_screen_p = event.is_pressed()