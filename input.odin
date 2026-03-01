package main

import rl "vendor:raylib"

MouseInput :: struct {
	screen_x:      i32,
	screen_y:      i32,
	world_x:       i32,
	world_y:       i32,
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

Input :: struct {
	mouse:    MouseInput,
	screen:   ScreenInput,
	viewport: ViewportInput,
	time:     TimeInput,
}

init_input :: proc() -> Input {
	return Input{}
}

capture_input :: proc(game: ^Game, input: ^Input) {
	// mouse coordinates
	screen_pos := rl.GetMousePosition()
	input.mouse.screen_x = i32(screen_pos.x)
	input.mouse.screen_y = i32(screen_pos.y)

	world_pos := rl.GetScreenToWorld2D(screen_pos, game.camera)
	input.mouse.world_x = i32(world_pos.x)
	input.mouse.world_y = i32(world_pos.y)

	// button presses
	input.mouse.left_pressed = rl.IsMouseButtonPressed(.LEFT)
	input.mouse.right_pressed = rl.IsMouseButtonPressed(.RIGHT)

	// screen stuff
	input.screen.width = rl.GetScreenWidth()
	input.screen.height = rl.GetScreenHeight()
	input.viewport.width = VIEWPORT_WIDTH
	input.viewport.height = VIEWPORT_HEIGHT

	// time
	input.time.dt = rl.GetFrameTime()
	input.time.elapsed = rl.GetTime()
}
