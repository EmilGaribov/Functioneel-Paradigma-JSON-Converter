module JSONParser (parseValue, parseArray , parseNumber , parseString ,parseObject , splitTopLevel) where

import JSONTypes ( JSON(..) )

-- | Parseert een JSON string naar een JSON ADT waarde.
--   Detecteert het type (string, object, array, bool, null of number)
--   op basis van het eerste karakter van de input.
parseValue :: String -> JSON
parseValue input =
  let s = trim input
  in if null s
     then error "JSON error: empty value"
     else case head s of
          '"' -> JString (parseString s)
          '{' -> parseObject s
          '[' -> parseArray s
          _   | s == "true"  -> JBool True
              | s == "false" -> JBool False
              | s == "null"  -> JNull
              | otherwise    -> parseNumber s


-- | Parseert een JSON string literal.
--   Verwijdert de omringende quotes en verwerkt escape sequences
--   zoals \n, \" en \\.
parseString :: String -> String
parseString s 
  | length s < 2 = []
  | otherwise = go (init (tail s))
  where
    go [] = []
    go ('\\':'n':xs)  = '\n' : go xs
    go ('\\':'"':xs)  = '"'  : go xs
    go ('\\':'\\':xs) = '\\' : go xs
    go (x:xs)         = x : go xs


-- | Parseert een JSON numerieke waarde naar een JNumber.
--   Gebruikt Haskell's 'read' om de string naar een Double te converteren.
parseNumber :: String -> JSON
parseNumber input = JNumber (read input)


-- | Parseert een JSON array.
--   Splitst de elementen op top-level komma's en parseert elk element
--   afzonderlijk met 'parseValue'.
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


-- | Parseert een JSON object.
--   Verdeelt de inhoud in key-value paren en parseert elk paar.
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


-- | Parseert een key-value paar binnen een JSON object.
--   De key wordt verwacht als een JSON string en de value kan
--   elke geldige JSON waarde zijn.
parsePair :: String -> (String, JSON)
parsePair s =
  let (keyPart, rest) = break (== ':') s
  in if null rest
     then error "JSON error: missing ':' in object pair"
     else
       let key = parseString (trim keyPart)
           value = parseValue (trim (tail rest))
       in (key, value)


-- | Verwijdert whitespace aan het begin en einde van een string.
trim :: String -> String
trim = f . f
  where f = reverse . dropWhile (`elem` " \n\t")


-- | Splitst een JSON lijst of object op top-level komma's.
--   Houdt rekening met geneste arrays en objecten zodat
--   interne komma's niet verkeerd worden gesplitst.
splitTopLevel :: String -> [String]
splitTopLevel str = go str 0 "" []
  where
    go [] _ current results
      | null current = results
      | otherwise    = results ++ [current]
    go (c:cs) depth current results
      | isOpen c  = go cs (depth + 1) (current ++ [c]) results
      | isClose c = go cs (depth - 1) (current ++ [c]) results
      | isComma c && depth == 0 = go cs depth "" (results ++ [current])
      | otherwise = go cs depth (current ++ [c]) results
    isOpen c = c == '{' || c == '['
    isClose c = c == '}' || c == ']'
    isComma c = c == ','