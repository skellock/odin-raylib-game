package main

import rl "vendor:raylib"

MouseInput :: struct {
	screen_pos:    rl.Vector2,
	world_pos:     rl.Vector2,
	left_pressed:  bool, // Has the left button been pressed?
	right_pressed: bool, // Has the right button been pressed?
}

ScreenInput :: struct {
	width:  i32,
	height: i32,
}

ViewportInput :: struct {
	width:  i32,
	height: i32,
}

TimeInput :: struct {
	dt:      f32, // The frame's delta time.
	elapsed: f64, // How long the game has been running
}

KeyboardInput :: struct {
	quit_pressed:  bool,
	pause_pressed: bool,
}

Input :: struct {
	mouse:    MouseInput,
	keyboard: KeyboardInput,
	screen:   ScreenInput,
	viewport: ViewportInput,
	time:     TimeInput,
}

resolve_input :: proc(input: ^Input, game: Game) {
	// mouse coordinates
	input.mouse.screen_pos = rl.GetMousePosition()
	input.mouse.world_pos = rl.GetScreenToWorld2D(input.mouse.screen_pos, game.camera)

	// button presses
	input.mouse.left_pressed = rl.IsMouseButtonPressed(.LEFT)
	input.mouse.right_pressed = rl.IsMouseButtonPressed(.RIGHT)

	// keyboard
	input.keyboard.quit_pressed = rl.IsKeyPressed(.Q)
	input.keyboard.pause_pressed = rl.IsKeyPressed(.P)

	// screen stuff
	input.screen.width = rl.GetScreenWidth()
	input.screen.height = rl.GetScreenHeight()
	input.viewport.width = VIEWPORT_WIDTH
	input.viewport.height = VIEWPORT_HEIGHT

	// time
	input.time.dt = rl.GetFrameTime()
	input.time.elapsed = rl.GetTime()
}
