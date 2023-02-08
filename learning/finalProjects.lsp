; ******************************************************
; 		Projeto final Curso AutoLISP Udemy
; Author	: Pedro H. T. Carvalho
; Data		: 17 Dez 2018
; **********************************************************

; Função CDIM
; Verifica texto de cotas modificados e altera sua cor para vermelho
(defun c:CDIM()
	(setvar "cmdecho" 0)
	(setq ctr 0)
	
	; Busca as cotas no desenho
	(setq dims (ssget "X" '((0 . "DIMENSION"))))
	(if (/= dims nil)
		(progn
		; Seleciona as cotas com textos modificados e muda sua cor
			; Cria uma lista vazia para as cotas modificadas
			(setq mdims (ssadd))	
			
			; Cicla entre as cotas
			(setq dimcount (sslength dims))
			(while (/= ctr dimcount)
				(setq dnam (ssname dims ctr))
				(setq pnam (entget dnam))
				(setq dimtx (cdr (assoc 1 pnam)))
				
				; Checa se texto da cota difere da distância entre as linhas
				(if (/= dimtx "")
					; Se diferir, adiciona a cota à lista de cotas modificadas
					(setq mdims (ssadd dnam mdims))
				)
				(setq ctr (1+ ctr))
			)
			; Checa se há elementos na lista de cotas modificadas
			(if (/= sslength mdims) 0
				(progn 
					; Altera a cor do texto para vermelho
					(command "chprop" mdims "" "c" "red")
					(prompt (strcat "\nForam encontradas " (itoa (sslength mdims)) " cotas modificadas."
					(prompt "Por favor, verifique as cotas que estão com cor vermelha")
				)
		)
		; Informar ao usuário se não houver cotas no desenho
		(prompt "\nNão foram encontradas cotas no desenho.")
	)
(princ)
)