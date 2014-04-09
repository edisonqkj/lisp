(defun myserver()
	(start (make-instance 'easy-acceptor :port 8080))

	(define-easy-handler (greet :uri "/hello") ()
		(format nil "<html><body><h1>Hello World!</h1></body></html>")
	)
)
