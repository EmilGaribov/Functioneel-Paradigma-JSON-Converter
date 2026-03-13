# Functioneel-Paradigma-JSON-Converter/Parser
Functioneel Paradigma opdracht voor APP waarin een JSON parser/converter in Haskell wordt ontwikkeld. Het project gebruikt functionele concepten zoals recursie, pattern matching, higher-order functions, immutability, ADTs en lazy evaluation.

# Projectstructuur
```
Functioneel-Paradigma-JSON-Converter/
│
├─ src/
│   ├─ JSONTypes.hs       # Definities van de JSON ADT
│   ├─ JSONParser.hs      # Parser functies (parseValue, parseArray, parseObject etc.)
│   ├─ JSONPrinter.hs     # flattenValue functie
│   └─ Main.hs            # Entry point voor het programma
│
├─ test/
│   └─ Test.hs            # HUnit tests
│
└─ inputfile.json         # JSON input bestand
```
# Installatie & vereisten

- Haskell compiler (GHC)
- HUnit library voor testen (cabal install HUnit of via Stack)
- yaml file (``hie.yaml``) om de modules te kunnen spliten van main.

# Gebruik
### Runnen van de JSON parser
De ``Main.hs`` leest een JSON-bestand in, parseert het naar de interne ``JSON ADT`` en print zowel de ADT als een platte stringrepresentatie.

```Powershell
PS C:\Users\<jouw-gebruikersnaam>\GitHub\Functioneel-Paradigma-JSON-Converter\src> runghc src\Main.hs
```
**Output voorbeeld:**
- Is afhankelijk van wat er in ``inputfile.json`` staat.
```
JObject [("school",JObject [("naam",JString "HAN"),("locatie",JString "Arnhem"),("opleidingen",JArray [JObject [("naam",JString "Informatica"),("studenten",JArray [JObject [("naam",JString "Emil"),("leeftijd",JNumber 21.0),("vakken",JArray [JObject [("naam",JString "Programming"),("cijfer",JNumber 8.2)],JObject [("naam",JString "Databases"),("cijfer",JNumber 7.5)]])],JObject [("naam",JString "Sara"),("leeftijd",JNumber 22.0),("vakken",JArray [JObject [("naam",JString "Programming"),("cijfer",JNumber 9.0)],JObject [("naam",JString "AI"),("cijfer",JNumber 8.7)]])]])],JObject [("naam",JString "Communicatie"),("studenten",JArray [JObject [("naam",JString "Tom"),("leeftijd",JNumber 20.0),("vakken",JArray [JObject [("naam",JString "Marketing"),("cijfer",JNumber 7.8)]])]])]])])]
```
**Let op ik heb hier de flatten weg gelaten deze staat direct onder dit stuk!!**

Zorg dat het JSON-bestand (``inputfile.json``) aanwezig is in de projectroot of pas het pad aan in ``Main.hs.``

# Runnen van de tests
Alle tests zijn geschreven met HUnit in`` test/Test.hs``.
```
# Voer alle tests uit
runghc -isrc -itest test/Test.hs
```
Zorg ervoor dat je op de juiste niv zit in de terminal!
bij mij was dit `` Functioneel-Paradigma-JSON-Converter\src> runghc -isrc -itest test/Test.hs``

### Beschrijving van de tests:

- Controleren van parsing van strings, nummers, booleans en null
- Controleren van lege en geneste arrays
- Controleren van lege en geneste objects
- Testen van de top-level comma splitting (splitTopLevel)
- Combinatie van nested numbers, arrays en objects
Verwachte output: Test resultaten in de terminal met pass/fail status.

# Belangrijke Functies
- ``parseValue``: Detecteert type ``JSON`` waarde en roept de juiste parser aan
- ``parseString``: Verwerkt strings met escape-tekens
- ``parseArray`` / ``parseObject``: Recursive parsing met top-level comma handling
- ``splitTopLevel``: Splitst geneste arrays en objecten op top-level commas
- ``flattenValue``: Zet een ``JSON ADT`` om naar een platte stringrepresentatie