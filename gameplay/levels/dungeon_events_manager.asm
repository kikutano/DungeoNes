;dungeon_events_manager

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; on_player_movement_done
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
on_player_movement_done:
  ldx CELL_SELECTED               ; Controlliamo se è su una della 4 porte
  lda RAM_ROOM_CELLS, x
  cmp #MAP_CELL_DOOR_UP
  beq .door_0_selected
  cmp #MAP_CELL_DOOR_RIGHT
  beq .door_1_selected
  cmp #MAP_CELL_DOOR_DOWN
  beq .door_2_selected
  cmp #MAP_CELL_DOOR_LEFT
  beq .door_3_selected
  cmp #CELL_POTION
  beq .perform_pick_potion

  jmp .continue

.door_0_selected:
  ldy #$00                        ; Porta di partenza nella mappa
  lda #MAP_CELL_DOOR_DOWN         ; Porta di destinazione nella prossima stanza
  jmp .change_room

.door_1_selected:
  ldy #$01
  lda #MAP_CELL_DOOR_LEFT
  jmp .change_room

.door_2_selected:
  ldy #$02
  lda #MAP_CELL_DOOR_UP
  jmp .change_room
    
.door_3_selected:
  ldy #$03
  lda #MAP_CELL_DOOR_RIGHT
  jmp .change_room   

.perform_pick_potion:
  inc $0680                       ; Picking della chiave
  jmp .continue

.change_room:
  sta PLAYER_ON_CELL_VALUE
  jsr go_to_next_room             ; Ci troviamo su una porta, quindi cambiamo stanza

  jmp .exit

.continue:                        ; Non ci troviamo su una porta, quindi proseguiamo
  jsr update_matrix_cells_occs    ; Aggiorniamo la matrice occupazionale
  jsr turn_system_increase        ; Incrementiamo quindi il turno
  jsr on_move_pawn_done           ; Chiamo il metodo in pawn_controls

.exit:
  rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; on_fade_in_room_done
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
on_fade_in_room_done:
  jsr unload_items_on_level
  jsr load_lvl_mat_occs             ; Carichiamo i la cella di occupazione
  jsr set_player_on_next_door2
  jsr load_lvl_items
  rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; on_perform_brawl_attack
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
on_perform_brawl_attack:
  lda #INDICATOR_HIT_COUNT
  sta INDICATOR_TYPE
  jsr cs_set_selected_pawn_stats_as_reciever
  jsr set_sprite_an_hit_brawl
  rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; on_pawn_attack_done
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
on_pawn_attack_done:
   lda CELL_INDICATOR_ON            ; E' un attacco speciale?
   cmp #$00
   beq .compute_brawl_attack

.compute_special_attack:            ; Si, allora calcolo il danno sull'attacco speciale
   jsr cs_compute_special_attack
   jmp .continue

.compute_brawl_attack:              ; No, allora calcolo il danno sull'attacco normale
   jsr cs_compute_brawl_attack

.continue:    
   jsr cs_pawn_hp_after_attack      ; Tolgo gli HP al destinatario

   rts

;:::::::::::::::::::::::::::::::::::::::::
; on_attack_stats_showed_done
;:::::::::::::::::::::::::::::::::::::::::
on_attack_stats_showed_done:
    lda INDICATOR_TYPE          
    cmp #INDICATOR_HIT_COUNT
    beq .inc_turn

    jmp .exit
.inc_turn:    
    jsr player_turn_done    

.exit:
    jsr attack_stats_showed_done
    rts

;:::::::::::::::::::::::::::::::::::::::::
; on_special_movement_done
;:::::::::::::::::::::::::::::::::::::::::
on_special_movement_done:
    jsr cell_indicator_hide
    jsr player_turn_done
    rts

;:::::::::::::::::::::::::::::::::::::::::
; player_turn_done
;:::::::::::::::::::::::::::::::::::::::::
player_turn_done:
    jsr check_if_update_gui_stats
    jsr turn_system_increase
  rts

;:::::::::::::::::::::::::::::::::::::::::
; on_indicator_show
;:::::::::::::::::::::::::::::::::::::::::
on_indicator_show:
    jsr get_current_pawn_cell_pos
    lda CURR_PAWN_CELL_POS
    sta CELL_INDICATOR_POS
    jsr cell_indicator_show
  rts 

;:::::::::::::::::::::::::::::::::::::::::
; on_perform_special_move
;:::::::::::::::::::::::::::::::::::::::::
on_perform_special_move:
    jsr decrement_mp_after_special_move ; Aggiorno gli MP usati 

    lda SM_TYPE_SEL                     ; Che tipo di special move ha selezionato?
    cmp #SM_ATK                         ; E' di tipo attacco?
    beq .perform_special_attack         ; Se si, allora performo un attacco

.perform_special_move:                  ; Altrimenti faccio lo spostamento
    lda CELL_INDICATOR_POS
    sta CELL_SELECTED
    jsr cs_perform_special_movement     ; Performo lo spostamento
    jmp .exit 
    
.perform_special_attack:
    lda CELL_INDICATOR_POS
    sta CELL_SELECTED
    jsr on_perform_brawl_attack         ; Performo l'attacco
    jsr cell_indicator_hide

.exit:
  rts

;:::::::::::::::::::::::::::::::::::::::::
; on_undo_special_move
;:::::::::::::::::::::::::::::::::::::::::
on_undo_special_move:
  jsr cell_indicator_hide
  rts

;:::::::::::::::::::::::::::::::::::::::::
; on_next_slot_selected
;:::::::::::::::::::::::::::::::::::::::::
on_next_slot_selected:
    lda GUI_SLOT_SELECTED
    cmp #$03
    beq .reset_gui_slot

    inc GUI_SLOT_SELECTED
    jmp .continue

.reset_gui_slot:
    lda #$00
    sta GUI_SLOT_SELECTED

    jsr gui_select_next_slot

.continue:
    lda GUI_SLOT_SELECTED
    cmp #$00
    beq .select_slot_0
    cmp #$01
    beq .select_slot_1
    cmp #$02
    beq .select_potion_HP
    cmp #$03
    beq .select_potion_MP

.select_slot_0:
    jsr select_special_attack_slot_0
    jmp .exit

.select_slot_1:
    jsr select_special_attack_slot_1
    jmp .exit

.select_potion_HP:
    jmp .exit

.select_potion_MP
    jmp .exit

.exit:
    jsr gui_select_next_slot
  rts