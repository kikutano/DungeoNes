;variables
;; VARIABLES
  .rsset $0000  ;;start variables at ram location 0

;::::::::::::::::::::::::::::::::::::::::::::
; Vars 2.0
;::::::::::::::::::::::::::::::::::::::::::::
; La posizione in matrice, della cella che sta muovendo
CURR_PAWN_CELL_POS    .rs 1
; Il tipo di pedina che attualmente sta muovendo 
CURR_PAWN_TYPE        .rs 1
; Il valore per il quale andiamo ad incrementare una cella
SUM_VALUE_TO_INC_CELL .rs 1 
;::::::::::::::::::::::::::::::::::::::::::::

GFX_SPRITES_UPDATE     .rs 1
GFX_SPRITE_TRANS_COUNT .rs 1
GFX_SPRITE_TRANS_ADDR  .rs 2
GFX_SPRITE_TRANS_DIREC .rs 1

CURRENT_CELL_POINTER   .rs 1
CELL_START             .rs 1
CELL_TO_REACH          .rs 1

CELL_TO_POINT     .rs 1 ; La cella in cui vogliamo spostare un oggetto
CELL_CONTAINER    .rs 1 ; Cosa contiene quella determinata cella?
PTR_RAM_ITEM      .rs 2
PTR_ITEM_TO_LOAD  .rs 2
TEMP_Y            .rs 1
TEMP_X            .rs 1
TEMP_A            .rs 1
TEMP_A_0          .rs 1
TEMP_A_1          .rs 1

PAWN_PTR           .rs 2
ENEMY_PTR          .rs 2

GENERIC_PTR           .rs 2
GENERIC_PTR_1         .rs 2
GENERIC_PTR_2         .rs 2

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Cells Shower
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CELL_SHOWER_ADDR_LOW  .rs 1
CELL_SHOWER_ADDR_HIGH .rs 1

CELL_SELECTED         .rs 1
CELL_SELECTED_PREV    .rs 1
CELL_INDICATOR_POS    .rs 1

CELL_INDEX         .rs 1 ; Contenitore per mettere la cella in cui è un nemico da
                         ; esaminare

CURRENT_ROOM_COUNTER .rs 1
PLAYER_ON_CELL_VALUE .rs 1 ;La cella su cui deve posizionarsi il player
                           ;al caricamento di una nuova stanza

; TURN SYSTEM
TS_CURR_PAWN      .rs 1; La pedina che attualmente può essere mossa
TS_COUNTER        .rs 1; Counter dell'attuale casella del turno 
TS_TICKING_TICKS  .rs 1 ; Il tempo che deve passare prima che l'AI possa fare
                        ; la prossima mossa.



GAME_STATE    .rs 1

MATRIX_FADE_OUT_COL_ADDR_LOW  .rs 1
MATRIX_FADE_OUT_COL_ADDR_HIGH .rs 1

CAN_INPUT         .rs 1       ; Va disattivato nel momento in cui c'è una transizione

FRAME_READY             .rs 1
ADDR_LOW                .rs 1
ADDR_HIGH               .rs 1

BUTTONS                .rs 1
BUTTONS_PREV           .rs 1

FADE_IN_COUNT      .rs 1
FADE_IN_ROWS_COUNT .rs 1
BG_TILE_LEFT       .rs 1
BG_TILE_RIGHT      .rs 1

ROOM_DOORS_TO_LOAD_ADDR    .rs 2
ROOM_OCCS_TO_LOAD_ADDR     .rs 2
ROOM_TURNS_TO_LOAD_ADDR    .rs 2
ROOM_ENEMIES_TO_LOAD_ADDR  .rs 2
MATRIX_OCCS_ADDR           .rs 2
MATRIX_TILE_MAP_POINTER .rs 1
MATRIX_FADE_OUT_TICKS   .rs 1

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; COMBAT
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INDICATOR_TYPE           .rs 1 ; 1 se dobbiamo mostrare Exp nel count
HIT_COUNT_VALUE          .rs 1
HIT_COUNT_UNIT           .rs 1
HIT_COUNT_DECIMAL        .rs 1
HIT_COUNT_CENTESIMAL     .rs 1
STR_POWER_BONUS          .rs 1 ; Il valore bonus dell'attacco attuale
STR_POWER_BONUS_INDEX    .rs 1
INT_POWER_BONUS          .rs 1
INT_POWER_BONUS_INDEX    .rs 1
STR_POWER_BONUS_EN       .rs 1
STR_POWER_BONUS_EN_INDEX .rs 1
ENEMIES_STR_SET          .rs 1 ; Livello dei nemici

CELL_INDICATOR_ON     .rs 1

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ANIMATIONS
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
AN_SPRITE_X             .rs 1
AN_SPRITE_Y             .rs 1
AN_SPRITE_X_0           .rs 1
AN_SPRITE_Y_0           .rs 1
AN_TICKS_COUNT          .rs 1
AN_SPRITE_ON            .rs 1
AN_SPRITE_TYPE          .rs 1
AN_SPRITE_FRAME_COUNT   .rs 1
AN_SPRITE_COUNT_UPDATE  .rs 1
AN_SHAKE_ON             .rs 1
AN_ATTR_SAVED           .rs 1
AN_SPECIAL_EFFECT_COUNT .rs 1

AN_PAWN_SPRITE_TICKS   .rs 1
AN_PAWN_SPRITE_COUNT   .rs 1

AN_PAWN_BUFFER_START_AT .rs 1

AN_JUMP_DIR_FACTOR      .rs 1 ; E' il valore che viene sommato per spostare la pedina
                              ; a destra o a sinistra. #$01 a destra, #$FF a destra.
AN_JUMP_COUNT           .rs 1
UPDATE_BACKGROUND_TILE  .rs 1
BACKGROUND_CELL_CHANGE  .rs 1
BACKGROUND_TILE_TO_SET  .rs 1

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; IN GAME UI
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GUI_UPDATE_HP     .rs 1
GUI_UPDATE_MP     .rs 1
GUI_UPDATE_SLOT   .rs 1