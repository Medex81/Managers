extends Node

var reserve_effects_dict = {}
var unique_effects = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _get_effect_instance(effect_name:String):
	var effect = reserve_effects_dict[effect_name].instance()
	if effect:
		effect.set_name(effect_name)
		return effect
	else:
		return null

# запрос сцены с эффектом
func get_effect(effect_name:String):
	if effect_name in reserve_effects_dict:
		return _get_effect_instance(effect_name)
	else:
		# сцена не зарезервирована - пытаемся создать
		var effect_res = load("res://Game/Managers/Effects/%s/%s.tscn" % [effect_name, effect_name] )
		if effect_res:
			reserve_effects_dict[effect_name] = effect_res
			return _get_effect_instance(effect_name)
		else:
			# такого эффекта нет или неверно указано имя эффекта
			print("Error effect name -> %s" % effect_name)
	return null

# подгружаем эффекты с диска в память
func reserve_effects(reserve_array:Array):
	for effect_name in reserve_array:
		if effect_name in reserve_effects_dict:
			continue
		else:
			var effect_res = load("res://Game/Managers/Effects/%s/%s.tscn" % [effect_name, effect_name] )
			if effect_res:
				print("Reserv effect -> %s" % effect_name)
				reserve_effects_dict[effect_name] = effect_res
			else:
				# такого эффекта нет или неверно указано имя эффекта
				print("Error effect name -> %s" % effect_name)
				
# установка эффекта в нод
func set_effect(parent_node:Object, effect_name:String, size:Vector2 = Vector2(0, 0)):
	if parent_node:
		var effect = get_effect(effect_name)
		if effect:
			if size == Vector2(0, 0):
				size = parent_node.rect_size
			effect.rect_size = size
			parent_node.add_child(effect)
			print("Set effect -> %s, %d" % [effect_name, parent_node.get_instance_id()])
			return true
	return false
	
# установим эффект только для одного нода, из предыдущего эффект удаляем
func set_unique_effect(parent_node:Object, effect_name:String, size:Vector2 = Vector2(0, 0)):
	if effect_name in unique_effects:
		remove_effect(unique_effects[effect_name], effect_name)
		unique_effects.erase(effect_name)
	if size == Vector2(0, 0) && parent_node:
		size = parent_node.rect_size
	if set_effect(parent_node, effect_name, size):
		unique_effects[effect_name] = parent_node
		print("Set unique effect -> %s, %d" % [effect_name, parent_node.get_instance_id()])
		print(unique_effects)
	
# удалить эффект из нод
func remove_effect(parent_node:Object, effect_name:String):
	if parent_node:
		var effect = parent_node.get_node(effect_name)
		if effect:
			parent_node.remove_child(effect)
			effect.queue_free()
			print("Remove unique effect -> %s, %d" % [effect_name, parent_node.get_instance_id()])
		else:
			print("Remove error. No effect in parent node -> %s, %d" % [effect_name, parent_node.get_instance_id()])
	else:
		print("Remove error. No parent(null) node for effect -> %s" % [effect_name])
				
func clear_effects():
	reserve_effects_dict.clear()
	
