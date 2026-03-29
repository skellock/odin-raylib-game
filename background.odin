package main

import rl "vendor:raylib"

draw_background :: proc(game: ^Game) {
	rl.ClearBackground(rl.WHITE)

	x := game.input.viewport.width / 2
	rl.DrawRectangle(0, 0, x, game.input.viewport.height, rl.BLUE)
	rl.DrawRectangle(x, 0, x, game.input.viewport.height, rl.SKYBLUE)
	rl.DrawRectangle(x - 1, 0, 2, game.input.viewport.height, rl.ColorAlpha(rl.WHITE, 0.5))
}
