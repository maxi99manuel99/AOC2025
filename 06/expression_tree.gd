class_name ExpressionTree
extends Control

@export var christmas_ball_scene: PackedScene = null

class OurExpressionTree:
	var root: ExpressionTreeNode 
	var christmas_ball_scene: PackedScene
	var parent_scene: ExpressionTree
	var _result: int 
	
	func _init(root_: ExpressionTreeNode, christmas_ball_scene_: PackedScene, parent_scene_: ExpressionTree):
		self.root = root_
		self.christmas_ball_scene = christmas_ball_scene_
		self.parent_scene = parent_scene_
		
	func calculate_result() -> int:
		self._result = _calculate_result_recursive(self.root)
		return self._result
		
	func _calculate_result_recursive(node: ExpressionTreeNode):
		if node.value not in ["+","*"]:
			return node.value 
		else:
			if node.value == "+":
				return _calculate_result_recursive(node.left) + _calculate_result_recursive(node.right)
			else:
				return _calculate_result_recursive(node.left) * _calculate_result_recursive(node.right)
				
	func draw():
		if not self._result:
			calculate_result()
		_draw_recursive(self.root, Vector2(150, 50), 50) 
		parent_scene.update_min_size()
		var result_label = Label.new()
		result_label.text = "Result: " + str(self._result)
		parent_scene.add_child(result_label)


	func _draw_recursive(node: ExpressionTreeNode, pos: Vector2, x_offset: float):
		if node == null:
			return

		var christmas_ball := christmas_ball_scene.instantiate()
		var size = christmas_ball.size
		var new_pos = pos - size * 0.5
		christmas_ball.position = new_pos
		var label := christmas_ball.get_node("Label")
		label.text = str(node.value)
		parent_scene.add_child(christmas_ball)
		if node.left:
			var left_pos = pos + Vector2(-x_offset, 50)
			_draw_recursive(node.left, left_pos, x_offset / 1.5)

		if node.right:
			var right_pos = pos + Vector2(x_offset, 50)
			_draw_recursive(node.right, right_pos, x_offset / 1.5)
			
		
class ExpressionTreeNode:
	var value
	var left: ExpressionTreeNode
	var right: ExpressionTreeNode
	
	func _init(_value, _left: ExpressionTreeNode = null, _right: ExpressionTreeNode = null):
		value = _value
		left = _left
		right = _right

func build_tree(numbers: Array[int], operand: String) -> OurExpressionTree:
	var root = ExpressionTreeNode.new(numbers[0])

	for i in range(1, numbers.size()):
		var new_node = ExpressionTreeNode.new(operand, root, ExpressionTreeNode.new(numbers[i]))
		root = new_node
	
	return OurExpressionTree.new(root, christmas_ball_scene, self)
	
func update_min_size() -> void:
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF

	for child in self.get_children():
		if child is Control:
			var rect = child.get_global_rect()
			min_x = min(min_x, rect.position.x)
			max_x = max(max_x, rect.position.x + rect.size.x)
			min_y = min(min_y, rect.position.y)
			max_y = max(max_y, rect.position.y + rect.size.y)

	var final_size = Vector2(max_x - min_x + 50 , max_y - min_y + 50)
	self.custom_minimum_size = final_size
	
