gameplay_main_update:

.check_if_player_is_alive:          ; Is the player alive?
    lda PLAYER_STATUS_HP
    cmp #$00
    bne .update_gameplay            ; Yes, so continue to check gameplay update
                                    
    jmp .update_gameover_state      ; No, perform Game Over                 

.update_gameplay:
    jsr update_pawn_animation
    jsr update_attack_bonus
    jsr update_attack_bonus_enemy
    jsr update_magic_attack_bonus
    
    jmp .update_turn_system

.update_gameover_state:
    ; Do gameover update state
    jmp .exit

;============================== ;
; Turn System Controller        ;
;============================== ;
.update_turn_system:
    lda TS_CURR_PAWN                ; Carico l'indice della pedina da muovere
    cmp #$01                        ; Tocca al player?
    beq .update_move_player_turn    ; Faccio muovere il player
    
    jsr update_enemy_ai

    jmp .exit

.update_move_player_turn:    
    jsr gp_update_player_controls

;:::::::::::::::::::::::::::::::::::::::::::::::
; Update the drop of object after enemy is 
; killed by the player
;:::::::::::::::::::::::::::::::::::::::::::::::
    jsr update_generate_random_drop

.exit:
    rts