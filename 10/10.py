from ortools.linear_solver import pywraplp
import sys

def solve(voltages, buttons_raw):
    buttons = [
        [
            1 if i in activated else 0
            for i in range(0, len(voltages))
        ] for activated in buttons_raw
    ]
    return ortools_solver(buttons, voltages)

def ortools_solver(buttons, voltages):
    solver = pywraplp.Solver.CreateSolver("SAT")
    inf = solver.infinity()

    # Variables
    k = [
        solver.IntVar(0, inf, f"k_{b}")
        for b in range(len(buttons))
    ]

    # Constraints
    for i, v in enumerate(voltages):
        solver.Add(
            sum([k[b] for b in range(len(buttons)) if buttons[b][i]]) == v
        )

    # Objective Function
    solver.Minimize(sum(k))

    # Solve
    status = solver.Solve()
    if status == pywraplp.Solver.OPTIMAL:
        return int(solver.Objective().Value())
    return -1

def main():
    ans = 0
    while True:
        line = sys.stdin.readline().rstrip()
        if line == "":
            break
        line = line.split(" ")
        buttons = line[1:-1]
        buttons = [list(map(int,button[1:-1].split(","))) for button in buttons]
        voltages = line[-1][1:-1]
        voltages = list(map(int, voltages.split(",")))
        ans += solve(voltages, buttons)
    print(ans)

if __name__ == "__main__":
    main()
