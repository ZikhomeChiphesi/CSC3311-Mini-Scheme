📘 CSC3311 — Mini-Scheme Evaluator
SICP Laboratory Practical Submission
👨‍💻 Author
Zikhome Chiphesi
📌 Project Overview
This project implements a Mini-Scheme evaluator in Racket using #lang sicp, based on concepts from Structure and Interpretation of Computer Programs (SICP), Chapter 4.1.
The evaluator models the eval–apply cycle, supports lexical scoping, and implements a frame-based environment system, enabling the execution of core Scheme expressions.
⚙️ Features Implemented
🧠 Core Evaluator (mini-eval)
The evaluator acts as a dispatcher that classifies and processes expressions. It supports:
Self-evaluating expressions (numbers, strings, booleans)
Variable lookup
Quoted expressions (quote)
Assignment (set!)
Definitions (define)
Conditionals (if, including one-armed if)
Lambda expressions (lambda)
Sequences (begin)
Procedure applications
🔁 Apply Mechanism (mini-apply)
Handles procedure execution by distinguishing between:
Primitive procedures (e.g. +, -, *, /, =)
Compound procedures (user-defined functions)
Ensures correct environment extension during function calls.
🌳 Environment Model
Implements a ribcage (frame-based) environment structure:
extend-environment for creating new frames
Variable lookup across environment chains
Variable mutation (set!)
Definition and binding (define)
✅ Fully supports lexical scoping, where procedures retain access to the environment in which they were defined.
🍬 Derived Expressions (Syntactic Sugar)
let expressions are implemented as derived expressions and internally transformed into lambda applications:
(let ((x 5)) (+ x 3))
⟶ ((lambda (x) (+ x 3)) 5)
This simplifies the evaluator by reducing complexity in the core logic.
🌍 Global Environment
The evaluator initializes a global environment containing:
Primitive operations: +, -, *, /, =
Boolean constants:
true → #t
false → #f
🧪 Test Cases
🔢 Arithmetic
(mini-eval '(+ 2 3) the-global-environment)
;; ⇒ 5
🍬 Let Expression
(mini-eval '(let ((x 5)) (+ x 3)) the-global-environment)
;; ⇒ 8
🔗 Multiple Bindings
(mini-eval '(let ((x 2) (y 3)) (* x y)) the-global-environment)
;; ⇒ 6
🧠 Lexical Scoping (Closure Test)
(mini-eval
 '(begin
    (define (make-adder x)
      (lambda (y) (+ x y)))
    (define add5 (make-adder 5))
    (add5 10))
 the-global-environment)
;; ⇒ 15
📍 Key Concepts Demonstrated
This implementation demonstrates:
The eval–apply cycle
How procedures capture their defining environment (closures)
The role of environments in variable scope resolution
The separation between evaluation and application
The use of syntactic transformation to simplify language design
🚀 How to Run
Open the project in DrRacket
Ensure the language is set to:
#lang sicp
Load evaluator.rkt
Evaluate expressions using:
(mini-eval '<expression> the-global-environment)
▶ Optional: Start the REPL
(driver-loop)
📂 File Structure
CSC3311-Mini-Scheme/
│
├── evaluator.rkt   # Full Mini-Scheme evaluator
└── README.md       # Project documentation
✅ Status
✔ Task 1: Core Evaluator
✔ Task 2: Apply Mechanism
✔ Task 3: Environment Model
✔ Task 4: Derived Expressions (let)
✔ Task 5: Global Environment
🎯 All tasks completed successfully
🧪 Evaluator tested and verified
🏁 Conclusion
This project delivers a fully functional Mini-Scheme interpreter that faithfully implements key ideas from SICP. It demonstrates a solid understanding of:
Lexical scoping
Environment modeling
Functional abstraction
Language evaluation mechanisms
The evaluator serves as a foundational model for understanding how programming languages are interpreted.