(defun f ()
	;define array
	(setf test-array (make-array 10 :initial-element 5))
	;print length
	(format *query-io* "array length is ~a~%" (length test-array))
	;print each element
	(loop for i from 0 to (- (length test-array) 1) do
		(format *query-io* "the ~a element is ~a~%" i (aref test-array i))
	)
	;reset the 6th element
	(setf (aref test-array 5) 100)
	(format *query-io* "after reset~%")
	(loop for i from 0 to (- (length test-array) 1) do
		(format *query-io* "the ~a element is ~a~%" i (aref test-array i))
	)
)
