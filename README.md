# 🔗 Blockchain Audit Layer (AuditRegistry)

## 📌 Overview

This module implements a **lightweight blockchain-based audit layer** for the grievance system.
Instead of storing full complaint data on-chain, we store **cryptographic proofs** to ensure:

* ✅ Data integrity
* ✅ Transparency
* ✅ Tamper-proof audit trail

The smart contract is deployed on **Sepolia Testnet**.

---

## 🧠 Design Philosophy

> **Blockchain is used as a verification layer, not a storage layer.**

* Full complaint data → stored off-chain (GitHub / backend)
* Only proof (hash + metadata) → stored on-chain

---

## 🧩 On-Chain Data Model

Each record contains:

| Field       | Type    | Description                       |
| ----------- | ------- | --------------------------------- |
| `recordId`  | uint256 | Unique index (auto-incremented)   |
| `dataHash`  | bytes32 | Hash of complaint JSON            |
| `commitId`  | string  | Git commit ID (version reference) |
| `sender`    | address | Wallet that submitted the record  |
| `timestamp` | uint256 | Block timestamp                   |

---

## ⚙️ Smart Contract

### Contract Name

`AuditRegistry`

### Core Functions

#### ➤ Store Record

```solidity
storeRecord(bytes32 _dataHash, string memory _commitId)
```

Stores a new audit entry on-chain.

---

#### ➤ Fetch Record

```solidity
getRecord(uint256 _id)
```

Returns stored data for a given record ID.

---

#### ➤ Search Functions

* `findByCommitId()` → locate record via commit ID (linear search)
* `findByTimestamp()` → find record by exact timestamp
* `findByTimeRange()` → retrieve records within a time window

---

## 🔁 System Flow

```text
Complaint Created
      ↓
Stored as JSON (GitHub)
      ↓
Hash Generated (SHA256 / keccak256)
      ↓
Smart Contract stores:
    hash + commitId + metadata
      ↓
Later Verification:
    Fetch JSON → Recompute hash → Compare with blockchain
```

---

## 🔐 Verification Logic

1. Fetch `commitId` and `recordId` from backend
2. Retrieve stored hash from blockchain
3. Fetch JSON using commitId
4. Recompute hash
5. Compare:

```text
if (recomputedHash == onChainHash)
    → VALID ✅
else
    → TAMPERED ❌
```

---

## 🚀 Why This Approach?

### ❌ Not storing full data on-chain

* High gas cost
* Not scalable

### ✅ Storing hash only

* Cheap
* Efficient
* Secure

---

## 🧠 Architecture

```text
Frontend
   ↓
Backend DB → commitId ↔ recordId
   ↓
Blockchain → recordId → hash + sender + timestamp
   ↓
GitHub → commitId → full complaint JSON
```

---

## ⚠️ Notes

* `bytes32` hashes must be:

  * prefixed with `0x`
  * exactly 64 hex characters (66 total length)
* Commit IDs are treated as unique identifiers
* Blockchain is **not used for querying large datasets**

---

## 💡 Key Features

* 🔒 Tamper-proof audit trail
* 📜 Version tracking via commit IDs
* 👤 Accountability via wallet address
* ⏱ Time-based traceability
* ⚡ Gas-efficient design

---

## 🧪 Example Record

```json
{
  "recordId": 1,
  "dataHash": "0x5e884898da28047151d0e56f8dc6292773603d0d6aabbdd38a5e2c4f2a1d6cbb",
  "commitId": "a1b2c3d4e5",
  "sender": "0xAbC123...",
  "timestamp": 1719900000
}
```

---

## 🏁 Conclusion

This module ensures that:

> **Every complaint and its processing lifecycle can be independently verified and trusted.**

By combining off-chain storage with on-chain verification, we achieve:

* Scalability
* Cost efficiency
* Strong data integrity

---

## 📎 Future Enhancements

* Merkle tree batching for multiple records
* Role-based access control (officers only)
* Event-based indexing for analytics
* Automated CI-based verification

---
