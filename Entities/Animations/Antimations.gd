extends AnimationPlayer

onready var p = get_parent()
onready var thorax = get_parent().get_node("Thorax")
onready var head = get_parent().get_node("Thorax/Head")
onready var gaster = get_parent().get_node("Thorax/Gaster")
onready var antennae = get_parent().get_node("Thorax/Head/Antennae")


func _process(_delta):
	if not p.get_parent().visible:
		p.visible = false
	if p.get_parent().visible:
		p.visible = true
	if not p.get_parent().self_modulate == p.modulate:
		p.modulate = p.get_parent().self_modulate


func forager(ally):
	thorax.offset = Vector2(-8,-4)
	thorax.texture = load("res://Sprites/Entities/Parts/ForagerThorax.png")
	
	head.offset = Vector2(12,8)
	head.texture = load("res://Sprites/Entities/Parts/ForagerHead.png")
	
	antennae.texture = load("res://Sprites/Entities/Parts/ForagerAntennae.png")
	
	if ally:
		gaster.texture = load("res://Sprites/Entities/Parts/BlueGaster.png")
	else:
		gaster.texture = load("res://Sprites/Entities/Parts/RedGaster.png")
	
	play("IdleForager")


func troop(ally):
	thorax.offset = Vector2(-4,-4)
	thorax.texture = load("res://Sprites/Entities/Parts/TroopThorax.png")
	
	head.offset = Vector2(16,8)
	head.texture = load("res://Sprites/Entities/Parts/TroopHead.png")
	
	antennae.texture = load("res://Sprites/Entities/Parts/TroopAntennae.png")
	
	if ally:
		gaster.texture = load("res://Sprites/Entities/Parts/BlueGaster.png")
	else:
		gaster.texture = load("res://Sprites/Entities/Parts/RedGaster.png")
	
	play("IdleTroop")

