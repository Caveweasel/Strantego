extends "res://Entities/EnemyAntcestor.gd"

var efficiency = 1
var harvestableresources = ["grass"]


func constructor():
	#self.texture = load("res://Sprites/Entities/ForagerEnemy.png") #Assigns sprite's texture
	self.texture = null
#	$Highlight.color1 = Color(1,0.15,0.15,1)
#	$Highlight.color2 = Color(1,0.25,0.25,1)
#	$Highlight.texture = load("res://Sprites/Entities/ForagerHighlight.png") #Assigns highlights's texture
	health = 20
	strength = 5
	efficiency = 0.5
	hasspacebarability = true
	isforager = true
	animationplayer = load("res://Entities/Animations/AntimationsHD.tscn")
	tilescale = 1


func set_up_shadow():
	shadow = get_node("AntmationsHD/Shadow")


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


func get_target():
	#var allygyne = players.get_child(1).get_node("Gyne")
	var selectedresource = resources.get_child(0)
	var resourceoccupied = false
	
	for b in resources.get_child_count(): #For every resource
		
#		print(Vector2(global_position.distance_to(resources.get_child(b).global_position),
#			selectedresource.global_position.distance_to(resources.get_child(b).global_position)))
		
		#if global_position.distance_to(resources.get_child(b).global_position) < selectedresource.global_position.distance_to(resources.get_child(b).global_position): #If the distance to the resource is lower than the distance to the selected resource
		if global_position.distance_to(resources.get_child(b).global_position) < global_position.distance_to(selectedresource.global_position) and can_harvest_resource(resources.get_child(b)): #If the distance to the resource is lower than the distance to the selected resource
			resourceoccupied = false
			for l in players.get_child_count(): #If there is another entity on the resource, don't go to it
				for i in players.get_child(l).get_child_count():
					if players.get_child(l).get_child(i).occupiedtile == resources.get_child(b).occupiedtile:
						resourceoccupied = true
			
			if not resourceoccupied: #replace the selected resource
				selectedresource = resources.get_child(b)
	
	path = arena.get_node("TileMap").get_astar_path_avoiding_obstacles(self.global_position - Vector2(64,64), selectedresource.global_position - Vector2(64,64))



func antimation():
	animation = "LasiusTroopIdle"
	$AntmationsHD/AntimationPlayer.start_anim(isAI, animation)
