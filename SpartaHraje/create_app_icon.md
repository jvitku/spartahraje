# Vytvoření App Icon pro SpartaHraje

## Možnost A: Použití online generátoru (NEJRYCHLEJŠÍ)

### 1. Vygeneruj ikonu online:

Jdi na: **https://www.appicon.co/** nebo **https://icon.kitchen/**

**Icon Kitchen (doporučeno):**
1. Jdi na: https://icon.kitchen/
2. Vyber "Image" → nahraj emoji ⚽ screenshot, nebo použij "Icon"
3. Vyber červenou barvu (#9C1C2E - Sparta red)
4. Background: Red gradient
5. Stáhni jako iOS App Icon
6. Rozbal ZIP

### 2. Alternativně - ruční vytvoření:

**Stáhni červený fotbalový míč:**
- **Flaticon** (free): https://www.flaticon.com/free-icon/soccer-ball_53283
- **Icons8** (free): https://icons8.com/icons/set/soccer-ball
- Vyhledej "red soccer ball icon free"

**Požadované velikosti pro iOS:**
- 1024x1024px (App Store)
- 180x180px (iPhone @3x)
- 120x120px (iPhone @2x)
- 167x167px (iPad Pro @2x)
- 152x152px (iPad @2x)
- 76x76px (iPad @1x)

## Možnost B: Emoji jako ikona (NEJJEDNODUŠŠÍ)

1. Otevři Preview (náhled) na Macu
2. Vytvoř nový dokument (Cmd+N)
3. Nastav velikost: 1024x1024px
4. Napiš emoji ⚽ (Cmd+Ctrl+Space)
5. Změň barvu na červenou (použij filtry/úpravy)
6. Export jako PNG

## Přidání do Xcode

### 1. Otevři Assets.xcassets:
   - V Xcode Project Navigator
   - Najdi **Assets.xcassets**
   - Klikni na něj

### 2. Přidej App Icon:
   - V Assets.xcassets najdi **AppIcon**
   - Přetáhni své ikony (různé velikosti) do příslušných slotů
   - Nebo stáhni celý asset z icon generátoru a přetáhni celou složku

### 3. Alternativně - použij jednu ikonu:
   - Xcode dokáže automaticky vygenerovat všechny velikosti z jedné 1024x1024px ikony
   - Stačí přetáhnout jeden velký obrázek do "iOS App Store" slotu (1024x1024)

## Možnost C: Programmaticky vygenerovaná ikona

Můžu vytvořit Swift skript, který vytvoří červený fotbalový míč programmaticky.
