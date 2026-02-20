package main

import rl "vendor:raylib"

draw :: proc(game: ^Game, input: ^Input) {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.BeginMode2D(game.camera)
	defer rl.EndMode2D()

	draw_background(input)
	draw_title()
	draw_dot(&game.dot, input)
	// draw_debug(input)
}

@(private = "file")
draw_background :: proc(input: ^Input) {
	rl.ClearBackground(rl.WHITE)

	x := input.viewport.width / 2
	rl.DrawRectangle(0, 0, x, input.viewport.height, rl.BLUE)
	rl.DrawRectangle(x, 0, x, input.viewport.height, rl.SKYBLUE)
	rl.DrawRectangle(x - 1, 0, 2, input.viewport.height, rl.ColorAlpha(rl.WHITE, 0.5))
}

@(private = "file")
draw_title :: proc() {
	rl.DrawText("This is a test using Odin and Raylib!", 10, 10, 8, rl.WHITE)
}
