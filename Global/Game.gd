extends Node
const save_path = "res://chackpoint.bin"
var Player_health = 10
var Player_Gold = 0
var Player_level = 0
var exp=0
var Gate = 0
var load_ok = 0
var gen_emery = 1
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	Utils.load_game()
	load_ok = 1
	player = preload("res://player/Player.tscn")
	player = player.instantiate()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
