extends AnimationPlayer

onready var p = get_parent()
#
#func _ready():
#	play("LasiusTroopIdle")

func _process(_delta):
	if not p.get_parent().visible:
		p.visible = false
	if p.get_parent().visible:
		p.visible = true
	if not p.get_parent().self_modulate == p.modulate:
		p.modulate = p.get_parent().self_modulate

func start_anim(isAI, animation):
	if isAI != null:
		if isAI:
			get_parent().get_node("Thorax/Gaster/Divide0").self_modulate = Color(1,0.2,0.2,1)
			get_parent().get_node("Thorax/Gaster/Divide1").self_modulate = Color(1,0.2,0.2,1)
		else:
			get_parent().get_node("Thorax/Gaster/Divide0").self_modulate = Color(0.3,0.3,1,1)
			get_parent().get_node("Thorax/Gaster/Divide1").self_modulate = Color(0.3,0.3,1,1)
	
	play(animation)
