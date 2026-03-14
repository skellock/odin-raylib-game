package main

import rl "vendor:raylib"

Game :: struct {
	dot:             Dot,
	camera:          rl.Camera2D,
	deck:            Deck,
	card_views:      [5]CardView,
	poker_hand_type: PokerHandType,
	tooltip:         Tooltip,
	hovered_card:    int,
	reshuffler:      Reshuffler,
}

init_game :: proc(card_images: CardImages) -> Game {
	deck := init_shuffled_deck()

	game := Game {
		dot = init_dot(),
		camera = rl.Camera2D{zoom = f32(WINDOW_HEIGHT / VIEWPORT_HEIGHT)},
		deck = deck,
		reshuffler = init_reshuffler(),
	}
	deal_to_hand(&game, card_images)

	return game
}

deal_to_hand :: proc(game: ^Game, card_images: CardImages) {
	for i in 0 ..< len(game.card_views) {
		card := game.deck.cards[i]
		tex := card_images.cards[card]
		game.card_views[i] = init_card_view(card, tex)
	}
	game.poker_hand_type = score_hand(game.deck.cards[:5])
	update_card_view_positions(game.card_views[:])
}

destroy_game :: proc(game: ^Game) {
	destroy_dot(&game.dot)
	destroy_reshuffler(&game.reshuffler)
}
