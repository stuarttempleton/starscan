extends VBoxContainer


func _process(_delta):
	var item_qty = $Scroll/ItemList.get_child_count()
	$Scroll.visible = item_qty > 0 #if there's anything in the list, light it up
	$Spacer.visible = item_qty > 0
	$Scroll.rect_min_size.y = min(item_qty, 4) * 55
	pass
