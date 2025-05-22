# Toy Robot Simulator

## Overview

The Toy Robot Simulator is a command-line application that simulates the movement of a toy robot on a square tabletop. The core challenge involves parsing commands to control the robot, ensuring it moves within the defined boundaries of the tabletop (5x5 units) and responds appropriately to user instructions.

## Features

*   **5x5 Unit Tabletop**: The robot operates on a square tabletop of 5 units by 5 units.
*   **Command-Based Control**: The robot responds to the following commands:
    *   `PLACE X,Y,F`
    *   `MOVE`
    *   `LEFT`
    *   `RIGHT`
    *   `REPORT`
*   **Boundary Safety**: The robot is prevented from falling off the table. Any move that would result in the robot falling is ignored.
*   **Initial Placement Required**: The robot ignores all commands until a valid `PLACE` command has been executed.
*   **Interactive Mode**: Users can input commands directly to the simulator.
*   **File-Based Input Mode**: Commands can be read from a specified file.
*   **Informative Startup**: The interactive mode provides startup messages, rules, and a list of valid commands with colored output for better readability.
*   **EXIT Command**: Allows users to gracefully exit the interactive simulator.

## Setup and Prerequisites

*   **Ruby Version**: Developed and tested with Ruby 3.2.3. Other versions might work but are not guaranteed.
*   **Bundler**: Uses Bundler to manage Ruby gems. If you don't have Bundler, install it with:
    ```bash
    gem install bundler
    ```
*   **Install Dependencies**: Navigate to the project's root directory and run:
    ```bash
    bundle install
    ```

## Usage

### Interactive Mode

This mode allows you to type commands directly to the robot.

1.  **Start the simulator**:
    ```bash
    bin/toy_robot
    ```
2.  **Startup Messages**: Upon starting, you will see a welcome message, the rules of the simulation, and a list of valid commands.
3.  **Input Commands**: Enter commands one by one at the prompt. For example:
    ```
    PLACE 0,0,NORTH
    MOVE
    REPORT
    EXIT
    ```

### File Mode

This mode reads commands from a specified file.

1.  **Run the simulator with a filepath**:
    ```bash
    bin/toy_robot_from_file <filepath>
    ```
2.  **Example using the provided test file**:
    ```bash
    bin/toy_robot_from_file data/test_commands.txt
    ```
    The `data/test_commands.txt` file contains a predefined sequence of commands to test various functionalities.

## Commands

All commands are case-insensitive.

*   **`PLACE X,Y,F`**
    *   Places the robot on the table at coordinates (X,Y) and facing direction F.
    *   X and Y must be integers between 0 and 4 (inclusive).
    *   F must be one of `NORTH`, `SOUTH`, `EAST`, `WEST`.
    *   The origin (0,0) is considered the SOUTH-WEST corner of the table.
    *   This must be the first valid command issued.
    *   Example: `PLACE 0,0,NORTH`

*   **`MOVE`**
    *   Moves the robot one unit forward in the direction it is currently facing.
    *   If the move would cause the robot to fall off the table, the command is ignored.

*   **`LEFT`**
    *   Rotates the robot 90 degrees to the left (counter-clockwise) without changing its position.

*   **`RIGHT`**
    *   Rotates the robot 90 degrees to the right (clockwise) without changing its position.

*   **`REPORT`**
    *   Announces the current X, Y coordinates and direction of the robot in the format: `X,Y,DIRECTION`.
    *   Example output: `0,1,NORTH`

*   **`EXIT`**
    *   Quits the interactive simulator (`bin/toy_robot`).

## Development

### Running Tests

The project uses RSpec for testing.
*   **Execute the test suite**:
    ```bash
    bundle exec rspec
    ```
*   The suite includes over 100 tests covering all major functionalities of the robot and simulator.

### Code Style

RuboCop is used for maintaining code style consistency.
*   **Check for offenses**:
    ```bash
    bundle exec rubocop
    ```
*   **Auto-correct offenses (where possible)**:
    ```bash
    bundle exec rubocop -A
    ```

## Project Structure

*   `bin/`: Contains the executable scripts (`toy_robot`, `toy_robot_from_file`).
*   `lib/`: Contains the core application logic:
    *   `robot.rb`: Defines the `Robot` class, its movement, and placement logic.
    *   `simulator.rb`: Defines the `Simulator` class for parsing and processing commands.
    *   `table.rb`: Defines the `Table` class and its boundaries.
    *   `direction.rb`: Defines the `Direction` module for handling robot orientation and turns.
    *   `ui_helper.rb`: Provides helper methods for colored terminal output.
*   `spec/`: Contains RSpec unit and integration tests.
*   `data/`: Contains test data files, like `test_commands.txt`.
*   `Gemfile` & `Gemfile.lock`: Define Ruby dependencies managed by Bundler.

## License

This project is licensed under the MIT License.
