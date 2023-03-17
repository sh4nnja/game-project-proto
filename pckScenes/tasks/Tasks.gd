extends Node2D

onready var taskMenu = $Tasks/Command/Console/Tasks

onready var xelarChunks = $Tasks/Electrical/Core/Viewport/XelarCheck
onready var xelarBotBar = $Tasks/Electrical/Core/Bar
onready var stats = $Tasks/Electrical/Core/Stats

onready var tankBar = $Tasks/Armory/Tanks/Gas

onready var carbonBar = $Tasks/Greenhouse/PlantStats/Carbon
onready var waterBar = $Tasks/Greenhouse/PlantStats/Water

onready var commandPlayer = $Tasks/Command/CommandPlayer
onready var elecPlayer = $Tasks/Electrical/ElecPlayer
onready var armoryPlayer = $Tasks/Armory/ArmoryPlayer
onready var greenhousePlayer = $Tasks/Greenhouse/GreenHPlayer

var rng = RandomNumberGenerator.new()
var tasks = []

var setValueXBB = 0
var idxE 

var setValueTB = 100 
var idxA

var setValueCB = 100
var setValueWB = 100
var isCBSet = false
var isWBSet = false
var idxG

var valueR
var adder = 5

func _ready():
	randomTasker()
	
func addScore():
	GameModes.score += 10
	
#COMMAND#############################################################################
func randomTasker():
	tasks.clear()
	rng.randomize()
	valueR = rng.randi_range(1, 3)
	if valueR == 1:
		if idxE != null:
			randomTasker()
		else:
			elecTask()
	if valueR == 2:
		if idxA != null:
			randomTasker()
		else:
			armoryTask()
	if valueR == 3:
		if idxG != null:
			randomTasker()
		else:
			greenhouseTask()
	
func addTask(taskName):
	tasks.append(taskName)
	showTask()
	return tasks.size() - 1
	
func showTask():
	taskMenu.clear()
	for i in range(tasks.size()):
		taskMenu.add_item(tasks[i], null, false)
		

#ELECTRICAL##########################################################################
func elecTask():
	rng.randomize()
	xelarBotBar.value = rng.randi_range(1, 100)
	rng.randomize()
	setValueXBB = rng.randi_range(1, 100)
	idxE = addTask("Electrical")

func elecVisuals():
	stats.text = str(xelarBotBar.value)
	if xelarBotBar.value > setValueXBB:
		xelarChunks.speed_scale = 1
		xelarChunks.color = Color(1, 0, 0)
	elif xelarBotBar.value < setValueXBB:
		xelarChunks.speed_scale = 0.1
		xelarChunks.color = Color(0.5, 0.5, 0.5)
	elif xelarBotBar.value == setValueXBB:
		xelarChunks.speed_scale = 0.5
		xelarChunks.color = Color(0, 0.75, 1)

func _on_Bar_value_changed(value):
	elecVisuals()
	if value == setValueXBB:
		yield(get_tree().create_timer(2), "timeout")
		idxE = null
		elecPlayer.play_backwards("open")
		randomTasker()
		addScore()

#ARMORY##############################################################################
func armoryTask():
	rng.randomize()
	tankBar.value = rng.randi_range(1, 100)
	idxA = addTask("Armory")
	tankBar.modulate = Color(0, 0.5, 0.5)

func armoryVisuals():
	tankBar.modulate += Color(0, 1, 1)

func _on_Gas_value_changed(value):
	armoryVisuals()
	if value == setValueTB:
		idxA = null
		armoryPlayer.play_backwards("open")
		randomTasker()
		addScore()

func _on_Fill_pressed():
	tankBar.value -= adder

func _on_Fill2_pressed():
	tankBar.value += adder

#GREENHOUSE##########################################################################
func greenhouseTask():
	rng.randomize()
	carbonBar.value = rng.randi_range(1, 100)
	rng.randomize()
	waterBar.value = rng.randi_range(1, 100)
	idxG = addTask("Greenhouse")

func greenhouseVisuals():
	if carbonBar.value < setValueCB:
		carbonBar.modulate  = Color(0.5, 0.5, 0.5)
	elif carbonBar.value == setValueCB:
		carbonBar.modulate = Color(0, 0.75, 1)

	if waterBar.value < setValueWB:
		waterBar.modulate  = Color(0.5, 0.5, 0.5)
	elif waterBar.value == setValueWB:
		waterBar.modulate = Color(0, 0.75, 1)

func _on_Carbon_value_changed(_value):
	checkCBWB()
	greenhouseVisuals()

func _on_Water_value_changed(_value):
	checkCBWB()
	greenhouseVisuals()

func checkCBWB():
	if waterBar.value == setValueWB and carbonBar.value == setValueCB:
		idxG = null
		greenhousePlayer.play_backwards("open")
		randomTasker()
		addScore()

func _on_Down_pressed():
	carbonBar.value -= adder
func _on_Up_pressed():
	carbonBar.value += adder

func _on_Down2_pressed():
	waterBar.value -= adder
func _on_Up2_pressed():
	waterBar.value += adder

func _on_RangeC_body_entered(body):
	if body.is_in_group("Player"):
		body.get_node("GUILayer/GUI/CmdBtn").show()

func _on_RangeC_body_exited(body):
	if body.is_in_group("Player"):
		body.get_node("GUILayer/GUI/CmdBtn").hide()
		body.get_node("GUILayer/GUI/CmdBtn").pressed = false

func _on_RangeE_body_entered(body):
	if body.is_in_group("Player"):
		if tasks.has("Electrical"):
			body.get_node("GUILayer/GUI/ElecBtn").show()
		else:
			body.get_node("GUILayer/GUI/ElecBtn").hide()
func _on_RangeE_body_exited(body):
	if body.is_in_group("Player"):
		body.get_node("GUILayer/GUI/ElecBtn").hide()
		body.get_node("GUILayer/GUI/ElecBtn").pressed = false
		elecPlayer.seek(0, true)

func _on_RangeA_body_entered(body):
	if body.is_in_group("Player"):
		if tasks.has("Armory"):
			body.get_node("GUILayer/GUI/ArmoryBtn").show()
		else:
			body.get_node("GUILayer/GUI/ArmoryBtn").hide()
func _on_RangeA_body_exited(body):
	if body.is_in_group("Player"):
		body.get_node("GUILayer/GUI/ArmoryBtn").hide()
		body.get_node("GUILayer/GUI/ArmoryBtn").pressed = false
		armoryPlayer.seek(0, true)

func _on_RangeG_body_entered(body):
	if body.is_in_group("Player"):
		if tasks.has("Greenhouse"):
			body.get_node("GUILayer/GUI/GreenhouseBtn").show()
		else:
			body.get_node("GUILayer/GUI/GreenhouseBtn").hide()
func _on_RangeG_body_exited(body):
	if body.is_in_group("Player"):
		body.get_node("GUILayer/GUI/GreenhouseBtn").hide()
		body.get_node("GUILayer/GUI/GreenhouseBtn").pressed = false
		greenhousePlayer.seek(0, true)






