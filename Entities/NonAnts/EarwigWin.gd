extends "res://Entities/NonAnts/Earwig.gd"

func damage(damage, aggressor): #Takes damage
	health -= damage
	
	var damagelabel = load("res://Entities/DamageLabel.tscn").instance()
	arena.add_child(damagelabel)
	damagelabel.start(-damage, global_position)
	
	$AnimationTimer.start()
#	if damage >= health:
	if health <= 0:
		dead = true
		moved = true
		selected = false
		$MovementCircles.modulate_circles()
		if aggressor != null:
			
			for l in players.get_child_count(): #If there is an entity/obstacle on this entity, don't get conquered
				for i in players.get_child(l).get_child_count(): 
					if players.get_child(l).get_child(i).occupiedtile == occupiedtile:
						if not players.get_child(l).get_child(i) == self:
							return
			
#			for i in ownallies.get_child_count(): #If there is an entity on this entity, don't get conquered
#				if ownallies.get_child(i).occupiedtile == occupiedtile:
#					if not ownallies.get_child(i) == self:
#						return
			aggressor.conquer(occupiedtile)
			arena.end_game(true)
			
			if aggressor.isant:
				$ResourceGainTimer.start()
				yield($ResourceGainTimer, "timeout")
				var resourcelabel = load("res://Entities/DamageLabel.tscn").instance()
				arena.add_child(resourcelabel)
				resourcelabel.change_type(Color(0,1,0), load("res://Sprites/Level/Resource.png"))
				resourcelabel.start(resourcegain, arena.tiles[occupiedtile])
				aggressor.ownallies.resources += resourcegain
