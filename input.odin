package main

import rl "vendor:raylib"

MouseInput :: struct {
	screen_pos:    rl.Vector2,
	world_pos:     rl.Vector2,
	left_pressed:  bool, // Has the left button been pressed?
	right_pressed: bool, // Has the right button been pressed?
}

KeyboardInput :: struct {
	quit_pressed:  bool,
	pause_pressed: bool,
}

Input :: struct {
	mouse:    MouseInput,
	keyboard: KeyboardInput,
}

update_input :: proc(game: ^Game) {
	// mouse coordinates
	game.input.mouse.screen_pos = rl.GetMousePosition()
	game.input.mouse.world_pos = rl.GetScreenToWorld2D(game.input.mouse.screen_pos, game.camera)

	// button presses
	game.input.mouse.left_pressed = rl.IsMouseButtonPressed(.LEFT)
	game.input.mouse.right_pressed = rl.IsMouseButtonPressed(.RIGHT)

	// keyboard
	game.input.keyboard.quit_pressed = rl.IsKeyPressed(.Q)
	game.input.keyboard.pause_pressed = rl.IsKeyPressed(.P)
}
