#!/usr/bin/env runhaskell
-- filter.hs
{-# LANGUAGE OverloadedStrings #-}
import Text.Pandoc.JSON
import qualified Data.Text as T
import Control.Exception
import Type.Reflection

main :: IO ()
main = toJSONFilter behead


behead :: [Inline] -> [Inline]
behead ((xs@(Str "$>" : _))) = [Code nullAttr (concat_text T.empty xs)]
behead x = x

data MyException
  = UnknownCode Inline
  deriving (Show,Typeable)

instance Exception MyException

concat_text:: T.Text -> [Inline] -> T.Text
concat_text acc (Str s : l) = concat_text (T.append acc s) l
concat_text acc (Space : l) = concat_text (T.snoc acc ' ') l
concat_text acc (Strong l' : l) = concat_text (concat_text acc l') l
concat_text acc [] = acc
concat_text acc (x : _) = throw (UnknownCode x)