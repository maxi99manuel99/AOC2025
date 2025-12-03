class_name Battery
extends Control

var on_texture: TextureRect = null
var highlight_texture: TextureRect = null
var label: Label = null
var value: int = 0

func _ready() -> void:
	on_texture = $TextureRect/OnTexture
	label = $BatteryValue
	highlight_texture = $TextureRect/Highlight

func set_value(value_: int) -> void:
	if not is_node_ready():
		await ready
	label.text = str(value_)
	value = value_

func turn_on() -> void:
	if not is_node_ready():
		await ready
	on_texture.show()
	
func turn_off() -> void:
	if not is_node_ready():
		await ready
	on_texture.hide()
	
func highlight() -> void:
	if not is_node_ready():
		await ready
	highlight_texture.show()
	await get_tree().create_timer(0.5).timeout # comment to stop animating so the programm runs in reasonable time
	highlight_texture.hide()
