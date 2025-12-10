package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func absolute(x int) (y int) {
	if x < 0 {
		y = -x
	} else {
		y = x
	}
	return
}

func readInput() (tile_coordinates [][]int) {
	// Read Input: Coordinates of the Red Tiles
	scanner := bufio.NewScanner(os.Stdin)
	for true {
		scanner.Scan()
		// Verify if we reached the end of the file or the final line
		err := scanner.Err()
		if err != nil {
			break
		}
		line := scanner.Text()
		if len(line) == 0 {
			break
		}

		// Convert the line to coordinates (int, int)
		line_splits := strings.Split(line, ",")
		x, _ := strconv.Atoi(line_splits[0])
		y, _ := strconv.Atoi(line_splits[1])
		// Add the coordinates to the list of tile coordinates
		tile_coordinates = append(tile_coordinates, []int{x, y})
	}

	return
}

func calculateArea(a []int, b []int) (area int) {
	area = (absolute(a[0]-b[0]) + 1) * (absolute(a[1]-b[1]) + 1)
	return
}

func insideRectangle(rec_corner1 []int, rec_corner2 []int, point []int) bool {
	min_x := min(rec_corner1[0], rec_corner2[0])
	min_y := min(rec_corner1[1], rec_corner2[1])
	max_x := max(rec_corner1[0], rec_corner2[0])
	max_y := max(rec_corner1[1], rec_corner2[1])

	x, y := point[0], point[1]

	// Excludes borders (because the line where the points are is green)
	return min_x < x && x < max_x && min_y < y && y < max_y
}

func intersectRectangle(rec_corner1 []int, rec_corner2 []int, point1 []int, point2 []int) bool {
	min_x := min(rec_corner1[0], rec_corner2[0])
	max_x := max(rec_corner1[0], rec_corner2[0])
	min_y := min(rec_corner1[1], rec_corner2[1])
	max_y := max(rec_corner1[1], rec_corner2[1])

	vertical := point1[0] == point2[0]
	if vertical {
		line_x := point1[0]
		min_line_y := min(point1[1], point2[1])
		max_line_y := max(point1[1], point2[1])
		return min_x < line_x && line_x < max_x && min_line_y <= min_y && max_y <= max_line_y
	} else {
		line_y := point1[1]
		min_line_x := min(point1[0], point2[0])
		max_line_x := max(point1[0], point2[0])
		return min_y < line_y && line_y < max_y && min_line_x <= min_x && max_x <= max_line_x
	}
}

func allRectangleOutsidePolygon(rec_corner1 []int, rec_corner2 []int, tile_coordinates [][]int) bool {
	n := len(tile_coordinates)
	rectangle_center_x := (rec_corner1[0] + rec_corner2[0]) / 2 // assumes that the rectangle has at least width 2
	rectangle_center_y := (rec_corner1[1] + rec_corner2[1]) / 2 // assumes that the rectangle has at least height 2

	count := 0
	for i, point1 := range tile_coordinates {
		j := (i + 1) % n
		point2 := tile_coordinates[j]

		vertical := point1[0] == point2[0]
		line_x := point1[0]
		min_y := min(point1[1], point2[1])
		max_y := max(point1[1], point2[1])
		if vertical && line_x <= rectangle_center_x &&
			(min_y < rectangle_center_y && rectangle_center_y < max_y) {
			count += 1
		}
	}

	return count%2 == 0
}

func part1(tile_coordinates [][]int) int {
	max_area := 0
	for i, tile1 := range tile_coordinates {
		for _, tile2 := range tile_coordinates[i+1:] {
			area := calculateArea(tile1, tile2)
			max_area = max(max_area, area)
		}
	}

	return max_area
}

func part2(tile_coordinates [][]int) int {
	max_area := 0
	for i, rec_corner1 := range tile_coordinates {
		for _, rec_corner2 := range tile_coordinates[i+1:] {

			// Check if some point is inside our rectangle
			// If no points are inside our rectangle, since we know
			// that the outside lines are green, then the inside must
			// also be green. If there was (at least) a point inside,
			// it means that a frontier between green and white exists
			// inside (which implicates the existance of white tiles inside)
			white_tiles_detected := false
			for k, point := range tile_coordinates {
				// if there is a point inside the rectangle, then part of
				// the rectangle is green and part is white
				if insideRectangle(rec_corner1, rec_corner2, point) {
					white_tiles_detected = true
					break
				}

				// if there is a line inside the rectangle, then part of
				// the rectangle is green and part is white
				point_segment := tile_coordinates[(k+1)%len(tile_coordinates)]
				if intersectRectangle(rec_corner1, rec_corner2, point, point_segment) {
					white_tiles_detected = true
					break
				}
			}

			// if there is no point nor line, then all the
			// rectangle is white or all the rectangle is green
			if !white_tiles_detected && allRectangleOutsidePolygon(rec_corner1, rec_corner2, tile_coordinates) {
				white_tiles_detected = true
			}

			if !white_tiles_detected {
				area := calculateArea(rec_corner1, rec_corner2)
				max_area = max(max_area, area)
			}
		}
	}

	return max_area
}

func main() {
	tile_coordinates := readInput()
	fmt.Println(part1(tile_coordinates))
	fmt.Println(part2(tile_coordinates))
}
