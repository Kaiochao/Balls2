
var/list/Balls = new
var/BallCollision = TRUE

obj/ball
	icon = 'rsc/circle.dmi'

	var/vector/velocity

	New()
		..()
		Balls += src
		color = rgb(rand(360), 100, 100, space = COLORSPACE_HSV)
		velocity = Vector.north.Turn(rand() * 360) * 32

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
		_BounceOffWalls()
		if(BallCollision)
			_BounceOffBalls()

	proc/_BounceOffWalls()
		for(var/turf/wall/wall in obounds())
			_BounceOffWall(wall)

	proc/_BounceOffWall(turf/wall/wall)
		var/vector/overlap = wall.normal.WithLength(bounds_dist(src, wall))
		Step(-overlap)
		var/is_approaching = velocity.Dot(wall.normal) < 0
		if(is_approaching)
			velocity = velocity.Bounce(wall.normal)

	proc/_BounceOffBalls()
		for(var/obj/ball/other in obounds())
			_BounceOffBall(other)

	proc/_BounceOffBall(obj/ball/other)
		if(_IsOverlapping(other))
			_Separate(other)
			if(_IsApproaching(other))
				var/vector/bounce = _Bounce(other)
				_ApplyBounce(other, bounce)
				_SpawnCollisionEffect(other, bounce)

	proc/_IsOverlapping(obj/ball/other)
		var/vector/to_other = other.Position() - Position()
		var/distance_squared = to_other.LengthSquared()
		var/is_concentric = distance_squared == 0
		var/is_overlapping = distance_squared < 32 * 32
		return !is_concentric && is_overlapping

	proc/_Separate(obj/ball/other)
		var/vector/to_other = other.Position() - Position()
		var/vector/overlap = to_other.WithLength(32 - to_other.Length())
		Step(overlap / -2)
		other.Step(overlap / 2)

	proc/_IsApproaching(obj/ball/other)
		return velocity.Dot(other.Position() - Position()) > 0

	proc/_Bounce(obj/ball/other)
		var/vector/to_other = other.Position() - Position()
		return to_other * ((velocity.Dot(to_other) - other.velocity.Dot(to_other)) / to_other.LengthSquared())

	proc/_ApplyBounce(obj/ball/other, vector/bounce)
		velocity -= bounce
		other.velocity += bounce

	proc/_SpawnCollisionEffect(obj/ball/other, vector/bounce)
		var/vector/position_between = (Position() + other.Position()) / 2
		var/obj/collision_particles/effect = new(position_between)
		effect.particles.count = round(bounce.Length())
		effect.particles.color = gradient(color, other.color, space = COLORSPACE_HSV, index = 0.5)
