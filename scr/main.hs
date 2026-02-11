
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

-}

main::IO ()
main = do
    print (function 7)
    print (doEuclidische 48 18)

function:: Int -> Int
function a =  3 + a

doEuclidische:: Int -> Int -> Int
doEuclidische input1 input2 = 
    if input2 == 0
        then input1
        else doEuclidische input2 (input1 `mod` input2)