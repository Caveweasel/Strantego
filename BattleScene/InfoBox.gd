extends Control

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


func arena_update():
	pass

