extends Node2D


const particle_pool_size : int = 20
var particle : CPUParticles2D
var particle_iter : int = 0


func _ready():
	Notification.register_observer(self, Notification.NotificationTypes.OreMined)
	
	# Particle Properties
	particle = CPUParticles2D.new()
	
	particle.emitting = false
	particle.one_shot = true
#	particle.linear_accel = -80
#	particle.linear_accel_random = true
#	particle.direction = Vector2.UP
	particle.gravity = Vector2.ZERO
#	particle.direction = Vector2.ZERO
	particle.spread = 180
	particle.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	particle.emission_sphere_radius = 8
	particle.scale *= 3
#	particle.scale_amount_random = true
	particle.lifetime = 4
	particle.lifetime_randomness = true
	particle.explosiveness = 1
	particle.initial_velocity_random = true
	particle.z_index = 1
#	particle.color = Color(0.921569, 0.970588, 0.972549)
	
	for _i in range(particle_pool_size):
		var d_particle = particle.duplicate()
		d_particle.initial_velocity = int(rand_range(100, 300))
		d_particle.amount = int(rand_range(8, 32))
		
		add_child(d_particle)


func set_particle(pos : Vector2, color : Color = Color.white):
	particle = get_child(particle_iter)
	particle_iter = (particle_iter + 1) % particle_pool_size
	
	particle.position = pos
	
	particle.color = color
	
	particle.restart()


func _on_Notify(notification_type : int):
	if notification_type == Notification.NotificationTypes.OreMined:
		pass

