# Sparta Hraje - iOS Aplikace

Nativní iOS aplikace pro sledování domácích zápasů AC Sparta Praha na Letné s inteligentními notifikacemi.

## Funkce

- ✅ Zobrazí, zda Sparta hraje dnes na Letné
- ✅ Seznam nadcházejících 10 domácích zápasů (všechny týmy: Muži A, B, Ženy)
- ✅ **Notifikace 3 dny a 1 den před zápasem na Letné**
- ✅ Team badges (červený pro hlavní tým, oranžový pro ostatní)
- ✅ Automatická změna barevného schématu (červené/zelené)
- ✅ Pull-to-refresh pro aktualizaci dat
- ✅ Background refresh pro automatické plánování notifikací
- ✅ Debug info s možností testovací notifikace

## Požadavky

- macOS 14+ (Sonoma) s Xcode 15+
- iOS 17.0+
- iPhone pro testování notifikací (doporučeno)

## Nastavení Projektu

### 1. Vytvoření Xcode Projektu

```bash
cd /Users/jaroslavvitku/workspace/spartahraje
```

1. Otevřete Xcode
2. **File → New → Project**
3. Vyberte **iOS → App**
4. Nastavení projektu:
   - **Product Name:** `SpartaHraje`
   - **Team:** Vyberte váš Apple ID (nebo vytvořte nový)
   - **Organization Identifier:** `com.yourname` (můžete změnit)
   - **Bundle Identifier:** `com.yourname.spartahraje`
   - **Interface:** SwiftUI
   - **Language:** Swift
   - **Storage:** None
5. **Minimum Deployments:** iOS 17.0
6. Klikněte **Next** a uložte do: `/Users/jaroslavvitku/workspace/spartahraje/SpartaHraje`

### 2. Přidání Souborů do Projektu

Všechny Swift soubory jsou již vytvořeny ve složce `SpartaHraje/SpartaHraje/`. Nyní je musíte přidat do Xcode projektu:

1. V Xcode, v **Project Navigator** (levý panel), klikněte pravým tlačítkem na složku `SpartaHraje`
2. Vyberte **Add Files to "SpartaHraje"...**
3. Přejděte do složky `SpartaHraje/SpartaHraje/`
4. Vyberte všechny složky: `Models`, `ViewModels`, `Views`, `Services`, `Utilities`
5. Ujistěte se, že je zaškrtnuto:
   - ✅ **Copy items if needed**
   - ✅ **Create groups**
   - ✅ **Add to targets: SpartaHraje**
6. Klikněte **Add**

7. **Nahraďte výchozí soubory:**
   - Smažte výchozí `ContentView.swift` (pokud existuje)
   - Smažte výchozí `SpartaHrajeApp.swift`
   - Přetáhněte `SpartaHrajeApp.swift` a `Info.plist` ze složky do projektu

### 3. Konfigurace Info.plist

Xcode by měl automaticky použít nový `Info.plist`. Pokud ne:

1. Vyberte projekt v Project Navigator
2. Vyberte target **SpartaHraje**
3. V **Info** tabu, ujistěte se, že obsahuje:
   - `NSUserNotificationsUsageDescription`
   - `UIBackgroundModes` (fetch, processing)
   - `BGTaskSchedulerPermittedIdentifiers`

### 4. Signing & Capabilities

1. Vyberte projekt → target **SpartaHraje** → **Signing & Capabilities**
2. Zaškrtněte **Automatically manage signing**
3. Vyberte váš **Team** (Apple ID)
4. Zkontrolujte, že **Bundle Identifier** je unikátní (např. `com.jaroslav.spartahraje`)

5. Přidejte **Background Modes** capability:
   - Klikněte **+ Capability**
   - Vyhledejte a přidejte **Background Modes**
   - Zaškrtněte:
     - ✅ **Background fetch**
     - ✅ **Background processing**

## Testování na Simulátoru

### Krok 1: Build & Run

1. V Xcode, vyberte simulator: **iPhone 15 Pro** (nebo jiný iOS 17+)
2. Klikněte **Run** (Cmd+R) nebo tlačítko ▶️
3. Aplikace by se měla spustit

### Krok 2: Základní Funkcionalita

✅ **Kontrolní seznam:**
- [ ] App se načte a zobrazí loading spinner
- [ ] Po načtení ukáže dnešní zápas (nebo "Ne, dnes nehraje")
- [ ] Seznam nadcházejících zápasů (až 10)
- [ ] Team badges: červený pro Muži A, oranžový pro ostatní
- [ ] Správné barevné schéma (červené/zelené)
- [ ] Pull-to-refresh funguje (táhněte dolů)
- [ ] Debug info je collapsible (klikněte ▶)

### Krok 3: Test Notifikací na Simulátoru

1. **Povolit notifikace:** Když se app poprvé spustí, měla by se zobrazit výzva k povolení notifikací
   - Klikněte **Allow**
   - Pokud se nezobrazí, restartujte simulator (Device → Erase All Content and Settings)

2. **Otevřít Debug Info:**
   - Scrollujte dolů na konec stránky
   - Klikněte na "▶ Debug informace" pro rozbalení
   - Měli byste vidět "Pending notifications: ~20" (10 matches × 2 notifications)

3. **Test notifikace:**
   - V Debug Info klikněte na tlačítko **"Test Notification (10s)"**
   - **ZAVŘETE aplikaci** - stiskněte Cmd+H (simuluje Home button)
   - Počkejte 10 sekund
   - ✅ Měla by se objevit notifikace: "Test: Sparta hraje za 3 dny!"

**Poznámka:** Na simulátoru notifikace fungují, ale background refresh není spolehlivý. Pro plné testování použijte fyzické zařízení.

## Testování na iPhone (Doporučeno)

### Krok 1: Připojení iPhone

1. Připojte iPhone k Macu pomocí USB kabelu
2. Na iPhone: Odemkněte telefon
3. Pokud se zobrazí "Trust This Computer?", klikněte **Trust**
4. V Xcode, v horní liště vyberte váš iPhone místo simulátoru

### Krok 2: Build & Install

1. Klikněte **Run** (Cmd+R)
2. Xcode zkompiluje a nainstaluje app na iPhone
3. **První spuštění:**
   - Pokud vidíte chybu "Untrusted Developer":
   - Na iPhone: **Settings → General → VPN & Device Management**
   - Klikněte na váš Apple ID
   - Klikněte **Trust "Your Name"**
   - Vraťte se do app a spusťte znovu

### Krok 3: Test Notifikací (Reálné)

#### Metoda 1: Změna Data (Rychlý Test)

1. **Zjistěte datum nadcházejícího zápasu:**
   - Otevřete app
   - V seznamu "Nadcházející zápasy" najděte nejbližší zápas
   - Např. "20. 12. 2025 18:00"

2. **Nastavte datum 3 dny před:**
   - Force quit app (swipe up z home screen)
   - iPhone: **Settings → General → Date & Time**
   - Vypněte **Set Automatically**
   - Nastavte datum na **17. 12. 2025** (3 dny před 20.12)
   - Nastavte čas na **10:00**

3. **Otevřete app a zavřete:**
   - Otevřete SpartaHraje app
   - Počkejte až se načte (naplánuje notifikace)
   - Force quit app

4. **Posuňte čas o 1 den:**
   - Settings → Date & Time
   - Změňte datum na **18. 12. 2025**
   - ✅ **Měla by přijít notifikace:** "Sparta hraje za 3 dny!"

5. **Test notifikace 1 den před:**
   - Nastavte datum na **19. 12. 2025**
   - ✅ **Měla by přijít notifikace:** "Sparta hraje zítra! | [Tým] vs [Soupeř] na Letné v 18:00"

6. **Vraťte automatický čas:**
   - Settings → Date & Time → **Set Automatically: ON**

#### Metoda 2: Testovací Notifikace (10 sekund)

1. Otevřete app
2. Scrollujte dolů do Debug Info
3. Klikněte **"Test Notification (10s)"**
4. **Zavřete app** (swipe up)
5. Počkejte 10 sekund
6. ✅ Notifikace by se měla objevit

#### Metoda 3: Dlouhodobý Test (Reálné použití)

1. Nechte app nainstalovanou
2. **Povolte Background App Refresh:**
   - Settings → General → Background App Refresh
   - Povolte pro SpartaHraje app
3. Používejte telefon normálně
4. Notifikace přijdou automaticky 3 dny a 1 den před skutečným zápasem

### Krok 4: Background Refresh Test

1. V Xcode (s iPhone připojeným)
2. Klikněte **Debug → Simulate Background Fetch**
3. V konzoli (View → Debug Area → Show Debug Area) byste měli vidět:
   ```
   🔄 Background refresh started
   ✅ Background refresh completed successfully
   ```

### Krok 5: Kontrola Pending Notifikací

1. Otevřete app
2. Debug Info → "Pending notifications: 20"
3. To znamená 10 zápasů × 2 notifikace (3d + 1d před)

## Struktura Projektu

```
SpartaHraje/
├── SpartaHrajeApp.swift              # Entry point, AppDelegate
├── Info.plist                        # Konfigurace
│
├── Models/                           # Data modely
│   ├── Team.swift                    # Sparta týmy (A, B, Ženy)
│   ├── Match.swift                   # Zápas s isAtLetna logikou
│   ├── Venue.swift                   # Stadion
│   └── EventsResponse.swift          # API response
│
├── ViewModels/                       # Business logika
│   ├── MatchViewModel.swift          # Orchestrace dat + theme
│   └── NotificationManager.swift     # Plánování notifikací
│
├── Views/                            # UI komponenty
│   ├── MainView.swift                # Root view
│   ├── HeaderView.swift              # "Hraje dnes na Letné?"
│   ├── LoadingView.swift             # Loading spinner
│   ├── MatchTodayView.swift          # Dnešní zápas
│   ├── NoMatchView.swift             # Žádný zápas
│   ├── UpcomingMatchesView.swift     # Seznam zápasů
│   ├── MatchCardView.swift           # Jednotlivý zápas
│   └── DebugInfoView.swift           # Debug panel
│
├── Services/                         # Networking & utils
│   ├── APIService.swift              # SofaScore API
│   ├── StadiumDetector.swift         # Detekce Letné
│   └── DateFormatters.swift          # Czech date/time
│
└── Utilities/                        # Konstanty & barvy
    ├── Constants.swift               # API URLs, IDs
    └── Colors.swift                  # Sparta red/green themes
```

## Jak Fungují Notifikace

### Plánování

Notifikace se plánují:
1. **Při spuštění app** - MainView.swift → .task
2. **Po pull-to-refresh**
3. **Background refresh** (každých 24 hodin)

### Logika

```swift
// Pro každý nadcházející zápas NA LETNÉ:
for match in letnaMatches {
    // 1. Notifikace 3 dny před
    schedule(match, daysBefore: 3)
    // Titulek: "Sparta hraje za 3 dny!"
    // Text: "[Tým] vs [Soupeř] na Letné"

    // 2. Notifikace 1 den před
    schedule(match, daysBefore: 1)
    // Titulek: "Sparta hraje zítra!"
    // Text: "[Tým] vs [Soupeř] na Letné v 18:00"
}
```

### Duplicity

- Při každém plánování se nejprve **vymažou všechny** pending notifikace
- Pak se naplánují nové
- Každá notifikace má unikátní ID: `sparta-match-{matchId}-{days}d`

### Oprávnění

App požádá o notification permissions při prvním spuštění. Pokud uživatel odmítne:
- App bude fungovat normálně
- Notifikace se nebudou zobrazovat
- V Debug Info můžete zkontrolovat status

## Troubleshooting

### Build Failed

**Problém:** "Cannot find 'Team' in scope"
- **Řešení:** Ujistěte se, že všechny soubory jsou přidány do target "SpartaHraje"
- V Project Navigator, klikněte na každý soubor → File Inspector → Target Membership → zaškrtněte "SpartaHraje"

**Problém:** "Missing required module 'BackgroundTasks'"
- **Řešení:** Změňte Minimum Deployment na iOS 17.0 (Project Settings → Deployment Info)

### Notifikace Nefungují

**Problém:** Notifikace se nezobrazují
- ✅ Zkontrolujte, že jste povolili notifikace při prvním spuštění
- ✅ V Debug Info zkontrolujte "Pending notifications" > 0
- ✅ Na iPhone: Settings → Notifications → SpartaHraje → Allow Notifications
- ✅ **Zavřete app** - notifikace se nezobrazí když je app otevřená

**Problém:** Test notification nefunguje
- ✅ Počkejte plných 10 sekund
- ✅ **Zavřete app** (Cmd+H na simulátoru, swipe up na iPhone)
- ✅ Restart simulátoru/telefonu

### Data se Nenačítají

**Problém:** "Chyba při načítání dat"
- ✅ Zkontrolujte internetové připojení
- ✅ SofaScore API může být dočasně nedostupné
- ✅ Zkuste pull-to-refresh

### Background Refresh Nefunguje

**Problém:** Notifikace se neplánují automaticky
- ✅ iPhone: Settings → General → Background App Refresh → ON
- ✅ Background refresh není garantován (iOS rozhoduje kdy)
- ✅ App musí běžet v popředí pravidelně
- ✅ Pro spolehlivé notifikace: otevírejte app alespoň 1× denně

## Další Vývoj

### Možná Rozšíření

- 📱 Widget showing next match
- ⌚ Apple Watch companion app
- 📅 Přidat do kalendáře
- 📤 Sdílet zápas
- ⚙️ Nastavení časů notifikací (např. 1 hodinu před)
- 🔴 Live Activity během zápasu
- 🔔 Push notifikace pro skóre (vyžaduje backend)

### Známé Limitace

- Background refresh není spolehlivý (závisí na iOS)
- Notifikace jen pro Letná matches (podle plánu)
- Team loga se cachují jen v paměti (po restartu se znovu načítají)
- Žádná offline podpora (vyžaduje internet)

## Zdroje

- **SofaScore API:** https://www.sofascore.com/
- **Sparta Kalendář:** https://sparta.cz/cs/zapasy/1-muzi-a/2025-2026/kalendar
- **Apple Documentation:**
  - [UserNotifications](https://developer.apple.com/documentation/usernotifications)
  - [BackgroundTasks](https://developer.apple.com/documentation/backgroundtasks)
  - [SwiftUI](https://developer.apple.com/xcode/swiftui/)

## License

Tato aplikace je vytvořena pro osobní použití. Data jsou získávána z veřejného SofaScore API.

---

Vytvořeno s Claude Code 🤖
