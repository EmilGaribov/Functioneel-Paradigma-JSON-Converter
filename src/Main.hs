module Main where

import JSONParser (parseValue)
import JSONPrinter (flattenValue)

main :: IO ()
main = do
  jsonFileContent <- readFile "../inputfile.json" 
  let parsed = parseValue jsonFileContent
  print parsed
  putStrLn (flattenValue parsed)
