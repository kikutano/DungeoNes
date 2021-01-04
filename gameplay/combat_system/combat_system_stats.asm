
;combat_system_stats.asm

;::::::::::::::::::::::::::::::::::::::::::::::::::::
;            * BONUS HITPOINTS *
;::::::::::::::::::::::::::::::::::::::::::::::::::::
hit_points_str_bonus:
    .db $01,$02,$03,$04,$05,$06,$07,$08,$09,$0A
hit_points_int_bonus:
    .db $01,$02,$03,$04,$05,$06,$07,$08,$09,$0A
hit_points_str_enemy_bonus_easy:
    .db $00,$00,$03,$01,$00,$00,$01,$01,$02,$00
hit_points_str_enemy_bonus_normal:
    .db $00,$00,$00,$00,$00,$01,$02,$02,$03,$03
hit_points_str_enemy_bonus_hard:
    .db $00,$00,$00,$00,$00,$01,$02,$02,$03,$03
;::::::::::::::::::::::::::::::::::::::::::::::::::::
;            * ARCHER PROGRESS *
;::::::::::::::::::::::::::::::::::::::::::::::::::::
stats_hp_archer_progress:
    ; 10, 15, 20, 25, 30, 35, 40, 50, 70, 80
    .db $0A,$0F,$14,$19,$1E,$23,$28,$32,$46,$50

stats_mp_archer_progress:
    ; 06, 09, 12, 16, 22, 26, 30, 35, 40, 50
    .db $09,$0F,$0C,$10,$16,$1A,$1E,$23,$28,$32

stats_str_archer_progress:
    ; 03, 06, 08, 12, 18, 22, 30, 35, 40, 50
    .db $03,$06,$08,$0C,$12,$16,$1E,$23,$28,$32

stats_def_archer_progress:
    ; 01, 06, 08, 12, 18, 22, 30, 35, 40, 50
    .db $01,$06,$08,$0C,$12,$16,$1E,$23,$28,$32

stats_special_0_archer_progress:
    ; 03, 06, 08, 12, 18, 22, 30, 35, 40, 50
    .db $03,$06,$08,$0C,$12,$16,$1E,$23,$28,$32

archer_special_attack_0:
    .db $04     ; Max cells
    .db $02     ; Mp consume
    .db SM_ATK  ; Tipo attack

archer_special_attack_1:
    .db $04     ; Max cells
    .db $06     ; Mp consume
    .db SM_MOVE ; Tipo move

;::::::::::::::::::::::::::::::::::::::::::::::::::::
;            * WARRIOR PROGRESS *
;::::::::::::::::::::::::::::::::::::::::::::::::::::
stats_hp_warrior_progress:
    ; 10, 15, 20, 25, 30, 35, 40, 50, 70, 80
    .db $0A,$0F,$14,$19,$1E,$23,$28,$32,$46,$50

stats_mp_warrior_progress:
    ; 06, 09, 12, 16, 22, 26, 30, 35, 40, 50
    .db $0A,$0F,$0C,$10,$16,$1A,$1E,$23,$28,$32

stats_str_warrior_progress:
    ; 03, 06, 08, 12, 18, 22, 30, 35, 40, 50
    .db $03,$06,$08,$0C,$12,$16,$1E,$23,$28,$32

stats_def_warrior_progress:
    ; 03, 06, 08, 12, 18, 22, 30, 35, 40, 50
    .db $03,$06,$08,$0C,$12,$16,$1E,$23,$28,$32

;::::::::::::::::::::::::::::::::::::::::::::::::::::
;            * WIZARD PROGRESS *
;::::::::::::::::::::::::::::::::::::::::::::::::::::
stats_hp_wizard_progress:
    ; 10, 15, 20, 25, 30, 35, 40, 50, 70, 80
    .db $0A,$0F,$14,$19,$1E,$23,$28,$32,$46,$50

stats_mp_wizard_progress:
    ; 06, 09, 12, 16, 22, 26, 30, 35, 40, 50
    .db $0A,$0F,$0C,$10,$16,$1A,$1E,$23,$28,$32

stats_str_wizard_progress:
    ; 03, 06, 08, 12, 18, 22, 30, 35, 40, 50
    .db $03,$06,$08,$0C,$12,$16,$1E,$23,$28,$32

stats_int_wizard_progress:
    ; 03, 06, 08, 12, 18, 22, 30, 35, 40, 50
    .db $03,$06,$08,$0C,$12,$16,$1E,$23,$28,$32

stats_def_wizard_progress:
    ; 03, 06, 08, 12, 18, 22, 30, 35, 40, 50
    .db $03,$06,$08,$0C,$12,$16,$1E,$23,$28,$32

;:::::::::::::::::::::::::::::::::::::::::
; wizard_special_attack_0
; Permette di colpire il nemico da lontano
; selezionando una cella.
;:::::::::::::::::::::::::::::::::::::::::
wizard_special_attack_0:
    .db $02     ; Max cells
    .db $03     ; Bonus attack
    .db $02     ; Mp consume
    .db SM_ATK  ; Tipo attack

wizard_special_attack_1:
    .db $02     ; Max cells
    .db $03     ; Bonus attack
    .db $06     ; Mp consume
    .db SM_MOVE ; Tipo move

;:::::::::::::::::::::::::::::::::::::::::
; warrior_special_attack_0
; Permette di colpire il nemico da lontano
; selezionando una cella.
;:::::::::::::::::::::::::::::::::::::::::
warrior_special_attack_0:
    .db $02     ; Max cells
    .db $03     ; Bonus attack
    .db $02     ; Mp consume
    .db SM_ATK  ; Tipo attack

warrior_special_attack_1:
    .db $02     ; Max cells
    .db $03     ; Bonus attack
    .db $06     ; Mp consume
    .db SM_MOVE ; Tipo move