;
;
;input data
;return the type of it
;
;
;First example:
;
;(type-of-data 1)
;(type-of-data #\a)
;(type-of-data 'a)
;(type-of-data "abc")
;(type-of-data '(a b c))
;(type-of-data (make-array 5))
;(type-of-data (cons 1 2))
;(type-of-data (make-hash-table))
;(type-of-data #'append)

(defun type-of-data (data)
	(cond
		((numberp data) 'number)
		((characterp data) 'character)
		((symbolp data) 'symbol)
		((stringp data) 'string)
		((listp data) 'list)
		((arrayp data) 'array)
		((consp data) 'cons);consp=listp
		((hash-table-p data) 'hashtable)
		((functionp data) 'function)
	)
)

;
;
;Second example:
;
;if the name of multiple function is too long,
;errors will occur.

(defmethod type-class ((a number))
	'number)

(defmethod type-class ((a character))
	'character)

(defmethod type-class ((a symbol))
	'symbol)

(defmethod type-class ((a string))
	'string)

(defmethod type-class ((a list))
	'list)

(defmethod type-class ((a array))
	'array)

(defmethod type-class ((a cons))
	'cons)

(defmethod type-class ((a hash-table))
	'hash-table)

(defmethod type-class ((a function))
	'function)
