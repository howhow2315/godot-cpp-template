extends Node


func _ready() -> void:
	var example := ExampleClass.new() # code instantiation
	example.print_type(example)
