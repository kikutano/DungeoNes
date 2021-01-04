gameplay_main_update:

    jsr update_pawn_animation
    jsr update_attack_bonus
    jsr update_attack_bonus_enemy
    jsr update_magic_attack_bonus
    
;============================== ;
; Turn System Controller        ;
;============================== ;
    lda TS_CURR_PAWN                ; Carico l'indice della pedina da muovere
    cmp #$01                        ; Tocca al player?
    beq .update_move_player_turn     ; Faccio muovere il player
    
    jsr update_enemy_ai

    jmp .exit

.update_move_player_turn:    
    jsr gp_update_player_controls

.exit:
    rts