(defun f ()
	(setf test-list '(a b c))
	(format *query-io* "atom 2: ~a~%" (nth 1 test-list))
	(print-list test-list)
	(format *query-io* "append atom:~%")
	(setf test-list (append test-list '(d)))
	(print-list test-list)
	(format *query-io* "test car:~%")
	(format *query-io* "~a~%" (car test-list))
	(format *query-io* "test cdr:~%")
	(print-list (cdr test-list))
	(format *query-io* "test cddr:~%")
	(print-list (cddr test-list))
	(format *query-io* "test eval:~%")
	(print-list (eval '(setf list1 '(1 2 3))))
	"end of function"
)
	
(defun print-list (l)
	(format *query-io* "print list:~%")
	(loop for i in l do
		(format *query-io* "atoms: ~a~%" i))
)
	
