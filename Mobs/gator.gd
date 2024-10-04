extends CharacterBody2D

var A = 200
var Value = 5
var SPEED = 200
var JUMP_VELOCITY = -350.0
var DAMAGE = 3
var back_scale = 0.5 #self hit back
var HP = 20
var m = 5 #hit back
var exp = 20
var IDLE_VELOCITY = 100.0
var proof = 0 # cant be hurted
var hunting = 0 #find player
var alive = 1
var direction = Vector2(0,0)
var random_turn_timer
@onready var anim = get_node("AnimatedSprite2D")
@onready var player = $"../../../Player/player"
@onready var proof_timmer = $proof_timer
var t = 0 
var tween
var gem
var bullet
var ok
func _ready():
	random_turn_timer = get_node("Timer")
	random_turn_timer.start()
	bullet = preload("res://Mobs/gater_bullet.tscn")
	gem = preload("res://Item/gem.tscn")
	gem = gem.instantiate()
	gem.scale*=1.5
	gem.value = Value

func _physics_process(delta):
	if alive and player:
		if velocity.length()>SPEED:
			velocity = velocity.normalized()*SPEED
		if is_on_floor():
			velocity.y=-100
		if velocity.x>0:
			get_node("AnimatedSprite2D").flip_h=true
		elif velocity.x<0:
			get_node("AnimatedSprite2D").flip_h=false
		direction = (player.position-position)
		if abs(direction.y)>100 or abs(direction.x)>250:
			velocity += (direction.normalized()+Vector2(randf_range(-0.3,0.3),randf_range(-0.1,0.1)))*A*delta
		else:
			velocity -= (direction.normalized()+Vector2(randf_range(-0.5,0.5),randf_range(-0.2,0.2)))*A*2*delta

		move_and_slide()

func _on_timer_timeout():
	velocity = Vector2(randf_range(-0.5,0.5),randf_range(-0.5,0.5))*SPEED
	random_turn_timer.set_wait_time(randf_range(2.0, 5.0))  # 初始等待时间随机
	random_turn_timer.start()
	
			


func _on_detection_body_entered(body):
	if body.get_parent().name =="Player":
		player=body
		random_turn_timer.stop()
		hunting=1



func _on_detection_body_exited(body):
	if body.get_parent().name =="Player":
		random_turn_timer.start()
		hunting=0
		velocity = Vector2(IDLE_VELOCITY,0)

func death():
	hunting=0
	velocity = Vector2(0,0)
	alive=0
	anim.play("dead")
	await anim.animation_finished
	self.queue_free()

func hurt(damage,back_velocity):
	if !proof:
		velocity+=back_velocity*back_scale
		HP-= damage
		velocity.x *= 0.5
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.tween_property(self,"modulate",Color.RED,0.1)
		tween.tween_callback(self.set_modulate.bind(Color.WHITE))
		#proof = 1
		#proof_timmer.start()
		self.modulate=Color.RED
		
	if HP<=0:
		HP=100
		proof=1
		gem.global_position = global_position
		$"../../../collect/Collections".add_child(gem)
		Game.exp+=exp
		death()


func _on_hurt_body_entered(body):
	if alive and body.get_parent().name =="Player":
		alive=0
		velocity.y=0
		player.hurt(DAMAGE*velocity.length()/100,velocity*m)
		


func _on_proof_timer_timeout():
	self.modulate=Color.WHITE
	proof=0


func _on_shoot_timer_timeout():
	if hunting and player:
		var temp = bullet.instantiate()
		temp.global_position = global_position
		temp.player = player
		temp.direction = direction
		temp.m*=scale.length()
		$Node2D.add_child(temp)
		$Shoot_timer.wait_time=randf_range(0.3,3)
