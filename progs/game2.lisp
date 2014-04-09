(defparameter *node* '((living-room (you are in the living room.))
					  (garden (you are in a beautiful garden.))
					  (attic (you are in the attic.))))
(defparameter *edge* '((living-room (garden west door)
									(attic upstairs ladder))
					  (garden (living-room east door))
					  (attic (living-room downstairs ladder))))
(defparameter *object* '(whiskey bucket frog chain))
(defparameter *object-location* '((whiskey living-room)
								  (bucket living-room)
								  (frog garden)
								  (chain attic)))
(defparameter *location* 'living-room)
(defparameter *allowed-commands* '(look walk pickup inventory))

(defun describe-location (location nodes)
	(cadr (assoc location nodes)))

(defun describe-path (edge)
	`(there is a ,(caddr edge) going ,(cadr edge) from here.))

(defun describe-paths (location edges)
	(apply #'append (mapcar #'describe-path (cdr (assoc location edges)))))

(defun objects-at (loc objs obj-loc)
	(labels ((at-loc-p (objs) ;use suffix p to mark this function return boolean
		(eq (cadr (assoc objs obj-loc)) loc)))
	(remove-if-not #'at-loc-p objs))
) 

(defun describe-objects (loc objs obj-loc)
	(labels ((describe-obj (obj)
		`(you see a ,obj on the floor.)))
	(apply #'append (mapcar #'describe-obj (objects-at loc objs obj-loc))))
)

(defun look ()
	(append (describe-location *location* *node*)
			(describe-paths *location* *edge*)
			(describe-objects *location* *object* *object-location*)
	)
)

(defun walk (direction)
	(let ((next (find direction
				(cdr (assoc *location* *edge*))
				:key #'cadr)))
	(if next
		(progn (setf *location* (car next))
				(look))
		'(you cannot go that way.))
	)
)

(defun pickup (object)
	(cond ((member object (objects-at *location* *object* *object-location*))
			(push (list object 'body) *object-location*)
			`(you are now carrying the ,object))
		  (t '(you cannot get that)))
)

(defun inventory ()
	(cons 'items- (objects-at 'body *object* *object-location*))
)

(defun game-repl0 ()
	(loop (print (eval (read))))
)

(defun game-repl ()
	(let ((cmd (game-read)))
		(unless (eq (car cmd) 'quit)
			(game-print (game-eval cmd))
		(game-repl))
	)
)

(defun game-read ()
	(let ((cmd (read-from-string
			(concatenate 'string "(" (read-line) ")")))
		 )
	(flet ((quote-it (x)
			(list 'quote x)))
		(cons (car cmd) (mapcar #'quote-it (cdr cmd))))
	);let
)

(defun game-eval (sexp)
	(if (member (car sexp) *allowed-commands*)
		(eval sexp)
		'(not allowsed command!)
	)
)

(defun tweak-text (lst caps lit)
	(when lst
		(let ((item (car lst))
			  (rest (cdr lst)))
		 (cond
			 ((eq item #\space) (cons item (tweak-text rest caps lit)))
			 ((member item '(#\! #\? #\.)) (cons item (tweak-text rest t lit)))
			 ((eq item #\") (tweak-text rest caps (not lit)))
			 (lit (cons item (tweak-text rest nil lit)))
			 ((or caps lit) (cons (char-upcase item) (tweak-text rest nil lit)))
			 (t (cons (char-downcase item) (tweak-text rest nil nil)))
		 );cond
		);let
	);when
)	

(defun game-print (lst)
	(princ (coerce (tweak-text (coerce (string-trim "() "
										(prin1-to-string lst))
										'list)
								t
								nil)
					'string))
	(fresh-line))

(defun dot-name (exp)
	(substitute-if #\_ (complement #'alphanumericp)
					(prin1-to-string exp))
)

(defparameter *max-label-length* 30)

(defun dot-label (exp)
	(if exp
		(let ((s (write-to-string exp :pretty nil)))
			(if (> (length s) *max-label-length*)
				(concatenate 'string (subseq s 0 (- *max-label-length* 3)) "...")
				s);if
			);let
	"");if
)

(defun nodes->dot (nodes)
	(mapc (lambda (node)
			(fresh-line)
			(princ (dot-name (car node)))
			(princ "[label=\"")
			(princ (dot-label node))
			(princ "\"];"));lambda
		  nodes)
)

(defun edges->dot (edges)
	(mapc (lambda (node)
			(mapc (lambda (edge)
				(fresh-line)
				(princ (dot-name (car node)))
				(princ "->")
				(princ (dot-name (car edge)))
				(princ "[label=\"")
				(princ (dot-label (cdr edge)))
				(princ "\"];"));lambda
				(cdr node));mapc
			);lambda
			edges);mapc
)

(defun graph->dot (nodes edges)
	(princ "digraph{")
	(nodes->dot nodes)
	(edges->dot edges)
	(princ "}")
)

(defun dot->png (fname thunk)
	(with-open-file (*standard-output*
					fname
					:direction :output
					:if-exists :supersede)
				(funcall thunk))
	(ext:shell (concatenate 'string "dot -Tsvg -O " fname))
)

(defun graph->png (fname nodes edges)
	(dot->png fname (lambda ()
						(graph->dot nodes edges))
	)
)

(defun uedges->dot (edges)
	(maplist (lambda (lst)
				(mapc (lambda (edge)
						(unless (assoc (car edge) (cdr lst))
							(fresh-line)
							(princ (dot-name (caar lst)))
							(princ "--")
							(princ (dot-name (car edge)))
							(princ "[label=\"")
							(princ (dot-label (cdr edge)))
							(princ "\"];"));unless
					   )
				(cdar lst));mapc
				)
			edges);maplist
)

(defun ugraph->dot (nodes edges)
	(princ "graph{")
	(nodes->dot nodes)
	(uedges->dot edges)
	(princ "}")
)

(defun ugraph->png (fname nodes edges)
	(dot->png fname
			  (lambda ()
				(ugraph->dot nodes edges)
			  )
	)
)
