extends Area2D

@export var damage_to_deal = 20.0
const SPEED = 500.0

func _physics_process(delta: float) -> void:
	global_position += Vector2.RIGHT.rotated(rotation) * SPEED * delta

func _on_lifetime_timeout() -> void:
	queue_free()
