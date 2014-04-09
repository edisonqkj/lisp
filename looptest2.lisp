(defun l ()
	(setq i-list '(a b c d e f g))
	(loop for i in i-list do
		(format *query-io* "~a " i)
	)
)
