extends Node

onready var gyne = get_node("Gyne")

var resources = 20 #How many resources you have
var enabled = true


func check_resources():
	if resources > 100:
		resources = 100
	
#	if enabled:
#		if resources >= 2:
#			if gyne.producing == "forager":
#				if not gyne.eggtimer >= gyne.foragerincubationtime:
#					gyne.eggtimer += 1
#					get_node("Gyne/EggTimer").egg_update(gyne.eggtimer)
#					resources -= 2
#			elif gyne.producing == "troop":
#				if not gyne.eggtimer >= gyne.troopincubationtime:
#					gyne.eggtimer += 1
#					get_node("Gyne/EggTimer").egg_update(gyne.eggtimer)
#					resources -= 2


#func _process(_delta):
#	check_resources()
