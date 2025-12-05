class_name Fruit
extends TextureRect

var label: Label = null

func _ready() -> void:
	label = $Label

func set_value_and_texture(texture_path: String, value: int) -> void:
	if not is_node_ready():
		await ready
	self.texture = load(texture_path)
	label.text = str(value)
	
