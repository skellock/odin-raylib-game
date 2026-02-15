package main

import rl "vendor:raylib"

MouseInputState :: struct {
	x:            i32,
	y:            i32,
	left_pressed: bool,
}

InputState :: struct {
	mouse:         MouseInputState,
	screen_width:  i32,
	screen_height: i32,
	delta:         f32,
}

new_input_state :: proc() -> InputState {
	return InputState{}
}

update_input_state :: proc(input: ^InputState) {
	input.mouse.x = rl.GetMouseX()
	input.mouse.y = rl.GetMouseY()
	input.mouse.left_pressed = rl.IsMouseButtonPressed(.LEFT)
	input.screen_width = rl.GetScreenWidth()
	input.screen_height = rl.GetScreenHeight()
	input.delta = rl.GetFrameTime()
}
