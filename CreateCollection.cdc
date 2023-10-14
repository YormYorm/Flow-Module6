import CryptoPoops from 0x05

transaction() {
  prepare(signer: AuthAccount) {
    // Check if a collection already exists in the account's storage.
    if signer.borrow<&CryptoPoops.Collection>(from: /storage/CryptoPoopsCollection) != nil {
      log("A collection already exists.")
      return
    }

    // Create a new collection in the account's storage.
    signer.save(<- CryptoPoops.createEmptyCollection(), to: /storage/CryptoPoopsCollection)

    // Make it publicly accessible.
    signer.link<&CryptoPoops.Collection>(/public/CryptoPoopsCollection, target: /storage/CryptoPoopsCollection)

    log("Collection has been successfully created.")
  }
}

