@tool
extends MarginContainer

@onready var combine: CheckBox = $HBoxContainer/VBoxContainer/Combine
@onready var mesh_instance:MeshInstance3D = $HBoxContainer/ViewportCon/SubViewport/Node3D/MeshInstance
@onready var action_explanation: Label = $HBoxContainer/VBoxContainer/ActionExplanation
@onready var amount_label: Label = $HBoxContainer/Amount


const SEPERATE_MESSAGE:String = "Don't combine Meshes into Multimesh"
const COMBINE_MESSAGE:String = "Combine Meshes into Multimesh"

var instances:Array[MeshInstance3D] = []

func _ready() -> void:
	combine.toggled.connect(func(toggled:bool):
		if toggled:
			action_explanation.text = COMBINE_MESSAGE
		else:
			action_explanation.text = SEPERATE_MESSAGE)
	action_explanation.text = SEPERATE_MESSAGE


func set_mesh_instances(mesh_instances:Array[MeshInstance3D]) -> void:
	print("These are the instances: ", mesh_instances)
	instances = mesh_instances
	mesh_instance.mesh = mesh_instances[0].mesh
	amount_label.text = "Amount: " + str(mesh_instances.size())
	

func add_multimeshes(mesh_instances:Array[MeshInstance3D] = instances) -> void:
	if !combine.button_pressed:
		print_rich("\t[color=darkgreen]Marked as seperate. Will not combine[/color]")
		return
	if mesh_instances == []:
		print_rich("\t[color=yellow]Found no meshes. Skipping this mesh...[/color]")
		return
	var multimesh:MultiMesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = mesh_instances.size()
	multimesh.mesh = mesh_instances[0].mesh
	for i in mesh_instances.size():
		var transform:Transform3D = Transform3D(mesh_instances[i].transform)
		multimesh.set_instance_transform(i, transform)
	var multimesh_instance:MultiMeshInstance3D = MultiMeshInstance3D.new()
	multimesh_instance.multimesh = multimesh
	var parent:Node = mesh_instances[0].get_parent()
	for instance in mesh_instances:
		instance.queue_free()
	multimesh_instance.name = mesh_instances[0].name
	parent.add_child(multimesh_instance, true)
	multimesh_instance.set_owner(get_tree().edited_scene_root)
	print_rich("\t[color=cyan]Added MultiMeshInstance3D...")
	
