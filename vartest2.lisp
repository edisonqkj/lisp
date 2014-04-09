(defun f1 ()
	(setf i 10)
	(setf j 20)
	(format *query-io* "i in f1: ~a~%" i)
	(format *query-io* "j in f1: ~a~%" j)
	(let ((j 200))
		(format *query-io* "i in let: ~a~%" i)
		(format *query-io* "j in let: ~a~%" j)
		(setf i 100)
		(setf j 300)
		(format *query-io* "i after setf: ~a~%" i)
		(format *query-io* "j after setf: ~a~%" j)
	)
	(format *query-io* "i out let: ~a~%" i)
	(format *query-io* "j out let: ~a~%" j)
)
