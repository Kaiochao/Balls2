
var/list/Balls = new
var/BallCollision = TRUE

obj/ball
	icon = 'rsc/circle256.dmi'

	var/vector/velocity
	var/radius = 128

	New()
		..()
		pixel_w += (32 - 256) / 2
		pixel_z += (32 - 256) / 2
		Balls += src
		color = rgb(rand(360), 100, 100, space = COLORSPACE_HSV)
		velocity = Vector.north.Turn(rand() * 360) * 32
		radius = rand(8, 64)
		transform *= radius / 128
		bound_width = \
		bound_height = radius * 2
		bound_x = \
		bound_y = (32 - bound_width) / 2

	Del()
		Balls -= src
		..()

	proc/Position()
		return new/vector(
			1 + (x - 1) * 32 + step_x + bound_x + (bound_width - 1) / 2,
			1 + (y - 1) * 32 + step_y + bound_y + (bound_height - 1) / 2,
			z)

	proc/Step(vector/motion)
		step_x += motion.X()
		step_y += motion.Y()

	proc/Tick()
		var/vector/position = Position()
		_Simulate()
		var/vector/motion = Position() - position
		step_size = max(abs(motion.X()), abs(motion.Y()))

	proc/_Simulate()
		Step(velocity * world.tick_lag)
		_CollideWithWalls()
		if(BallCollision)
			_CollideWithBalls()

	proc/_CollideWithWalls()
		for(var/turf/wall/wall in obounds())
			var/vector/overlap = wall.normal * -bounds_dist(src, wall)
			Step(overlap)
			var/is_approaching = velocity.Dot(wall.normal) < 0
			if(is_approaching)
				velocity = velocity.Bounce(wall.normal)

	proc/_CollideWithBalls()
		for(var/obj/ball/other in obounds())
			if(_IsOverlapping(other))
				_Separate(other)
				if(_IsApproaching(other))
					var/vector/bounce = _Bounce(other)
					_ApplyBounce(other, bounce)
					_SpawnCollisionEffect(other, bounce)

	proc/_IsOverlapping(obj/ball/other)
		var/vector/to_other = _To(other)
		var/distance_squared = to_other.LengthSquared()
		var/is_concentric = distance_squared == 0
		var/is_overlapping = distance_squared < (radius + other.radius) ** 2
		return !is_concentric && is_overlapping

	proc/_Separate(obj/ball/other)
		var/vector/to_other = _To(other)
		var/vector/overlap = to_other.WithLength(radius + other.radius - to_other.Length())
		Step(overlap / -2)
		other.Step(overlap / 2)

	proc/_IsApproaching(obj/ball/other)
		return velocity.Dot(_To(other)) > 0

	proc/_Bounce(obj/ball/other)
		var/vector/to_other = _To(other)
		return to_other * ((velocity.Dot(to_other) - other.velocity.Dot(to_other)) / to_other.LengthSquared())

	proc/_ApplyBounce(obj/ball/other, vector/bounce)
		velocity -= bounce
		other.velocity += bounce

	proc/_SpawnCollisionEffect(obj/ball/other, vector/bounce)
		new/obj/collision_particles(
			(Position() + other.Position()) / 2,
			round(bounce.Length()),
			gradient(color, other.color, index = 0.5))

	proc/_To(obj/ball/other)
		return other.Position() - Position()
