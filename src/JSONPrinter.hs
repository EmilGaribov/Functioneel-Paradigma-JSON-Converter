module JSONPrinter (flattenValue) where

import JSONTypes ( JSON(..) )
-- | Converteert een JSON waarde naar een enkelvoudige string representatie.
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
    flattenPair (k,v) = k ++ ": " ++ flattenValue v ++ "\n"