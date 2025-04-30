;; Blacklist Manager Contract

;; Error Codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ALREADY-BLACKLISTED (err u101))
(define-constant ERR-NOT-BLACKLISTED (err u102))
(define-constant ERR-INVALID-ARGUMENT (err u103))
(define-constant ERR-BATCH-OPERATION-FAILED (err u104))
(define-constant ERR-ADMIN-ONLY (err u105))
(define-constant ERR-CANNOT-BLACKLIST-ADMIN (err u106))
(define-constant ERR-INVALID-TIME (err u107))
(define-constant ERR-EXPIRED-BLACKLIST (err u108))

;; Data Variables
(define-data-var contract-admin principal tx-sender)
(define-data-var backup-admin principal tx-sender)
(define-data-var blacklisted-address-count uint u0)
(define-data-var is-contract-active bool true)
(define-data-var last-updated uint block-height)

;; Maps
(define-map blacklisted-addresses principal 
  {
    is-blacklisted: bool,
    timestamp: uint,
    expiry: uint,
    blacklist-level: uint
  })
(define-map blacklisted-address-reasons principal (string-utf8 500))
(define-map admins principal bool)
(define-map blacklist-appeals principal 
  {
    status: (string-utf8 20),
    appeal-timestamp: uint,
    appeal-reason: (string-utf8 500)
  })

;; Read-Only Functions
(define-read-only (is-address-blacklisted (address principal))
  (match (map-get? blacklisted-addresses address)
    entry (and 
            (get is-blacklisted entry)
            (> (get expiry entry) block-height))
    false))

(define-read-only (get-blacklist-details (address principal))
  (map-get? blacklisted-addresses address))

(define-read-only (get-blacklist-reason-for-address (address principal))
  (default-to u"" (map-get? blacklisted-address-reasons address)))

(define-read-only (get-total-blacklisted-address-count)
  (var-get blacklisted-address-count))

(define-read-only (is-admin (address principal))
  (default-to false (map-get? admins address)))

(define-read-only (get-appeal-status (address principal))
  (map-get? blacklist-appeals address))

(define-read-only (get-contract-status)
  {
    is-active: (var-get is-contract-active),
    last-updated: (var-get last-updated),
    total-blacklisted: (var-get blacklisted-address-count)
  })

;; Private Functions
(define-private (is-authorized)
  (or (is-eq tx-sender (var-get contract-admin))
      (is-eq tx-sender (var-get backup-admin))
      (is-admin tx-sender)))

(define-private (calculate-expiry (expiry-blocks (optional uint)))
  (default-to (+ block-height u1000) expiry-blocks))

;; Public Functions
(define-public (set-contract-admin (new-admin principal))
  (begin 
    (asserts! (is-eq tx-sender (var-get contract-admin)) ERR-NOT-AUTHORIZED)
    (asserts! (not (is-eq new-admin (var-get contract-admin))) ERR-INVALID-ARGUMENT)
    (var-set contract-admin new-admin)
    (map-set admins new-admin true)
    (ok true)))

(define-public (set-backup-admin (new-backup-admin principal))
  (begin 
    (asserts! (is-eq tx-sender (var-get contract-admin)) ERR-NOT-AUTHORIZED)
    (asserts! (not (is-eq new-backup-admin (var-get backup-admin))) ERR-INVALID-ARGUMENT)
    (var-set backup-admin new-backup-admin)
    (map-set admins new-backup-admin true)
    (ok true)))

(define-public (add-admin (address principal))
  (begin 
    (asserts! (is-authorized) ERR-NOT-AUTHORIZED)
    (asserts! (not (is-admin address)) ERR-ALREADY-BLACKLISTED)
    (map-set admins address true)
    (ok true)))
