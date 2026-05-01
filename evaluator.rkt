#lang sicp

;; =========================
;; BASIC EXPRESSION TYPES
;; =========================

(define (self-evaluating? exp)
  (or (number? exp)
      (string? exp)
      (boolean? exp)))

(define false #f)

(define (let? exp)
  (tagged-list? exp 'let))

(define (variable? exp)
  (symbol? exp))

(define (quoted? exp)
  (tagged-list? exp 'quote))

(define (text-of-quotation exp)
  (cadr exp))

(define (assignment? exp)
  (tagged-list? exp 'set!))

(define (definition? exp)
  (tagged-list? exp 'define))

(define (if? exp)
  (tagged-list? exp 'if))

(define (lambda? exp)
  (tagged-list? exp 'lambda))

(define (begin? exp)
  (tagged-list? exp 'begin))

(define (application? exp)
  (pair? exp))

(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (begin-actions exp) (cdr exp))

;; =========================
;; LET SUPPORT (TASK 4)
;; =========================

(define (let-bindings exp)
  (cadr exp))

(define (let-body exp)
  (cddr exp))

(define (let-vars exp)
  (map car (let-bindings exp)))

(define (let-vals exp)
  (map cadr (let-bindings exp)))

(define (let->combination exp)
  (cons (cons 'lambda
              (cons (let-vars exp)
                    (let-body exp)))
        (let-vals exp)))

;; =========================
;; EVALUATOR CORE
;; =========================

(define (mini-eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((let? exp)
         (mini-eval (let->combination exp) env))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
        ((begin? exp)
         (eval-sequence (begin-actions exp) env))
        ((application? exp)
         (mini-apply (mini-eval (operator exp) env)
                     (list-of-values (operands exp) env)))
        (else (error "Unknown expression type -- EVAL" exp))))

(define (list-of-values exps env)
  (if (null? exps)
      '()
      (cons (mini-eval (car exps) env)
            (list-of-values (cdr exps) env))))

;; =========================
;; PROCEDURE APPLICATION
;; =========================

(define (mini-apply procedure arguments)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure procedure arguments))
        ((compound-procedure? procedure)
         (eval-sequence
          (procedure-body procedure)
          (extend-environment
           (procedure-parameters procedure)
           arguments
           (procedure-environment procedure))))
        (else
         (error "Unknown procedure type -- APPLY" procedure))))

;; =========================
;; PROCEDURES
;; =========================

(define (make-procedure parameters body env)
  (list 'procedure parameters body env))

(define (compound-procedure? p)
  (tagged-list? p 'procedure))

(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))

;; =========================
;; PRIMITIVES
;; =========================

(define (make-primitive proc)
  (list 'primitive proc))

(define primitive-procedures
  (list
   (list '+ +)
   (list '- -)
   (list '* *)
   (list '/ /)
   (list '= =)))

(define (primitive-procedure-names)
  (map car primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (p)
         (make-primitive (cadr p)))
       primitive-procedures))

(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))

(define (primitive-implementation proc)
  (cadr proc))

(define (apply-primitive-procedure proc args)
  (apply (primitive-implementation proc) args))

;; =========================
;; ENVIRONMENT (RIBCAGE)
;; =========================

(define (make-frame vars vals)
  (cons vars vals))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (error "Arguments mismatch -- EXTEND-ENVIRONMENT" vars vals)))

(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))

;; =========================
;; LOOKUP
;; =========================

(define (lookup-variable-value var env)
  (define (env-loop env)
    (if (null? env)
        (error "Unbound variable" var)
        (scan (frame-variables (car env))
              (frame-values (car env))
              (cdr env))))

  (define (scan vars vals rest-env)
    (cond ((null? vars)
           (env-loop rest-env))
          ((eq? var (car vars))
           (car vals))
          (else
           (scan (cdr vars) (cdr vals) rest-env))))

  (env-loop env))

;; =========================
;; ASSIGNMENT / DEFINITION
;; =========================

(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

(define (eval-assignment exp env)
  (set-variable-value!
   (assignment-variable exp)
   (mini-eval (assignment-value exp) env)
   env)
  'ok)

(define (set-variable-value! var val env)
  (define (env-loop env)
    (if (null? env)
        (error "Unbound variable -- SET!" var)
        (scan (frame-variables (car env))
              (frame-values (car env))
              (cdr env))))

  (define (scan vars vals rest-env)
    (cond ((null? vars)
           (env-loop rest-env))
          ((eq? var (car vars))
           (set-car! vals val))
          (else
           (scan (cdr vars) (cdr vals) rest-env))))

  (env-loop env))

(define (definition-variable exp) (cadr exp))
(define (definition-value exp) (caddr exp))

(define (eval-definition exp env)
  (define-variable!
   (definition-variable exp)
   (mini-eval (definition-value exp) env)
   env)
  'ok)

(define (define-variable! var val env)
  (let ((frame (car env)))
    (let loop ((vars (car frame))
               (vals (cdr frame)))
      (cond ((null? vars)
             (set-car! frame (cons var (car frame)))
             (set-cdr! frame (cons val (cdr frame))))
            ((eq? var (car vars))
             (set-car! vals val))
            (else
             (loop (cdr vars) (cdr vals)))))))

;; =========================
;; IF + SEQUENCES
;; =========================

(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      false))  ;; FIXED

(define (eval-if exp env)
  (if (true? (mini-eval (if-predicate exp) env))
      (mini-eval (if-consequent exp) env)
      (mini-eval (if-alternative exp) env)))

(define (true? x)
  (not (eq? x false)))

(define (eval-sequence exps env)
  (cond ((null? (cdr exps))
         (mini-eval (car exps) env))
        (else
         (mini-eval (car exps) env)
         (eval-sequence (cdr exps) env))))

;; =========================
;; HELPERS
;; =========================

(define (tagged-list? exp tag)
  (and (pair? exp)
       (eq? (car exp) tag)))

;; =========================
;; GLOBAL ENVIRONMENT
;; =========================

(define the-empty-environment '())

(define the-global-environment
  (extend-environment
   (primitive-procedure-names)
   (primitive-procedure-objects)
   the-empty-environment))

(eval-definition '(define true #t) the-global-environment)
(eval-definition '(define false #f) the-global-environment)

;; =========================
;; TESTS (FINAL VERIFICATION)
;; =========================

(display "Basic arithmetic:\n")
(display (mini-eval '(+ 2 3) the-global-environment)) (newline)

(display "Let expression:\n")
(display (mini-eval '(let ((x 5)) (+ x 3)) the-global-environment)) (newline)

(display "Lexical scoping test (make-adder):\n")
(display
 (mini-eval
  '(begin
     (define (make-adder x)
       (lambda (y) (+ x y)))
     (define add5 (make-adder 5))
     (add5 10))
  the-global-environment))
(newline)

(display "Argument mismatch test (should error):\n")
(mini-eval
 '((lambda (x y) (+ x y)) 5)
 the-global-environment)

;; =========================
;; SIMPLE REPL (Driver Loop)
;; =========================

(define (driver-loop)
  (display "\nMini-Scheme REPL\n")
  (display "Type 'exit to quit\n")
  (newline)
  (let loop ()
    (display ">>> ")
    (let ((input (read)))
      (if (eq? input 'exit)
          (display "Goodbye!\n")
          (begin
            (display (mini-eval input the-global-environment))
            (newline)
            (loop))))))

;; To start REPL, call:
;; (driver-loop)