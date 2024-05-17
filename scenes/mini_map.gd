extends MarginContainer

@export var zoom = 1.5

@onready var player = $"../../../Player"
@onready var mineral_tag = $MineralTag
@onready var flag_tag = $FlagTag

@onready var grid = $Grid

@onready var icons = {
	"mineral" : mineral_tag,
	"flag" : flag_tag
}

var grid_scale
var markers = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	Global.connect("item_added", update_minimap)
	Global.connect("flag_placed", update_minimap)
	grid_scale = grid.size / (get_viewport_rect().size * zoom)
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for item in map_objects:
		var new_marker = icons[item.minimap_icon].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !player:
		return
	
	for item in markers:
		if is_instance_valid(item):
			var obj_pos = (item.position - player.position) * grid_scale + grid.size / 2
			obj_pos = obj_pos.clamp(Vector2.ZERO, grid.size)
			markers[item].position = obj_pos
			if grid.get_rect().has_point(obj_pos + grid.position):
				markers[item].visible = true
			else:
				markers[item].visible = false
			


func update_minimap():
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for i in grid.get_children():
		i.queue_free()

	for item in map_objects:
		var new_marker = icons[item.minimap_icon].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker
