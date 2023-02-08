; **********************************************************
; 			  Seção 12 Curso AutoLISP Udemy
;
; Descrição	: Funções de demonstração sobre Symbol Tables	
; Author	: Pedro H. T. Carvalho
; Data		: 16 Dez 2018
;
; **********************************************************

; Demo TBLSEARCH
(defun c:UpdateStyle2()
	; Solicita o nome do novo estilo e valida-o
	(setq newstyle (getstring "\nEnter the new style: "))

	; Caso o novo estilo exista, realize a susbtituição
	(if (tblsearch "style" newstyle)
		(progn 
			; Solicita ao usuário o texto cujo estilo será substituído 
			(setq tx (car (entsel "\nSelect a text to replace with a style: ")))
			(setq txp (entget tx))
			
			; Substitui a propriedade #7 "Textstyle" do texto selecionado
			(setq txpnew (subst (cons 7 newstyle) (assoc 7 txp) txp))
			(entmod txpnew)
			(entupd tx)
		)
		
	; Caso o estilo não exista, informe ao usuário.
		(prompt (strcat "\nStyle " newstyle " does not exist."))
	)
(princ)	
)

; DEMO TBLNEXT
(defun c:DisplayLayers()
	; Cicle entre as layers até que todas tenham sido acessadas
	(setq flag T)
	(setq lprop (tblnext "layer" T))
	(while flag 
		; Para cada layer válida, imprima o nome.
		; Ao final, informe a variável de controle (flag = nil)
		(setq lname (cdr (assoc 2 lprop)))
		(if (/= lname nil)
			(prompt (strcat "\nLayer name: " lname))
			(setq flag nil)
		)
		(setq lprop (tblnext "layer"))
	)
(princ)
)