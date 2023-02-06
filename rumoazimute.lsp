;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;                                                                      ;;;;;;
;;;;;; DRUMO - DESENHA UM TRECHO COM BASE NO RUMO E DISTÂNCIA FORNECIDOS 		;;;;;;
;;;;;;                                                                      ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:DRUMO () 
	(vl-load-com)
	(setvar 'cmdecho 0)

	; Solicita o nome da layer
	(setq nomeLayer (getstring "Informe o nome da layer a ser utilizada: "))

	; Inicia o ciclo
	(setq flag T)
	(while flag
		
		; Solicita entradas de dados do trecho - checa se os dados foram inseridos
		(if
			(and
			; Solicita o primeiro ponto
				(setq p1 (getpoint "Informe o primeiro ponto: "))

				; Solicita ao usuario informar os dados do trecho
				; Quadrante do rumo
				(progn
					(initget "NE SE SW NW")
					(setq rumo (getkword "\nInforme o rumo [NE SE SW NW]: "))
				) ; end progn

				; Distancia
				(setq dist (getreal "\nInforme a distancia: "))
			
			) ; end and

			; se os dados foram inseridos, faça:
			(while
				(or
					; Angulo (entre 0 e 90 graus)
					(not (setq angulo (getangle "\nInforme o angulo no formato 00d00'00\": ")))
					(> angulo (angtof "90d"))
					; (< (angtof angulo) (angtof "0d"))
				) ; end or
				(progn
					(prompt (strcat "Angulo = " (angtos angulo 1 0)))
					(prompt "\nAngulo invalido.")
					(princ)
				) ; end progn
			) ; end while

			; else = se os dados não foram inseridos, faça
			(setq flag nil)

		) ; end if
	) ; end while

	; Define as variaveis
	(setq

		; Variaveis graficas
		offset 1.5
		textSize 4

		; Variaveis de calculo
		azimute (cond
				((eq rumo "NE") angulo)
				((eq rumo "NW") (- (* 2 PI) angulo))
				((eq rumo "SE") (- PI angulo))
				((eq rumo "SW") (+ PI angulo))
			)
		x1 (car p1)
		y1 (cadr p1)
		dx (* dist (sin azimute))
		dy (* dist (cos azimute))
		x2 (+ x1 dx)
		y2 (+ y1 dy)
		p2 (list x2 y2)
		xm (/ (+ x1 x2) 2)
		ym (/ (+ y1 y2) 2)
		angCADRad (- (/ pi 2) azimute)
		angCADGraus (radToDeg angCADRad)
		pm (list xm ym)
		;pmsup (list (- xm (* offset (sin angCADRad))) (+ ym (* offset (cos angCADRad))))
		;pminf (list (+ xm (* offset (sin angCADRad))) (- ym (* offset (cos angCADRad))))
	)
		
	; Desenha a linha
	(setvar 'clayer nomeLayer)
	(command "LINE" p1 p2 "")

	; Desenha texto da distancia
	(setvar 'clayer "TEXTO")
	(if (< dx 0) (setq angCADGraus (+ angCADGraus 180)))
	(command "TEXT" "S" "Standard" "J" "TC" pm
		(rtos textSize)
		(rtos angCADGraus)
		(strcat (rtos dist 2 2) "m")
	)
	; Desenha texto do rumo
	(command "TEXT" "S" "Standard" "J" "BC" pm
		(rtos textSize)
		(rtos angCADGraus)
		(strcat "Rumo " (vl-string-subst "%%d" "d" (angtos angulo 1 4)) " " rumo)
	)
	(princ)
) ; defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;                                                                       ;;;;;;
;;;;;; DAZIM - DESENHA UM TRECHO COM BASE NO AZIMUTE E DISTÂNCIA FORNECIDOS ;;;;;;
;;;;;                                                                       ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:Dazim () 
	(vl-load-com)
	(setvar 'cmdecho 0)
	
	; Solicita entradas de dados do trecho
	(setq p1 (getpoint "Informe o primeiro ponto: "))

	; Solicita ao usuario informar os dados do trecho
	; Azimute
	(setq azimute (getangle "\nInforme o Azimute no formato 00d00'00\": "))
	; Distancia
	(setq dist (getreal "\nInforme a distancia: "))
	
	; Define as variaveis
	(setq

		; Variaveis graficas
		offset 1.5
		textSize 4

		; Variaveis de calculo
		x1 (car p1)
		y1 (cadr p1)
		dx (* dist (sin azimute))
		dy (* dist (cos azimute))
		x2 (+ x1 dx)
		y2 (+ y1 dy)
		p2 (list x2 y2)
		xm (/ (+ x1 x2) 2)
		ym (/ (+ y1 y2) 2)
		angCADRad (- (/ pi 2) azimute)
		angCADGraus (radToDeg angCADRad)
		pm (list xm ym)
		;pmsup (list (- xm (* offset (sin angCADRad))) (+ ym (* offset (cos angCADRad))))
		;pminf (list (+ xm (* offset (sin angCADRad))) (- ym (* offset (cos angCADRad))))
	)
		
	; Desenha a linha
	(setvar 'clayer "LIMITE")
	(command "LINE" p1 p2 "")

	; Desenha texto da distancia
	(setvar 'clayer "TEXTO")
	(if (< dx 0) (setq angCADGraus (+ angCADGraus 180)))
	(command "TEXT" "S" "Standard" "J" "TC" pm
		(rtos textSize)
		(rtos angCADGraus)
		(strcat (rtos dist 2 2) "m")
	)
	; Desenha texto do rumo
	(command "TEXT" "S" "Standard" "J" "BC" pm
		(rtos textSize)
		(rtos angCADGraus)
		(strcat "Az " (vl-string-subst "%%d" "d" (angtos azimute 1 4)))
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;                                                                       ;;;;;;
;;;;;      RUMO - CALCULA O RUMO E DISTÂNCIA ENTRE DE DOIS PONTOS        ;;;;;;
;;;;;                                                                       ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:RUMO()
	(vl-load-com)
	(setvar 'cmdecho 0)

 	; Solicita o nome da layer
	(setq nomeLayer (getstring "\nInforme o nome da layer a ser utilizada: "))

	; Define as variaveis
	(setq
		; Variaveis graficas
		offset 1.5
		textSize 2
	)
		
	; Solicita entradas de dados do trecho
	(setq flag T)
	(setq p1 (getpoint "\nInforme o primeiro ponto: "))			
	(while flag
		(if
			(and
				(setq p2 (getpoint "\nInforme o proximo ponto: "))
			) ; end and

			; se todos os dados forem inseridos, então faça	
			(progn
				; Calcula variáveis
				(setq
					x1 (car p1)
					y1 (cadr p1)
					x2 (car p2)
					y2 (cadr p2)
					xm (/ (+ x1 x2) 2)
					ym (/ (+ y1 y2) 2)
					dist (distance p1 p2)
					dx (- x2 x1)
					dy (- y2 y1)
				)

				; Desenha a linha
				(setvar 'clayer nomeLayer)
				(command "LINE" p1 p2 "")

				; Desenha texto da distancia
				(setvar 'clayer "TEXTO")
				(setq angCADRad (angle p1 p2))
				(setq anguloRumo (radToDeg angCADRad))
				
				(setq rumo (cond 
					((<= 0 anguloRumo 90) "NE")
					((<= 90 anguloRumo 180) "NW")
					((<= 180 anguloRumo 270) "SW")
					((<= 270 anguloRumo 360) "SE")
				))
				(setq anguloRumo (cond
					((eq rumo "NE") (- 90 anguloRumo))
					((eq rumo "NW") (- anguloRumo 90))
					((eq rumo "SW") (- 270 anguloRumo))
					((eq rumo "SE") (- anguloRumo 270))
				))
	
				(setq angCADGraus (radToDeg angCADRad))
				(setq pm (list xm ym))
				
				(if (< dx 0) (setq angCADGraus (+ angCADGraus 180)))
				(command "TEXT" "S" "Standard" "J" "TC" pm
					(rtos textSize)
					(rtos angCADGraus)
					(strcat (rtos dist 2 2) "m")
				)
			
				; Desenha texto do rumo
				(command "TEXT" "S" "Standard" "J" "BC" pm
					(rtos textSize)
					(rtos angCADGraus)
					(strcat (vl-string-subst "%%d" "d" (angtos (degToRad anguloRumo) 1 4)) " " rumo)
				)
				(setq p1 p2)
			)
			
			; caso os dados não sejam inseridos, saia da rotina
			(setq flag nil)
		
		) ; end if
	)	; if while
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;                                                                       ;;;;;;
;;;;;      AZIM - CALCULA O AZIMUTE E DISTÂNCIA ENTRE DE DOIS PONTOS        ;;;;;;
;;;;;                                                                       ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:azim()
	(vl-load-com)
	(setvar 'cmdecho 0)

  ; Solicita o nome da layer
	(setq nomeLayer (getstring "\nInforme o nome da layer a ser utilizada: "))

	; Define as variaveis
	(setq
		; Variaveis graficas
		offset 1.5
		textSize 2
	)

	
	; Solicita entradas de dados do trecho
	(setq flag T)
	(setq p1 (getpoint "\nInforme o primeiro ponto: "))			
	(while flag
		(if
			(and
				(setq p2 (getpoint "\nInforme o proximo ponto: "))
			) ; end and

			; se todos os dados forem inseridos, então faça	
			(progn
				; Calcula variáveis
				(setq
					x1 (car p1)
					y1 (cadr p1)
					x2 (car p2)
					y2 (cadr p2)
					xm (/ (+ x1 x2) 2)
					ym (/ (+ y1 y2) 2)
					dist (distance p1 p2)
				)


				; Desenha a linha
				(setvar 'clayer nomeLayer)
				(command "LINE" p1 p2 "")

				; Desenha texto da distancia
				(setvar 'clayer "TEXTO")
				(setq angCADRad (angle p1 p2))
				(setq azimute (- (* 5 (/ PI 2)) angCADRad))
				(setq angCADGraus (radToDeg angCADRad))
				(setq pm (list xm ym))
				
				(if (< dx 0) (setq angCADGraus (+ angCADGraus 180)))
				(command "TEXT" "S" "Standard" "J" "TC" pm
					(rtos textSize)
					(rtos angCADGraus)
					(strcat (rtos dist 2 2) "m")
				)
			
				; Desenha texto do rumo
				(command "TEXT" "S" "Standard" "J" "BC" pm
					(rtos textSize)
					(rtos angCADGraus)
					(strcat "Az " (vl-string-subst "%%d" "d" (angtos azimute 1 4)))
				)
				(setq p1 p2)
			)
			
			; caso os dados não sejam inseridos, saia da rotina
			(setq flag nil)
		
		) ; end if
	)	; if while
)