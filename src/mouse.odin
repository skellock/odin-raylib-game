package main

import rl "vendor:raylib"

Mouse :: struct {
	screen_pos:    rl.Vector2,
	world_pos:     rl.Vector2,
	left_pressed:  bool, // Has the left button been pressed?
	right_pressed: bool, // Has the right button been pressed?
}

update_mouse :: proc(game: ^Game) {
	game.mouse.screen_pos = rl.GetMousePosition()
	game.mouse.world_pos = rl.GetScreenToWorld2D(game.mouse.screen_pos, game.camera)
	game.mouse.left_pressed = rl.IsMouseButtonPressed(.LEFT)
	game.mouse.right_pressed = rl.IsMouseButtonPressed(.RIGHT)
}
