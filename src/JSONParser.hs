module JSONParser (parseValue) where

import JSONTypes ( JSON(..) )

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

parseString :: String -> String
parseString s = go (init (tail s))
  where
    go [] = []
    go ('\\':'n':xs)  = '\n' : go xs
    go ('\\':'"':xs)  = '"'  : go xs
    go ('\\':'\\':xs) = '\\' : go xs
    go (x:xs)         = x : go xs

parseNumber :: String -> JSON
parseNumber input = JNumber (read input)

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

parsePair :: String -> (String, JSON)
parsePair s =
  let (keyPart, rest) = break (== ':') s
  in if null rest
     then error "JSON error: missing ':' in object pair"
     else
       let key = parseString (trim keyPart)
           value = parseValue (trim (tail rest))
       in (key, value)

-- Helpers
trim :: String -> String
trim = f . f
  where f = reverse . dropWhile (`elem` " \n\t")

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