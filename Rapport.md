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
 - recursie 
 - pattern matching

**N**a veder onderzoek tewijl ik codeerde kwam ik er achter dat ik dus ook meer concepten toepas dan deze twee namelijk:

- Higher Order Functions
- Pure Functions
- First-class Functions
- Immutability
- Lazy Evaluation
- eën ADT

**I**k heb al deze concepten ook min of meer gebruikt in het maken van mijn code. 
**T**oevallig zijn all deze functionele concepten ook typishe kenmerken voor Haskell mijn gekozen taal voor deze opdracht.

## Functionele concepten 
**I**n dit stuk laat ik zien HOE ik deze concepten gebruikt heb met een link naar het bestand waar het zich bevind.

1. recursie 

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

2.
3.
4.
5.
6.
7.
8.

## **Challenge**
bla


## **Implementatie**

## **Reflectie** !!

## **Conclusie**

## **Bronvermelding**
- *Onthoud dat je de PROMPTS van GPT moet opgeven of de Chatlink geeft in APP style (APPA genartor).*

ChatGPT:Hulp met Tests: https://chatgpt.com/c/69b2c461-c7ac-8329-8fb1-90c337a0e692