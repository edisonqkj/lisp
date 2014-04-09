(defun file-write ()
	;write file
	(setf sample '(a b (1 2) c d (mon tue wed) e f))
	(setf file-to-write (open "./filetest1.txt" :direction :output
						:if-does-not-exist :create :if-exists :overwrite))
	;write into file
	(format file-to-write "~a ~%" sample)
	(close file-to-write)
)
(defun file-read ()
	;read file
	(setf file-to-read (open "./filetest1.txt" :if-does-not-exist nil))
	(if (not file-to-read)
		(progon
			(format t "file open failed ~%")
		(return-from file-read nil)))
	(setf file-detail (read file-to-read))
	;print
	(format t "is list-readed is a list: ~a ~%" (listp file-detail))
	 file-detail
)
