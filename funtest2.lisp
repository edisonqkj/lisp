(defun f (a b &rest other-parameters)
	(format *query-io* "~a~%" a)
	(format *query-io* "~a~%" b)
	(loop for para in other-parameters do
		(format *query-io* "~a~%" para)
	)
)	
