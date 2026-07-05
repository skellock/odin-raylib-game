package main

import rl "vendor:raylib"

Time :: struct {
	dt: f32, // The frame's delta time.
}

time_update :: proc(time: ^Time) {
	time.dt = rl.GetFrameTime()
}
