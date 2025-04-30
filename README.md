### STX-SafeBlocker : Blacklist Manager Contract

#### Overview
This contract is designed to manage a blacklist of addresses for a given blockchain network. The contract allows administrators to add and remove addresses from the blacklist, manage appeals, and handle administrative roles. It includes features for managing administrative permissions, tracking appeals, and dynamically updating the blacklist with various levels of restriction and expiry.

---

### Key Features
- **Blacklist Management**: Add and remove addresses from the blacklist with expiry and reason.
- **Appeal Process**: Blacklisted addresses can submit appeals, which can be processed by the administrators.
- **Admin Roles**: The contract allows for the management of admins, including the contract admin and backup admin.
- **Contract Activation**: The contract can be toggled between active and inactive states.
- **Expiry Management**: Blacklist entries have an expiry block height to automatically remove addresses after a set period.
- **Security**: Only authorized users (contract admin, backup admin, or other admins) can perform certain actions.

---

### Data Variables
- **contract-admin**: The main administrator of the contract.
- **backup-admin**: A secondary administrator who can manage the contract in the absence of the contract admin.
- **blacklisted-address-count**: A count of how many addresses are currently blacklisted.
- **is-contract-active**: Indicates whether the contract is active or not.
- **last-updated**: The block height when the contract was last updated.

---

### Data Maps
- **blacklisted-addresses**: Maps blacklisted addresses to metadata, including their status, timestamp, expiry, and blacklist level.
- **blacklisted-address-reasons**: Maps addresses to the reasons they were blacklisted.
- **admins**: Maps addresses to a boolean value indicating whether they are admins or not.
- **blacklist-appeals**: Maps addresses to their appeal status, including timestamps and reasons.

---

### Functions

#### Read-Only Functions
- **is-address-blacklisted**: Checks if an address is currently blacklisted.
- **get-blacklist-details**: Returns the details of a blacklisted address.
- **get-blacklist-reason-for-address**: Returns the reason an address was blacklisted.
- **get-total-blacklisted-address-count**: Returns the total count of blacklisted addresses.
- **is-admin**: Checks if an address is an admin.
- **get-appeal-status**: Returns the appeal status of an address.
- **get-contract-status**: Returns the contract's current status (active or inactive), the last update block height, and the total number of blacklisted addresses.

#### Private Functions
- **is-authorized**: Verifies if the sender is authorized to perform administrative actions (contract admin, backup admin, or regular admin).
- **calculate-expiry**: Calculates the expiry block height for blacklisted addresses.

#### Public Functions
- **set-contract-admin**: Changes the contract admin.
- **set-backup-admin**: Changes the backup admin.
- **add-admin**: Adds an address as an admin.
- **remove-admin**: Removes an address from the admin list.
- **add-address-to-blacklist**: Adds an address to the blacklist with a reason, blacklist level, and expiry.
- **remove-address-from-blacklist**: Removes an address from the blacklist.
- **submit-appeal**: Allows a blacklisted address to submit an appeal.
- **process-appeal**: Processes an appeal, either approving or rejecting it.
- **toggle-contract-status**: Toggles the contract between active and inactive states.
- **update-blacklist-expiry**: Updates the expiry time for a blacklisted address.
- **receive-stx**: Prevents STX transfers to the contract.

---

### Error Codes
- **ERR-NOT-AUTHORIZED**: The caller is not authorized to perform the operation.
- **ERR-ALREADY-BLACKLISTED**: The address is already blacklisted.
- **ERR-NOT-BLACKLISTED**: The address is not blacklisted.
- **ERR-INVALID-ARGUMENT**: Invalid arguments were provided.
- **ERR-BATCH-OPERATION-FAILED**: A batch operation failed.
- **ERR-ADMIN-ONLY**: The operation is restricted to admins only.
- **ERR-CANNOT-BLACKLIST-ADMIN**: Admins cannot be blacklisted.
- **ERR-INVALID-TIME**: The provided time is invalid.
- **ERR-EXPIRED-BLACKLIST**: The blacklist entry has expired.

---

### Example Usage

#### Adding an Address to the Blacklist:
```clojure
(add-address-to-blacklist "address-1" "Fraudulent activity" 3)
```

#### Removing an Address from the Blacklist:
```clojure
(remove-address-from-blacklist "address-1")
```

#### Submitting an Appeal:
```clojure
(submit-appeal "I did not commit any fraudulent activities.")
```

#### Processing an Appeal:
```clojure
(process-appeal "address-1" true) ;; Approve
```

---
