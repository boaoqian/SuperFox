extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $start.disabled and Game.load_ok:
		$start.disabled=0


func _on_quit_button_down() -> void:
	Utils.save_game()
	get_tree().quit() # Replace with function body.


func _on_start_button_down() -> void:
	Utils.load_game()
	get_tree().change_scene_to_file("res://World/world.tscn") # Replace with function body.
