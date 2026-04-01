package main

import rl "vendor:raylib"

Keyboard :: struct {
	quit_pressed:  bool,
	pause_pressed: bool,
	load_pressed:  bool,
	save_pressed:  bool,
}

update_keyboard :: proc(game: ^Game) {
	game.keyboard.quit_pressed = rl.IsKeyPressed(.Q)
	game.keyboard.pause_pressed = rl.IsKeyPressed(.P)
	game.keyboard.load_pressed = rl.IsKeyPressed(.L)
	game.keyboard.save_pressed = rl.IsKeyPressed(.S)
}
