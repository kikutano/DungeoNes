;dungeon_room_manager

;:::::::::::::::::::::::::::::::::::::::::
; update_random_room_selector
;:::::::::::::::::::::::::::::::::::::::::
update_random_room_selector:
    lda ROOM_RANDOM_SELECTOR_COUNT
    cmp #ROOM_RANDOM_SIZE
    beq .reset_room_selector

    inc ROOM_RANDOM_SELECTOR_COUNT
    jmp .exit

.reset_room_selector:
    lda #$00
    sta ROOM_RANDOM_SELECTOR_COUNT

    lda #$01
    sta ROOM_RANDOM_SELECTOR_COUNT
.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; init_room_specs_on_memory
; Inizializza tutti i puntatori in memoria per il 
; caricamento dinamico dei livelli.
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
init_room_specs_on_memory:
  ;lda CURRENT_ROOM_COUNTER
  lda ROOM_RANDOM_SELECTOR_COUNT
  asl a
  tax
  
  ;matrice di occupazione
  lda level_0_occs_rooms     + 0, x
  sta ROOM_OCCS_TO_LOAD_ADDR + 0
  lda level_0_occs_rooms     + 1, x
  sta ROOM_OCCS_TO_LOAD_ADDR + 1 

  ;nemici
  lda level_0_rooms_enemies     + 0, x
  sta ROOM_ENEMIES_TO_LOAD_ADDR + 0
  lda level_0_rooms_enemies     + 1, x
  sta ROOM_ENEMIES_TO_LOAD_ADDR + 1 
  
  ;doors
  ;lda level_0_doors_links     + 0, x
  ;sta ROOM_DOORS_TO_LOAD_ADDR + 0
  ;lda level_0_doors_links     + 1, x
  ;sta ROOM_DOORS_TO_LOAD_ADDR + 1
  rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; go_to_next_room
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
go_to_next_room:
    ; Carichiamo i valori delle porte sulla mappa,
    ; prima che venga caricata.
    lda [ROOM_DOORS_TO_LOAD_ADDR], y
    sta CURRENT_ROOM_COUNTER
    
    lda #GAME_STATE_FADE_OUT_MATRIX     ; Impostiamo il Game State per caricare con il Fade
    sta GAME_STATE

    jsr init_room_specs_on_memory       ; Carichiamo il successivo
    jsr turn_system_init
    
    lda #$21
    sta MATRIX_FADE_OUT_COL_ADDR_LOW    ; Impostiamo l'indirizzo di partenza
    lda #$13
    sta MATRIX_FADE_OUT_COL_ADDR_HIGH   
    rts

;:::::::::::::::::::::::::::::::::::::::::
; Update Matrix Cells Occupations
;:::::::::::::::::::::::::::::::::::::::::
update_matrix_cells_occs:

    jsr get_current_pawn_cell_pos
    
    ldy CURR_PAWN_CELL_POS      ; Carichiamo in Y la posizione della pedina che sta muovendo
    lda RAM_ROOM_CELLS, y
    cmp #CELL_PLAYER
    beq .set_prev_cell_as_free
    cmp #CELL_ENEMY_0
    beq .set_prev_cell_as_free
    cmp #CELL_ENEMY_1
    beq .set_prev_cell_as_free
    cmp #CELL_ENEMY_2
    beq .set_prev_cell_as_free

    jmp .update_cell_grid_occs

.set_prev_cell_as_free:
    lda #MAP_EMPTY_FLOOR_00         ; Se nella casella c'è una pedina, allora liberiamo la cella
    sta RAM_ROOM_CELLS, y
    
    ldy TS_COUNTER                  ; Carico in Y l'index del turno
    lda CURR_PAWN_CELL_POS          ; Prendo l'attuale posizione
    iny 
    iny
    iny
    iny
    sta CELLS_PAWNS_OCCS_ARRAY, y   ; La metto nell'array di occupazione per le celle precedenti

.update_cell_grid_occs:
    lda CURR_PAWN_CELL_POS
    clc 
    adc SUM_VALUE_TO_INC_CELL
    sta CURR_PAWN_CELL_POS
    ldy CURR_PAWN_CELL_POS
    lda CURR_PAWN_TYPE
    sta RAM_ROOM_CELLS, y

    ldy TS_COUNTER                  ; Carichiamo in Y l'index del turno
    lda CURR_PAWN_CELL_POS          ; Carichiamo la posizione
    sta CELLS_PAWNS_OCCS_ARRAY, y   ; Aggiorniamo l'array con le celle di occupazione

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; get_current_pawn_cell_pos:
; Restituisce in [A] la posizione nella
; matrice, della pedina che sta attualmente
; muovendo.
;:::::::::::::::::::::::::::::::::::::::::
get_current_pawn_cell_pos:
    ldy TS_COUNTER
    ;lda [ROOM_TURNS_TO_LOAD_ADDR], y
    lda pawn_turns, y
    cmp #$01
    beq .set_curr_pawn_type_player
    cmp #$02
    beq .set_curr_pawn_type_en_0
    cmp #$03
    beq .set_curr_pawn_type_en_1
    cmp #$04
    beq .set_curr_pawn_type_en_2

    jmp .exit

.set_curr_pawn_type_player
    lda CELLS_PAWNS_OCCS_ARRAY + 0
    sta CURR_PAWN_CELL_POS
    lda #CELL_PLAYER
    jmp .exit

.set_curr_pawn_type_en_0:
    lda CELLS_PAWNS_OCCS_ARRAY + 1
    sta CURR_PAWN_CELL_POS
    lda #CELL_ENEMY_0
    jmp .exit

.set_curr_pawn_type_en_1:
    lda CELLS_PAWNS_OCCS_ARRAY + 2
    sta CURR_PAWN_CELL_POS
    lda #CELL_ENEMY_1
    jmp .exit

.set_curr_pawn_type_en_2:
    lda CELLS_PAWNS_OCCS_ARRAY + 3
    sta CURR_PAWN_CELL_POS
    lda #CELL_ENEMY_2
    jmp .exit

.exit:
    sta CURR_PAWN_TYPE
    rts

;:::::::::::::::::::::::::::::::::::::::::
; mahanattan_distance
;:::::::::::::::::::::::::::::::::::::::::
mahanattan_distance:
    lda CELL_START
    jsr get_row_cell_pos_on_grid
    sta AN_SPRITE_X

    lda CELL_START
    jsr get_column_cell_pos_on_grid
    sta AN_SPRITE_Y

    lda CELL_TO_REACH
    jsr get_row_cell_pos_on_grid
    sta AN_SPRITE_X_0

    lda CELL_TO_REACH
    jsr get_column_cell_pos_on_grid
    sta AN_SPRITE_Y_0

    lda AN_SPRITE_X
    cmp AN_SPRITE_X_0
    bcc .x_0_minus_x 

.x_minus_x_0:
    lda AN_SPRITE_X
    sec
    sbc AN_SPRITE_X_0

    jmp .continue_y

.x_0_minus_x:
    lda AN_SPRITE_X_0
    sec
    sbc AN_SPRITE_X

.continue_y:
    sta AN_SPRITE_X

    lda AN_SPRITE_Y
    cmp AN_SPRITE_Y_0
    bcc .y_0_minus_y 

.y_minus_y_0:
    lda AN_SPRITE_Y
    sec
    sbc AN_SPRITE_Y_0

    jmp .continue

.y_0_minus_y:
    lda AN_SPRITE_Y_0
    sec
    sbc AN_SPRITE_Y

.continue:
    sta AN_SPRITE_Y
    clc
    adc AN_SPRITE_X

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; set_player_on_cell
;:::::::::::::::::::::::::::::::::::::::::
set_player_on_cell:
    ;for X
    lda CURRENT_CELL_POINTER
    and #7 ; A % 8
    asl A
    asl A
    asl A
    asl A ; A * 16
    clc
    adc #$20 ; A + offset_x
    
    sta RAM_PLAYER + 3
    sta RAM_PLAYER + 11
    clc
    adc #8 ; A + 8
    sta RAM_PLAYER + 7
    sta RAM_PLAYER + 15
    
    ;fox Y
    lda CURRENT_CELL_POINTER
    lsr A
    lsr A
    lsr A ; A / 8
    asl A
    asl A
    asl A
    asl A; A * 16
    clc
    
    ;and #%11111000  ; clear out the low 3 bits which were supposed to be dropped off the right side by LSR
    ;asl A           ; A * 2 (3x ASL cancels 3x LSR, so only 1x ASL is left)

    adc #$39            ; A + oy
    sta RAM_PLAYER + 0
    sta RAM_PLAYER + 4
    adc #$08
    sta RAM_PLAYER + 8
    sta RAM_PLAYER + 12

    lda CURRENT_CELL_POINTER        ; Mettiamo la cella occupata dal player nella prima posizione
    sta CELLS_PAWNS_OCCS_ARRAY + 0  ; dell'array delle pedine

    rts

;:::::::::::::::::::::::::::::::::::::::::
; set_player_on_next_door2
;:::::::::::::::::::::::::::::::::::::::::
set_player_on_next_door2:
    jsr flip_sprite_pawn_to_right

    ;Cerchiamo la porta di ingresso della stanza successiva
    ldx #$00
    .room_enter_search_loop:
        lda RAM_ROOM_CELLS, x
        cmp PLAYER_ON_CELL_VALUE
        beq .room_enter_search_loop_exit
        inx
        cpx #$FF
        bne .room_enter_search_loop

    .room_enter_search_loop_exit:
        txa 
        sta CURRENT_CELL_POINTER
    
    jsr set_player_on_cell
    rts

;:::::::::::::::::::::::::::::::::::::::::
; set_x_y_coords_from_cell_pos
;:::::::::::::::::::::::::::::::::::::::::
set_x_y_coords_from_cell_pos:
    
    ;for X
    lda CELL_TO_POINT
    and #7                      ; A % 8
    asl A
    asl A
    asl A
    asl A                       ; A * 16
    clc
    adc #$20                    ; A + offset_x
    
    sta AN_SPRITE_X

    ;fox Y
    lda CELL_TO_POINT
    lsr A
    lsr A
    lsr A                       ; A / 8
    asl A
    asl A
    asl A
    asl A                       ; A * 16
    clc
    adc #$39                    ; A + oy

    sta AN_SPRITE_Y
    
    rts

;:::::::::::::::::::::::::::::::::::::::::
; get_row_cell_pos_on_grid
; Restituisce la riga della cella caricata
; in A.
;:::::::::::::::::::::::::::::::::::::::::
get_row_cell_pos_on_grid:
    lsr A
    lsr A
    lsr A ; A / 8
    rts

;:::::::::::::::::::::::::::::::::::::::::
; get_column_cell_pos_on_grid
; Restituisce la colonna della cella caricata
; in A.
;:::::::::::::::::::::::::::::::::::::::::
get_column_cell_pos_on_grid:
    and #7 ;A % 8
    rts

;:::::::::::::::::::::::::::::::::::::::::
; remove_pawn_from_grid
;:::::::::::::::::::::::::::::::::::::::::
remove_pawn_from_grid:
    tax
    lda #MAP_EMPTY_FLOOR_00
    sta RAM_ROOM_CELLS, x
    rts

;::::::::::::::::::::::::::::::::::::
; load_lvl_items
;::::::::::::::::::::::::::::::::::::
load_lvl_items:
    lda #low( RAM_ENEMY_0 )
    sta PTR_RAM_ITEM + 0
    lda #high( RAM_ENEMY_0 )
    sta PTR_RAM_ITEM + 1

    lda #low( ENEMY_0_CELL_INDEX )
    sta GENERIC_PTR + 0
    lda #high( ENEMY_0_CELL_INDEX )
    sta GENERIC_PTR + 1

    lda #$00
    sta CELL_TO_POINT
    sta TEMP_A_1

    ldy #$00
    .loop:
        lda RAM_ROOM_CELLS, y
        sta CELL_CONTAINER
        jsr load_item
        inc CELL_TO_POINT
        
        iny
        cpy #$40
        bne .loop
    rts

;::::::::::::::::::::::::::::::::::::
; load_next_item_on_map
;::::::::::::::::::::::::::::::::::::
load_next_item_on_map:

    ; sprites_bat_idle_0:
    ; .db $04, $05, $14, $15, %00000011
    ; sprites_bat_idle_1:
    ; .db $24, $25, $34, $35
    
    ;up_left_sprite
    ldy #$04                    ; Carico le proprietà della palette che è alla 4°
    lda [PTR_ITEM_TO_LOAD], y   ; posizione dell'array
    sta TEMP_A 

    ldy #$00                    ; Carico il primo tile
    lda [PTR_ITEM_TO_LOAD], y   
    iny
    sta [PTR_RAM_ITEM], y       ; Lo metto nella sua corrispondente in RAM
    iny
    lda TEMP_A                  ; Carico il valore della palette
    sta [PTR_RAM_ITEM], y       ; La metto nella sua corrispondente in RAM

    ;up_left_sprite
    ldy #$01
    lda [PTR_ITEM_TO_LOAD], y
    ldy #$05
    sta [PTR_RAM_ITEM], y 
    iny
    lda TEMP_A
    sta [PTR_RAM_ITEM], y

    ;down_left_sprite
    ldy #$02
    lda [PTR_ITEM_TO_LOAD], y
    ldy #$09
    sta [PTR_RAM_ITEM], y 
    iny
    lda TEMP_A
    sta [PTR_RAM_ITEM], y

    ;down_right_sprite
    ldy #$03
    lda [PTR_ITEM_TO_LOAD], y
    ldy #$0D
    sta [PTR_RAM_ITEM], y 
    iny
    lda TEMP_A
    sta [PTR_RAM_ITEM], y
    
    lda CELL_CONTAINER
    cmp #CELL_POTION
    beq .skip_assign_enemy_ram

    lda CELL_TO_POINT
    inc TEMP_A_1                                ; Andiamo a inserire dentro CELLS_PAWNS_OCCS_ARRAY
    ldy TEMP_A_1                                ; le coordinate di cella dove sono posizionati gli attori
    sta CELLS_PAWNS_OCCS_ARRAY, y

.skip_assign_enemy_ram:
    jsr put_sprite_on_grid                      ; Chiamiamo il metodo per posizionarlo
    
    ;m_inc_by PTR_RAM_ITEM, #$10                 ; Incrementiamo il puntatore di 16 byte

    lda TEMP_Y                              
    tay                                         ; Rimettiamo il valore della Y al suo posto

    rts

;::::::::::::::::::::::::::::::::::::
; load_item
;::::::::::::::::::::::::::::::::::::
load_item:
    tya
    sta TEMP_Y

    lda CELL_CONTAINER
    cmp #CELL_ENEMY_0
    beq .load_enemy_0
    cmp #CELL_ENEMY_1
    beq .load_enemy_1
    cmp #CELL_ENEMY_2
    beq .load_enemy_2 
    cmp #CELL_POTION
    beq .load_item_potion

    jmp .exit

.load_enemy_0:
    lda #low( RAM_ENEMY_0 )
    sta PTR_RAM_ITEM + 0
    lda #high( RAM_ENEMY_0 )
    sta PTR_RAM_ITEM + 1
    lda #$04
    sta AN_PAWN_BUFFER_START_AT

    ldy #$00
    jmp .load_enemy

.load_enemy_1:
    lda #low( RAM_ENEMY_1 )
    sta PTR_RAM_ITEM + 0
    lda #high( RAM_ENEMY_1 )
    sta PTR_RAM_ITEM + 1
    lda #$08
    sta AN_PAWN_BUFFER_START_AT

    ldy #$01
    jmp .load_enemy

.load_enemy_2:
    lda #low( RAM_ENEMY_2 )
    sta PTR_RAM_ITEM + 0
    lda #high( RAM_ENEMY_2 )
    sta PTR_RAM_ITEM + 1
    lda #$0C
    sta AN_PAWN_BUFFER_START_AT

    ldy #$02
    jmp .load_enemy

.load_enemy:
    lda [ROOM_ENEMIES_TO_LOAD_ADDR], y
    cmp #CELL_EN_BAT
    beq .load_bat_sprite_0
    cmp #CELL_EN_SMILE
    beq .load_smile_sprite_0

    jmp .exit

.load_bat_sprite_0:
    jsr set_pawn_an_bat_idle
    ldx AN_PAWN_BUFFER_START_AT
    jsr set_pawn_an

    lda #low( sprites_bat_idle_0 )
    sta PTR_ITEM_TO_LOAD + 0
    lda #high( sprites_bat_idle_0 )
    sta PTR_ITEM_TO_LOAD + 1
    jsr load_next_item_on_map

    jmp .exit

.load_smile_sprite_0
    jsr set_pawn_an_smile_idle
    ldx AN_PAWN_BUFFER_START_AT
    jsr set_pawn_an

    lda #low( sprites_smile_an_0 )
    sta PTR_ITEM_TO_LOAD + 0
    lda #high( sprites_smile_an_0 )
    sta PTR_ITEM_TO_LOAD + 1
    jsr load_next_item_on_map
    jmp .exit

.load_item_potion:
    lda #low( RAM_ITEM_0 )
    sta PTR_RAM_ITEM + 0
    lda #high( RAM_ITEM_0 )
    sta PTR_RAM_ITEM + 1

    lda #low( sprites_potion )
    sta PTR_ITEM_TO_LOAD + 0
    lda #high( sprites_potion )
    sta PTR_ITEM_TO_LOAD + 1
    jsr load_next_item_on_map
    jmp .exit

.exit: 
    rts

;::::::::::::::::::::::::::::::::::::
; load_lvl_mat_occs
; Caricamento Matrice Occupazionale
;::::::::::::::::::::::::::::::::::::
load_lvl_mat_occs:
    lda ROOM_OCCS_TO_LOAD_ADDR + 0
    sta MATRIX_OCCS_ADDR       + 0
    lda ROOM_OCCS_TO_LOAD_ADDR + 1
    sta MATRIX_OCCS_ADDR       + 1

    ldy #$00
    .loop:
        lda [MATRIX_OCCS_ADDR], y
        sta RAM_ROOM_CELLS, y
        iny
        cpy #$40
        bne .loop

    rts

;:::::::::::::::::::::::::::::::::::::::::::::::
; unload_items_on_level
; Unload di tutti gli elementi sulla mappa
;:::::::::::::::::::::::::::::::::::::::::::::::
unload_items_on_level:
    ldx #$00
    .loop:
        lda #$FF
        sta RAM_ENEMY_0, x
        inx 
        cpx #$30
        bne .loop

    rts