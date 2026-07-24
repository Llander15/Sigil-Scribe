extends NinePatchRect

var DL_chapter_list = [
	{
		"title": "What is Digital Logic?",
		"description": "Digital Logic is the fundamental system used to design computing hardware and electronic systems. It serves as the basic language of computers, using binary states—0 and 1, or False and True—to process signals. By passing electrical voltages through organized networks of logic gates, a system can execute mathematical equations, store digital memory values, and perform automated structural decisions."
	},
	{
		"title": "The AND Gate",
		"description": "The AND Gate is called a logical 'AND' operation because the output is 1 (true) only when all inputs are 1 (true). Just like the word 'and' in everyday language, both conditions must be true at the same time for the result to be true.\n\nCore Function: Outputs 1 only when all inputs are 1; otherwise, it outputs 0.\n\nTruth Table:\nA | B | Output\n0 | 0 | 0\n0 | 1 | 0\n1 | 0 | 0\n1 | 1 | 1"
	},
	{
		"title": "The OR Gate",
		"description": "The OR Gate is called a logical 'OR' operation because the output is 1 (true) when at least one input is 1 (true). Similar to the word 'or' in everyday language, the result is true if one or more conditions are true.\n\nCore Function: Outputs 1 when at least one input is 1, and outputs 0 only when all inputs are 0.\n\nTruth Table:\nA | B | Output\n0 | 0 | 0\n0 | 1 | 1\n1 | 0 | 1\n1 | 1 | 1"
	},
	{
		"title": "The NOT Gate",
		"description": "The NOT Gate is called a logical 'NOT' operation because it reverses (inverts) the input value. It produces the opposite output of the input.\n\nCore Function: Reverses the input value, turning a 0 into a 1 and a 1 into a 0. It is also widely known as an inverter.\n\nTruth Table:\nA | Output\n0 | 1\n1 | 0"
	},
	{
		"title": "The NAND Gate",
		"description": "The NAND Gate represents a logical 'NOT AND' operation. It effectively performs an AND operation first and then completely reverses (inverts) the resulting output.\n\nCore Function: It acts as the exact opposite of an AND Gate, producing an output of 0 only when all inputs are 1.\n\nTruth Table:\nA | B | Output\n0 | 0 | 1\n0 | 1 | 1\n1 | 0 | 1\n1 | 1 | 0"
	},
	{
		"title": "The NOR Gate",
		"description": "The NOR Gate represents a logical 'NOT OR' operation. It performs a standard OR operation first and then immediately reverses (inverts) the resulting value.\n\nCore Function: It acts as the exact opposite of an OR Gate, producing an output of 1 only when all inputs are 0.\n\nTruth Table:\nA | B | Output\n0 | 0 | 1\n0 | 1 | 0\n1 | 0 | 0\n1 | 1 | 0"
	},
	{
		"title": "The XOR Gate",
		"description": "The XOR Gate stands for 'Exclusive OR'. It is designed to evaluate input variations and produces an output of 1 (true) only when the provided inputs are completely different from each other.\n\nCore Function: Outputs 1 when inputs are different, and outputs 0 when both inputs are the same.\n\nTruth Table:\nA | B | Output\n0 | 0 | 0\n0 | 1 | 1\n1 | 0 | 1\n1 | 1 | 0"
	},
	{
		"title": "The XNOR Gate",
		"description": "The XNOR Gate stands for 'Exclusive NOR' or 'NOT XOR'. It executes an exclusive OR operation first and then completely reverses (inverts) that result.\n\nCore Function: Outputs 1 when the inputs are exactly the same, and outputs 0 when the inputs are different.\n\nTruth Table:\nA | B | Output\n0 | 0 | 1\n0 | 1 | 0\n1 | 0 | 0\n1 | 1 | 1"
	}
]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_Button1_pressed()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button1_pressed():
	var chapter = DL_chapter_list[0]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]
	
	
func _on_Button2_pressed():
	var chapter = DL_chapter_list[1]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button3_pressed():
	var chapter = DL_chapter_list[2]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button4_pressed():
	var chapter = DL_chapter_list[3]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button5_pressed():
	var chapter = DL_chapter_list[4]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button6_pressed():
	var chapter = DL_chapter_list[5]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button7_pressed():
	var chapter = DL_chapter_list[6]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]


func _on_Button8_pressed():
	var chapter = DL_chapter_list[7]
	$"Content panel/Contents".scroll_vertical = 0
	$"Content panel/Contents/VBoxContainer/Title".text = chapter["title"]
	$"Content panel/Contents/VBoxContainer/Description".text = chapter["description"]
