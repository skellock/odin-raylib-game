package main

import rl "vendor:raylib"

InputState :: struct {
	mouse_x:            i32,
	mouse_y:            i32,
	screen_width:       i32,
	screen_height:      i32,
	left_mouse_pressed: bool,
	delta:              f32,
}

new_input_state :: proc() -> InputState {
	return InputState{}
}

update_input_state :: proc(input_state: ^InputState) {
	input_state.mouse_x = rl.GetMouseX()
	input_state.mouse_y = rl.GetMouseY()
	input_state.screen_width = rl.GetScreenWidth()
	input_state.screen_height = rl.GetScreenHeight()
	input_state.left_mouse_pressed = rl.IsMouseButtonPressed(.LEFT)
	input_state.delta = rl.GetFrameTime()
}
