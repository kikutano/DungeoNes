;gameplay_turn_system

;:::::::::::::::::::::::::::::::::::::::::
; turn_system_init 
;:::::::::::::::::::::::::::::::::::::::::
turn_system_init:

    ; Carichiamo le stats dei nemici nella stanza
    jsr cs_init_pawns_en_stats 

    ; Resettiamo il counter del turno
    lda #$00
    sta TS_COUNTER

    lda #low( RAM_PLAYER )
    sta PAWN_PTR + 0
    lda #high( RAM_PLAYER )
    sta PAWN_PTR + 1
    
    ; Il primo a spostare sarà sempre il player ( #$01 )
    lda #$01
    sta TS_CURR_PAWN
    
    ; Selezioniamo la cella in cui è presente il player
    lda CELLS_PAWNS_OCCS_ARRAY + 0
    sta CELL_SELECTED
    lda CELLS_PAWNS_OCCS_ARRAY + 4
    sta CELL_SELECTED_PREV

    ; Settiamo il CURRENT_SENDER
    jsr cs_set_current_pawn_stats_as_sender

    ; Abilitiamo l'input
    jsr enable_input

    rts

;:::::::::::::::::::::::::::::::::::::::::
; turn_system_increase
;:::::::::::::::::::::::::::::::::::::::::
turn_system_increase:
    lda #$00
    sta TS_TICKING_TICKS
    
    inc TS_COUNTER

    ldy TS_COUNTER
    ;lda [ROOM_TURNS_TO_LOAD_ADDR], y
    lda pawn_turns, y
    cmp #$FF                            ; E' un fine turno?
    beq .reset_turn_system              ; Resetto

    jmp .set_current_pawn

.reset_turn_system:
    lda #$00
    sta TS_COUNTER

    lda #$01
    sta TS_CURR_PAWN ; Il primo a spostare sarà sempre il player ( #$01 )
    
    jsr enable_input

.set_current_pawn:

    ldy TS_COUNTER
    ;lda [ROOM_TURNS_TO_LOAD_ADDR], y
    lda pawn_turns, y
    sta TS_CURR_PAWN
    
    lda TS_CURR_PAWN
    cmp #$01
    beq .set_player_as_curr_pawn
    cmp #$02
    beq .set_en_0_as_curr_pawn
    cmp #$03
    beq .set_en_1_as_curr_pawn
    cmp #$04
    beq .set_en_2_as_curr_pawn

.set_player_as_curr_pawn:
    lda #low( RAM_PLAYER )
    sta PAWN_PTR + 0
    lda #high( RAM_PLAYER )
    sta PAWN_PTR + 1

    lda CELLS_PAWNS_OCCS_ARRAY + 0

    jmp .skip_set_curr_pawn

.set_en_0_as_curr_pawn:
    lda #low( RAM_ENEMY_0 )
    sta PAWN_PTR + 0
    lda #high( RAM_ENEMY_0 )
    sta PAWN_PTR + 1

    lda CELLS_PAWNS_OCCS_ARRAY + 1
    
    jmp .skip_set_curr_pawn

.set_en_1_as_curr_pawn:
    lda #low( RAM_ENEMY_1 )
    sta PAWN_PTR + 0
    lda #high( RAM_ENEMY_1 )
    sta PAWN_PTR + 1

    lda CELLS_PAWNS_OCCS_ARRAY + 2

    jmp .skip_set_curr_pawn

.set_en_2_as_curr_pawn:
    lda #low( RAM_ENEMY_2 )
    sta PAWN_PTR + 0
    lda #high( RAM_ENEMY_2 )
    sta PAWN_PTR + 1

    lda CELLS_PAWNS_OCCS_ARRAY + 3
    
.skip_set_curr_pawn:
    sta CELL_SELECTED_PREV
    ; Settiamo il CURRENT_SENDER
    jsr cs_set_current_pawn_stats_as_sender

.exit:
    rts