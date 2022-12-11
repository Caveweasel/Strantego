extends "res://Entities/AncestorSatelliteNest.gd"


func _ready():
	troop = load("res://Entities/Ants/Lasius/LflavusAllyTroop.tscn")
	troopcost = 25
	troopincubationtime = 3
	#occupiedtile = arena.arenalength
	
	shadow = get_node("AntmationsHD/Shadow")
	species = "Lasius flavus"
	
	animationplayer = load("res://Entities/Animations/LasiusAnimations/AntmationsHDflavusGyne.tscn")
	antimation()
	tilescale = 2


func antimation():
	animation = "LasiusGyneIdle"
	$AntmationsHD/AntimationPlayer.start_anim(null, animation)
