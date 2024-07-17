extends EditorInspectorPlugin

const MULTIMESH_CONVERTER:PackedScene = preload("res://addons/optiscene/multimesh_converter.tscn")

var editor_plugin:EditorPlugin

var current_selection:Node3D

func _can_handle(object: Object) -> bool:
	if object is Node3D:
		current_selection = object
		return true
	else:
		return false
