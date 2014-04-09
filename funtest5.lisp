(defun f (&key a (b "default b" b-supplied-p))
	(format *query-io* "~a~%" a)
	(format *query-io* "~a~%" b)
	(format *query-io* "~a~%" b-supplied-p)
	"end of function"
)
