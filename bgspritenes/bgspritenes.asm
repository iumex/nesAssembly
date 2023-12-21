; press arrows to move the sprite

.db "NES", $1A, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.define PPUCTRL $2000
.define PPUMASK $2001
.define PPUSTATUS $2002
.define OAMADDR $2003
.define OAMDATA $2004
.define PPUSCROLL $2005
.define PPUADDR $2006
.define PPUDATA $2007
.define OAMDMA $4014


.define PALETTE_BACKGROUND $3F00
.define PALETTE_SPRITES $3F10

.define JOYPAD1 $4016

.define SPRITE_Y $00
.define SPRITE_X $03

.org $8000
reset:
start:
    ; disable interrupts
    SEI
    ; disable decimal modus
    CLD




; initialize stack
LDX #$FF
TXS




LDA #%10001000
STA PPUCTRL
LDA #$0
STA PPUMASK




; waiting for the vblank to set graphics
wait_for_vblank:
    LDA PPUSTATUS
    AND #%10000000
    BEQ wait_for_vblank



; initialize palette for bg

;LDA PPUSTATUS
LDA #>PALETTE_BACKGROUND
STA PPUADDR
LDA #<PALETTE_BACKGROUND
STA PPUADDR


LDX #$00
palettebg_loop:
    LDA palette_bg, X
    STA PPUDATA
    INX
    CPX #$10
    BNE palettebg_loop


; initialize palette for sprites

LDA #>PALETTE_SPRITES
STA PPUADDR
LDA #<PALETTE_SPRITES
STA PPUADDR

LDX #$00
palettesprite_loop:
    LDA palette_sprite, X
    STA PPUDATA
    INX
    CPX #$10
    BNE palettesprite_loop




; background creation

    LDA #$20
    STA PPUADDR
    LDA #$00
    STA PPUADDR
    
    LDX #$00
    ;LDA #$24    
    ;LDA PPUDATA
skyloop1:
    LDA table1,X 
    STA PPUDATA
    INX
    CPX #$80
    BNE skyloop1

    LDX #$00
skyloop2:
    LDA table2,X 
    STA PPUDATA
    INX
    CPX #$80
    BNE skyloop2

    LDX #$00
skyloop3:
    LDA table3,X 
    STA PPUDATA
    INX
    CPX #$80
    BNE skyloop3

    LDX #$00
sentenceloop1:
    LDA table4,X 
    STA PPUDATA
    INX
    CPX #$80
    BNE sentenceloop1

    LDX #$00
skyloop5:
    LDA table5,X 
    STA PPUDATA
    INX
    CPX #$80
    BNE skyloop5

    LDX #$00
skyloop6:
    LDA table6,X 
    STA PPUDATA
    INX
    CPX #$80
    BNE skyloop6

    LDX #$00
skyloop7:
    LDA table7,X 
    STA PPUDATA
    INX
    CPX #$80
    BNE skyloop7

    LDX #$00
skyloop8:
    LDA table8,X 
    STA PPUDATA
    INX
    CPX #$40
    BNE skyloop8

LDA #$23
STA PPUADDR
LDA #$C0
STA PPUADDR


; setting the attributes
LDX #$00
attributeloop:
    LDA attribute,X 
    STA PPUDATA
    INX
    CPX #$20
    BNE attributeloop



; activate the bg
LDA #%00011000
STA PPUMASK
    


; setting data to use the DMA
LDA #$00
STA OAMADDR

LDA #$00
STA OAMDATA
STA $00

LDA #$00
STA OAMDATA
STA $01

LDA #%00000011
STA OAMDATA
STA $02

LDA #$00
STA OAMDATA
STA $03



LDA #$40
STA OAMDATA
STA $04

LDA #$55
STA OAMDATA
STA $05


LDA #%00000011
STA OAMDATA
STA $06


LDA #$79
STA OAMDATA
STA $07



LDA #$40
STA OAMDATA
STA $08


LDA #$56
STA OAMDATA
STA $09


LDA #%00000011
STA OAMDATA
STA $0A


LDA #$81
STA OAMDATA
STA $0B



LDA #$48
STA OAMDATA
STA $0C

LDA #$57
STA OAMDATA
STA $0D

LDA #%00000011
STA OAMDATA
STA $0E

LDA #$79
STA OAMDATA
STA $0F


LDA #$48
STA OAMDATA
STA $10

LDA #$58
STA OAMDATA
STA $11

LDA #%00000011
STA OAMDATA
STA $12


LDA #$81
STA OAMDATA
STA $13




game_loop:
    ;wait_for_vblank_game:
        ;LDA PPUSTATUS
        ;AND #%10000000
        ;BEQ wait_for_vblank_game
    
    

    LDA #%00000000
    STA PPUSCROLL
    LDA #%00000000
    STA PPUSCROLL
    
JMP game_loop


; setting joypad

check_joy:
        LDA #$01
        STA JOYPAD1       
        LDA #$00
        STA JOYPAD1      
  
    check_a:
        LDA JOYPAD1
        AND #%00000001
        BEQ check_b

    check_b:
        LDA JOYPAD1
        AND #%00000001
        BEQ check_select

    check_select:
        LDA JOYPAD1
        AND #%00000001
        BEQ check_start

    check_start:
        LDA JOYPAD1
        AND #%00000001
        BEQ check_up

    check_up:
        LDA JOYPAD1
        AND #%00000001
        BEQ check_down            
        DEC SPRITE_Y
   
    check_down:
        LDA JOYPAD1
        AND #%00000001
        BEQ check_left              
        INC SPRITE_Y
   
    check_left:
        LDA JOYPAD1
        AND #%00000001
        BEQ check_right      
        DEC SPRITE_X
       
    check_right:
        LDA JOYPAD1
        AND #%00000001
        BEQ end_joy      
        INC SPRITE_X
     

    end_joy:
        RTS




nmi:
    LDA #$00
    STA OAMADDR
    STA OAMDMA
    JSR check_joy

    RTI

irq:
    RTI


; tables filled with the tiles to build the bg
table1:
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
table2:
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
table3:
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
table4:
    .db $24,$24,$24,$24,$24,$24,$24,$24,$10,$12,$0A,$17,$0A,$24,$12,$1C
    .db $24,$0B,$0E,$1D,$1D,$0E,$1B,$24,$24,$24,$24,$24,$24,$24,$24,$24
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$1D,$11,$0A,$17,$24,$16,$0A
    .db $1B,$12,$18,$2B,$2B,$2B,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24
table5:
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
table6:
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
table7:
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
table8:
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24 
    .db $24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24  

; table of the attributes
attribute:
    .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
    .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
    .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
    .db %00000000, %00000000, %01010000, %10010100, %10101111, %01101111, %00000000, %00000000
    
 
palette_bg:
    .db $22,$15,$1A,$0F,$22,$36,$17,$0F,$22,$30,$21,$0F,$22,$01,$17,$0F
palette_sprite:
    .db $22,$1C,$15,$14,$22,$02,$38,$3C,$22,$1C,$15,$14,$22,$02,$38,$3C   
    
    

.goto $FFFA


.dw nmi
.dw reset
.dw irq


.incbin "mario1.chr"

.db %10000001
.db %01000010
.db %00111100
.db %00111100
.db %00111100
.db %00111100
.db %01000010
.db %10000001


.db %00000000
.db %00000000
.db %00111100
.db %00111100
.db %00111100
.db %00111100
.db %00000000
.db %00000000

.incbin "mario0.chr"