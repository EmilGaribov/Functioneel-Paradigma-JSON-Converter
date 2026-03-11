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

import Test.HUnit ( assertEqual, runTestTT, Test(..) )
import JSONTypes ( JSON(JString,JNumber) )
import JSONParser (parseValue)

-- Je test case
testJString :: Test
testJString = TestCase (assertEqual "Moet een JString teruggeven" 
                        (JString "Hallo") 
                        (parseValue "\"Hallo\""))

-- Een test voor getallen
testJNumber :: Test
testJNumber = TestCase (assertEqual "Check of getal klopt" 
                        (JNumber 42.0) 
                        (parseValue "42"))

-- De lijst met alle tests
tests :: Test
tests = TestList [TestLabel "String Test" testJString , TestLabel "Number Test" testJNumber] 

-- De functie die alles start
main :: IO ()
main = do
    result <- runTestTT tests
    return ()