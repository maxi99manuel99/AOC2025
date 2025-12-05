extends Control


var _ingredient_input := AOC_Input_05.new().input_to_fresh_and_available_ingredients()
var _fresh_ingredient_ranges: Array[AOC_Input_05.IdRange] = _ingredient_input.fresh_ingredient_ranges
var _available_ingredients: Array[int] = _ingredient_input.available_ingredients
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var result1: int = 0
	for av_ingredient in _available_ingredients:
		for fresh_range in _fresh_ingredient_ranges:
			if av_ingredient >= fresh_range.start and av_ingredient <= fresh_range.end:
				result1 += 1
				break 
	print("Result1: " + str(result1))
	
	var final_ranges: Array[AOC_Input_05.IdRange] = []
	for fresh_range in _fresh_ingredient_ranges:
		var new_range_start := fresh_range.start 
		var new_range_end := fresh_range.end
		var overlapping_ranges_indices: Array[int]
		var existing_range_idx: int = 0
		for existing_range in final_ranges:
			if not (fresh_range.end < existing_range.start or fresh_range.start > existing_range.end):
				overlapping_ranges_indices.append(existing_range_idx)
				new_range_start = min(new_range_start, existing_range.start)
				new_range_end = max(new_range_end, existing_range.end)
			existing_range_idx += 1
		
		overlapping_ranges_indices.reverse() # reverse so that we start removing from the back
		for idx in overlapping_ranges_indices:
			final_ranges.remove_at(idx)
			
		final_ranges.append(AOC_Input_05.IdRange.new(new_range_start, new_range_end))
	
	var result2: int = 0
	for final_range in final_ranges:
		result2 += final_range.end - final_range.start + 1
	print("Result2: " + str(result2))
	
		
		
		
		
	
