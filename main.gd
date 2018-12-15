#=================#
#     MAIN.GD     #
#=================#

extends Control


func _ready():
	#signal connection
	$swipe_detect.connect("screen_dragged",self,"swipe_tab") #connect swipe amt

func swipe_tab(amt): #transmit swipe to tabs
		$main_frame/swipe_tab.swipe(amt)