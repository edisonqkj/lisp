(defun f (&key a b c d)
	(format *query-io* "~a~%" a)
	(format *query-io* "~a~%" b)
	(format *query-io* "~a~%" c)
	(format *query-io* "~a~%" d)
	"end of function"
)
