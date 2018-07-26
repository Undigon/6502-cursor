; Visor de memoria [$0200 - $021f]
;                  [$0220 - $022f]
;                  [$05e0 - $05ff]
; Ultima tecla presionada [$00FF]

start:
  LDA #$2
  STA $01

; cursor xy lo-byte @ $00 [00 - ff] renglon 20 - 40 - etc
; cursor xy hi-byte @ $01 [02 - 05]

readinput:
 LDA $FF            ;Cargar última tecla
;x
 CMP #$68        ;¿Es h? (izquierda)
 BEQ decx           
 CMP #$6C        ;¿Es l? (derecha)
 BEQ incx
;y
 CMP #$6B       ;¿Es k? (arriba)
 BEQ incy
 CMP #$6A       ;¿Es j? (abajo)
 BEQ decy
;Si ninguna de las condiciones de movimiento se dieron
 CMP #$78       ;¿Es x?
 BEQ loadbrush  ;Sale del modo cursor.
;Default
 JMP readinput

incx:
 INC $00
 BEQ inchix
 JMP drawcursor
decx:
 DEC $00
 BEQ dechix
 JMP drawcursor
dechix:
 DEC $01
 JMP drawcursor
inchix:
 INC $01
 JMP drawcursor

incy:           ;incorrect
 LDA $00        ;
 ADC #$40       ;
 BCS inchix     ;
 JMP drawcursor ; No pasa nada
decy:           ; en $0200 hasta
 LDA $00        ; $021f. Luego,
 SEC            ; rompe a
 SBC #$20       ; drawcursor.
 BCS dechix     ;
 JMP drawcursor ;incorrect

drawcursor:        ;BUG
 LDA #$00          ;
 DEC $00           ;
 STA ($00),Y       ;
 INC $00           ;
alliswell:         ;
 STX $FF           ;
 LDA #$01          ;
 STA ($00,X)       ;
 JMP readinput     ;BUG
 
loadbrush:
 LDA #$4

idle:
 LDX $ff
 CPX #$61
 BNE idle

paint:
 STA $02A1

idle2:
 LDX $ff
 CPX #$61
 BEQ idle2

erase:
 LDA #$00
 STA $02A1
 JMP loadbrush
