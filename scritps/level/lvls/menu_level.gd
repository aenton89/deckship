extends Level



@export var lvl_camera: Camera2D



func _ready() -> void:
	level_name = "MenuLevel"



func enter_level() -> void:
	Global.UI.hud.visible = false
	Global.UI.menu.visible = true
	lvl_camera.make_current()
	
	super.enter_level()

func exit_level() -> void:
	Global.UI.menu.visible = false
	Global.UI.hud.visible = true
	Global.camera.make_current()
	
	# bo teraz to samo menu będzie służyć jako pasue menu, a nie jako to entry
	Global.UI.menu.is_pause_menu = true
	print(Global.UI.menu.is_pause_menu)
	
	super.exit_level()
