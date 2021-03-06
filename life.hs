import Data.List
import Control.Concurrent
import Control.DeepSeq

type Grid = [[Int]]

printMatrix g = let printCell 1 = putStr "■ "
                    printCell 0 = putStr ". "
                in mapM (\xs -> do
                              mapM_ printCell xs
                              putStr "\n") g

neighbours :: Grid -> Int -> Int -> Grid
neighbours g r c = foldr1 (zipWith (zipWith (+))) [up, down, left, right, shiftLeft up r,
                                            shiftRight up r, shiftLeft down r, shiftRight down r]
                   where
                        shiftUp (_:g) n = g ++ [replicate n 0]
                        shiftDown g n = replicate n 0 : init g
                        shiftLeft g n = foldr (\(_:xs) acc ->  (xs ++ [0]) : acc) [] g
                        shiftRight g n = foldr (\xs acc -> (0 : init xs) : acc) [] g
                        up     = shiftUp g c
                        down   = shiftDown g c
                        left   = shiftLeft g r
                        right  = shiftRight g r

nextIteration :: Grid -> Int -> Int -> Grid
nextIteration g r c = fmap (fmap p) (zipWith zip g $ neighbours g r c)
                      where p (1, n)
                              | n < 2 || n > 3 = 0
                              | otherwise      = 1
                            p (0, n)
                              | n == 3         = 1
                              | otherwise      = 0

simulate :: Grid -> Int -> Int -> IO ()
simulate seed r c = do
        putStr "\ESC[H"          --ANSI escape sequence to go to home
        printMatrix seed
        threadDelay 500000       --Sleep for 0.5 second
        simulate (nextIteration seed r c) r c

main = do
        seed <- fmap (\c -> map stringToList (lines c)) getContents
        seed `deepseq` putStr "\ESC[2J"        --Force strict evaluation of seed, i.e. wait for EOF then clear screen
        simulate seed (length seed) (length $ head seed)
        where stringToList str = map (\x -> read x :: Int) (words str)


