package main

import "core:fmt"
import rl "vendor:raylib"

Tooltip :: struct {
	text:  string,
	x:     i32,
	y:     i32,
	alpha: f32,
	delay: f32,
}

update_tooltip :: proc(game: ^Game, input: Input) {
	update_hovered_card(game, input)
	update_tooltip_position(game, input)
	update_tooltip_text(game)
	update_tooltip_alpha(game, input)
}

draw_tooltip :: proc(game: Game) {
	tooltip := game.tooltip
	if tooltip.alpha <= 0 do return

	FONT_SIZE :: i32(8)
	PADDING :: i32(4)
	text := fmt.ctprintf("%s", tooltip.text)

	// calculate text size
	text_w := rl.MeasureText(text, FONT_SIZE)

	// the background
	bg_rect := rl.Rectangle {
		f32(tooltip.x - PADDING),
		f32(tooltip.y - PADDING),
		f32(text_w + PADDING * 2),
		f32(FONT_SIZE + PADDING * 2),
	}
	rl.DrawRectangleRounded(bg_rect, 0.4, 4, rl.ColorAlpha(rl.WHITE, tooltip.alpha))

	// the text
	rl.DrawText(text, tooltip.x, tooltip.y, FONT_SIZE, rl.ColorAlpha(rl.BLACK, tooltip.alpha))
}

@(private = "file")
update_tooltip_alpha :: proc(game: ^Game, input: Input) {
	if game.tooltip.alpha <= 0 do return
	if game.hovered_card >= 0 do return

	// move the tooltip along with mouse as it fades
	FADE_DELAY :: f32(0.25)
	FADE_SPEED :: f32(4.0)
	game.tooltip.delay += input.time.dt
	if game.tooltip.delay >= FADE_DELAY {
		game.tooltip.alpha -= FADE_SPEED * input.time.dt
	}
	if game.tooltip.alpha < 0 do game.tooltip.alpha = 0
}

@(private = "file")
update_hovered_card :: proc(game: ^Game, input: Input) {
	mouse := rl.Vector2{f32(input.mouse.world_x), f32(input.mouse.world_y)}
	game.hovered_card = -1

	for i := len(game.hand) - 1; i >= 0; i -= 1 {
		card := game.hand[i]
		tex := game.card_images.cards[card]
		card_w := f32(tex.width) * CARD_SCALE
		card_h := f32(tex.height) * CARD_SCALE
		card_pos := game.card_positions[i]
		rect := rl.Rectangle{card_pos.x, card_pos.y, card_w, card_h}
		if rl.CheckCollisionPointRec(mouse, rect) {
			game.hovered_card = i
			break
		}
	}
}

@(private = "file")
update_tooltip_text :: proc(game: ^Game) {
	// nothing to do if we're not over a card
	if game.hovered_card < 0 do return

	card := game.hand[game.hovered_card]
	set_tooltip_text(&game.tooltip, fmt.tprintf("%v of %vs", card.pip, card.suit))
}

@(private = "file")
update_tooltip_position :: proc(game: ^Game, input: Input) {
	OFFSET_X :: 10
	OFFSET_Y :: 10
	game.tooltip.x = input.mouse.world_x + OFFSET_X
	game.tooltip.y = input.mouse.world_y + OFFSET_Y
}

set_tooltip_text :: proc(tooltip: ^Tooltip, text: string) {
	tooltip.alpha = 1.0
	tooltip.delay = 0
	tooltip.text = text
}
