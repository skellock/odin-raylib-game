package main

import rl "vendor:raylib"

cursor_draw :: proc(game: ^Game) {
	if game.hovered_card < 0 {
		rl.SetMouseCursor(.DEFAULT)
	} else {
		rl.SetMouseCursor(.POINTING_HAND)
	}
}
