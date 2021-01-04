NMI:
  pha         ; back up registers (important)
  txa
  pha
  tya
  pha

  ;::::::::::::::::::::::::::::::::::::::::::::::::::::
  ; CHR SWITCHER
  ;::::::::::::::::::::::::::::::::::::::::::::::::::::
  lda #%00000000
  sta $8000
  ;::::::::::::::::::::::::::::::::::::::::::::::::::::
  ;::::::::::::::::::::::::::::::::::::::::::::::::::::

  lda FRAME_READY ;first time through will be 0
  cmp #READY      ;01
  bne JumpNMIDone
  jmp JumpSpriteDMA

JumpNMIDone:
  jmp NMIDone

JumpSpriteDMA:

  ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; GRAPHICS UPDATES
  ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  jsr background_set_tile
  jsr update_meta_sprites_translation
  jsr update_check_ongridsprite_an_must_update
  jsr update_sprite_hit_count
  jsr update_sprite_hit_shake_an

  ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; GUI UPDATES
  ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  jsr gui_update_hp_player_stats
  jsr gui_update_mp_player_stats
  jsr gui_update_select_next_slot
  
  ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ; GRAPHICS UPDATES -> END
  ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  ;lda GAME_STATE
  ;sta $0600

  lda GAME_STATE
  cmp #GAME_STATE_FADE_OUT_MATRIX
  beq jmp_fade_out_update
  cmp #GAME_STATE_FADE_IN_MATRIX
  beq jmp_fade_in_update
  cmp #GAME_STATE_GAME_PLAY
  beq jmp_gameplay_update
  
jmp_fade_out_update:
  jsr fade_out_update
  jmp exit_state_update

jmp_fade_in_update:
  jsr fade_in_update
  jmp exit_state_update

jmp_gameplay_update:
  ;do_nothing

exit_state_update:
  jmp SpriteDMA

SpriteDMA:
  lda #$00
  sta $2003       ; set the low byte (00) of the RAM address
  lda #$02
  sta $4014       ; set the high byte (02) of the RAM address, start the transfer

CleanUp:
  lda #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1  -  ;;PPU clean up section, so rendering the next frame starts properly.
  sta $2000
  lda #%00011110   ; enable sprites, enable background, no clipping on left side
  sta $2001
  lda #$00        ;;tell the ppu there is no background scrolling
  sta $2005
  sta $2005       ;;;all graphics updates done by here, run game engine

ClearReadyFlag:   ;Clear flagready to be reinstated by MainLoop frame.
  lda #$00
  sta FRAME_READY

NMIDone:

  pla           ; restore regs and exit
  tay
  pla
  tax
  pla

  rti