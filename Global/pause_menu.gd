extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !get_tree().paused and self.visible:
		self.visible = false


func _on_goon_pressed():
	get_tree().paused = false


func _on_quit_pressed():
	Utils.save_game()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")
