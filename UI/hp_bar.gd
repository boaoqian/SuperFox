extends ProgressBar

@onready var player = $"../../Player/player"
# Called when the node enters the scene tree for the first time.
func _ready():
	self.max_value = 100+20*Game.Player_level
func _process(delta):
	if self.max_value != 100+20*Game.Player_level:
		self.max_value = 100+20*Game.Player_level
	if self.value!=Game.exp:
		self.value=Game.exp
