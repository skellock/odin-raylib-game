package main

import "core:math"
import rl "vendor:raylib"

background_draw :: proc() {
	rl.ClearBackground(rl.WHITE)

	gw := rl.GetRenderWidth()
	gh := rl.GetRenderHeight()
	x := gw / 2
	rl.DrawRectangle(0, 0, x, gh, rl.BLUE)
	rl.DrawRectangle(x, 0, x, gh, rl.SKYBLUE)
	rl.DrawRectangle(x - 1, 0, 2, gh, rl.ColorAlpha(rl.WHITE, 0.5))

	background_draw_checkboard()
}

@(private = "file")
background_draw_checkboard :: proc() {
	gw := rl.GetRenderWidth()
	gh := rl.GetRenderHeight()
	SIZE :: 96
	OFFSET :: SIZE / 2
	color1 := rl.ColorAlpha(rl.WHITE, 0.1)
	color2 := rl.ColorAlpha(rl.WHITE, 0.05)
	rows := math.floor_div(gh, SIZE) + 1
	cols := math.floor_div(gw, SIZE) + 1
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
