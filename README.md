# WordGame - iOS Coding Challenge for Babbel
[![Swift 5](https://img.shields.io/badge/Swift-5-green.svg?style=flat)](https://swift.org/) [![Xcode 14.0.1](https://img.shields.io/badge/Xcode-14.0.1-blue)](https://developer.apple.com/documentation/xcode-release-notes/xcode-14_0_1-release-notes)

## Task Description
The task is to write a small language game. At the end of the challenge, a user will see an English word on the screen. While the English word is displayed, a word in Spanish will appear.
The user has to choose if the Spanish word is the correct or wrong translation for the displayed word.
The project is split into three milestones/deliverables.

## Dev Setup
`Clean, Build and Run! 😎`

## Dev Notes ##
**App Architecture:** `Model View View Model` is used for the Architecture with some ideas from [Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture).
* **Better Separation of Concerns** The view model translates the data of the model layer into something the view layer can use. The controller is no longer responsible for this task.
* **Improved Testability** View controllers are notoriously hard to test because of their relation to the view layer. By migrating data manipulation to the view model, testing becomes much easier.
* **Transparent Communication** The responsibilities of the view controller are reduced to controlling the interaction between the view layer and the model layer, glueing both layers together. The view model provides a transparant interface to the view controller, which it uses to populate the view layer and interact with the model layer. This results in a transparant communication between the four layers of the application.

**Technologies:** `Combine` and `SwiftUI` are used for handling the logic and the UI.

**Unit Testing:** `XCTest` is used for unit test.

## TODO List:
- [x] Game Logic.
- [x] Rules.
- [ ] End of the game.
