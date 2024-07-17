@tool
extends EditorPlugin

const MULTIMESH_CONVERTER:PackedScene = preload("res://addons/optiscene/multimesh_converter.tscn")
var multimesh_converter:Window = MULTIMESH_CONVERTER.instantiate()
const INSPECTOR_SCRIPT:GDScript = preload("res://addons/optiscene/inspector_plugin.gd")
var inspector_plugin:EditorInspectorPlugin = INSPECTOR_SCRIPT.new()


signal thread_finished(collections:Array[Array])

func place_multimeshes(root:Node):
	if root is not Node3D:
		push_warning("Root of scene is not Node3D but '", root, "' instead. Continuing...")
	var all_nodes:Array[Node] = get_all_children(root)
	var nodes_with_children:Array[Node]
	for node:Node in all_nodes:
		if node and node.get_child_count() > 1:
			nodes_with_children.append(node)
	nodes_with_children.append(root)
	var all_mesh_collections:Array[Array] = []
	multimesh_converter = MULTIMESH_CONVERTER.instantiate().duplicate()
	get_editor_interface().popup_dialog(multimesh_converter)
	multimesh_converter.inspector_plugin = inspector_plugin
	#var thread:Thread = Thread.new()
	#thread.start(func():
		#print("inside thread now")
		#var collections:Array[Array] =  []
		##print("These are the nodes with children:\n\t", nodes_with_children)
		#for node in nodes_with_children:
			#print("Iterating over node ", node.name, ". That is this one: ", node)
			#var mesh_nodes:Array[MeshInstance3D] = []
			#var children:Array[Node] = node.call_thread_safe("get_children")
			#for child in children:
				#print("inside loop")
				#if child is MeshInstance3D and !child.get_script():
					#mesh_nodes.append(child)
			#print("Found all mesh nodes: ", mesh_nodes)
			#if mesh_nodes.size() <= 1:
				#continue
			#var similars:Array[Array]
			#for mesh in mesh_nodes:
				#var found_same:bool = false
				#for similar in similars:
					#if similar[0].mesh == mesh.mesh:
						#found_same = true
						#break
				#if found_same:
					#continue
				#print("Iterating over mesh node: ", mesh.name)
				#var others:Array[MeshInstance3D] = mesh_nodes.duplicate()
				#others.erase(mesh)
				#var collection:Array[MeshInstance3D] = [mesh]
				#for other in others:
					#if mesh.mesh == other.mesh and other.get_child_count() == 0:
						#collection.append(other)
				#similars.append(collection)
			#collections.append(similars)
		#call_thread_safe("emit_signal", "thread_finished", collections)
		#)
	var collections:Array[Array] =  []
	for node in nodes_with_children:
		var mesh_nodes:Array[MeshInstance3D] = []
		var children:Array[Node] = node.get_children()
		for child in children:
			if child is MeshInstance3D and !child.get_script():
				mesh_nodes.append(child)
		if mesh_nodes.size() <= 1:
			continue
		var similars:Array[Array]
		for mesh in mesh_nodes:
			var found_same:bool = false
			for similar in similars:
				if similar[0].mesh == mesh.mesh:
					found_same = true
					break
			if found_same:
				continue
			var others:Array[MeshInstance3D] = mesh_nodes.duplicate()
			others.erase(mesh)
			var collection:Array[MeshInstance3D] = [mesh]
			for other in others:
				if mesh.mesh == other.mesh and other.get_child_count() == 0:
					collection.append(other)
			similars.append(collection)
		collections.append(similars)
	#call_thread_safe("emit_signal", "thread_finished", collections)
	all_mesh_collections = collections
	multimesh_converter.set_mesh_collections(all_mesh_collections)


func get_all_children(in_node:Node, array:Array[Node]= [], is_first:bool = true):
	array.push_back(in_node)
	if in_node and (in_node.scene_file_path == "" or is_first):
		for child in in_node.get_children():
			array = get_all_children(child, array, false)
	return array

func _enter_tree() -> void:
	inspector_plugin.editor_plugin = self
	add_inspector_plugin(inspector_plugin)
	add_tool_menu_item("Summarize MeshInstance3Ds", func():
		place_multimeshes(get_tree().edited_scene_root)
		)


func _exit_tree() -> void:
	remove_inspector_plugin(inspector_plugin)
	remove_tool_menu_item("Summarize MeshInstance3Ds")
