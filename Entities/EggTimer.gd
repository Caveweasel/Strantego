extends Node2D

onready var egg = load("res://Entities/Egg.tscn")
#add_child(egg.instance())
# + Vector2(128 / eggcount * (i + 1), 0)


func setup(eggcount):
	for i in eggcount:
		add_child(egg.instance())
		get_child(i).global_position = global_position + Vector2(128 / (eggcount + 1) * (i + 1), 0)
	
	get_child(0).texture = load("res://Sprites/EggVis.png")


func egg_update(eggs):
	for i in eggs:
		get_child(i).texture = load("res://Sprites/EggVis.png")


func reset():
	for i in get_child_count():
		get_child(i).queue_free()
