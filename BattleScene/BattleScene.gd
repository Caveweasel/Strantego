extends Node2D
#Global variables
onready var players = $Players
#Arena variables
export var arenalength = 5 #How long the arena is in tiles
export var arenawidth = 3 #How wide the arena is in tiles
#export var area = "EUTier1"
export var levelnum = 0
export var levelsunlockedoncompletion = [1]
export var upgradesunlockedoncompletion = [-1, "startresource"] #Which ant/upgrade it unlocks on completion. -1 is nothing unlocked
var tiles = [] #An array of tiles and their position
#var arenabiome #Which biome this arena is in
var turn #Whose turn it is
var turnnumber = 0 #Which turn it is
var gamehasended = false

var selectedcolonynumber = 0 #Which number colony is the currently selected one
var selectedcolony #Which colony is the currently selected one

#class TileSorter:
#	static func sort_tile_values(a, b):
#		if a[0] < b[0]:
#			return true
#		return false

func _ready():
#	var a = [[1, "left"], [4, "down"], [2, "up"]]
#	a.sort_custom(TileSorter, "sort_tile_values")
#	print(a[0])
#	print(a[1])
#	print(a[2])
	#Assigns cameras position:
#	$Camera.position.x = float(arenalength) / 2 * 128 - 64
#	$Camera.position.y = float(arenawidth) / 2 * 128 + 64
	var zoom = 0
	#print(arenalength*0.42)
	if (arenawidth-5)*0.16 > (arenalength-13)*0.075:
		if arenawidth > 5:
			zoom = (arenawidth-5)*0.16
			$Camera.zoom.y = 1+zoom
			$Camera.zoom.x = 1+zoom
			$Camera.scale.y = 1+zoom
			$Camera.scale.x = 1+zoom
	else:
		if arenalength > 13:
			zoom = (arenalength-13)*0.075
			$Camera.zoom.y = 1+zoom
			$Camera.zoom.x = 1+zoom
			$Camera.scale.y = 1+zoom
			$Camera.scale.x = 1+zoom
	$Camera.position.x = float(arenalength) / 2 * 128 - 64
	$Camera.position.y =float(arenawidth) / 2 * 128 - 64 + (137*(1+zoom))
#	arenabiome = plains()
	
	$BlackSlideOut/BlackSlideOut.rect_position = $Camera.position - Vector2(960,540)
	$BlackSlideOut/BlackSlideOut.slide_out()
	
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
	if not gamehasended:
		select_movers()
		get_tree().call_group("Arena", "movement_update")
		# foreach PLayer
		#    for ally  in player.allies 
		#        #ally.movement_update()


#func plains(): #I need this function so I can send the arenabiome variable to Tilemap
#	pass


func _on_NextTurnButton_pressed():
	
	#selectedmover = 0
	$Camera/GUI/NextTurnButton.disabled = true
	
	
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
		$Camera/GUI/UpgradeButton.check_pressable(selectedcolony)
		
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
					$Camera/GUI/UpgradeButton.check(selectedcolony.get_child(i))
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
		$Camera/GUI/NextTurnButton.disabled = false
		$Camera/GUI/KillButton.disabled = true
		$Camera/GUI/UpgradeButton.disabled = true
		$Camera/GUI/InfoBox.close()
#	else:
#		_on_NextTurnButton_pressed()


func check_if_empty():
	if selectedcolony.get_child_count() == 0:
		return true
	
	for i in selectedcolony.get_child_count():
		if not selectedcolony.get_child(i).dead and selectedcolony.get_child(i).moveable:
			return false
	return true




func _process(_delta):
	$Camera/GUI/FPSCounter.text = "FPS: " + str(Engine.get_frames_per_second())



func check_gynes():
	var gynecount = 0
	#Sees how many gynes are left
	for i in players.get_child_count():
		if players.get_child(i).get_child_count() >= 1:
			if players.get_child(i).get_child(0).name == "Gyne":
				if players.get_child(i).get_child(0).dead == false:
					gynecount += 1
	#Checks if there is one gyne left
	if gynecount <= 1:
		if players.get_child(1).get_child_count() >= 1:
			if players.get_child(1).get_child(0).dead == false:
				end_game(true)
			else:
				end_game(false)
		else:
			end_game(false)


func end_game(won):
	for i in selectedcolony.get_child_count():
		if selectedcolony.get_child(i).moveable:
			selectedcolony.get_child(i).moved = false
			selectedcolony.get_child(i).selected = false
	
	gamehasended = true
	$Camera/GUI/NextTurnButton.disabled = true
	$Camera/GUI/KillButton.disabled = true
	$Camera/GUI/UpgradeButton.disabled = true
	$Camera/GUI/InfoBox.close()
	$Camera/GUI/WinPanel.move_in(won)
	
	if won:
		var global = get_node("/root/Global")
		
		#If this level has been beaten, give some money
		if global.levelsbeaten[levelnum]:
			global.money += global.levelreplayedmoney
		#If the level unlocks an upgrade, unlock it if it isn't unlocked, otherwise give money
		elif upgradesunlockedoncompletion[0] >= 0:
			if upgradesunlockedoncompletion[1] == "startresource":
#				if not global.unlockedstartresourceupgrades[upgradesunlockedoncompletion[0]]:
				global.unlock_start_resource_upgrade(upgradesunlockedoncompletion[0])
			elif upgradesunlockedoncompletion[1] == "maxresource":
#				if not global.unlockedmaxresourceupgrades[upgradesunlockedoncompletion[0]]:
				global.unlock_max_resource_upgrade(upgradesunlockedoncompletion[0])
			elif upgradesunlockedoncompletion[1] == "species":
#				if not global.unlockedspecies[upgradesunlockedoncompletion[0]]:
				global.unlockedspecies[upgradesunlockedoncompletion[0]] = true
		
		#If this level hasn't been beaten and doesn't unlock upgrades, give more money
		else:
			global.money += global.levelcompletedmoney
		
		if global.money >= global.maxmoney:
			global.money = global.maxmoney
		
		
		#Unlocks levels this level unlocks
		for i in levelsunlockedoncompletion.size():
			global.levelsunlocked[levelsunlockedoncompletion[i]] = true
		
		global.levelsbeaten[levelnum] = true
		
	


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

func _on_KillButton_pressed():
	for i in selectedcolony.get_child_count(): 
		if selectedcolony.get_child(i).moveable:
			if not selectedcolony.get_child(i).moved and not selectedcolony.get_child(i).skipthisentity and not selectedcolony.get_child(i).dead:
#					selectedcolony.get_child(i).damage(9999, null)
				selectedcolony.get_child(i).dead = true
				selectedcolony.get_child(i)._on_AnimationTimer_timeout()
				$Camera/GUI/KillButton.release_focus()
				return


func _on_CloseButton_pressed():
	$Camera/GUI/ClosePanel.move_in()


func _on_UpgradeButton_pressed():
	for i in selectedcolony.get_child_count(): 
		if selectedcolony.get_child(i).moveable:
			if not selectedcolony.get_child(i).moved and not selectedcolony.get_child(i).skipthisentity and not selectedcolony.get_child(i).dead and selectedcolony.get_child(i).isforager:
				selectedcolony.get_child(i).turn_into_sat_nest()
