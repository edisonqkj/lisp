(defun f (a b &optional (c "default c" c-supplied-p) d)
	(format *query-io* "~a~%" a)
	(format *query-io* "~a~%" b)
	(format *query-io* "~a~%" c)
	(format *query-io* "~a~%" c-supplied-p)
	(format *query-io* "~a~%" d)
	"end of function"
)	
