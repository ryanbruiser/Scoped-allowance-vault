;; =====================================================
;; ScopedAllowanceVault
;; Contract-scoped allowance treasury vault
;; =====================================================

;; -----------------------------
;; Data Variables
;; -----------------------------

(define-data-var admin principal tx-sender)

;; -----------------------------
;; Data Maps
;; -----------------------------

;; authorized contract => allowance data
(define-map allowances
  principal
  {
    remaining: uint,
    expires-at: uint
  }
)

;; -----------------------------
;; Errors
;; -----------------------------

(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-NO-ALLOWANCE u101)
(define-constant ERR-INSUFFICIENT-ALLOWANCE u102)
(define-constant ERR-EXPIRED u103)
(define-constant ERR-INVALID-AMOUNT u104)

;; -----------------------------
;; Helpers
;; -----------------------------

(define-read-only (is-admin)
  (is-eq tx-sender (var-get admin))
)

;; -----------------------------
;; Deposit STX into Vault
;; -----------------------------

(define-public (deposit (amount uint))
  (begin
    (asserts! (> amount u0) (err ERR-INVALID-AMOUNT))

    (match (stx-transfer?
      amount
      tx-sender
      (as-contract tx-sender)
    )
      success (ok true)
      failure (err failure)
    )
  )
)

;; -----------------------------
;; Grant Allowance
;; -----------------------------

(define-public (grant-allowance
  (contract principal)
  (amount uint)
  (duration uint)
)
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (> amount u0) (err ERR-INVALID-AMOUNT))

    (let ((expiry (+ stacks-block-height duration)))
      (map-set allowances contract {
        remaining: amount,
        expires-at: expiry
      })

      (ok true)
    )
  )
)

;; -----------------------------
;; Revoke Allowance
;; -----------------------------

(define-public (revoke-allowance (contract principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (map-delete allowances contract)
    (ok true)
  )
)

;; -----------------------------
;; Withdraw by Authorized Contract
;; -----------------------------

(define-public (withdraw (amount uint))
  (let ((allowance (map-get? allowances tx-sender)))
    (match allowance data
      (begin
        (asserts! (> amount u0) (err ERR-INVALID-AMOUNT))
        (asserts! (>= stacks-block-height (get expires-at data)) (err ERR-EXPIRED))
        (asserts! (< stacks-block-height (get expires-at data)) (err ERR-EXPIRED))
        (asserts! (>= (get remaining data) amount) (err ERR-INSUFFICIENT-ALLOWANCE))

        ;; Update state first
        (map-set allowances tx-sender {
          remaining: (- (get remaining data) amount),
          expires-at: (get expires-at data)
        })

        (stx-transfer?
          amount
          (as-contract tx-sender)
          tx-sender
        )
      )
      (err ERR-NO-ALLOWANCE)
    )
  )
)

;; -----------------------------
;; Read-only Views
;; -----------------------------

(define-read-only (get-allowance (contract principal))
  (map-get? allowances contract)
)
