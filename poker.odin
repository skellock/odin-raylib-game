package main

import "core:fmt"
import "core:sort"

PokerHand :: enum {
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
	if len(cards) != 5 {return false}

	pip_map := init_card_pip_map(cards, context.temp_allocator)

	for _, count in pip_map {
		if count == number {return true}
	}

	return false
}

has_pair :: proc(cards: []Card) -> bool {
	return has_number_of_common_pips(cards, 2)
}

has_two_pair :: proc(cards: []Card) -> bool {
	if len(cards) != 5 {return false}

	pip_map := init_card_pip_map(cards, context.temp_allocator)

	doubles := 0
	for _, count in pip_map {
		if count == 2 {doubles += 1}
		if doubles == 2 {return true}
	}

	return false
}

has_three_of_a_kind :: proc(cards: []Card) -> bool {
	return has_number_of_common_pips(cards, 3)
}

has_straight :: proc(cards: []Card) -> bool {
	if len(cards) != 5 {return false}

	pip_set := make(map[CardPip]int, context.temp_allocator)
	for card in cards {
		map_insert(&pip_set, card.pip, 0)
	}

	pips := make([dynamic]int, context.temp_allocator)
	for pip, _ in pip_set {
		append(&pips, int(pip))
	}
	sort.bubble_sort(pips[:])

	for i in 0 ..< len(pips) - 1 {
		if pips[i + 1] - pips[i] != 1 {return false}
	}

	return true
}

has_flush :: proc(cards: []Card) -> bool {
	if len(cards) != 5 {return false}

	suit_map := init_card_suit_map(cards, context.temp_allocator)

	for _, count in suit_map {
		if count == 5 {return true}
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
	if !has_straight_flush(cards) {return false}
	pip_map := init_card_pip_map(cards, context.temp_allocator)
	return pip_map[.Ten] == 1 && pip_map[.Ace] == 1
}

// --- Tests ------------------------------------------------------------------

import "core:testing"

expect_poker_hand :: proc(
	t: ^testing.T,
	hand_string: string,
	hand_fn: proc(card: []Card) -> bool,
	value: bool = true,
) {
	context.allocator = context.temp_allocator
	card_map := init_card_map()
	hand := init_cards(hand_string, card_map)
	testing.expect(
		t,
		hand_fn(hand) == value,
		fmt.tprintf("expected (%s) to be %v", hand_string, value),
	)
}

@(test)
has_high_card_test :: proc(t: ^testing.T) {
	expect_poker_hand(t, "", has_high_card, false)
	expect_poker_hand(t, "2h 3h 4h 5h 6c", has_high_card)
}

@(test)
has_pair_test :: proc(t: ^testing.T) {
	expect_poker_hand(t, "", has_pair, false)
	expect_poker_hand(t, "2h 3h 4h 5h 5c", has_pair)
}

@(test)
has_two_pair_test :: proc(t: ^testing.T) {
	expect_poker_hand(t, "", has_two_pair, false)
	expect_poker_hand(t, "2h 2c 3h 3c 5h", has_two_pair)
}

@(test)
is_three_of_a_kind_test :: proc(t: ^testing.T) {
	expect_poker_hand(t, "", has_three_of_a_kind, false)
	expect_poker_hand(t, "2h 2c 3h 3c 4h", has_three_of_a_kind, false)
	expect_poker_hand(t, "2h 2c 2d 3c 4h", has_three_of_a_kind)
}

@(test)
has_straight_test :: proc(t: ^testing.T) {
	expect_poker_hand(t, "", has_straight, false)
	expect_poker_hand(t, "2c 3c 4h 5h 7d", has_straight, false)
	expect_poker_hand(t, "ac 2c 3c 4h 5h", has_straight, false)
	expect_poker_hand(t, "9h jh qc kd as", has_straight, false)
	expect_poker_hand(t, "2c 3c 4h 5h 6h", has_straight)
	expect_poker_hand(t, "th jh qc kd as", has_straight)
}

@(test)
has_flush_test :: proc(t: ^testing.T) {
	expect_poker_hand(t, "", has_flush, false)
	expect_poker_hand(t, "2h 3h 4h 5h 6c", has_flush, false)
	expect_poker_hand(t, "2h 3h 4h 5h 6h", has_flush)
}

@(test)
has_full_house_test :: proc(t: ^testing.T) {
	expect_poker_hand(t, "", has_full_house, false)
	expect_poker_hand(t, "3c 3s 3d 2h ac", has_full_house, false)
	expect_poker_hand(t, "3c 4s 5d 2h 2c", has_full_house, false)
	expect_poker_hand(t, "3c 3s 3d 2h 2c", has_full_house)
}

@(test)
has_four_of_a_kind_test :: proc(t: ^testing.T) {
	expect_poker_hand(t, "", has_four_of_a_kind, false)
	expect_poker_hand(t, "2c 2s 2d 3h 3c", has_four_of_a_kind, false)
	expect_poker_hand(t, "2c 2s 2d 2h 3c", has_four_of_a_kind)
}

@(test)
has_straight_flush_test :: proc(t: ^testing.T) {
	expect_poker_hand(t, "", has_straight_flush, false)
	expect_poker_hand(t, "2c 3s 4c 5c 6c", has_straight_flush, false)
	expect_poker_hand(t, "2c 3c 4c 5c 7c", has_straight_flush, false)
	expect_poker_hand(t, "2c 3c 4c 5c 6c", has_straight_flush)
	expect_poker_hand(t, "tc jc qc kc ac", has_straight_flush)
}

@(test)
has_royal_flush_test :: proc(t: ^testing.T) {
	expect_poker_hand(t, "", has_royal_flush, false)
	expect_poker_hand(t, "9c jc qc kc ac", has_royal_flush, false)
	expect_poker_hand(t, "tc js qc kc ac", has_royal_flush, false)
	expect_poker_hand(t, "2c 3c 4c 5c 6c", has_royal_flush, false)
	expect_poker_hand(t, "tc jc qc kc ac", has_royal_flush)
}
