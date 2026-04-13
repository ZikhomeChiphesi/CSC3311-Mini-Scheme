#lang sicp
#lang sicp

;; ====================================================
;; CSC3311 MINI-SCHEME EVALUATOR SKELETON
;; ====================================================

;; THE BRAIN: Team A & D
(define (mini-eval exp env)
  (cond ((number? exp) exp)
        ;; Add more cases here (Team A)
        (else (error "Unknown expression type -- MINI-EVAL" exp))))

;; THE HANDS: Team A
(define (mini-apply procedure arguments)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure procedure arguments))
        ;; Add compound procedure logic here
        (else (error "Unknown procedure type -- MINI-APPLY" procedure))))

;; THE MEMORY: Team B
(define (extend-environment vars vals base-env)
  'todo-team-b)

;; THE WORLD: Team C
(define the-global-environment '()) 

;; ====================================================
;; HELPER FUNCTIONS (To be filled)
;; ====================================================
(define (primitive-procedure? proc) (tagged-list? proc 'primitive))
(define (tagged-list? exp tag) (if (pair? exp) (eq? (car exp) tag) false))