# Food Delivery App

A mobile food-delivery application where users can register or sign in,
browse restaurants and dishes, view a restaurant's menu, add items to a cart,
place an order, and track their order history. Built in Flutter with Clean
Architecture (Cubit + GetIt), following the Figma UI Kit for design and
consuming the Fake Restaurant API for live data.
## Team
- جنة محمد فاروق
- جني محمد أحمد إبراهيم
- حذيفة محمد عبد الظاهر
- صبا أشرف نديم
- سجدة طارق خيري

## Architecture
`lib/`
- `core/` — constants, DI, networking (Dio), routing, themes, shared widgets
- `features/` — auth, restaurants, menu, cart, orders, profile
    - each feature split into: `data/`, `domain/`, `presentation/` (or `logic/` + `ui/`)

## Tech Stack
- Flutter + flutter_bloc (Cubit)
- get_it (Dependency Injection)
- dio (HTTP client)
- shared_preferences (session persistence)

## Base URL
https://fakerestaurantapi.runasp.net

## How to Run
1. Clone the repo
2. Run `flutter pub get`
3. Run `flutter run`

## Status
Core setup complete: networking, DI, routing, theme, splash/session handling.
Feature screens are being built by team members.