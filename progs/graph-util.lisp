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
