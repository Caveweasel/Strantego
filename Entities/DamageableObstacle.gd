extends Sprite

#Global variables
onready var arena = get_node("/root/BattleSceneTest")
#Object variables
var occupiedtile = 1 #The tile this entity is occupying
var occupiedxtile = 0
var occupiedytile = 0
#Entity variables
var dead = false
var health = 80
#DamageableObstacle variables
var hurtparticles = load("res://Particles/SplinterExplosion.tscn")
var deathparticles = load("res://Particles/SplinterExplosion.tscn")


func _ready():
	self.texture = load("res://Sprites/Entities/Obstacles/Twig.png") #Assigns sprite's texture


func arena_ready():
	position = arena.tiles[occupiedtile]
	occupiedytile = ceil(float(occupiedtile / arena.arenalength)) #Finds out which Y tile this entity is occupying
	occupiedxtile = ceil(float(occupiedtile - occupiedytile * 5)) #Finds out which X tile this entity is occupying


func damage(damage, aggressor): #Takes damage
	if damage >= health:
		dead = true
		aggressor.conquer(occupiedtile)
	health -= damage
	$AnimationTimer.start()


func _on_AnimationTimer_timeout(): #Takes damage and animation
	if dead:
		$DeathTimer.start()
		self_modulate = Color(0,0,0,0)
		occupiedtile = -1
		self.add_child(deathparticles.instance())
	else:
		self.add_child(hurtparticles.instance())


func _on_DeathTimer_timeout():
	queue_free()
