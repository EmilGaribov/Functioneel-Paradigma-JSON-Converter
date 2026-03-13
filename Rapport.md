## **Rapport**
Schrijf een kort rapport (ongeveer 4-6 pagina’s) dat voldoet aan de richtlijnen van de AIM-controlekaart.
leg uit welke functionele concepten je hebt toegepast en hoe ze bijdragen aan de oplossing.
Schrijf een kort rapport (ongeveer 4-6 pagina’s)

# ToDo
- Add docstring/comment to code (Explain what it does)
- Work in Rapport (Explain why)
--
 Hoe diep moet het zijn?
 zo min mogelijk teasers
 "Ik vond dit erg goed"
(Wat maakt het dan goed)
--
Niet alles is puur doordat ik Error handling erin heb gestopt
Dat is niet erg zolang ik kan vertellen dat ik weet dat dit niet puur meer is en uitleggen waarom ik dit niet puur heb gemaakt en waarom ik dit niet heb opgelost als ik wist dat het niet puur is. (bv geen tijd over)
--

# **Title: JSON Parser Paradigma Opdracht**
* **Versienummer**: 1
* **Studentnaam**: Emil
* **Studentnummer**: 2114655
* **Docentnamen**: Michel
* **Klas**: ITA-CNI-A-f
* **Datum**: 27-02-2026

## **Inleiding**
**D**it document gaat over de Functinele Paradigma opdracht van APP waarbij ik als student een functionele programmeertaal kies (*in mijn geval Haskell*) en hiermee inhoudelijk interessante challenge ga uitvoeren die ik zelf mag kiezen (*JSON Parser*) Hierbij is het doel het oefen en leren van algoritmes en functionele concepten in mijn context en dit te verwoorden in een document (*dit document*).

**I**k heb hierbij gekozen om te werken in Haskell na een mini onderzoek kwam ik tot de conclusie dat Haskell het beste keuze om fucntineel te leren werken omdat Haskell streng is en veelgebruikt is dus veel informatie over is ook is het fijn dat we les voorbeelden hier kregen.

## **Onderzoek**
**O**mdat ik heb gekozen om een JSON Parser te maken in Haskell moest ik uitvogelen hoe de syntax werkt van mijn taal en onderzoeken wat een JSON parser doet en inhoud

**N**a een paar googles searches en de opdracht nog eens te lezen kwam ik er achter dat ik minimaal deze functionele concepten moet gaan toepassen:
 - Recursie 
 - Pattern matching

**N**a veder onderzoek tewijl ik codeerde kwam ik er achter dat ik dus ook meer concepten toepas dan deze twee namelijk:

- Higher Order Functions
- Pure Functions
- First-class Functions
- Immutability
- Lazy Evaluation
- Eën ADT

**I**k heb al deze concepten ook min of meer gebruikt in het maken van mijn code. 
**T**oevallig zijn all deze functionele concepten ook typishe kenmerken voor Haskell mijn gekozen taal voor deze opdracht.

## Functionele concepten 
**I**n dit stuk laat ik zien **hoe** ik deze concepten gebruikt heb met een link naar het bestand waar het zich bevind.

1. **Recursie** 

**R**ecursie wordt hier gebruikt in de hulpfunctie ``go``. De functie verwerkt telkens het eerste karakter van de string en roept zichzelf daarna opnieuw aan met de resterende karakters (``xs``). Dit gaat door totdat de basiscase ``go []``wordt bereikt.recursie aan te sturen

[JSONparser](src\JSONParser.hs) 
```Haskell
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
```

2. **Pattern matching**

**I**n dit voorbeeld wordt pattern matching gebruikt om te bepalen welk type JSON-waarde moet worden geparsed. De functie bekijkt het eerste karakter van de invoerstring met een ``case``-expressie. Afhankelijk van het patroon dat wordt herkend, wordt een andere parsefunctie aangeroepen. Wanneer het eerste karakter bijvoorbeeld een aanhalingsteken (`"`) is, wordt de string verwerkt met ``parseString``. Bij ``{`` wordt een object geparsed en bij ``[`` een array. Op deze manier kan de parser verschillende JSON-structuren herkennen op basis van het patroon van de invoer.

[JSONparser](src\JSONParser.hs) 
```Haskell
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
```

3. **Higher Order Functions**

**H**ier wordt map gebruikt als Higher-Order Function. Het past de functie ``(parseValue . trim)`` toe op elk element van de array, waardoor alle onderdelen magish (*automatisch*) worden omgezet naar JSON objecten. Dit laat zien hoe Haskell functies als argumenten kan gebruiken om lijsten efficiënt te verwerken en dus een HOF (*Higher-Order Function*) gebruikt wordt. Later kwam ik er achter dat hier dus ook `First-Class Function` in word gebruikt.

[JSONparser](src\JSONParser.hs) 
```Haskell
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
```

4. **Pure Functions**

``flattenValue`` **i**s een pure functie omdat het voor dezelfde ``JSON`` input altijd dezelfde string teruggeeft en geen bijwerkingen veroorzaakt. Het gebruikt recursie en lokale hulpfuncties om geneste JSON-structuren volledig te verwerken.

[JSONPrinter](src\JSONPrinter.hs) 
```Haskell
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
```
### Extra
**H**oewel sommige functies, zoals ``flattenValue``, puur zijn, zijn andere functies zoals ``parseValue``, ``parseArray`` en ``parseObject`` niet puur. Dit komt doordat ik error handling heb toegevoegd met als voorbeeld:
``` Haskell
-- parseValue method
then error "JSON error: empty value"
```
**D**eze aanpak veroorzaakt bijwerkingen *(het genereren van een runtime-fout*) en breekt daarmee de zuiverheid van de functie. Ik heb kort gekeken naar een alternatieve aanpak met `Maybe`, waarbij de functie in plaats van een foutmelding gewoon ``Nothing`` teruggeeft, maar ik had niet genoeg tijd om dit te implementeren.


5. **First-class Functions**

**I**n de regel ``parsed = map (parseValue . trim)`` parts zien we toevallig twee belangrijke functionele concepten: map is een Higher-Order Function omdat het een andere functie als argument ontvangt, en ``(parseValue . trim)`` is een first-class function, omdat deze als waarde wordt doorgegeven aan map.

[JSONparser](src\JSONParser.hs) 
``` Haskell
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
```

6. **Immutability**

``parseString`` **I**s een voorbeeld van een immutable functie. De originele inputstring wordt nooit aangepast; in plaats daarvan wordt stap voor stap een nieuwe string opgebouwd met recursie en pattern matching. Dit laat zien hoe Haskell functies schrijft die zuiver en state-onafhankelijk zijn.

[JSONparser](src\JSONParser.hs) 
```Haskell
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
```

7. **Lazy Evaluation**

``splitTopLevel`` **L**aat lazy evaluation zien. De lijst van gesplitste elementen wordt pas geëvalueerd wanneer deze nodig is, waardoor Haskell grote JSON-arrays efficiënt kan verwerken zonder meteen alles in het geheugen te laden.

[JSONparser](src\JSONParser.hs) 
```Haskell
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
```
8. **ADT**

**D**e ``JSON`` ADT wordt gebruikt om alle mogelijke JSON-waarden te representeren. Objecten en arrays worden recursief opgebouwd met ``JObject`` en ``JArray``, terwijl strings, nummers, booleans en null direct worden opgeslagen in hun respectievelijke constructor. Dit maakt pattern matching en recursie in de parser eenvoudig.

[JSONTypes](src\JSONTypes.hs) 

```Haskell
data JSON
  = JObject [(String, JSON)]
  | JArray [JSON]
  | JString String
  | JNumber Double
  | JBool Bool
  | JNull
  deriving (Show, Eq)
```

## **Challenge**
JSON Parser

Schrijf een JSON-parser die JSON-bestanden inleest en omzet naar een datastructuur.
Maak gebruik van recursie en pattern matching om geneste objecten en arrays correct te verwerken.


## **Implementatie**
-- Noem git
Korte samenvatting van de implementatie 
en ~~gebruikte functionele concepten.~~

## **Reflectie** !!
 --Wat heb je geleerd

## **Conclusie**
 Samenvatting van de belangrijkste leerpunten.
 Dit stuk kan ook in de reflectie 
 wat er boven staat maar dan korter (boven -- Reflectie)

## **Bronvermelding**
- *Onthoud dat je de PROMPTS van GPT moet opgeven of de Chatlink geeft in APP style (APPA genartor).*

ChatGPT:Hulp met Tests: https://chatgpt.com/c/69b2c461-c7ac-8329-8fb1-90c337a0e692