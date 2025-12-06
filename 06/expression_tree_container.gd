extends GridContainer

@export var expression_tree_scene: PackedScene = null
var result_label: Label = null
var _switch_input_button: Button = null
var _problem_input := AOC_Input_06.new().input_to_vertical_problem_list()
var _problem_input2 := AOC_Input_06.new().input_to_vertical_problem_list_right_to_left_col()
var _current_input_set := 1 

func _ready() -> void:
	result_label = $"../../Result"
	_switch_input_button = $"../../Button"
	_switch_input_button.connect("pressed", Callable(self, "_on_switch_button_pressed"))

	_display_trees_with_result(_problem_input)

func _on_switch_button_pressed():
	if _current_input_set == 1:
		_current_input_set = 2
		_display_trees_with_result(_problem_input2)
	else:
		_current_input_set = 1
		_display_trees_with_result(_problem_input)

func _display_trees_with_result(problems):
	self.columns = int(len(problems) / 2)
	for child in get_children():
		if child is ExpressionTree:
			remove_child(child)
			child.queue_free()

	var result: int = 0
	for problem in problems:
		var expression_tree: ExpressionTree = expression_tree_scene.instantiate()
		var tree := expression_tree.build_tree(problem.numbers, problem.operand)
		result += tree.calculate_result()
		tree.draw()
		add_child(expression_tree)
	
	var part_str: String = ""
	if _current_input_set == 1:
		part_str = "(Part 1)"
	else:
		part_str = "(Part 2)"
	result_label.text = "Sum of Tree Results " + part_str + ": " + str(result)
	print("Result " + part_str + ": " + str(result))
