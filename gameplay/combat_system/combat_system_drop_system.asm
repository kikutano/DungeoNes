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
    lda #$16
    sta CELL_CONTAINER
    lda LAST_ENEMy_KILLED_CELL
    sta CELL_TO_POINT
    jsr load_item
    rts