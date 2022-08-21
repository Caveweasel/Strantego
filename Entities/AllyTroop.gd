extends "res://Entities/Mover.gd"


func _init():
	self.texture = load("res://Sprites/Entities/TroopAlly.png") #Assigns sprite's texture
	$Highlight.texture = load("res://Sprites/Entities/TroopHighlight.png") #Assigns highlights's texture
	health = 30
	strength = 20



