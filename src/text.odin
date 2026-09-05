package main

import rl "vendor:raylib"

// Owns short UI text, including its C terminator, without heap allocations.
TextCache :: struct {
	buf:       [256]byte,
	length:    int,
	measured:  bool,
	size:      rl.Vector2,
	font:      rl.Font,
	font_size: f32,
	spacing:   f32,
}

text_cache_set :: proc(cache: ^TextCache, text: string) -> bool {
	visible_text := text[:min(len(text), len(cache.buf) - 1)]
	if string(cache.buf[:cache.length]) == visible_text { return false }
	cache.length = copy(cache.buf[:], visible_text)
	cache.buf[cache.length] = 0
	cache.measured = false
	return true
}

text_cache_cstring :: proc(cache: ^TextCache) -> cstring {
	return cstring(&cache.buf[0])
}

text_cache_needs_measure :: proc(cache: ^TextCache, font: rl.Font, font_size, spacing: f32) -> bool {
	return !cache.measured || cache.font != font || cache.font_size != font_size || cache.spacing != spacing
}

text_cache_measure :: proc(cache: ^TextCache, font: rl.Font, font_size, spacing: f32) -> rl.Vector2 {
	if text_cache_needs_measure(cache, font, font_size, spacing) {
		cache.size = rl.MeasureTextEx(font, text_cache_cstring(cache), font_size, spacing)
		cache.font = font
		cache.font_size = font_size
		cache.spacing = spacing
		cache.measured = true
	}
	return cache.size
}
