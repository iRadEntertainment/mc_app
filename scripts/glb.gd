#===================#
#     GLOBAL.GD     #
#===================#

extends Node

#log
var log_max_size = 1000

#network
var fl_connected = false
var fl_logged_in = false
var net_id = -1

#swipe_detect
var fl_screen_p = false
var fl_dragging = false
var current_tab = 1


#--------------------- console utilities ---------------------
func log_print(string):
	print(string)
	var dic = OS.get_datetime()
	var time = [dic["month"],dic["day"],dic["hour"],dic["minute"],dic["second"]]
	var log_entry = [time,string]
	glb.console_log.push_back(log_entry)
	while glb.console_log.size() > log_max_size:
		glb.console_log.pop_front()
	
	
	print(format_log_entry(log_entry))

func format_log_entry(log_entry):
	var time = log_entry[0]
	var string = log_entry[1]
	#print sdtout
	var time_str   = "%s/%s [%s:%s:%s]"%time
	var format_str = "%s - %s"%[time_str,string]
	return (format_str)

#--------------------- other utilities ---------------------
func n_base():
	var root=get_tree().get_root()
	return root.get_child(root.get_child_count()-1)

