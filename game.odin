package main

import rl "vendor:raylib"

Game :: struct {
	dot:    Dot,
	camera: rl.Camera2D,
}

init_game :: proc() -> Game {
	return Game {
		dot = init_dot(),
		camera = rl.Camera2D{zoom = f32(WINDOW_HEIGHT / VIEWPORT_HEIGHT)},
	}
}
