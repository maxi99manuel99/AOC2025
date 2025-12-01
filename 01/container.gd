extends GridContainer


@export var dial_count: int = 100 
@export var dial_scene: PackedScene = null
@export var arrow: TextureRect = null 
@export var zero_counter1: ZeroCounter = null
@export var zero_counter2: ZeroCounter = null
@export var pointing_at_dial = 50
@export var vertical_arrow_offset = 30
var _dials: Array[Control] = []
var _move_sequence: Array[String] = AOC_Input_01.new().input_to_array()
var _current_move_idx: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arrow = $"../Arrow"
	zero_counter1 = $"../ZeroCounter1"
	zero_counter2 = $"../ZeroCounter2"
	for i in dial_count:
		var new_dial: Node = dial_scene.instantiate()
		new_dial.name = "Dial" + str(i)
		var label: Label = new_dial.get_node("%Label")
		label.text = str(i)
		add_child(new_dial, true)
		_dials.append(new_dial)
		
	set_arrow_pos.call_deferred(50)
	continue_move_sequence()
	
	
func continue_move_sequence():
	if _current_move_idx >= len(_move_sequence):
		return
	var curr_instruction: String = _move_sequence[_current_move_idx]
	var direction: String = curr_instruction[0]        
	var value: int = int(curr_instruction.substr(1))  
	var next_dial: int = 0
	for i in value:
		if direction == "R":
			next_dial = posmod(pointing_at_dial + 1, 100)
		else:
			next_dial = posmod(pointing_at_dial - 1, 100)
		if next_dial == 0:
			zero_counter1.increment_count()
		highlight_dial(next_dial)
		pointing_at_dial = next_dial
		
	set_arrow_pos(next_dial)
	if next_dial == 0:
		zero_counter2.increment_count()
	await get_tree().create_timer(0.001).timeout
	_current_move_idx += 1
	continue_move_sequence()
	
	
func highlight_dial(dial_idx: int) -> void:
	_dials[dial_idx].modulate = Color(255, 0, 0)
	await get_tree().create_timer(0.001).timeout
	_dials[dial_idx].modulate = Color(255, 255, 255)
		
func set_arrow_pos(dial_idx: int) -> void:
	var new_pos: Vector2 =  _dials[dial_idx].global_position
	new_pos.y -= vertical_arrow_offset
	arrow.global_position = new_pos
	
	
		
	
	
	
