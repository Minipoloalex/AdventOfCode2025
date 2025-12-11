use std::{collections::{HashMap, HashSet}, io};

struct Node {
    connections: Vec<String>,
}

fn parse_input() -> HashMap<String, Node> {
    let stdin = io::stdin();

    let mut lines: HashMap<String, Node> = HashMap::new();
    loop {
        let mut buffer = String::new();
        stdin.read_line(&mut buffer).unwrap_or(0);
        buffer = String::from(buffer.trim());

        if buffer.is_empty() {
            break;
        }

        let splits: Vec<&str> = buffer.split(":").collect();
        let id: String = String::from(splits.get(0).unwrap().to_owned());

        let connections: Vec<&str> = splits.get(1).unwrap().trim().split(" ").collect();
        let connections: Vec<String> = connections.iter().map(|s| String::from(s.to_owned())).collect();

        lines.insert(id, Node {connections});
    }

    lines
}

fn count_all_paths(current: &String, graph: &HashMap<String, Node>, visited: HashSet<String>) -> u64 {
    if current == "out" {
        return 1;
    }

    let mut count = 0;
    for edge in &graph.get(current).unwrap().connections {
        if ! visited.contains(edge) {
            let mut new_visited = visited.clone();
            new_visited.insert(edge.to_owned());
            count += count_all_paths(edge, graph, new_visited);
        }
    }
    
    count
}

#[derive(PartialEq, Eq, Hash, Clone, Copy, Debug)]
struct VisitState {
    dac: bool,
    fft: bool,
}

#[derive(Debug)]
struct State {
    partials: HashMap<VisitState, u64>,
}

fn add_states(s1: HashMap<VisitState, u64>, s2: &State) -> HashMap<VisitState, u64> {
    let mut partials = HashMap::new();

    let keys1: HashSet<&VisitState> = s1.keys().collect();
    let keys2: HashSet<&VisitState> = s2.partials.keys().collect();

    for &key in keys1.union(&keys2) {
        let v1 = s1.get(key).unwrap_or(&0).to_owned();
        let v2 = s2.partials.get(key).unwrap_or(&0).to_owned();
        partials.insert(key.to_owned(), v1 + v2);
    }

    partials
}

fn count_all_paths_with_dac_and_fft<'a> (current: &String, graph: &HashMap<String, Node>, visited: HashSet<String>, cache: &'a mut HashMap<String, State>) -> &'a State
{
    if current == "out" {
        let mut partials: HashMap<VisitState, u64> = HashMap::new();
        partials.insert(VisitState { dac: true, fft: true }, 0);
        partials.insert(VisitState { dac: true, fft: false }, 0);
        partials.insert(VisitState { dac: false, fft: true }, 0);
        partials.insert(VisitState { dac: false, fft: false }, 1);

        cache.insert(current.to_owned(), State{ partials });
        return cache.get(current).unwrap();
    }

    if cache.contains_key(current) {
        return cache.get(current).unwrap();
    }

    let mut state_partials = HashMap::new();
    for edge in &graph.get(current).unwrap().connections {
        if ! visited.contains(edge) {
            let mut new_visited = visited.clone();
            new_visited.insert(edge.to_owned());

            let new_state = count_all_paths_with_dac_and_fft(edge, graph, new_visited, cache);
            state_partials = add_states(state_partials, new_state);
        }
    }

    // Update partials to contain current node information
    if current == "dac" {
        for fft_value in [true, false] {
            state_partials.insert(VisitState { dac: true, fft: fft_value }, state_partials.get(&VisitState { dac: false, fft: fft_value }).unwrap_or(&0).to_owned());
            state_partials.insert(VisitState {dac: false, fft: fft_value}, 0);
        }
    }
    else if current == "fft" {
        for dac_value in [true, false] {
            state_partials.insert(VisitState { dac: dac_value, fft: true }, state_partials.get(&VisitState { dac: dac_value, fft: false }).unwrap_or(&0).to_owned());
            state_partials.insert(VisitState {dac: dac_value, fft: false}, 0);
        }
    }

    cache.insert(current.to_owned(), State {partials: state_partials});
    cache.get(current).unwrap()
}

fn part1(lines: &HashMap<String, Node>) -> u64 {
    let starter = String::from("you");
    if ! lines.contains_key(&starter) {
        return 0;
    }
    let value = count_all_paths(&starter, lines, HashSet::new());
    value
}

fn part2(lines: &HashMap<String, Node>) -> u64 {
    let starter = String::from("svr");
    if ! lines.contains_key(&starter) {
        return 0;
    }
    let mut cache = HashMap::new();
    let value = count_all_paths_with_dac_and_fft(&starter, &lines, HashSet::new(), &mut cache);
    value.partials.get(&VisitState { dac: true, fft: true }).unwrap().to_owned()
}

fn main() -> Result<(), std::io::Error> {
    let lines = parse_input();

    println!("Part 1 : {}", part1(&lines));
    println!("Part 2 : {}", part2(&lines));

    Ok(())
}
