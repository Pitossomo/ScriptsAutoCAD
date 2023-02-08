;;;; Accessing and modifying properties of AutoCAD objects ;;;;

;; Line Object ;;
; Move the first point of the line of the origin (0.0 0.0 0.0)
(defun c:movetozero()
	(setq line (car (entsel "\nSelect a line: ")))
	(setq lp (entget line))
	(setq newlp (subst (cons 10 (list 0.0 0.0 0.0)) (assoc 10 lp) lp))
	(entmod newlp)
	(entupd line)
(princ)
)

;; Circle Object ;;
; Change the radius of the circle
(defun c:changeRadius()
	(setq circ (car (entsel "\nSelect a circle: ")))
	(setq cp (entget circ))
	(setq newRadius (getreal "\nEnter the new radius: "))
	(setq newcp (subst (cons 40 newRadius)(assoc 40 cp) cp))
	(entmod newcp)
	(entupd circ)
(princ)
)

;; Text Object
; Change the text value, the layer and the text style
(defun c:changeText()

	; Initialize and populate variables
	(setq text (car (entsel "\nSelect a text object: ")))
	(setq tp (entget text))
	(setq newString (getstring T "\nEnter the new text value: "))
	(setq newLayer (getstring nil "\nEnter the new layer name: ")) ; Existente ou não
	(setq newtStyle (getstring nil "\nEnter an existent style name: ")) ; Existente! 
	
	; Subst old properties by the new ones
	(setq ntp1 (subst (cons 1 newString)(assoc 1 tp) tp))
	(setq ntp2 (subst (cons 8 newLayer)(assoc 8 ntp1) ntp1))
	(setq ntp3 (subst (cons 7 newtStyle)(assoc 7 ntp2) ntp2))
	(entmod ntp3)
	(entupd text)
	(prompt "Done.")
(princ)
)

;; Dimension Object ;;
; Change the style and the layer of the selected dimension object
(defun c:changeDim()
	(setq dim (car (entsel "\nSelect a dimension object: ")))
	(setq dp (entget dim))
	(setq scale (getint "\nEnter the scale of the project: "))
	
	; Update properties
	(setq newStyle (strcat "ISO-" (itoa scale)))
	(setq nlayer "Cota")
	(setq newdp (subst (cons 3 newStyle)(assoc 3 dp) dp))
	(setq newdp2 (subst (cons 8 nlayer)(assoc 8 newdp) newdp))
	(entmod newdp2)
	(entupd dim)
	(prompt "Done.")
(princ)
)

; Change the style and the layer of all the dimension objects
(defun c:changeDims()
	(setq dims (ssget "X" '((0 . "DIMENSION"))))
	(setq scale (getint "\nEnter the scale of the project: "))
	(setq ctr 0)
	(setq ldim (sslength dims))

	(while (/= ctr ldim)
		(setq dim (ssname dims ctr))
		(setq dp (entget dim))	
		(setq newStyle (strcat "ISO-" (itoa scale)))
		(setq nlayer "Cota")
		(setq newdp (subst (cons 3 newStyle)(assoc 3 dp) dp))
		(setq newdp2 (subst (cons 8 nlayer)(assoc 8 newdp) newdp))
		(entmod newdp2)
		(entupd dim)
		(setq ctr (1+ ctr))
	)
	(prompt "Done.")
(princ)
)

;;;; Block and Attribute Elements ;;;;
(defun c:atualizaPVs()
	(setq pvs (ssget "X" '((0 . "INSERT")(2 . "ModeloPV"))))
	(setq ctr 0)
	(setq len (sslength pvs))
	(if (> len 0) (setq len (- len 1)))
	
	; Iterate over blocks
	(while (< ctr len)
		(setq pv (ssname pvs ctr))
		(setq properties (entget pv))
		(setq blktype (cdr (assoc 0 properties)))
		
		; Iterate over attributes of each block
		; (in case there are more than one attr)
		(while (/= blktype "SEQEND")
			(setq properties (entget (entnext (cdr (assoc -1 properties))))) ; Access the properties of the next entity (ie. the sub-entities of the block)
			(setq blktype (cdr (assoc 0 properties))) ; access the ent
			
			; For the attributes, select what to do based on the tagname and change it accordingly
			(if (= blktype "ATTRIB")
				(progn
					(setq tagname (cdr (assoc 2 properties)))
					(if (= tagname "COTATOPO")
						(progn
							(setq cotaTopo (getreal "\nInforme a cota de topo: "))
							(setq newprop (subst (cons 1 (rtos cotaTopo))(assoc 1 properties) properties))
							(entmod newprop)
							(entupd pv)
						)
					)
				)
			)
		)
		(setq ctr (1+ ctr))
	)
(princ)
)

