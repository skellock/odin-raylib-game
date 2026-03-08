package main

import "core:fmt"
import rl "vendor:raylib"

Tooltip :: struct {
	text:  [64]u8,
	len:   int,
	x, y:  i32,
	alpha: f32,
	delay: f32,
}

update_tooltip :: proc(game: ^Game, input: ^Input) {
	mouse := rl.Vector2{f32(input.mouse.world_x), f32(input.mouse.world_y)}
	game.hovered_card = -1

	OFFSET_X :: 10
	OFFSET_Y :: 10

	for i := len(game.hand) - 1; i >= 0; i -= 1 {
		card := game.hand[i]
		tex := game.card_images.cards[card]
		card_w := f32(tex.width) * CARD_SCALE
		card_h := f32(tex.height) * CARD_SCALE
		card_pos := game.card_positions[i]
		rect := rl.Rectangle{card_pos.x, card_pos.y, card_w, card_h}
		if rl.CheckCollisionPointRec(mouse, rect) {
			text := fmt.ctprintf("%v of %vs", card.pip, card.suit)
			set_tooltip(
				&game.tooltip,
				text,
				input.mouse.world_x + OFFSET_X,
				input.mouse.world_y + OFFSET_Y,
			)
			game.hovered_card = i
			break
		}
	}

	if game.hovered_card < 0 && game.tooltip.alpha > 0 {
		// move the tooltip along with mouse as it fades
		game.tooltip.x = input.mouse.world_x + OFFSET_X
		game.tooltip.y = input.mouse.world_y + OFFSET_Y
		FADE_DELAY :: f32(0.25)
		FADE_SPEED :: f32(4.0)
		game.tooltip.delay += input.time.dt
		if game.tooltip.delay >= FADE_DELAY {
			game.tooltip.alpha -= FADE_SPEED * input.time.dt
		}
		if game.tooltip.alpha < 0 do game.tooltip.alpha = 0
	}
}

set_tooltip :: proc(tooltip: ^Tooltip, text: cstring, x: i32, y: i32) {
	tooltip.x = x
	tooltip.y = y
	tooltip.alpha = 1.0
	tooltip.delay = 0
	bytes := transmute([^]u8)text
	n := 0
	for n < len(tooltip.text) - 1 && bytes[n] != 0 {
		tooltip.text[n] = bytes[n]
		n += 1
	}
	tooltip.text[n] = 0
	tooltip.len = n
}

draw_tooltip :: proc(tooltip: ^Tooltip) {
	if tooltip.alpha <= 0 do return

	FONT_SIZE :: i32(8)
	PADDING :: i32(4)
	text := cstring(raw_data(tooltip.text[:]))
	text_w := rl.MeasureText(text, FONT_SIZE)
	bg_rect := rl.Rectangle {
		f32(tooltip.x - PADDING),
		f32(tooltip.y - PADDING),
		f32(text_w + PADDING * 2),
		f32(FONT_SIZE + PADDING * 2),
	}
	rl.DrawRectangleRounded(bg_rect, 0.4, 4, rl.ColorAlpha(rl.WHITE, tooltip.alpha))
	rl.DrawText(text, tooltip.x, tooltip.y, FONT_SIZE, rl.ColorAlpha(rl.BLACK, tooltip.alpha))
}
