package main

import "core:math/rand"
import "core:strings"

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

STANDARD_DECK :: [52]Card {
	Card{.Two, .Club},
	Card{.Three, .Club},
	Card{.Four, .Club},
	Card{.Five, .Club},
	Card{.Six, .Club},
	Card{.Seven, .Club},
	Card{.Eight, .Club},
	Card{.Nine, .Club},
	Card{.Ten, .Club},
	Card{.Jack, .Club},
	Card{.Queen, .Club},
	Card{.King, .Club},
	Card{.Ace, .Club},
	Card{.Two, .Heart},
	Card{.Three, .Heart},
	Card{.Four, .Heart},
	Card{.Five, .Heart},
	Card{.Six, .Heart},
	Card{.Seven, .Heart},
	Card{.Eight, .Heart},
	Card{.Nine, .Heart},
	Card{.Ten, .Heart},
	Card{.Jack, .Heart},
	Card{.Queen, .Heart},
	Card{.King, .Heart},
	Card{.Ace, .Heart},
	Card{.Two, .Spade},
	Card{.Three, .Spade},
	Card{.Four, .Spade},
	Card{.Five, .Spade},
	Card{.Six, .Spade},
	Card{.Seven, .Spade},
	Card{.Eight, .Spade},
	Card{.Nine, .Spade},
	Card{.Ten, .Spade},
	Card{.Jack, .Spade},
	Card{.Queen, .Spade},
	Card{.King, .Spade},
	Card{.Ace, .Spade},
	Card{.Two, .Diamond},
	Card{.Three, .Diamond},
	Card{.Four, .Diamond},
	Card{.Five, .Diamond},
	Card{.Six, .Diamond},
	Card{.Seven, .Diamond},
	Card{.Eight, .Diamond},
	Card{.Nine, .Diamond},
	Card{.Ten, .Diamond},
	Card{.Jack, .Diamond},
	Card{.Queen, .Diamond},
	Card{.King, .Diamond},
	Card{.Ace, .Diamond},
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
	return Deck{STANDARD_DECK}
}

get_card_code :: proc(card: Card, allocator := context.allocator) -> string {
	return strings.concatenate({card_pip_codes[card.pip], card_suit_codes[card.suit]}, allocator)
}

shuffle_deck :: proc(deck: ^Deck) {
	rand.shuffle(deck.cards[:])
}

init_shuffled_deck :: proc() -> Deck {
	deck := init_deck()
	shuffle_deck(&deck)
	return deck
}

init_card_map :: proc() -> map[string]Card {
	result := make(map[string]Card)
	for card in STANDARD_DECK {
		code := get_card_code(card)
		result[code] = card
	}
	return result
}

destroy_card_map :: proc(card_map: map[string]Card) {
	for k, _ in card_map {delete(k)}
	delete(card_map)
}

init_cards :: proc(card_string: string, card_map: map[string]Card) -> [dynamic]Card {
	result := make([dynamic]Card)

	// jet if the string is empty
	if len(card_string) == 0 {return result}

	splits := strings.split(card_string, " ", context.temp_allocator)

	// jet if there are no splits
	if len(splits) == 0 {return result}

	for code in splits {
		card := card_map[code]
		append(&result, card)
	}

	return result
}

init_card_pip_map :: proc(cards: []Card, allocator := context.allocator) -> map[CardPip]int {
	pip_map := make(map[CardPip]int, allocator)
	for card in cards {
		pip_map[card.pip] += 1
	}
	return pip_map
}

init_card_suit_map :: proc(cards: []Card, allocator := context.allocator) -> map[CardSuit]int {
	suit_map := make(map[CardSuit]int, allocator)
	for card in cards {
		suit_map[card.suit] += 1
	}
	return suit_map
}

// --- Tests ------------------------------------------------------------------

import "core:testing"

@(test)
get_card_code_test :: proc(t: ^testing.T) {
	tc := get_card_code(Card{.Ten, .Club})
	testing.expect_value(t, tc, "tc")
	delete(tc)
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

@(test)
init_card_map_test :: proc(t: ^testing.T) {
	card_map := init_card_map()
	defer destroy_card_map(card_map)

	testing.expect_value(t, card_map["jc"], Card{.Jack, .Club})
	testing.expect_value(t, card_map["3h"], Card{.Three, .Heart})
	testing.expect_value(t, len(card_map), len(STANDARD_DECK))
}

@(test)
init_cards_test :: proc(t: ^testing.T) {
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
