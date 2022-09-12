extends "res://Entities/Obstacles/DamageableObstacle.gd"
#onready var players = get_node("/root/BattleSceneTest/Players")

var producetimer = 0


func turn_rollover():
	if not dead:
		producetimer += 1
		if producetimer >= 2:
			for l in players.get_child_count(): #If there is an entity/obstacle on this entity, don't produce
				for i in players.get_child(l).get_child_count(): 
					if players.get_child(l).get_child(i).occupiedtile == occupiedtile:
						if not players.get_child(l).get_child(i) == self:
							return
			
			#Creates an entity on this tile
			var entity = load("res://Entities/NonAnts/NonAntcestor.tscn").instance()
			players.get_child(3).add_child(entity)
			entity.set_occupiedtile(occupiedtile)
			producetimer = 0
