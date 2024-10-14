# SwiftSkeleton

SwiftSkeleton is a mobile app skeleton generator in Swift using the MVP architecture and Coordinators for navigation management. It allows you to quickly generate the foundation of your app from a lightweight JSON file.

## Features

- Automatic generation of modules (ViewController, Presenter, Storyboard, Builder, Contract) for each screen.
- Navigation flow management via Coordinators.
- Simplified MVP architecture for better separation of concerns.
- Code generation based on a JSON configuration file.

## Requirements

- [Swift](https://swift.org/getting-started/) 5.7 or higher.
- Swift Package Manager (SPM).

## Installation

1. Clone this GitHub repository:

    ```bash
    git clone https://github.com/squall09s/SwiftSkeleton.git
    ```

2. Navigate to the project directory:

    ```bash
    cd SwiftSkeleton
    ```

3. Build the application in release mode:

    ```bash
    swift build --configuration release
    ```

## Usage

Once the project is compiled, you can run SwiftSkeleton from the command line to generate your app skeleton. The tool accepts a JSON file as an argument, which defines the structure of your project.

Example command:

    ```bash
    .build/release/SwiftSkeleton path/to/your-json-file.json
     ```
    
## Generated Structure

For each module, SwiftSkeleton automatically generates the following:

    •    ViewController: The user interface controller for the screen.
    •    Presenter: Manages the presentation logic.
    •    Storyboard: User interface file for the screen.
    •    Builder: Initializes the module.
    •    Contract: Defines the protocols linking the View and Presenter.


### Contributing

Contributions are welcome! 

### License

This project is licensed under the MIT License. See the LICENSE file for details.
