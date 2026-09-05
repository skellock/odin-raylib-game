#+feature using-stmt
package tests

import main "../src"
import "core:testing"
import rl "vendor:raylib"

@(test)
text_cache_owns_text_and_terminates_shorter_values_test :: proc(t: ^testing.T) {
	using main, testing

	cache: TextCache
	source := [5]byte{'h', 'e', 'l', 'l', 'o'}
	expect(t, text_cache_set(&cache, string(source[:])))
	source[0] = 'j'
	expect_value(t, string(text_cache_cstring(&cache)), "hello")
	cache.measured = true
	expect(t, !text_cache_set(&cache, "hello"))
	expect(t, cache.measured)
	expect(t, text_cache_set(&cache, "hi"))
	expect(t, !cache.measured)
	expect_value(t, string(text_cache_cstring(&cache)), "hi")
	text_cache_set(&cache, "")
	expect_value(t, string(text_cache_cstring(&cache)), "")
}

@(test)
text_cache_reserves_terminator_test :: proc(t: ^testing.T) {
	using main, testing

	cache: TextCache
	text: [300]byte
	for &ch in text { ch = 'x' }
	text_cache_set(&cache, string(text[:]))
	expect_value(t, cache.length, 255)
	expect_value(t, cache.buf[255], u8(0))
}

@(test)
text_cache_invalidates_measurement_for_style_changes_test :: proc(t: ^testing.T) {
	using main, testing

	font := rl.Font {
		baseSize = 24,
	}
	cache := TextCache {
		measured  = true,
		font      = font,
		font_size = 16,
		spacing   = 2,
	}
	expect(t, !text_cache_needs_measure(&cache, font, 16, 2))
	expect(t, text_cache_needs_measure(&cache, font, 32, 2))
	expect(t, text_cache_needs_measure(&cache, font, 16, 4))
	font.texture.id = 1
	expect(t, text_cache_needs_measure(&cache, font, 16, 2))
}

@(test)
clock_text_cache_tracks_displayed_tenths_test :: proc(t: ^testing.T) {
	using main, testing

	clock := clock_init()
	clock_cache_text(&clock)
	expect_value(t, string(text_cache_cstring(&clock.text)), "0.0")
	clock.text.measured = true
	clock.elapsed = 0.09
	clock_cache_text(&clock)
	expect(t, clock.text.measured)
	clock.elapsed = 0.1
	clock_cache_text(&clock)
	expect_value(t, string(text_cache_cstring(&clock.text)), "0.1")
	expect(t, !clock.text.measured)
	clock.elapsed = 60.0
	clock_cache_text(&clock)
	expect_value(t, string(text_cache_cstring(&clock.text)), "1:00.0")
	clock.elapsed = 3600.0
	clock_cache_text(&clock)
	expect_value(t, string(text_cache_cstring(&clock.text)), "1:00:00.0")
}

@(test)
debug_text_cache_tracks_fps_test :: proc(t: ^testing.T) {
	using main, testing

	debug: Debug
	debug_cache_text(&debug, 144)
	expect_value(t, string(text_cache_cstring(&debug.text)), "FPS: 144")
	debug.text.measured = true
	debug_cache_text(&debug, 144)
	expect(t, debug.text.measured)
	debug_cache_text(&debug, 9)
	expect(t, !debug.text.measured)
	expect_value(t, string(text_cache_cstring(&debug.text)), "FPS: 9")
}

@(test)
tooltip_text_cache_preserves_hover_and_refreshes_card_test :: proc(t: ^testing.T) {
	using main, testing

	tooltip: Tooltip
	card := Card{.Ace, .Spade}
	tooltip_cache_card(&tooltip, card)
	expect_value(t, string(text_cache_cstring(&tooltip.text)), "Ace of Spades")
	tooltip.text.measured = true
	tooltip.alpha = 0.2
	tooltip.delay = 0.5
	tooltip_cache_card(&tooltip, card)
	expect(t, tooltip.text.measured)
	expect_value(t, tooltip.alpha, f32(1))
	expect_value(t, tooltip.delay, f32(0))
	// A new deal can change the card without changing the hovered slot.
	tooltip_cache_card(&tooltip, Card{.Two, .Club})
	expect(t, !tooltip.text.measured)
	expect_value(t, string(text_cache_cstring(&tooltip.text)), "Two of Clubs")
}
