@tool
extends Window

var inspector_plugin:EditorInspectorPlugin

func _ready() -> void:
	%CombinableMessage.show()
	get_child(0).theme = ThemeDB.get_default_theme()
	%Finished.pressed.connect(func():
		print_rich("[color=white]Replacing MeshInstance3Ds with MultiMeshInstance3D[/color]")
		for element in %Elements.get_children():
			element.add_multimeshes()
		print_rich("\t[color=green]Done![/color]")
		close_requested.emit()
		)
	%Cancel.pressed.connect(func():
		close_requested.emit())
	close_requested.connect(func():
		queue_free())



func set_mesh_collections(mesh_collections:Array[Array]):
	if mesh_collections.size() != 0:
		%CombinableMessage.hide()
	else:
		return
	for element in %Elements.get_children():
		element.queue_free()
		print("mesh_collections: ", mesh_collections)
	for collection in mesh_collections:
		print("Iterating over collection: ", collection)
		for similars in collection:
			print("Iterating over similars: ", similars)
			var new_element:Control = %ElementSample.duplicate()
			new_element.show()
			new_element.get_node("HBoxContainer/ViewportCon/SubViewport").world_3d = World3D.new()
			%Elements.add_child(new_element)
			new_element.set_mesh_instances(similars)
