extends GridContainer

@export var basket_scene: PackedScene = null
@export var fruit_scene: PackedScene = null
var result1_label: Label = null 
var result2_label: Label = null
var _ingredient_input := AOC_Input_05.new().input_to_fresh_and_available_ingredients()
var _fresh_ingredient_ranges: Array[AOC_Input_05.IdRange] = _ingredient_input.fresh_ingredient_ranges
var _available_ingredients: Array[int] = _ingredient_input.available_ingredients

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	result1_label = $"../../Result1"
	result2_label = $"../../Result2"
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
	self.columns = len(final_ranges)
	var baskets: Array[Basket] = []
	for final_range in final_ranges:
		var basket: Basket = basket_scene.instantiate()
		basket.set_range(final_range.start, final_range.end)
		add_child(basket)
		result2 += final_range.end - final_range.start + 1
		baskets.append(basket)
	result2_label.text = "Total fresh ingredients: " + str(result2)
	
	
	var result1: int = 0
	for av_ingredient in _available_ingredients:
		var basket_idx: int = 0
		for fresh_range in final_ranges:
			if av_ingredient >= fresh_range.start and av_ingredient <= fresh_range.end:
				result1 += 1
				spawn_fruit_over_basket(baskets[basket_idx], av_ingredient)
				await get_tree().create_timer(0.2).timeout # adjust this timer for faster solution
				result1_label.text = "Available ingredients that are fresh:: " + str(result1)
				break 
			basket_idx += 1
				
	print("Result1: " + str(result1))
	print("Result2: " + str(result2))
	
func spawn_fruit_over_basket(basket: Basket, av_ingredient: int) -> void:
	var fruit_paths: Array[String] = ["res://05/apple.svg", "res://05/banana.svg", "res://05/peach.svg"]
	var chosen_texture := fruit_paths[randi() % fruit_paths.size()]
	var fruit: Fruit = fruit_scene.instantiate()
	fruit.set_value_and_texture(chosen_texture, av_ingredient)

	call_deferred("add_and_drop_fruit", fruit, basket)
	
func add_and_drop_fruit(fruit: Fruit, basket: Basket) -> void:
	var basket_pos = basket.get_global_position()
	var basket_size = basket.size
	var fruit_size = fruit.size
	var target_pos = Vector2(basket_pos.x + basket_size.x * 0.5 - fruit_size.x * 0.5, basket_pos.y + basket_size.y * 0.5 - fruit_size.y * 0.5)
	var spawn_pos = Vector2(target_pos.x, 0)

	get_parent().add_child(fruit)
	var tween = create_tween()
	tween.tween_property(
		fruit,
		"global_position",
		spawn_pos,
		0.1
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished

	tween = create_tween()
	tween.tween_property(
		fruit,
		"global_position",
		target_pos,
		1
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	fruit.queue_free()
