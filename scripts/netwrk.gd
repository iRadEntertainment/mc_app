#====================#
#     netwrk.gd      #
#====================#
extends Node

const PORT        = 5000
const ADDRESS     = "81.4.107.146" #"127.0.0.1" #"81.4.107.146"



func _ready():
	get_tree().multiplayer.connect("network_peer_packet",self,"_on_packets_received")
	get_tree().multiplayer.connect("connected_to_server",self,"_on_connection_succeeded")
	get_tree().multiplayer.connect("connection_failed",self,"_on_connection_failed")

func connect_to_network():
	var host = NetworkedMultiplayerENet.new()
	var res = host.create_client(ADDRESS,PORT)
	
	if res != OK:
		glb.log_print ("NETWORK: Impossible to create client")
		glb.log_print (str("NETWORK: Error:",res) )
		return
	get_tree().set_network_peer(host)
	glb.net_id = get_tree().multiplayer.get_network_unique_id()

func disconnect_from_network():
	get_tree().set_network_peer(null)
	glb.fl_connected = false

func _on_connection_failed():
	$scr/bg/lb_print.text = str($scr/bg/lb_print.text,"\n","Connection failed - ","Error: ")
	get_tree().set_network_peer(null)
	glb.fl_connected = false
	
func _on_connection_succeeded():
	$scr/bg/lb_print.text = str($scr/bg/lb_print.text,"\n","Connection succeded - ")
	glb.fl_connected = true
	$btn_bg/btn.text = "disconnect"

func _on_packets_received(id,packet):
	if id == 1: id = "Server: "
	$scr/bg/lb_print.text = str($scr/bg/lb_print.text,"\n", id , str( bytes2var(packet) ) )

func send_msg_data(dat, id = 0):
	get_tree().multiplayer.send_bytes(var2bytes(dat),id)