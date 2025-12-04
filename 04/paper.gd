class_name Paper
extends Control

var accesible_texture: ColorRect = null
var label: Label = null
var value: int = 0

func _ready() -> void:
	accesible_texture = $TextureRect/Accesible
	label = $TextureRect/PaperValue

func set_value(value_: int) -> void:
	if not is_node_ready():
		await ready
	label.text = str(value_)
	value = value_
	if value < 4:
		mark_accesible()

func mark_accesible():
	accesible_texture.show()
