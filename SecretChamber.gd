extends Spatial

func _on_LeaverScn_leaver_on():
	$AnimationPlayer.play("OpeningDoor")
