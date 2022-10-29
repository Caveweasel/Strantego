extends Sprite

#Global variables
onready var players = get_node("/root/BattleSceneTest/Players")
onready var arena = get_node("/root/BattleSceneTest")
#Object variables
var value = -5
var occupiedtile = 1 #The tile this entity is occupying
var occupiedxtile = 0
var occupiedytile = 0
#Entity variables
var dead = false
var health = 80
var attackable = true
#DamageableObstacle variables
var hurtparticles = load("res://Particles/Grassplosion.tscn")
var deathparticles = load("res://Particles/Grassplosion.tscn")


#func _ready():
#	self.texture = load("res://Sprites/Entities/Obstacles/Twig.png") #Assigns sprite's texture


func arena_ready():
	occupiedtile = arena.tiles.find(position)
#	position = arena.tiles[occupiedtile]
	occupiedytile = ceil(float(occupiedtile / arena.arenalength)) #Finds out which Y tile this entity is occupying
	occupiedxtile = ceil(float(occupiedtile - occupiedytile * arena.arenalength)) #Finds out which X tile this entity is occupying


func damage(damage, aggressor): #Takes damage
	health -= damage
	$AnimationTimer.start()
#	if damage >= health:
	if health <= 0:
		dead = true
		if aggressor != null:
			
			for l in players.get_child_count(): #If there is an entity/obstacle on this entity, don't get conquered
				for i in players.get_child(l).get_child_count(): 
					if players.get_child(l).get_child(i).occupiedtile == occupiedtile:
						if not players.get_child(l).get_child(i) == self:
							return
			
#			for i in ownallies.get_child_count(): #If there is an entity on this entity, don't get conquered
#				if ownallies.get_child(i).occupiedtile == occupiedtile:
#					if not ownallies.get_child(i) == self:
#						return
			aggressor.conquer(occupiedtile)


func _on_AnimationTimer_timeout(): #Takes damage and animation
	if dead:
		$DeathTimer.start()
		self_modulate = Color(0,0,0,0)
		$Sprites.modulate = Color(0,0,0,0)
		occupiedtile = -1
		self.add_child(deathparticles.instance())
	else:
		self.add_child(hurtparticles.instance())


func _on_DeathTimer_timeout():
	queue_free()
