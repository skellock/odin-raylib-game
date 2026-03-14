package main

import rl "vendor:raylib"

Game :: struct {
	dot:             Dot,
	camera:          rl.Camera2D,
	card_images:     CardImages,
	deck:            Deck,
	hand:            [dynamic]CardView,
	poker_hand_type: PokerHandType,
	tooltip:         Tooltip,
	hovered_card:    int,
	reshuffler:      Reshuffler,
}

init_game :: proc() -> Game {
	deck := init_shuffled_deck()
	hand := make([dynamic]CardView)

	game := Game {
		dot = init_dot(),
		camera = rl.Camera2D{zoom = f32(WINDOW_HEIGHT / VIEWPORT_HEIGHT)},
		card_images = init_card_images(),
		deck = deck,
		hand = hand,
		reshuffler = init_reshuffler(),
	}
	deal_to_hand(&game)

	return game
}

deal_to_hand :: proc(game: ^Game) {
	clear(&game.hand)
	for i in 0 ..< 5 {
		card := game.deck.cards[i]
		tex := game.card_images.cards[card]
		append(&game.hand, init_card_view(card, tex))
	}
	game.poker_hand_type = score_hand(hand_cards(game.hand[:], context.temp_allocator))
	update_card_view_positions(game.hand[:])
}

hand_cards :: proc(hand: []CardView, allocator := context.allocator) -> []Card {
	cards := make([]Card, len(hand), allocator)
	for cv, i in hand {
		cards[i] = cv.card
	}
	return cards
}

destroy_game :: proc(game: ^Game) {
	destroy_dot(&game.dot)
	destroy_reshuffler(&game.reshuffler)
	delete(game.hand)
	destroy_card_images(&game.card_images)
}
