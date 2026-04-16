#+feature using-stmt
package tests

import main "../src"
import "core:testing"

@(test)
card_code_get_test :: proc(t: ^testing.T) {
	using main, testing

	tc := card_get_code(Card{.Ten, .Club})
	defer delete(tc)
	expect_value(t, tc, "tc")
}

@(test)
deck_init_test :: proc(t: ^testing.T) {
	using main, testing

	deck := deck_init()
	expect_value(t, len(deck.cards), 52)
}

@(test)
deck_shuffle_test :: proc(t: ^testing.T) {
	using main, testing

	d1 := deck_init()
	d2 := deck_init()
	d3 := deck_init()
	d4 := deck_init()

	expect(t, d1.cards == d2.cards, "unshuffled cards should match")

	deck_shuffle(&d3)
	expect(t, d3.cards != d1.cards, "cards are not shuffled")

	deck_shuffle(&d4)
	expect(t, d4.cards != d3.cards, "2 shuffled decks should not match")
}

@(test)
deck_init_shuffled_test :: proc(t: ^testing.T) {
	using main, testing

	d1 := deck_init()
	d2 := deck_init_shuffled()

	expect(t, d1.cards != d2.cards, "shuffled deck was not shuffled")
}

@(test)
card_map_init_test :: proc(t: ^testing.T) {
	using main, testing

	card_map := card_map_init()
	defer card_map_destroy(card_map)

	expect_value(t, card_map["jc"], Card{.Jack, .Club})
	expect_value(t, card_map["3h"], Card{.Three, .Heart})
	expect_value(t, len(card_map), len(STANDARD_DECK))
}

@(test)
card_init_all_test :: proc(t: ^testing.T) {
	using main, testing

	card_map := card_map_init()
	defer card_map_destroy(card_map)

	cards := card_init_all("ah 2h 3h 4h 5h", card_map)
	defer delete(cards)

	expect_value(t, cards[0], Card{.Ace, .Heart})
	expect_value(t, cards[1], Card{.Two, .Heart})
	expect_value(t, cards[2], Card{.Three, .Heart})
	expect_value(t, cards[3], Card{.Four, .Heart})
	expect_value(t, cards[4], Card{.Five, .Heart})
}
