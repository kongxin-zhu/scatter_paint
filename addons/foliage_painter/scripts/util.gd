@tool
class_name FoliagePrinterUtil

static func get_scene_aabb(node, aabb=AABB(), parent_transform=Transform3D()):
	if not node.visible:
		return aabb
	var gtrans := Transform3D()
	if node is Node3D:
		# We cannot use `global_transform` because the node might not be in the scene tree.
		# If we still use it, Godot will print warnings.
		gtrans = parent_transform * node.transform
	if node is VisualInstance3D:
		var node_aabb = gtrans * node.get_aabb()
		#var node_aabb = gtrans.xform(node.get_aabb())
		if aabb == AABB():
			aabb = node_aabb
		else:
			aabb = aabb.merge(node_aabb)
	for i in node.get_child_count():
		aabb = get_scene_aabb(node.get_child(i), aabb, gtrans)
	return aabb


static func get_instance_root(node):
	# TODO Could use `owner`?
	while node != null and node.scene_file_path == "":
		node = node.get_parent()
	return node


static func get_node_in_parents(node, klass):
	while node != null:
		node = node.get_parent()
		if node != null and node is klass:
			return node
	return null


static func is_self_or_parent_scene(fpath, node):
	while node != null:
		if node.scene_file_path == fpath:
			return true
		node = node.get_parent()
	return false
