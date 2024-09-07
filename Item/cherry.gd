extends Area2D
var ok=1# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimatedSprite2D").play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name=="player" and ok:
		ok = 0
		body.health+=1
		var tween = get_tree().create_tween()
		tween.tween_property(self,"position",Vector2(0,-50)+position,0.5)
		tween.tween_property(self,"modulate:a",0,0.5)
		tween.tween_callback(queue_free)
