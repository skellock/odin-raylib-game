package main

import rl "vendor:raylib"

Keyboard :: struct {
	quit_pressed:      bool,
	pause_pressed:     bool,
	load_pressed:      bool,
	save_pressed:      bool,
	enter_pressed:     bool,
	backspace_pressed: bool,
	escape_pressed:    bool,
	slash_pressed:     bool,
}

update_keyboard :: proc(game: ^Game) {
	k := &game.keyboard

	k.escape_pressed = rl.IsKeyPressed(.ESCAPE)
	k.enter_pressed = rl.IsKeyPressed(.ENTER)
	k.slash_pressed = rl.IsKeyPressed(.SLASH)
	k.backspace_pressed = rl.IsKeyPressed(.BACKSPACE) || rl.IsKeyPressedRepeat(.BACKSPACE)

	if !game.console.active {
		k.quit_pressed = rl.IsKeyPressed(.Q)
		k.pause_pressed = rl.IsKeyPressed(.P)
		k.load_pressed = rl.IsKeyPressed(.L)
		k.save_pressed = rl.IsKeyPressed(.S)
	}
}
