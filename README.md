**CSC3311 — Mini-Scheme Evaluator**
SICP Laboratory Practical Submission

**Group Members**
1. Zikhome Mphatso Chiphesi - 2023140048
2. Franco Mwiinga - 2023055491
3. Sunduzwayo Ngoma - 2023087805
4. Emely Mangisha - 2023102162
5. Lozindahba Moyo - 2023013283
6. Memory Mupotola - 2023038111
7. Samuel Musonda - 2023001285

## Verification Questions — Model Answers

### 1. In the `add5` call, where is the value of `x` stored?

The value of `x` is stored in the **environment frame created when the procedure `(make-adder x)` is evaluated**.

When `make-adder` is called, it creates a **compound procedure** that captures its defining environment. This environment contains a frame where `x` is bound to its value (e.g., `5`).

When `(add5 10)` is later evaluated:

* A new frame is created for parameter `y`
* The procedure still has access to the **captured environment where `x = 5`**
* This is what enables **lexical scoping**

Therefore, `x` is stored in the **closure environment of the returned procedure**.


### 2. What happens in your environment if you try to `(set! z 10)` before defining `z`?

The evaluator will raise an error:

```
Unbound variable -- SET!
```

This happens because `set!` does not create new variables. It only modifies **existing bindings** in the environment.

The evaluator searches all frames in the environment chain:

* If `z` is not found in any frame → an error is thrown
* This enforces strict variable binding rules

Therefore, attempting to assign to an undefined variable results in an **unbound variable error**.


###  3. Modify your `eval-if` to support a “one-armed if” (optional else clause)

The evaluator already supports a **one-armed if** through the following implementation:

(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      false))

### Behaviour:

* If an `else` clause is provided → it is evaluated normally
* If no `else` clause exists → the expression evaluates to `false`

#### Example:

(if (> 5 3)
    10)

Result: `10`

(if (< 5 3)
    10)

Result: `false`


#### Summary

The evaluator correctly supports:

* Optional else clauses in conditionals
* Strict variable binding rules (`set!`)
* Lexical scoping via closure environments

These behaviors demonstrate correct implementation of core SICP evaluation principles.

**Author**
Zikhome Chiphesi

  **Project Overview**
  This project implements a Mini-Scheme evaluator in Racket using #lang sicp, based on concepts from Structure and Interpretation of Computer Programs (SICP), Chapter 4.1.
The evaluator models the eval–apply cycle, supports lexical scoping, and implements a frame-based environment system, enabling the execution of core Scheme expressions.

  **Features Implemented**
   1) _Core Evaluator (mini-eval)_
The evaluator acts as a dispatcher that classifies and processes expressions. It supports:
- Self-evaluating expressions (numbers, strings, booleans)
- Variable lookup
- Quoted expressions (quote)
- Assignment (set!)
- Definitions (define)
- Conditionals (if, including one-armed if)
- Lambda expressions (lambda)
- Sequences (begin)
- Procedure applications

  2) _Apply Mechanism (mini-apply)_
Handles procedure execution by distinguishing between:
- Primitive procedures (e.g. +, -, *, /, =)
- Compound procedures (user-defined functions)
Ensures correct environment extension during function calls.

 **Environment Model**
Implements a ribcage (frame-based) environment structure:
- extend-environment for creating new frames
- Variable lookup across environment chains
- Variable mutation (set!)
- Definition and binding (define)
- Fully supports lexical scoping, where procedures retain access to the environment in which they were defined.

  **Derived Expressions (Syntactic Sugar)**
  let expressions are implemented as derived expressions and internally transformed into lambda applications:
(let ((x 5)) (+ x 3))
⟶ ((lambda (x) (+ x 3)) 5)
This simplifies the evaluator by reducing complexity in the core logic.

  **Global Environment**
  The evaluator initializes a global environment containing:
- Primitive operations: +, -, *, /, =
- Boolean constants:
true → #t
false → #f

  **Test Cases**
   1) _Arithmetic_
(mini-eval '(+ 2 3) the-global-environment)
;; ⇒ 5
   
   2) _Let Expression_
(mini-eval '(let ((x 5)) (+ x 3)) the-global-environment)
;; ⇒ 8

   3) _Multiple Bindings_
(mini-eval '(let ((x 2) (y 3)) (* x y)) the-global-environment)
;; ⇒ 6

   4) _Lexical Scoping (Closure Test)_
(mini-eval
 '(begin
    (define (make-adder x)
      (lambda (y) (+ x y)))
    (define add5 (make-adder 5))
    (add5 10))
 the-global-environment)
;; ⇒ 15

   **Key Concepts Demonstrated**
  This implementation demonstrates:
- The eval–apply cycle
- How procedures capture their defining environment (closures)
- The role of environments in variable scope resolution
- The separation between evaluation and application
- The use of syntactic transformation to simplify language design

  **How to Run**
1. Open the project in DrRacket
2. Ensure the language is set to:
  #lang sicp
3. Load evaluator.rkt
4. Evaluate expressions using:
(mini-eval '<expression> the-global-environment)
    _Optional_: Start the REPL
(driver-loop)

 **File Structure** 
CSC3311-Mini-Scheme/
│
├── evaluator.rkt   # Full Mini-Scheme evaluator
└── README.md       # Project documentation

 **Status of Lab Progression**
✔ Task 1: Core Evaluator
✔ Task 2: Apply Mechanism
✔ Task 3: Environment Model
✔ Task 4: Derived Expressions (let)
✔ Task 5: Global Environment
- All tasks completed successfully
- Evaluator tested and verified
  
 **Conclusion**
This project delivers a fully functional Mini-Scheme interpreter that faithfully implements key ideas from SICP. It demonstrates a solid understanding of:
- Lexical scoping
- Environment modeling
- Functional abstraction
- Language evaluation mechanisms

The evaluator serves as a foundational model for understanding how programming languages are interpreted.
