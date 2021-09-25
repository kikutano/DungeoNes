;:::::::::::::::::::::::::::::::::::::::::::::::
; update_generate_random_drop
;:::::::::::::::::::::::::::::::::::::::::::::::
update_generate_random_drop:
    lda DROP_RANDOM_ITEM_AVAILABLE
    cmp #$01
    beq .generate_random_drop

    jmp .exit

.generate_random_drop:
    jsr put_random_item_on_grid
    lda #$00
    sta DROP_RANDOM_ITEM_AVAILABLE

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::::::::
; update_generate_random_drop
;:::::::::::::::::::::::::::::::::::::::::::::::
set_drop_random_item_available:
    lda #$01
    sta DROP_RANDOM_ITEM_AVAILABLE
    rts

;:::::::::::::::::::::::::::::::::::::::::::::::
; put_random_item_on_grid
; CELL_CONTAINER: Sprite reference
; CELL_TO_POINT: The cell to point on grid
;:::::::::::::::::::::::::::::::::::::::::::::::
put_random_item_on_grid:
    lda LAST_ENEMY_KILLED_NUM
    cmp #$00
    beq .set_ram_item_0
    cmp #$01
    beq .set_ram_item_1
    cmp #$02
    beq .set_ram_item_2

.set_ram_item_0:
    lda #low( RAM_ITEM_0 )
    sta PTR_RAM_ITEM + 0
    lda #high( RAM_ITEM_0 )
    sta PTR_RAM_ITEM + 1
    jmp .load_item_on_grid

.set_ram_item_1:
    lda #low( RAM_ITEM_1 )
    sta PTR_RAM_ITEM + 0
    lda #high( RAM_ITEM_1 )
    sta PTR_RAM_ITEM + 1
    jmp .load_item_on_grid

.set_ram_item_2:
    lda #low( RAM_ITEM_2 )
    sta PTR_RAM_ITEM + 0
    lda #high( RAM_ITEM_2 )
    sta PTR_RAM_ITEM + 1
    jmp .load_item_on_grid
    
.load_item_on_grid:
    lda #CELL_POTION            ; load cell potion value
    sta CELL_CONTAINER          ; set into CELL_CONTAINER used within load_item
    lda LAST_ENEMY_KILLED_CELL  ; load the cell where the enemy was killed
    sta CELL_TO_POINT           ; set in CELL_POINT used within load_item
    jsr load_item               ; call load_item
    ldy LAST_ENEMY_KILLED_CELL  ; load the cell index where the enemy was killed
    lda #CELL_POTION            ; load the valure for CELL_POTION
    sta RAM_ROOM_CELLS, y       ; update the RAM_ROOM_CELLS position with Potion
    rts