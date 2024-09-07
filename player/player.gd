extends CharacterBody2D
@export var cam_zoom = [1.5,1.7]
var health = Game.Player_health
var alive = 1
var base_damage = 0
var base_shoot_speed=0
var back_scale=0.5
var proof = 0
const SPEED = 300.0
const JUMP_VELOCITY = -450.0
var A = 400
var on_stair = 0
var step_stair_high = 8
var tween
@onready var anim = get_node("AnimationPlayer")

func _ready():
	self.floor_block_on_wall=true
	self.floor_max_angle=PI/4
	$Camera2D.zoom = Vector2(cam_zoom[0],cam_zoom[0])
	$Camera2D.limit_left=$"../..".limit[0]
	$Camera2D.limit_right=$"../..".limit[1]
	$Camera2D.limit_top=$"../..".limit[2]
	$Camera2D.limit_bottom=$"../..".limit[3]
func _process(delta):
	if health>Game.Player_health:
		health=Game.Player_health

func _physics_process(delta):
	if velocity.length()>400: velocity.normalized()*SPEED
	if health>0:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			anim.play("jump")
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction==-1:
			get_node("AnimatedSprite2D").flip_h=true
		elif direction==1 :
			get_node("AnimatedSprite2D").flip_h=false
		if direction:
			up_stair(direction)
			velocity.x = move_toward(velocity.x, direction*SPEED, A)
			if velocity.y == 0:
				anim.play("run")
			elif velocity.y<0:
				anim.play("jump")
		else:
			if velocity.y == 0:
				anim.play("idle")
			velocity.x = move_toward(velocity.x, 0, A)
			
		if velocity.y>0:
				anim.play("fall")
		move_and_slide()
	else:
		if alive:
			alive=0
			death()

func _on_proof_time_timeout():
	proof=0
	A = 400
	$proof_time.start()
	
func hurt(damage,back_velocity):
	if !proof and !$"../..".proof:
		proof = 1;
		A=100
		$proof_time.start()
		health-=damage
		velocity+=back_velocity*back_scale
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.tween_property(self,"modulate",Color.RED,0.2)
		tween.tween_property(get_node("Camera2D"),"zoom",Vector2(cam_zoom[1],cam_zoom[1]),0.1)
		tween.tween_property(get_node("Camera2D"),"zoom",Vector2(cam_zoom[0],cam_zoom[0]),0.15)
		tween.tween_callback(self.set_modulate.bind(Color.WHITE))
	
func death():
	anim.play("dead")
	await anim.animation_finished
	Game.Player_Gold=0
	Game.exp = 0
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",Vector2(0,-200)+self.position,0.7)
	tween.tween_property(self,"modulate:a",0,0.5)
	Utils.save_game()
	tween.tween_callback(get_tree().change_scene_to_file.bind("res://main.tscn"))
	
func up_stair(direction):
	if on_stair and is_on_floor():
		if direction==on_stair:
			position.y-=step_stair_high
			on_stair=0
		
	
