; Area conversions
(defun c:acr2hect()
	(setq acr (getreal "\nEnter acres: "))
	(setq result (* acr 0.4047))
	(prompt (strcat "\n" (rtos acr) " acres is equal to " (rtos result) " hectars."))
(princ)
)

; Temperature Conversions
(defun c:Fah2Cel()
	(setq fah (getreal "\nEnter Fahrenheit: "))
	(setq result (/ (- fah 32) 1.8))
	(prompt (strcat "\n" (rtos fah) " Fahrenheit is equal to " (rtos result) " Celsius."))
(princ)
)

(defun c:Cel2Fah()
	(setq cel (getreal "\nEnter Celsius: "))
	(setq result (+ 32 (* cel 1.8)))
	(prompt (strcat "\n" (rtos cel) " Celsius is equal to " (rtos result) " Fahrenheit."))
(princ)
)

; Weight conversions
(defun c:kg2Lb()
	(setq kg (getreal "\nEnter Kilograms: "))
	(setq result (* kg 2.205))
	(prompt (strcat "\n" (rtos kg) " kg is equal to " (rtos result) " lb"))
(princ)
)

; Angle conversions
(defun c:deg2Rad()
	(setq degrees (getreal "\n Enter degrees: "))
	(setq result (/ (* degrees PI) 180))
	(prompt (strcat "\n" (rtos degrees) " degrees is equal to " (rtos result) " radians."))
(princ)
)