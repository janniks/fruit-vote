;; constants
(define-constant INVALID-INPUT (err u100))

;; apple emoji  == u"\u{e345}"
;; orange emoji == u"\u{e346}"
(define-constant VOTE-OPTIONS (list u"\u{e345}" u"\u{e346}"))

;; the votes map stores which principals have voted for u"\u{e345}" (true) or u"\u{e346}" (false)
(define-map votes principal bool)
;; the votes-count map stores the respective total vote count
(define-map votes-count bool uint)

(define-private (is-apple (str (string-utf8 1)))
  (is-eq str u"\u{e345}")
)

;; initialize vote counts to zero, before anybody voted
(define-private (initialize-votes-count)
  (begin
    (map-insert votes-count true u0)
    (map-insert votes-count false u0)
  )
)

;; main vote function
(define-public (vote (pick (string-utf8 1)))
  (begin
    ;; ensure that the passed pick is in VOTE-OPTIONS list
    (asserts! (is-some (index-of VOTE-OPTIONS pick)) INVALID-INPUT)

    ;; ensure that votes-count has been initialized
    (if (is-none (map-get? votes-count true)) (initialize-votes-count) true)

    ;; check if tx-sender is in existing votes
    (let ((some-vote (map-get? votes tx-sender)) (pick-bool (is-apple pick)))
      (if (is-none some-vote)
        ;; tx-sender never voted yet (some-vote is none)
        ;; add vote and update total count
        (begin
          (map-insert votes tx-sender pick-bool)
          (map-set votes-count pick-bool (+ (unwrap-panic (map-get? votes-count pick-bool)) u1))
        )

        ;; tx-sender already voted before (some-vote is some)
        ;; check if pick is the same as previous vote
        (if (is-eq pick-bool (unwrap-panic some-vote))
          ;; is the same, don't do anything
          true

          ;; is different, only change recorded vote
          (map-set votes tx-sender pick-bool)
        )
      )
    )

    (ok true)
  )
)
