#+feature using-stmt
package tests

import main ".."
import "core:testing"

@(test)
get_card_code_test :: proc(t: ^testing.T) {
	using main
	tc := get_card_code(Card{.Ten, .Club})
	testing.expect_value(t, tc, "tc")
	delete(tc)
}

@(test)
init_deck_test :: proc(t: ^testing.T) {
	using main
	deck := init_deck()
	testing.expect_value(t, len(deck.cards), 52)
}

@(test)
shuffle_deck_test :: proc(t: ^testing.T) {
	using main
	d1 := init_deck()
	d2 := init_deck()
	d3 := init_deck()
	d4 := init_deck()

	testing.expect(t, d1.cards == d2.cards, "unshuffled cards should match")

	shuffle_deck(&d3)
	testing.expect(t, d3.cards != d1.cards, "cards are not shuffled")

	shuffle_deck(&d4)
	testing.expect(t, d4.cards != d3.cards, "2 shuffled decks should not match")
}

@(test)
init_shuffled_deck_test :: proc(t: ^testing.T) {
	using main
	d1 := init_deck()
	d2 := init_shuffled_deck()

	testing.expect(t, d1.cards != d2.cards, "shuffled deck was not shuffled")
}

@(test)
init_card_map_test :: proc(t: ^testing.T) {
	using main
	card_map := init_card_map()
	defer destroy_card_map(card_map)

	testing.expect_value(t, card_map["jc"], Card{.Jack, .Club})
	testing.expect_value(t, card_map["3h"], Card{.Three, .Heart})
	testing.expect_value(t, len(card_map), len(STANDARD_DECK))
}

@(test)
init_cards_test :: proc(t: ^testing.T) {
	using main
	card_map := init_card_map()
	defer destroy_card_map(card_map)

	cards := init_cards("ah 2h 3h 4h 5h", card_map)
	defer delete(cards)

	testing.expect_value(t, cards[0], Card{.Ace, .Heart})
	testing.expect_value(t, cards[1], Card{.Two, .Heart})
	testing.expect_value(t, cards[2], Card{.Three, .Heart})
	testing.expect_value(t, cards[3], Card{.Four, .Heart})
	testing.expect_value(t, cards[4], Card{.Five, .Heart})
}
