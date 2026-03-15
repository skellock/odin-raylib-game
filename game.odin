package main

import rl "vendor:raylib"

Game :: struct {
	dot:          Dot,
	camera:       rl.Camera2D,
	deck:         Deck,
	card_views:   [5]CardView,
	poker_hand:   PokerHand,
	tooltip:      Tooltip,
	hovered_card: int,
	reshuffler:   Reshuffler,
}

init_game :: proc(card_images: CardImages) -> Game {
	game := Game {
		dot = init_dot(),
		camera = rl.Camera2D{zoom = f32(WINDOW_HEIGHT / VIEWPORT_HEIGHT)},
		deck = init_shuffled_deck(),
		reshuffler = init_reshuffler(),
	}
	deal_to_hand(&game, card_images)

	return game
}

deal_to_hand :: proc(game: ^Game, card_images: CardImages) {
	game.poker_hand = init_poker_hand(game.deck.cards[:5])
	for card, i in game.poker_hand.cards {
		tex := card_images.cards[card]
		game.card_views[i] = init_card_view(card, tex)
	}
	update_card_view_positions(game.card_views[:])
}

destroy_game :: proc(game: ^Game) {
	destroy_dot(&game.dot)
	destroy_reshuffler(&game.reshuffler)
}
