(defun l ()
	(setq i 1)
	(loop while (< i 10) do
		(format *query-io* "*")
		(setq i (+ i 1))
	)
)
