extends Node
func _ready():
	self.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
#level 0,1,2,3 {name:[func,discribe]}
var skills=[{"bigger":[bigger,"make your weapen bigger"],
			"stronger":[stronger,"make your damage higher"],
			"healthier":[health_boost,"incearse your max health"],
			"fast_shoot":[faster_shoot,"shoot faster!!"]},
			]

func bigger(player):
	player.get_node("Equipment").scale = Vector2(2,2)

func stronger(player):
	player.base_damage+=5
	print("dammage")
	
func health_boost(player):
	Game.Player_health += 5
	print("health_boost")

func faster_shoot(player):
	player.base_shoot_speed += 0.5
	print("fast_shoot")
