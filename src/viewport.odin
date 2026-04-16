package main

VIEWPORT_WIDTH :: 1920
VIEWPORT_HEIGHT :: 1080

Viewport :: struct {
	width:  i32,
	height: i32,
}

viewport_update :: proc(game: ^Game) {
	game.viewport.width = VIEWPORT_WIDTH
	game.viewport.height = VIEWPORT_HEIGHT
}
