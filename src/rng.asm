; Pokeys
org $0688E9
    ; 0688e9 jsl $0dba71
    ; 0688ed and #$03
    ; 0688ef tay
    ; 0688f0 lda $88d7,y
    ; 0688f3 sta $0d50,x
    ; 0688f6 lda $88db,y
    ; 0688f9 sta $0d40,x
    ; 0688fc rts
    JSL rng_pokey_hook
    RTS

; Agahnim
org $01ED6EF
    ; 1ed6ef jsl $0dba71
    JSL rng_agahnim_hook

; Helmasaur
org $01E8262
    ; 1e8262 jsl $0dba71
    JSL rng_helmasaur_hook

; Ganon warp location
org $1D9488
    ; 1d9488 jsl $0dba71
    JSL rng_ganon_warp_location

; Ganon warp
org $1D91E3
    ; 1d91e3 jsl $0dba71
    JSL rng_ganon_warp

; Eyegore
org $1EC89C
    ;1ec89c jsl $0dba71
    JSL rng_eyegore

; Arrghus
org $1EB5F7
    ;1eb5f7 jsl $0dba71
    JSL rng_arrghus

; Turtles
org $1EB2A6
    ;1eb2a6 jsl $0dba71
    JSL rng_turtles

org $0580D6
    ;0580d6 txa
    ;0580d7 asl
    ;0580d8 asl
    ;0580d9 clc
    ;0580da adc $1a
    ;0580dc and #$1f
    JSL rng_cannonballs
    NOP : NOP

org $288000

tbl_pokey_speed:
    ; 00
    db -16, -16, -16, -16 ; ul ul
    db -16,  16, -16, -16 ; ur ul
    db  16,  16, -16, -16 ; dr ul
    db  16, -16, -16, -16 ; dl ul

    ; 10
    db -16, -16, -16,  16 ; ul ur
    db -16,  16, -16,  16 ; ur ur
    db  16,  16, -16,  16 ; dr ur
    db  16, -16, -16,  16 ; dl ur

    ; 20
    db -16, -16,  16,  16 ; ul dr
    db -16,  16,  16,  16 ; ur dr
    db  16,  16,  16,  16 ; dr dr
    db  16, -16,  16,  16 ; dl dr

    ; 30
    db -16, -16,  16, -16 ; ul dl
    db -16,  16,  16, -16 ; ur dl
    db  16,  16,  16, -16 ; dr dl
    db  16, -16,  16, -16 ; dl dl

tbl_real_pokey_x:
    db 16, -16,  16, -16
tbl_real_pokey_y:
    db 16,  16, -16, -16

rng_pokey_hook:
    PHB : PHK : PLB

    LDA !ram_pokey_rng : BEQ .random

    LDA !ram_rng_counter : ASL : STA !lowram_draw_tmp
    LDA !ram_pokey_rng : DEC : ASL #2 : CLC : ADC !lowram_draw_tmp : TAY

    LDA tbl_pokey_speed, Y : STA $0D40, X
    LDA tbl_pokey_speed+1, Y : STA $0D50, X

    LDA !ram_rng_counter : INC : STA !ram_rng_counter
    BRA .done

  .random
    JSL !RandomNumGen : AND #$03 : TAY
    LDA tbl_real_pokey_x, Y : STA $0D50, X
    LDA tbl_real_pokey_y, Y : STA $0D40, X

  .done
    PLB
    RTL

; == Agahnim ==

rng_agahnim_hook:
    LDA !ram_agahnim_rng : BEQ .random
    CMP #$01 : BEQ .done
    LDA #$00
    RTL

  .random
    JSL !RandomNumGen
    RTL

  .done
    RTL

; == Helmasaur ==

rng_helmasaur_hook:
    LDA !ram_helmasaur_rng : BEQ .random
    DEC
    RTL

  .random
    JSL !RandomNumGen
    RTL

; == Ganon Warp Location ==

rng_ganon_warp_location:
    LDA !ram_ganon_warp_location_rng : BEQ .random
    DEC
    RTL

  .random
    JSL !RandomNumGen
    RTL

; == Ganon Warp ==

rng_ganon_warp:
    LDA !ram_ganon_warp_rng : BEQ .random
    DEC
    RTL

  .random
    JSL !RandomNumGen
    RTL

; == Eyegore ==

rng_eyegore:
    LDA !ram_eyegore_rng : BEQ .random
    DEC
    RTL

  .random
    JSL !RandomNumGen
    RTL

; == Arrghus ==

arrghus_speeds:
    db $00, $10, $20, $30, $3F

rng_arrghus:
    LDA.l !ram_arrghus_rng : BEQ .random
  PHX : PHB : PHK : PLB
    DEC
    TAX : LDA arrghus_speeds, X
  PLB : PLX
    RTL

  .random
    JSL !RandomNumGen
    RTL

; == Turtles ==

rng_turtles:
    LDA !ram_turtles_rng : BEQ .random
    DEC
    RTL

  .random
    JSL !RandomNumGen
    RTL

; == Cannonballs ==

rng_cannonballs:
    LDA !ram_cannonballs_rng : BEQ .random
    TXA : CLC : ADC !ram_cannonballs_rng : DEC
    CLC : ADC !lowram_room_gametime
    RTL

  .random
    TXA : ASL : ASL : CLC : ADC $1A
    RTL
