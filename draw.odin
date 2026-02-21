package main

import rl "vendor:raylib"

draw :: proc(game: ^Game, input: ^Input) {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.BeginMode2D(game.camera)
	defer rl.EndMode2D()

	draw_background(input)
	draw_title()
	draw_cards(game, input)
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

@(private = "file")
draw_cards :: proc(game: ^Game, input: ^Input) {
	rl.DrawTextureEx(game.card_images.cards["ah"], {200, 200}, 0, 0.5, rl.WHITE)
	rl.DrawTextureEx(game.card_images.cards["qc"], {231, 200}, 0, 0.5, rl.WHITE)
	rl.DrawTextureEx(game.card_images.cards["3d"], {262, 200}, 0, 0.5, rl.WHITE)
	rl.DrawTextureEx(game.card_images.cards["th"], {293, 200}, 0, 0.5, rl.WHITE)
	rl.DrawTextureEx(game.card_images.cards["ks"], {324, 200}, 0, 0.5, rl.WHITE)
}
