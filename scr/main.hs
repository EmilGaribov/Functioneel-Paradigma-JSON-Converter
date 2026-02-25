import Distribution.Utils.Json (Json)
import Distribution.SPDX (LicenseId(JSON))

{- TIJDELIJKE TEXT LATER WEGHALEN
leg uit welke functionele concepten je hebt toegepast en hoe ze bijdragen aan de oplossing.
Schrijf een kort rapport (ongeveer 4-6 pagina’s)
-}

{-
Schrijf een JSON-parser die JSON-bestanden inleest en omzet naar een datastructuur.
Maak gebruik van recursie en pattern matching om geneste objecten en arrays correct te verwerken.

Waarom moet dit recursief?
Omdat JSON genest kan zijn
(Dat is)
{
  "person": {
    "name": "Emil" <-- NESTED
  }
}
-}
-- JSON input → Parse → Transform → Plain text → Print / Save
-- What type is JSON? --> convert --> String

main :: IO ()
main = do
  jsonFileContent <- readFile "inputfile.json" -- of dit mag ligt aan hoeveel Functinal code ik nog kan toepassen
  print jsonFileContent -- "{\n  \"name\": \"Emil\",\n  \"age\": 24\n}\n"
  print (jsonToPlainText jsonFileContent) -- "name:Emil,age:24"

jsonToPlainText :: String -> String 
jsonToPlainText [] = []
jsonToPlainText (x : xs)
  | x == '\n' = jsonToPlainText xs 
  | x == ' ' = jsonToPlainText xs 
  | x == '{' = jsonToPlainText xs
  | x == '}' = jsonToPlainText xs
  | x == '"' = jsonToPlainText xs 
  | x == '\\' = jsonToPlainText xs
  | otherwise = x : jsonToPlainText xs

-- Schrijf een JSON-parser die JSON-bestanden inleest en omzet naar een datastructuur.

--datastuctuur (Patternmatching)
-- dit is een Haskell algebraic data type (ADT).== Custom type
data JSON
  = JObject [(String, JSON)] 
  | JArray [JSON]             
  | JString String            
  | JNumber Double            
  | JBool Bool                
  | JNull                     
  deriving (Show, Eq)



-- plainTextToJson :: String -> String