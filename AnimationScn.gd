extends Spatial

signal leaver_on

func _on_Area_body_entered(body):
	emit_signal("leaver_on")
