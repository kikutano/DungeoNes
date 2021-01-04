RESET:
  sei          ; disable IRQs
  cld          ; disable decimal mode
  ldx #$40
  stx $4017    ; disable APU frame IRQ
  ldx #$FF
  txs          ; Set up stack
  inx          ; now X = 0
  stx $2000    ; disable NMI
  stx $2001    ; disable rendering
  stx $4010    ; disable DMC IRQs

vblankwait1:       ; First wait for vblank to make sure PPU is ready
  bit $2002
  bpl vblankwait1

clrmem:
  lda #$00
  sta $0000, x
  sta $0100, x
  sta $0300, x
  sta $0400, x
  sta $0500, x
  sta $0600, x
  sta $0700, x
  lda #$FE
  sta $0200, x
  inx
  bne clrmem

vblankwait2:      ; Second wait for vblank, PPU is ready after this
  bit $2002
  bpl vblankwait2
  
ClearFrameReady:
  lda #$00
  sta FRAME_READY

EnableNMI:
  lda #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1  -  ;;PPU clean up section, so rendering the next frame starts properly.
  sta $2000
  lda #%00011110   ; enable sprites, enable background, no clipping on left side
  sta $2001
  lda #$00         ;tell the ppu there is no background scrolling
  sta $2005
  sta $2005        ;all graphics updates done by here, run game engine