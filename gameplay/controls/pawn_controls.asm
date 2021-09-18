;:::::::::::::::::::::::::::::::::::::::::
; Move Pawn Down
;:::::::::::::::::::::::::::::::::::::::::
move_pawn_down:
    lda #$08                    ; Aggiungiamo 8
    sta SUM_VALUE_TO_INC_CELL
    lda #$01
    sta AN_JUMP_DIR_FACTOR
    jsr perform_dir_button_pressed
    cmp #$01
    beq .can_move

    jmp .exit

.can_move:
    jsr set_pawn_for_tranlastion
    lda #GFX_SPRITE_TRANS_DOWN
    jsr set_pawn_start_translation
    
.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; Move Pawn Up
;:::::::::::::::::::::::::::::::::::::::::
move_pawn_up:
    ; Aggiungendo 248, ci ritroveremo 
    ; con una sottrazione di 8 dell'attuale valore!
    lda #$F8                     
    sta SUM_VALUE_TO_INC_CELL
    lda #$00                    
    sta AN_JUMP_DIR_FACTOR
    jsr perform_dir_button_pressed
    cmp #$01
    beq .can_move

    jmp .exit

.can_move:
    jsr set_pawn_for_tranlastion
    lda #GFX_SPRITE_TRANS_UP
    jsr set_pawn_start_translation

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; Move Pawn Right
;:::::::::::::::::::::::::::::::::::::::::
move_pawn_right:
    lda #$01
    sta SUM_VALUE_TO_INC_CELL
    sta AN_JUMP_DIR_FACTOR
    jsr flip_sprite_pawn_to_right
    jsr perform_dir_button_pressed
    cmp #$01
    beq .can_move

    jmp .exit

.can_move:

    lda #$01
    sta AN_JUMP_DIR_FACTOR

    jsr set_pawn_for_tranlastion
    lda #GFX_SPRITE_TRANS_RIGHT
    jsr set_pawn_start_translation

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; Move Pawn Left
;:::::::::::::::::::::::::::::::::::::::::
move_pawn_left:
    ; Aggiungendo 255, ci ritroveremo 
    ; con una sottrazione di 1 dell'attuale valore!
    lda #$FF
    sta SUM_VALUE_TO_INC_CELL
    sta AN_JUMP_DIR_FACTOR
    jsr flip_sprite_pawn_to_left
    jsr perform_dir_button_pressed
    cmp #$01
    beq .can_move

    jmp .exit

.can_move:
    jsr set_pawn_for_tranlastion
    lda #GFX_SPRITE_TRANS_LEFT
    jsr set_pawn_start_translation

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; button_pressed_A
;:::::::::::::::::::::::::::::::::::::::::
button_pressed_A:
    lda CELL_INDICATOR_ON
    cmp #$01
    beq .perform_special_selected

.perform_show_indicator:
    jsr on_indicator_show
    jmp .exit

.perform_special_selected:
    jsr on_perform_special_move
    
.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; button_pressed_B
;:::::::::::::::::::::::::::::::::::::::::
button_pressed_B:
    jsr on_undo_special_move
    rts

;:::::::::::::::::::::::::::::::::::::::::
; button_pressed_SELECT
;:::::::::::::::::::::::::::::::::::::::::
button_pressed_SELECT:
    jsr on_next_slot_selected
    rts

;:::::::::::::::::::::::::::::::::::::::::
; Translation Animation Done
;:::::::::::::::::::::::::::::::::::::::::
on_move_pawn_done:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; sprite_animation_done
;:::::::::::::::::::::::::::::::::::::::::
sprite_animation_done:
    jsr cs_sprite_an_done
    rts

;:::::::::::::::::::::::::::::::::::::::::
; sprite_on_half_animation_done
;:::::::::::::::::::::::::::::::::::::::::
sprite_on_half_animation_done:
    jsr cs_sprite_on_half_done
    rts

;:::::::::::::::::::::::::::::::::::::::::
; attack_pawn_done
;:::::::::::::::::::::::::::::::::::::::::
attack_pawn_done:
    jsr cell_indicator_hide
    rts

;:::::::::::::::::::::::::::::::::::::::::
; attack_stats_showed_done
;:::::::::::::::::::::::::::::::::::::::::
attack_stats_showed_done:
    jsr enable_input
    rts

;:::::::::::::::::::::::::::::::::::::::::
;perform_dir_button_pressed
;:::::::::::::::::::::::::::::::::::::::::
perform_dir_button_pressed:

    lda CELL_INDICATOR_ON
    cmp #$00
    beq .perform_move_pawn

    jsr move_indicator

    jmp .exit

.perform_move_pawn:
    jsr perform_move_or_attack_next_cell

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; perform_move_or_attack_next_cell
; [A]=$01 se può arrivare a quella cella,    
; [A]=$00 altrimenti. 
;:::::::::::::::::::::::::::::::::::::::::
perform_move_or_attack_next_cell:
    jsr get_current_pawn_cell_pos
    lda CURR_PAWN_CELL_POS
    clc 
    adc SUM_VALUE_TO_INC_CELL
    sta TEMP_A
    tax
    lda RAM_ROOM_CELLS, x
    cmp #MAP_EMPTY_FLOOR_00
    beq .perform_walk
    cmp #MAP_EMPTY_FLOOR_01
    beq .perform_walk
    cmp #MAP_CELL_DOOR_DOWN
    beq .perform_walk
    cmp #MAP_CELL_DOOR_UP
    beq .perform_walk
    cmp #MAP_CELL_DOOR_LEFT
    beq .perform_walk
    cmp #MAP_CELL_DOOR_RIGHT
    beq .perform_walk
    cmp #CELL_POTION
    beq .perform_walk
    cmp #CELL_ENEMY_0
    beq .perform_attack
    cmp #CELL_ENEMY_1
    beq .perform_attack
    cmp #CELL_ENEMY_2
    beq .perform_attack
    cmp #CELL_PLAYER
    beq .perform_attack

    lda #$00
    jmp .exit

.perform_walk:
    lda TEMP_A
    sta CELL_SELECTED

    lda #$01
    jmp .exit

.perform_attack:
    lda TEMP_A
    sta CELL_SELECTED
    jsr on_perform_brawl_attack
    jsr disable_input

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; move_cell_selector
;:::::::::::::::::::::::::::::::::::::::::
move_indicator:
    lda CELL_INDICATOR_POS
    clc 
    adc SUM_VALUE_TO_INC_CELL
    sta TEMP_A
    tax
    lda RAM_ROOM_CELLS, x
    cmp #MAP_EMPTY_FLOOR_00
    beq .can_move
    cmp #MAP_EMPTY_FLOOR_01
    beq .can_move
    cmp #CELL_ENEMY_0
    beq .can_move
    cmp #CELL_ENEMY_1
    beq .can_move
    cmp #CELL_ENEMY_2
    beq .can_move

    jmp .exit

.can_move:
    lda CELLS_PAWNS_OCCS_ARRAY + 0  ; Carico la posizione del player
    sta CELL_START
    lda TEMP_A
    sta CELL_TO_REACH           

    jsr mahanattan_distance         ; Verifico la distanza
    cmp SM_CELLS_MAX_SEL            ; E' minore?
    bcs .exit

    lda TEMP_A                      ; Allora posso muovere e aggiornare
    sta CELL_INDICATOR_POS          ; l'indicatore

    jsr cell_indicator_show

.exit:
    rts