extends CharacterBody2D

var A = 300
var Value = 1
var SPEED = 500
var JUMP_VELOCITY = -350.0
var DAMAGE = 1
var back_scale = 0.5 #self hit back
var HP = 50
var m = 10 #hit back
var exp = 10
var IDLE_VELOCITY = 100.0
var proof = 0 # cant be hurted
var hunting = 0 #find player
var player
var alive = 1
var direction = Vector2(0,0)
var random_turn_timer
@onready var anim = get_node("AnimatedSprite2D")
@onready var proof_timmer = $proof_timer
var t = 0 
var tween
var gem
func _ready():
	random_turn_timer = get_node("Timer")
	random_turn_timer.start()
	gem = preload("res://Item/gem.tscn")
	gem = gem.instantiate()
	gem.value = Value


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func _on_timer_timeout():
	if randi_range(0,1):
		IDLE_VELOCITY = -IDLE_VELOCITY
	else:
		velocity.y=JUMP_VELOCITY
		
	random_turn_timer.set_wait_time(randf_range(2.0, 5.0))  # 初始等待时间随机
	random_turn_timer.start()
	

func _process(delta):
	if alive:
		if velocity.length()>0:
			anim.play("walk")
		if velocity.x>0:
			get_node("AnimatedSprite2D").flip_h=false
		elif velocity.x<0:
			get_node("AnimatedSprite2D").flip_h=true
		if hunting:
			direction = (player.global_position-self.global_position).normalized()
			if direction.x>0:
				velocity.x = min(SPEED,velocity.x+A*delta)
			elif direction.x<0:
				velocity.x= max(-SPEED,velocity.x-A*delta)
			if direction.y<-0.4 and is_on_floor() or direction.y<0.1 and (player.global_position-self.global_position).length()>400:
				velocity.y=JUMP_VELOCITY
		else:
			velocity.x = IDLE_VELOCITY


func _on_detection_body_entered(body):
	if body.name=="player":
		player = get_node("../../../Player/player")
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

func _on_killed_body_entered(body):
	if direction.y<-0.7 and body.get_parent().name =="Player" and alive:
		Game.Player_Gold+=Value*3
		Game.exp+=exp*2
		death()


func _on_hurt_body_entered(body):
	if alive and body.get_parent().name =="Player":
		alive=0
		velocity.y=0
		body.hurt(DAMAGE*velocity.length()/100,velocity*m)
		death()		
		


func _on_proof_timer_timeout():
	self.modulate=Color.WHITE
	proof=0
