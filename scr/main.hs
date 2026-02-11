

{- TIJDELIJKE TEXT LATER WEGHALEN
Haskell
Json converter naar iets (start simple) als tijd over doe meer anders max 6 volgens micheal
{platte txt}
{pretty maken} 
etc

Het doel van de opdracht is om:

De werking van functionele programmeertalen te begrijpen en functionele concepten in praktijk te brengen.
(Dus als het niet werk kan je nog voldoen scoren als je laat zien dat je goed bezig was vandaar git)
Een oplossing te programmeren die gebaseerd is op het functionele paradigma.
(Dat je Functionle taal gebruikt?)
Functionele concepten bewust te koppelen aan specifieke onderdelen van je uitgeprogrammeerde algoritme.
(Lesstof toepassen bij mijn algoritmes?)
Je bevindingen helder te verwoorden in een rapport dat voldoet aan de AIM-controlekaart.
(Het opschrijft (Documenteerd) volgens HAN standaarden (Template))

------Dit moeten we onderzoeken.------waarschijnlijk ook iets over schrijven.
Zuiverheid (pure functions)
First-class functions
Higher-order functions
Immutability
Recursie
Lazy evaluation
Pattern matching

leg uit welke functionele concepten je hebt toegepast en hoe ze bijdragen aan de oplossing.
Schrijf een kort rapport (ongeveer 4-6 pagina’s)
-}

{-
You can omit the header of a method
function a = 3 + a works alone since it READS this as

function:: Int -> Int
function a =  3 + a

You cannot normally put print inside a normal function like doEuclidische
Because print is an IO action, and your function is pure

ONLY THESE are pure
+
-
*
/
mod
if statements
recursion
pattern matching
list operations


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
---------
IS DIT pattern matching? 

Als tekst begint met '{' → Object
Als tekst begint met '[' → Array
Als tekst begint met '"' → String
Als tekst = true/false → Bool
Als tekst = null → Null
Anders →  value/int ?

-}

main::IO ()
main = do
    print ()
    print ()

-- JSON input → Parse → Transform → Plain text → Print / Save
--What type is JSON? --> convert --> String

{-
data JSON
    = JObject [(String, JSON)]
    | JArray [JSON]
    | JString String
    | JNumber Double
    | JBool Bool
    | JNull

    wat is Data.Aeson?
-}
jsonConverter:: Int -> String -- Moet recursie hebben en? Pattern macthing?
jsonConverter a = "WIP" 