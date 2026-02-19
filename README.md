Scoped-Allowance-Vault

A secure, scope-based asset delegation smart contract built in **Clarity** for the **Stacks Blockchain**.

---

Overview

**Scoped-Allowance-Vault (SAV)** is a smart contract that enables granular delegation of asset spending permissions.

Instead of granting unlimited approvals, users can authorize specific principals or contracts to spend a limited amount of assets within clearly defined constraints such as:

- Spending caps
- Time limits
- Scope restrictions
- Function-level permissions

This model reduces risk exposure and improves capital safety in DeFi, DAO, and treasury environments.

---

Problem Statement

Traditional approval systems often rely on:

- Unlimited token approvals
- Weak delegation boundaries
- No expiration controls
- Poor allowance tracking

These practices introduce major security risks.

Scoped-Allowance-Vault solves this by enforcing deterministic, scope-based allowances that are:

- Limited
- Trackable
- Revocable
- Transparent
- Auditable

---

Architecture

Built With
- **Language:** Clarity
- **Blockchain:** Stacks
- **Framework:** Clarinet

Supported Assets
- Native STX
- Extendable to SIP-010 fungible tokens

---

Roles

1. Vault Owner
- Deposits funds into the vault
- Assigns scoped allowances
- Updates or revokes permissions

2. Delegate (Spender)
- Authorized to spend funds within defined scope
- Cannot exceed allowance limits

3. Admin (Optional)
- Manages system-wide configuration
- May enforce global constraints

---

Allowance Model

Each allowance may include:

- Authorized principal
- Maximum spending cap
- Remaining allowance balance
- Optional expiration block height
- Optional function-level scope restriction

Execution Flow

1. Owner deposits assets into the vault.
2. Owner assigns scoped allowance to a delegate.
3. Delegate executes spending within defined limits.
4. Contract verifies:
   - Remaining allowance
   - Time validity (if configured)
   - Scope restrictions
5. If valid → transaction proceeds.
6. Allowance state is updated deterministically.

---

Core Features

- Granular per-principal allowances
- Amount-based spending caps
- Optional time-based expiration
- Revocation and modification support
- Deterministic allowance tracking
- Transparent event logging
- Modular and integration-friendly design
- Clarinet-compatible structure

---

 Security Design Principles

- Explicit state accounting for allowances
- No unlimited approvals by default
- Controlled permission assignment
- Deterministic state transitions
- Minimal attack surface
- Audit-ready architecture
- Clear separation of owner and delegate authority

---


License

MIT License



 Development & Testing

1. Install Clarinet
Follow official Stacks documentation to install Clarinet.

2. Initialize Project
```bash
clarinet new scoped-allowance-vault
