package main

import rl "vendor:raylib"

UserInput :: struct {
	mouse_x:       i32,
	mouse_y:       i32,
	screen_width:  i32,
	screen_height: i32,
}

process_user_input :: proc(user_input: ^UserInput) {
	user_input^ = UserInput {
		mouse_x       = rl.GetMouseX(),
		mouse_y       = rl.GetMouseY(),
		screen_width  = rl.GetScreenWidth(),
		screen_height = rl.GetScreenHeight(),
	}
}
