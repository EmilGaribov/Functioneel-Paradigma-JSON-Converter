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
  --print jsonFileContent -- "{\n  \"name\": \"Emil\",\n  \"age\": 24\n}\n"
  --print (jsonToPlainText jsonFileContent) -- "name:Emil,age:24"
  let parsed = parseArray jsonFileContent
  print parsed
  
jsonToPlainText :: String -> String -- soort van flatten
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

-- jsonParser:: ? -> ?
-- hier alles methodes aanroepen

-- dit zou moeten kijk wat voor type het is
parseValue:: String -> JSON
parseValue s
  | head s == '"' = JString (parseString s)
  | head s == '{' = parseObject s
  | head s == '[' = parseArray s
  | s == "true"   = JBool True
  | s == "false"  = JBool False
  | s == "null"   = JNull
 -- | otherwise     = parseNumber s --moet zoals parseString

-- dit handled enkle string nu ik toe heb gevoed is het meer afgebakend omdat het "escaped charc" kan handle en het gebruikt recersion :D
parseString :: String -> String
parseString [] = []
parseString ('\\':'n':xs)  = '\n' : parseString xs
parseString ('\\':'"':xs)  = '"'  : parseString xs
parseString ('\\':'\\':xs) = '\\' : parseString xs
parseString (x:xs)         = x : parseString xs

parseArray :: String -> JSON
parseArray input =
  let inner = init (tail input)  -- remove '[' and ']'
      parts = splitTopLevel inner -- reused function splits top-level commas
      parsed = map (parseValue . trim) parts -- parse each thing recursively
  in JArray parsed

parseObject :: String -> JSON
parseObject input =
  let inner = init (tail input)           -- remove { and }
      parts = splitTopLevel inner        -- split top-level commas
      pairs = map parsePair parts        -- parse each key:value pair
  in JObject pairs

parsePair :: String -> (String, JSON)
parsePair s =
  let (keyPart, rest) = break (== ':') s
      key = parseString (trim keyPart)
      value = parseValue (trim (tail rest))
  in (key, value)

trim :: [Char] -> [Char]
trim = f . f
  where f = reverse . dropWhile (`elem` " \n\t")


{-splitTopLevel splits a JSON string into top-level key/value pairs.
Keeps track of nesting depth to ignore commas inside {} or [].
Recursive approach with current and results makes it functional and pure.-}
splitTopLevel :: String -> [String] -- reuse this in array 
splitTopLevel str = go str 0 "" []
  where
    go [] _ current results -- basecase
      | null current = results
      | otherwise    = results ++ [current]
    go (c:cs) depth current results --recursie 
      | isOpen c  = go cs (depth + 1) (current ++ [c]) results
      | isClose c = go cs (depth - 1) (current ++ [c]) results
      | isComma c && depth == 0 = go cs depth "" (results ++ [current])
      | otherwise = go cs depth (current ++ [c]) results
    isOpen c = c == '{' || c == '['
    isClose c = c == '}' || c == ']'
    isComma c = c == ','




--We hebben met Micheal gesproken:
{-Testen given meer punten
onderbouwing over WAAROM ik deze manier gebruik is verwacht ook als ik niets beters weet dan zou ik moeten zoeken en of bewijzen dat ik iets anders zag/probeerde maar niet deed omdat reden X
(Werkte Niet ,NVT , Te complex, Ik kreeg het niet werkend, )zo kan je dus uitleggen waarom je een minder goude keuze hebt gemaakt.
-}