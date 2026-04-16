package main

import rl "vendor:raylib"

Screen :: struct {
	width:  i32,
	height: i32,
}

screen_update :: proc(game: ^Game) {
	game.screen.width = rl.GetRenderWidth()
	game.screen.height = rl.GetRenderHeight()
}
