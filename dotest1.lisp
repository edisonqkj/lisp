(defun f ()
	(format *query-io* "do test:~%")
	(setf end-value
	(do ((x 1 (1+ x)))
		((> x 10) "end")
		(format *query-io* "x = ~a ~%" x))
	)
	(format *query-io* "end value: ~a~%" end-value)
	"end of function"
)
