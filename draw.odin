package main

import rl "vendor:raylib"

draw :: proc(game: ^Game, input: ^Input) {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	draw_background(input)
	draw_title()
	draw_dot(&game.dot, input)
	draw_debug(input)
}

@(private = "file")
draw_background :: proc(input: ^Input) {
	rl.ClearBackground(rl.SKYBLUE)

	x := input.screen.width / 2
	rl.DrawRectangle(0, 0, x, input.screen.height, rl.BLUE)
	rl.DrawRectangle(x - 1, 0, 2, input.screen.height, rl.ColorAlpha(rl.WHITE, 0.5))
}

@(private = "file")
draw_title :: proc() {
	rl.DrawText("This is a test using Odin and Raylib!", 10, 10, 20, rl.WHITE)
}
