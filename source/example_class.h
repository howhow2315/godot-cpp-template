#pragma once

#include "godot_cpp/classes/node.hpp"
#include "godot_cpp/classes/wrapped.hpp"
#include "godot_cpp/variant/variant.hpp"

using namespace godot;

class ExampleClass : public Node {
	GDCLASS(ExampleClass, Node)

protected:
	static void _bind_methods() {
		ClassDB::bind_method(D_METHOD("print_type", "variant"), &ExampleClass::print_type);
	};

public:
	ExampleClass() = default;
	~ExampleClass() override = default;

	void print_type(const Variant &p_variant) const;
};
