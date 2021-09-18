
set_meta_sprites_to_translate:
    lda #$01
    sta GFX_SPRITES_UPDATE

    lda #$00
    sta GFX_SPRITE_TRANS_COUNT

    rts

;:::::::::::::::::::::::::::::::::::::::::
; Set Pawn For Translation
;:::::::::::::::::::::::::::::::::::::::::
set_pawn_for_tranlastion:
    lda #$00
    sta AN_JUMP_COUNT

    lda PAWN_PTR + 0
    sta GFX_SPRITE_TRANS_ADDR + 0
    lda PAWN_PTR + 1
    sta GFX_SPRITE_TRANS_ADDR + 1
    
    rts

;:::::::::::::::::::::::::::::::::::::::::
; set_pawn_start_translation
;:::::::::::::::::::::::::::::::::::::::::
set_pawn_start_translation:
    sta GFX_SPRITE_TRANS_DIREC
    jsr set_meta_sprites_to_translate
    jsr disable_input

    rts
    
;:::::::::::::::::::::::::::::::::::::::::
; background_set_tile
;:::::::::::::::::::::::::::::::::::::::::

;TODO: Ottimizzare meglio
background_set_tile:
    lda UPDATE_BACKGROUND_TILE
    cmp #$01
    beq .can_update

    jmp .exit

.can_update:
    lda #$29                                    ; Impostiamo $2094 come inizio della griglia
    sta CELL_SHOWER_ADDR_LOW
    lda #$04
    sta CELL_SHOWER_ADDR_HIGH

    lda BACKGROUND_CELL_CHANGE
    sta TEMP_A_0
    lsr A
    lsr A
    lsr A
    sta TEMP_A_0                                ; Riga
    
    lda BACKGROUND_CELL_CHANGE
    sta TEMP_A
    lda TEMP_A
    and #7
    sta TEMP_A                                  ; Colonna

    lda BACKGROUND_CELL_CHANGE
    cmp #$20
    bcc .on_up_side_of_grid

    lda #$2A                    ; Aggiustiamo l'ADD_LOW per partire da $2A
    sta CELL_SHOWER_ADDR_LOW
    lda BACKGROUND_CELL_CHANGE
    sec 
    sbc #$20
    sta BACKGROUND_CELL_CHANGE  ; Togliamo 32 tiles

.on_up_side_of_grid:
    
    ;Spostiamoci sulla riga
    ldx #$00
.loop_row:
    lda CELL_SHOWER_ADDR_HIGH
    clc
    adc #$40
    sta CELL_SHOWER_ADDR_HIGH
    inx
    cpx TEMP_A_0
    bne .loop_row

    ;Spostiamoci sulla colonna
    ldx #$00
.loop_column:
    inc CELL_SHOWER_ADDR_HIGH
    inc CELL_SHOWER_ADDR_HIGH
    inx
    cpx TEMP_A
    bne .loop_column

    ;Aggiorniamo i tiles
    lda $2002
    lda CELL_SHOWER_ADDR_LOW
    sta $2006
    lda CELL_SHOWER_ADDR_HIGH
    sta $2006

    lda BACKGROUND_TILE_TO_SET
    sta $2007
    inc BACKGROUND_TILE_TO_SET
    lda BACKGROUND_TILE_TO_SET
    sta $2007

    lda CELL_SHOWER_ADDR_HIGH
    clc
    adc #$20
    sta CELL_SHOWER_ADDR_HIGH

    lda $2002
    lda CELL_SHOWER_ADDR_LOW
    sta $2006
    lda CELL_SHOWER_ADDR_HIGH
    sta $2006

    lda BACKGROUND_TILE_TO_SET
    clc 
    adc #$0F
    sta BACKGROUND_TILE_TO_SET

    lda BACKGROUND_TILE_TO_SET
    sta $2007
    lda BACKGROUND_TILE_TO_SET
    clc
    adc #$01
    sta BACKGROUND_TILE_TO_SET
    lda BACKGROUND_TILE_TO_SET
    sta $2007

    lda #$00
    sta UPDATE_BACKGROUND_TILE

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; update_shadow_on_grid
;:::::::::::::::::::::::::::::::::::::::::
update_shadow_on_grid:
    lda AN_JUMP_COUNT
    cmp #$05
    bne .skip_change_shadow_front

.change_back:
    ldx CELL_SELECTED_PREV
    lda RAM_ROOM_CELLS, x
    cmp #CELL_PLAYER
    beq .can_change_back_bg
    cmp #CELL_ENEMY_0
    beq .can_change_back_bg
    cmp #CELL_ENEMY_1
    beq .can_change_back_bg
    cmp #CELL_ENEMY_2
    beq .can_change_back_bg

    jmp .skip_change_shadow_front

.can_change_back_bg:
    lda #$54
    sta BACKGROUND_TILE_TO_SET
    lda #$01
    sta UPDATE_BACKGROUND_TILE
    lda CELL_SELECTED_PREV
    sta BACKGROUND_CELL_CHANGE

.skip_change_shadow_front:
    lda AN_JUMP_COUNT
    cmp #$09
    bne .skip_change_shadow_back
    
    lda #$76
    sta BACKGROUND_TILE_TO_SET
    lda #$01
    sta UPDATE_BACKGROUND_TILE
    lda CELL_SELECTED
    sta BACKGROUND_CELL_CHANGE

.skip_change_shadow_back:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; update_jump_translation
;:::::::::::::::::::::::::::::::::::::::::
update_jump_translation:
    ldy #$00
.loop:
    ldx AN_JUMP_COUNT
    lda jump_params, x
    sta TEMP_A_0
    ;Y
    lda [GFX_SPRITE_TRANS_ADDR], y
    clc
    adc TEMP_A_0
    sta [GFX_SPRITE_TRANS_ADDR], y
    iny 
    iny
    iny 
    ;X
    lda [GFX_SPRITE_TRANS_ADDR], y
    clc
    adc AN_JUMP_DIR_FACTOR
    sta [GFX_SPRITE_TRANS_ADDR], y

    iny
    cpy #$10
    bne .loop

    inc AN_JUMP_COUNT 

    jsr update_shadow_on_grid
    rts

;:::::::::::::::::::::::::::::::::::::::::
; update_jump_translation_y
;:::::::::::::::::::::::::::::::::::::::::
update_jump_translation_y:
    ldy #$00
.loop:
    ldx AN_JUMP_COUNT
    lda AN_JUMP_DIR_FACTOR
    cmp #$01
    beq .down

.up:
    lda jump_params_y_down_up, x
    jmp .continue

.down:
    lda jump_params_y_up_down, x

.continue:
    sta TEMP_A_0
    lda [GFX_SPRITE_TRANS_ADDR], y
    clc
    adc TEMP_A_0
    sta [GFX_SPRITE_TRANS_ADDR], y

    iny
    iny
    iny
    iny
    cpy #$10
    bne .loop

    inc AN_JUMP_COUNT 

    jsr update_shadow_on_grid

    rts

update_meta_sprites_translation:
    lda GFX_SPRITES_UPDATE
    cmp #$01
    beq .update_translation

    jmp .exit

.update_translation:
    inc GFX_SPRITE_TRANS_COUNT

    lda GFX_SPRITE_TRANS_DIREC
    cmp #GFX_SPRITE_TRANS_UP
    beq .jmp_move_up
    cmp #GFX_SPRITE_TRANS_DOWN
    beq .jmp_move_down
    cmp #GFX_SPRITE_TRANS_LEFT
    beq .jmp_move_left
    cmp #GFX_SPRITE_TRANS_RIGHT
    beq .jmp_move_right

    jmp .exit

.jmp_move_up:
    jmp .move_up
.jmp_move_down:
    jmp .move_down
.jmp_move_left:
    jmp .move_left
.jmp_move_right:
    jmp .move_right

.move_up:
    jsr update_jump_translation_y

    jmp .translation_done

.move_down:
    jsr update_jump_translation_y

    jmp .translation_done

.move_left:
    jsr update_jump_translation

    jmp .translation_done

.move_right:
    jsr update_jump_translation    

    jmp .translation_done

.translation_done:

    lda GFX_SPRITE_TRANS_COUNT
    cmp #$10
    beq .cell_reached

    jmp .exit

.cell_reached:
    
    lda #$00
    sta GFX_SPRITES_UPDATE
    jsr on_player_movement_done

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; cell_indicator_show
;:::::::::::::::::::::::::::::::::::::::::
cell_indicator_show:
    lda #$01
    sta CELL_INDICATOR_ON
    lda CELL_INDICATOR_POS
    sta CELL_TO_POINT
    jsr set_x_y_coords_from_cell_pos

    ldx #$00
.loop:
    lda sprites_indicator, x
    sta RAM_CELL_INDICATOR, x
    inx
    cpx #$10
    bne .loop

    lda AN_SPRITE_Y 
    sta RAM_CELL_INDICATOR + 0
    sta RAM_CELL_INDICATOR + 4
    clc 
    adc #$08
    sta RAM_CELL_INDICATOR + 8
    sta RAM_CELL_INDICATOR + 12

    lda AN_SPRITE_X 
    sta RAM_CELL_INDICATOR + 3
    sta RAM_CELL_INDICATOR + 11
    clc 
    adc #$08
    sta RAM_CELL_INDICATOR + 7
    sta RAM_CELL_INDICATOR + 15

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; cell_indicator_hide
;:::::::::::::::::::::::::::::::::::::::::
cell_indicator_hide:

    lda #$FF
    sta RAM_CELL_INDICATOR + 0
    sta RAM_CELL_INDICATOR + 1
    sta RAM_CELL_INDICATOR + 4
    sta RAM_CELL_INDICATOR + 5
    sta RAM_CELL_INDICATOR + 8
    sta RAM_CELL_INDICATOR + 9
    sta RAM_CELL_INDICATOR + 12
    sta RAM_CELL_INDICATOR + 13
    
    lda #$00
    sta CELL_INDICATOR_ON

    rts

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; [ SET SPRITE ANIMATION ON GRID ] 
; Questo metodo setta gli sprite dell'animazione
; che poi saranno mostrati sulla griglia.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

set_on_grid_sprite_animation:
    lda CELL_SELECTED
    sta CELL_TO_POINT
    jsr set_x_y_coords_from_cell_pos

    lda #$01
    sta AN_SPRITE_ON

    lda AN_SPRITE_Y
    sta RAM_AN_HIT + 0
    sta RAM_AN_HIT + 4
    
    lda #$07
    adc AN_SPRITE_Y
    sta AN_SPRITE_Y

    lda AN_SPRITE_Y
    sta RAM_AN_HIT + 8
    sta RAM_AN_HIT + 12

    lda AN_SPRITE_X
    sta RAM_AN_HIT + 3
    sta RAM_AN_HIT + 11
    
    lda #$08
    adc AN_SPRITE_X
    sta AN_SPRITE_X

    lda AN_SPRITE_X
    sta RAM_AN_HIT + 7
    sta RAM_AN_HIT + 15

    jsr update_on_grid_sprite_an

    rts

;:::::::::::::::::::::::::::::::::::::::::
; update_on_grid_sprite_an
;:::::::::::::::::::::::::::::::::::::::::
update_on_grid_sprite_an:
    
    ldx AN_SPRITE_FRAME_COUNT
    lda AN_SPRITES_ARRAY, x
    sta RAM_AN_HIT + 1
    sta RAM_AN_HIT + 9
    lda #%00000010
    sta RAM_AN_HIT + 2
    sta RAM_AN_HIT + 6
    
    inc AN_SPRITE_FRAME_COUNT

    ldx AN_SPRITE_FRAME_COUNT
    lda AN_SPRITES_ARRAY, x

    sta RAM_AN_HIT + 5
    sta RAM_AN_HIT + 13
    lda #%10000010
    sta RAM_AN_HIT + 10
    sta RAM_AN_HIT + 14

    inc AN_SPRITE_FRAME_COUNT

    rts

;:::::::::::::::::::::::::::::::::::::::::::::
; update_check_ongridsprite_an_must_update
;:::::::::::::::::::::::::::::::::::::::::::::
update_check_ongridsprite_an_must_update:

    lda AN_SPRITE_ON
    cmp #$01
    beq .must_update_an

    jmp .exit

.must_update_an:
    inc AN_TICKS_COUNT
    lda AN_TICKS_COUNT
    cmp #$05
    beq .set_next_an_frame

    jmp .exit

.set_next_an_frame:
    jsr update_on_grid_sprite_an

    lda #$00
    sta AN_TICKS_COUNT

    lda AN_SPRITE_FRAME_COUNT
    cmp #$04
    bne .continue

    jsr sprite_on_half_animation_done   ; L'animazione è a metà, mando un messaggio

.continue:
    lda AN_SPRITE_FRAME_COUNT
    cmp #$06
    bne .exit

.reset_frame_count:
    lda #$00
    sta AN_SPRITE_FRAME_COUNT
    sta AN_TICKS_COUNT
    sta AN_SPRITE_ON

    jsr hide_on_grid_sprite_an

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::::::
; hide_on_grid_sprite_an
;:::::::::::::::::::::::::::::::::::::::::::::
hide_on_grid_sprite_an:
    
    ldx #$00
    .hide_sprite_an_loop:
        lda #$00
        sta RAM_AN_HIT, x
        inx 
        cpx #$0F 
        bne .hide_sprite_an_loop
    
    lda AN_SPRITE_TYPE
    cmp #AN_INDEX_HIT
    bne .exit

    jsr on_pawn_attack_done    ; L'animazione dell'Hit è finita, 
                               ; avvertiamo il dungeon_events_manager

.exit:
    jsr sprite_animation_done
    rts

;:::::::::::::::::::::::::::::::::::::::::::::
; Brawl Animation
;:::::::::::::::::::::::::::::::::::::::::::::
set_sprite_an_hit_brawl:    
    lda #AN_INDEX_HIT
    sta AN_SPRITE_TYPE
    jsr set_sprite_index_for_animation
    rts

;:::::::::::::::::::::::::::::::::::::::::::::
; set_sprite_an_dead
;:::::::::::::::::::::::::::::::::::::::::::::
set_sprite_an_dead:
    lda #AN_INDEX_DEAD
    sta AN_SPRITE_TYPE
    jsr set_sprite_index_for_animation
    rts

;:::::::::::::::::::::::::::::::::::::::::::::
; set_sprite_an_puff
;:::::::::::::::::::::::::::::::::::::::::::::
set_sprite_an_puff:
    lda #AN_INDEX_PUFF
    sta AN_SPRITE_TYPE
    jsr set_sprite_index_for_animation
    rts 

;:::::::::::::::::::::::::::::::::::::::::::::
; set_sprite_index_for_animation
;:::::::::::::::::::::::::::::::::::::::::::::
set_sprite_index_for_animation:
    lda #$00
    sta AN_TICKS_COUNT

    ldx AN_SPRITE_TYPE
    ldy #$00
    .loop:
        txa
        sta AN_SPRITES_ARRAY, y
        iny 
        inx
        cpy #$05 
        bne .loop

    jsr set_on_grid_sprite_animation

    rts

;:::::::::::::::::::::::::::::::::::::::::::::
; Hit count Animation
;:::::::::::::::::::::::::::::::::::::::::::::
set_sprite_an_hit_count:
    lda HIT_COUNT_VALUE
    jsr from_hex_to_decimal
    
    lda CELL_SELECTED
    sta CELL_TO_POINT
    
    ;::::::::::::::::::::::::::::::::::
    ; PALETTE HIT COUNT
    ;::::::::::::::::::::::::::::::::::
    lda #$02                
    sta RAM_AN_HIT + 2      
    sta RAM_AN_HIT + 6
    sta RAM_AN_HIT + 10

    lda INDICATOR_TYPE
    cmp #INDICATOR_COIN_COUNT
    beq .set_indicator_as_coins_count
    cmp #INDICATOR_HIT_COUNT
    beq .set_indicator_as_hit_count
    
.set_indicator_as_coins_count
    lda #$0A
    jmp .set_first_value_as_icon

.set_indicator_as_lvl_up_count
    lda #$0B
    jmp .set_first_value_as_icon

.set_first_value_as_icon:               ; Setta il primo valore come icona
    sta HIT_COUNT_CENTESIMAL
    lda CELLS_PAWNS_OCCS_ARRAY + 0
    sta CELL_TO_POINT

    ;::::::::::::::::::::::::::::::::::
    ; PALETTE HIT COUNT
    ;::::::::::::::::::::::::::::::::::
    lda #$00                
    sta RAM_AN_HIT + 2
    lda #$02      
    sta RAM_AN_HIT + 6
    sta RAM_AN_HIT + 10

.set_indicator_as_hit_count:
    jsr set_x_y_coords_from_cell_pos

    lda AN_SPRITE_Y
    sta RAM_AN_HIT + 0
    sta RAM_AN_HIT + 4
    sta RAM_AN_HIT + 8

    lda HIT_COUNT_CENTESIMAL
    adc #$F0
    sta RAM_AN_HIT + 1

    lda HIT_COUNT_DECIMAL
    adc #$F0
    sta RAM_AN_HIT + 5
    
    lda HIT_COUNT_UNIT
    adc #$F0
    sta RAM_AN_HIT + 9

    lda AN_SPRITE_X
    sbc #$04
    sta AN_SPRITE_X

    lda HIT_COUNT_CENTESIMAL
    cmp #$00
    bne .skip_hide_centesimal

.hide_centesimal:
    lda AN_SPRITE_X
    sbc #$04
    sta AN_SPRITE_X
    lda #$FF
    sta RAM_AN_HIT + 1

    lda HIT_COUNT_DECIMAL
    cmp #$00
    bne .skip_hide_centesimal

    lda AN_SPRITE_X
    sbc #$04
    sta AN_SPRITE_X
    lda #$FF
    sta RAM_AN_HIT + 5

.skip_hide_centesimal:
    lda AN_SPRITE_X
    sta RAM_AN_HIT + 3
    adc #$08
    sta RAM_AN_HIT + 7
    adc #$08
    sta RAM_AN_HIT + 11

    lda #$01
    sta AN_SPRITE_COUNT_UPDATE
    lda #$00
    sta AN_TICKS_COUNT

    rts

    ;::: UPDATE :::

start_sprite_hit_shake_an:
    lda #$01
    sta AN_SHAKE_ON

    lda CURRENT_RECIEVER_STATS_PTR
    cmp #CELL_ENEMY_0
    beq .set_en_0
    cmp #CELL_ENEMY_1
    beq .set_en_1
    cmp #CELL_ENEMY_2
    beq .set_en_2
    cmp #CELL_PLAYER
    beq .set_player

.set_en_0:
    lda RAM_ENEMY_0 + 2
    sta AN_ATTR_SAVED
    jmp .exit

.set_en_1:
    lda RAM_ENEMY_1 + 2
    sta AN_ATTR_SAVED
    jmp .exit

.set_en_2:
    lda RAM_ENEMY_2 + 2
    sta AN_ATTR_SAVED
    jmp .exit

.set_player:
    lda RAM_PLAYER + 2
    sta AN_ATTR_SAVED
    jmp .exit

.exit:
    rts

stop_sprite_hit_shake_an:
    lda #$00
    sta AN_SHAKE_ON

    lda CURRENT_RECIEVER_STATS_PTR
    cmp #CELL_ENEMY_0
    beq .set_en_0
    cmp #CELL_ENEMY_1
    beq .set_en_1
    cmp #CELL_ENEMY_2
    beq .set_en_2
    cmp #CELL_PLAYER
    beq .set_player

.set_en_0:
    lda AN_ATTR_SAVED
    sta RAM_ENEMY_0 + 2
    sta RAM_ENEMY_0 + 6
    sta RAM_ENEMY_0 + 10
    sta RAM_ENEMY_0 + 14
    jmp .exit

.set_en_1:
    lda AN_ATTR_SAVED
    sta RAM_ENEMY_1 + 2
    sta RAM_ENEMY_1 + 6
    sta RAM_ENEMY_1 + 10
    sta RAM_ENEMY_1 + 14
    jmp .exit

.set_en_2:
    lda AN_ATTR_SAVED
    sta RAM_ENEMY_2 + 2
    sta RAM_ENEMY_2 + 6
    sta RAM_ENEMY_2 + 10
    sta RAM_ENEMY_2 + 14
    jmp .exit

.set_player:
    lda AN_ATTR_SAVED
    sta RAM_PLAYER + 2
    sta RAM_PLAYER + 6
    sta RAM_PLAYER + 10
    sta RAM_PLAYER + 14
    jmp .exit

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; update_sprite_hit_shake_an
;:::::::::::::::::::::::::::::::::::::::::
update_sprite_hit_shake_an:
    lda AN_SHAKE_ON
    cmp #$00
    bne .can_update_shake

    jmp .exit
    
.can_update_shake:
    lda CURRENT_RECIEVER_STATS_PTR
    cmp #CELL_ENEMY_0
    beq .set_en_0
    cmp #CELL_ENEMY_1
    beq .set_en_1
    cmp #CELL_ENEMY_2
    beq .set_en_2
    cmp #CELL_PLAYER
    beq .set_player

.set_en_0:
    ldy #$00
    lda #low( RAM_ENEMY_0 )
    sta GENERIC_PTR + 0
    lda #high( RAM_ENEMY_0 )
    sta GENERIC_PTR + 1
    jmp .continue_update_sprite_an

.set_en_1:
    ldy #$00
    lda #low( RAM_ENEMY_1 )
    sta GENERIC_PTR + 0
    lda #high( RAM_ENEMY_1 )
    sta GENERIC_PTR + 1
    jmp .continue_update_sprite_an

.set_en_2:
    ldy #$00
    lda #low( RAM_ENEMY_2 )
    sta GENERIC_PTR + 0
    lda #high( RAM_ENEMY_2 )
    sta GENERIC_PTR + 1
    jmp .continue_update_sprite_an

.set_player:
    ldy #$00
    lda #low( RAM_PLAYER )
    sta GENERIC_PTR + 0
    lda #high( RAM_PLAYER )
    sta GENERIC_PTR + 1
    jmp .continue_update_sprite_an

.continue_update_sprite_an:

    ldy #$02
    m_inc_by [GENERIC_PTR], y, #$01
    ldy #$06
    m_inc_by [GENERIC_PTR], y, #$01
    ldy #$0A
    m_inc_by [GENERIC_PTR], y, #$01
    ldy #$0E
    m_inc_by [GENERIC_PTR], y, #$01

    ldy #$02
    lda [GENERIC_PTR], y
    cmp #$04
    bne .exit

    lda #$00
    ldy #$02
    sta [GENERIC_PTR], y
    ldy #$06
    sta [GENERIC_PTR], y
    ldy #$0A
    sta [GENERIC_PTR], y
    ldy #$0E
    sta [GENERIC_PTR], y

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; update_sprite_hit_count
;:::::::::::::::::::::::::::::::::::::::::
update_sprite_hit_count:
    lda AN_SPRITE_COUNT_UPDATE
    cmp #$00
    beq .exit

    lda AN_TICKS_COUNT
    cmp #$05
    bcs .update_stop_count

    inc AN_TICKS_COUNT
    dec RAM_AN_HIT + 0
    dec RAM_AN_HIT + 0
    dec RAM_AN_HIT + 4
    dec RAM_AN_HIT + 4
    dec RAM_AN_HIT + 8
    dec RAM_AN_HIT + 8

    jmp .exit

    ;::: STOP :::

.update_stop_count:
    inc AN_TICKS_COUNT
    lda AN_TICKS_COUNT
    cmp #$15
    bne .exit
    
.stop_counting:
    lda #$FF
    sta RAM_AN_HIT + 0
    sta RAM_AN_HIT + 1
    sta RAM_AN_HIT + 4
    sta RAM_AN_HIT + 5
    sta RAM_AN_HIT + 8
    sta RAM_AN_HIT + 9

    jsr stop_sprite_hit_shake_an
    jsr on_attack_stats_showed_done
       
    lda #$00
    sta AN_SPRITE_COUNT_UPDATE

    lda INDICATOR_TYPE
    cmp #INDICATOR_HIT_COUNT
    beq .stop_dead_anim

    lda #INDICATOR_HIT_COUNT
    sta INDICATOR_TYPE
    jmp .exit

.stop_dead_anim:
    jsr cs_compute_if_pawn_is_dead

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::::::
; PAWN ANIMATIONS
; Settings delle animazioni per le pedine
;:::::::::::::::::::::::::::::::::::::::::::::

set_pawn_an:
    
    ldy #$00
    .loop:
        lda [GENERIC_PTR], y
        sta ANIMATIONS_PAWNS_FRAME_0, x
        lda [GENERIC_PTR_1], y
        sta ANIMATIONS_PAWNS_FRAME_1, x
        inx
        iny
        cpy #$04
        bne .loop
    
    rts

set_pawn_an_en_0_dead:
    lda #$FF
    sta RAM_ENEMY_0 + 0
    sta RAM_ENEMY_0 + 4
    sta RAM_ENEMY_0 + 8
    sta RAM_ENEMY_0 + 12
    jsr set_pawn_en_dead
    ldx #$04
    jsr set_pawn_an
    rts

set_pawn_an_en_1_dead:
    lda #$FF
    sta RAM_ENEMY_1 + 0
    sta RAM_ENEMY_1 + 4
    sta RAM_ENEMY_1 + 8
    sta RAM_ENEMY_1 + 12
    jsr set_pawn_en_dead
    ldx #$08
    jsr set_pawn_an
    rts

set_pawn_an_en_2_dead:
    lda #$FF
    sta RAM_ENEMY_2 + 0
    sta RAM_ENEMY_2 + 4
    sta RAM_ENEMY_2 + 8
    sta RAM_ENEMY_2 + 12
    jsr set_pawn_en_dead
    ldx #$0C
    jsr set_pawn_an
    rts

set_pawn_an_player_idle:
    jsr set_pawn_an_player_on_mem_idle
    ldx #$00
    jsr set_pawn_an
    rts

set_pawn_an_player_on_mem_idle:
    ;lda #low( sprites_player_idle_0 )
    lda #low( sprites_player_archer_idle_0 )
    sta GENERIC_PTR + 0
    ;lda #high( sprites_player_idle_0 )
    lda #high( sprites_player_archer_idle_0 )
    sta GENERIC_PTR + 1
    ;lda #low( sprites_player_idle_1 )
    lda #low( sprites_player_archer_idle_1 )
    sta GENERIC_PTR_1 + 0
    ;lda #high( sprites_player_idle_1 )
    lda #high( sprites_player_archer_idle_1 )
    sta GENERIC_PTR_1 + 1
    rts
        
set_pawn_an_bat_idle:
    lda #low( sprites_bat_idle_0 )
    sta GENERIC_PTR + 0
    lda #high( sprites_bat_idle_0 )
    sta GENERIC_PTR + 1
    lda #low( sprites_bat_idle_1 )
    sta GENERIC_PTR_1 + 0
    lda #high( sprites_bat_idle_1 )
    sta GENERIC_PTR_1 + 1
    rts

set_pawn_an_smile_idle:
    lda #low( sprites_smile_an_0 )
    sta GENERIC_PTR + 0
    lda #high( sprites_smile_an_0 )
    sta GENERIC_PTR + 1
    lda #low( sprites_smile_an_1 )
    sta GENERIC_PTR_1 + 0
    lda #high( sprites_smile_an_1 )
    sta GENERIC_PTR_1 + 1
    rts

set_pawn_en_dead:
    lda #low( sprites_dead )
    sta GENERIC_PTR + 0
    lda #high( sprites_dead )
    sta GENERIC_PTR + 1
    lda #low( sprites_dead )
    sta GENERIC_PTR_1 + 0
    lda #high( sprites_dead )
    sta GENERIC_PTR_1 + 1
    rts

;:::::::::::::::::::::::::::::::::::::::::
; update_pawn_animation
;:::::::::::::::::::::::::::::::::::::::::
update_pawn_animation:
    inc AN_PAWN_SPRITE_TICKS

    lda AN_PAWN_SPRITE_TICKS
    cmp #$10
    beq .update_next_sprite

    jmp .exit

.update_next_sprite:
    
    lda #$00
    sta AN_PAWN_SPRITE_TICKS

    lda AN_PAWN_SPRITE_COUNT
    cmp #$01
    beq .set_an_frame_0

    jmp .set_an_frame_1

.set_an_frame_0:
    
    ldy #$00
    ldx #$01
    .loop_0:
        lda ANIMATIONS_PAWNS_FRAME_0, y
        sta RAM_PLAYER, x
        iny
        inx
        inx
        inx
        inx
        cpy #$10
        bne .loop_0

    lda #$00
    sta AN_PAWN_SPRITE_COUNT

    jmp .exit

.set_an_frame_1:

    ldy #$00
    ldx #$01
    .loop_1:
        lda ANIMATIONS_PAWNS_FRAME_1, y
        sta RAM_PLAYER, x
        iny
        inx
        inx
        inx
        inx
        cpy #$10
        bne .loop_1

    lda #$01
    sta AN_PAWN_SPRITE_COUNT

.exit:
    rts 

;:::::::::::::::::::::::::::::::::::::::::::::
; flip_sprite_pawn_to_left
;:::::::::::::::::::::::::::::::::::::::::::::
flip_sprite_pawn_to_left:
    ;Verifichiamo che non sia già girato verso sinistra
    
    ldy #$02
    lda [PAWN_PTR], y
    and #%01000000
    cmp #%01000000
    bne .continue

    jmp .exit

.continue:

    ldy #$02
    ldx #$00
    .loop:

        lda [PAWN_PTR], y
        ora #%01000000
        sta [PAWN_PTR], y
        
        iny
        iny
        iny
        iny

        inx
        cpx #$04
        bne .loop

    ldy #$03
    lda [PAWN_PTR], y
    clc
    adc #$08
    sta [PAWN_PTR], y

    ldy #$07
    lda [PAWN_PTR], y
    sec
    sbc #$08
    sta [PAWN_PTR], y

    ldy #$0B
    lda [PAWN_PTR], y
    clc
    adc #$08
    sta [PAWN_PTR], y

    ldy #$0F
    lda [PAWN_PTR], y
    sec
    sbc #$08
    sta [PAWN_PTR], y

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; flip_sprite_pawn_to_right
;:::::::::::::::::::::::::::::::::::::::::
flip_sprite_pawn_to_right:
    ldy #$02
    lda [PAWN_PTR], y
    and #%01000000
    cmp #%00000000
    bne .continue

    jmp .exit

.continue:
    ldy #$02
    ldx #$00
    .loop:
        lda [PAWN_PTR], y
        asl A
        asl A
        lsr A
        lsr A
        sta [PAWN_PTR], y
        
        iny
        iny
        iny
        iny

        inx
        cpx #$04
        bne .loop

    ldy #$03
    lda [PAWN_PTR], y
    sec
    sbc #$08
    sta [PAWN_PTR], y

    ldy #$07
    lda [PAWN_PTR], y
    clc
    adc #$08
    sta [PAWN_PTR], y

    ldy #$0B
    lda [PAWN_PTR], y
    sec
    sbc #$08
    sta [PAWN_PTR], y

    ldy #$0F
    lda [PAWN_PTR], y
    clc
    adc #$08
    sta [PAWN_PTR], y

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; put_sprite_on_grid
;:::::::::::::::::::::::::::::::::::::::::
put_sprite_on_grid:
    ;for X
    lda CELL_TO_POINT
    and #7                      ; A % 8
    asl A
    asl A
    asl A
    asl A                       ; A * 16
    clc
    adc #$20                    ; A + offset_x
    
    ldy #$03
    sta [PTR_RAM_ITEM], y
    ldy #$0B
    sta [PTR_RAM_ITEM], y
    clc
    adc #8                      ; A + 8
    
    ldy #$07
    sta [PTR_RAM_ITEM], y
    ldy #$0F
    sta [PTR_RAM_ITEM], y

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
    
    ldy #$00
    sta [PTR_RAM_ITEM], y
    ldy #$04
    sta [PTR_RAM_ITEM], y

    clc 
    adc #8 ; A + 8
    
    ldy #$08
    sta [PTR_RAM_ITEM], y
    ldy #$0C
    sta [PTR_RAM_ITEM], y
    
    rts

;2103 -> 2116
;2120 -> 2136
;...
;2303 -> 2376

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; fade_out_column
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
fade_out_column:    
  lda $2002             
  lda MATRIX_FADE_OUT_COL_ADDR_LOW
  sta $2006             
  lda MATRIX_FADE_OUT_COL_ADDR_HIGH
  sta $2006     

  lda #%00000100
  sta $2000

  ldx #$00
  .fade_out_column_loop:
    lda #$FF
    sta $2007
    inx
    cpx #$10                          ; Limite verticale sotto
    bne .fade_out_column_loop
    
  rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; fade_out_update
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
fade_out_update:
  lda MATRIX_FADE_OUT_COL_ADDR_HIGH
  cmp #$03                            ; -> Limite sinistro
  bne .continue

  lda #GAME_STATE_FADE_IN_MATRIX      ; -> Fade Out finito, impostiamo Fade In 
  sta GAME_STATE
  lda #$00
  sta MATRIX_TILE_MAP_POINTER
  sta FADE_IN_COUNT
  sta FADE_IN_ROWS_COUNT

  lda #$21
  sta MATRIX_FADE_OUT_COL_ADDR_LOW
  lda #$04
  sta MATRIX_FADE_OUT_COL_ADDR_HIGH

  jmp .exit

.continue:
  inc MATRIX_FADE_OUT_TICKS

  lda MATRIX_FADE_OUT_TICKS
  cmp #$02                          ; -> Tick per la velocità di Fade
  beq .fade_out_one_column

  jmp .exit

.fade_out_one_column:
  jsr fade_out_column
  dec MATRIX_FADE_OUT_COL_ADDR_HIGH ;$12 -> $03
  lda #$00
  sta MATRIX_FADE_OUT_TICKS

.exit:
  rts

;:::::::::::::::::::::::::::::::::::::::::::::::
; put_bg_meta_tile
;:::::::::::::::::::::::::::::::::::::::::::::::
put_bg_meta_tile:
  lda $2002             
  lda MATRIX_FADE_OUT_COL_ADDR_LOW
  sta $2006             
  lda MATRIX_FADE_OUT_COL_ADDR_HIGH
  sta $2006    

  lda BG_TILE_LEFT
  sta PPUDATA
  lda BG_TILE_RIGHT
  sta PPUDATA

  rts

;:::::::::::::::::::::::::::::::::::::::::::::::
; fade_in_column 
; Costruzione dinamica del background level
;:::::::::::::::::::::::::::::::::::::::::::::::

fade_in_column:

  ldy FADE_IN_COUNT
  lda [ROOM_OCCS_TO_LOAD_ADDR], y
  tax
  lda tile_translator, x
  sta BG_TILE_LEFT
  sta BG_TILE_RIGHT
  inc BG_TILE_RIGHT

.put_bg_tile:
  jsr put_bg_meta_tile

  m_inc_by MATRIX_FADE_OUT_COL_ADDR_HIGH, #$20
  
  lda BG_TILE_LEFT
  cmp #$FF
  beq .skip_increase_tile ; lasciamo che sia #$FF e non prenda i tile di sotto
  clc
  adc #$10
  sta BG_TILE_LEFT
  sta BG_TILE_RIGHT
  inc BG_TILE_RIGHT

.skip_increase_tile:
  jsr put_bg_meta_tile

  inc FADE_IN_COUNT
  inc FADE_IN_ROWS_COUNT
  
  m_dec_by MATRIX_FADE_OUT_COL_ADDR_HIGH, #$1E

  lda FADE_IN_COUNT
  cmp #$20
  beq .incrase_low_addr

  jmp .continue_check

.incrase_low_addr:
  m_inc_by MATRIX_FADE_OUT_COL_ADDR_LOW, #$01

.continue_check:
  lda FADE_IN_ROWS_COUNT
  cmp #$08
  beq .fade_next_row

  jmp .continue

.fade_next_row:
  m_inc_by MATRIX_FADE_OUT_COL_ADDR_HIGH, #$30
  lda #$00
  sta FADE_IN_ROWS_COUNT

.continue:
  rts

;:::::::::::::::::::::::::::::::::::::::::::::::
; fade_in_update 
;:::::::::::::::::::::::::::::::::::::::::::::::
fade_in_update:
  
  lda FADE_IN_COUNT
  cmp #$40
  bne .continue

  lda #GAME_STATE_GAME_PLAY         ; Fade In Concluso 
  sta GAME_STATE
  
  jsr on_fade_in_room_done          ; Fade finito
  
  jmp .exit

.continue:
  inc MATRIX_FADE_OUT_TICKS

  lda MATRIX_FADE_OUT_TICKS
  cmp #$01
  beq .fade_in_one_column

  jmp .exit

.fade_in_one_column:
  jsr fade_in_column
  jsr fade_in_column
  lda #$00
  sta MATRIX_FADE_OUT_TICKS

.exit:
  rts