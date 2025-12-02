class_name ResultSum
extends Label

var _result_sum: int = 0
var _label_text: String = "Invalid IDs Sum: "

func _ready() -> void:
	self.text = _label_text + str(_result_sum)

func add(id: int) -> void:
	_result_sum += id
	self.text = _label_text + str(_result_sum)
