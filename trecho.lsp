
(defun c:trecho () 
	(vl-load-com)
	(setvar 'cmdecho 0)
	
	; Solicita entradas de dados do trecho
	(setq p1 (getpoint "Informe o primeiro ponto: "))
	(setq flag T)
	
	(while (setq p2 (getpoint p1 "\nInforme o segundo ponto: "))			
		; Calcula as variaveis
		(setq x1 (car p1) x2 (car p2))
		(setq y1 (cadr p1) y2 (cadr p2))
		(setq dx (+ (- x2 x1)))
		(setq dy (- y2 y1))
		(setq offset 2)
		(setq textSize 0.01)
		(setq xm (/ (+ x1 x2) 2))
		(setq ym (/ (+ y1 y2) 2))
		(setq angRad (atan (+ (/ dy (if (= dx 0) 0.001 dx)))))
		(setq angDeg (radToDeg angRad))
		(if (< dx 0) (setq angRad (+ angRad	PI) angDeg (+ angDeg 180)))
		
		; Desenha a linha
		(command "LINE" p1 p2 "")

		; Desenha a seta
		(command "INSERT" "SETA" (strcat (rtos xm) "," (rtos ym)) "0.5" "0.5" (rtos angDeg))
		
		; Desenha texto da distancia
		(setvar 'clayer "EG_TX_EXT")
		(if (< dx 0) (setq angRad (+ angRad	PI) angDeg (+ angDeg 180)))
		(command "TEXT" "S" "ROMANS" "J" "TC" 
			(strcat 
				(rtos (+ xm (* offset (sin angRad)))) 
				"," 
				(rtos (- ym (* offset (cos angRad))))
			)
			(rtos angDeg)
			(rtos (sqrt (+ (expt dx 2) (expt dy 2))) 2 2)
		)
		(setq p1 p2)
	)
	(princ)
) ; defun

; Converter Angulos em grau para radiano
(defun degToRad (angDeg) 
	(/ (* angDeg PI) 180.0)
)
; Converter Angulos em radiano para graus
(defun radToDeg (angRad) 
	(/ (* angRad 180.0) PI)
)