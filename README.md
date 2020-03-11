# tezos-pascaligo-vote 🗳️
Simple Smart Contract for voting 🗳️, written in PascaLIGO, for Tezos DLT Blockchain ߷⛓️.

## Goals:
Write a smart voting contract (in LIGO):
+ 2 vote options possible ("yes" ✔️ or "no" ⛔)
+ any user has the right to vote 👩‍👩‍👧‍👦
+ a user can only vote once 📌
+ the administrator is defined during the deployment of the smart contract 🤴
    + the administrator does not have the right to vote 🙅
+ the smart contract is paused if at least 10 people have voted
    + when the smart contract is paused, the result of the vote must be available (the result is stored in the storage of the smart contract) 💾
    + an administrator must be able to reset all votes (and remove the pause => make it active again) 🔁
+ the smart contract should have unit tests 📋🧪

## Usage:
First, make sure you have LIGO installed and correctly set up.
+ [LIGO Lang - Installation](https://ligolang.org/docs/intro/installation/)

Then, copy the contents of this repo and compile, dry-run, and deploy the contract `pascaligoTest.ligo` :

```
ligo compile-contract pascaligoTest.ligo main
ligo dry-run pascaligoTest.ligo main "Decrement(2)" 8
ligo dry-run pascaligoTest.ligo main "Increment(2)" 5
```

## Known Issues:


## Contributing:
Pull requests are always welcome 🤓, though keep in mind this smart contract is more for learning purposes than for commercial use.

For bug fixes or improvements, please open an issue and I will get back to you as soon as I can! 🔜

## License
Please cite the author [Charaf ZELLOU](https://linkedin.com/in/charafzellou/) and the source [tezos-pascaligo-vote repository](https://github.com/charafzellou/tezos-pascaligo-vote) in any copies, forks or use of the material in this repository.

[GNU Affero General Public License v3.0](https://choosealicense.com/licenses/agpl-3.0/) 🥐