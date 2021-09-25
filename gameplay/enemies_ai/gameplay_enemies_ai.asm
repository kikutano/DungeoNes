;:::::::::::::::::::::::::::::::::::::::::
; update_enemy_ai
;:::::::::::::::::::::::::::::::::::::::::
update_enemy_ai:
    lda TS_CURR_PAWN
    cmp #$02
    beq .update_enemy_ai_0
    cmp #$03
    beq .update_enemy_ai_1
    cmp #$04
    beq .update_enemy_ai_2

    jmp .exit

.update_enemy_ai_0:
    jsr update_enemy_ai_0
    jmp .exit

.update_enemy_ai_1:
    jsr update_enemy_ai_1
    jmp .exit

.update_enemy_ai_2:
    jsr update_enemy_ai_2
    jmp .exit

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; update_ai_thiking_time
;:::::::::::::::::::::::::::::::::::::::::
update_ai_thiking_time:
    lda TS_TICKING_TICKS
    cmp #$1D                ; <- THINKING SPEED
    beq .think_time_passed

    inc TS_TICKING_TICKS

    jmp .exit

.think_time_passed:
    lda #$00
    sta TS_TICKING_TICKS

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; update_enemy_ai_0
;:::::::::::::::::::::::::::::::::::::::::
update_enemy_ai_0:
    lda EN_0_STATUS_HP
    cmp #$00
    bne .can_turn
    
    jsr turn_system_increase

    jmp .exit

.can_turn:

    jsr update_ai_thiking_time

    lda TS_TICKING_TICKS
    cmp #$00
    bne .exit

    lda #low( RAM_ENEMY_0 )
    sta ENEMY_PTR + 0
    lda #high( RAM_ENEMY_0 )
    sta ENEMY_PTR + 1

    lda #low( ENEMY_0_CELL_INDEX )
    sta GENERIC_PTR + 0
    lda #high( ENEMY_0_CELL_INDEX )
    sta GENERIC_PTR + 1

    jsr ai_perform_next_move

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; update_enemy_ai_1
;:::::::::::::::::::::::::::::::::::::::::
update_enemy_ai_1:
    lda EN_1_STATUS_HP
    cmp #$00
    bne .can_turn
    
    jsr turn_system_increase

    jmp .exit

.can_turn:
    jsr update_ai_thiking_time

    lda TS_TICKING_TICKS
    cmp #$00
    bne .exit

    lda #low( RAM_ENEMY_1 )
    sta ENEMY_PTR + 0
    lda #high( RAM_ENEMY_1 )
    sta ENEMY_PTR + 1

    lda #low( ENEMY_1_CELL_INDEX )
    sta GENERIC_PTR + 0
    lda #high( ENEMY_1_CELL_INDEX )
    sta GENERIC_PTR + 1

    jsr ai_perform_next_move

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; update_enemy_ai_2
;:::::::::::::::::::::::::::::::::::::::::
update_enemy_ai_2:
    lda EN_2_STATUS_HP
    cmp #$00
    bne .can_turn
    
    jsr turn_system_increase

    jmp .exit

.can_turn:
    jsr update_ai_thiking_time

    lda TS_TICKING_TICKS
    cmp #$00
    bne .exit

    lda #low( RAM_ENEMY_2 )
    sta ENEMY_PTR + 0
    lda #high( RAM_ENEMY_2 )
    sta ENEMY_PTR + 1

    lda #low( ENEMY_2_CELL_INDEX )
    sta GENERIC_PTR + 0
    lda #high( ENEMY_2_CELL_INDEX )
    sta GENERIC_PTR + 1

    jsr ai_perform_next_move

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; ai_perform_next_move
;:::::::::::::::::::::::::::::::::::::::::
ai_perform_next_move:
    ldy #$00
    lda [ENEMY_PTR], y    
    cmp RAM_PLAYER  + 0           ; Prendiamo la Y del nemico
    beq .player_is_same_row
    cmp RAM_PLAYER  + 0
    bcs .player_is_up

    jmp .player_is_down

    jmp .exit

.player_is_up:
    jsr move_pawn_up

    jmp .exit

.player_is_same_row:
    ldy #$03
    lda [ENEMY_PTR], Y
    cmp RAM_PLAYER + 3
    bcc .player_is_right

.player_is_left:
    jsr move_pawn_left

    jmp .exit

.player_is_right:
    jsr move_pawn_right

    jmp .exit

.player_is_down:
    jsr move_pawn_down

    jmp .exit

.exit:
    rts