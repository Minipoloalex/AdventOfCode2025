import Data.List
import Debug.Trace

main :: IO ()
main = do
    input <- parse_input
    print $ calc_ans $ input

split :: (Char -> Bool) -> String -> [String]
split pred s = case dropWhile pred s of
    "" -> []
    s' -> w : split pred s''
        where (w, s'') = break pred s'

parse_input :: IO [(Int, Int)]
parse_input = do
    input <- getLine
    let parsed = map parse_single $ split (==',') input
    return parsed

parse_single :: String -> (Int, Int)
parse_single s = (x, y)
    where
        parts = split (=='-') s
        x = read (head parts) :: Int
        y = read (parts !! 1) :: Int


calc_ans :: [(Int, Int)] -> Int
calc_ans x = sum $ map calc_single_ans x


-- change here between check and check2 for part 1 or 2
calc_single_ans :: (Int, Int) -> Int
calc_single_ans (x, y) = sum $ map check2 [x..y]

check :: Int -> Int
check n
    | fst == snd = n
    | otherwise  = 0
    where
        nstr = show n -- use show for Number -> String
        (fst, snd) = splitAt (length nstr `div` 2) nstr


check2 :: Int -> Int
check2 n
    | any (check_size nstr) [1..nsz-1] = n
    | otherwise = 0
    where
        nstr = show n -- use show for Number -> String
        nsz = length nstr

check_size :: String -> Int -> Bool
check_size nstr sz = nsz `mod` sz == 0 && all (==fst) pieces
    where
        nsz = length nstr
        pieces = split_pieces nstr sz
        fst = head pieces


-- int should be size of substrings (len(string) % int == 0)
split_pieces :: String -> Int -> [String]
split_pieces s n
    | s == "" = []
    | otherwise = cur : s''
        where
            (cur, s') = splitAt n s
            s'' = split_pieces s' n
