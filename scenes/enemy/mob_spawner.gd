extends Path2D

@export var MobToSpawn: PackedScene = preload("res://scenes/enemy/enemy.tscn")

func _on_spawn_timer_timeout() -> void:
	$SpawnPoint.progress_ratio = randf()
	var mob_to_spawn : Area2D = MobToSpawn.instantiate()
	mob_to_spawn.global_position = $SpawnPoint.global_position
	var player : CharacterBody2D = get_parent().get_node("Player")
	if player:
		mob_to_spawn.look_at(get_parent().get_node("Player").global_position)
	get_parent().add_child(mob_to_spawn)
