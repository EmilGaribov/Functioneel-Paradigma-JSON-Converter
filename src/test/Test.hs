--we gebruiken Hunit
-- runghc -isrc -itest test/Test.hs

module Main where

import Test.HUnit ( assertEqual, runTestTT, assertString,Test(..) )
import JSONTypes ( JSON(JString,JNumber, JArray, JObject) )
import JSONParser (parseValue, parseString , parseArray , parseObject , splitTopLevel)


testJNumber :: Test -- dit is meer een showcase test 
testJNumber = TestCase $ assertEqual "Check of getal klopt" --wat je checkt
                        (JNumber 42.0)   --Verwacht
                        (parseValue "42") --Echte antwoord

testStringEmpty :: Test
testStringEmpty = TestCase $ assertEqual "Check of hij leeg is" "" (parseString "")

testStringEscapedCharacters :: Test
testStringEscapedCharacters =
    TestCase $ assertEqual "Check if escaped charc stays escaped after becoming JString"
         "Hallo\nWereld"
         (parseString "\"Hallo\\nWereld\"")

testArrayEmpty :: Test
testArrayEmpty = TestCase $ assertEqual "Check of de array leeg is" (JArray []) (parseArray "[]" )

testArrayNested :: Test
testArrayNested = TestCase $ assertEqual "Nested array parsing" (JArray [JArray [JNumber 0.0]]) (parseValue "[[0.0]]")

testObjectEmpty :: Test
testObjectEmpty = TestCase $ assertEqual "Controleer of hij leeg is" (JObject []) (parseObject "{}")

testObjectNested :: Test
testObjectNested = TestCase $ assertEqual "Object wordt correct geparsed" 
    (JObject [("outer", JObject [("inner", JString "kip")])])
    (parseValue "{\"outer\": {\"inner\": \"kip\"}}")

testNestedArraySplit :: Test
testNestedArraySplit = TestCase $ assertEqual "Test een nested array de juiste comma handled" 
    ["[1,2]","[3,4]"]
    (splitTopLevel "[1,2],[3,4]")

testNestedObjectSplit ::Test
testNestedObjectSplit = TestCase $ assertEqual "Test een Nested object comma handling" 
    ["{\"a\":1}","{\"b\":2}"]
    (splitTopLevel "{\"a\":1},{\"b\":2}")

testNestedNumbersArraysAndObjects :: Test
testNestedNumbersArraysAndObjects = TestCase $ assertEqual "Mix van numbers, objects and arrays die worden correct gehandled door de functie"
    ["1","{\"a\":[2,3]}","4"]
    (splitTopLevel "1,{\"a\":[2,3]},4")


tests :: Test
tests = TestList [
                TestLabel "Number test" testJNumber,
                TestLabel "Empty string test" testStringEmpty,
                TestLabel "Escaped string test" testStringEscapedCharacters,
                TestLabel "Is de array leeg?" testArrayEmpty,
                TestLabel "Nested array word geparsed" testArrayNested,
                TestLabel "Kijk of object leeg is" testObjectEmpty,
                TestLabel "Nested object parsen" testObjectNested,
                TestLabel "Test of de functie array commas goed verwerkt" testNestedArraySplit,
                TestLabel "Test of de commas in het object correct worden verwerkt " testNestedObjectSplit,
                TestLabel "Test die een mix van numbers, objects en arrays verwerkt" testNestedNumbersArraysAndObjects
                 ]

main :: IO ()
main = do
    result <- runTestTT tests
    return ()