extends Control

var fl_connected = false


var current_tab = 0

func _ready():
	#signal connection
	$swipe_detect.connect("screen_dragged",self,"swipe_tab") #connect swipe amt

func swipe_tab(amt): #transmit swipe to tabs
		$main_frame/swipe_tab.swipe(amt)

func _on_btn_send_pressed():
	if $message.text == "": return
	if !fl_connected:
		$scr/bg/lb_print.text = str($scr/bg/lb_print.text,"\n","Not connected to server")
		$message.text = ""
		return
	
	var text_to_send = $message.text
	match text_to_send:
		"1": text_to_send = 1
		"2": text_to_send = 2
	$scr/bg/lb_print.text = str($scr/bg/lb_print.text,"\n","Sending data to server:",text_to_send)
	get_tree().multiplayer.send_bytes(var2bytes(text_to_send))
	$message.text = ""