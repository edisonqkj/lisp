(defun calc ()
	;input (x,y) value & add into list
	;calculate the distance from each value to the first
	;output the calculate results
	(format *query-io* "input x,y:~%")
	;(parse-integer (read-line *query-io*))
	;(setf read-input (cons (read-line *query-io*) ()))
	;read-input)
	(setf read-file (open "./xy" :if-does-not-exist nil))
	(setf row (read read-file))
	(setf col (read read-file))
	;(setf row (parse-integer (read read-file) :junk-allowed t))
	;(setf col (parse-integer (read read-file) :junk-allowed t))

;	(setf line (read read-file))
	(setf data '())
	(loop for i from 1 to row do
		(progn
			(setf line '())
			(loop for j from 1 to col do
				(setf line (append line (cons (read read-file) '())))
			)
			(setf line (cons line '()))
			(setf data (append data line))
		)
	)
	(close read-file)
	data
)
