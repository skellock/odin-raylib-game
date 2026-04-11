package main

import "core:math"
import "core:strings"
import rl "vendor:raylib"

point_in_rotated_rect :: proc(point: rl.Vector2, rect: rl.Rectangle, angle_deg: f32) -> bool {
	// Raylib rotates around the top-left corner
	origin := rl.Vector2{rect.x, rect.y}
	angle_rad := angle_deg * math.RAD_PER_DEG

	// Translate point relative to the rectangle's origin
	dx := point.x - origin.x
	dy := point.y - origin.y

	// Rotate point by the inverse angle to align with the axis-aligned rect
	cos_a := math.cos(-angle_rad)
	sin_a := math.sin(-angle_rad)
	local_x := dx * cos_a - dy * sin_a
	local_y := dx * sin_a + dy * cos_a

	return local_x >= 0 && local_x <= rect.width && local_y >= 0 && local_y <= rect.height
}

format_with_commas :: proc(n: int, allocator := context.allocator) -> string {
	buf: [32]u8
	pos := len(buf)
	v := n < 0 ? -n : n
	digits := 0

	for {
		pos -= 1
		buf[pos] = u8(v % 10) + '0'
		v /= 10
		digits += 1
		if v == 0 { break }
		if digits % 3 == 0 {
			pos -= 1
			buf[pos] = ','
		}
	}

	if n < 0 {
		pos -= 1
		buf[pos] = '-'
	}

	return strings.clone_from_bytes(buf[pos:], allocator)
}
