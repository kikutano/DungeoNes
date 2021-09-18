; graphics.asm

jump_params:
  .db $FB,$FC,$FD,$FE,$FF,$FF,$FF,$FF, $01,$01,$01,$01,$02,$03,$04,$05

;up->down
jump_params_y_up_down:
  .db $FD,$FE,$FF,$FF,$FF, $00,$00,$00,$00,$00, $02,$03,$03,$03,$05,$08 

;down->up
jump_params_y_down_up:
  .db $FB,$FC,$FC,$FC,$FD,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$01,$03,$04

;=============================================
; Sprites
;=============================================
Palettes: 
  ;0: Level Background
  ;1: UI Background
  ;2: Title Screen
  ;3: Start Button

  ;0: Player
  ;1: Floating Score
  ;2: 
  ;3: Mole color
 
 .db $0C,$2D,$00,$10,  $0C,$15,$38,$20,  $0C,$27,$07,$30,  $0C,$05,$15,$35  ;;background palette
 ;knight
 ;.db $0F,$0C,$2C,$38,  $0F,$15,$0D,$10,  $0F,$21,$30,$3C,  $0F,$26,$05,$0D  ;;sprite palette
 ;mage
 ;.db $0F,$0C,$27,$2C,  $0F,$1D,$22,$32,  $0F,$21,$30,$3C,  $0F,$26,$05,$0D  ;;sprite palette
 ;archer
 .db $0F,$09,$29,$37,  $0F,$1D,$22,$32,  $0F,$21,$30,$3C,  $0F,$26,$05,$0D  ;;sprite palette

Attribute_Level: 
  .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
  .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %10101010, %10101010, %10101010
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %10101010, %11111111, %10101010
  .db %00000000, %00000000, $00000000, %00000000, %00000000, %10101010, %11111111, %10101010
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %10101010
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000

sprites_indicator:
  .db $70, $0C, %00000000, $50
  .db $70, $0C, %01000000, $58
  .db $78, $1C, %00000000, $50
  .db $78, $1C, %01000000, $58

sprites_player:
  .db $40, $00, %00000000, $30
  .db $40, $01, %00000000, $38
  .db $48, $10, %00000000, $30
  .db $48, $11, %00000000, $38

sprites_player_mage:
  .db $40, $20, %00000000, $30
  .db $40, $21, %00000000, $38
  .db $48, $30, %00000000, $30
  .db $48, $31, %00000000, $38

sprites_player_archer:
  .db $40, $40, %00000000, $30
  .db $40, $41, %00000000, $38
  .db $48, $50, %00000000, $30
  .db $48, $51, %00000000, $38

sprites_player_idle_0:
  .db $00, $01, $10, $11
sprites_player_idle_1:
  .db $02, $03, $12, $13

sprites_player_mage_idle_0:
  .db $20, $21, $30, $31
sprites_player_mage_idle_1:
  .db $22, $23, $32, $33

sprites_player_archer_idle_0:
  .db $40, $41, $50, $51
sprites_player_archer_idle_1:
  .db $42, $43, $52, $53

sprites_dead:
  .db $FF, $FF, $FF, $FF

;::::::::::::::::::::::::::::::::::::
; Enemies Sprites
;::::::::::::::::::::::::::::::::::::
sprites_bat_idle_0:
  .db $04, $05, $14, $15, %00000011
sprites_bat_idle_1:
  .db $24, $25, $34, $35

sprites_smile_an_0:
  .db $44, $45, $54, $55, %00000001
sprites_smile_an_1:
  .db $64, $65, $74, $75

;::::::::::::::::::::::::::::::::::::
; Items Sprites
;::::::::::::::::::::::::::::::::::::
sprites_potion:
  .db $81, $82, $91, $92, %00000010

;=============================================
; Cells Sprites
;=============================================
sprites_cell_walk:
  .db $68,$69,$78,$79 

;=============================================
; Backgrounds
;=============================================
Palette_StartScreen:
  ;0: Credits
  ;1: 
  ;2: Title Screen
  ;3: Start Button
 .db $0F,$16,$00,$30,  $0F,$27,$07,$37,  $0F,$27,$07,$37,  $0F,$05,$15,$35  ;;background palette
 .db $0F,$21,$11,$31,  $0F,$29,$21,$39,  $0F,$18,$19,$20,  $0F,$27,$0D,$15  ;;sprite palette

Palette_GameOver:
  ;0:
  ;1: Background and Corner
  ;2: Total Score
  ;3: 
   
 .db $0F,$27,$07,$37,  $0F,$29,$09,$39,  $0F,$1C,$09,$29,  $0F,$05,$15,$35  ;;background palette
 .db $0F,$21,$11,$31,  $0F,$29,$21,$39,  $0F,$18,$19,$20,  $0F,$27,$0D,$15  ;;sprite palette

;:::::::::::::::::::::::::::::::::::::::::::::::::::
; ACTION AREA
;:::::::::::::::::::::::::::::::::::::::::::::::::::

; 00  01 02 03 04 05 06  07

; 08  09 10 11 12 13 14  15
; 16  17 18 19 20 21 22  23
; 24  25 26 27 28 29 30  31
; 32  33 34 35 36 37 38  39
; 40  41 42 43 44 45 46  47
; 48  49 50 51 52 53 54  55

; 56  57 58 59 60 61 62  63


; 00  01 02 03 04 05 06  07

; 08  09 0A 0B 0C 0D 0E  0F
; 10  11 12 13 14 15 16  17
; 18  19 1A 1B 1C 1D 1E  1F
; 20  21 22 23 24 25 26  27
; 28  29 2A 2B 2C 2D 2E  2F
; 30  31 32 33 34 35 36  37

; 38  39 3A 3B 3C 3D 3E  3F
