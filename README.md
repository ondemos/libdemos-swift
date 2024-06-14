# LibDemos

This repository provides cryptographic tools for digital democracies in a SwiftPM package.

It follows the API of the TS package [@ondemos/core](https://github.com/ondemos/libdemos-ts).

The code has not undergone any external security audits yet. Use at your own risk.

## Functionality

This library relies heavily on Ed25519 public-secret key pairs and their related operations, which are provided by [libsodium](https://github.com/jedisct1/libsodium), which is a battle-tested project.
We import the [c-libdemos](https://github.com/ondemos/libdemos) library for the functionality that is not provided by CryptoKit and as a fallback in case CryptoKit is not available in the platform.

In the [LibDemos](Sources/LibDemos) folder, there are functions that enable private liquid democracy according to [this paper](https://arxiv.org/pdf/2302.14421). There is an example in the [Tests](Tests) folder.

There is [Shamir secret sharing](https://en.wikipedia.org/wiki/Shamir%27s_secret_sharing) functionality in the [Shamir](Sources/LibDemos/Shamir) folder, where a user can split and restore a secret through the Shamir threshold sharing scheme. 

The library also has mnemonic generation, validation and Ed25519 key pair from mnemonic functionality that was inspired by [bip39](https://github.com/bitcoinjs/bip39) but instead of Blake2b we use Argon2 and instead of SHA256 we use SHA512.

Finally, you can calculate [Merkle roots](https://en.wikipedia.org/wiki/Merkle_tree), proofs and validate proofs from trees. The relevant functionality is in the [Merkle](Sources/LibDemos/Merkle) folder. 

## License

The source code is licensed under the terms of the Affero General Public License version 3.0 (see [LICENSE](LICENSE)).

## Copyright

Copyright (C) 2024 Deliberative Technologies P.C.
