import System.Environment (getArgs)

diagonal :: [[a]] -> [a]
diagonal [] = []
diagonal ((a00:_):rows) = a00 : diagonal (map tail rows)

matSum :: Num a => [[a]] -> a
matSum = sum . map sum

msubm :: Num a => [[a]] -> [[a]] -> [[a]]
msubm = zipWith (zipWith (-))

mdivs :: Fractional a => [[a]] -> a -> [[a]]
mdivs a b = map (map (/b)) a

outer :: Num a => [a] -> [a] -> [[a]]
outer a b = [map (*x) b | x <- a]

lu :: (Num a, Fractional a) => [[a]] -> ([[a]], [[a]])
lu [[a00]] = ([[1]], [[a00]])
lu ((a00:w):rows) = (l, u)
  where
    n = length w + 1
    v = map head rows
    ap = map tail rows
    (lp, up) = lu $ ap `msubm` (v `outer` w) `mdivs` a00
    l = (1 : replicate (n - 1) 0) : zipWith (:) (map (/a00) v) lp
    u = (a00 : w) : map (0:) up
lu _ = error "lu: invalid matrix"

det :: (Num a, Fractional a) => [[a]] -> a
det = product . diagonal . snd . lu

main :: IO ()
main = do
  [doDet, k] <- map read <$> getArgs
  let n = 2 ^ k
  let a = replicate n $ replicate n 1
  putStrLn "Running..."
  if doDet /= 0
    then print $ det a
    else do
      let (l, u) = lu a
      let s = matSum l + matSum u
      print s
  putStrLn "Done."
