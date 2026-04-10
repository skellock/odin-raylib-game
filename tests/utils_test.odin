#+feature using-stmt
package tests

import main "../src"
import "core:testing"
import rl "vendor:raylib"

@(test)
point_in_rotated_rect_no_rotation :: proc(t: ^testing.T) {
	using main
	rect := rl.Rectangle{10, 10, 100, 50}
	testing.expect(t, point_in_rotated_rect({50, 30}, rect, 0), "center should be inside")
	testing.expect(t, !point_in_rotated_rect({5, 30}, rect, 0), "left of rect should be outside")
	testing.expect(t, !point_in_rotated_rect({50, 5}, rect, 0), "above rect should be outside")
	testing.expect(t, point_in_rotated_rect({10, 10}, rect, 0), "top-left corner should be inside")
	testing.expect(
		t,
		point_in_rotated_rect({110, 60}, rect, 0),
		"bottom-right corner should be inside",
	)
}

@(test)
point_in_rotated_rect_90_degrees :: proc(t: ^testing.T) {
	using main
	// 100x50 rect at (10,10) rotated 90° clockwise around top-left
	// The rect extends from (10,10) leftward and downward
	rect := rl.Rectangle{10, 10, 100, 50}
	// Point that was inside unrotated rect should now be outside
	testing.expect(
		t,
		!point_in_rotated_rect({50, 30}, rect, 90),
		"original center should be outside after 90° rotation",
	)
	// Rotated 90° CW around (10,10): rect extends left (x: -40 to 10) and down (y: 10 to 110)
	testing.expect(t, point_in_rotated_rect({-20, 60}, rect, 90), "should be inside rotated rect")
}

@(test)
point_in_rotated_rect_180_degrees :: proc(t: ^testing.T) {
	using main
	// 100x50 rect at (10,10) rotated 180° — extends left and up from origin
	rect := rl.Rectangle{10, 10, 100, 50}
	testing.expect(
		t,
		!point_in_rotated_rect({50, 30}, rect, 180),
		"original center should be outside after 180° rotation",
	)
	// Point to the left and above origin should be inside
	testing.expect(
		t,
		point_in_rotated_rect({-40, -15}, rect, 180),
		"should be inside 180° rotated rect",
	)
}
