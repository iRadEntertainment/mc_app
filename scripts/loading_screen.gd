#=======================#
#   LOADING_SCREEN.GD   #
#=======================#

extends Control

var main_scene = "res://main.tscn"
var loader
var loaded_scene

var min_time = 2 #sec
var fl_min_time_expired = false
var wait_frames = 10

func _ready():
	load_main_scene()

func load_main_scene():
	loader = ResourceLoader.load_interactive(main_scene)
	set_process(true)

func _process(delta):
	if min_time > 0:
		min_time -= delta
	elif !fl_min_time_expired:
		fl_min_time_expired = true
	
	if wait_frames > 0:
		wait_frames -= 1
		return
	
	if loader == null: # loader can be set null from next step -> stop processing
		update_percentage()
		if fl_min_time_expired:
			open_next_scene(loaded_scene)
			set_process(false)
		return
	
	var err = loader.poll()
	if err == ERR_FILE_EOF: # loading finished
		loaded_scene = loader.get_resource()
		loader = null
	elif err == OK:
		update_percentage()
	else: # loading error
		loading_error()
		loader = null

func update_percentage():
	var percentage = 0
	if loader == null: percentage = 100
	else:              percentage = float(loader.get_stage()) / loader.get_stage_count()
	$bar.value = percentage

func open_next_scene(loaded_scene): 
	get_node("/root").add_child( loaded_scene.instance() )
	queue_free()

func loading_error():
	glb.log_print("LOADING_SCREEN: !!!Loading error!!!")