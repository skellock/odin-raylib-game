package main

import rl "vendor:raylib"

Game :: struct {
	dot:         Dot,
	camera:      rl.Camera2D,
	card_images: CardImages,
}

init_game :: proc() -> Game {
	return Game {
		dot = init_dot(),
		camera = rl.Camera2D{zoom = f32(WINDOW_HEIGHT / VIEWPORT_HEIGHT)},
		card_images = init_card_images(),
	}
}

destroy_game :: proc(game: ^Game) {
	destroy_card_images(&game.card_images)
}
