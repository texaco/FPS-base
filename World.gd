extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const DEBUG = true
signal show_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("ui_cancel")):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
	if (Input.is_action_just_pressed("ui_home")):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("show_menu")

func _input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)