class_name Basket
extends Control

var label: Label = null
var start: int = 0
var end: int = 0

func _ready() -> void:
	label = $BasketRange

func set_range(start_: int, end_: int) -> void:
	if not is_node_ready():
		await ready
	start = start_
	end = end_
	
	label.text = str(start) + " - " + str(end)
