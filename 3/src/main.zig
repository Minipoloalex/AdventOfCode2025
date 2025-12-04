const std = @import("std");
const aoc2025 = @import("aoc2025");

const stdIn = std.Io.File.stdin();
const stdOut = std.Io.File.stdout();

fn part1() !void {
    // Read from `stdin` all the lines
    var reader_buffer: [1024]u8 = undefined;
    const io = std.testing.io;
    var reader = stdIn.reader(io, &reader_buffer);

    var total_voltage: u64 = 0;

    while (true) {
        const buffer = reader.interface.peekDelimiterExclusive('\n') catch {
            break;
        };
        _ = try reader.interface.discardDelimiterInclusive('\n');

        // For each bank, find the highest value battery
        var max_digit: u64 = 0;
        var bank_voltage: u64 = 0;
        for (buffer) |character| {
            const current_digit = character - '0';
            const current_voltage = max_digit * 10 + current_digit;

            max_digit = @max(current_digit, max_digit);
            bank_voltage = @max(current_voltage, bank_voltage);
        }

        total_voltage += bank_voltage;
    }

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    _ = try stdout.print("{d}\n", .{total_voltage});
    _ = try stdout.flush();
}

fn max_in_bank(buffer: []u8) u64 {
    const N = 12;
    var max_voltages: [N + 1]u64 = .{0} ** (N + 1);

    for (buffer) |character| {
        const current_digit = character - '0';
        for (0..N) |iterator| {
            const battery_length = N - iterator;
            const new_voltage = max_voltages[battery_length - 1] * 10 + current_digit;
            max_voltages[battery_length] = @max(max_voltages[battery_length], new_voltage);
        }
    }

    const bank_voltage: u64 = max_voltages[N];
    return bank_voltage;
}

fn part2() !void {
    // Read from `stdin` all the lines
    var reader_buffer: [1024]u8 = undefined;
    const io = std.testing.io;
    var reader = stdIn.reader(io, &reader_buffer);

    var total_voltage: u64 = 0;

    while (true) {
        const buffer = reader.interface.peekDelimiterExclusive('\n') catch {
            break;
        };
        _ = try reader.interface.discardDelimiterInclusive('\n');

        // For each bank, find the highest value battery
        const bank_voltage = max_in_bank(buffer);

        total_voltage += bank_voltage;
    }

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    _ = try stdout.print("{d}\n", .{total_voltage});
    _ = try stdout.flush();
}

pub fn main() !void {
    try part2();
}
