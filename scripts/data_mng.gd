#=====================#
#     DATA_MNG.GD     #
#=====================#
extends Node

#---------- config_files
var data_dir  = str(OS.get_system_dir(0))
var data_filename = "mc_data.cfg"
var data_path = str(data_dir,"/",data_filename)

#---------- config_files
var console_log = [] setget _log_updated
signal log_updated


func _ready():
	load_initial_settings()

func load_initial_settings():
	glb.log_print("DATA MANAGER: loading initial settings")
	var dir = Directory.new()
	if dir.open(data_dir) != OK:
		glb.log_print("DATA MANAGER: Unexisting folder")
		create_default_config()
	elif not Directory.new().file_exists(data_path):
		glb.log_print("DATA MANAGER: no config file!")
		create_default_config()
	else:
		var file_config = ConfigFile.new()
		file_config.load(data_path)
		#var_name = file_config.get_value("settings", "var_name", var_name(or default value) )

func create_default_config():
	glb.log_print("DATA MANAGER: creating default file")
	var dir = Directory.new()
	if dir.open(data_dir) != OK:
		var err_dir = dir.make_dir_recursive(data_dir)
		if err_dir == OK:
			glb.log_print( str ("DATA MANAGER: folder created -> ", data_dir) )
		else:
			glb.log_print(str ("DATA MANAGER: Unable to create folder -> Error ",err_dir))
			return
	
	#--------- default values
	var file_config = ConfigFile.new()
#	file_config.set_value("settings","thumb_size",thumb_size)
	
	#--------- finalizing
	var err_cfg = file_config.save(data_path)
	if err_cfg == OK:
		glb.log_print(str ("DATA MANAGER: config file = ", data_path))
	else:
		glb.log_print( str("DATA MANAGER: unable to save config file -> Error ", err_cfg))


func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		var node_data = i.call("save");
		save_game.store_line(to_json(node_data))
	save_game.close()

func _log_updated(val):
	console_log = val
	emit_signal("log_updated",console_log)