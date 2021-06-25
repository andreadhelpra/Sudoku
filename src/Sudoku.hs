module Sudoku where

import Data.Char (intToDigit, digitToInt)
import Data.Maybe (fromJust, isJust, isNothing, listToMaybe)
import Data.List (transpose, group, sort, sortBy, elemIndex, findIndex, splitAt)
import Data.List.Split (chunksOf)
import Data.Ix (inRange)
import Data.Functor
import Data.Function (on)
-------------------------------------------------------------------------

{-| A Sudoku puzzle is a list of lists, where each value is a Maybe Int. That is,
each value is either `Nothing' or `Just n', for some Int value `n'. |-}
newtype Puzzle = Puzzle [[Maybe Int]]
 deriving (Show, Eq)

{-| A Block is a list of 9 Maybe Int values. Each Block represents a row, a column,
or a square. |-}
type Block = [Maybe Int]

{-| A Pos is a zero-based (row, column) position within the puzzle. |-}
newtype Pos = Pos (Int, Int) deriving (Show, Eq)

{-| A getter for the rows in a Sudoku puzzle. |-}
rows :: Puzzle -> [[Maybe Int]]
rows (Puzzle rs) = rs

example :: Puzzle
example =
    Puzzle
      [ [Just 3, Just 6, Nothing,Nothing,Just 7, Just 1, Just 2, Nothing,Nothing]
      , [Nothing,Just 5, Nothing,Nothing,Nothing,Nothing,Just 1, Just 8, Nothing]
      , [Nothing,Nothing,Just 9, Just 2, Nothing,Just 4, Just 7, Nothing,Nothing]
      , [Nothing,Nothing,Nothing,Nothing,Just 1, Just 3, Nothing,Just 2, Just 8]
      , [Just 4, Nothing,Nothing,Just 5, Nothing,Just 2, Nothing,Nothing,Just 9]
      , [Just 2, Just 7, Nothing,Just 4, Just 6, Nothing,Nothing,Nothing,Nothing]
      , [Nothing,Nothing,Just 5, Just 3, Nothing,Just 8, Just 9, Nothing,Nothing]
      , [Nothing,Just 8, Just 3, Nothing,Nothing,Nothing,Nothing,Just 6, Nothing]
      , [Nothing,Nothing,Just 7, Just 6, Just 9, Nothing,Nothing,Just 4, Just 3]
      ]
    
easy1 :: Puzzle
easy1 = 
    Puzzle[[Nothing,Nothing,Just 3,Nothing,Just 2,Nothing,Just 6,Nothing,Nothing],[Just 9,Nothing,Nothing,Just 3,Nothing,Just 5,Nothing,Nothing,Just 1],[Nothing,Nothing,Just 1,Just 8,Nothing,Just 6,Just 4,Nothing,Nothing],[Nothing,Nothing,Just 8,Just 1,Nothing,Just 2,Just 9,Nothing,Nothing],[Just 7,Nothing,Nothing,Nothing,Nothing,Nothing,Nothing,Nothing,Just 8],[Nothing,Nothing,Just 6,Just 7,Nothing,Just 8,Just 2,Nothing,Nothing],[Nothing,Nothing,Just 2,Just 6,Nothing,Just 9,Just 5,Nothing,Nothing],[Just 8,Nothing,Nothing,Just 2,Nothing,Just 3,Nothing,Nothing,Just 9],[Nothing,Nothing,Just 5,Nothing,Just 1,Nothing,Just 3,Nothing,Nothing]]
{-| Ex 1.1

    A sudoku with just blanks. |-}
allBlankPuzzle :: Puzzle
allBlankPuzzle = Puzzle $ replicate 9 (replicate 9 Nothing)
-- replicating 9 times Nothing for each of the 9 rows

{-| Ex 1.2

    Checks if sud is really a valid representation of a sudoku puzzle. |-}
isPuzzle :: Puzzle -> Bool
isPuzzle sud = length r == 9 -- rows are 9
               && all ((==9) . length) r -- each row has 9 values
               && and (concatMap(map (\ x -> maybe (isNothing x) (inRange (1, 9)) x)) r) 
               where r = rows sud
-- Check if rows are 9 and if each row has 9 values. 
-- Each value is either a digit between 1 and 9 or Nothing

{-| Ex 1.3

    Checks if the puzzle is already solved, i.e. there are no blanks. |-}
isSolved :: Puzzle -> Bool
isSolved sud = and [Nothing `notElem` r | r <- rows sud] 
-- Return a [Bool] of 9 elements with each element stating if Nothing is NOT an element of that row,
-- then return True if all elements of that list are True, False otherwise.

{-| Ex 2.1

    `printPuzzle s' prints a representation of `s'. |-}
printPuzzle :: Puzzle -> IO ()
printPuzzle s' = putStr $ unlines [ map (maybe '.' intToDigit) r | r <- rows s']
-- For each element of a row return '.' if that element is Nothing otherwise 

{-| Ex 2.2

    `readPuzzle f' reads from the FilePath `f', and either delivers it, or stops
    if `f' did not contain a puzzle. |-}
readPuzzle :: FilePath -> IO Puzzle
readPuzzle f' = readFile f' <&> ((\ x -> if isPuzzle x then x else error "Not a Sudoku puzzle!") . Puzzle . map strToBlock . lines)
-- Read a file and keep its result, check if it is a puzzle and convert each line from string to Block type. return Puzzle

-- Convert each line from String to a Block    
strToBlock :: String -> Block
strToBlock xs | null xs        = [] -- Return an empty list if xs is empty
              | head xs == '.' = Nothing : strToBlock (tail xs) -- Convert '.' to Nothing and do recursion
              | otherwise      = Just (digitToInt $ head xs) : strToBlock (tail xs) -- Convert character to Just Int and do recursion

{-| Ex 3.1


    Check that a block contains no duplicate values. |-}
isValidBlock :: Block -> Bool
isValidBlock b = length b' == length(nub' b')  -- Check that the length is the same after eliminating duplicates
                 where b' = filter isJust b -- Only check if there are duplicate Just as there can be multiple Nothing

nub' :: (Ord a) => [a] -> [a]
nub' = map head . group . sort -- Sort the list, group duplicates, get head of each group and eliminate duplicates

{-| Ex 3.2

    Collect all blocks on a board - the rows, the columns and the squares. |-}
blocks :: Puzzle -> [Block]
blocks sud = let r = rows sud
             in r ++ transpose r ++ (map concat . concatMap transpose . chunksOf 3 . map (chunksOf 3)) r
-- Squares are collected by dividing in chunks of 3 each row,  dividing in chunks of 3 each column
-- concatenating each chunk of column to its row value and concatenate these for each square
{-| Ex 3.3

    Check that all blocks in a puzzle are legal. |-}
isValidPuzzle :: Puzzle -> Bool
isValidPuzzle = all isValidBlock . blocks -- All blocks are valid blocks or return False

{-| Ex 4.1

    Given a Puzzle that has not yet been solved, returns a position in
    the Puzzle that is still blank. If there are more than one blank
    position, you may decide yourself which one to return. |-}
blank :: Puzzle -> Pos
blank sud = let xs = map (elemIndex Nothing) (rows sud) -- [Maybe Int] containing blank column values.
                y = findIndex isJust xs -- Index of the first row where a blank is found 
            in case y of
                Just a -> Pos (a, fromJust (xs !! a))
-- Convert Maybe Int to create (Int, Int) tuple with the Int values of y and the first blank of that row

{-| Ex 4.2

    Given a list, and a tuple containing an index in the list and a
    new value, updates the given list with the new value at the given
    index. |-}
(!!=) :: [a] -> (Int,a) -> [a]
(!!=) [] _ = [] --handle case where list is empty 
(!!=) xs (i, a) | (i >= length xs) || (i < 0) = xs
                | otherwise = take i xs ++ [a] ++ drop (i + 1) xs
-- Concatenate list of values before the index, 
-- The new value and the values after.

{-| Ex 4.3

    `update s p v' returns a puzzle which is a copy of `s' except that
    the position `p' is updated with the value `v'. |-}
update :: Puzzle -> Pos -> Maybe Int -> Puzzle
update s (Pos(y, x)) v' = let r = rows s -- Get rows
                              rv  = (r !! y) !!= (x, v') -- Update new value at given Pos
                          in Puzzle $ r !!= (y, rv) -- Update puzzle with new row

{-| Ex 5.1

    Solve the puzzle. |-}
solve :: Puzzle -> Maybe Puzzle
solve s | not $ isValidPuzzle s = Nothing  -- There's a violation in s
        | isSolved s            = Just s   -- s is already solved
        | otherwise = pickASolution possibleSolutions -- Get a solution
  where
   nineUpdatedSuds = [update s (blank s) (Just v) | v <- [1..9]] :: [Puzzle] -- Fill the first blank space with all numbers 1 to 9
   possibleSolutions = [solve s' | s' <- nineUpdatedSuds] -- Return solutions 

pickASolution :: [Maybe Puzzle] -> Maybe Puzzle
pickASolution [] = Nothing -- Return Nothing if there is no solution
pickASolution (x:xs) = if isJust x then x else pickASolution xs -- Return the head or start recursion

{-| Ex 5.2
s <- readPuzzle "puzzles/hard20.sud"
printPuzzle(fromJust (solve s))
    Read a puzzle and solve it. |-}
readAndSolve :: FilePath -> IO (Maybe Puzzle)
readAndSolve f' = do 
                     sud <- readPuzzle f' -- Bind the file
                     pure $ solve sud -- Return the solution

{-| Ex 5.3

    Checks if s1 is a solution of s2. |-}
isSolutionOf :: Puzzle -> Puzzle -> Bool
isSolutionOf s1 s2 = isValidPuzzle s1 -- All blocks are ok
                     && isSolved s1 -- There are no blanks
                     && all (\(x, y) -> isNothing y || (x == y)) -- Ignore if Nothing, check they're equal if Just
                            (zip ((concat . rows) s1) ((concat . rows) s2))
                        -- List of tuples containing the elements of the two puzzles at the same Pos 

