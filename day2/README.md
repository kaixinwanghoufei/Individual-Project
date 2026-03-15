# Mouse & Touch Workshop (Quick Guide)

- A minimal Flutter responsive demo showing mouse hover, tap, and keyboard activation across web, mobile, and tablet
- App entry: [lib/main.dart](file:///d:/953464/challenge4-workshop/day2/lib/main.dart)

## Features
- Responsive breakpoints
  - Mobile: width < 600
  - Tablet: 600–1024
  - Desktop/Web: ≥ 1024
- Layout & navigation
  - Mobile: bottom NavigationBar (HOME / BOARD / SETTINGS)
  - Tablet/Desktop: left NavigationRail
- Interactive button
  - On web, MouseRegion hover turns the button gray
  - Tap or press Enter/Space to show a SnackBar “Activated 🎉”
  - BOARD and SETTINGS each display a simple action button

## Key Code
- Page & state: MouseTouchWorkshopPage ([main.dart](file:///d:/953464/challenge4-workshop/day2/lib/main.dart))
- Interactive button: _InteractiveButton (same file)
- Widgets used: Scaffold, SafeArea, MediaQuery, LayoutBuilder, NavigationBar, NavigationRail, ListView/GridView, MouseRegion, Focus/KeyboardListener

## Run Locally
- Install dependencies
  - `flutter pub get`
- Run in browser
  - `flutter run -d chrome`
  - Specify port: `flutter run -d chrome --web-hostname localhost --web-port 5175`
- Other platforms
  - Android: `flutter run -d android`
  - Windows/macOS: `flutter run -d windows` / `flutter run -d macos`

## Dev Tips
- Hot reload: press `r` in the terminal; Hot restart: `R`
- Analyze & tests
  - `flutter analyze`
  - `flutter test`
- If the page appears blank in the browser, try Incognito/Private mode or temporarily disable extensions and hard reload (Ctrl+F5)

## Customize
- You can adjust breakpoints, button labels, and styles in `main.dart` without changing existing interaction logic or structure
