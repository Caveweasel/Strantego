extends CPUParticles2D


func _on_DeathTimer_timeout():
	queue_free()
