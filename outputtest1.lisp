(defun print-to-file ()
	(princ "this is a print function")
)

(defun write-file-test (thunk)
	(with-open-file (*standard-output*
					"file-output.txt"
					:direction :output
					:if-exists :supersede)
					(princ "hello world")
					(princ '#\newline)
					(funcall thunk)
	)
)

(defun run ()
	(write-file-test (lambda ()
						(print-to-file))
	)
)
