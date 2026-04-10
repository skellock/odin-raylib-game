package main

import "core:math"
import rl "vendor:raylib"

draw_background :: proc(game: ^Game) {
	rl.ClearBackground(rl.WHITE)

	x := game.viewport.width / 2
	rl.DrawRectangle(0, 0, x, game.viewport.height, rl.BLUE)
	rl.DrawRectangle(x, 0, x, game.viewport.height, rl.SKYBLUE)
	rl.DrawRectangle(x - 1, 0, 2, game.viewport.height, rl.ColorAlpha(rl.WHITE, 0.5))

	draw_checkerboard(game)
}

@(private = "file")
draw_checkerboard :: proc(game: ^Game) {
	SIZE :: 48
	OFFSET :: SIZE / 2
	color1 := rl.ColorAlpha(rl.WHITE, 0.1)
	color2 := rl.ColorAlpha(rl.WHITE, 0.05)
	rows := math.floor_div(game.viewport.height, SIZE) + 1
	cols := math.floor_div(game.viewport.width, SIZE) + 1
	color: rl.Color

	for r in 0 ..< rows {
		even_row := math.floor_mod(r, 2) == 0
		for c in 0 ..< cols {
			even_col := math.floor_mod(c, 2) == 0
			if even_row {
				color = even_col ? color2 : color1
			} else {
				color = even_col ? color1 : color2
			}
			rl.DrawRectangle(c * SIZE - OFFSET, r * SIZE - OFFSET, SIZE, SIZE, color)
		}
	}

}
