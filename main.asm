;=================================================================
; Shooting Like A Star for NES 
; Code by Gaetano Lenoci, Studio Leaves 2019
;=================================================================

;; NES HEADERS
  .inesprg 2 ; 1x 16KB PRG code
  .ineschr 5 ; 1x  8KB CHR data
  .inesmap 3 ; mapper 0 = NROM, no bank swapping
  .inesmir 1 ; background mirroring

;; Constants and Variables
    .include "./engine/variables.asm"
    .include "./engine/constants.asm"

;; Code starting point
  .bank 0
  .org $8000

;; RESET Routine. Initialize Title, clear NMI ready flag
  .include "./engine/reset.asm"
  .include "./macros/utils.asm"
  
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
; Inizializzazione del Dungeon 
;:::::::::::::::::::::::::::::::::::::::::::::::::::::
  jsr load_and_init_dungeon ; Todo: Togliere da qui

;; MAIN LOOP
MainLoop:
  jsr update_random_room_selector
  jsr gameplay_main_update

  lda #READY       ;frameready is now set to 1. This will Allow NMI to Draw To Screen
  sta FRAME_READY

WaitForNMI:       ;Allow NMI to complete one pass before Starting Main Loop again. This ensure no game logic will happen during NMI while its writing.
  lda FRAME_READY ;01
  cmp #READY      ;01
  beq WaitForNMI  ;Since both frameready and READY are 01 this will loop back to WaitForNMI until NMI clears the frameready flag.

  jmp MainLoop     ;jump back to MainLoop, infinite loop

; The NMI
  .include "./engine/nmi.asm"
  .include "./graphics/gfx_ingame_manager.asm"
  .include "./gameplay/gameplay_update.asm"
  .include "./gameplay/combat_system/combat_system_stats.asm"
  .include "./gameplay/combat_system/combat_system.asm"
  .include "./gameplay/combat_system/combat_system_drop_system.asm"
  .include "./gameplay/controls/gameplay_player_controls.asm"
  .include "./gameplay/controls/pawn_controls.asm"
  .include "./gameplay/turns/gameplay_turn_manager.asm"
  .include "./gameplay/enemies_ai/gameplay_enemies_ai.asm"
  .include "./gameplay/gui/gui_combat_mgr.asm"
  .include "./gameplay/levels/dungeon_level_manager.asm"
  .include "./gameplay/levels/dungeon_room_manager.asm"
  .include "./gameplay/levels/dungeon_events_manager.asm"

;; data tables
  .bank 1
  .org $A000
  .include "./graphics/graphics.asm"
  .include "./gameplay/levels/levels_descriptor.asm"
  
  .bank 2
  .org $C000

  ;.include "UpdateGamePlay.asm"

  .bank 3
  .org $E000
  
  ;.include "famitone2.asm"

Music:
  ;.include "Music.asm"
  ;.include "Music2.asm"
  ;.include "music/lawn_mower.asm"
SFX:
	;.include "Sfx.asm"
;;;;; The Vectors

  .org $FFFA      ;first of the three vectors starts here
  .dw NMI         ;when an NMI happens (once per frame if enabled) the
                  ;processor will jump to the label NMI:
  .dw RESET       ;when the processor first turns on or is reset, it will jump
                  ;to the label RESET:
  .dw 0

  .bank 4
  .org $0000
  .incbin "./graphics/chr/graphics_0.chr"
  .incbin "./graphics/chr/graphics_1.chr"
  .incbin "./graphics/chr/graphics_2.chr"
  .incbin "./graphics/chr/graphics_3.chr"
  .incbin "./graphics/chr/graphics_4.chr"