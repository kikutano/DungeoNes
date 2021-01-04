;:::::::::::::::::::::::::::::::::::::::::
; disable_input
;:::::::::::::::::::::::::::::::::::::::::
disable_input:
  lda #$00
  sta CAN_INPUT
  rts

;:::::::::::::::::::::::::::::::::::::::::
; enable_input
;:::::::::::::::::::::::::::::::::::::::::
enable_input:
  lda #$01
  sta CAN_INPUT
  rts

gp_update_player_controls:

    lda CAN_INPUT
    cmp #$01
    beq .can_read_input

    rts

.can_read_input
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; Joystick Input Read
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    lda #$01
    sta $4016
    sta BUTTONS 
    lsr a
    sta $4016
    loop_read_inputs:
        lda $4016
        lsr a
        rol BUTTONS
        bcc loop_read_inputs

read_inputs_controls:
    lda BUTTONS                     ; Se il pulsante è tenuto premuto lo ignoriamo
    cmp BUTTONS_PREV
    bne .can_read_input

    jmp input_read_exit

.can_read_input:

read_for_SELECT_input:

    lda BUTTONS
    and #%00100000                  ; SELECT
    cmp #%00100000  
    beq jmp_SELECT_pressed

    jmp read_for_START_input

jmp_SELECT_pressed:
    jmp SELECT_pressed

read_for_START_input:
    lda BUTTONS
    and #%00010000
    cmp #%00010000
    beq jmp_START_pressed

    jmp read_for_A_input

jmp_START_pressed:
    jmp START_pressed

read_for_A_input:
    lda BUTTONS
    and #%10000000                  ; A
    cmp #%10000000
    beq jmp_A_pressed

    jmp read_for_B_input

jmp_A_pressed:
    jmp A_pressed

read_for_B_input:
    lda BUTTONS
    and #%01000000                  ; B
    cmp #%01000000
    beq jmp_B_pressed

    jmp read_for_UP_pressed

jmp_B_pressed:
    jmp B_pressed

read_for_UP_pressed:
    lda BUTTONS
    and #%00001000                  ; UP
    cmp #%00001000
    beq jmp_UP_pressed

    jmp read_for_DOWN_pressed

jmp_UP_pressed:
    jmp UP_pressed

read_for_DOWN_pressed:

    lda BUTTONS
    and #%00000100                  ; DOWN
    cmp #%00000100
    beq jmp_DOWN_pressed

    jmp read_for_LEFT_pressed

jmp_DOWN_pressed:
    jmp DOWN_pressed

read_for_LEFT_pressed:

    lda BUTTONS
    and #%00000010                  ; LEFT
    cmp #%00000010
    beq jmp_LEFT_pressed

    jmp read_for_RIGHT_pressed

jmp_LEFT_pressed:
    jmp LEFT_pressed

read_for_RIGHT_pressed:

    lda BUTTONS
    and #%00000001                  ; RIGHT
    cmp #%00000001
    beq jmp_RIGHT_pressed

    jmp input_read_exit

jmp_RIGHT_pressed:
    jmp RIGHT_pressed

SELECT_pressed:
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; SELECT PRESSED
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    jsr button_pressed_SELECT
    jmp input_read_exit
    
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; SELECT PRESSED -> END
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

START_pressed:
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; START PRESSED
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    jmp input_read_exit
    
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; START PRESSED -> END
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

A_pressed:
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; A PRESSED
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    jsr button_pressed_A
    jmp input_read_exit

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; A PRESSED -> END
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

B_pressed:
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; B PRESSED
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    jsr button_pressed_B
    jmp input_read_exit

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; B PRESSED -> END
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

UP_pressed:
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; UP PRESSED
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    jsr move_pawn_up
    ;jsr turn_system_up_pressed
    jmp input_read_exit

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; UP PRESSED -> END
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DOWN_pressed:
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; DOWN PRESSED
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    jsr move_pawn_down
    ;jsr turn_system_down_pressed
    jmp input_read_exit

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; DOWN PRESSED -> END
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

LEFT_pressed:
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; LEFT PRESSED
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    jsr move_pawn_left
    ;jsr turn_system_left_pressed
    jmp input_read_exit

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; LEFT PRESSED -> END
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

RIGHT_pressed:
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; RIGHT PRESSED
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
     jsr move_pawn_right
    ;jsr turn_system_right_pressed
    jmp input_read_exit

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; RIGHT PRESSED -> END
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

input_read_exit:
    lda BUTTONS
    sta BUTTONS_PREV

    lda BUTTONS
    cmp #$00
    bne .something_pressed

    lda #$00
    sta BUTTONS_PREV

.something_pressed:
    rts