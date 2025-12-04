defmodule Main do
  def read_input() do
    case IO.gets("") do
      "\n" -> ""
      "" -> ""
      line -> line <> read_input()
    end
  end

  defp parse_to_tuple_grid(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(
      fn line ->
        line
        |> String.graphemes()
        |> List.to_tuple()
      end)
    |> List.to_tuple()
  end

  defp inside(r, c, rows, cols) do
    r >= 0 && c >= 0 && r < rows && c < cols
  end
  defp get_cell(grid, r, c) do
    elem(elem(grid, r), c)
  end
  defp cnt_adj(grid, r, c, rows, cols) do
    Enum.sum(
      Enum.map(-1..1,
      fn dr ->
        Enum.sum(
          Enum.map(-1..1,
          fn dc ->
            if inside(r+dr, c+dc, rows, cols) && get_cell(grid, r+dr, c+dc) == "@" do
              1
            else
              0
            end
          end)
        )
      end)
    )
  end

  def cnt_valid(grid) do
    rows = tuple_size(grid)
    cols = tuple_size(elem(grid, 0))
    Enum.sum(
      Enum.map(0..(rows-1),
      fn r ->
        Enum.sum(
          Enum.map(0..(cols-1),
          fn c ->
            if get_cell(grid,r,c) == "@" && cnt_adj(grid, r, c, rows, cols) <= 4 do
              1
            else
              0
            end
          end)
        )
      end)
    )
  end
  def cnt_ans2(grid) do
    rows = tuple_size(grid)
    cols = tuple_size(elem(grid, 0))
    ans = cnt_valid(grid)
    ngrid = Enum.reduce(
      Enum.map(0..(rows-1),
      fn r ->
        Enum.reduce(
          Enum.map(0..(cols-1),
          fn c ->
            if get_cell(grid,r,c) == "@" && cnt_adj(grid, r, c, rows, cols) <= 4 do
              "."
            else
              get_cell(grid, r, c)
            end
          end),
          [],
          fn x, acc -> [x | acc] end  # reverses stuff but idc
        )
      end),
      [],
      fn x, acc -> [x | acc] end
    )
    |> Enum.map(fn line -> List.to_tuple(line) end)
    |> List.to_tuple()

    if ans == 0 do
      ans
    else
      ans + cnt_ans2(ngrid)
    end
  end

  def solve() do
    input = read_input()
    grid = parse_to_tuple_grid(input)
    ans1 = cnt_valid(grid)
    ans2 = cnt_ans2(grid)
    IO.puts(ans1)
    IO.puts(ans2)
  end
end

Main.solve()
