extends Area2D
const SPEED = 1500
@onready var DAMAGE = $"../..".damage
var hurt_player = 0
var m = 0.1
var b = PI/2
var direction = Vector2(1,0)
func _process(delta):
	if load:
		global_position+=delta*SPEED*direction.normalized()

func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body.get_parent().name =="Mobs":
		body.hurt(DAMAGE,SPEED*direction.normalized()*m)
	if body.get_parent().name =="Player" and hurt_player:
		body.hurt(DAMAGE,SPEED*direction.normalized()*m)
	elif body.get_parent().name =="Player":
		return
	queue_free()
