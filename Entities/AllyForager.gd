extends "res://Entities/Mover.gd"

var efficiency = 1
var harvestableresources = ["grass"]
var satnest = load("res://Entities/AncestorSatelliteNest.tscn")
onready var satnestcost = get_parent().get_node("Gyne").troopcost * 1.5


func constructor():
	#self.texture = load("res://Sprites/Entities/ForagerAlly.png") #Assigns sprite's texture
	self.texture = null
	
	#$Highlight.texture = load("res://Sprites/Entities/ForagerHighlight.png") #Assigns highlights's texture
	health = 20
	strength = 5
	efficiency = 0.5
	canattack = false
	hasspacebarability = true
	animationplayer = load("res://Entities/Animations/AntimationsHD.tscn")
	tilescale = 1
	isforager = true


func set_up_shadow():
	shadow = get_node("AntmationsHD/Shadow")

#func _ready():
##	animation = $AntmationsHD/AntimationPlayer.start_anim(true, "LasiusTroopIdle")
#	antimation()


func turn_into_sat_nest():
	var newant = satnest.instance()
	ownallies.add_child(newant)
	newant.occupiedtile = occupiedtile
	newant.position = position
	ownallies.resources -= satnestcost
	dead = true
	get_tree().call_group("Arena", "arena_update")
	queue_free()


func spacebar_ability():
	#Harvests a resource
	
	for i in resources.get_child_count():
		if resources.get_child(i).occupiedxtile == occupiedxtile and resources.get_child(i).occupiedytile == occupiedytile:
			ownallies.resources += resources.get_child(i).resources * efficiency
			
			var resourcelabel = load("res://Entities/DamageLabel.tscn").instance()
			arena.add_child(resourcelabel)
			resourcelabel.change_type(Color(0,1,0), load("res://Sprites/Level/Resource.png"))
			resourcelabel.start(resources.get_child(i).resources * efficiency, position)
			resourcelabel._on_HalfTimer_timeout()
	
#	ownallies.resources += 1
	moved = true
	ownallies.check_resources()
	get_tree().call_group("Arena", "arena_update")
#	print(ownallies.resources)

func can_use_spacebar_ability():
	#Can only harvest on grass tiles
	if arena.get_node("TileMap").get_cell(position.x/128,position.y/128) == 0 or arena.get_node("TileMap").get_cell(position.x/128,position.y/128) == 2:
		return true
	
	#Detects resources in Resources node
	for i in resources.get_child_count():
		if resources.get_child(i).occupiedxtile == occupiedxtile and resources.get_child(i).occupiedytile == occupiedytile and can_harvest_resource(resources.get_child(i)):
			return true
	
	
	
	return false


func can_harvest_resource(resource):
	for i in harvestableresources.size():
		if harvestableresources[i] == resource.croptype:
			return true
	return false


func antimation():
	animation = "LasiusTroopIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
