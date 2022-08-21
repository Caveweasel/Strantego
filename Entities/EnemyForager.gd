extends "res://Entities/EnemyAntcestor.gd"


func _init():
	self.texture = load("res://Sprites/Entities/ForagerEnemy.png") #Assigns sprite's texture
	$Highlight.color1 = Color(1,0.15,0.15,1)
	$Highlight.color2 = Color(1,0.25,0.25,1)
	$Highlight.texture = load("res://Sprites/Entities/ForagerHighlight.png") #Assigns highlights's texture
	health = 20
	strength = 0
	canattack = false
	hasspacebarability = true


func spacebar_ability():
		#Harvests a resource
	ownallies.resources += 1
	moved = true
	get_tree().call_group("Arena", "arena_update")
	print(ownallies.resources)


func can_use_spacebar_ability():
	#Can only harvest on grass tiles
	if arena.get_node("TileMap").get_cell(position.x/128,position.y/128) == 0 or arena.get_node("TileMap").get_cell(position.x/128,position.y/128) == 2:
		return true
	return false
	
