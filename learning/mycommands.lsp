; Zoom Commands
(defun c:ze() (command "zoom" "e"))
(defun c:za() (command "zoom" "a"))
(defun c:zz() (command "zoom" "p"))

; Layer Commands
(defun c:walls() (command "layer" "s" "walls" ""))
(defun c:wf() (command "layer" "s" "walls" "f" "*" ""))
(defun c:lth() (command "layer" "t" "*" ""))
(defun c:loff() (command "layer" "off" "*" "" ""))
(defun c:lon() (command "layer" "on" "*" ""))
(defun c:power() (command "layer" "s" "power" ""))

; Insert Commands
(defun c:ir() 
	(command "layer" "s" "power" "")
	(command "insert" "receptacle" pause "" "" "")
)
(defun c:il() 
	(command "layer" "s" "lighting" "")
	(command "insert" "lighting fixture" pause "" "" "")
)

; Audit Commands
(defun c:CountReceptacles()
	(setq ss (ssget "X" '((0 . "INSERT") (2 . "Receptacle"))))
	(setq count (sslength ss))
	(alert (strcat "Total Receptacles in the drawing: " (itoa count)))
(princ)
)

(defun c:CountLights()
	(setq ss (ssget "X" '((0 . "INSERT") (2 . "Lighting Fixture"))))
	(setq count (sslength ss))
	(alert (strcat "Total Lightings in the drawing: " (itoa count)))
(princ)
)