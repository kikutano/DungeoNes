;dungeon_level_manager.asm

;:::::::::::::::::::::::::::::::::::::::::
; load_and_init_dungeon
;:::::::::::::::::::::::::::::::::::::::::
load_and_init_dungeon:
   lda #$00
   sta $2001  ;Turn Screen Off

  jsr init_starting_stats_on_dungeon
  ;:::::::::::::::::::::::::::::::::::::::::::::::::::::
  ; Disegnamo l'intero Background
  ;:::::::::::::::::::::::::::::::::::::::::::::::::::::
  jsr load_dungeon_level_background
  ;:::::::::::::::::::::::::::::::::::::::::::::::::::::
  ; Disegnamo la UI iniziale 
  ;:::::::::::::::::::::::::::::::::::::::::::::::::::::
  jsr load_and_init_dungeon_gui
  ;:::::::::::::::::::::::::::::::::::::::::::::::::::::
  ; Inizializziamo la stanza la prima volta
  ;:::::::::::::::::::::::::::::::::::::::::::::::::::::
  jsr init_starting_level_dungeon
  
  rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; load_dungeon_level_background 
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
load_dungeon_level_background:
  lda $2002             
  lda #$20
  sta $2006             
  lda #$00
  sta $2006             
  
  ;Mettiamo il background tutto a nero
  ldx #$04              
  ldy #$00              
.load_background_loop:
  lda #$FF
  sta $2007
  iny
  bne .load_background_loop
    inc ADDR_HIGH            
    dex                      
    bne .load_background_loop

.load_palettes:
  lda $2002             
  lda #$3F
  sta $2006             
  lda #$00
  sta $2006             
  ldx #$00              
.load_palettes_loop:
  lda Palettes, x   
  sta $2007                     
  inx                           
  cpx #$20          
  bne .load_palettes_loop

.load_attribute:
  lda $2002             
  lda #$23
  sta $2006             
  lda #$C0
  sta $2006
               
  ldx #$00              
.load_attribute_loop:
  lda Attribute_Level, x      
  sta $2007             
  inx                   
  cpx #$40            
  bne .load_attribute_loop

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; show_game_version_on_bg (todo: Remove from here!)
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
.show_game_version_on_bg:
  macro_draw_tile_on_bg #$2B, #$7A, #$00
  macro_draw_tile_on_bg #$2B, #$7B, #$27
  macro_draw_tile_on_bg #$2B, #$7C, #$01
  macro_draw_tile_on_bg #$2B, #$7D, #$27
  macro_draw_tile_on_bg #$2B, #$7E, #$00

  rts 

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; load_and_init_dungeon_gui
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
load_and_init_dungeon_gui:
  jsr gui_init_player_stats
  jsr gui_start_update_hp_player_stats
  jsr gui_update_hp_player_stats
  jsr gui_start_update_mp_player_stats
  jsr gui_update_mp_player_stats
  rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; init_starting_level_dungeon
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
init_starting_level_dungeon:
  ;Posizioniamo il player sulla mappa
  lda #$00
  sta CURRENT_ROOM_COUNTER
  lda #MAP_CELL_DOOR_UP
  sta PLAYER_ON_CELL_VALUE

  ldx #$00
  lda level_0_doors_links     + 0, x
  sta ROOM_DOORS_TO_LOAD_ADDR + 0
  lda level_0_doors_links     + 1, x
  sta ROOM_DOORS_TO_LOAD_ADDR + 1

  jsr init_room_specs_on_memory
  jsr load_lvl_mat_occs    
  jsr set_player_on_next_door2
  jsr turn_system_init
  jsr set_pawn_an_player_idle

  lda #$21
  sta MATRIX_FADE_OUT_COL_ADDR_LOW
  lda #$13
  sta MATRIX_FADE_OUT_COL_ADDR_HIGH

  lda GAME_STATE_FADE_OUT_MATRIX
  sta GAME_STATE
  rts