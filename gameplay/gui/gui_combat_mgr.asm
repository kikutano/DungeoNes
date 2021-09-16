; gui_combat_mgr

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; GUI
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
gui_hp_text_letters:
    .db $11,$19,$25,$01,$03,$05,$24,$02,$03,$00
gui_mp_text_letters:
    .db $16,$19,$25,$00,$03,$06,$24,$00,$05,$02
gui_points_text_letters:
    .db $19,$25,$00,$01,$02,$05,$08,$00
gui_coins_text_letters:
    .db $0C,$25,$00,$00,$00,$02,$06,$00
gui_keys_text_letters:
    .db $26,$25,$00,$03
gui_specials_archer:
    .db $EC,$E0,$E1,$FF,$FF,$E2,$E3,$FC, $F0,$F1,$FF,$FF,$F2,$F3
gui_potions_icons:
    .db $90,$91,$FF,$FF,$90,$91,$A0,$A1,$FF,$FF,$A0,$A1, $21,$03,$FF,$FF,$21,$06

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; gui_init_player_stats
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
gui_init_player_stats:
    
    jsr gui_init_hp_player_stats
    jsr gui_init_mp_player_stats
    jsr gui_init_points_player
    jsr gui_init_coins_points_player
    jsr gui_init_keys_points_player
    jsr gui_init_specials_player_stats
    jsr gui_init_potions_player_stats
    
    rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; gui_init_hp_player_stats
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
gui_init_hp_player_stats:
    lda $2002
    lda #GUI_STATS_PLAYER_HP_POS_LOW
    sta $2006
    lda #GUI_STATS_PLAYER_HP_POS_HIGH
    sta $2006

    ldx #$00
    .loop:
        lda gui_hp_text_letters, x
        sta $2007
        inx
        cpx #$0A
        bne .loop
    rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; gui_init_mp_player_stats
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
gui_init_mp_player_stats:
    lda $2002
    lda #GUI_STATS_PLAYER_MP_POS_LOW
    sta $2006
    lda #GUI_STATS_PLAYER_MP_POS_HIGH
    sta $2006

    ldx #$00
    .loop: 
        lda gui_mp_text_letters, x
        sta $2007
        inx
        cpx #$0A
        bne .loop
    rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; gui_init_points_player
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
gui_init_points_player:
    lda $2002
    lda #$20
    sta $2006
    lda #$54
    sta $2006

    ldx #$00
    .loop: 

        lda gui_points_text_letters, x
        sta $2007
        inx
        cpx #$08
        bne .loop

    rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; gui_init_coins_points_player
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
gui_init_coins_points_player:
    lda $2002
    lda #$20
    sta $2006
    lda #$94
    sta $2006

    ldx #$00
    .loop: 

        lda gui_coins_text_letters, x
        sta $2007
        inx
        cpx #$08
        bne .loop

    rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; gui_init_keys_points_player
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
gui_init_keys_points_player:
    lda $2002
    lda #$28
    sta $2006
    lda #$D4
    sta $2006

    ldx #$00
    .loop: 
        lda gui_keys_text_letters, x
        sta $2007
        inx
        cpx #$04
        bne .loop

    rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; gui_init_specials_player_stats
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
gui_init_specials_player_stats:
    lda $2002
    lda #GUI_STATS_SELECTOR_POS_LOW
    sta $2006
    lda #GUI_STATS_SELECTOR_POS_HIGH_0
    sta $2006

.set_archer_specials:
    
    ldx #$00
    .loop:
        lda gui_specials_archer, x
        sta $2007
        inx
        cpx #$07
        beq .go_next_row
        jmp .continue

        .go_next_row:
            lda $2002
            lda #$21
            sta $2006
            lda #$77
            sta $2006

        .continue:
        cpx #$0E
        bne .loop

    rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; gui_init_potions_player_stats
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
gui_init_potions_player_stats:
    lda $2002
    lda #$21
    sta $2006
    lda #$D8
    sta $2006
    
    ldx #$00
    .loop:
        lda gui_potions_icons, x
        sta $2007
        inx
        cpx #$06
        beq .go_next_row
        jmp .continue

        .go_next_row:
            lda $2002
            lda #$21
            sta $2006
            lda #$F8
            sta $2006

        .continue:
        cpx #$0C
        bne .loop
    
    ; Posizioniamo i numeretti
    lda $2002
    lda #$22
    sta $2006
    lda #$18
    sta $2006
    .loop_num:

        lda gui_potions_icons, x
        sta $2007
        inx 
        cpx #$12
        bne .loop_num

    rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; gui_start_update_hp_player_stats
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
gui_start_update_hp_player_stats:
    inc GUI_UPDATE_HP
    rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; gui_put_dec_values_on_screen
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
gui_put_dec_values_on_screen:
    sta HIT_COUNT_VALUE
    jsr from_hex_to_decimal

    lda HIT_COUNT_CENTESIMAL
    sta $2007
    lda HIT_COUNT_DECIMAL
    sta $2007
    lda HIT_COUNT_UNIT
    sta $2007
    rts
    
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; gui_update_hp_player_stats
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
gui_update_hp_player_stats: 
    lda GUI_UPDATE_HP
    cmp #$00
    bne .update_hp_player

    jmp .exit

.update_hp_player:
    lda $2002
    lda #$20
    sta $2006
    lda #$45
    sta $2006

    lda PLAYER_STATUS_HP
    jsr gui_put_dec_values_on_screen

    lda #$24
    sta $2007

    lda PLAYER_STATUS_HP_TOTAL
    jsr gui_put_dec_values_on_screen

    dec GUI_UPDATE_HP
.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; gui_start_update_mp_player_stats
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
gui_start_update_mp_player_stats:
    inc GUI_UPDATE_MP
    rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; gui_update_mp_player_stats
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
gui_update_mp_player_stats: 
    lda GUI_UPDATE_MP
    cmp #$00
    bne .update_mp_player

    jmp .exit

.update_mp_player:
    lda $2002
    lda #$20
    sta $2006
    lda #$85
    sta $2006

    lda PLAYER_STATUS_MP
    jsr gui_put_dec_values_on_screen

    lda #$24
    sta $2007

    lda PLAYER_STATUS_MP_TOTAL
    jsr gui_put_dec_values_on_screen

    dec GUI_UPDATE_MP
.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; gui_select_next_slot
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
gui_update_select_next_slot:
    lda GUI_UPDATE_SLOT
    cmp #$01
    beq .must_update_gui_slot

    jmp .exit

.must_update_gui_slot:
    lda GUI_SLOT_SELECTED
    cmp #$00
    beq .set_indicator_on_slot_0
    cmp #$01
    beq .set_indicator_on_slot_1
    cmp #$02
    beq .set_indicator_on_slot_2
    cmp #$03
    beq .set_indicator_on_slot_3

.set_indicator_on_slot_0:
    lda #GUI_STATS_SELECTOR_POS_HIGH_0
    sta TEMP_A
    lda #GUI_STATS_SELECTOR_POS_HIGH_3
    sta TEMP_A_0
    jmp .continue
.set_indicator_on_slot_1:
    lda #GUI_STATS_SELECTOR_POS_HIGH_1
    sta TEMP_A
    lda #GUI_STATS_SELECTOR_POS_HIGH_0
    sta TEMP_A_0
    jmp .continue
.set_indicator_on_slot_2:
    lda #GUI_STATS_SELECTOR_POS_HIGH_2
    sta TEMP_A
    lda #GUI_STATS_SELECTOR_POS_HIGH_1
    sta TEMP_A_0
    jmp .continue
.set_indicator_on_slot_3:
    lda #GUI_STATS_SELECTOR_POS_HIGH_3
    sta TEMP_A
    lda #GUI_STATS_SELECTOR_POS_HIGH_2
    sta TEMP_A_0
    
.continue:
    ;Disegno la parte superiore della freccia
    lda $2002
    lda #GUI_STATS_SELECTOR_POS_LOW
    sta $2006
    lda TEMP_A
    sta $2006
    lda #$EC
    sta $2007

    ;Cancello la parte superiore precedente della freccia
    lda $2002
    lda #GUI_STATS_SELECTOR_POS_LOW
    sta $2006
    lda TEMP_A_0
    sta $2006
    lda #$FF
    sta $2007
    
    lda TEMP_A
    clc 
    adc #$20
    sta TEMP_A

    lda $2002
    lda #GUI_STATS_SELECTOR_POS_LOW
    sta $2006
    lda TEMP_A
    sta $2006
    lda #$FC
    sta $2007

    lda TEMP_A_0
    clc 
    adc #$20
    sta TEMP_A_0

    lda $2002
    lda #GUI_STATS_SELECTOR_POS_LOW
    sta $2006
    lda TEMP_A_0
    sta $2006
    lda #$FF
    sta $2007

    lda #$00
    sta GUI_UPDATE_SLOT

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; gui_select_next_slot
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
gui_select_next_slot:    
    lda #$01
    sta GUI_UPDATE_SLOT
    rts

gui_reset_select_slot:
    lda #$00
    sta GUI_SLOT_SELECTED
    jsr gui_select_next_slot
    rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; check_if_update_gui_stats
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
check_if_update_gui_stats:
    lda TS_COUNTER
    cmp #$00
    beq .update_mp_gui

.update_hp_gui:
    ; Il turno attuale non è quello del player
    ; quindi è il nemico che ha attaccato. Aggiorno
    ; quindi le stats degli HP.
    jsr gui_start_update_hp_player_stats 
    jmp .exit

.update_mp_gui:
    ; E' il turno del player, quindi aggiorno gli 
    ; MP nel caso in cui gli abbia usati.
    jsr gui_start_update_mp_player_stats

.exit:
    rts 

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; from_hex_to_decimal
; Traduce in maniera super veloce ( e poco elegante ), 
; da HEX 8 bit a un int 8 bit.
;:::::::::::::::::::::::::::::::::::::::::::::::::::::

from_hex_to_decimal:
    lda #$00
    sta HIT_COUNT_UNIT
    sta HIT_COUNT_DECIMAL
    sta HIT_COUNT_CENTESIMAL

    ldx #$00
    lda HIT_COUNT_VALUE
    cmp #$C7
    bcs .set_cent_as_2
    cmp #$63
    bcs .set_cent_as_1

    jmp .continue_cent

.set_cent_as_2:                 ; E' maggiore di 200?
    ldx #$02
    sbc #$C8
    jmp .continue_cent

.set_cent_as_1:                 ; E' maggiore di 100?
    ldx #$01
    sbc #$65

.continue_cent:
    sta HIT_COUNT_VALUE
    txa
    sta HIT_COUNT_CENTESIMAL

    lda HIT_COUNT_VALUE
    cmp #$59
    bcs .set_dec_as_9
    cmp #$4F
    bcs .set_dec_as_8
    cmp #$45
    bcs .set_dec_as_7
    cmp #$3B
    bcs .set_dec_as_6
    cmp #$31
    bcs .set_dec_as_5
    cmp #$27
    bcs .set_dec_as_4
    cmp #$1D
    bcs .set_dec_as_3
    cmp #$13
    bcs .set_dec_as_2
    cmp #$09
    bcs .set_dec_as_1

    jmp .continue_unit

.set_dec_as_9:
    ldx #$09
    sbc #$59

    jmp .continue_unit

.set_dec_as_8:
    ldx #$08
    sbc #$4F

    jmp .continue_unit

.set_dec_as_7:
    ldx #$07
    sbc #$45

    jmp .continue_unit

.set_dec_as_6:
    ldx #$06
    sbc #$3B

    jmp .continue_unit

.set_dec_as_5:
    ldx #$05
    sbc #$31

    jmp .continue_unit

.set_dec_as_4:
    ldx #$04
    sbc #$27

    jmp .continue_unit

.set_dec_as_3:
    ldx #$03
    sbc #$1D

    jmp .continue_unit

.set_dec_as_2:
    ldx #$02
    sbc #$13

    jmp .continue_unit

.set_dec_as_1:
    ldx #$01
    sbc #$09

    jmp .continue_unit

.continue_unit:
    sta HIT_COUNT_UNIT      ; Perché è il valore residuo al netto di cent e dec
    txa
    sta HIT_COUNT_DECIMAL   ; Mettiamo il valore decimale che abbiamo tenuto
                            ; nel registro X momentaneamente.

  rts