#====================#
#     netwrk.gd      #
#====================#
extends Node

const PORT        = 5000
const ADDRESS     = "81.4.107.146" #"127.0.0.1" #"81.4.107.146"



func _ready():
	#connect network signals
	get_tree().multiplayer.connect("network_peer_packet",self,"_on_packets_received")
	get_tree().connect("connected_to_server",self,"_on_connection_succeeded")
	get_tree().connect("connection_failed",self,"_on_connection_failed")
	
	get_tree().connect("network_peer_connected", self, "_on_user_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_user_disconnected")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")

func connect_to():
	var host = NetworkedMultiplayerENet.new()
	var res = host.create_client(ADDRESS,PORT)
	
	if res != OK:
		glb.log_print ("NETWORK: Impossible to create client")
		glb.log_print (str("NETWORK: Error:",res) )
		return
	get_tree().set_network_peer(host)
	glb.net_id = get_tree().multiplayer.get_network_unique_id()

func disconnect_from():
	get_tree().set_network_peer(null)
	glb.fl_connected = false

#----------------- network signal functions ---------------------
func _on_connection_failed():
	$scr/bg/lb_print.text = str($scr/bg/lb_print.text,"\n","Connection failed - ","Error: ")
	get_tree().set_network_peer(null)
	glb.fl_connected = false
	
func _on_connection_succeeded():
	$scr/bg/lb_print.text = str($scr/bg/lb_print.text,"\n","Connection succeded - ")
	glb.fl_connected = true
	$btn_bg/btn.text = "disconnect"

#----------------- network communications ---------------------

func _on_packets_received(id,packet):
	#id == 1: id = "Server"
	glb.log_print( "NETWORK: <- %s - %s"%[ id , bytes2var(packet) ] )
	if id == 1:
		cmd_from_server(bytes2var(packet))

func send_msg_data(dat, id = 0):
	#id == 0: all peers
	var err = get_tree().multiplayer.send_bytes(var2bytes(dat),id)
	if err == OK:
		glb.log_print( "NETWORK: -> %s - %s"%[ id , dat ] )
	else:
		glb.log_print( "NETWORK: unable to send %s - %s\nError: %s"%[ id , dat , err] )

func cmd_from_server(cmd):
	print("NETWORK: Server commands - %s"%[cmd])