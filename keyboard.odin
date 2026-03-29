package main

import rl "vendor:raylib"

Keyboard :: struct {
	quit_pressed:  bool,
	pause_pressed: bool,
}

update_keyboard :: proc(game: ^Game) {
	game.keyboard.quit_pressed = rl.IsKeyPressed(.Q)
	game.keyboard.pause_pressed = rl.IsKeyPressed(.P)
}
