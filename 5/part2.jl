in = stdin::IO;
out = stdout::IO;

id_ranges = []

# Read the fresh ingredient ID ranges
while true
    line = readline(in);
    line != "" || break

    # Add the ID range to the list of ID ranges
    line_splits = split(line, "-")
    start_id = parse(Int64, line_splits[1])
    end_id = parse(Int64, line_splits[2])
    push!(id_ranges, [start_id, end_id])
end

id_ranges = sort(id_ranges)

n_fresh_ids = 0
max_fresh_id = 0

for range in id_ranges
    start_id = max(max_fresh_id + 1, range[1]) # inclusive
    end_id = range[2]
    global n_fresh_ids += max(end_id - start_id + 1, 0) # 0 makes sure no negative numbers are added (start after end)
    global max_fresh_id = max(max_fresh_id, end_id)
end

write(out, "$n_fresh_ids\n")
