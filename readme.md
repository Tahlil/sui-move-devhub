# SUI Devhub project

### Prerequisite

Before you begin, ensure you have met the following requirements:

- **Operating System**: You're running Windows 10, MacOS (10.15 or later), or any modern Linux distribution.
- **Node.js**: You have installed Node.js version 14.0 or later.
- **npm**: You have installed npm version 6.0 or later (usually comes with Node.js).
- **Git**: You have installed Git version 2.20 or later.
- **SUI CLI**: Install [SUI CLI](https://docs.sui.io/references/cli)

### Run the project
- To build the project run the following the command:
```
sudo sui move build --skip-fetch-latest-git-deps
```
- To publish in the contract in devnet:
```
sui client publish --gas-budget 20000000 . --skip-fetch-latest-git-deps
```
