package main

import rl "vendor:raylib"

MouseInput :: struct {
	x:            i32,
	y:            i32,
	left_pressed: bool,
}

ScreenInput :: struct {
	width:  i32,
	height: i32,
}

TimeInput :: struct {
	frame32: f32,
	frame64: f64,
	game:    f64,
}

Input :: struct {
	mouse:  MouseInput,
	screen: ScreenInput,
	time:   TimeInput,
}

init_input :: proc() -> Input {
	return Input{}
}

capture_input :: proc(input: ^Input) {
	input.mouse.x = rl.GetMouseX()
	input.mouse.y = rl.GetMouseY()
	input.mouse.left_pressed = rl.IsMouseButtonPressed(.LEFT)

	input.screen.width = rl.GetScreenWidth()
	input.screen.height = rl.GetScreenHeight()

	input.time.frame32 = rl.GetFrameTime()
	input.time.frame64 = f64(input.time.frame32)
	input.time.game = rl.GetTime()
}
