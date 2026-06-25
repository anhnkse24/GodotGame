extends Node2D

const W := 960
const H := 540

func _ready():
    randomize()
    get_viewport().size = Vector2(W, H)

var grid := Vector2i(32, 18)
var cell := 28
var offset := Vector2(32, 36)
var snake := [Vector2i(8, 8), Vector2i(7, 8), Vector2i(6, 8)]
var dir := Vector2i(1, 0)
var next_dir := dir
var food := Vector2i(16, 9)
var timer := 0.0
var score := 0
var dead := false

func _process(delta):
    if Input.is_action_just_pressed("ui_up") and dir.y != 1:
        next_dir = Vector2i(0, -1)
    if Input.is_action_just_pressed("ui_down") and dir.y != -1:
        next_dir = Vector2i(0, 1)
    if Input.is_action_just_pressed("ui_left") and dir.x != 1:
        next_dir = Vector2i(-1, 0)
    if Input.is_action_just_pressed("ui_right") and dir.x != -1:
        next_dir = Vector2i(1, 0)

    if dead:
        if Input.is_action_just_pressed("ui_accept"):
            get_tree().reload_current_scene()
        queue_redraw()
        return

    timer += delta
    if timer > 0.13:
        timer = 0
        dir = next_dir
        var head := snake[0] + dir
        if head.x < 0 or head.y < 0 or head.x >= grid.x or head.y >= grid.y or snake.has(head):
            dead = true
        else:
            snake.insert(0, head)
            if head == food:
                score += 1
                while snake.has(food):
                    food = Vector2i(randi_range(0, grid.x - 1), randi_range(0, grid.y - 1))
            else:
                snake.pop_back()

    queue_redraw()

func pos(v: Vector2i) -> Vector2:
    return offset + Vector2(v.x * cell, v.y * cell)

func _draw():
    draw_rect(Rect2(0, 0, W, H), Color("#081c15"))
    draw_string(ThemeDB.fallback_font, Vector2(20, 24), "Snake Classic | Arrows: Turn | Enter: Restart", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color.WHITE)
    draw_string(ThemeDB.fallback_font, Vector2(20, 50), "Score: %d" % score, HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("#ffd166"))
    draw_rect(Rect2(offset - Vector2(4, 4), Vector2(grid.x * cell + 8, grid.y * cell + 8)), Color("#1b4332"))
    draw_rect(Rect2(pos(food), Vector2(cell - 2, cell - 2)), Color("#ef476f"))
    for i in range(snake.size()):
        draw_rect(Rect2(pos(snake[i]), Vector2(cell - 2, cell - 2)), Color("#52b788") if i == 0 else Color("#95d5b2"))
    if dead:
        draw_string(ThemeDB.fallback_font, Vector2(340, 270), "GAME OVER - Press Enter", HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color("#ff595e"))
