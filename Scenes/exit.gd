extends Area2D

@export var next_room_path: String
@export var next_spawn_name: String = "SpawnPlayer"
@export var current_room_path: String
@export var current_spawn_name: String = "SpawnPlayer"

func _on_body_entered(body: Node2D) -> void:
	if body.name != "bombman":
		return

	var shape := body.get_node("CollisionShape2D")
	shape.set_deferred("disabled", true)  # désactivation après la physique actuelle

	var level_manager := get_tree().current_scene.get_node("tab_manager")
	level_manager.call_deferred("load_tab", next_room_path, next_spawn_name)

func _on_timer_timeout():
	var level_manager := get_tree().current_scene.get_node("tab_manager")
	level_manager.call_deferred("load_tab", current_room_path, current_spawn_name)
	pass # Replace with function body.
