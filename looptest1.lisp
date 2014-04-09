(defun l ()
	(loop for i from 1 to 10 do
		(format *query-io* "*")
	)
)
