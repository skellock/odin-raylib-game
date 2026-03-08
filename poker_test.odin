package main

import "core:fmt"
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
		hand_fn(hand[:]) == value,
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
	expect_poker_hand(t, "9h jh qc kd as", has_straight, false)
	expect_poker_hand(t, "2h 2c 2d 3c 4h", has_straight, false)
	expect_poker_hand(t, "ac 2c 3c 4h 5h", has_straight)
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

// A helper function for testing if a hand is a certain type of Poker Hand.
expect_poker_hand_score :: proc(t: ^testing.T, hand_string: string, hand: PokerHand) {
	context.allocator = context.temp_allocator
	card_map := init_card_map()
	cards := init_cards(hand_string, card_map)
	score := score_hand(cards[:])
	testing.expect(
		t,
		score == hand,
		fmt.tprintf("expected (%s) to be %v but was %v", hand_string, hand, score),
	)
}

// Tests all the things.
@(test)
score_hand_test :: proc(t: ^testing.T) {
	expect_poker_hand_score(t, "tc jc qc kc ac", .RoyalFlush)
	expect_poker_hand_score(t, "9c tc jc qc kc", .StraightFlush)
	expect_poker_hand_score(t, "2c 2s 2d 2h 3c", .FourOfAKind)
	expect_poker_hand_score(t, "3c 3s 3d 2h 2c", .FullHouse)
	expect_poker_hand_score(t, "2h 3h 4h 5h 7h", .Flush)
	expect_poker_hand_score(t, "2c 3c 4h 5h 6h", .Straight)
	expect_poker_hand_score(t, "2h 2c 2d 3c 4h", .ThreeOfAKind)
	expect_poker_hand_score(t, "2h 2c 3h 3c 5h", .TwoPair)
	expect_poker_hand_score(t, "2h 3h 4h 5h 5c", .Pair)
	expect_poker_hand_score(t, "2h 3h 4h 5h tc", .HighCard)
	expect_poker_hand_score(t, "2h", .Nothing)
	expect_poker_hand_score(t, "2h 3h", .Nothing)
	expect_poker_hand_score(t, "2h 3h 4h", .Nothing)
	expect_poker_hand_score(t, "2h 3h 4h 5h", .Nothing)
}
