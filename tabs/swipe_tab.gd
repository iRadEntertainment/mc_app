#=======================#
#      SWIPE_TAB.GD     #
#=======================#

extends Container

var tab_num = 0

func _ready():
	set_material(get_material().duplicate()) #set the shader as an instance
	$an_swipe.current_animation = "swipe"
	$an_swipe.stop(false)
	self.set("shader_param/shader_screen_size",get_viewport().size)
	assign_parent_mat(self)
	set_process(true)
	init()

func swipe(amt):
	var scaled_amt = amt/get_viewport().size.x
	var an_pos = $an_swipe.current_animation_position
	an_pos += scaled_amt
	an_pos = clamp(an_pos,0,1)
	$an_swipe.seek(an_pos, true)
#	prints ("SWIPE TAB: current pos =",$an_swipe.current_animation_position)

func swipe_anim(pos):
	pos = clamp(pos,0,1)
	$an_swipe.seek(pos,true)

func get_anim_pos():
	var an_pos = $an_swipe.current_animation_position
	return an_pos

func assign_parent_mat(node):
	for N in node.get_children():
		
		if N.get_child_count() > 0:
			assign_parent_mat(N)
		
		if N.has_method("set_use_parent_material"):
			N.use_parent_material = (N.get_name() != "bg")

func _process(delta):
	if !glb.fl_dragging:
		var an_pos = $an_swipe.current_animation_position
		if !an_pos in [0,0.5,1]:
			var target = 0.0
			var release_treshold = 0.25
			if   an_pos < 0.5 - release_treshold: target = 0.0
			elif an_pos > 0.5 + release_treshold: target = 1.0
			else:                                 target = 0.5
			
			$an_swipe.seek(lerp(an_pos,target,delta*10),true)
			if abs(an_pos - target) < 0.01:
				$an_swipe.seek(target,true)
		elif an_pos == 0.5:
			if glb.current_tab != tab_num:
				glb.current_tab = tab_num
				print("current tab = %s"%[glb.current_tab])
				

func init(): pass
