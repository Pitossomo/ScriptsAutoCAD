;;;;;;;;;;;;;;;;;;;;;;; Comandos para trabalhar com o cadastro digital - Desenha o perfil do PV, solicitando as variáveis ao usuário ;;;;;;;;;;;;;;;;
;; Ver. 001
;;;;;;;;;;;;;;;;;;;;; Função SelectLine ;;;;;;;;;;;;;;;;;;;;;;;
(defun selectLine ()
  (while
    (not
      (setq
				esel (entsel (strcat "\nSelecione uma linha: "))
        edata (if esel (entget (car esel)))
        etype (if esel (cdr (assoc 0 edata)))
			) ; setq
			(wcmatch etype "LINE")
    ) ; not
    (prompt "\nSeleção inadequada. Selecione uma linha valida.")
  ) ; while
) ; defun

;;;;;;;;;;;;;;;;;;;;; Função textAligned ;;;;;;;;;;;;;;;;;;;;;;;
; Insere um texto alinhado a uma linha em um ponto especificado pelo usuário
(defun textAligned (textStr linha / acadObj acadDoc modelSpace hTexto angText ptText textEnt)
  ; Inicializa variaveis
  (vl-load-com)
  (setvar "CMDECHO" 0)
  ; Autocad
  (setq acadObj (vlax-get-acad-object))
  (setq acadDoc (vla-get-ActiveDocument acadObj))
  (setq modelSpace (vla-get-ModelSpace acadDoc))
  ; Textos
  (setq hTexto 0.2)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Inicio do codigo ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; Calcula o angulo da linha
  ; TODO
  (setq angText 0)
  
  ; Seleciona o ponto
  (setq ptText (getpoint "\n Selecione o ponto central do texto: "))
  (setq ptText (vlax-3d-point (car ptText) (cadr ptText) 0.0))

  ; Insere, justifica e rotaciona o texto
  (setq textEnt (vla-addText modelSpace textStr ptText hTexto))
  (justifyText textEnt acAlignmentMiddleCenter)
  (rotateText textEnt angText)
(princ)
) ; defun

  
;;;;;;;;;;;;;;;;;;;;; Comando LDCOORDS ;;;;;;;;;;;;;;;;;;;;
; Insere um Leader com as coordenadas UTM (ie. coordenadas X e Y)
; Funciona APENAS SE os pontos estiverem locados com as coordenadas originais,
; Ou seja, coord. X = coordenada E, e coord. Y = N)
(defun c:LDCOORDS (/ acadObj acadDoc modelSpace offsetTextos prCoords dxLd flag hTexto ptSeta ptText x1 x2 x3 y1 y2 y3 textVar points leaderObj)
  ; Inicializa variaveis
  (vl-load-com)
  (setvar "CMDECHO" 0)
  ; Autocad
  (setq acadObj (vlax-get-acad-object))
  (setq acadDoc (vla-get-ActiveDocument acadObj))
  (setq modelSpace (vla-get-ModelSpace acadDoc))
  ; Textos
  (setq offsetTextos 0.1)
  (setq prCoords 2)
  (setq hTexto 1)
  ;; Leaders ;;
  (setq dXLd (- (* 12.5 hTexto)))	; Dimensão da linha horizontal do Leader
  ;(setq prjXLd -5)			; Projeção horizontal da linha de chamada do Leader X
  ;(setq prjYLd -10)			; Projeção vertical da linha de chamada do Leader X
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Inicio do codigo ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
  (setq flag T)
  (while flag
    ; Define os pontos
    (if (setq ptSeta (getpoint "\n Selecione o ponto: "))
      (progn
	; Seleciona o 2o ponto
	(setq ptText (getpoint "\n Selecione o local do texto: "))
	; Calcula as coordenadas
	
	(setq x1 (car ptSeta) y1 (cadr ptSeta))
	(setq x2 (car ptText) y2 (cadr ptText))
	(setq x3 (+ x2 dxLd) y3 y2)
	    
	; Adiciona o Leader
	(setq textVar (vla-addMText modelSpace (vlax-3d-point x3 y3 0) 1 ""))
  	(setq points (vlax-make-safearray vlax-vbDouble '(0 . 8)))
  	(vlax-safearray-fill points (list x1 y1 0 x2 y2 0 x3 0 0))
	(setq leaderObj (vla-AddLeader modelSpace points textVar acLineWithArrow))
	(vla-Erase textVar)

	; Add o texto superior do leader
  	(vla-addText modelSpace (strcat "N " (rtos y1 2 prCoords)) (vlax-3d-point x3 (+ y3 offsetTextos) 0) hTexto )
	; Add o texto inferior do leader
  	(vla-addText modelSpace (strcat "E " (rtos x1 2 prCoords)) (vlax-3d-point x3 (- y3 offsetTextos hTexto ) 0) hTexto )
	) ; end progn
      
      (setq flag nil)
      
    ) ; end if
  ) ; end while
  (prompt "\nComando concluido.")
  (princ)
) ; end defun

;;;;;;;;;;;;;;;;;; FUNÇÃO rotateText ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Alinha o texto no alinhamento desejado
; textVar = Objeto vla-Text
; angVar = Angulo a rotacionar, em graus
(defun rotateText(textVar angVar)
  (if (vlax-property-available-p textVar 'Rotation T)
    (progn
      (vlax-put-property textVar 'Rotation (/ (* angVar 3.1415) 180))
      (vlax-release-object textVar)
    ) ; progn
    (prompt "Unable to change the text")
  ) ; if
  (princ)
)

;;;;;;;;;;;;;;;;;; FUNÇÃO justifyText ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Alinha o texto no alinhamento desejado
; textVar = Objeto vla-Text
; alignVar = acAlignmentBottomRight, acAlignmentMiddleCenter, etc.
(defun justifyText(textVar alignVar)
  (if (vlax-property-available-p textVar 'Alignment T)
    (progn
      (setq int_pt (vlax-get-property textVar 'InsertionPoint))
      (vlax-put-property textVar 'Alignment alignVar)
      (vlax-put-property textVar 'TextAlignmentPoint int_pt)
      (vlax-release-object textVar)
    ) ; progn
    (prompt "\nUnable to change the text")
  ) ; if
  (princ)
)


