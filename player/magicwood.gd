extends Node2D
const base_speed = 4
const base_damage = 3
@onready var player = $"../.."
var shot_speed
var damage
var direction = Vector2.UP
var mouse_press = 0
var bullet = preload("res://player/bullet.tscn")

func shoot():
	var temp = bullet.instantiate()
	temp.global_position = $Magicwood.global_position
	temp.global_rotation = global_rotation
	temp.direction = direction
	$Node.add_child(temp)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../..")
	shot_speed = player.base_shoot_speed+base_speed
	damage = player.base_damage+base_damage
	$Timer.wait_time = 1.0/shot_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shot_speed != player.base_shoot_speed+base_speed:
		shot_speed = player.base_shoot_speed+base_speed
	if damage != player.base_damage+base_damage:
		damage = player.base_damage+base_damage
	$Timer.wait_time = 1.0/shot_speed
	direction = get_global_mouse_position()-global_position
	global_rotation=atan2(direction.x,-direction.y)
	if Input.is_action_just_pressed("click"):
		mouse_press=1
	if Input.is_action_just_released("click"):
		mouse_press=0


func _on_timer_timeout():
	if mouse_press:
		shoot()
