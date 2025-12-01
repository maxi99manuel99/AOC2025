class_name ZeroCounter
extends Label

var _zero_count: int = 0
var _label_text: String = "Zero Count: "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text = _label_text + str(_zero_count)

func increment_count() -> void:
	_zero_count += 1
	self.text = _label_text + str(_zero_count)
