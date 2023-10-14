/**

## The Flow Non-Fungible Token standard

## `NonFungibleToken` contract interface

The interface that all non-fungible token contracts could conform to.
If a user wants to deploy a new nft contract, their contract would need
to implement the NonFungibleToken interface.

Their contract would have to follow all the rules and naming
that the interface specifies.

## `NFT` resource

The core resource type that represents an NFT in the smart contract.

## `Collection` Resource

The resource that stores a user's NFT collection.
It includes a few functions to allow the owner to easily
move tokens in and out of the collection.

## `Provider` and `Receiver` resource interfaces

These interfaces declare functions with some pre and post conditions
that require the Collection to follow certain naming and behavior standards.

They are separate because it gives the user the ability to share a reference
to their Collection that only exposes the fields and functions in one or more
of the interfaces. It also gives users the ability to make custom resources
that implement these interfaces to do various things with the tokens.

By using resources and interfaces, users of NFT smart contracts can send
and receive tokens peer-to-peer, without having to interact with a central ledger
smart contract.

To send an NFT to another user, a user would simply withdraw the NFT
from their Collection, then call the deposit function on another user's
Collection to complete the transfer.

*/

// Interface for Non-Fungible Token contracts

pub contract interface NonFungibleToken {

    // Total number of tokens in existence
    pub var totalSupply: UInt64

    // Event emitted on contract initialization
    pub event ContractInitialized()

    // Event emitted when a token is withdrawn
    pub event Withdraw(id: UInt64, from: Address?)

    // Event emitted when a token is deposited
    pub event Deposit(id: UInt64, to: Address?)

    // Interface for NFT resource
    pub resource interface INFT {
        pub let id: UInt64
    }

    // Requirement for NFT contracts to define a resource called NFT conforming to INFT
    pub resource NFT: INFT {
        pub let id: UInt64
    }

    // Interface for withdrawing from a collection
    pub resource interface Provider {
        pub fun withdraw(withdrawID: UInt64): @NFT {
            post {
                result.id == withdrawID: "The ID of the withdrawn token must match the requested ID"
            }
        }
    }

    // Interface for depositing to a collection
    pub resource interface Receiver {
        pub fun deposit(token: @NFT)
    }

    // Interface for public collection methods
    pub resource interface CollectionPublic {
        pub fun deposit(token: @NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NFT
    }

    // Concrete resource type for implementing collection
    pub resource Collection: Provider, Receiver, CollectionPublic {

        // Dictionary to hold NFTs
        pub var ownedNFTs: @{UInt64: NFT}

        // Withdraw NFT from the collection
        pub fun withdraw(withdrawID: UInt64): @NFT

        // Deposit NFT to the collection
        pub fun deposit(token: @NFT)

        // Get array of IDs in the collection
        pub fun getIDs(): [UInt64]

        // Borrow reference to NFT in the collection
        pub fun borrowNFT(id: UInt64): &NFT {
            pre {
                self.ownedNFTs[id] != nil: "NFT does not exist in the collection!"
            }
        }
    }

    // Create an empty collection
    pub fun createEmptyCollection(): @Collection {
        post {
            result.getIDs().length == 0: "The created collection must be empty!"
        }
    }
}