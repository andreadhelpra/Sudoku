# Sudoku

Sudoku is a logic puzzle from Japan which gained popularity in the
West during the 90s. Most newspapers now publish a Sudoku puzzle for
the readers to solve every day.

A Sudoku puzzle consists of a 9x9 grid. Some of the cells in the grid
have digits (from 1 to 9), others are blank. The objective of the
puzzle is to fill in the blank cells with digits from 1 to 9, in such
a way that every row, every column and every 3x3 block has exactly one
occurrence of each digit 1 to 9.

Here is an example of a Sudoku puzzle:

```
+---+---+---+---+---+---+---+---+---+
|   |   | 1 |   |   |   | 7 | 5 |   |
+---+---+---+---+---+---+---+---+---+
|   | 8 |   |   | 2 |   |   |   |   |
+---+---+---+---+---+---+---+---+---+
|   | 3 | 6 |   | 4 |   |   | 8 |   |
+---+---+---+---+---+---+---+---+---+
|   |   |   | 6 |   | 1 | 2 | 4 |   |
+---+---+---+---+---+---+---+---+---+
| 7 |   | 4 |   | 5 |   | 6 |   | 8 |
+---+---+---+---+---+---+---+---+---+
|   | 6 |   | 8 |   | 3 |   | 7 | 4 |
+---+---+---+---+---+---+---+---+---+
|   |   |   | 1 |   |   |   | 3 |   |
+---+---+---+---+---+---+---+---+---+
| 8 |   | 2 |   |   |   | 3 |   | 6 |
+---+---+---+---+---+---+---+---+---+
|   |   | 7 | 4 |   |   | 8 |   | 1 |
+---+---+---+---+---+---+---+---+---+


```


And here is the solution:

```
+---+---+---+---+---+---+---+---+---+
| 4 | 2 | 1 | 9 | 6 | 8 | 7 | 5 | 3 |
+---+---+---+---+---+---+---+---+---+
| 9 | 8 | 3 | 7 | 2 | 4 | 1 | 6 | 5 |
+---+---+---+---+---+---+---+---+---+
| 1 | 3 | 6 | 2 | 4 | 5 | 9 | 8 | 7 |
+---+---+---+---+---+---+---+---+---+
| 3 | 5 | 8 | 6 | 7 | 1 | 2 | 4 | 9 |
+---+---+---+---+---+---+---+---+---+
| 7 | 1 | 4 | 3 | 5 | 2 | 6 | 9 | 8 |
+---+---+---+---+---+---+---+---+---+
| 2 | 6 | 9 | 8 | 1 | 3 | 5 | 7 | 4 |
+---+---+---+---+---+---+---+---+---+
| 6 | 7 | 5 | 1 | 8 | 9 | 4 | 3 | 2 |
+---+---+---+---+---+---+---+---+---+
| 8 | 4 | 2 | 5 | 9 | 7 | 3 | 1 | 6 |
+---+---+---+---+---+---+---+---+---+
| 5 | 9 | 7 | 4 | 3 | 6 | 8 | 2 | 1 |
+---+---+---+---+---+---+---+---+---+
```


Adapted with permission from http://www.cse.chalmers.se/edu/course/TDA555.

## Download
First, download a copy of this repository.

```
$ git clone https://github.com/jimburton/sudoku.git
$ cd sudoku
sudoku$ 
```
This is a Cabal project. Use `cabal` to compile the code and run the tests:

```
sudoku$ cabal configure
sudoku$ cabal run test-sudoku
--- output of tests
```
