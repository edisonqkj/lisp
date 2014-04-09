(defun f (a &key b)
	(format *query-io* "~a~%" a)
	(format *query-io* "~a~%" b)
)	
