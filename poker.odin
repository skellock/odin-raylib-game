package main

import "core:sort"

PokerHandType :: enum {
	Nothing,
	HighCard,
	Pair,
	TwoPair,
	ThreeOfAKind,
	Straight,
	Flush,
	FullHouse,
	FourOfAKind,
	StraightFlush,
	RoyalFlush,
}

poker_odds := [PokerHandType]f64 {
	.Nothing       = 0.0,
	.HighCard      = 1.0,
	.Pair          = 0.422569,
	.TwoPair       = 0.047539,
	.ThreeOfAKind  = 0.021128,
	.Straight      = 0.003925,
	.Flush         = 0.001965,
	.FullHouse     = 0.001441,
	.FourOfAKind   = 0.000240,
	.StraightFlush = 0.0000139,
	.RoyalFlush    = 0.00000154,
}

has_high_card :: proc(cards: []Card) -> bool {
	return len(cards) == 5
}

// A helper to check if there's 2, 3 or 4 of a kind.
@(private = "file")
has_number_of_common_pips :: proc(cards: []Card, number: int) -> bool {
	if len(cards) != 5 do return false

	pip_map := init_card_pip_map(cards, context.temp_allocator)

	for _, count in pip_map {
		if count == number do return true
	}

	return false
}

has_pair :: proc(cards: []Card) -> bool {
	return has_number_of_common_pips(cards, 2)
}

has_two_pair :: proc(cards: []Card) -> bool {
	if len(cards) != 5 do return false

	pip_map := init_card_pip_map(cards, context.temp_allocator)

	doubles := 0
	for _, count in pip_map {
		if count == 2 {doubles += 1}
		if doubles == 2 do return true
	}

	return false
}

has_three_of_a_kind :: proc(cards: []Card) -> bool {
	return has_number_of_common_pips(cards, 3)
}

has_straight :: proc(cards: []Card) -> bool {
	if len(cards) != 5 do return false

	pip_set := make(map[CardPip]int, context.temp_allocator)
	for card in cards {
		map_insert(&pip_set, card.pip, 0)
	}

	if len(pip_set) != 5 do return false

	pips := make([dynamic]int, context.temp_allocator)
	for pip, _ in pip_set {
		append(&pips, int(pip))
	}
	sort.bubble_sort(pips[:])

	// Check for the wheel (A-2-3-4-5) where Ace acts as low.
	if pips[4] == int(CardPip.Ace) && pips[3] == int(CardPip.Five) {
		return true
	}

	for i in 0 ..< len(pips) - 1 {
		if pips[i + 1] - pips[i] != 1 do return false
	}

	return true
}

has_flush :: proc(cards: []Card) -> bool {
	if len(cards) != 5 do return false

	suit_map := init_card_suit_map(cards, context.temp_allocator)

	for _, count in suit_map {
		if count == 5 do return true
	}

	return false
}

has_full_house :: proc(cards: []Card) -> bool {
	return has_number_of_common_pips(cards, 3) && has_number_of_common_pips(cards, 2)
}

has_four_of_a_kind :: proc(cards: []Card) -> bool {
	return has_number_of_common_pips(cards, 4)
}

has_straight_flush :: proc(cards: []Card) -> bool {
	return has_flush(cards) && has_straight(cards)
}

has_royal_flush :: proc(cards: []Card) -> bool {
	if !has_straight_flush(cards) do return false
	pip_map := init_card_pip_map(cards, context.temp_allocator)
	return pip_map[.Ten] == 1 && pip_map[.Ace] == 1
}

score_hand :: proc(cards: []Card) -> PokerHandType {
	if has_royal_flush(cards) do return .RoyalFlush
	if has_straight_flush(cards) do return .StraightFlush
	if has_four_of_a_kind(cards) do return .FourOfAKind
	if has_full_house(cards) do return .FullHouse
	if has_flush(cards) do return .Flush
	if has_straight(cards) do return .Straight
	if has_three_of_a_kind(cards) do return .ThreeOfAKind
	if has_two_pair(cards) do return .TwoPair
	if has_pair(cards) do return .Pair
	if has_high_card(cards) do return .HighCard
	return .Nothing
}
