in = stdin::IO;
out = stdout::IO;

id_ranges = []
ids = []

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

# Read the available ingredient IDs
while true
    line = readline(in);
    line != "" || break

    # Add the ingredient ID to the list of ingredient IDs
    id = parse(Int64, line)
    push!(ids, id)
end

id_ranges = sort(id_ranges)
ids = sort(ids)

n_fresh_ids = 0
id_range_index = 1
for id in ids
    # The first condition guarantees that the id_range_index is only between [1, size(id_ranges, 1)]
    # so we can always index that vector (index values are 1 to N)
    while id_range_index < size(id_ranges, 1) && id > id_ranges[id_range_index][2]
        global id_range_index += 1
    end

    # The second condition is necessary in case the previous while breaks
    # from the first condition (going out of bounds in the id_ranges vector)
    if id >= id_ranges[id_range_index][1] && id <= id_ranges[id_range_index][2]
        global n_fresh_ids += 1
    end
end

write(out, "$n_fresh_ids\n")
