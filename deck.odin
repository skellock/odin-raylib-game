package main

import "core:fmt"
import "core:math/rand"
import "core:slice"

CardSuit :: enum {
	Club,
	Heart,
	Spade,
	Diamond,
}

CardPip :: enum {
	Two,
	Three,
	Four,
	Five,
	Six,
	Seven,
	Eight,
	Nine,
	Ten,
	Jack,
	Queen,
	King,
	Ace,
}

Card :: struct {
	pip:  CardPip,
	suit: CardSuit,
}

Deck :: struct {
	cards: [52]Card,
}

@(private = "file")
card_pip_codes := [CardPip]string {
	.Two   = "2",
	.Three = "3",
	.Four  = "4",
	.Five  = "5",
	.Six   = "6",
	.Seven = "7",
	.Eight = "8",
	.Nine  = "9",
	.Ten   = "t",
	.Jack  = "j",
	.Queen = "q",
	.King  = "k",
	.Ace   = "a",
}

@(private = "file")
card_suit_codes := [CardSuit]string {
	.Club    = "c",
	.Heart   = "h",
	.Spade   = "s",
	.Diamond = "d",
}

init_deck :: proc() -> Deck {
	deck := Deck{}

	i := 0
	for suit in CardSuit {
		for pip in CardPip {
			deck.cards[i] = Card{pip, suit}
			i += 1
		}
	}

	return deck
}

get_card_code :: proc(card: Card) -> string {
	return fmt.tprintf("%v%v", card_pip_codes[card.pip], card_suit_codes[card.suit])
}

shuffle_deck :: proc(deck: ^Deck) {
	rand.shuffle(deck.cards[:])
}

init_shuffled_deck :: proc() -> Deck {
	deck := init_deck()
	shuffle_deck(&deck)
	return deck
}

// --- Tests ------------------------------------------------------------------

import "core:testing"

@(test)
get_card_code_test :: proc(t: ^testing.T) {
	testing.expect_value(t, get_card_code(Card{.Ten, .Club}), "tc")
	testing.expect_value(t, get_card_code(Card{.Four, .Heart}), "4h")
	testing.expect_value(t, get_card_code(Card{.Queen, .Spade}), "qs")
	testing.expect_value(t, get_card_code(Card{.Ace, .Diamond}), "ad")
}

@(test)
init_deck_test :: proc(t: ^testing.T) {
	deck := init_deck()
	testing.expect_value(t, len(deck.cards), 52)
}

@(test)
shuffle_deck_test :: proc(t: ^testing.T) {
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
	d1 := init_deck()
	d2 := init_shuffled_deck()

	testing.expect(t, d1.cards != d2.cards, "shuffled deck was not shuffled")
}
