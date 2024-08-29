extends CharacterBody2D

var Bullet = preload("res://scenes/projectiles/bullet.tscn")
var GameOverScreen = preload("res://scenes/user_interface/game_over_screen.tscn")

const SPEED: float = 100.0
var direction_vector: Vector2
@export var health: float = 200.0

func _unhandled_input(event: InputEvent) -> void:
	# `.is_action_pressed()` takes in the string of actions (key presses) we have defined in
	# the project settings' "Input Map".
	if event.is_action_pressed("shoot_bullet"):
		shoot_bullet()

# This function runs every frame. Without any lag, this runs 60 times per second
func _physics_process(delta: float) -> void:
	# Calculate the unit vector representing the direction to the mouse
	direction_vector = (get_global_mouse_position() - global_position).normalized()
	# `velocity` is a property of this node: `CharacterBody2D`
	velocity = direction_vector * SPEED
	# `move_and_slide() is a method specific to `CharacterBody2D` that helps us move the node for us
	move_and_slide()
	# `look_at()` is a helpful function to turn the player node to face a certain point
	look_at(get_global_mouse_position())

func die() -> void:
	# We take the "Class" and create an object out of it and assign this object to a variable
	var game_over_screen = GameOverScreen.instantiate()
	# We want this screen to be part of the map, not part of us, else it will die along with us :P
	get_parent().add_child(game_over_screen)
	# We remove ourselves from the game
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
	# We make it face where we are pointing
	bullet.look_at(get_global_mouse_position())
	# The collision_layer expects binary bits. Since we want layer 3 ONLY which is bit 2 (b'0100), 
	# we put 4
	bullet.collision_layer = 4

func _on_hurtbox_area_entered(area: Area2D) -> void:
	# The `damage_to_deal` will be a property of each damaging area we make
	area.queue_free()
	receive_damage(area.damage_to_deal)
