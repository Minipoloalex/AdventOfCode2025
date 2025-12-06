const fs = require('fs');
const input: string = fs.readFileSync(0, 'utf-8').trim();
let lines: string[] = input.split("\n");

const create_op = (ch: string) =>
    (acc: number, nr: number): number => {
        return ch === '*' ? acc * nr : acc + nr;
    };

function solve1(ops: string[], nrs: number[][]): number {
    let ans: number = 0;
    for (let j = 0; j < nrs[0].length; j++) {
        const op = create_op(ops[j]);
        let cur = ops[j] === '*' ? 1 : 0;
        for (let i = 0; i < nrs.length; i++) {
            cur = op(cur, nrs[i][j]);
        }
        ans += cur;
    }
    return ans;
}

function part1() {
    const ops: string[] = lines.pop()!.trim().split(/ +/);
    const nrs: number[][] = lines.map(nrline => nrline.trim().split(/ +/).map(nr => parseInt(nr)));
    const ans = solve1(ops, nrs);
    console.log(ans);
}

function part2() {
    const ops: string[] = lines.pop()!.trim().split(/ +/);
    const sz = lines[0].length;
    let ans = 0;
    let opidx = 0;
    let start = true;
    let cur, op;
    for (let j = 0; j < sz; j++) {
        if (start) {
            start = false;
            op = create_op(ops[opidx]);
            cur = ops[opidx] == '*' ? 1 : 0;
        }
        let empty = true;
        let nr = 0;
        for (let i = 0; i < lines.length; i++) {
            if (lines[i][j] !== " ") {
                empty = false;
                nr *= 10;
                nr += parseInt(lines[i][j]);
            }
        }
        if (empty) {
            opidx++;
            ans += cur!;
            start = true;
        }
        else {
            cur = op!(cur!, nr);
        }
    }
    ans += cur!;
    console.log(ans);
}

// part1
part2();
