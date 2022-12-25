extends "res://Entities/Antcestor.gd"
#Enemy variables
var redstripes = true
#var AItype = "advancing left" #Will move left unless it can attack something
var lefttilevalue = 0
var uplefttilevalue = 0
var uptilevalue = 0
var uprighttilevalue = 0
var righttilevalue = 0
var downrighttilevalue = 0
var downtilevalue = 0
var downlefttilevalue = 0
var spacebarvalue = 0
var spacebarpriority = 100 #The value the spacebarability has if it can be used
const closesttilepriority = 20 #The bonus priority value given to the tile closest to the queen
var numberoftopvaluetiles = 1
var valuearray = []
var chosentile
var path
#var hasWaited = false


#func _process(delta):
#	if gyne == null:
#		queue_free()


func do():
#	$MovementCircles.detect_obstacles()
#	$MovementCircles.movement_update()
#	selected = true
	thinking = true
	yield(get_tree(), "idle_frame") #Wait one frame
	
	if not moved:
		moved = true
		selected = false
		$MovementCircles.showcircles = true
		$WaitTimer.start()
		yield($WaitTimer, "timeout")
		
		
		AI()
		update_occupied_tile()
		
		thinking = false
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


class TileSorter:
	static func sort_tile_values(a, b):
		if a[0] < b[0]:
			return true
		return false
		

func AI():
	
	#Calculate tiles weight:
	
	lefttilevalue = calculate_base_value(canmoveleft)
	uplefttilevalue = calculate_base_value(canmoveupleft)
	uptilevalue = calculate_base_value(canmoveup)
	uprighttilevalue = calculate_base_value(canmoveupright)
	righttilevalue = calculate_base_value(canmoveright)
	downrighttilevalue = calculate_base_value(canmovedownright)
	downtilevalue = calculate_base_value(canmovedown)
	downlefttilevalue = calculate_base_value(canmovedownleft)
	
	if hasspacebarability and can_use_spacebar_ability():
		spacebarvalue = spacebarpriority
	else:
		spacebarvalue = -1
	
#	if allygyne != gyne:
#
#		if allygyne.occupiedxtile < occupiedxtile: #If it is to the right of the queen
#
#			if allygyne.occupiedytile < occupiedytile: #If it is below the queen
#
#				if allygyne.occupiedytile - occupiedytile < allygyne.occupiedxtile - occupiedxtile: #If it is further to the queen in the x-axis
#					lefttilevalue += closesttilepriority
#					uplefttilevalue += closesttilepriority
#					uptilevalue += closesttilepriority / 2
#				elif allygyne.occupiedytile - occupiedytile > allygyne.occupiedxtile - occupiedxtile: #If it is further to the queen in the y-axis
#					uptilevalue += closesttilepriority
#					uplefttilevalue += closesttilepriority
#					lefttilevalue += closesttilepriority / 2
#				else: #If it is equally as far from the queen in both axes
#					lefttilevalue += closesttilepriority
#					uplefttilevalue += closesttilepriority
#					uptilevalue += closesttilepriority
#
#
#
#			else: #If it is neither abover nor below the queen
#				lefttilevalue += 20
	
	
	
	#Detects enemies and adds their values to the weight calculations
	for l in players.get_child_count():
		if not players.get_child(l) == ownallies:
			for i in players.get_child(l).get_child_count():
				
				#If there is an entity to the left
				if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile - 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile:
					if lefttilevalue >= 0:
						lefttilevalue += players.get_child(l).get_child(i).value
				
				#If there is an entity to the upleft
				elif players.get_child(l).get_child(i).occupiedxtile == occupiedxtile - 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile - 1:
					if uplefttilevalue >= 0:
						uplefttilevalue += players.get_child(l).get_child(i).value
				
				#If there is an entity to the up
				elif players.get_child(l).get_child(i).occupiedxtile == occupiedxtile and players.get_child(l).get_child(i).occupiedytile == occupiedytile - 1:
					if uptilevalue >= 0:
						uptilevalue += players.get_child(l).get_child(i).value
				
				#If there is an entity to the upright
				elif players.get_child(l).get_child(i).occupiedxtile == occupiedxtile + 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile - 1:
					if uprighttilevalue >= 0:
						uprighttilevalue += players.get_child(l).get_child(i).value
				
				#If there is an entity to the right
				elif players.get_child(l).get_child(i).occupiedxtile == occupiedxtile + 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile:
					if righttilevalue >= 0:
						righttilevalue += players.get_child(l).get_child(i).value
				
				#If there is an entity to the downright
				elif players.get_child(l).get_child(i).occupiedxtile == occupiedxtile + 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile + 1:
					if downrighttilevalue >= 0:
						downrighttilevalue += players.get_child(l).get_child(i).value
				
				#If there is an entity to the down
				elif players.get_child(l).get_child(i).occupiedxtile == occupiedxtile and players.get_child(l).get_child(i).occupiedytile == occupiedytile + 1:
					if downtilevalue >= 0:
						downtilevalue += players.get_child(l).get_child(i).value
				
				#If there is an entity to the downleft
				elif players.get_child(l).get_child(i).occupiedxtile == occupiedxtile - 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile + 1:
					if downlefttilevalue >= 0:
						downlefttilevalue += players.get_child(l).get_child(i).value
	
	
	get_target()
	if path.size() > 1:
		var nexttilex = (path[1].x + 64 - self.global_position.x) / 128
		var nexttiley = (path[1].y + 64 - self.global_position.y) / 128
		#print(str(nexttilex) + ", " + str(nexttiley))
		#print((path[1]+Vector2(64,64))/128)
		
		if nexttilex == -1 and nexttiley == 0:
			lefttilevalue += closesttilepriority
		elif nexttilex == -1 and nexttiley == -1:
			uplefttilevalue += closesttilepriority
		elif nexttilex == 0 and nexttiley == -1:
			uptilevalue += closesttilepriority
		elif nexttilex == 1 and nexttiley == -1:
			uprighttilevalue += closesttilepriority
		elif nexttilex == 1 and nexttiley == 0:
			righttilevalue += closesttilepriority
		elif nexttilex == 1 and nexttiley == 1:
			downrighttilevalue += closesttilepriority
		elif nexttilex == 0 and nexttiley == 1:
			downtilevalue += closesttilepriority
		elif nexttilex == -1 and nexttiley == 1:
			downlefttilevalue += closesttilepriority
	
	#Find a tile to move to:
	valuearray = [[lefttilevalue, "lefttilevalue"], [uplefttilevalue, "uplefttilevalue"], [uptilevalue, "uptilevalue"],
	[uprighttilevalue, "uprighttilevalue"], [righttilevalue, "righttilevalue"], [downrighttilevalue, "downrighttilevalue"],
	[downtilevalue, "downtilevalue"], [downlefttilevalue, "downlefttilevalue"], [spacebarvalue, "spacebarvalue"]]
	valuearray.sort_custom(TileSorter, "sort_tile_values")
	numberoftopvaluetiles = 1
	
	#Finds the number of tiles which has most value
	if valuearray[valuearray.size()-1][0] == valuearray[valuearray.size()-2][0]:
		if valuearray[valuearray.size()-2][0] == valuearray[valuearray.size()-3][0]:
			if valuearray[valuearray.size()-3][0] == valuearray[valuearray.size()-4][0]:
				if valuearray[valuearray.size()-4][0] == valuearray[valuearray.size()-5][0]:
					if valuearray[valuearray.size()-5][0] == valuearray[valuearray.size()-6][0]:
						if valuearray[valuearray.size()-6][0] == valuearray[valuearray.size()-7][0]:
							if valuearray[valuearray.size()-7][0] == valuearray[valuearray.size()-8][0]:
								if valuearray[valuearray.size()-8][0] == valuearray[valuearray.size()-9][0]:
									numberoftopvaluetiles += 1
								numberoftopvaluetiles += 1
							numberoftopvaluetiles += 1
						numberoftopvaluetiles += 1
					numberoftopvaluetiles += 1
				numberoftopvaluetiles += 1
			numberoftopvaluetiles += 1
		numberoftopvaluetiles += 1
	
	
	#Moves the enemy to the chosen tile
	chosentile = valuearray[8-randi() % numberoftopvaluetiles][1] #Randomly choose the highest value tile if there is more than 1
	#print(chosentile)
	
	if chosentile == "lefttilevalue":
		if canmoveleft == 2:
			for l in players.get_child_count():
				for i in players.get_child(l).get_child_count():
					if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile - 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile:
						actually_attack(0,-1,l,i)
		elif canmoveleft == 1:
			occupiedtile -= 1
	
	elif chosentile == "uplefttilevalue":
		if canmoveupleft == 2:
			for l in players.get_child_count():
				for i in players.get_child(l).get_child_count():
					if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile - 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile - 1:
						actually_attack(-1,-1,l,i)
	
	elif chosentile == "uptilevalue":
		if canmoveup == 2:
			for l in players.get_child_count():
				for i in players.get_child(l).get_child_count():
					if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile and players.get_child(l).get_child(i).occupiedytile == occupiedytile - 1:
						actually_attack(-1,0,l,i)
		elif canmoveup == 1:
			occupiedtile -= arena.arenalength
	
	elif chosentile == "uprighttilevalue":
		if canmoveupright == 2:
			for l in players.get_child_count():
				for i in players.get_child(l).get_child_count():
					if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile + 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile - 1:
						actually_attack(-1,1,l,i)
	
	elif chosentile == "righttilevalue":
		if canmoveright == 2:
			for l in players.get_child_count():
				for i in players.get_child(l).get_child_count():
					if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile + 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile:
						actually_attack(0,1,l,i)
		elif canmoveright == 1:
			occupiedtile += 1
	
	elif chosentile == "downrighttilevalue":
		if canmovedownright == 2:
			for l in players.get_child_count():
				for i in players.get_child(l).get_child_count():
					if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile + 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile + 1:
						actually_attack(1,1,l,i)
	
	elif chosentile == "downtilevalue":
		if canmovedown == 2:
			for l in players.get_child_count():
				for i in players.get_child(l).get_child_count():
					if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile and players.get_child(l).get_child(i).occupiedytile == occupiedytile + 1:
						actually_attack(1,0,l,i)
		elif canmovedown == 1:
			occupiedtile += arena.arenalength
	
	elif chosentile == "downlefttilevalue":
		if canmovedownleft == 2:
			for l in players.get_child_count():
				for i in players.get_child(l).get_child_count():
					if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile - 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile + 1:
						actually_attack(1,-1,l,i)
	
	elif chosentile == "spacebarvalue":
		spacebar_ability()
	


func calculate_base_value(canmove):
	#if it can move to the tile make the base value 10
	if canmove == 0:
		return(-1)
	else:
		return(10)


func get_target():
	var allygyne = players.get_child(1).get_node("Gyne")
	path = arena.get_node("TileMap").get_astar_path_avoiding_obstacles(self.global_position - Vector2(64,64), allygyne.global_position - Vector2(64,64))


#func AI(): #Calculate where it will go
#	#All the AI stuff under here
#
##	return
#
#	if hasspacebarability and can_use_spacebar_ability():
#		spacebar_ability()
#
#	elif canmoveupright == 2:
#		for l in players.get_child_count():
#			for i in players.get_child(l).get_child_count():
#				if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile + 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile - 1:
#					actually_attack(-1,1,l,i)
#	elif canmovedownright == 2:
#		for l in players.get_child_count():
#			for i in players.get_child(l).get_child_count():
#				if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile + 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile + 1:
#					actually_attack(1,1,l,i)
#	elif canmoveright == 2:
#		for l in players.get_child_count():
#			for i in players.get_child(l).get_child_count():
#				if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile + 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile:
#					actually_attack(0,1,l,i)
#	elif canmoveup == 2:
#		for l in players.get_child_count():
#			for i in players.get_child(l).get_child_count():
#				if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile and players.get_child(l).get_child(i).occupiedytile == occupiedytile - 1:
#					actually_attack(-1,0,l,i)
#	elif canmovedown == 2:
#		for l in players.get_child_count():
#			for i in players.get_child(l).get_child_count():
#				if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile and players.get_child(l).get_child(i).occupiedytile == occupiedytile + 1:
#					actually_attack(1,0,l,i)
#	elif canmoveupleft == 2:
#		for l in players.get_child_count():
#			for i in players.get_child(l).get_child_count():
#				if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile - 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile - 1:
#					actually_attack(-1,-1,l,i)
#	elif canmovedownleft == 2:
#		for l in players.get_child_count():
#			for i in players.get_child(l).get_child_count():
#				if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile - 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile + 1:
#					actually_attack(1,-1,l,i)
#	elif canmoveleft == 2:
#		for l in players.get_child_count():
#			for i in players.get_child(l).get_child_count():
#				if players.get_child(l).get_child(i).occupiedxtile == occupiedxtile - 1 and players.get_child(l).get_child(i).occupiedytile == occupiedytile:
#					actually_attack(0,-1,l,i)
#
#
#	elif canmoveleft == 1:
#		occupiedtile -= 1
#	elif canmoveup == 1:
#		occupiedtile -= arena.arenalength
#	elif canmovedown == 1:
#		occupiedtile += arena.arenalength
#	elif canmoveright == 1:
#		occupiedtile += 1
#
#
##		position = arena.tiles[occupiedtile]
##	if canmoveleft == 2:
##		pass
##	if canmoveright == 2:
##		pass
#
#
