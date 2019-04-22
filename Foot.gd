extends RayCast

func getSlopeAngle():
	return rad2deg(acos(get_collision_normal().dot(Vector3(0, 1, 0))))