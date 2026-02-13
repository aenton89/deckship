extends Level



@export var lvl_camera: Camera2D



func enter_level() -> void:
	Global.UI.hud.visible = false
	Global.UI.menu.visible = true
	lvl_camera.make_current()
	
	super.enter_level()


func exit_level() -> void:
	Global.UI.menu.visible = false
	Global.UI.hud.visible = true
	Global.camera.make_current()
	
	super.exit_level()
