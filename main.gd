#=================#
#     MAIN.GD     #
#=================#

extends Control

onready var tab_mng = $main_frame/control_panel
onready var n_tabs = [tab_mng] 

func _ready():
	#signal connection
	$swipe_detect.connect("screen_dragged",self,"swipe_tab") #connect swipe amt

func swipe_tab(amt): #transmit swipe to tabs
	var tab_next = glb.current_tab + 1
	var tab_prev = glb.current_tab - 1
	if   amt < 0 and tab_prev < 0: return
	elif amt > 0 and tab_prev > n_tabs.size()-1: return
	n_tabs[glb.current_tab].swipe(amt)