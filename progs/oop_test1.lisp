(defstruct person
			name
			borrow-book-name
)

(defstruct book
			name
			borrowed-by
			is-returned
)

(defparameter *edison* 'nil)
(defparameter *jay* 'nil)

(defparameter *persons* '(nil nil))
(defparameter *books* '(nil nil))

(defun create-persons ()
	(setf (nth 0 *persons*) (make-person
					:name 'edison
					:borrow-book-name '(b1 b2 b3))
	)
	(setf (nth 1 *persons*) (make-person
					:name 'jay
					:borrow-book-name '(b4 b5))
	)
)

(defun create-books ()
	(setf *books*
			(mapcan (lambda (pers)
						(mapcar (lambda (book-name)
									(make-book 
										:name book-name
										:borrowed-by (person-name pers)
										:is-returned 'nil))
							(person-borrow-book-name pers)
						))
					*persons*)
	)
)	

(defun print-books ()
	(mapc (lambda (bk)
			(princ (book-name bk))
			(princ ":")
			(fresh-line)
			(princ "borrowed by ")
			(princ (book-borrowed-by bk))
			(fresh-line)
			(princ "is returned? ")
			(princ (book-is-returned bk))
			(fresh-line))
		*books*)
)

(defun start ()
	(create-persons)
	(create-books)
	(print-books)
)
