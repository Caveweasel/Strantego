extends "res://Entities/Antcestor.gd"
#Enemy variables
var AItype = "random aggressive" #Will move randomly unless it can attack something
#var hasWaited = false


#func _process(delta):
#	if gyne == null:
#		queue_free()


func do():
#	$MovementCircles.detect_obstacles()
#	$MovementCircles.movement_update()
#	selected = true
	moved = true
	selected = false
	$MovementCircles.showcircles = true
	$WaitTimer.start()
	yield($WaitTimer, "timeout")
	
	
	AI()
	update_occupied_tile()
	
	get_tree().call_group("Arena", "arena_update") #Updates the arena to let everyone else know where this entity is
	
	var tween = $MovementTween
	tween.interpolate_property(self, "position",
	position, arena.tiles[occupiedtile], 0.5,
	Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	
	
	$WaitTimer.start()
	yield($WaitTimer, "timeout")
#	get_tree().call_group("Arena", "arena_update")


func is_AI():
	isAI = true


func AI(): #Calculate where it will go
	#All the AI stuff under here
	
#	return
	
	if hasspacebarability and can_use_spacebar_ability():
		spacebar_ability()
	
	elif canmoveupright == 2:
		for l in players.get_child_count():
			for i in players.get_child(l).get_child_count():
				if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile + 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile - 1:
					actually_attack(-1,1,l,i)
	elif canmovedownright == 2:
		for l in players.get_child_count():
			for i in players.get_child(l).get_child_count():
				if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile + 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile + 1:
					actually_attack(1,1,l,i)
	elif canmoveright == 2:
		for l in players.get_child_count():
			for i in players.get_child(l).get_child_count():
				if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile + 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile:
					actually_attack(0,1,l,i)
	elif canmoveup == 2:
		for l in players.get_child_count():
			for i in players.get_child(l).get_child_count():
				if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile and players.get_child(l).get_child(i).occupiedytile == occupiedytile - 1:
					actually_attack(-1,0,l,i)
	elif canmovedown == 2:
		for l in players.get_child_count():
			for i in players.get_child(l).get_child_count():
				if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile and players.get_child(l).get_child(i).occupiedytile == occupiedytile + 1:
					actually_attack(1,0,l,i)
	elif canmoveupleft == 2:
		for l in players.get_child_count():
			for i in players.get_child(l).get_child_count():
				if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile - 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile - 1:
					actually_attack(-1,-1,l,i)
	elif canmovedownleft == 2:
		for l in players.get_child_count():
			for i in players.get_child(l).get_child_count():
				if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile - 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile + 1:
					actually_attack(1,-1,l,i)
	elif canmoveleft == 2:
		for l in players.get_child_count():
			for i in players.get_child(l).get_child_count():
				if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile - 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile:
					actually_attack(0,-1,l,i)
	
	
	elif canmoveleft == 1:
		occupiedtile -= 1
	elif canmoveup == 1:
		occupiedtile -= arena.arenalength
	elif canmovedown == 1:
		occupiedtile += arena.arenalength
	elif canmoveright == 1:
		occupiedtile += 1
	
	
#		position = arena.tiles[occupiedtile]
#	if canmoveleft == 2:
#		pass
#	if canmoveright == 2:
#		pass


