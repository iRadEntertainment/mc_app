#=================#
#     MAIN.GD     #
#=================#

extends Control

var n_tabs = [] 

func _ready():
	connect_signals()
	count_tabs()
	set_current_tab()
	self

#--------- Setup ------------
func connect_signals():
	$swipe_detect.connect("screen_dragged",self,"swipe_tab") #connect swipe amt

func count_tabs():
	for i in range( $main_frame.get_child_count() ):
		var node = $main_frame.get_children()[i]
		if node.has_method("swipe"):
			node.tab_num = i-1
			n_tabs.append(node)
			print("MAIN: Tab %s: %s"%[node.tab_num , node.get_name()])

func set_current_tab(tab_num = 0):
	glb.current_tab = tab_num
	for node in $main_frame.get_children():
		if node.has_method("swipe_anim"):
			node.visible = false
			if node.tab_num == tab_num:
				node.visible = true
				node.swipe_anim(0.5)
			elif node.tab_num<tab_num:
				node.swipe_anim(0)
			else:
				node.swipe_anim(1)


#--------- Layout funcs ------------
func swipe_tab(amt): #transmit swipe to tabs
	var tab = n_tabs[glb.current_tab]
	var tab_anim_pos = tab.get_anim_pos()
	
	var tab_next = glb.current_tab + 1
	if tab_next > n_tabs.size()-1: tab_next = 0
	var tab_prev = glb.current_tab - 1
	if tab_prev < 0: tab_prev = n_tabs.size()-1
#	if   amt < 0 and tab_prev < 1: return
#	elif amt > 0 and tab_next > n_tabs.size()+1: return
#	else:
	tab.swipe(amt)
	if amt <0: n_tabs[tab_next].swipe_anim(tab_anim_pos+0.5)
	if amt >0: n_tabs[tab_prev].swipe_anim(tab_anim_pos-0.5)
#	print("MAIN: swipe anim %s-%s, %s-%s, %s-%s"%[tab_prev,n_tabs[tab_prev].get_anim_pos(),
#												glb.current_tab,n_tabs[glb.current_tab].get_anim_pos(),
#												tab_next,n_tabs[tab_next].get_anim_pos()])
	
