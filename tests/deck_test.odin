package tests

import main ".."
import "core:testing"

@(test)
get_card_code_test :: proc(t: ^testing.T) {
	tc := main.get_card_code(main.Card{.Ten, .Club})
	testing.expect_value(t, tc, "tc")
	delete(tc)
}

@(test)
init_deck_test :: proc(t: ^testing.T) {
	deck := main.init_deck()
	testing.expect_value(t, len(deck.cards), 52)
}

@(test)
shuffle_deck_test :: proc(t: ^testing.T) {
	d1 := main.init_deck()
	d2 := main.init_deck()
	d3 := main.init_deck()
	d4 := main.init_deck()

	testing.expect(t, d1.cards == d2.cards, "unshuffled cards should match")

	main.shuffle_deck(&d3)
	testing.expect(t, d3.cards != d1.cards, "cards are not shuffled")

	main.shuffle_deck(&d4)
	testing.expect(t, d4.cards != d3.cards, "2 shuffled decks should not match")
}

@(test)
init_shuffled_deck_test :: proc(t: ^testing.T) {
	d1 := main.init_deck()
	d2 := main.init_shuffled_deck()

	testing.expect(t, d1.cards != d2.cards, "shuffled deck was not shuffled")
}

@(test)
init_card_map_test :: proc(t: ^testing.T) {
	card_map := main.init_card_map()
	defer main.destroy_card_map(card_map)

	testing.expect_value(t, card_map["jc"], main.Card{.Jack, .Club})
	testing.expect_value(t, card_map["3h"], main.Card{.Three, .Heart})
	testing.expect_value(t, len(card_map), len(main.STANDARD_DECK))
}

@(test)
init_cards_test :: proc(t: ^testing.T) {
	card_map := main.init_card_map()
	defer main.destroy_card_map(card_map)

	cards := main.init_cards("ah 2h 3h 4h 5h", card_map)
	defer delete(cards)

	testing.expect_value(t, cards[0], main.Card{.Ace, .Heart})
	testing.expect_value(t, cards[1], main.Card{.Two, .Heart})
	testing.expect_value(t, cards[2], main.Card{.Three, .Heart})
	testing.expect_value(t, cards[3], main.Card{.Four, .Heart})
	testing.expect_value(t, cards[4], main.Card{.Five, .Heart})
}
