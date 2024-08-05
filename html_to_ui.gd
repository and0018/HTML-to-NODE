@tool
extends EditorPlugin
func _enter_tree():
	add_custom_type("HTMLtoUINode", "Control", preload("res://addons/HTMLtoUINode/html_to_ui_node.gd"), null)
func _exit_tree():
	remove_custom_type("HTMLtoUINode")
