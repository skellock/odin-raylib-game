package main

import "core:sort"
import rl "vendor:raylib"

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

draw_poker_hand_type_text :: proc(game: Game, input: Input) {
	text: cstring
	switch game.poker_hand_type {
	case .Nothing:
		text = "Nothing"
	case .HighCard:
		text = "High Card"
	case .Pair:
		text = "Pair"
	case .TwoPair:
		text = "Two Pair"
	case .ThreeOfAKind:
		text = "Three of a Kind"
	case .Straight:
		text = "Straight"
	case .Flush:
		text = "Flush"
	case .FullHouse:
		text = "Full House"
	case .FourOfAKind:
		text = "Four of a Kind"
	case .StraightFlush:
		text = "Straight Flush"
	case .RoyalFlush:
		text = "Royal Flush"
	}

	FONT_SIZE :: i32(20)
	MARGIN_TOP :: i32(10)

	// center text with the hand of cards
	first := game.hand[0]
	last := game.hand[len(game.hand) - 1]
	card_w := f32(first.texture.width) * CARD_SCALE
	card_h := f32(first.texture.height) * CARD_SCALE
	hand_center_x := (first.pos.x + last.pos.x + card_w) / 2
	text_w := f32(rl.MeasureText(text, FONT_SIZE))
	x := i32(hand_center_x - text_w / 2)
	y := i32(first.pos.y + card_h) + MARGIN_TOP

	rl.DrawText(text, x, y, FONT_SIZE, rl.WHITE)
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
