;this file is about the Principle of 72
;and, firstly, we will introduce to the
;natural logarithm 'e' and calculate its
;value. Secondly, we will use this constant
;to analyze some increase or decrease
;instances in our life.


;***************** Part One *****************;
;calculate e
(defun calc-e ()
	(let ((n 200))
		(loop for x from 1 to n do
			(mapc #' princ `("n=" ,x " (1+100%/" ,x ")^" ,x "=" ,(calc-n x)))
			(fresh-line)
		)
	)
)	
;calculate each value of (1+100%/n)^n
;with given value n
(defun calc-n (n)
	(setf r 1.0)
	(loop for i from 1 to n do
		(setf r (* r (+ 1 (/ 1 n))))
	)
	r
)
;***************** End  One *****************;

;***************** Part Two *****************;
;analysis by principle 72
(defun profit-time (rate)
	(princ "Use E-M principle, Y/N?")
	(mapc #'princ
		(case (read)
			(Y 
				(cond
					((and (< 0 rate) (<= rate 20)) `("twice need time of " ,(* (/ 69.3 rate) (/ 200 (- 200 rate))) " years"))
					((> rate 20) `("twice need time of " ,(/ 76.0 rate) " years"))
				)
			)
			(N 
				(cond 
					((>= rate 10) `("twice need time of " ,(/ (+ 72.0 (/ (- rate 8) 3.0)) rate) " years"))
					((and (<= 6 rate) (< rate 10)) `("twice need time of " ,(/ 72.0 rate) " years"))
					((and (< 0 rate) (< rate 6)) `("twice need time of " ,(/ 69.3 rate) " years"))
				)
			)
			(otherwise '("input Y or N"))
		)
	)
	nil
)
;***************** End  Two *****************;
