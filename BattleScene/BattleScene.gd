extends Node2D
#Global variables
onready var players = $Players
#Arena variables
var arenalength = 5 #How long the arena is in tiles
var arenawidth = 3 #How wide the arena is in tiles
var tiles = [] #An array of tiles and their position
#var arenabiome #Which biome this arena is in
var turn #Whose turn it is
var turnnumber = 0 #Which turn it is

var selectedcolonynumber = 0 #Which number colony is the currently selected one
var selectedcolony #Which colony is the currently selected one


func _ready():
	#Assigns cameras position:
	$Camera.position.x = float(arenalength) / 2 * 128 - 64
	$Camera.position.y = float(arenawidth) / 2 * 128 + 64
#	arenabiome = plains()
	
	selectedcolony = players.get_child(selectedcolonynumber)
	
	#creates tiles
	for y in arenawidth:
		for x in arenalength:
			#print(y*arenalength+x)
			tiles.append(Vector2(x*128,y*128))
	#print(tiles)
	
	get_tree().call_group("Arena", "arena_ready")
	_on_NextTurnButton_pressed()
	get_tree().call_group("Arena", "movement_update")


func arena_update():
	select_movers()
	get_tree().call_group("Arena", "movement_update")
	# foreach PLayer
	#    for ally  in player.allies 
	#        #ally.movement_update()


#func plains(): #I need this function so I can send the arenabiome variable to Tilemap
#	pass


func _on_NextTurnButton_pressed():
	
	#selectedmover = 0
	$NextTurnButton.disabled = true
	
	
	if selectedcolonynumber >= players.get_child_count()-1:
		selectedcolonynumber = 1
		turnnumber += 1
		get_tree().call_group("Arena", "turn_rollover") #When all have finished their turns and the turns rollover
	
	else:
		selectedcolonynumber += 1
	
	selectedcolony = players.get_child(selectedcolonynumber)
	
	if not check_if_empty():
		
		
		#Makes allies moveable
		for i in selectedcolony.get_child_count():
			if selectedcolony.get_child(i).moveable:
				selectedcolony.get_child(i).moved = false
				selectedcolony.get_child(i).selected = false
		
		$Camera/GUI/KillButton.check_pressable(selectedcolony)
		
		get_tree().call_group("Arena", "turn_update")
		select_movers()
	else:
		_on_NextTurnButton_pressed()

	
func select_movers():
	
#	if not selectedcolony.get_child_count() == 0:
		#Selects a moveable entity to select
		for i in selectedcolony.get_child_count(): 
			if selectedcolony.get_child(i).moveable:
				if not selectedcolony.get_child(i).moved and not selectedcolony.get_child(i).skipthisentity and not selectedcolony.get_child(i).dead:
					selectedcolony.get_child(i).do()
					$Camera/GUI/InfoBox.refresh(selectedcolony.get_child(i))
					$Camera/GUI/KillButton.check(selectedcolony.get_child(i))
					return
		
		yield(get_tree(), "idle_frame") #Wait one frame
		
		
		#If there are any skipped entities go back and select them
		for i in selectedcolony.get_child_count():
			if selectedcolony.get_child(i).skipthisentity:
				for i in selectedcolony.get_child_count():
					if selectedcolony.get_child(i).skipthisentity:
						selectedcolony.get_child(i).skipthisentity = false
				select_movers()
				return
			if selectedcolony.get_child(i).selected or not selectedcolony.get_child(i).moved or selectedcolony.get_child(i).thinking: #Failsafe
				select_movers()
				return
		
		
		#If no entity can move enable the NextTurnButton
		$NextTurnButton.disabled = false
		$Camera/GUI/KillButton.disabled = true
		$Camera/GUI/InfoBox.close()
#	else:
#		_on_NextTurnButton_pressed()


func check_if_empty():
	if selectedcolony.get_child_count() == 0:
		return true
	
	for i in selectedcolony.get_child_count():
		if not selectedcolony.get_child(i).dead:
			return false
	return true


func _on_KillButton_pressed():
	for i in selectedcolony.get_child_count(): 
		if selectedcolony.get_child(i).moveable:
			if not selectedcolony.get_child(i).moved and not selectedcolony.get_child(i).skipthisentity and not selectedcolony.get_child(i).dead:
#				selectedcolony.get_child(i).damage(9999, null)
				selectedcolony.get_child(i).dead = true
				selectedcolony.get_child(i)._on_AnimationTimer_timeout()


#func _process(_delta):
#	if selectedcolony.get_child_count() == 0:
#		_on_NextTurnButton_pressed()
#	else:
#		for i in selectedcolony.get_child_count():
#			if not selectedcolony.get_child(i).dead:
#				return
#	_on_NextTurnButton_pressed()


#	selectedmover = 0
#	for selectedmover in allies.get_child_count(): 
#		if allies.get_child(selectedmover).moveable:
#			if not allies.get_child(selectedmover).moved and not allies.get_child(selectedmover).skipthisentity:
#				allies.get_child(selectedmover).selected = true
#				return
#
#	for selectedmover in allies.get_child_count():
#		if allies.get_child(selectedmover).skipthisentity:
#			for selectedmover in allies.get_child_count():
#				if allies.get_child(selectedmover).skipthisentity:
#					allies.get_child(selectedmover).skipthisentity = false
#			select_movers()
#			return
#
#	$NextTurnButton.disabled = false
	
#		if allies.get_child(selectedmover).moveable:
#			if not allies.get_child(selectedmover).moved:
#				allies.get_child(selectedmover).selected = true
#				selectedmover += 1
#		else: #If the selected ally can't move, it chooses the next one
#			selectedmover += 1
#			select_movers()


#	else: #If there are movers which haven't done an action it goes through all allies again
#		for i in allies.get_child_count():
#			if allies.get_child(i).moveable:
#				if not allies.get_child(i).moved:
#
#					selectedmover = 0
#					for selectedmover in allies.get_child_count():
#						if allies.get_child(selectedmover).moveable:
#							if not allies.get_child(selectedmover).moved:
#								allies.get_child(selectedmover).selected = true
#								return
#
##					selectedmover = 0
##					select_movers()
##					return
#		$NextTurnButton.disabled = false

