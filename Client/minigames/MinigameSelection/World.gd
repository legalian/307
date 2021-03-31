extends Node

onready var minigameAnimation = get_node("AnimationPlayer")

var minigameList = [["Racing", "Race Around the Track, Use Power Ups, and Pass All Other Racers To Win!", "res://minigames/MinigameSelection/MinigameSprites/RacingThumbnail.png"],
["Battle Royale", "Drop on A Huge Map, Pick Up Weapons, and Eliminate Other Players to be the Last Remaining!", "res://minigames/MinigameSelection/MinigameSprites/BattleRoyale_Icon.png"], 
["Demolition Derby", "Use Power Ups and Ram into Other Players to be the Last Remaining!", "res://minigames/MinigameSelection/MinigameSprites/CarSelectionPage.png"]
]
var currentMinigame = 0

func _ready():
	minigameAnimation.connect("finished", self, "Finished_Animation")
	minigameAnimation.play("SelectMinigameDisplay")
	_Set_Minigame()
	

func _Select_Minigame():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var RandomMinigame = rng.randi_range(0, minigameList.size()-1)
	currentMinigame = RandomMinigame

func _Set_Minigame():
	_Select_Minigame()
	find_node("MinigameTitle").bbcode_text = "[center]" + minigameList[currentMinigame][0]
	find_node("MinigameSummary").bbcode_text = "[center]" + minigameList[currentMinigame][1]
	find_node("MinigameIcon").texture = load(minigameList[currentMinigame][2])

func Finished_Animation(): # Not Triggering?
	print("Transition Scene")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
