extends PanelContainer

signal clicked

@onready var name_label: Label = %NameLabel
@onready var desc_label: Label = %DescriptionLabel
@onready var ability_texture: TextureRect = %TextureRect

var disabled = false

func _ready():
	mouse_entered.connect(on_mouse_entered)

func play_in(delay:float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("in")

func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	desc_label.text = upgrade.description
	ability_texture.texture = upgrade.picture
	

func play_discard():
	$AnimationPlayer.play("discarded")
	

func select_card():
	disabled = true
	$AnimationPlayer.play("selected")
	
	for other_cards in get_tree().get_nodes_in_group("upgrade_card"):
		if other_cards != self:
			other_cards.play_discard()
	
	await  $AnimationPlayer.animation_finished
	clicked.emit()

func _on_gui_input(event: InputEvent):
	if disabled :
		
		return 
	if event.is_action_pressed("left_click"):
		select_card()
		
		

func on_mouse_entered():
	if !disabled:
		$HoverAnimationPlayer.play("hover")
