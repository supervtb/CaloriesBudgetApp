# CaloriesBudgetApp

A test iOS app that implements a simplified onboarding flow inspired by MyNetDiary.

## Overview
The app focuses on clean navigation, solid non-UI logic, and predictable onboarding behavior.
It follows the assignment requirements: code-based UI layout, optional HealthKit import, editable user input, and a final daily budget result screen.

## User Flow
The onboarding has 6 steps:
1. Welcome
2. Gender selection
3. Health App Import (Import or Skip)
4. Current Weight + unit system switch
5. Date of Birth
6. Daily Calorie Budget result

Users can go back to previous steps at any point.

## Behavior Implemented
- No persistence/state restore: after app relaunch, onboarding starts from the beginning.
- HealthKit import is optional.
- Imported values are used to prefill onboarding where available.
- Weight and date of birth are always editable by the user.
- If height is unavailable or invalid, the app uses a fallback value of `1.7 m`.
- Weight supports both `kg` and `lb` with conversion when unit mode changes.
- Date of birth validation enforces minimum age (13+).
- Final result is displayed as:
  - `kcal` in imperial mode
  - `kJ` in metric mode

## Architecture
The project is split into clear modules:
- `Navigation/` for app-level coordination and flow switching
- `Flows/OnboardingFlow/` for onboarding screens, view models, routes, and state
- `Flows/MainFlow/` for the final summary/result screen
- `Services/` for business logic (calculation, validation, HealthKit access)
- `Models/` for domain data structures
- `DI/` for dependency composition

Navigation is built with UIKit + Coordinator pattern.
Screen content/layout is implemented in code (no Interface Builder-based feature screen implementation).

## Technical Notes
- Targets iOS 17+.
- Designed primarily for iPhone; basic iPad compatibility is kept.
- Unit defaults are locale-aware based on the agreed assignment clarification.
- Business logic is separated from UI to keep it testable and reusable.

## Tests
The project includes unit tests in `CaloriesBudgetAppTests` for core domain/business behavior, including:
- calculation logic
- input validation
- onboarding-related model/view-model behavior

## Run
1. Open `CaloriesBudgetApp.xcodeproj` in Xcode.
2. Select the `CaloriesBudgetApp` scheme.
3. Run on an iOS 17+ simulator or device.

To run tests: `Product -> Test` (or `Cmd+U`).
