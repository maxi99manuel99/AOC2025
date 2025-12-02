extends Label

@export var waiting_text: String = "Waiting for next invalid ID to be found..."
var _result_display1: ResultSum = null
var _result_display2: ResultSum = null
var _progress_display: HSlider = null
var _input_id_ranges := AOC_Input_02.new().input_to_array()

func get_digit_count(id: int) -> int:
	return (floor(log(id) / log(10)) + 1) 
	
func has_even_digits(id: int) -> bool:
	return get_digit_count(id) % 2 == 0
	
func generate_rnd_color() -> Color:
	return Color(randf(), randf(), randf())
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_result_display1 = $"../ResultSum"
	_result_display2 = $"../ResultSum2"
	_progress_display = $"../ProgressBar"
	var _max_value = 0
	for range in _input_id_ranges:
		_max_value += range.end - range.start
	_progress_display.max_value = _max_value
	var corrects: Array[int] = []
	for id_range in _input_id_ranges:
		for x in range(id_range.start, id_range.end+1):
			_progress_display.value += 1
			self.text = waiting_text
			var digit_count: int = get_digit_count(x)
			if has_even_digits(x):
				var half_digit_count: int = digit_count / 2
				var divisor: int = int(pow(10, half_digit_count))
				var left := x / divisor
				var right := x % divisor
				if left == right:
					_result_display1.add(x)
					self.add_theme_color_override("font_color", generate_rnd_color())
					self.text = "Found invalid ID repeated exactly twice: " + str(left) + " | " + str(right) 
					await get_tree().create_timer(0.001).timeout

			for chunk_size in range(1, int(digit_count / 2) + 1):
				if digit_count % chunk_size != 0:
					continue 
				var n_chunks: int = digit_count / chunk_size
				var divisor: int = int(pow(10, digit_count - chunk_size))
				var chunk_to_repeat: int = int(x / divisor)
				var reconstruction: int = chunk_to_repeat
				for i in range(1, n_chunks):
					reconstruction += chunk_to_repeat*int(pow(10, i*chunk_size))
				if x == reconstruction:
					corrects.append(x)
					_result_display2.add(x)
					self.add_theme_color_override("font_color", generate_rnd_color())
					self.text = "Found invalid ID repeated at least twice: " + str(x)
					await get_tree().create_timer(0.005).timeout
					break
					
	self.text = "All invalid IDs have been identified"
	
						
					
		
