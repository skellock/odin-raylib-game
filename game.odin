package main

import rl "vendor:raylib"

Game :: struct {
	dot:         Dot,
	camera:      rl.Camera2D,
	card_images: CardImages,
	music:       Music,
	sounds:      Sounds,
	deck:        Deck,
}

init_game :: proc() -> Game {
	game := Game {
		dot = init_dot(),
		camera = rl.Camera2D{zoom = f32(WINDOW_HEIGHT / VIEWPORT_HEIGHT)},
		card_images = init_card_images(),
		music = init_music(),
		sounds = init_sounds(),
		deck = init_shuffled_deck(),
	}

	play_music(&game.music)

	return game
}

destroy_game :: proc(game: ^Game) {
	destroy_card_images(&game.card_images)
	destroy_music(&game.music)
	destroy_sounds(&game.sounds)
}
