module Main where
import Network.MateLight.Simple

import Data.Maybe
import qualified Network.Socket as Sock



move :: (Int, Int) -> String -> (Int, Int) -> (Int, Int)
move (xdim, ydim) "\"s\"" (x, y) = (x, (y + 4)) -- Add border so you can't go outside the road
move (xdim, ydim) "\"w\"" (x, y) = (x, (y - 4))
--move (xdim, ydim) "\"a\"" (x, y) = ((x - 1) `mod` xdim, y)
--move (xdim, ydim) "\"d\"" (x, y) = ((x + 1) `mod` xdim, y)
move _ _ x = x


toFrame :: (Int, Int) -> (Int, Int) -> ListFrame
toFrame (xdim, ydim) (x', y') = ListFrame $ map (\y -> map (\x -> if x == x' && y == y' then Pixel 0xff 0xff 0xff else Pixel 0 0 0) [0 .. xdim - 1]) [0 .. ydim - 1]

eventTest :: [Event String] -> (Int, Int) -> (ListFrame, (Int, Int))
eventTest events pixel = (toFrame dim pixel', pixel')
  where pixel' = foldl (\acc (Event mod ev) -> if mod == "KEYBOARD" then move dim ev acc else acc) pixel events

dim :: (Int, Int)
dim = (30, 12)
main :: IO ()
main = Sock.withSocketsDo $ runMate (Config (fromJust $ parseAddress "134.28.70.172") 1337 dim (Just 500000) False []) eventTest (1, 6)
