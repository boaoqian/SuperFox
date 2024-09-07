extends Node

func load_game():
	if FileAccess.file_exists(Game.save_path):
		var file = FileAccess.open(Game.save_path,FileAccess.READ)
		if not file.eof_reached():
			var data = JSON.parse_string(file.get_line())
			if data:
				Game.Player_health=data["hp"]
				Game.Player_Gold=data["gold"]
				Game.Gate=data["gate"]
				Game.Player_level=data["lv"]
		
		
func save_game():
	var file = FileAccess.open(Game.save_path,FileAccess.WRITE)
	var data = {
		"hp":Game.Player_health,
		"gold":Game.Player_Gold,
		"gate":Game.Gate,
		"lv":Game.Player_level
	}
	data = JSON.stringify(data)
	file.store_line(data)
	print("saved!")
	
