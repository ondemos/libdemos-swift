  // swift-tools-version: 5.10
  // The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let package = Package(
  name: "LibDemos",
  products: [
    .library(
      name: "LibDemos",
      targets: ["LibDemos"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "Clibdemos",
      exclude: ["__tests__", "./libsodium/test"],
      sources: [
        "./src/demos.c",
        "./libsodium/src/libsodium/randombytes/randombytes.c",
        "./libsodium/src/libsodium/randombytes/sysrandom/randombytes_sysrandom.c",
        "./libsodium/src/libsodium/sodium/runtime.c",
        "./libsodium/src/libsodium/sodium/codecs.c",
        "./libsodium/src/libsodium/sodium/core.c",
        "./libsodium/src/libsodium/sodium/utils.c",
        "./libsodium/src/libsodium/crypto_aead/aegis128l/aead_aegis128l.c",
        "./libsodium/src/libsodium/crypto_aead/aegis128l/aegis128l_soft.c",
        "./libsodium/src/libsodium/crypto_aead/aegis128l/aegis128l_common.h",
        "./libsodium/src/libsodium/crypto_aead/aegis256/aead_aegis256.c",
        "./libsodium/src/libsodium/crypto_aead/aegis256/aegis256_soft.c",
        "./libsodium/src/libsodium/crypto_aead/aegis256/aegis256_common.h",
        "./libsodium/src/libsodium/crypto_auth/hmacsha512/auth_hmacsha512.c",
        "./libsodium/src/libsodium/crypto_hash/sha512/cp/hash_sha512_cp.c",
        "./libsodium/src/libsodium/crypto_core/ed25519/ref10/ed25519_ref10.c",
        "./libsodium/src/libsodium/crypto_core/salsa/ref/core_salsa_ref.c",
        "./libsodium/src/libsodium/crypto_core/softaes/softaes.c",
        "./libsodium/src/libsodium/crypto_sign/ed25519/ref10/keypair.c",
        "./libsodium/src/libsodium/crypto_sign/ed25519/ref10/open.c",
        "./libsodium/src/libsodium/crypto_sign/ed25519/ref10/sign.c",
        "./libsodium/src/libsodium/crypto_verify/verify.c",
        "./libsodium/src/libsodium/crypto_aead/chacha20poly1305/aead_chacha20poly1305.c",
        "./libsodium/src/libsodium/crypto_generichash/blake2b/ref/blake2b-compress-ref.c",
        "./libsodium/src/libsodium/crypto_generichash/blake2b/ref/blake2b-ref.c",
        "./libsodium/src/libsodium/crypto_generichash/blake2b/ref/generichash_blake2b.c",
        "./libsodium/src/libsodium/crypto_generichash/crypto_generichash.c",
        "./libsodium/src/libsodium/crypto_onetimeauth/poly1305/onetimeauth_poly1305.c",
        "./libsodium/src/libsodium/crypto_onetimeauth/poly1305/donna/poly1305_donna.c",
        "./libsodium/src/libsodium/crypto_stream/chacha20/ref/chacha20_ref.c",
        "./libsodium/src/libsodium/crypto_stream/chacha20/stream_chacha20.c",
        "./libsodium/src/libsodium/crypto_stream/salsa20/ref/salsa20_ref.c",
        "./libsodium/src/libsodium/crypto_stream/salsa20/stream_salsa20.c",
        "./libsodium/src/libsodium/crypto_kx/crypto_kx.c",
        "./libsodium/src/libsodium/crypto_scalarmult/crypto_scalarmult.c",
        "./libsodium/src/libsodium/crypto_scalarmult/curve25519/scalarmult_curve25519.c",
        "./libsodium/src/libsodium/crypto_scalarmult/curve25519/ref10/x25519_ref10.c",
        "./libsodium/src/libsodium/crypto_scalarmult/ed25519/ref10/scalarmult_ed25519_ref10.c",
        "./libsodium/src/libsodium/crypto_pwhash/argon2/argon2.c",
        "./libsodium/src/libsodium/crypto_pwhash/argon2/argon2-core.c",
        "./libsodium/src/libsodium/crypto_pwhash/argon2/argon2-encoding.c",
        "./libsodium/src/libsodium/crypto_pwhash/argon2/blake2b-long.c",
        "./libsodium/src/libsodium/crypto_pwhash/argon2/argon2-fill-block-ref.c",
        "./libsodium/src/libsodium/crypto_pwhash/argon2/pwhash_argon2id.c",
      ],
      publicHeadersPath: "./include",
      cSettings: [
        .headerSearchPath("./include"), // Path to main C library headers
        .headerSearchPath("./libsodium/src/libsodium/include"), // Path to submodule headers
        .headerSearchPath("./libsodium/src/libsodium/include/sodium"), // Path to submodule headers
        .headerSearchPath("./libsodium/src/libsodium/include/sodium/private"), // Path to submodule headers
        .headerSearchPath("../../Resources")
      ]),
    .target(
      name: "LibDemos",
      dependencies: ["Clibdemos"],
      resources: [
        .process("Resources")
      ]),
    .testTarget(
      name: "LibDemosTests",
      dependencies: ["LibDemos"]),
  ]
)
