module Main where

import Codec.Picture as P
import Data.Complex
import Data.Vector.Storable as V
import Data.Word as W
import Data.Time

-- 複素数 a + bi (a : 実部, b : 虚部, i : 虚数単位) は a :+ b で表す
-- 演算子 :+ は複素数を生成する

size = 1000
span' = 4.0
re_center = 0
im_center = 0
cpoint1 = (re_center - (span' / 2)) :+ (im_center - (span' / 2))
cpoint2 = (re_center + (span' / 2)) :+ (im_center + (span' / 2))

type CPoint = Complex Double

mandelbrot :: CPoint -> W.Word8
mandelbrot c = mandelbrot' c 2.0 (0 :+ 0) size

mandelbrot' :: CPoint -> Double -> CPoint -> Int -> W.Word8
mandelbrot' _ _ _ 0 = 0
mandelbrot' c threshold z n
  -- magnitude :: RealFloat a => Complex a -> a
  | magnitude z' > threshold = 255 - fromIntegral n
  | otherwise = mandelbrot' c threshold z' (n - 1)
  where
    z' = z * z + c

draw :: CPoint -> CPoint -> Int -> P.Image P.Pixel8
draw tl br size =
  P.Image
    { P.imageWidth = size,  P.imageHeight = size,
      P.imageData =
        -- Data.Vector.Storable.generate :: forall a. Storable a => Int -> (Int -> a) -> Vector a
        -- divMod :: Integral a => a -> a -> (a, a)
        -- mandelbrot :: CPoint -> W.Word8
        V.generate (size ^ 2) ( \n -> let (q, r) = n `divMod` size in mandelbrot (tl + dx * fromIntegral q + dy * fromIntegral r))
    }
  where
    -- realPart :: RealFloat a => Complex a -> a
    dx = (realPart br - realPart tl) / fromIntegral size :+ 0
    -- imagPart :: RealFloat a => Complex a -> a
    dy = 0 :+ (imagPart br - imagPart tl) / fromIntegral size


main :: IO ()
main = do
  x <- getCurrentTime
  putStrLn "スタート"
  -- P.writePng :: PngSavable pixel => FilePath -> Image pixel -> IO ()
  P.writePng "./mandelbrot_haskell.png" $ draw cpoint1 cpoint2 size
  y <- getCurrentTime
  putStr "経過時間(秒)"
  print $ diffUTCTime y x

