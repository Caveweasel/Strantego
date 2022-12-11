extends Node

onready var gyne = get_node("Gyne")

export var isAI = false
export var AIstartresourceamount = 30
var resources = 30 #How many resources you have
var maxresources = 100
#var enabled = true

func _ready():
	if not isAI:
		resources = get_node("/root/Global").startresourceamount
		maxresources = get_node("/root/Global").maxresourceamount
	else:
		resources = AIstartresourceamount


func check_resources():
	if resources > maxresources:
		resources = maxresources
	
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
