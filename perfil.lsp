;;;;;;;;;;;;;;;;;;;;;;; Comando PERFIL - Desenha o perfil do PV, solicitando as variáveis ao usuário ;;;;;;;;;;;;;;;;
;; Chama a rotina VBA
  
(defun c:perfil ()
  ;;;;;;;;;;;;;;;; Inicializa as variaveis ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (vl-load-com)
  (setvar 'cmdecho 0)
  (vl-vbarun "Perfil-v2.dvb!Main.ShowForm")
  (princ)
) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;