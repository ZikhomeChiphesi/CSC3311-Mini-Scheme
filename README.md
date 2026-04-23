# CSC3311-Mini-Scheme
📘 Mini-Scheme Evaluator — SICP Lab Submission
👨‍💻 Author

Zikhome Chiphesi

📌 Project Overview

This project implements a Mini-Scheme evaluator in Racket (#lang sicp) based on concepts from Structure and Interpretation of Computer Programs (SICP) Chapter 4.1.

The evaluator supports a working eval–apply cycle, lexical scoping, and a basic environment model, allowing evaluation of Scheme-like expressions.

⚙️ Features Implemented
🧠 Core Evaluator
Expression dispatcher (mini-eval)
Handles:
self-evaluating expressions
variables
quoted expressions
assignments (set!)
definitions (define)
conditionals (if)
lambdas
sequences (begin)
procedure applications
🔁 Apply Mechanism
mini-apply supports:
primitive procedures
compound (user-defined) procedures
Proper environment extension during function calls
🌳 Environment Model
Frame-based (ribcage) environment structure
Implemented:
extend-environment
variable lookup
variable assignment
definition mutation
Supports lexical scoping correctly
🍬 Derived Expressions
let expressions implemented as syntactic sugar
Converted internally into lambda applications:
(let ((x 5)) (+ x 3)) → ((lambda (x) (+ x 3)) 5)
🌍 Global Environment
Preloaded primitive operations:
+, -, *, /, =
Boolean constants:
true → #t
false → #f
Fully initialized global environment for evaluation
🧪 Test Cases
Arithmetic
(mini-eval '(+ 2 3) the-global-environment)
;; => 5
Let Expression
(mini-eval '(let ((x 5)) (+ x 3)) the-global-environment)
;; => 8
Nested Let
(mini-eval '(let ((x 2) (y 3)) (* x y)) the-global-environment)
;; => 6
Lexical Scoping Test
(mini-eval
 '(begin
    (define (make-adder x)
      (lambda (y) (+ x y)))
    (define add5 (make-adder 5))
    (add5 10))
 the-global-environment)
;; => 15
📍 Key Insight

This implementation demonstrates:

How procedures carry their environment (closures)
How environments model variable scope
How evaluation is separated from application
How syntactic sugar simplifies core evaluation rules
🚀 How to Run
Open file in DrRacket (#lang sicp)
Load evaluator

Run test expressions using:

(mini-eval '<expression> the-global-environment)
📂 File Structure
evaluator.rkt   → Full Mini-Scheme interpreter
README.md       → This documentation
✅ Status

✔ Tasks 1–5 completed
✔ Full evaluator working
✔ Lexical scoping verified
✔ Global environment initialized

🏁 Conclusion

This project successfully implements a working Mini-Scheme interpreter with lexical scoping, environment handling, and a complete eval-apply cycle inspired by SICP.
