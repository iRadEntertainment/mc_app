#=================#
#     MAIN.GD     #
#=================#

extends Control

var n_tabs = [] 

func _ready():
	connect_signals()
	count_tabs()

#--------- Setup ------------
func connect_signals():
	$swipe_detect.connect("screen_dragged",self,"swipe_tab") #connect swipe amt

func count_tabs():
	for node in $main_frame.get_children():
		if node.has_method("swipe"):
			node.tab_num = 0
			n_tabs.append(node)

#--------- Layout funcs ------------
func swipe_tab(amt): #transmit swipe to tabs
	var tab_next = glb.current_tab + 1
	var tab_prev = glb.current_tab - 1
	if   amt < 0 and tab_prev < 0: return
	elif amt > 0 and tab_next > n_tabs.size()-1: return
	else: n_tabs[glb.current_tab].swipe(amt)