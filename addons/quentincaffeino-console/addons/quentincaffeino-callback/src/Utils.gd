
extends RefCounted


enum Type \
{
	UNKNOWN,
	VARIABLE,
	METHOD
}


# @param  RefCounted  target
# @param  string     name
static func getType(target, name):  # int
	# Is it a METHOD
	if target.has_method(name):
		return Type.METHOD

	# Is it a VARIABLE
	if name in target:
		return Type.VARIABLE

	return Type.UNKNOWN


# @param  RefCounted  obj
static func isFunkRef(obj):  # boolean
	return obj.has_method('set_instance') and obj.has_method('set_function')
