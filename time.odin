package main

import rl "vendor:raylib"

Time :: struct {
	dt:      f32, // The frame's delta time.
	elapsed: f64, // How long the game has been running
}

update_time :: proc(game: ^Game) {
	game.time.dt = rl.GetFrameTime()
	game.time.elapsed = rl.GetTime()
}
