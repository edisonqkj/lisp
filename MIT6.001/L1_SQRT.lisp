;In CLisp, 'define' can't be used?
;(define (SQRT x)
;	(define (good-enough? guess)
;		(< (abs (- guess (/ x guess))) 0.01))
;	(define (improve guess)
;		 (/ (+ guess (/ x guess)) 2.0))
;	(define (try guess)
;		(if (good-enough? guess)
;			guess
;			(try (improve guess))))
;	(try 1))
(defun SQRT-edison (x)
	(labels (
		(good-enough? (guess)
			(< (abs (- guess (/ x guess))) 0.0001))
		(improve (guess)
			(/ (+ guess (/ x guess)) 2.0))
		(try (guess)
			(if (good-enough? guess)
				guess
				(try (improve guess)))))
		(try 1)))
