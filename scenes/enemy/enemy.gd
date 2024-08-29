extends Area2D

var Bullet: PackedScene = preload("res://scenes/projectiles/bullet.tscn")
const SPEED: float = 100.0
@export var health: float = 60.0
var DeathEffect: PackedScene = preload("res://scenes/effects/enemy_death_effect.tscn")

func _physics_process(delta):
	global_position += Vector2.RIGHT.rotated(rotation) * SPEED * delta

func die() -> void:
	var death_effect = DeathEffect.instantiate()
	death_effect.global_position = global_position
	death_effect.animation_finished.connect(death_effect.queue_free)
	get_parent().add_child(death_effect)
	queue_free()

func receive_damage(damage: float) -> void:
	health -= damage
	if health <= 0:
		die()

func shoot_bullet() -> void:
	# We take the "Class" and create an object out of it and assign this object to a variable
	var bullet = Bullet.instantiate()
	# We must place this missile in the game as a child of something.
	# It can't be us else it would move along with us, so we put it under the non-moving map.
	get_parent().add_child(bullet)
	# The new object needs a coordinate where it spawns
	bullet.global_position = global_position
	# We make it have the same rotation as the enemy itself
	bullet.global_rotation = global_rotation
	# The collision_layer expects binary bits. Since we want layer 2 ONLY which is bit 1 (b'0010),
	# we put 2
	bullet.collision_layer = 2

func _on_shoot_cooldown_timeout() -> void:
	shoot_bullet()

func _on_area_entered(area: Area2D) -> void:
	receive_damage(area.damage_to_deal)
	area.queue_free()

func _on_lifetime_timeout() -> void:
	die()
