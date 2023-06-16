(define get-operator (lambda (op-symbol env)
  (cond
    ((eq? op-symbol '+) +)
    ((eq? op-symbol '*) *)
    ((eq? op-symbol '-) -)
    ((eq? op-symbol '/) /)
    (else (display "ERROR\n") (repl env)))))

(define ifExpr? (lambda (e)
	(and (list? e) (equal? (car e) 'if) (= (length e) 4))))

(define condChecker? (lambda (e)
    (if(null? e)
        #f
        (if (and (list? (car e)) (= (length (car e)) 2))
            (if (equal? (caar e) 'else)
                (if (null? (cdr e))
                    #t
                    #f
                )
                (condChecker? (cdr e))                
            )
            #f
        )
    )
))

(define condExpr? (lambda (e)
	(and (list? e) (> (length e) 2)(equal? (car e) 'cond) (condChecker? (cdr e)))))

(define letChecker? (lambda (e)
    (cond
        ((null? e) #t)
        ((not (and (list? (car e))
                (= (length (car e)) 2)
                (symbol? (caar e)))) #f)
        (else (letChecker? (cdr e)))
    )
))

(define letExpr? (lambda (e) 
    (and (list? e) (equal? (car e) 'let) (= (length e) 3) (letChecker? (cadr e)))))

(define letSExpr? (lambda (e) 
    (and (list? e) (equal? (car e) 'let*) (= (length e) 3) (letChecker? (cadr e)))))

(define get-value (lambda (var env)
    (cond 
       ( (null? env) "ERROR" )
       ( (eq? var (caar env)) (cdar env))
       ( else (get-value var (cdr env))))))

(define extend-env (lambda (var val old-env)
        (cons (cons var val) old-env)))

(define define-expr? (lambda (e)
         (and (list? e) (= (length e) 3) (eq? (car e) 'define) (symbol? (cadr e)))))

(define nothingWorked? (lambda (e)
    (and (equal? (length e) 2) (list? (cadr e)) (equal? (caadr e) 'else ))))

(define dupFound? (lambda (e)
    (if (null? e)
        #f 
        (if (member (car e) (cdr e))
            #t
            (dupFound? (cdr e))
        ))
    )
)

(define letSFunc (lambda (toBindLhs toBindRhs env)
    (if (null? toBindLhs)
        (s6 toBindRhs env)
        (let ((currBinding (car toBindLhs)))
            (letSFunc (cdr toBindLhs) toBindRhs (cons (cons (car currBinding) (s6 (cadr currBinding) env)) env))
        )
    )
))

(define s6 (lambda (e env)
   (cond
      ( (number? e) e)
      ( (symbol? e) (get-value e env))
      ( (not (list? e)) (display "ERROR\n") (repl env))
      ( (ifExpr? e) (if (eq? (s6 (cadr e) env) 0)
        (s6 (cadddr e) env)
        (s6 (caddr e) env)
      ))
      ( (condExpr? e)
        (cond
            ((not (eq? (s6 (caadr e) env) 0)) (s6 (cadadr e) env))
            (else (s6 (cons 'cond (cddr e)) env))
        )
      )

      ( (nothingWorked? e)
        (s6 (cadadr e) env)
      )

      ((letExpr? e)
        (if (dupFound? (map car (cadr e)))
            (begin (display "ERROR\n") (repl env))

            (let ((toBindLhs (map car (cadr e)))
                 (toBindRhs (map cadr (cadr e))))
                 (let ((toBindValues (map (lambda (expr) (s6 expr env)) toBindRhs)))
                    (let ((letEnv (append (map cons toBindLhs toBindValues) env)))
                    (s6 (caddr e) letEnv))
                 )
        )
      ))

      ((letSExpr? e)
        (letSFunc (cadr e) (caddr e) env)
      )

      ( else 
         (let (
                (operator (get-operator (car e) env))
                (operands (map s6 (cdr e) (make-list (length (cdr e) ) env )))
              )
              (apply operator operands))))))

(define repl (lambda (env)
   (let* (
           (dummy1 (display "cs305> "))
           (expr (read))
           (new-env (if (define-expr? expr) 
                        (extend-env (cadr expr) (s6 (caddr expr) env) env)
                        env
                    ))
           (val (if (define-expr? expr)
                    (cadr expr)
                    (s6 expr env)
                ))
           (dummy2 (display "cs305: "))
           (dummy3 (display val))
           (dummy4 (newline))
           (dummy5 (newline))
          )
          (repl new-env))))

(define cs305 (lambda () (repl '())))