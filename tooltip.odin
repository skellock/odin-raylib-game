package main

import "core:fmt"
import rl "vendor:raylib"

Tooltip :: struct {
	text_buf: [256]byte,
	text_len: int,
	pos:      rl.Vector2,
	alpha:    f32,
	delay:    f32,
}

update_tooltip :: proc(game: ^Game) {
	update_hovered_card(game)
	update_tooltip_position(game)
	update_tooltip_text(game)
	update_tooltip_alpha(game)
}

draw_tooltip :: proc(game: ^Game) {
	tooltip := game.tooltip
	if tooltip.alpha <= 0 do return

	FONT_SIZE :: f32(16)
	SPACING :: f32(1)
	PADDING :: f32(2)

	font := assets.fonts.body

	// make a cstring for the raylib text
	text := fmt.ctprintf("%s", tooltip.text_buf[:tooltip.text_len])

	// calculate text size
	text_size := rl.MeasureTextEx(font, text, FONT_SIZE, SPACING)

	// the background
	bg_rect := rl.Rectangle {
		tooltip.pos.x - PADDING,
		tooltip.pos.y - PADDING,
		text_size.x + PADDING * 2,
		text_size.y + PADDING * 2,
	}
	rl.DrawRectangleRounded(bg_rect, 0.4, 4, rl.ColorAlpha(rl.WHITE, tooltip.alpha))

	// the text
	rl.DrawTextEx(
		font,
		text,
		tooltip.pos,
		FONT_SIZE,
		SPACING,
		rl.ColorAlpha(rl.BLACK, tooltip.alpha),
	)
}

@(private = "file")
update_tooltip_alpha :: proc(game: ^Game) {
	if game.tooltip.alpha <= 0 do return
	if game.hovered_card >= 0 do return

	// move the tooltip along with mouse as it fades
	FADE_DELAY :: f32(0.25)
	FADE_SPEED :: f32(4.0)
	game.tooltip.delay += game.time.dt
	if game.tooltip.delay >= FADE_DELAY {
		game.tooltip.alpha -= FADE_SPEED * game.time.dt
	}
	if game.tooltip.alpha < 0 do game.tooltip.alpha = 0
}

@(private = "file")
update_hovered_card :: proc(game: ^Game) {
	mouse := game.mouse.world_pos
	game.hovered_card = -1

	for i := len(game.card_views) - 1; i >= 0; i -= 1 {
		cv := game.card_views[i]
		card_w := f32(cv.texture.width) * CARD_SCALE
		card_h := f32(cv.texture.height) * CARD_SCALE
		rect := rl.Rectangle{cv.pos.x, cv.pos.y, card_w, card_h}
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

	card := game.card_views[game.hovered_card].card
	set_tooltip_text(&game.tooltip, fmt.tprintf("%v of %vs", card.pip, card.suit))
}

@(private = "file")
update_tooltip_position :: proc(game: ^Game) {
	OFFSET :: rl.Vector2{10, 10}
	game.tooltip.pos = game.mouse.world_pos + OFFSET
}

@(private = "file")
set_tooltip_text :: proc(tooltip: ^Tooltip, text: string) {
	tooltip.alpha = 1.0
	tooltip.delay = 0
	tooltip.text_len = min(len(text), len(tooltip.text_buf))
	copy(tooltip.text_buf[:tooltip.text_len], text[:tooltip.text_len])
}
