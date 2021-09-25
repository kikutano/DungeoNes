READY                   = $01

;--Data to be copied to OAM during next vertical blank $0200->$02FF
RAM_AN_HIT              = $0200
RAM_CELL_INDICATOR      = $0210
RAM_PLAYER              = $0220
RAM_ENEMY_0             = $0230
RAM_ENEMY_1             = $0240
RAM_ENEMY_2             = $0250
RAM_ITEM_0              = $0260
RAM_ITEM_1              = $0270
RAM_ITEM_2              = $0280
;-- OAM end 

;-- $0400-$07FF Arrays and less-often-accessed global variables
RAM_ROOM_CELLS          = $0400

; Da $0440 -> $0443 ci sono le celle occupate ATTUALI
; Da $0444 -> $0448 ci sono le celle occupate nel turno PRIMA
CELLS_PAWNS_OCCS_ARRAY  = $0440 ; Array che contiene le celle occupate dalle pedine

;::::::::::::::::::::::::::::::::::::::::::::::::::::
; Pawns Status
;::::::::::::::::::::::::::::::::::::::::::::::::::::

PLAYER_STATUS_HP_LVL    = $0550
PLAYER_STATUS_MP_LVL    = $0551
PLAYER_STATUS_STR_LVL   = $0552
PLAYER_STATUS_INT_LVL   = $0553
PLAYER_STATUS_DEF_LVL   = $0554

PLAYER_STATUS_HP        = $0500
PLAYER_STATUS_MP        = $0501
PLAYER_STATUS_STR       = $0502
PLAYER_STATUS_INT       = $0503
PLAYER_STATUS_DEF       = $0504
PLAYER_STATUS_HP_TOTAL  = $0505
PLAYER_STATUS_MP_TOTAL  = $0506

EN_0_STATUS_HP          = $0507
EN_0_STATUS_MP          = $0508
EN_0_STATUS_STR         = $0509
EN_0_STATUS_INT         = $050A
EN_0_STATUS_DEF         = $050B

EN_1_STATUS_HP          = $050C
EN_1_STATUS_MP          = $050D
EN_1_STATUS_STR         = $050E
EN_1_STATUS_INT         = $050F
EN_1_STATUS_DEF         = $0510

EN_2_STATUS_HP          = $0511
EN_2_STATUS_MP          = $0512
EN_2_STATUS_STR         = $0513
EN_2_STATUS_INT         = $0514
EN_2_STATUS_DEF         = $0515

PAWN_SENDER_STATS_HP        = $0516
PAWN_SENDER_STATS_MP        = $0517
PAWN_SENDER_STATS_STR       = $0518
PAWN_SENDER_STATS_INT       = $0519
PAWN_SENDER_STATS_DEF       = $051A

PAWN_RECIEVER_STATS_HP      = $051B
PAWN_RECIEVER_STATS_MP      = $051C
PAWN_RECIEVER_STATS_STR     = $051D
PAWN_RECIEVER_STATS_INT     = $051E
PAWN_RECIEVER_STATS_DEF     = $051F

CURRENT_SENDER_STATS_PTR    = $0520 ; Chi sta muovendo?
CURRENT_RECIEVER_STATS_PTR  = $0521 ; Chi sta ricevendo l'attacco/magia/item?
DROP_RANDOM_ITEM_AVAILABLE  = $0522
LAST_ENEMY_KILLED_CELL      = $0523 ; Cell position of last enemy killed
LAST_ENEMY_KILLED_NUM       = $0524 ; enemy 0, 1 or 2

ENEMIES_STR_SET_EASY    = $00
ENEMIES_STR_SET_NORMAL  = $01
ENEMIES_STR_SET_HARD    = $02

;::::::::::::::::::::::::::::::::::::::::::::::::::::
; Special Attack 
;::::::::::::::::::::::::::::::::::::::::::::::::::::
GUI_SLOT_SELECTED = $0525 ; Indicatore da 0 a 3 per selezionare 
                          ; le due special o le pozioni

SM_CELLS_MAX_0    = $0526 ; Di quante celle è possibile muovere per questo attacco
SM_MP_CONSUME_0   = $0527 ; Quanto MP consuma
SM_TYPE_0         = $0528 ; Che tipo di mossa è?

SM_CELLS_MAX_1    = $0529 ; Di quante celle è possibile muovere per questo attacco
SM_MP_CONSUME_1   = $052A ; Quanto MP consuma
SM_TYPE_1         = $052B ; Che tipo di mossa è?

SM_CELLS_MAX_SEL    = $052C
SM_MP_CONSUME_SEL   = $052D
SM_TYPE_SEL         = $052E

SM_ATK            = $00
SM_MOVE           = $01

;::::::::::::::::::::::::::::::::::::::::::::::::::::
; Hero Selected
;::::::::::::::::::::::::::::::::::::::::::::::::::::
HERO_CLASS_SELECTED = $0532

HERO_WARRIOR = $00
HERO_ARCHER  = $01
HERO_WIZARD  = $02

;::::::::::::::::::::::::::::::::::::::::::::::::::::
; PAWNS ANIMATIONS
;::::::::::::::::::::::::::::::::::::::::::::::::::::

ANIMATIONS_PAWNS_FRAME_0 = $0560 ; 16 byte
ANIMATIONS_PAWNS_FRAME_1 = $0570 ; 16 byte

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

ENEMY_0_CELL_INDEX      = $0600
ENEMY_1_CELL_INDEX      = $0601
ENEMY_2_CELL_INDEX      = $0602

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ANIMATIONS
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
AN_SPRITES_ARRAY       = $0660 ; L'array di 6 caselle ( due per ogni sprite ) con gli sprites 

;::::::::::::::::::::::::::::::::::::::::::::::::::::
; ROOM RANDOMIZE
;::::::::::::::::::::::::::::::::::::::::::::::::::::
ROOM_RANDOM_SELECTOR_COUNT = $0670 ; Counter of room selector
ROOM_RANDOM_SIZE           = $02

AN_INDEX_HIT  = $06
AN_INDEX_PUFF = $26
AN_INDEX_DEAD = $16

PPUSTATUS           = $2002
PPUADDR             = $2006
PPUDATA             = $2007
START_ADDR_MATRIX   = $2103 
MATRIX_ROWS         = $10 ; == 16 righe di tiles
MATRIX_COLS         = $10 ; == 16 colonne di tiles
TILE                = $C2   

GAME_STATE_MAIN_SCREEN      = $01
GAME_STATE_FADE_IN_MATRIX   = $02
GAME_STATE_FADE_OUT_MATRIX  = $03
GAME_STATE_GAME_PLAY        = $04

;::::::::::::::::::::::::::::::::::::
; Room Items
;::::::::::::::::::::::::::::::::::::
CELL_PLAYER         = $99

CELL_ENEMY_0        = $13
CELL_ENEMY_1        = $14
CELL_ENEMY_2        = $15
CELL_POTION         = $16

;::::::::::::::::::::::::::::::::::::::::::::::::::::
; Enemies Id
;::::::::::::::::::::::::::::::::::::::::::::::::::::
CELL_EN_NONE        = $00
CELL_EN_BAT         = $06
CELL_EN_SMILE       = $03

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; IN GAME UI
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GUI_STATS_PLAYER_HP_POS_LOW     = $20
GUI_STATS_PLAYER_HP_POS_HIGH    = $42
GUI_STATS_PLAYER_MP_POS_LOW     = $20
GUI_STATS_PLAYER_MP_POS_HIGH    = $82
GUI_STATS_SELECTOR_POS_LOW      = $21
GUI_STATS_SELECTOR_POS_HIGH_0   = $57 
GUI_STATS_SELECTOR_POS_HIGH_1   = $5B
GUI_STATS_SELECTOR_POS_HIGH_2   = $D7
GUI_STATS_SELECTOR_POS_HIGH_3   = $DB

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; IN GAME INDICATOR COUNT
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INDICATOR_HIT_COUNT     = $00
INDICATOR_COIN_COUNT    = $03

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GFX ANIMATIONS
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GFX_SPRITE_TRANS_UP    = $00
GFX_SPRITE_TRANS_DOWN  = $01
GFX_SPRITE_TRANS_LEFT  = $02
GFX_SPRITE_TRANS_RIGHT = $03

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; LEVEL MAP IDS
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
MAP_EMPTY_FLOOR_00          = $00
MAP_EMPTY_FLOOR_01          = $01
; Doors
MAP_CELL_DOOR_UP            = $02
MAP_CELL_DOOR_RIGHT         = $03
MAP_CELL_DOOR_DOWN          = $04
MAP_CELL_DOOR_LEFT          = $05
; Not Walkable
MAP_WALL_FLAT               = $06
MAP_WALL_COR_LEFT_UP        = $07
MAP_WALL_COR_UP_RIGHT       = $08
MAP_WALL_FLAT_LEFT          = $09
MAP_WALL_FLAT_RIGHT         = $0A
MAP_WALL_COR_LEFT_F         = $0B ; con un po' di pavimento
MAP_WALL_COR_RIGHT_F        = $0C ; con un po' di pavimento
MAP_WALL_COR_DOWN_RIGHT     = $0D
MAP_WALL_COR_DOWN_LEFT      = $0E
MAP_WALL_COR_DOWN_RIGHT_F   = $0F
MAP_WALL_COR_DOWN_LEFT_F    = $10
MAP_FLOOR_HOLE              = $11
MAP_EMPTY_SLOT              = $12