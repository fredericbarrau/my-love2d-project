# Pong, made with Love

This is a simple Love2D project for playing around the Love 2D framework. It is a simple implementation of the classic game Pong.

## Project Structure

- `main.lua`: The main entry point of the game.
- `conf.lua`: Configuration file for Love2D settings.
- `assets`: Directory for game assets like fonts, sounds, and images.
- `src/entities/player.lua`: Defines the player entity.
- `src/scenes/game.lua`: Manages the game scene.

## How to Run

1. Install Love2D from https://love2d.org/
2. Navigate to the project directory in your terminal.
3. Run the command `make run` to start the game.

Please ensure you have Love2D installed and correctly set up in your PATH before running the game.

## Build the Game

To build the game, you can use the `love-release` tool. Install it using the command `luarocks install love-release`. Then, run the command `love-release -D` to build the game for your platform.

## Build the Game to HTLM5

To build the game to HTML5, you can use the [love.js](https://github.com/Davidobot/love.js) tool. Install it using the command `npm install -g love.js`.
Then:

```bash
make build
```

This will create a `build` directory with the HTML5 version of the game.

To run it using a Docker container, you can use the following command:

```bash
make docker-build
```

Then, open your browser and navigate to `http://localhost:8080/` to play the game.