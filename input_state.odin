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

update_input_state :: proc(input_state: ^InputState) {
	input_state^ = InputState {
		mouse_x            = rl.GetMouseX(),
		mouse_y            = rl.GetMouseY(),
		screen_width       = rl.GetScreenWidth(),
		screen_height      = rl.GetScreenHeight(),
		left_mouse_pressed = rl.IsMouseButtonPressed(.LEFT),
		delta              = rl.GetFrameTime(),
	}
}
