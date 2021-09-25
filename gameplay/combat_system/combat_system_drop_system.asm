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
    lda #CELL_POTION
    sta CELL_CONTAINER
    lda LAST_ENEMY_KILLED_CELL
    sta CELL_TO_POINT

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
    jmp .load

.set_ram_item_1:
    lda #low( RAM_ITEM_1 )
    sta PTR_RAM_ITEM + 0
    lda #high( RAM_ITEM_1 )
    sta PTR_RAM_ITEM + 1
    jmp .load

.set_ram_item_2:
    lda #low( RAM_ITEM_2 )
    sta PTR_RAM_ITEM + 0
    lda #high( RAM_ITEM_2 )
    sta PTR_RAM_ITEM + 1
    jmp .load
    
.load    
    jsr load_item
    rts