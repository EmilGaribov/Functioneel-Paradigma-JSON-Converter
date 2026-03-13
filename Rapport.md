# ToDo
- Add docstring/comment to code (Explain what it does)

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

## **Challenge: JSON Parser**
**D**e uitdaging was om een JSON-parser te bouwen die JSON-bestanden kan inlezen en omzetten naar een interne datastructuur (``JSON ADT``). Het ging hierbij niet alleen om eenvoudige waarden zoals strings, nummers, booleans en null, maar vooral om geneste objecten (``JObject``) en arrays (``JArray``) correct te verwerken. Omdat JSON-data een recursieve structuur kan hebben – objecten kunnen arrays bevatten, die op hun beurt weer objecten bevatten – moest de parser recursief en modulair zijn opgebouwd.

**I**k heb ook **UNIT** - **T E S T S** gemaakt voor mijn code.

### Dit was uitdagend omdat
**I**k moest nadenken. Ik Funtioneel moest nadenken over immutability en elke bewerking een nieuwe waarde geven zonder de input string aante passen waardoor dit moeijlijker was dan een imperatieve taal zoals Java.

**H**et correct identificeren van de “top-level” elementen in geneste arrays en objecten was lastig omdat ik eerst niet wist hoe dit moest. Hiervoor moest een functie zoals ``splitTopLevel`` worden bedacht die diep geneste komma’s kan negeren.

**O**ok moest ik goed nadenken over de basiscases en de recursieve stapen om te voorkomen dat je functies vastlopen of verkeerde waarden teruggeven.


## **Implementatie**

### Korte samenvatting van de implementatie 

**D**e parser leest een JSON-bestand in en zet dit om naar een interne datastructuur, de ``JSON`` ADT. Deze structuur ondersteunt:

- Strings (``JString``), nummers (``JNumber``), booleans (``JBool``) en null (``JNull``).
- Geneste objecten (``JObject``) en arrays (``JArray``).

**D**e parser is modulair opgebouwd:

1. ``JSONTypes.hs`` – definieert de ``JSON`` ADT.

2. ``JSONParser.hs`` – bevat functies om strings, nummers, arrays en objecten te parsen.

    - ``parseValue`` bepaalt het type JSON-waarde en roept de juiste parsefunctie aan.

    - ``parseString`` verwerkt escape-tekens en verwijdert aanhalingstekens.

    - ``parseArray`` en ``parseObject`` gebruiken recursie en ``splitTopLevel`` om geneste structuren correct te verwerken.

    - ``splitTopLevel`` splits een ``JSON`` ``Object`` of ``Array`` op top-level komma's en houd rekening met nested cases.

3. ``JSONPrinter.hs`` – bevat ``flattenValue``, die een ``JSON`` ADT omzet naar een schoone stringrepresentatie.

**A**lle code wordt beheerd met ``Git``, waardoor commits eenvoudig te bekijken zijn.

### Uitleg van de implementatie

1. **Detectie van JSON-type**

**D**e functie ``parseValue`` bekijkt het eerste karakter van de input om te bepalen welk type JSON-waarde wordt geparsed:

- ``"..." → parseString``
- ``{...} → parseObject``
- ``[...] → parseArray``
- ``true``, ``false``, ``null`` → respectievelijk ``JBool`` of ``JNull``
- Anders → ``parseNumber``

2. **Strings parsen**

``parseString`` **V**erwijdert de omringende aanhalingstekens en verwerkt escape sequences zoals ``\n``, ``\"`` en ``\\``. Het bouwt recursief een nieuwe string op, waarbij elke stap een nieuw karakter toevoegt.

3. **Arrays en objecten parsen**

``parseArray`` **E**n ``parseObject`` splitsen de inhoud op top-level komma’s via ``splitTopLevel``.
Elk element of key-value paar wordt afzonderlijk geparsed met ``parseValue``.
Recursie zorgt ervoor dat geneste arrays en objecten correct verwerkt worden.

4. **Top-level splitsing**

**D**e functie ``splitTopLevel`` houdt bij hoe diep genest een element zit, zodat interne komma’s van geneste arrays of objecten niet verkeerd worden gesplitst.

5. **Flattenen van JSON**

``flattenValue`` **Z**et de ``JSON`` ADT om naar een string, waarbij arrays en objecten recursief worden verwerkt. Strings, nummers, booleans en null worden direct omgezet naar een stringrepresentatie.

6. **Error handling**

**B**ij ongeldige JSON wordt een foutmelding gegooid via ``error``, bijvoorbeeld bij een ontbrekende ``]`` of ``}``. Dit maakt sommige functies niet volledig puur, maar dit was een nodig vooral bij het testen.


## **Reflectie** !!
**W**at heb ik nou geleerd dat is een goede vraag.

**T**ijdens deze opdracht heb ik geleerd om problemen op een functionele manier op te lossen. In plaats van variabelen aan te passen zoals in imperatieve talen (``Java``), moest ik werken met ``immutability``. Dit betekent dat data niet wordt aangepast, maar dat elke functie een nieuwe waarde teruggeeft.

**D**it was vooral merkbaar bij functies zoals ``parseString``. In deze functie wordt stap voor stap een nieuwe string opgebouwd met behulp van ``recursie``, in plaats van een bestaande string te wijzigen. Je kunt dit zien als het gebruiken van een oude waarde om een nieuwe waarde te maken.

**O**ok heb ik geleerd hoe ``pattern matching`` kan worden gebruikt om verschillende soorten input te herkennen. Samen met ``recursie`` blijkt dit een handige combinatie te zijn bij het verwerken van genested data.

**I**n ``parseValue`` wordt bijvoorbeeld het eerste karakter van een string bekeken om te bepalen welk type JSON-waarde het is. Op basis hiervan wordt de juiste **parsefunctie** aangeroepen. Hierdoor kan de parser makkelijk bepalen hoe de input verwerkt moet worden.

**D**aarnaast heb ik geleerd wat een ``ADT`` (Algebraic Data Type) is en hoe deze gebruikt kan worden om een datastructuur te maken. In mijn project wordt de ``JSON ADT`` gebruikt om alle mogelijke JSON-waarden te 'representeren'. Hierdoor kan Haskell met behulp van ``pattern matching`` eenvoudig bepalen hoe een bepaalde waarde verwerkt moet worden. Dit liet mij zien hoe krachtig ``ADT’s`` zijn bij het modelleren van complexere data.

**T**ijdens het programmeren merkte ik ook dat meerdere functionele concepten vaak tegelijk worden gebruikt. Bijvoorbeeld:

(Higher-Order Function & First-Class Function)
```Haskell 
parsed = map (parseValue . trim) parts
```

(Onderandere Recursie & Pattern Matching)
```Haskell 
go (c:cs) depth current results
  | isOpen c  = go cs (depth + 1) (current ++ [c]) results
  | isClose c = go cs (depth - 1) (current ++ [c]) results
  | isComma c && depth == 0 = go cs depth "" (results ++ [current])
  | otherwise = go cs depth (current ++ [c]) results

```
###  Side note (next time)
**T**ijdens het maken van dit verslag merkte ik dat er een aantal dingen zijn die ik achteraf anders had willen doen of verder had willen uitwerken.

**D**e belangrijkste hiervan is dat sommige functies in mijn implementatie niet volledig puur meer zijn. Dit komt doordat ik gebruik heb gemaakt van error voor error handling. Op het moment dat ik dit implementeerde, begreep ik nog niet goed dat deze manier van foutafhandeling de pure functionele flow verstoort. Achteraf had ik dit liever anders opgelost, bijvoorbeeld door gebruik te maken van ``Maybe``, zodat een functie ``Nothing`` kan teruggeven wanneer er iets misgaat. Een andere mogelijkheid was om een duidelijke foutwaarde of foutmelding terug te geven in plaats van een runtime-error.

**D**aarnaast had ik graag meer **tests** willen schrijven. Op dit moment heb ik voor elke **test** ongeveer twee edge cases toegevoegd, maar het was beter geweest had ik meer edges **getest**. Door tijds te kort was het helaas niet mogelijk om dit verder uit te breiden.

**T**ot slot had ik mijn **projectstructuur** graag beter willen opzetten. In mijn huidige aanpak werk ik met losse bestanden, waardoor ik soms problemen kreeg met module imports. Hiervoor bestaan oplossingen zoals Cabal of Cradle, waarmee een Haskell-project beter gestructureerd kan worden. In een volgend project zou ik dit willen gebruiken om een aantal problemen te voorkomen.

## **Conclusie**

**I**n deze opdracht heb ik een ``JSON Parser`` gebouwd in ``Haskell`` waarbij ik verschillende functionele concepten heb toegepast. Het belangrijkste dat ik heb geleerd is hoe **recursie** en **pattern matching** gebruikt kunnen worden om geneste datastructuren zoals ``JSON`` te verwerken.

**D**aarnaast heb ik beter begrepen hoe concepten zoals ``immutability``, ``higher-order functions`` en het gebruik van een ``ADT`` helpen bij het maken en verwerken van data in een functionele taal.

**D**oor deze opdracht heb ik meer inzicht/beeld gekregen in hoe functioneel programmeren werkt en hoe deze concepten in de praktijk (*Werkvloer*) kunnen worden toegepast bij het bouwen van algoritmes zoals een parser.

## **Bronvermelding**
- *Onthoud dat je de PROMPTS van GPT moet opgeven of de Chatlink geeft in APP style (APPA genartor).*

### APPA

ChatGPT:Hulp met Tests: https://chatgpt.com/c/69b2c461-c7ac-8329-8fb1-90c337a0e692

### Uitelg AI

## Gebruik van AI

**T**ijdens deze opdracht heb ik gebruik gemaakt van een AI-tool (ChatGPT) als ondersteuning bij het schrijven van mijn verslag en het verduidelijken van bepaalde concepten.

**A**I is voornamelijk gebruikt voor:
- Het verbeteren van de structuur en formulering van tekst in dit document.
- Het verduidelijken van uitleg over functionele concepten zoals recursie en pattern matching.
- Het geven van feedback op stukken tekst zodat deze duidelijker en beter gestructureerd werden.

**D**e implementatie van de JSON parser, het algoritme en de uiteindelijke code zijn door mijzelf ontworpen en geschreven. AI is hierbij alleen gebruikt als hulpmiddel voor uitleg en controle, vergelijkbaar met het raadplegen van documentatie.