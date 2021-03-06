./game2.lisp                                                                                        0000664 0001750 0001750 00000011655 12216322345 012435  0                                                                                                    ustar   edison                          edison                                                                                                                                                                                                                 (defparameter *node* '((living-room (you are in the living room.))
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
                                                                                   ./game3.lisp                                                                                        0000664 0001750 0001750 00000014576 12221456022 012437  0                                                                                                    ustar   edison                          edison                                                                                                                                                                                                                 (load "graph-util.lisp")
(defparameter *congestion-city-nodes* nil)
(defparameter *congestion-city-edges* nil)
(defparameter *visited-nodes* nil)
(defparameter *node-num* 30)
(defparameter *edge-num* 45)
(defparameter *worm-num* 3)
(defparameter *cop-odds* 15)

(defun random-node ()
	(1+ (random *node-num*))
)

(defun edge-pair (a b)
	(unless (eql a b)
		(list (cons a b) (cons b a)))
)

(defun make-edge-list ()
	(apply #'append (loop repeat *edge-num*
						  collect (edge-pair (random-node) (random-node))
					)
	)
)

;get all the edges linked to the given node
(defun direct-edges (node edge-list)
	(remove-if-not (lambda (x)
						(eql (car x) node))
						edge-list)
)

;get all the nodes which are linked to the given node
;even across several edges
(defun get-connected (node edge-list)
	(let ((visited nil))
		(labels ((traverse (node)
					(unless (member node visited)
						(push node visited)
						;traverse all the edges linked to the node recursively
						(mapc (lambda (edge)
									(traverse (cdr edge)))
							  (direct-edges node edge-list)
						)
					)))
		(traverse node))
	visited)
)

(defun find-islands (nodes edge-list)
	(let ((islands nil))
		(labels ((find-island (nodes)
					(let* ((connected (get-connected (car nodes) edge-list))
						   (unconnected (set-difference nodes connected)))
						(push connected islands)
						(when unconnected
							(find-island unconnected)
						)
					)
				))
	      (find-island nodes)
		)
		islands)
)

;link two islands with their first node
(defun connect-with-bridges (islands)
	(when (cdr islands)
		(append (edge-pair (caar islands) (caadr islands))
				(connect-with-bridges (cdr islands))
		)
	)
)

;append new edges into the initial edge-list
(defun connect-all-islands (nodes edge-list)
	(append (connect-with-bridges (find-islands nodes edge-list)) edge-list)
)

(defun make-city-edges ()
	(let* ((nodes (loop for i from 1 to *node-num*
						collect i))
		   (edge-list (connect-all-islands nodes (make-edge-list)))
		   (cops (remove-if-not (lambda (x)
									(zerop (random *cop-odds*))
								)
								edge-list)
		   ))
		   (add-cops (edges-to-alist edge-list) cops)
	)
)

;edge-list: ((1.2) (2.1) (2.3) (3.2))
(defun edges-to-alist (edge-list)
	(mapcar (lambda (node1)
				(cons node1
					(mapcar (lambda (edge)
								(list (cdr edge))
							)
							(remove-duplicates (direct-edges node1 edge-list) :test #'equal))
				)
			)
		;get all the node
		(remove-duplicates (mapcar #'car edge-list))
	)
)

(defun add-cops (edge-alist edges-with-cops)
	(mapcar (lambda (x)
				(let ((node1 (car x))
					  (node1-edges (cdr x)))
					(cons node1
						(mapcar (lambda (edge)
							(let ((node2 (car edge)))
								(if (intersection (edge-pair node1 node2)
													edges-with-cops
													:test #'equal)
									(list node2 'cops)
									edge)
							));lambda
						node1-edges);mapcar
					)
				))
			edge-alist)
)

(defun neighbors (node edge-alist)
	(mapcar #'car (cdr (assoc node edge-alist)))
)

(defun within-one (a b edge-alist)
	(member b (neighbors a edge-alist))
)

(defun within-two (a b edge-alist)
	(or (within-one a b edge-alist)
		(some (lambda (x)
				(within-one x b edge-alist))
			(neighbors a edge-alist))
	)
)

(defun make-city-nodes (edge-alist)
	(let ((wumpus (random-node))
		(glow-worms (loop for i below *worm-num*
						collect (random-node))
		))
		(loop for n from 1 to *node-num*
			collect (append (list n)
						(cond ((eql n wumpus) '(wumpus))
							  ((within-two n wumpus edge-alist) '(blood!)))
						(cond ((member n glow-worms) '(glow-worm))
							  ;if existing one of glow-worms is within-one to n
							  ;return lights
							  ((some (lambda (worm)
										(within-one n worm edge-alist))
									glow-worms)
								'(lights!)));cond
						;if existing edge linked to n has cops, return sirens
						(when (some #'cdr (cdr (assoc n edge-alist)))
							'(sirens!)
						)
					)
		)
	)
)

(defun new-game ()
	(setf *congestion-city-edges* (make-city-edges))
	(setf *congestion-city-nodes* (make-city-nodes *congestion-city-edges*))
	(setf *player-pos* (find-empty-node))
	(setf *visited-nodes* (list *player-pos*))
	(draw-city)
	(draw-known-city)
)

(defun find-empty-node ()
	(let ((x (random-node)))
		;if node has description
		;recursive
		;warning: if every node isn't empty, searching will never stop
		;dead program!
		(if (cdr (assoc x *congestion-city-nodes*))
			(find-empty-node)
			x)
	)
)

(defun draw-city ()
	(ugraph->png "city" *congestion-city-nodes* *congestion-city-edges*)
)

(defun known-city-nodes ()
	(mapcar (lambda (node)
				(if (member node *visited-nodes*)
					(let ((n (assoc node *congestion-city-nodes*)))
						(if (eql node *player-pos*)
							(append n '(*))
							n);if
					)
					(list node '?));if
			)
		(remove-duplicates
			(append *visited-nodes*
					(mapcan (lambda (node)
								(mapcar #'car
									(cdr (assoc node
												*congestion-city-edges*));cdr
								)
							)
						*visited-nodes*);mapcan
			)
		)
	)
)

(defun known-city-edges ()
	(mapcar (lambda (node)
				(cons node (mapcar (lambda (x)
										(if (member (car x) *visited-nodes*)
											x
											(list (car x))
										)
									)
								(cdr (assoc node *congestion-city-edges*)));mapcar
				);cons
			)
		*visited-nodes*)
)

(defun draw-known-city ()
	(ugraph->png "known-city" (known-city-nodes) (known-city-edges))
)

(defun walk (pos)
	(handle-direction pos nil)
)

(defun charge (pos)
	(handle-direction pos t)
)

;next position: pos
(defun handle-direction (pos charging)
	(let ((edge (assoc pos
					(cdr (assoc *player-pos* *congestion-city-edges*)))
		  ))
		(if edge
			(handle-new-place edge pos charging)
			(princ "that location does not exist!")
		)
	)
)

(defun handle-new-place (edge pos charging)
	(let* ((node (assoc pos *congestion-city-nodes*))
		   (has-worm (and (member 'glow-worm node)
						  (not (member pos *visited-nodes*))
					 ))
		  )
		(pushnew pos *visited-nodes*)
		(setf *player-pos* pos)
		(draw-known-city)
		(cond ((member 'cops edge) (princ "you ran into the cops. game over."))
			  ((member 'wumpus node) (if charging
										(princ "you found the wumpus!")
										(princ "you ran into the wumpus!")
									 ))
			  (charging (princ "you wasted your last bullet. game over."))
			  (has-worm (let ((new-pos (random-node)))
							(princ "you ran into a glow worm gang! you're now at ")
							(princ new-pos)
							(handle-new-place nil new-pos nil)
						))
		)
	)
)

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  