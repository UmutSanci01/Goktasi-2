extends Node2D

var pool_size : int = 50
var pool_count : int = 0

var pool : Dictionary = {

}

func _ready():
	pass

func get_bullet(bullet_id) -> Bullet:
	var bullet_pool = pool.get(bullet_id)
	var bullet : Bullet

	if bullet_pool:
		bullet = bullet_pool.get_child(pool_count)
	else:
		pool_count = 0

		# get bullet data
		var bullet_data = ItemDB.get_item(bullet_id)
		var bullet_scene
		if bullet_data:
			bullet_scene = bullet_data.scene

		# add pool
		bullet_pool = Node2D.new()
		add_child(bullet_pool)
		pool[bullet_id] = bullet_pool
		
		# fill pool
		for _i in range(pool_size):
			bullet = bullet_scene.instance()
			bullet_pool.add_child(bullet)
			bullet.disable()

			# if bullet.connect("collision", get_parent(), "_on_bullet_collide"): pass
			if bullet.connect("collision_meteor", get_parent(), "_on_Bullet_MeteorCollide"): pass
		
		bullet = bullet_pool.get_child(pool_count)
	
	pool_count += 1
	pool_count %= pool_size
	
	return bullet
	