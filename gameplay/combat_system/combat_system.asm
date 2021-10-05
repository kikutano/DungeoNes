
; gp_combat_system_mgr.asm

;::::::::::::::::::::::::::::::::::::::::::::::::::::
; cs_init_pawns_en_stats
; Carica in memoria le stats dei nemici.
;::::::::::::::::::::::::::::::::::::::::::::::::::::
cs_init_pawns_en_stats:
    
    lda #$00                            ; Le stats come MP e INT non servono ai nemici
    sta EN_0_STATUS_MP
    sta EN_1_STATUS_MP
    sta EN_2_STATUS_MP
    sta EN_0_STATUS_INT
    sta EN_1_STATUS_INT
    sta EN_2_STATUS_INT

    ldy #$00
    lda [ROOM_ENEMIES_TO_LOAD_ADDR], y  ; Carico il primo valore presente in 
    tax                                 ; level_0_room_0_enemies
    lda enemies_stats, x
    sta EN_0_STATUS_HP
    inx 
    lda enemies_stats, x
    sta EN_0_STATUS_STR
    inx 
    lda enemies_stats, x
    sta EN_0_STATUS_DEF

    ldy #$01
    lda [ROOM_ENEMIES_TO_LOAD_ADDR], y
    tax
    lda enemies_stats, x
    sta EN_1_STATUS_HP
    inx 
    lda enemies_stats, x
    sta EN_1_STATUS_STR
    inx 
    lda enemies_stats, x
    sta EN_1_STATUS_DEF

    ldy #$02
    lda [ROOM_ENEMIES_TO_LOAD_ADDR], y
    tax
    lda enemies_stats, x
    sta EN_2_STATUS_HP
    inx 
    lda enemies_stats, x
    sta EN_2_STATUS_STR
    inx 
    lda enemies_stats, x
    sta EN_2_STATUS_DEF

    rts

;::::::::::::::::::::::::::::::::::::::::::::::::::::
; cs_init_player_stats
; In base alla classe selezionata, vengono caricate
; le stats base.
;::::::::::::::::::::::::::::::::::::::::::::::::::::
cs_init_player_stats:

    lda HERO_CLASS_SELECTED
    cmp #HERO_ARCHER
    beq .jump_load_ancher_stats
    cmp #HERO_WARRIOR
    beq .jump_load_warrior_stats
    cmp #HERO_WIZARD
    beq .jump_load_wizad_stats

.jump_load_ancher_stats
    jmp .load_archer_stats
.jump_load_warrior_stats
    jmp .load_warrior_stats
.jump_load_wizad_stats
    jmp .load_wizard_stats

.load_archer_stats:
    ;::::::::::::::::::::::::::::::::::::::::::::::::::::
    ;                 * ARCHER STATS *
    ;::::::::::::::::::::::::::::::::::::::::::::::::::::
    ldx PLAYER_STATUS_HP_LVL
    lda stats_hp_archer_progress, x
    sta PLAYER_STATUS_HP
    sta PLAYER_STATUS_HP_TOTAL

    ldx PLAYER_STATUS_MP_LVL
    lda stats_mp_archer_progress, x
    sta PLAYER_STATUS_MP
    sta PLAYER_STATUS_MP_TOTAL

    ldx PLAYER_STATUS_STR_LVL
    lda stats_str_archer_progress, x
    sta PLAYER_STATUS_STR

    lda #$00
    sta PLAYER_STATUS_INT

    ldx PLAYER_STATUS_DEF_LVL
    lda stats_def_archer_progress, x
    sta PLAYER_STATUS_DEF

    ;::::::::::::::::::::::::::::::::::::::::::::::::::::
    ;                 * ARCHER SKILLS *
    ;::::::::::::::::::::::::::::::::::::::::::::::::::::
    lda #low(archer_special_attack_0)
    sta GENERIC_PTR_1 + 0
    lda #high(archer_special_attack_0)
    sta GENERIC_PTR_1 + 1

    lda #low(archer_special_attack_1)
    sta GENERIC_PTR_2 + 0
    lda #high(archer_special_attack_1)
    sta GENERIC_PTR_2 + 1

    jmp .load_special_attack_slot

.load_warrior_stats:
    ;::::::::::::::::::::::::::::::::::::::::::::::::::::
    ;                 * WARRIOR STATS *
    ;::::::::::::::::::::::::::::::::::::::::::::::::::::
    ldx PLAYER_STATUS_HP_LVL
    lda stats_hp_warrior_progress, x
    sta PLAYER_STATUS_HP
    sta PLAYER_STATUS_HP_TOTAL

    ldx PLAYER_STATUS_MP_LVL
    lda stats_mp_warrior_progress, x
    sta PLAYER_STATUS_MP
    sta PLAYER_STATUS_MP_TOTAL

    ldx PLAYER_STATUS_STR_LVL
    lda stats_str_warrior_progress, x
    sta PLAYER_STATUS_STR

    lda #$00
    sta PLAYER_STATUS_INT

    ldx PLAYER_STATUS_DEF_LVL
    lda stats_def_warrior_progress, x
    sta PLAYER_STATUS_DEF

    ;::::::::::::::::::::::::::::::::::::::::::::::::::::
    ;                 * WARRIOR SKILLS *
    ;::::::::::::::::::::::::::::::::::::::::::::::::::::
    lda #low(warrior_special_attack_0)
    sta GENERIC_PTR_1 + 0
    lda #high(warrior_special_attack_0)
    sta GENERIC_PTR_1 + 1

    lda #low(warrior_special_attack_1)
    sta GENERIC_PTR_2 + 0
    lda #high(warrior_special_attack_1)
    sta GENERIC_PTR_2 + 1

    jmp .load_special_attack_slot

.load_wizard_stats:
    ;::::::::::::::::::::::::::::::::::::::::::::::::::::
    ;                 * WIZARD STATS *
    ;::::::::::::::::::::::::::::::::::::::::::::::::::::
    ldx PLAYER_STATUS_HP_LVL
    lda stats_hp_wizard_progress, x
    sta PLAYER_STATUS_HP
    sta PLAYER_STATUS_HP_TOTAL

    ldx PLAYER_STATUS_MP_LVL
    lda stats_mp_wizard_progress, x
    sta PLAYER_STATUS_MP
    sta PLAYER_STATUS_MP_TOTAL

    ldx PLAYER_STATUS_STR_LVL
    lda stats_str_wizard_progress, x
    sta PLAYER_STATUS_STR

    ldx PLAYER_STATUS_INT_LVL
    lda stats_int_wizard_progress, x
    sta PLAYER_STATUS_INT

    ldx PLAYER_STATUS_DEF_LVL
    lda stats_def_wizard_progress, x
    sta PLAYER_STATUS_DEF

    ;::::::::::::::::::::::::::::::::::::::::::::::::::::
    ;                 * WIZARD SKILLS *
    ;::::::::::::::::::::::::::::::::::::::::::::::::::::
    lda #low(wizard_special_attack_0)
    sta GENERIC_PTR_1 + 0
    lda #high(wizard_special_attack_0)
    sta GENERIC_PTR_1 + 1

    lda #low(wizard_special_attack_1)
    sta GENERIC_PTR_2 + 0
    lda #high(wizard_special_attack_1)
    sta GENERIC_PTR_2 + 1

    jmp .load_special_attack_slot

.load_special_attack_slot:
    ldy #$00
    lda [GENERIC_PTR_1], y
    sta SM_CELLS_MAX_0
    lda [GENERIC_PTR_2], y
    sta SM_CELLS_MAX_1
    iny
    lda [GENERIC_PTR_1], y
    sta SM_MP_CONSUME_0
    lda [GENERIC_PTR_2], y
    sta SM_MP_CONSUME_1 
    iny
    lda [GENERIC_PTR_1], y
    sta SM_TYPE_0
    lda [GENERIC_PTR_2], y
    sta SM_TYPE_1 

    rts

;::::::::::::::::::::::::::::::::::::::::::::::::::::
; cs_set_current_pawn_stats_as_sender
;::::::::::::::::::::::::::::::::::::::::::::::::::::
cs_set_current_pawn_stats_as_sender:

    lda TS_COUNTER
    cmp #$00
    beq .load_player_stats
    cmp #$01
    beq .load_en_0_stats
    cmp #$02
    beq .load_en_1_stats
    cmp #$03
    beq .load_en_2_stats

.load_player_stats:
    ldy #$00                        ; PLAYER_STATUS_HP 
    jmp .continue
.load_en_0_stats:
    ldy #$07                        ; EN_0_STATUS_HP 
    jmp .continue
.load_en_1_stats:
    ldy #$0C                        ; EN_1_STATUS_HP
    jmp .continue
.load_en_2_stats:
    ldy #$11                        ; EN_2_STATUS_HP

.continue:
    lda PLAYER_STATUS_HP, y         ; Il caricamento della stats usa "PLAYER_STATUS_HP"
    sta CURRENT_SENDER_STATS_PTR    ; come indirizzo di partenza. La y viene assegnata
    sta PAWN_SENDER_STATS_HP        ; in base al turno. E' un po' tricky, ma mi fa risparmiare
    iny                             ; un sacco di spazio.
    lda PLAYER_STATUS_HP, y
    sta PAWN_SENDER_STATS_MP
    iny 
    lda PLAYER_STATUS_HP, y
    sta PAWN_SENDER_STATS_STR
    iny 
    lda PLAYER_STATUS_HP, y
    sta PAWN_SENDER_STATS_INT
    iny
    lda PLAYER_STATUS_HP, y
    sta PAWN_SENDER_STATS_DEF
    
    rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; cs_set_selected_pawn_stats_as_reciever
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
cs_set_selected_pawn_stats_as_reciever:

    ldx CELL_SELECTED
    lda RAM_ROOM_CELLS, x
    sta CURRENT_RECIEVER_STATS_PTR

    lda CURRENT_RECIEVER_STATS_PTR
    cmp #CELL_PLAYER
    beq .load_player_stats
    cmp #CELL_ENEMY_0
    beq .load_en_0_stats
    cmp #CELL_ENEMY_1
    beq .load_en_1_stats
    cmp #CELL_ENEMY_2
    beq .load_en_2_stats
    
    jmp .exit

.load_player_stats:
    ldy #$00
    jmp .set_reciever_stats

.load_en_0_stats:
    ldy #$07
    jmp .set_reciever_stats

.load_en_1_stats:
    ldy #$0C
    jmp .set_reciever_stats

.load_en_2_stats:
    ldy #$11
    jmp .set_reciever_stats

.set_reciever_stats:
    ldx #$00
    .loop:
        lda PLAYER_STATUS_HP, y
        sta PAWN_RECIEVER_STATS_HP, x
        iny
        inx
        cpx #$05
        bne .loop    

.exit:
    rts

;::::::::::::::::::::::::::::::::::::::::::::::::
; AGGIORNAMENTO HP DOPO ATTACCO
;::::::::::::::::::::::::::::::::::::::::::::::::
cs_pawn_hp_after_attack:
    
    jsr start_sprite_hit_shake_an

    lda CURRENT_RECIEVER_STATS_PTR
    cmp #CELL_ENEMY_0
    beq .compute_en_0_hp
    cmp #CELL_ENEMY_1
    beq .compute_en_1_hp
    cmp #CELL_ENEMY_2
    beq .compute_en_2_hp
    cmp #CELL_PLAYER
    beq .compute_player_hp

.compute_en_0_hp:
    lda EN_0_STATUS_HP
    cmp HIT_COUNT_VALUE
    bcc .en_0_dead
    jmp .decrease_en_0_hp

.decrease_en_0_hp:
    sbc HIT_COUNT_VALUE
    sta EN_0_STATUS_HP
    cmp #$00
    beq .en_0_dead
    jmp .exit

.en_0_dead:
    lda #$00
    sta EN_0_STATUS_HP

    jmp .exit

.compute_en_1_hp:
    lda EN_1_STATUS_HP
    cmp HIT_COUNT_VALUE
    bcc .en_1_dead
    jmp .decrease_en_1_hp

.decrease_en_1_hp:
    sbc HIT_COUNT_VALUE
    sta EN_1_STATUS_HP
    cmp #$00
    beq .en_1_dead
    jmp .exit

.en_1_dead:
    lda #$00
    sta EN_1_STATUS_HP
    jmp .exit

.compute_en_2_hp:
    lda EN_2_STATUS_HP
    cmp HIT_COUNT_VALUE
    bcc .en_2_dead
    jmp .decrease_en_2_hp

.decrease_en_2_hp:
    sbc HIT_COUNT_VALUE
    sta EN_2_STATUS_HP
    cmp #$00
    beq .en_2_dead
    jmp .exit

.en_2_dead:
    lda #$00
    sta EN_2_STATUS_HP
    jmp .exit

.compute_player_hp:
    lda PLAYER_STATUS_HP
    cmp HIT_COUNT_VALUE
    bcc .player_dead

.decrease_player_hp:
    sbc HIT_COUNT_VALUE
    sta PLAYER_STATUS_HP

    jmp .exit

.player_dead:
    ;::::::::::::::::::::::::::::::::::::::::::::::::
    ; PLAYER DEAD
    ;::::::::::::::::::::::::::::::::::::::::::::::::
    lda #$00
    sta PLAYER_STATUS_HP

.exit:
    jsr set_sprite_an_hit_count
    rts

;::::::::::::::::::::::::::::::::::::::::::::::::
; cs_compute_if_pawn_is_dead
;::::::::::::::::::::::::::::::::::::::::::::::::
cs_compute_if_pawn_is_dead:
    lda CURRENT_RECIEVER_STATS_PTR
    cmp #CELL_ENEMY_0
    beq .compute_en_0_hp
    cmp #CELL_ENEMY_1
    beq .compute_en_1_hp
    cmp #CELL_ENEMY_2
    beq .compute_en_2_hp

    jmp .exit

.compute_en_0_hp:
    lda EN_0_STATUS_HP
    cmp #$00
    beq .set_en_0_dead
    jmp .exit

.compute_en_1_hp:
    lda EN_1_STATUS_HP
    cmp #$00
    beq .set_en_1_dead
    jmp .exit

.compute_en_2_hp:
    lda EN_2_STATUS_HP
    cmp #$00
    beq .set_en_2_dead
    jmp .exit

.set_en_0_dead:
    lda CELLS_PAWNS_OCCS_ARRAY + 1
    sta LAST_ENEMY_KILLED_CELL          ; save the cell where enemy is killed
    jsr remove_pawn_from_grid
    jsr set_pawn_an_en_0_dead
    jsr set_sprite_an_dead
    lda #$00
    sta LAST_ENEMY_KILLED_NUM           ; Enemy 0 killed
    jsr set_drop_random_item_available  ; Start method to drop random item

    jmp .exit

.set_en_1_dead:
    lda CELLS_PAWNS_OCCS_ARRAY + 2
    sta LAST_ENEMY_KILLED_CELL          ; save the cell where enemy is killed
    jsr remove_pawn_from_grid
    jsr set_pawn_an_en_1_dead
    jsr set_sprite_an_dead
    lda #$01
    sta LAST_ENEMY_KILLED_NUM           ; Enemy 1 killed
    jsr set_drop_random_item_available  ; Start method to drop random item
    jmp .exit

.set_en_2_dead:
    lda CELLS_PAWNS_OCCS_ARRAY + 3
    sta LAST_ENEMY_KILLED_CELL          ; save the cell where enemy is killed
    jsr remove_pawn_from_grid
    jsr set_pawn_an_en_2_dead
    jsr set_sprite_an_dead
    lda #$02
    sta LAST_ENEMY_KILLED_NUM           ; Enemy 2 killed
    jsr set_drop_random_item_available  ; Start method to drop random item
    jmp .exit

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; init_starting_stats_on_dungeon
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
init_starting_stats_on_dungeon:
  lda #HERO_ARCHER                  ; Todo: Rendere dinamico
  sta HERO_CLASS_SELECTED

  jsr cs_init_player_stats
  jsr select_special_attack_slot_0
  lda #ENEMIES_STR_SET_EASY         ; Todo: Rendere dinamico
  sta ENEMIES_STR_SET

  ldx #$00
  .load_player_sprites_loop:
    lda sprites_player_archer, x    ; Todo: Rendere dinamico
    sta RAM_PLAYER, x
    inx
    cpx #$10
    bne .load_player_sprites_loop 
  rts

;:::::::::::::::::::::::::::::::::::::::::
; select_special_attack_slot_0
;:::::::::::::::::::::::::::::::::::::::::
select_special_attack_slot_0:
    lda SM_CELLS_MAX_0
    sta SM_CELLS_MAX_SEL
    lda SM_MP_CONSUME_0
    sta SM_MP_CONSUME_SEL
    lda SM_TYPE_0
    sta SM_TYPE_SEL

    rts 

;:::::::::::::::::::::::::::::::::::::::::
; select_special_attack_slot_1
;:::::::::::::::::::::::::::::::::::::::::
select_special_attack_slot_1:
    lda SM_CELLS_MAX_1
    sta SM_CELLS_MAX_SEL
    lda SM_MP_CONSUME_1
    sta SM_MP_CONSUME_SEL
    lda SM_TYPE_1
    sta SM_TYPE_SEL
    
    rts

;:::::::::::::::::::::::::::::::::::::::::
; decrement_mp_after_special_move
;:::::::::::::::::::::::::::::::::::::::::
decrement_mp_after_special_move:
    lda PLAYER_STATUS_MP
    sec 
    sbc SM_MP_CONSUME_SEL
    sta PLAYER_STATUS_MP

    rts

;:::::::::::::::::::::::::::::::::::::::::
; update_attack_bonus
;:::::::::::::::::::::::::::::::::::::::::
update_attack_bonus:
    lda STR_POWER_BONUS_INDEX
    cmp PLAYER_STATUS_STR_LVL
    beq .reset_str_count

    inc STR_POWER_BONUS_INDEX
    jmp .set_str_bonus

.reset_str_count:
    lda #$00
    sta STR_POWER_BONUS_INDEX
    
.set_str_bonus:
    ldx STR_POWER_BONUS_INDEX
    lda hit_points_str_bonus, x 
    sta STR_POWER_BONUS

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; update_magic_attack_bonus
;:::::::::::::::::::::::::::::::::::::::::
update_magic_attack_bonus:
    lda INT_POWER_BONUS_INDEX
    cmp PLAYER_STATUS_INT_LVL
    beq .reset_int_count

    inc INT_POWER_BONUS_INDEX
    jmp .set_int_bonus

.reset_int_count:
    lda #$00
    sta INT_POWER_BONUS_INDEX
    
.set_int_bonus:
    ldx INT_POWER_BONUS_INDEX
    lda hit_points_int_bonus, x 
    sta INT_POWER_BONUS

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; update_attack_bonus_enemy
;:::::::::::::::::::::::::::::::::::::::::
update_attack_bonus_enemy:
    lda STR_POWER_BONUS_EN_INDEX            ; In questo caso il nemico ha un bonus d'attacco
    cmp #$0A                                ; preso da un array da 0-10
    beq .reset_str_count

    inc STR_POWER_BONUS_EN_INDEX
    jmp .set_str_bonus

.reset_str_count:
    lda #$00
    sta STR_POWER_BONUS_EN_INDEX
    
.set_str_bonus:
    ldx STR_POWER_BONUS_EN_INDEX
    lda ENEMIES_STR_SET
    cmp #ENEMIES_STR_SET_EASY               ; Se il nemico è settato a Easy allora prende i
    beq .set_str_bonus_easy                 ; i valori dall'array Easy
    cmp #ENEMIES_STR_SET_NORMAL
    beq .set_str_bonus_normal
    cmp #ENEMIES_STR_SET_HARD
    beq .set_str_bonus_hard

.set_str_bonus_easy:
    lda hit_points_str_enemy_bonus_easy, x 
    jmp .set
.set_str_bonus_normal:
    lda hit_points_str_enemy_bonus_normal, x 
    jmp .set
.set_str_bonus_hard:
    lda hit_points_str_enemy_bonus_hard, x 
    jmp .set

.set:
    sta STR_POWER_BONUS_EN

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; cs_compute_brawl_attack
;:::::::::::::::::::::::::::::::::::::::::
cs_compute_brawl_attack:
    lda PAWN_SENDER_STATS_STR   ; Se la STR è minore uguale alla DEF
    cmp PAWN_RECIEVER_STATS_DEF ; allora settiamo l'hit point a 1
    bcs .continue

    lda #$01                    ; Settiamo l'HitPoint a 1 perchè la DEF è
    sta HIT_COUNT_VALUE         ; troppo alta.
    jmp .exit

.continue:
    lda PAWN_SENDER_STATS_STR   ; Carichiamo la STR e gli sottraiamo 
    sec                         ; la DEF della pedina ricevente.
    sbc PAWN_RECIEVER_STATS_DEF
    sta HIT_COUNT_VALUE

    lda TS_COUNTER              ; Muove il player?
    cmp #$00
    bne .set_enemy_attack_bonus

.set_player_attack_bonus
    lda STR_POWER_BONUS         ; Gli aggiungiamo il bonus di attacco
    jmp .set

.set_enemy_attack_bonus:
    lda STR_POWER_BONUS_EN      ; Gli aggiungiamo il bonus di attacco per il nemico

.set:
    clc 
    adc HIT_COUNT_VALUE
    sta HIT_COUNT_VALUE
.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; cs_compute_special_attack
;:::::::::::::::::::::::::::::::::::::::::
cs_compute_special_attack:
    jsr cs_compute_brawl_attack             ; Calcoliamo l'hit in base alla str
    
    lda HERO_CLASS_SELECTED
    cmp #HERO_ARCHER
    beq .compute_archer_special_attack

    jmp .exit

.compute_archer_special_attack:             
    ldx PLAYER_STATUS_STR_LVL               ; Gli sommiamo il bonus derivato dall'attacco
    lda stats_special_0_archer_progress, x  ; speciale.
    clc
    adc HIT_COUNT_VALUE
    sta HIT_COUNT_VALUE

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; cs_perform_special_movement
;:::::::::::::::::::::::::::::::::::::::::
cs_perform_special_movement:
    lda #$00
    sta AN_SPECIAL_EFFECT_COUNT         ; Azzeriamo l'indice di comparizioni del "puff"
    lda CELLS_PAWNS_OCCS_ARRAY + 0
    sta CELL_SELECTED

    ;- Rendiamo la cella precente libera
    ldx CELL_SELECTED
    lda #MAP_EMPTY_FLOOR_00
    sta RAM_ROOM_CELLS, x               
    ;-
    
    jsr flip_sprite_pawn_to_right

    lda HERO_CLASS_SELECTED             ; Selezioniamo l'animazione che ci interessa
    cmp #HERO_ARCHER
    beq .perform_special_move_puff
    cmp #HERO_WARRIOR
    beq .perform_special_move_puff
    cmp #HERO_WIZARD
    beq .perform_special_move_teleport

.perform_special_move_puff:
    jsr set_sprite_an_puff
    jmp .exit

.perform_special_move_teleport:
    jsr set_sprite_an_puff

.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; cs_animation_done
; Questo metodo viene chiamato quando 
; l'animazione di sprite è a metà.  
;:::::::::::::::::::::::::::::::::::::::::
cs_sprite_on_half_done:
    lda CELL_INDICATOR_ON
    cmp #$01
    beq .continue

    jmp .exit

.continue:
    lda SM_TYPE_SEL                ; Se l'animazione a metà è una di movimento 
    cmp #SM_MOVE                   ; facciamo sparire il player.
    beq .hide_pawn_for_teleport

    jmp .exit 

.hide_pawn_for_teleport:
    lda #$FF
    sta RAM_PLAYER + 1
    sta RAM_PLAYER + 5
    sta RAM_PLAYER + 9
    sta RAM_PLAYER + 13

    lda CELL_INDICATOR_POS
    sta CURRENT_CELL_POINTER
    jsr set_player_on_cell          ;<- Aggiorno la posizione
    
.exit:
    rts

;:::::::::::::::::::::::::::::::::::::::::
; cs_sprite_an_done
;:::::::::::::::::::::::::::::::::::::::::
cs_sprite_an_done:
    lda AN_SPRITE_TYPE
    cmp #AN_INDEX_HIT
    beq .stop_teleport_animation
    cmp #AN_INDEX_DEAD
    beq .stop_teleport_animation

    inc AN_SPECIAL_EFFECT_COUNT     ; Quando l'animazione è finita, vediamo se è
    lda AN_SPECIAL_EFFECT_COUNT     ; stata mostrata due volte. Per evitare i loop.
    cmp #$02
    beq .stop_teleport_animation

    lda CELLS_PAWNS_OCCS_ARRAY + 0  ; Lanciamo l'animazione di "riapparizione"
    sta CELL_SELECTED
    jsr set_sprite_an_puff
    
    ;- Aggiorniamo la posizione del player
    ;  sulla matrice di occupazione
    ldx CELLS_PAWNS_OCCS_ARRAY + 0
    lda #CELL_PLAYER
    sta RAM_ROOM_CELLS, x
    ;-
    jsr on_special_movement_done
    
.stop_teleport_animation:
    rts