; Calculate the area of a rectangle defined by the user
(defun c:calcArea()
	; Get the width and length from the user
	(setq wd (getreal "\nEnter the width: "))
	(setq ln (getreal "\nEnter the length: "))
	
	; Calculate the area based on the data provided by the user
	(setq area (* wd ln))
	(prompt (strcat "\n The area is: " (rtos area)))
(princ)
)

; Create a new layer with parameters defined by the user
(defun c:LM()
	; Ask the user for the parameters
	(setq newlayer (getstring "\nEnter new layer name: "))
	(setq ltype (getstring "\nEnter linetype for the new layer: "))
	(setq color (getstring "\nEnter color for the new layer: "))
	
	; Create the layer
	(command "layer" "m" newlayer "lt" ltype "" "c" color "" "")
	(prompt (strcat "\nLayer " newlayer " created"))
(princ)
)

; Show how the variable PAUSE is used
; ie. it replaces a argument to a command by a pause to the user enter some input
(defun c:ln()
	(command "line" pause pause "")
)

(defun c:ib()
	(setq blkname (getstring "\nEnter blockname: "))
	(command "insert" blkname pause "" "" "")
)

; Show how the variable T is used
(defun c:printNum()
	(setq flag T)
	(setq counter 1)
	(while flag
		(if (< counter 11)
			(progn
				(print counter)
				(setq counter (1+ counter))
			)
			(setq flag nil)
		)
	)
(princ)
)