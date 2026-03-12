--Zoek uit hoe ik Unit tests maak in Haskell
-- Ook hier Docstring/comments
--We hebben met Micheal gesproken:
{-Testen given meer punten
onderbouwing over WAAROM ik deze manier gebruik is verwacht ook als ik niets beters weet dan zou ik moeten zoeken en of bewijzen dat ik iets anders zag/probeerde maar niet deed omdat reden X
(Werkte Niet ,NVT , Te complex, Ik kreeg het niet werkend, )zo kan je dus uitleggen waarom je een minder goude keuze hebt gemaakt.
-}

--we gebruiken Hunit
-- runghc -isrc -itest test/Test.hs


module Main where

import Test.HUnit ( assertEqual, runTestTT, assertString,Test(..) )
import JSONTypes ( JSON(JString,JNumber, JArray) )
import JSONParser (parseValue, parseString , parseArray , parseObject)


testJNumber :: Test
testJNumber = TestCase (assertEqual "Check of getal klopt" --wat je checkt
                        (JNumber 42.0)   --Verwacht
                        (parseValue "42")) --Echte antwoord

testStringEmpty :: Test
testStringEmpty = TestCase (assertEqual "Check of hij leeg is" "" (parseString ""))

testStringEscapedCharacters :: Test
testStringEscapedCharacters = 
    TestCase (assertEqual "Check if escaped charc stays escaped after becoming JString"
         "Hallo\nWereld"
         (parseString "\"Hallo\\nWereld\""))

testArrayEmpty :: Test
testArrayEmpty = TestCase (assertEqual "Check of de array leeg is" (JArray []) (parseArray "[]" ))

testArrayNested :: Test
testArrayNested = TestCase (assertEqual "Nested array wordt correct geparsed" 
        (JArray [JArray [JNumber 0 ]])  
        (parseValue "[[0]]"))

tests :: Test
tests = TestList [
                TestLabel "Number Test" testJNumber,
                TestLabel "Empty String Test" testStringEmpty,
                TestLabel "Ecscaped String Test" testStringEscapedCharacters,
                TestLabel "Is de Array leeg?" testArrayEmpty,
                TestLabel "Nested array word geparsed" testArrayNested
                 ]


main :: IO ()
main = do
    result <- runTestTT tests
    return ()