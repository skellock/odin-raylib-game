package main

import "core:strings"

utils_format_with_commas :: proc(n: int, allocator := context.allocator) -> string {
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
