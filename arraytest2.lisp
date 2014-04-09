(defun f ()
	;define two dimensional array
	(setf test-array (make-array '(3 5) :initial-element "aaa"))
	;dimensions
	(setf dimensions (array-dimensions test-array))
	(format *query-io* "array dimensions: ~a~%" dimensions)
;	(format *query-io* "first dimension: ~a~%" (aref dimensions 0))
;	(format *query-io* "second dimension: ~a~%" (aref dimensions 1))
	;print array element
	(loop for i from 0 below (array-dimension test-array 0) do
		(loop for j from 0 below (array-dimension test-array 1) do
			(if (= j (- (array-dimension test-array 1) 1))
				(format *query-io* "(~a,~a) =  ~a~%"
									i j (aref test-array i j))
				(format *query-io* "(~a,~a) = ~a "
									i j (aref test-array i j)))
		))
	;reset element
	(setf (aref test-array 1 3) "lll")
	(setf (aref test-array 2 4) "lll")
	;print array element
	(format *query-io* "~%after reset~%")
	(loop for i from 0 below (array-dimension test-array 0) do
		(loop for j from 0 below (array-dimension test-array 1) do
			(if (= j (- (array-dimension test-array 1) 1))
				(format *query-io* "(~a,~a) =  ~a~%"
									i j (aref test-array i j))
				(format *query-io* "(~a,~a) = ~a "
									i j (aref test-array i j)))
		))
	"end of function"
)

