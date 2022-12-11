extends "res://Entities/Antcestor.gd"


func do():
	selected = true


func _input(_event):
	if selected and moved == false: #Only if this entity is selected and can move
		if not shifting:
			if Input.is_action_just_pressed("ui_left"): #Makes the entity go left
				if canmoveleft == 1:
					occupiedtile -= 1
#					if occupiedtile < 0:
#						pass
					moved = true
					selected = false
					get_tree().call_group("Arena", "arena_update") #Updates the arena to let everyone else know where this entity is
				
				elif canmoveleft == 2: #Makes the entity attack left
					for l in players.get_child_count():
						for i in players.get_child(l).get_child_count():
							if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile - 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile:
								actually_attack(0,-1,l,i)
			
			
			elif Input.is_action_just_pressed("ui_right"):
				if canmoveright == 1:
					occupiedtile += 1
					moved = true
					selected = false
					get_tree().call_group("Arena", "arena_update")
				
				elif canmoveright == 2:
					for l in players.get_child_count():
						for i in players.get_child(l).get_child_count():
							if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile + 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile:
								actually_attack(0,1,l,i)
			
			
			elif Input.is_action_just_pressed("ui_up"): #Makes the entity go up
				if canmoveup == 1:
					occupiedtile -= arena.arenalength
					moved = true
					selected = false
					get_tree().call_group("Arena", "arena_update")
				
				elif canmoveup == 2:
					for l in players.get_child_count():
						for i in players.get_child(l).get_child_count():
							if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile and players.get_child(l).get_child(i).occupiedytile == occupiedytile - 1:
								actually_attack(-1,0,l,i)
			
			
			elif Input.is_action_just_pressed("ui_down"): #Makes the entity go down
				if canmovedown == 1:
					occupiedtile += arena.arenalength
					moved = true
					selected = false
					get_tree().call_group("Arena", "arena_update")
				
				elif canmovedown == 2:
					for l in players.get_child_count():
						for i in players.get_child(l).get_child_count():
							if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile and players.get_child(l).get_child(i).occupiedytile == occupiedytile + 1:
								actually_attack(1,0,l,i)
		
		
		else:
			if Input.is_action_just_pressed("ui_left"): #Makes the entity go up and left
				if canmoveupleft == 2: #Makes the entity attack up and left
					for l in players.get_child_count():
						for i in players.get_child(l).get_child_count():
							if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile - 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile - 1:
								actually_attack(-1,-1,l,i)
			
			
			elif Input.is_action_just_pressed("ui_right"):
				if canmovedownright == 2:
					for l in players.get_child_count():
						for i in players.get_child(l).get_child_count():
							if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile + 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile + 1:
								actually_attack(1,1,l,i)
			
			
			elif Input.is_action_just_pressed("ui_up"): #Makes the entity go up
				if canmoveupright == 2:
					for l in players.get_child_count():
						for i in players.get_child(l).get_child_count():
							if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile + 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile - 1:
								actually_attack(-1,1,l,i)
			
			
			elif Input.is_action_just_pressed("ui_down"): #Makes the entity go down
				if canmovedownleft == 2:
					for l in players.get_child_count():
						for i in players.get_child(l).get_child_count():
							if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile - 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile + 1:
								actually_attack(1,-1,l,i)
		
		if Input.is_action_just_pressed("ui_select"):
			if hasspacebarability and can_use_spacebar_ability():
				moved = true
				selected = false
				spacebar_ability()
				get_tree().call_group("Arena", "arena_update")
		
		
		if Input.is_action_just_pressed("delete"): #Skips turn
			moved = true
			selected = false
			get_tree().call_group("Arena", "arena_update")
		
		if Input.is_action_just_pressed("ui_cancel"): #Deselect this entity and select another
			for i in ownallies.get_child_count(): #Only deselects this entity if there are others to select
				if ownallies.get_child(i).moveable:
					if not ownallies.get_child(i).moved:
						if not ownallies.get_child(i) == self:
							selected = false
							skipthisentity = true
							get_tree().call_group("Arena", "arena_update")
		
		
		update_occupied_tile()
		
		var tween = $MovementTween
		tween.interpolate_property(self, "position",
		position, arena.tiles[occupiedtile], 0.5,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
