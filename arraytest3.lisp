(defun f ()
	;adjustable array test
	;:fill-pointer only
	(setf test-array (make-array 5 :fill-pointer 4 :initial-element 1))
	;:fill-pointer + :adjustable
	(setf test-array1 (make-array 5 :fill-pointer 4 :initial-element 2 :adjustable t))

	(format *query-io* "initial array:~%")
	(print-array test-array)
	(print-array test-array1)

	(vector-push 10 test-array)
	(vector-push-extend 20 test-array1)
	(format *query-io* "~%first extend:~%")
	(print-array test-array)
	(print-array test-array1)

	(vector-push-extend 30 test-array1)
	(vector-push-extend 40 test-array1)
	(format *query-io* "~%second extend:~%")
	(print-array test-array1)

	(format *query-io* "~%array pop:~%")
	(vector-pop test-array1)
	(print-array test-array1)
	"end of function"
)
(defun print-array (array)
	(format *query-io* "~%array length ~a~%" (length array))
	(loop for i from 0 below (length array) do
		(format *query-io* "~a " (aref array i)))
	(format *query-io* "~%")
)
