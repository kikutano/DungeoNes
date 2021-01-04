m_inc_by .macro
  lda \1
  clc
  adc \2
  sta \1
  .endm

m_dec_by .macro
  lda \1
  sec
  sbc \2
  sta \1
  .endm

;\1 high_address_upper_left_sprite
;\2 low_address_upper_right_sprite
;\3 upper_left_sprite
;\4 upper_right_sprite
;\5 high_address_down_left_sprite
;\6 low_address_down_right_sprite
;\7 down_left_sprite
;\8 down_right_sprite

;TAG: OTTIMIZZABILE

macro_draw_metatile_on_bg .macro

  lda $2002
  lda \1
  sta $2006
  lda \2
  sta $2006

  lda \3
  sta $2007
  lda \4
  sta $2007

  lda $2002
  lda \5
  sta $2006
  lda \6
  sta $2006

  lda \7
  sta $2007
  lda \8
  sta $2007

  .endm