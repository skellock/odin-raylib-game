#+feature using-stmt
package tests

import main "../src"
import "core:fmt"
import "core:testing"

expect_poker_hand :: proc(
	t: ^testing.T,
	hand_string: string,
	hand_fn: proc(card: []main.Card) -> bool,
	value: bool = true,
) {
	using main, testing

	context.allocator = context.temp_allocator
	card_map := card_map_init()
	hand := card_init_all(hand_string, card_map)
	expect(t, hand_fn(hand[:]) == value, fmt.tprintf("expected (%s) to be %v", hand_string, value))
}

@(test)
has_high_card_test :: proc(t: ^testing.T) {
	using main, testing

	expect_poker_hand(t, "", has_high_card, false)
	expect_poker_hand(t, "2h 3h 4h 5h 6c", has_high_card)
}

@(test)
has_pair_test :: proc(t: ^testing.T) {
	using main, testing

	expect_poker_hand(t, "", has_pair, false)
	expect_poker_hand(t, "2h 3h 4h 5h 5c", has_pair)
}

@(test)
has_two_pair_test :: proc(t: ^testing.T) {
	using main, testing

	expect_poker_hand(t, "", has_two_pair, false)
	expect_poker_hand(t, "2h 2c 3h 3c 5h", has_two_pair)
}

@(test)
is_three_of_a_kind_test :: proc(t: ^testing.T) {
	using main, testing

	expect_poker_hand(t, "", has_three_of_a_kind, false)
	expect_poker_hand(t, "2h 2c 3h 3c 4h", has_three_of_a_kind, false)
	expect_poker_hand(t, "2h 2c 2d 3c 4h", has_three_of_a_kind)
}

@(test)
has_straight_test :: proc(t: ^testing.T) {
	using main, testing

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
	using main, testing

	expect_poker_hand(t, "", has_flush, false)
	expect_poker_hand(t, "2h 3h 4h 5h 6c", has_flush, false)
	expect_poker_hand(t, "2h 3h 4h 5h 6h", has_flush)
}

@(test)
has_full_house_test :: proc(t: ^testing.T) {
	using main, testing

	expect_poker_hand(t, "", has_full_house, false)
	expect_poker_hand(t, "3c 3s 3d 2h ac", has_full_house, false)
	expect_poker_hand(t, "3c 4s 5d 2h 2c", has_full_house, false)
	expect_poker_hand(t, "3c 3s 3d 2h 2c", has_full_house)
}

@(test)
has_four_of_a_kind_test :: proc(t: ^testing.T) {
	using main, testing

	expect_poker_hand(t, "", has_four_of_a_kind, false)
	expect_poker_hand(t, "2c 2s 2d 3h 3c", has_four_of_a_kind, false)
	expect_poker_hand(t, "2c 2s 2d 2h 3c", has_four_of_a_kind)
}

@(test)
has_straight_flush_test :: proc(t: ^testing.T) {
	using main, testing

	expect_poker_hand(t, "", has_straight_flush, false)
	expect_poker_hand(t, "2c 3s 4c 5c 6c", has_straight_flush, false)
	expect_poker_hand(t, "2c 3c 4c 5c 7c", has_straight_flush, false)
	expect_poker_hand(t, "2c 3c 4c 5c 6c", has_straight_flush)
	expect_poker_hand(t, "tc jc qc kc ac", has_straight_flush)
}

@(test)
has_royal_flush_test :: proc(t: ^testing.T) {
	using main, testing

	expect_poker_hand(t, "", has_royal_flush, false)
	expect_poker_hand(t, "9c jc qc kc ac", has_royal_flush, false)
	expect_poker_hand(t, "tc js qc kc ac", has_royal_flush, false)
	expect_poker_hand(t, "2c 3c 4c 5c 6c", has_royal_flush, false)
	expect_poker_hand(t, "tc jc qc kc ac", has_royal_flush)
}

@(test)
init_poker_hand_test :: proc(t: ^testing.T) {
	using main, testing

	context.allocator = context.temp_allocator
	card_map := card_map_init()

	cards := card_init_all("tc jc qc kc ac", card_map)
	hand := poker_hand_init(cards[:])
	defer poker_hand_destroy(&hand)
	expect_value(t, hand.hand_type, PokerHandType.RoyalFlush)
	expect_value(t, hand.hand_type_text, "Royal Flush")
	expect_value(t, hand.cards[0], Card{pip = .Ten, suit = .Club})
	expect_value(t, hand.cards[4], Card{pip = .Ace, suit = .Club})

	cards2 := card_init_all("2h 3h 4h 5h 5c", card_map)
	hand2 := poker_hand_init(cards2[:])
	defer poker_hand_destroy(&hand2)
	expect_value(t, hand2.hand_type, PokerHandType.Pair)
	expect_value(t, hand2.hand_type_text, "Pair")
}

expect_card_score_hand :: proc(t: ^testing.T, hand_string: string, hand_type: main.PokerHandType) {
	using main, testing

	context.allocator = context.temp_allocator
	card_map := card_map_init()
	cards := card_init_all(hand_string, card_map)
	score := card_score_hand(cards[:])
	expect(t, score == hand_type, fmt.tprintf("expected (%s) to be %v but was %v", hand_string, hand_type, score))
}

@(test)
score_hand_test :: proc(t: ^testing.T) {
	using main, testing

	expect_card_score_hand(t, "tc jc qc kc ac", .RoyalFlush)
	expect_card_score_hand(t, "9c tc jc qc kc", .StraightFlush)
	expect_card_score_hand(t, "2c 2s 2d 2h 3c", .FourOfAKind)
	expect_card_score_hand(t, "3c 3s 3d 2h 2c", .FullHouse)
	expect_card_score_hand(t, "2h 3h 4h 5h 7h", .Flush)
	expect_card_score_hand(t, "2c 3c 4h 5h 6h", .Straight)
	expect_card_score_hand(t, "2h 2c 2d 3c 4h", .ThreeOfAKind)
	expect_card_score_hand(t, "2h 2c 3h 3c 5h", .TwoPair)
	expect_card_score_hand(t, "2h 3h 4h 5h 5c", .Pair)
	expect_card_score_hand(t, "2h 3h 4h 5h tc", .HighCard)
	expect_card_score_hand(t, "2h", .Nothing)
	expect_card_score_hand(t, "2h 3h", .Nothing)
	expect_card_score_hand(t, "2h 3h 4h", .Nothing)
	expect_card_score_hand(t, "2h 3h 4h 5h", .Nothing)
}
