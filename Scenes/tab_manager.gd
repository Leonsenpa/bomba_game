extends Node

var current_tab: Node2D

func _ready():
	load_tab("res://Tableau/tab_1.tscn", "SpawnPlayer")

func load_tab(path: String, spawn_name: String):
	var player = get_node("../bombman")
	player.get_node("CollisionShape2D").disabled = true
	# supprimer l'ancien room
	if current_tab:
		current_tab.queue_free()

	var scene: PackedScene = load(path)
	if scene == null:
		push_error("Scene not found: %s" % path)
		return
		
	current_tab = scene.instantiate()
	add_child(current_tab)
	
	
	get_tree().current_scene.get_node("bombman").remove_bomb()
	
	# placer le joueur au bon spawn
	var spawn = current_tab.get_node(spawn_name)
	player.global_position = spawn.global_position
	await get_tree().process_frame

	player.get_node("CollisionShape2D").disabled = false
