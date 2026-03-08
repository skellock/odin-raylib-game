package main

import "core:fmt"
import rl "vendor:raylib"

draw :: proc(game: ^Game, input: ^Input) {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.BeginMode2D(game.camera)
	defer rl.EndMode2D()

	draw_background(input)
	draw_title()
	draw_cards(game, input)
	draw_poker_hand(game, input)
	draw_dot(&game.dot, input)
	draw_debug(input)
}

@(private = "file")
draw_background :: proc(input: ^Input) {
	rl.ClearBackground(rl.WHITE)

	x := input.viewport.width / 2
	rl.DrawRectangle(0, 0, x, input.viewport.height, rl.BLUE)
	rl.DrawRectangle(x, 0, x, input.viewport.height, rl.SKYBLUE)
	rl.DrawRectangle(x - 1, 0, 2, input.viewport.height, rl.ColorAlpha(rl.WHITE, 0.5))
}

@(private = "file")
draw_title :: proc() {
	rl.DrawText("This is a test using Odin and Raylib!", 10, 10, 8, rl.WHITE)
}

@(private = "file")
draw_cards :: proc(game: ^Game, input: ^Input) {
	SHADOW_OFFSET :: rl.Vector2{1, 1}
	SCALE :: f32(1.0 / 3.0)
	pos := rl.Vector2{200, 200}

	positions: [5]rl.Vector2

	for card, idx in game.hand {
		tex := game.card_images.cards[card]
		rl.DrawTextureEx(tex, pos + SHADOW_OFFSET, 0, SCALE, rl.ColorAlpha(rl.BLACK, 0.1))
		rl.DrawTextureEx(tex, pos, 0, SCALE, rl.WHITE)
		positions[idx] = pos
		pos += {25, 0}
	}

	draw_card_tooltip(game, input, positions, SCALE)
}

@(private = "file")
draw_card_tooltip :: proc(game: ^Game, input: ^Input, positions: [5]rl.Vector2, scale: f32) {
	mouse := rl.Vector2{f32(input.mouse.world_x), f32(input.mouse.world_y)}
	for i := len(game.hand) - 1; i >= 0; i -= 1 {
		card := game.hand[i]
		tex := game.card_images.cards[card]
		card_w := f32(tex.width) * scale
		card_h := f32(tex.height) * scale
		card_pos := positions[i]
		rect := rl.Rectangle{card_pos.x, card_pos.y, card_w, card_h}
		if rl.CheckCollisionPointRec(mouse, rect) {
			text := fmt.ctprintf("%v of %vs", card.pip, card.suit)
			draw_tooltip(text, input.mouse.world_x + 10, input.mouse.world_y + 10)
			break
		}
	}
}

@(private = "file")
draw_tooltip :: proc(text: cstring, x: i32, y: i32) {
	FONT_SIZE :: i32(8)
	PADDING :: i32(4)
	text_w := rl.MeasureText(text, FONT_SIZE)
	bg_rect := rl.Rectangle {
		f32(x - PADDING),
		f32(y - PADDING),
		f32(text_w + PADDING * 2),
		f32(FONT_SIZE + PADDING * 2),
	}
	rl.DrawRectangleRounded(bg_rect, 0.4, 4, rl.WHITE)
	rl.DrawText(text, x, y, FONT_SIZE, rl.BLACK)
}

@(private = "file")
draw_poker_hand :: proc(game: ^Game, input: ^Input) {
	text: cstring
	switch game.poker_hand {
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

	rl.DrawText(text, 200, 300, 20, rl.WHITE)
}
