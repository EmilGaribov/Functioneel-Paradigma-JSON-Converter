module JSONTypes where

-- ADT voor JSON
data JSON
  = JObject [(String, JSON)]
  | JArray [JSON]
  | JString String
  | JNumber Double
  | JBool Bool
  | JNull
  deriving (Show, Eq)