module Main where

import JSONParser (parseValue)
import JSONPrinter (flattenValue)

main :: IO ()
main = do
  jsonFileContent <- readFile "../inputfile.json" -- Ik kan dit niet zonder deze funcntie want dit raak de OS aan dat kan ik niet zelf
  let parsed = parseValue jsonFileContent
  print parsed
  putStrLn (flattenValue parsed)

  {-
Schrijf een JSON-parser die JSON-bestanden inleest en omzet naar een datastructuur.
Maak gebruik van recursie en pattern matching om geneste objecten en arrays correct te verwerken.
-}

