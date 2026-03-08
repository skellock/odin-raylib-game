package main

import rl "vendor:raylib"

Game :: struct {
	dot:            Dot,
	camera:         rl.Camera2D,
	card_images:    CardImages,
	music:          Music,
	sounds:         Sounds,
	deck:           Deck,
	hand:           [dynamic]Card,
	poker_hand:     PokerHand,
	tooltip:        Tooltip,
	card_positions: [5]rl.Vector2,
	hovered_card:   int,
}

init_game :: proc() -> Game {
	deck := init_shuffled_deck()
	hand := make([dynamic]Card)

	game := Game {
		dot = init_dot(),
		camera = rl.Camera2D{zoom = f32(WINDOW_HEIGHT / VIEWPORT_HEIGHT)},
		card_images = init_card_images(),
		music = init_music(),
		sounds = init_sounds(),
		deck = deck,
		hand = hand,
	}
	deal_to_hand(&game)

	play_music(&game.music)

	return game
}

deal_to_hand :: proc(game: ^Game) {
	clear(&game.hand)
	for i in 0 ..< 5 {
		append(&game.hand, game.deck.cards[i])
	}
	game.poker_hand = score_hand(game.hand[:])
}

destroy_game :: proc(game: ^Game) {
	delete(game.hand)
	destroy_dot(&game.dot)
	destroy_card_images(&game.card_images)
	destroy_music(&game.music)
	destroy_sounds(&game.sounds)
}
