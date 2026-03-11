
{-
Schrijf een JSON-parser die JSON-bestanden inleest en omzet naar een datastructuur.
Maak gebruik van recursie en pattern matching om geneste objecten en arrays correct te verwerken.
-}

main :: IO ()
main = do
  jsonFileContent <- readFile "inputfile.json" -- Ik kan dit niet zonder deze funcntie want dit raak de OS aan dat kan ik niet zelf
  let parsed = parseValue jsonFileContent
  print parsed
  putStrLn (flattenValue parsed)

flattenValue :: JSON -> String
flattenValue (JString s) = s
flattenValue (JNumber n) = show n
flattenValue (JBool b) = if b then "true" else "false"
flattenValue JNull = "null"

flattenValue (JArray xs) =
  "[" ++ concatMap (\x -> flattenValue x ++ ", ") xs ++ "]"

flattenValue (JObject pairs) =
  concatMap flattenPair pairs
  where
    flattenPair (k,v) =
      k ++ ": " ++ flattenValue v ++ "\n"

-- dit is een Haskell algebraic data type (ADT).== Custom type
data JSON
  = JObject [(String, JSON)] 
  | JArray [JSON]             
  | JString String            
  | JNumber Double            
  | JBool Bool                
  | JNull                     
  deriving (Show, Eq)

parseValue :: String -> JSON
parseValue input =
  let s = trim input
  in if null s
     then error "JSON error: empty value"
     else case head s of
          '"' -> JString (parseString s)
          '{' -> parseObject s
          '[' -> parseArray s
          _
            | s == "true"  -> JBool True
            | s == "false" -> JBool False
            | s == "null"  -> JNull
            | otherwise    -> parseNumber s

parseString :: String -> String
parseString s = go (init (tail s))
  where
    go [] = []
    go ('\\':'n':xs)  = '\n' : go xs
    go ('\\':'"':xs)  = '"'  : go xs
    go ('\\':'\\':xs) = '\\' : go xs
    go (x:xs)         = x : go xs

parseNumber :: String -> JSON
parseNumber input = JNumber (read input) --makes input a double 

parseArray :: String -> JSON
parseArray input =
  case trim input of 
    ('[':xs) ->
      if null xs || last xs /= ']'
      then error "JSON error: missing closing ']' in array"
      else
        let inner  = trim (init xs)
            parts  = if null inner then [] else splitTopLevel inner
            parsed = map (parseValue . trim) parts
        in JArray parsed
    _ -> error "JSON error: array must start with '['"

parseObject :: String -> JSON
parseObject input =
  case trim input of
    ('{':xs) ->
      if null xs || last xs /= '}'
      then error "JSON error: missing closing '}' in object"
      else
        let inner = trim (init xs)
            parts = if null inner then [] else splitTopLevel inner
            pairs = map (parsePair . trim) parts
        in JObject pairs
    _ -> error "JSON error: object must start with '{'"

---- helper functions: count = 3parsePair :: String -> (String, JSON)
parsePair :: [Char] -> (String, JSON)
parsePair s =
  let (keyPart, rest) = break (== ':') s
  in if null rest
     then error "JSON error: missing ':' in object pair"
     else
       let key = parseString (trim keyPart)
           value = parseValue (trim (tail rest))
       in (key, value)

trim :: [Char] -> [Char]
trim = f . f
  where f = reverse . dropWhile (`elem` " \n\t")


{-splitTopLevel splits a JSON string into top-level key/value pairs.
Keeps track of nesting depth to ignore commas inside {} or [].
Recursive approach with current and results makes it functional and pure.-}
splitTopLevel :: String -> [String] -- MVP method
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
