extends EditorInspectorPlugin

const MULTIMESH_CONVERTER:PackedScene = preload("res://addons/optiscene/multimesh_converter.tscn")

var editor_plugin:EditorPlugin


var multimesh_button:Button

#func _can_handle(object: Object) -> bool:
	#var all_mesh_instances:Array[MeshInstance3D] = []
	#if multimesh_button and is_instance_valid(multimesh_button):
		#editor_plugin.remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, multimesh_button)
		#multimesh_button.queue_free()
		#print("Tried to remove the button")
	#if object.get_class() == "MultiNodeEdit":
		#var selections:Array[Node] = EditorInterface.get_selection().get_selected_nodes()
		#var all_meshes:bool = true
		#var all_same_parent:bool = true
		#var last_parent:Node = selections[0].get_parent()
		#for node in selections:
			#if node.get_parent() != last_parent:
				#all_same_parent = false
				#push_warning("Not same parent. Aborting")
				#break
			#if node is not MeshInstance3D:
				#all_meshes = false
				#push_warning("Not all selections are meshes")
				#break
			#all_mesh_instances.append(node)
		#if all_meshes and all_same_parent:
			#print("All edited nodes are MeshInstances: ", selections)
			#multimesh_button = Button.new()
			#multimesh_button.text = "Combine to MultiMesh"
			#editor_plugin.add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, multimesh_button)
			#multimesh_button.pressed.connect(editor_plugin.place_multimeshes.bind(last_parent, all_mesh_instances))
			#
	#return false
