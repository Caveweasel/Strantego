extends Control

onready var arena = get_node("/root/BattleSceneTest")
onready var players = get_node("/root/BattleSceneTest/Players")

var selectedentity

var tilescale1 = load("res://Sprites/Level/TileScale1.png")
var tilescale2 = load("res://Sprites/Level/TileScale2.png")

func refresh(e):
	selectedentity = e
	for i in $Anim.get_child_count():
		$Anim.get_child(i).queue_free()
	
	if selectedentity.tilescale == 1:
		$Tile.texture = tilescale1
		$Anim.scale = Vector2(1,1)
	if selectedentity.tilescale == 2:
		$Tile.texture = tilescale2
		$Anim.scale = Vector2(0.75,0.75)
	
	
	$XButton.disabled = false
	
	$Health.visible = true
	$Health.text = str(selectedentity.health)
	$Attack.visible = true
	$Attack.text = str(selectedentity.strength)
	
	$Anim.add_child(selectedentity.animationplayer.instance())
	$Anim.start_animation(selectedentity)


func close():
	if $Anim.get_child_count() > 0:
		$Anim.get_child(0).queue_free()
	$Tile.texture = null
	
	$XButton.disabled = true
	$Health.visible = false
	$Attack.visible = false

func _on_XButton_pressed():
	close()


func _input(_event):
	if Input.is_action_just_pressed("click"):
		var mousepos = get_global_mouse_position()
		if mousepos.y > -64 and mousepos.y < arena.arenawidth * 128 - 64 and mousepos.x > -64 and mousepos.x < arena.arenalength * 128 - 64: #If the click is within the arena
			mousepos.y = stepify(mousepos.y, 128)
			mousepos.x = stepify(mousepos.x, 128)
#			print(arena.tiles.find(mousepos))
			for l in players.get_child_count():
				if not players.get_child(l) == players.get_child(0):
					for i in players.get_child(l).get_child_count():
						if players.get_child(l).get_child(i).occupiedtile == arena.tiles.find(mousepos) and not players.get_child(l).get_child(i).dead:
							refresh(players.get_child(l).get_child(i))
							return

