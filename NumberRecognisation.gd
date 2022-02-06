extends Control

onready var texture_display = $HBoxContainer/TextureRect
onready var btn_container = $HBoxContainer/VBoxContainer
var image: Image
var painting: bool = false
var previous_point = null
var perceptrons = 0

func _ready():
	image = Image.new()
	clear()
	for btn in btn_container.get_children():
		btn = btn as Button
		if !btn.name in ["Clear"]:
			btn.connect("pressed", self, "add_img", [int(btn.name)])

func add_img(n):
	var d  = Directory.new()
	d.open(str("res://", n))
	var num = 0
	while d.file_exists(str(num, ".png")): num += 1
	image.unlock()
	image.resize(32, 32)
	image.save_png(str("res://", n, "/", num, ".png"))
	clear()
	pass

func clear():
	image.create(320, 320, false, Image.FORMAT_RGB8)
	image.fill(Color.white)
	var t = ImageTexture.new()
	t.create_from_image(image)
	texture_display.texture = t

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			painting = true
		else:
			previous_point = null
			painting = false

func _process(delta):
	if painting:
		paint(image)
		var t = ImageTexture.new()
		t.create_from_image(image)
		texture_display.texture = t
		

func paint(img: Image):
	var pos = get_local_mouse_position()
	if previous_point:
		var dx := int(abs(pos.x - previous_point.x))
		var dy := int(-abs(pos.y - previous_point.y))
		var err := dx + dy
		var e2 := err << 1
		var sx = 1 if previous_point.x < pos.x else -1
		var sy = 1 if previous_point.y < pos.y else -1
		var x = previous_point.x
		var y = previous_point.y
		while !(x == pos.x && y == pos.y):
			e2 = err << 1
			if e2 >= dy:
				err += dy
				x += sx
			if e2 <= dx:
				err += dx
				y += sy
			draw(img, Vector2(x, y))
	else:
		draw(img, pos)

func draw(img: Image, pos: Vector2):
	img.lock()
	if !pos < Vector2(321,321): return
	var poss = Vector2()
	var pose = Vector2()
	poss.x = floor(pos.x/10)
	poss.y = floor(pos.y/10)
	pose.x = ceil(pos.x/10)
	pose.y = ceil(pos.y/10)
	poss = poss*10
	pose = pose*10
	for x in range(poss.x, pose.x):
		for y in range(poss.y, pose.y):
			img.set_pixel(x, y, Color.black)
	img.unlock()


func check():
	pass # Replace with function body.
