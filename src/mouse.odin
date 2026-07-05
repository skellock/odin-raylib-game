package main

import rl "vendor:raylib"

Mouse :: struct {
	screen_pos:    rl.Vector2,
	world_pos:     rl.Vector2,
	left_pressed:  bool, // Has the left button been pressed?
	right_pressed: bool, // Has the right button been pressed?
}

mouse_update :: proc(mouse: ^Mouse, camera: rl.Camera2D) {
	mouse.screen_pos = rl.GetMousePosition()
	mouse.world_pos = rl.GetScreenToWorld2D(mouse.screen_pos, camera)
	mouse.left_pressed = rl.IsMouseButtonPressed(.LEFT)
	mouse.right_pressed = rl.IsMouseButtonPressed(.RIGHT)
}
