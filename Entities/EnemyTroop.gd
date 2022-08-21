extends "res://Entities/EnemyAntcestor.gd"


func _init():
	self.texture = load("res://Sprites/Entities/TroopEnemy.png") #Assigns sprite's texture
	$Highlight.color1 = Color(1,0.15,0.15,1)
	$Highlight.color2 = Color(1,0.25,0.25,1)
	$Highlight.texture = load("res://Sprites/Entities/TroopHighlight.png") #Assigns highlights's texture
	health = 30
	strength = 20

