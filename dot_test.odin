package main

import "core:testing"

@(test)
cycle_dot_color_test :: proc(t: ^testing.T) {
	dot := init_dot()
	defer destroy_dot(&dot)

	testing.expect_value(t, dot.color, DotColor.Yellow)
	cycle_dot_color(&dot)
	testing.expect_value(t, dot.color, DotColor.Red)
	cycle_dot_color(&dot)
	cycle_dot_color(&dot)
	testing.expect_value(t, dot.color, DotColor.Yellow)
}
