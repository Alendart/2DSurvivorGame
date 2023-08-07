class_name WeightedTable

var items: Array[Dictionary]=[]
var weight_sum = 0

func add_item(item,weight: int,category:String = ""):
	items.append({"item":item,"category":category, "weight":weight})
	weight_sum += weight

func pick_item(array:Array = items, sum:int = weight_sum):
	var choosen_weight = randf_range(1, sum)
	var iteration_sum = 0
	for i in array:
		iteration_sum += i["weight"]
		if choosen_weight <= iteration_sum:
			return i["item"]
	return []

func delete_item(item):
	items = items.filter(func(e): e["item"] != item)

func pick_item_from_categories(category:Array[String]):
	var filtered_table = []
	for cat in category:
		filtered_table += items.filter(func(e): e["category"] == cat)
	var sum_table = filtered_table.reduce(func(acc,item): acc + item["weight"],0)
	return pick_item(filtered_table, sum_table)
