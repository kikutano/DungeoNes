level_0_rooms_enemies:
  .dw level_0_room_0_enemies
  .dw level_0_room_1_enemies
  .dw level_0_room_2_enemies

; up, right, down, left
level_0_room_0_door_links:
  .db $00,$00,$01,$03
level_0_room_1_door_links:
  .db $00,$00,$02,$00
level_0_room_2_door_links:
  .db $01,$02,$02,$02

  ; $00 salta il turno
  ; $01 il player
  ; $02 enemy_0
  ; $03 enemy_1
  ; $04 enemy_2 
pawn_turns:
  .db $01,$02,$03,$04,$FF

;::::::::::::::::::::::::::::::::::::::::::::::::
;            * ENEMIES STATS 2.0 *
;                 HP, STR, DEF
;::::::::::::::::::::::::::::::::::::::::::::::::
enemies_stats:
  ;none:
  .db $00,$00,$00
  ;smile:
  ;.db $05,$03,$02
  .db $05,$00,$02
  ;bat:
  ;.db $04,$02,$01
  .db $04,$00,$01

level_0_room_0_enemies:
  .db CELL_EN_NONE
  .db CELL_EN_NONE
  .db CELL_EN_NONE
level_0_room_1_enemies:
  .db CELL_EN_BAT
  .db CELL_EN_BAT
  .db CELL_EN_NONE
level_0_room_2_enemies:
  .db CELL_EN_SMILE
  .db CELL_EN_SMILE
  .db CELL_EN_BAT

;:::::::::::::::::::::::::::::::::::::::::::::::
;        * LEVEL TILES DESCRIPTOR *
; Di seguito ci sono i tile da mettere sullo 
; sfondo. Ad esempio $54 è il mattone "normale".
;:::::::::::::::::::::::::::::::::::::::::::::::
tile_translator:
  .db $54 ;$00
  .db $56 ;$01
  .db $36 ;$02
  .db $7C ;$03
  .db $36 ;$04
  .db $B0 ;$05
  .db $34 ;$06
  .db $3A ;$07
  .db $38 ;$08
  .db $5A ;$09
  .db $58 ;$0A
  .db $74 ;$0B
  .db $72 ;$0C
  .db $52 ;$0D
  .db $50 ;$0E
  .db $30 ;$0F
  .db $32 ;$10
  .db $70 ;$11
  .db $EE ;$12
  .db $54 ;$13 Enemy 0
  .db $54 ;$14 Enemy 1
  .db $54 ;$15 Enemy 2
  .db $54 ;$16

level_0_occs_rooms:
 .dw l_0_0
 .dw l_1_0
 .dw l_1_1

l_0_0:
 .db $07,$06,$06,$02,$06,$06,$06,$08
 .db $09,$00,$00,$00,$00,$00,$00,$0A
 .db $09,$00,$00,$00,$00,$00,$00,$0A
 .db $09,$00,$00,$00,$00,$00,$00,$0A
 .db $09,$00,$00,$00,$00,$00,$00,$0A
 .db $09,$00,$00,$00,$00,$00,$00,$0A
 .db $09,$00,$00,$00,$00,$00,$00,$0A
 .db $0E,$06,$06,$04,$06,$06,$06,$0D

l_1_0:
 .db $07,$06,$06,$02,$06,$06,$06,$08
 .db $09,$00,$00,$00,$00,$00,$00,$0A
 .db $09,$00,$00,$00,$00,$00,$00,$0A
 .db $09,$00,$00,$00,$00,$00,$00,$0A
 .db $09,$00,$00,$00,$00,$00,$00,$0A
 .db $09,$00,$13,$00,$14,$00,$00,$0A
 .db $09,$00,$00,$00,$00,$00,$00,$0A
 .db $0E,$06,$06,$04,$06,$06,$06,$0D

 l_1_1:
 .db $07,$06,$06,$02,$06,$06,$06,$08
 .db $09,$00,$00,$00,$00,$00,$00,$0A
 .db $09,$13,$00,$00,$00,$14,$00,$0A
 .db $09,$00,$00,$00,$00,$00,$00,$0A
 .db $09,$00,$00,$00,$00,$00,$00,$0A
 .db $09,$00,$15,$00,$00,$00,$00,$0A
 .db $09,$00,$00,$00,$00,$00,$00,$0A
 .db $0E,$06,$06,$04,$06,$06,$06,$0D

 level_0_doors_links:
 .dw d_0_0
 .dw d_1_0
 .dw d_1_1

 d_0_0:
 .db $00,$00,$01,$00
 d_1_0:
 .db $0,$2,$00,$00
 d_1_1:
 .db $00,$00,$03,$01