package main

import rl "vendor:raylib"

draw_cursor :: proc(game: Game) {
	if game.hovered_card < 0 {
		rl.SetMouseCursor(.DEFAULT)
	} else {
		rl.SetMouseCursor(.POINTING_HAND)
	}
}
