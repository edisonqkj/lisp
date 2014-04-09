(defun f ()
	;iterate to print array elements
	;not in use of loop
	(setf test-array (make-array 10 :initial-element 5))
	(setf i (- (length test-array) 1))
	(print-array i)
)
		
(defun print-array (index)
	(format *query-io* "the element ~a is ~a~%" index (aref test-array index))
	(if (< index 0)
		(format *query-io* "end~%")
		(print-array (- index 1))
	)
)
(defun f2 ()
	;iterate to print array elements
	;not in use of loop
	(setf test-array (make-array 10 :initial-element 5))
	(setf i 0)
	(print-array2 i)
)
(defun print-array2 (index)
	(format *query-io* "the element ~a is ~a~%" index (aref test-array index))
	(if (> index (- (length test-array) 2))
		(format *query-io* "end~%")
		(print-array2 (+ index 1))
	)
)
