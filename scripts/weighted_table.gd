class_name WeightedTable

var items: Array[Dictionary]=[]
var weight_sum = 0

func add_item(item,weight: int,category:String = ""):
	items.append({"item":item,"category":category, "weight":weight})
	weight_sum += weight

func pick_item(array:Array = items, sum:int = weight_sum, qty:int = 1):
	var choosen_upgrades = []
	var items_pool = array.duplicate(true)
	var calculation_sum = sum
	for q in qty:
		var choosen_weight = randf_range(1, calculation_sum)
		var iteration_sum = 0
		for i in items_pool:
			iteration_sum += i["weight"]
			if choosen_weight <= iteration_sum:
				choosen_upgrades.append(i["item"])
				if i["category"] != "":
					items_pool = items_pool.filter(func(item): return (item["item"]).id != (i["item"]).id )
					calculation_sum -= i["weight"]
				break
	return choosen_upgrades
	

func delete_item(item):
	items = items.filter(func(e): return e["item"] != item)

func pick_item_from_categories(category:Array[String],qty:int = 1):
	var filtered_table = []
	for cat in category:
		var filtered_items = items.filter(func(e): return e["category"] == cat)
		for e in filtered_items:
			filtered_table.append(e)
	var sum_table = filtered_table.reduce(func(acc,item): return acc + item["weight"],0)
	return pick_item(filtered_table, sum_table, qty)
