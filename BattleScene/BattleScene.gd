extends Node2D
#Global variables
onready var players = $Players
#Arena variables
var arenalength = 5 #How long the arena is in tiles
var arenawidth = 3 #How wide the arena is in tiles
var tiles = [] #An array of tiles and their position
var arenabiome #Which biome this arena is in
var turn #Whose turn it is
var turnnumber #Which turn it is

var selectedcolonynumber = 0 #Which number colony is the currently selected one
var selectedcolony #Which colony is the currently selected one


func _ready():
	#Assigns cameras position:
	$Camera.position.x = float(arenalength) / 2 * 128 - 64
	$Camera.position.y = float(arenawidth) / 2 * 128 + 64
	arenabiome = plains()
	
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


func plains(): #I need this function so I can send the arenabiome variable to Tilemap
	pass


func _on_NextTurnButton_pressed():
	
	#selectedmover = 0
	$NextTurnButton.disabled = true
	
	
	if selectedcolonynumber >= players.get_child_count()-1:
		selectedcolonynumber = 1
	else:
		selectedcolonynumber += 1
	selectedcolony = players.get_child(selectedcolonynumber)
	
	#Makes allies moveable
	for i in selectedcolony.get_child_count():
		if selectedcolony.get_child(i).moveable:
			selectedcolony.get_child(i).moved = false
			selectedcolony.get_child(i).selected = false
	
	get_tree().call_group("Arena", "turn_update")
	select_movers()


func select_movers():
	
	#Selects a moveable entity to select
	for i in selectedcolony.get_child_count(): 
		if selectedcolony.get_child(i).moveable:
			if not selectedcolony.get_child(i).moved and not selectedcolony.get_child(i).skipthisentity:
				selectedcolony.get_child(i).do()
				return
	
	#If there are any skipped entities go back and select them
	for i in selectedcolony.get_child_count():
		if selectedcolony.get_child(i).skipthisentity:
			for i in selectedcolony.get_child_count():
				if selectedcolony.get_child(i).skipthisentity:
					selectedcolony.get_child(i).skipthisentity = false
			select_movers()
			return
	
	#If no entity can move enable the NextTurnButton
	$NextTurnButton.disabled = false



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
