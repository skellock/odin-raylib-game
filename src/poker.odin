package main

import "core:fmt"
import "core:sort"

PokerHand :: struct {
	cards:          [5]Card,
	hand_type:      PokerHandType,
	hand_type_text: cstring,
	odds:           string,
}

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

init_poker_hand :: proc(cards: []Card) -> PokerHand {
	result: PokerHand
	result.hand_type = score_hand(cards)
	result.hand_type_text = get_poker_hand_type_text(result.hand_type)
	set_poker_hand_odds_text(&result)
	for i in 0 ..< min(len(cards), 5) {
		result.cards[i] = cards[i]
	}
	return result
}

destroy_poker_hand :: proc(poker_hand: ^PokerHand) {
	delete(poker_hand.odds)
}

set_poker_hand_odds_text :: proc(poker_hand: ^PokerHand) {
	odds := poker_odds[poker_hand.hand_type]
	one_in := int(1.0 / odds + 0.5)

	// NOTE: am I stressing too much about this allocation? It is certainly not in a hot path.
	delete(poker_hand.odds)
	poker_hand.odds = fmt.aprintf("1 in {}", format_with_commas(one_in, context.temp_allocator))
}

has_high_card :: proc(cards: []Card) -> bool {
	return len(cards) == 5
}

// A helper to check if there's 2, 3 or 4 of a kind.
@(private = "file")
has_number_of_common_pips :: proc(cards: []Card, number: int) -> bool {
	if len(cards) != 5 { return false }

	pip_map := init_card_pip_map(cards, context.temp_allocator)

	for _, count in pip_map {
		if count == number { return true }
	}

	return false
}

has_pair :: proc(cards: []Card) -> bool {
	return has_number_of_common_pips(cards, 2)
}

has_two_pair :: proc(cards: []Card) -> bool {
	if len(cards) != 5 { return false }

	pip_map := init_card_pip_map(cards, context.temp_allocator)

	doubles := 0
	for _, count in pip_map {
		if count == 2 { doubles += 1 }
		if doubles == 2 { return true }
	}

	return false
}

has_three_of_a_kind :: proc(cards: []Card) -> bool {
	return has_number_of_common_pips(cards, 3)
}

has_straight :: proc(cards: []Card) -> bool {
	if len(cards) != 5 { return false }

	pip_set := make(map[CardPip]int, context.temp_allocator)
	for card in cards {
		map_insert(&pip_set, card.pip, 0)
	}

	if len(pip_set) != 5 { return false }

	pips := make([dynamic]int, context.temp_allocator)
	for pip, _ in pip_set {
		append(&pips, int(pip))
	}
	sort.bubble_sort(pips[:])

	// Check for the wheel (A-2-3-4-5) where Ace acts as low.
	if pips[4] == int(CardPip.Ace) && pips[3] == int(CardPip.Five) { return true }

	for i in 0 ..< len(pips) - 1 {
		if pips[i + 1] - pips[i] != 1 { return false }
	}

	return true
}

has_flush :: proc(cards: []Card) -> bool {
	if len(cards) != 5 { return false }

	suit_map := init_card_suit_map(cards, context.temp_allocator)

	for _, count in suit_map {
		if count == 5 { return true }
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
	if !has_straight_flush(cards) { return false }
	pip_map := init_card_pip_map(cards, context.temp_allocator)
	return pip_map[.Ten] == 1 && pip_map[.Ace] == 1
}

score_hand :: proc(cards: []Card) -> PokerHandType {
	if has_royal_flush(cards) { return .RoyalFlush }
	if has_straight_flush(cards) { return .StraightFlush }
	if has_four_of_a_kind(cards) { return .FourOfAKind }
	if has_full_house(cards) { return .FullHouse }
	if has_flush(cards) { return .Flush }
	if has_straight(cards) { return .Straight }
	if has_three_of_a_kind(cards) { return .ThreeOfAKind }
	if has_two_pair(cards) { return .TwoPair }
	if has_pair(cards) { return .Pair }
	if has_high_card(cards) { return .HighCard }
	return .Nothing
}
