def solve_part1(lines: list[str], start_index: int) -> int:
    lasers = {start_index}

    n_laser_splits = 0
    for current_line in range(1, len(lines)):
        new_lasers = set()
        for laser in lasers:
            # No need to handle the case where laser value gets out of bounds,
            # because the input doesn't allow it
            if lines[current_line][laser] == "^":
                new_lasers.add(laser - 1)
                new_lasers.add(laser + 1)
                n_laser_splits += 1
            else: # "."
                new_lasers.add(laser)
        lasers = new_lasers

    return n_laser_splits

def solve_part2(lines: list[str], start_index: int) -> int:
    lasers = {start_index: 1}

    for current_line in range(1, len(lines)):
        new_lasers = {}
        for laser in lasers:
            # No need to handle the case where laser value gets out of bounds,
            # because the input doesn't allow it
            if lines[current_line][laser] == "^":
                new_lasers[laser - 1] = new_lasers.get(laser - 1, 0) + lasers[laser]
                new_lasers[laser + 1] = new_lasers.get(laser + 1, 0) + lasers[laser]
            else: # "."
                new_lasers[laser] = new_lasers.get(laser, 0) + lasers[laser]
        lasers = new_lasers

    return sum(lasers.values())

def parse_input() -> list[str]:
    lines: list[str] = []
    while True:
        try:
            line = input().strip()
        except EOFError:
            break
        if line == "":
            break
        lines.append(line)
    return lines

if __name__ == "__main__":
    # Start by parsing the input
    lines = parse_input()
    
    # Then, find the position of the S (always on the first line)
    start_index = lines[0].find("S")

    # Finally, trace the lasers within the the manifold

    # Solve for Part 1
    part1_result = solve_part1(lines, start_index)

    # Solve for Part 2
    part2_result = solve_part2(lines, start_index)

    # Present results
    print(part1_result)
    print(part2_result)
