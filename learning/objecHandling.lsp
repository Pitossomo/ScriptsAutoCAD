; List properties of a selected entity
(defun c:UsingEntsel()
	(setq ln (car (entsel "\nSelect a line entity: ")))
	(command "list" ln)
	(princ)
)

; List properties of the last drawn entity
(defun c:UsingEntlast()
	(setq elast (entlast))
	(command "list" elast "")
	(princ)
)

; Change color of the next entity
(defun c:UsingEntNext()
	(setq obj (entnext))
	(command "chprop" obj "" "Color" "red" "")
	(princ)
)

; Store the properties of a line in a variable
(defun c:UsingEntget()
	(setq ln (car (entsel "\nSelect a line entity: ")))
	(setq lprop (entget ln))
	(print lprop)
	(princ)
)
