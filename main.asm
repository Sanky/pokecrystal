SECTION "bank0",ROM0

INCLUDE "rst.asm"

INCLUDE "interrupts.asm"


SECTION "header",ROM0[$100]

Start:
	nop
	jp _Start


SECTION "start",ROM0[$150]

INCLUDE "engine/init.asm"
INCLUDE "engine/vblank.asm"
INCLUDE "engine/delay.asm"
INCLUDE "engine/rtc.asm"
INCLUDE "engine/fade.asm"
INCLUDE "engine/lcd.asm"
INCLUDE "engine/time.asm"
INCLUDE "engine/serial.asm"
INCLUDE "engine/joypad.asm"
INCLUDE "engine/decompress.asm"
INCLUDE "engine/palettes.asm"
INCLUDE "engine/copy.asm"
INCLUDE "engine/text.asm"
INCLUDE "engine/video.asm"
INCLUDE "engine/map_objects.asm"
INCLUDE "engine/sine.asm"

Function1b1e: ; 1b1e
	ld [$d003], a
	xor a
	ld [DefaultFlypoint], a
	ld a, $0
	ld [$d004], a
	ld a, $7
	ld [StartFlypoint], a
	ld a, $d0
	ld [EndFlypoint], a
	ret
; 1b35

Function1b35: ; 1b35
	ld a, [DefaultFlypoint]
	and a
	ret z
	dec a
	ld [DefaultFlypoint], a
	ret
; 1b3f

Function1b3f: ; 1b3f
	push hl
	push de
	ld hl, DefaultFlypoint
	ld e, [hl]
	inc [hl]
	ld d, 0
	ld hl, MovementBuffer
	add hl, de
	ld [hl], a
	pop de
	pop hl
	ret
; 1b50

Function1b50: ; 1b50
	push af
	ld a, c
	and a
	jr nz, .asm_1b57
	pop af
	ret

.asm_1b57
	pop af
.asm_1b58
	call Function1b3f
	dec c
	jr nz, .asm_1b58
	ret
; 1b5f

Function1b5f: ; 1b5f
	push af
	ld a, b
	sub d
	ld h, $2
	jr nc, .asm_1b6a
	dec a
	cpl
	ld h, $3

.asm_1b6a
	ld d, a
	ld a, c
	sub e
	ld l, $1
	jr nc, .asm_1b75
	dec a
	cpl
	ld l, $0

.asm_1b75
	ld e, a
	cp d
	jr nc, .asm_1b7f
	ld a, h
	ld h, l
	ld l, a
	ld a, d
	ld d, e
	ld e, a

.asm_1b7f
	pop af
	ld b, a
	ld a, h
	call Function1b92
	ld c, d
	call Function1b50
	ld a, l
	call Function1b92
	ld c, e
	call Function1b50
	ret
; 1b92

Function1b92: ; 1b92
	push de
	push hl
	ld l, b
	ld h, 0
	add hl, hl
	add hl, hl
	ld e, a
	ld d, 0
	add hl, de
	ld de, .data_1ba5
	add hl, de
	ld a, [hl]
	pop hl
	pop de
	ret
; 1ba5

.data_1ba5
	db 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
; 1bb1

Function1bb1: ; 1bb1
	push hl
	push bc
	ld hl, $cfa1
	ld b, $8
.asm_1bb8
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .asm_1bb8
	ld a, $1
	ld [hli], a
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	pop bc
	pop hl
	ret
; 1bc9

Function1bc9: ; 1bc9
	ld hl, $41a8
	ld a, $9
	rst FarCall
	call Function1bdd
	ret
; 1bd3

Function1bd3: ; 1bd3
	ld hl, $41ab
	ld a, $9
	rst FarCall
	call Function1bdd
	ret
; 1bdd

Function1bdd: ; 1bdd
	push bc
	push af
	ld a, [$ffa9]
	and $f0
	ld b, a
	ld a, [hJoyPressed]
	and $f
	or b
	ld b, a
	pop af
	ld a, b
	pop bc
	ret
; 1bee

Function1bee: ; 1bee
	ld hl, $cfac
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [hl], $ec
	ret
; 1bf7

Function1bf7: ; 1bf7
	ld hl, $cfac
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [hl], $7f
	ret
; 1c00

Function1c00: ; 1c00
	ld hl, $4374
	ld a, $9
	rst FarCall
	ret
; 1c07

Function1c07: ; 0x1c07
	push af
	callab Function243e8
	pop af
	ret

Function1c10: ; 0x1c10
	callab Function2446d
	ret

Function1c17: ; 0x1c17
	push af
	call Function1c07
	call Function321c
	call Function1ad2
	pop af
	ret

Function1c23: ; 0x1c23
	call Function1cfd
	call Function1c30
	call Function1d19
	call Function1c30
	ret

Function1c30: ; 0x1c30
	call Function1c53
	inc b
	inc c
.asm_1c35
	push bc
	push hl
.asm_1c37
	ld a, [de]
	ld [hli], a
	dec de
	dec c
	jr nz, .asm_1c37 ; 0x1c3b $fa
	pop hl
	ld bc, $0014
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_1c35 ; 0x1c44 $ef
	ret

Function1c47: ; 0x1c47
	ld b, $10
	ld de, $cf81
.asm_1c4c
	ld a, [hld]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_1c4c ; 0x1c50 $fa
	ret

Function1c53: ; 0x1c53
	ld a, [$cf82]
	ld b, a
	ld a, [$cf84]
	sub b
	ld b, a
	ld a, [$cf83]
	ld c, a
	ld a, [$cf85]
	sub c
	ld c, a
	ret
; 0x1c66

Function1c66: ; 1c66
	push hl
	push de
	push bc
	push af
	ld hl, $cf86
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $cf91
	ld bc, $0010
	call CopyBytes
	pop af
	pop bc
	pop de
	pop hl
	ret
; 1c7e

Function1c7e: ; 1c7e
	ld hl, $cf71
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret
; 1c89

Function1c89: ; 1c89
	call Function1c66
	ld hl, $cf86
	ld e, [hl]
	inc hl
	ld d, [hl]
	call Function1cc6
	call Function1d05
	inc de
	ld a, [de]
	inc de
	ld b, a
.asm_1c9c
	push bc
	call PlaceString
	inc de
	ld bc, $0028
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_1c9c
	ld a, [$cf91]
	bit 4, a
	ret z
	call Function1cfd
	ld a, [de]
	ld c, a
	inc de
	ld b, $0
	add hl, bc
	jp PlaceString
; 1cbb

Function1cbb: ; 1cbb
	call Function1cfd
	call Function1c53
	dec b
	dec c
	jp TextBox
; 1cc6

Function1cc6: ; 1cc6
	ld a, [$cf82]
	ld b, a
	inc b
	ld a, [$cf83]
	ld c, a
	inc c
	ld a, [$cf91]
	bit 6, a
	jr nz, .asm_1cd8
	inc b

.asm_1cd8
	ld a, [$cf91]
	bit 7, a
	jr z, .asm_1ce0
	inc c

.asm_1ce0
	ret
; 1ce1

Function1ce1: ; 1ce1
	call Function1cfd
	ld bc, $0015
	add hl, bc
	call Function1c53
	dec b
	dec c
	call ClearBox
	ret
; 1cf1

Function1cf1: ; 1cf1
	call Function1cfd
	call Function1c53
	inc c
	inc b
	call ClearBox
	ret
; 1cfd


Function1cfd: ; 1cfd
	ld a, [$cf83]
	ld c, a
	ld a, [$cf82]
	ld b, a
; 1d05


Function1d05: ; 1d05
	xor a
	ld h, a
	ld l, b
	ld a, c
	ld b, h
	ld c, l
	add hl, hl
	add hl, hl
	add hl, bc
	add hl, hl
	add hl, hl
	ld c, a
	xor a
	ld b, a
	add hl, bc
	ld bc, TileMap
	add hl, bc
	ret
; 1d19

Function1d19: ; 1d19
	ld a, [$cf83]
	ld c, a
	ld a, [$cf82]
	ld b, a
	xor a
	ld h, a
	ld l, b
	ld a, c
	ld b, h
	ld c, l
	add hl, hl
	add hl, hl
	add hl, bc
	add hl, hl
	add hl, hl
	ld c, a
	xor a
	ld b, a
	add hl, bc
	ld bc, AttrMap
	add hl, bc
	ret
; 1d35


INCLUDE "engine/menu.asm"


AskSerial: ; 2063
; send out a handshake while serial int is off
	ld a, [$c2d4]
	bit 0, a
	ret z
	
	ld a, [$c2d5]
	and a
	ret nz
	
; once every 6 frames
	ld hl, $ca8a
	inc [hl]
	ld a, [hl]
	cp 6
	ret c
	
	xor a
	ld [hl], a
	
	ld a, $c
	ld [$c2d5], a
	
; handshake
	ld a, $88
	ld [rSB], a
	
; switch to internal clock
	ld a, %00000001
	ld [rSC], a
	
; start transfer
	ld a, %10000001
	ld [rSC], a
	
	ret
; 208a


INCLUDE "engine/game_time.asm"


Function210f: ; 210f
	ld hl, $c7e8
	ld bc, $0018
	ld a, $0
	call ByteFill
	ret
; 211b

Function211b: ; 211b
	push hl
	ld hl, $dbf7
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ld a, [hl]
	jr nz, .asm_2128
	ld a, $ff

.asm_2128
	pop hl
	ret
; 212a

Function212a: ; 212a
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	xor a
	ld [$dbf7], a
	ld [$dbf8], a
	call Function2147
	ret c
	ld a, e
	ld [$dbf7], a
	ld a, d
	ld [$dbf8], a
	xor a
	ret
; 2147

Function2147: ; 2147
	push bc
	ld a, [hROMBank]
	push af
	ld a, $13
	rst Bankswitch

	ld hl, $501e
.asm_2151
	push hl
	ld a, [hli]
	cp $ff
	jr z, .asm_2167
	cp b
	jr nz, .asm_2160
	ld a, [hli]
	cp c
	jr nz, .asm_2160
	jr .asm_216a

.asm_2160
	pop hl
	ld de, $0004
	add hl, de
	jr .asm_2151

.asm_2167
	scf
	jr .asm_216d

.asm_216a
	ld e, [hl]
	inc hl
	ld d, [hl]

.asm_216d
	pop hl
	pop bc
	ld a, b
	rst Bankswitch

	pop bc
	ret
; 2173

Function2173: ; 2173
	call Function217a
	call Functiondb1
	ret
; 217a

Function217a: ; 217a
	ld a, [hROMBank]
	push af
	ld a, [TilesetBlocksBank]
	rst Bankswitch

	call Function2198
	ld a, $60
	ld hl, TileMap
	ld bc, $0168
	call ByteFill
	ld a, $13
	rst Bankswitch

	call $515b
	pop af
	rst Bankswitch

	ret
; 2198

Function2198: ; 2198
	ld a, [$d194]
	ld e, a
	ld a, [$d195]
	ld d, a
	ld hl, EnemyMoveAnimation
	ld b, $5

.asm_21a5
	push de
	push hl
	ld c, $6

.asm_21a9
	push de
	push hl
	ld a, [de]
	and a
	jr nz, .asm_21b2
	ld a, [$d19d]

.asm_21b2
	ld e, l
	ld d, h
	add a
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, [TilesetBlocksAddress]
	add l
	ld l, a
	ld a, [TilesetBlocksAddress + 1]
	adc h
	ld h, a

rept 3
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de

	ld a, e
	add 20
	ld e, a
	jr nc, .next\@
	inc d
.next\@
endr

	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de

	pop hl
	ld de, $0004
	add hl, de
	pop de
	inc de
	dec c
	jp nz, .asm_21a9
	pop hl
	ld de, $0060
	add hl, de
	pop de
	ld a, [$d19f]
	add $6
	add e
	ld e, a
	jr nc, .asm_2225
	inc d

.asm_2225
	dec b
	jp nz, .asm_21a5
	ret
; 222a

Function222a: ; 222a
	ld a, $fa
	ld [$ff9f], a
	callba Function15363
	xor a
	ld [$ff9f], a
	ret
; 2238

Function2238: ; 2238
	call Function2252
	ret nc
	push bc
	callba Function149af
	pop bc
	ret nc
	call Function22a7
	scf
	ret
; 224a



Function224a: ; 224a
	call Function2252
	ret nc
	call Function22a7
	ret
; 2252

Function2252: ; 2252
	callba Function1499a
	ret nc

	ld a, [hROMBank]
	push af

	call Function2c52
	call Function2266

	pop de
	ld a, d
	rst Bankswitch
	ret
; 2266

Function2266: ; 2266
	ld a, [MapY]
	sub $4
	ld e, a
	ld a, [MapX]
	sub $4
	ld d, a
	ld a, [$dbfb]
	and a
	ret z
	ld c, a
	ld hl, $dbfc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.asm_227e
	push hl
	ld a, [hli]
	cp e
	jr nz, .asm_2289
	ld a, [hli]
	cp d
	jr nz, .asm_2289
	jr .asm_2296

.asm_2289
	pop hl
	ld a, $5
	add l
	ld l, a
	jr nc, .asm_2291
	inc h

.asm_2291
	dec c
	jr nz, .asm_227e
	xor a
	ret

.asm_2296
	pop hl
	call Function22a3
	ret nc
	ld a, [$dbfb]
	inc a
	sub c
	ld c, a
	scf
	ret
; 22a3

Function22a3: ; 22a3
	inc hl
	inc hl
	scf
	ret
; 22a7

Function22a7: ; 22a7
	ld a, [hROMBank]
	push af

	call Function2c52
	call Function22b4

	pop af
	rst Bankswitch
	scf
	ret
; 22b4

Function22b4: ; 22b4
	push bc
	ld hl, $dbfc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	dec a
	ld bc, $0005
	call AddNTimes
	ld bc, $0002
	add hl, bc
	ld a, [hli]
	cp $ff
	jr nz, .asm_22d0
	ld hl, $dcac
	ld a, [hli]

.asm_22d0
	pop bc
	ld [$d146], a
	ld a, [hli]
	ld [$d147], a
	ld a, [hli]
	ld [$d148], a
	ld a, c
	ld [$d149], a
	ld a, [MapGroup]
	ld [$d14a], a
	ld a, [MapNumber]
	ld [$d14b], a
	scf
	ret
; 22ee



CheckOutdoorMap: ; 22ee
	cp ROUTE
	ret z
	cp TOWN
	ret
; 22f4

CheckIndoorMap: ; 22f4
	cp INDOOR
	ret z
	cp CAVE
	ret z
	cp DUNGEON
	ret z
	cp GATE
	ret
; 2300

Function2300: ; 2300
	cp INDOOR
	ret z
	cp GATE
	ret z
	cp $5
	ret
; 2309


Function2309: ; 2309
	call Function2326
	call Function2c52
	call Function234f
	xor a
	call Function2336
	ret
; 2317

Function2317: ; 2317
	call Function2326
	call Function2c52
	call Function234f
	ld a, $1
	call Function2336
	ret
; 2326

Function2326: ; 2326
	call Function2c3d
	call Function2c1c
	call GetSecondaryMapHeaderPointer
	call Function235c
	call Function2368
	ret
; 2336

Function2336: ; 2336
	push af
	ld hl, $d1a6
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	call Function23da
	call Function23f1
	call Function2408
	pop af
	and a
	ret nz
	call Function241f
	ret
; 234f

Function234f: ; 234f
	ld hl, $d1a4
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Function23ac
	call Function23c3
	ret
; 235c

Function235c: ; 235c
	ld de, $d19d
	ld c, $c
.asm_2361
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_2361
	ret
; 2368

Function2368: ; 2368
	ld a, $ff
	ld [NorthConnectedMapGroup], a
	ld [SouthConnectedMapGroup], a
	ld [WestConnectedMapGroup], a
	ld [EastConnectedMapGroup], a

	ld a, [$d1a8]
	ld b, a

	bit 3, b
	jr z, .asm_2384
	ld de, NorthMapConnection
	call GetMapConnection

.asm_2384
	bit 2, b
	jr z, .asm_238e
	ld de, SouthMapConnection
	call GetMapConnection

.asm_238e
	bit 1, b
	jr z, .asm_2398
	ld de, WestMapConnection
	call GetMapConnection

.asm_2398
	bit 0, b
	jr z, .asm_23a2
	ld de, EastMapConnection
	call GetMapConnection

.asm_23a2
	ret
; 23a3


GetMapConnection: ; 23a3
; Load map connection struct at hl into de.
	ld c, SouthMapConnection - NorthMapConnection
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret
; 23ac


Function23ac: ; 23ac
	ld a, [hli]
	ld c, a
	ld [$dc07], a
	ld a, l
	ld [$dc08], a
	ld a, h
	ld [$dc09], a
	ld a, c
	and a
	ret z
	ld bc, $0004
	call AddNTimes
	ret
; 23c3

Function23c3: ; 23c3
	ld a, [hli]
	ld c, a
	ld [$dc0a], a
	ld a, l
	ld [$dc0b], a
	ld a, h
	ld [$dc0c], a
	ld a, c
	and a
	ret z
	ld bc, $0003
	call AddNTimes
	ret
; 23da

Function23da: ; 23da
	ld a, [hli]
	ld c, a
	ld [$dbfb], a
	ld a, l
	ld [$dbfc], a
	ld a, h
	ld [$dbfd], a
	ld a, c
	and a
	ret z
	ld bc, $0005
	call AddNTimes
	ret
; 23f1

Function23f1: ; 23f1
	ld a, [hli]
	ld c, a
	ld [$dbfe], a
	ld a, l
	ld [$dbff], a
	ld a, h
	ld [$dc00], a
	ld a, c
	and a
	ret z
	ld bc, $0008
	call AddNTimes
	ret
; 2408

Function2408: ; 2408
	ld a, [hli]
	ld c, a
	ld [$dc01], a
	ld a, l
	ld [$dc02], a
	ld a, h
	ld [$dc03], a
	ld a, c
	and a
	ret z
	ld bc, $0005
	call AddNTimes
	ret
; 241f

Function241f: ; 241f
	push hl
	call Function2471
	pop de
	ld hl, $d72e
	ld a, [de]
	inc de
	ld [$dc04], a
	ld a, e
	ld [$dc05], a
	ld a, d
	ld [$dc06], a
	ld a, [$dc04]
	call Function2457
	ld a, [$dc04]
	ld c, a
	ld a, $10
	sub c
	jr z, .asm_2454
	ld bc, $0001
	add hl, bc
	ld bc, $0010
.asm_244a
	ld [hl], $0
	inc hl
	ld [hl], $ff
	dec hl
	add hl, bc
	dec a
	jr nz, .asm_244a

.asm_2454
	ld h, d
	ld l, e
	ret
; 2457

Function2457: ; 2457
	and a
	ret z
	ld c, a
.asm_245a
	push bc
	push hl
	ld a, $ff
	ld [hli], a
	ld b, $d
.asm_2461
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .asm_2461
	pop hl
	ld bc, $0010
	add hl, bc
	pop bc
	dec c
	jr nz, .asm_245a
	ret
; 2471

Function2471: ; 2471
	ld hl, $d4fe
	ld bc, $01e0
	xor a
	call ByteFill
	ld hl, $d4fe
	ld de, $0028
	ld c, $c
	xor a
.asm_2484
	ld [hl], a
	add hl, de
	dec c
	jr nz, .asm_2484
	ret
; 248a

Function248a: ; 248a
	call GetMapEventBank
	rst Bankswitch

	ld hl, $d1a6
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	inc hl
	ld a, [WarpNumber]
	dec a
	ld c, a
	ld b, $0
	ld a, $5
	call AddNTimes
	ld a, [hli]
	ld [YCoord], a
	ld a, [hli]
	ld [XCoord], a
	ld a, [hli]
	cp $ff
	jr nz, .asm_24b3
	call Function24ba

.asm_24b3
	ld a, $41
	ld hl, $486d
	rst FarCall
	ret
; 24ba

Function24ba: ; 24ba
	ld a, [$d149]
	ld [$dcac], a
	ld a, [$d14a]
	ld [BackupMapGroup], a
	ld a, [$d14b]
	ld [BackupMapNumber], a
	ret
; 24cd

Function24cd: ; 24cd
	ld hl, OverworldMap
	ld bc, $0514
	ld a, $0
	call ByteFill
	call Function24e4
	call FillMapConnections
	ld a, $1
	call Function263b
	ret
; 24e4



Function24e4: ; 24e4
	ld a, [hROMBank]
	push af
	ld hl, OverworldMap
	ld a, [$d19f]
	ld [hConnectedMapWidth], a
	add $6
	ld [hConnectionStripLength], a
	ld c, a
	ld b, $0
	add hl, bc
	add hl, bc
	add hl, bc
	ld c, $3
	add hl, bc
	ld a, [$d1a0]
	rst Bankswitch

	ld a, [$d1a1]
	ld e, a
	ld a, [$d1a2]
	ld d, a
	ld a, [$d19e]
	ld b, a
.asm_250c
	push hl
	ld a, [hConnectedMapWidth]
	ld c, a
.asm_2510
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .asm_2510
	pop hl
	ld a, [hConnectionStripLength]
	add l
	ld l, a
	jr nc, .asm_251e
	inc h

.asm_251e
	dec b
	jr nz, .asm_250c
	pop af
	rst Bankswitch

	ret
; 2524



FillMapConnections: ; 2524

; North
	ld a, [NorthConnectedMapGroup]
	cp $ff
	jr z, .South
	ld b, a
	ld a, [NorthConnectedMapNumber]
	ld c, a
	call GetAnyMapBlockdataBank

	ld a, [NorthConnectionStripPointer]
	ld l, a
	ld a, [NorthConnectionStripPointer + 1]
	ld h, a
	ld a, [NorthConnectionStripLocation]
	ld e, a
	ld a, [NorthConnectionStripLocation + 1]
	ld d, a
	ld a, [NorthConnectionStripLength]
	ld [hConnectionStripLength], a
	ld a, [NorthConnectedMapWidth]
	ld [hConnectedMapWidth], a
	call FillNorthConnectionStrip

.South
	ld a, [SouthConnectedMapGroup]
	cp $ff
	jr z, .West
	ld b, a
	ld a, [SouthConnectedMapNumber]
	ld c, a
	call GetAnyMapBlockdataBank

	ld a, [SouthConnectionStripPointer]
	ld l, a
	ld a, [SouthConnectionStripPointer + 1]
	ld h, a
	ld a, [SouthConnectionStripLocation]
	ld e, a
	ld a, [SouthConnectionStripLocation + 1]
	ld d, a
	ld a, [SouthConnectionStripLength]
	ld [hConnectionStripLength], a
	ld a, [SouthConnectedMapWidth]
	ld [hConnectedMapWidth], a
	call FillSouthConnectionStrip

.West
	ld a, [WestConnectedMapGroup]
	cp $ff
	jr z, .East
	ld b, a
	ld a, [WestConnectedMapNumber]
	ld c, a
	call GetAnyMapBlockdataBank

	ld a, [WestConnectionStripPointer]
	ld l, a
	ld a, [WestConnectionStripPointer + 1]
	ld h, a
	ld a, [WestConnectionStripLocation]
	ld e, a
	ld a, [WestConnectionStripLocation + 1]
	ld d, a
	ld a, [WestConnectionStripLength]
	ld b, a
	ld a, [WestConnectedMapWidth]
	ld [hConnectionStripLength], a
	call FillWestConnectionStrip

.East
	ld a, [EastConnectedMapGroup]
	cp $ff
	jr z, .Done
	ld b, a
	ld a, [EastConnectedMapNumber]
	ld c, a
	call GetAnyMapBlockdataBank

	ld a, [EastConnectionStripPointer]
	ld l, a
	ld a, [EastConnectionStripPointer + 1]
	ld h, a
	ld a, [EastConnectionStripLocation]
	ld e, a
	ld a, [EastConnectionStripLocation + 1]
	ld d, a
	ld a, [EastConnectionStripLength]
	ld b, a
	ld a, [EastConnectedMapWidth]
	ld [hConnectionStripLength], a
	call FillEastConnectionStrip

.Done
	ret
; 25d3


FillNorthConnectionStrip:
FillSouthConnectionStrip: ; 25d3

	ld c, 3
.y
	push de

	push hl
	ld a, [hConnectionStripLength]
	ld b, a
.x
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .x
	pop hl

	ld a, [hConnectedMapWidth]
	ld e, a
	ld d, 0
	add hl, de
	pop de

	ld a, [$d19f]
	add 6
	add e
	ld e, a
	jr nc, .asm_25f2
	inc d
.asm_25f2
	dec c
	jr nz, .y
	ret
; 25f6


FillWestConnectionStrip:
FillEastConnectionStrip: ; 25f6

.asm_25f6
	ld a, [$d19f]
	add 6
	ld [hConnectedMapWidth], a

	push de

	push hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	pop hl

	ld a, [hConnectionStripLength]
	ld e, a
	ld d, 0
	add hl, de
	pop de

	ld a, [hConnectedMapWidth]
	add e
	ld e, a
	jr nc, .asm_2617
	inc d
.asm_2617
	dec b
	jr nz, .asm_25f6
	ret
; 261b

Function261b: ; 261b
	ld [$d432], a
	ret
; 261f


CallScript: ; 261f
; Call a script at a:hl.

	ld [ScriptBank], a
	ld a, l
	ld [ScriptPos], a
	ld a, h
	ld [ScriptPos + 1], a

	ld a, $ff
	ld [ScriptRunning], a

	scf
	ret
; 2631

Function2631: ; 2631
	ld a, [ScriptRunning]
	and a
	ret nz
	call GetMapEventBank
	jr CallScript
; 263b

Function263b: ; 263b
	ld b, a
	ld a, [hROMBank]
	push af
	call Function2c52
	call Function2653
	jr nc, .done

	call GetMapEventBank
	ld b, a
	ld d, h
	ld e, l
	call Function2674

.done
	pop af
	rst Bankswitch
	ret
; 2653

Function2653: ; 2653
	ld a, [$dc0a]
	ld c, a
	and a
	ret z
	ld hl, $dc0b
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld de, $0003
.asm_2664
	ld a, [hl]
	cp b
	jr z, .asm_266e
	add hl, de
	dec c
	jr nz, .asm_2664
	xor a
	ret

.asm_266e
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	scf
	ret
; 2674

Function2674: ; 2674
	callba Unknown_0x974f3
	ld a, [ScriptMode]
	push af
	ld hl, ScriptFlags
	ld a, [hl]
	push af
	set 1, [hl]
	callba Function96c56
	callba ScriptEvents
	pop af
	ld [ScriptFlags], a
	pop af
	ld [ScriptMode], a
	ret
; 269a

Function269a: ; 269a
	ld a, [hROMBank]
	push af
	ld a, b
	rst Bankswitch

	push hl
	call SpeechTextBox
	call Function2e31
	ld a, 1
	ld [hOAMUpdate], a
	call Function321c
	pop hl
	call PrintTextBoxText
	xor a
	ld [hOAMUpdate], a
	pop af
	rst Bankswitch

	ret
; 26b7

Function26b7: ; 26b7
; Call a:de.

	ld [hBuffer], a
	ld a, [hROMBank]
	push af
	ld a, [hBuffer]
	rst Bankswitch

	call .de

	pop af
	rst Bankswitch
	ret

.de
	push de
	ret
; 26c7

Function26c7: ; 26c7
	ld a, [hROMBank]
	push af
	ld a, b
	rst Bankswitch

	ld a, c
	call Function19e9

	pop hl
	ld a, h
	rst Bankswitch
	ret
; 26d4


GetScriptByte: ; 0x26d4
; Return byte at ScriptBank:ScriptPos in a.

	push hl
	push bc
	ld a, [hROMBank]
	push af
	ld a, [ScriptBank]
	rst Bankswitch

	ld hl, ScriptPos
	ld c, [hl]
	inc hl
	ld b, [hl]

	ld a, [bc]

	inc bc
	ld [hl], b
	dec hl
	ld [hl], c

	ld b, a
	pop af
	rst Bankswitch
	ld a, b
	pop bc
	pop hl
	ret
; 0x26ef


ObjectEvent: ; 0x26ef
	jumptextfaceplayer ObjectEventText
; 0x26f2

ObjectEventText:
	TX_FAR _ObjectEventText
	db "@"
; 0x26f7


BGEvent: ; 26f7
	jumptext BGEventText
; 26fa

BGEventText: ; 26fa
	text_jump UnknownText_0x1c46fc, BANK(UnknownText_0x1c46fc)
	db "@"
; 26ff


CoordinatesEvent: ; 26ff
	jumptext CoordinatesEventText
; 2702

CoordinatesEventText: ; 2702
	text_jump UnknownText_0x1c4706, BANK(UnknownText_0x1c4706)
	db "@"
; 2707


Function2707: ; 2707
	ld a, [hConnectionStripLength]
	ld e, a
	ld d, $0
	ld hl, $d81e
	add hl, de
	ld a, [hl]
	ret
; 2712

Function2712: ; 2712
	ld a, [hConnectionStripLength]
	ld e, a
	ld d, $0
	ld hl, $d81e
	add hl, de
	ld [hl], $ff
	ret
; 271e

Function271e: ; 271e
	ld a, [hConnectionStripLength]
	ld e, a
	ld d, $0
	ld hl, $d81e
	add hl, de
	ld [hl], $0
	ret
; 272a


Function272a: ; 272a
	ld hl, TileMap
	ld de, BGMapBuffer
	call Function27b7
	ld c, $28
	call Functiondbd
	ld a, [$d152]
	ld e, a
	ld a, [$d153]
	ld d, a
	call Function27d3
	ld a, $1
	ld [hBGMapUpdate], a
	ret
; 2748

Function2748: ; 2748
	ld hl, $c5e0
	ld de, BGMapBuffer
	call Function27b7
	ld c, $28
	call Functiondbd
	ld a, [$d152]
	ld l, a
	ld a, [$d153]
	ld h, a
	ld bc, $0200
	add hl, bc
	ld a, h
	and $3
	or $98
	ld e, l
	ld d, a
	call Function27d3
	ld a, $1
	ld [hBGMapUpdate], a
	ret
; 2771

Function2771: ; 2771
	ld hl, TileMap
	ld de, BGMapBuffer
	call Function27c0
	ld c, $24
	call Functiondbd
	ld a, [$d152]
	ld e, a
	ld a, [$d153]
	ld d, a
	call Function27f8
	ld a, $1
	ld [hBGMapUpdate], a
	ret
; 278f

Function278f: ; 278f
	ld hl, $c4b2
	ld de, BGMapBuffer
	call Function27c0
	ld c, $24
	call Functiondbd
	ld a, [$d152]
	ld e, a
	and $e0
	ld b, a
	ld a, e
	add $12
	and $1f
	or b
	ld e, a
	ld a, [$d153]
	ld d, a
	call Function27f8
	ld a, $1
	ld [hBGMapUpdate], a
	ret
; 27b7

Function27b7: ; 27b7
	ld c, $28
.asm_27b9
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_27b9
	ret
; 27c0

Function27c0: ; 27c0
	ld c, $12
.asm_27c2
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld a, $13
	add l
	ld l, a
	jr nc, .asm_27cf
	inc h

.asm_27cf
	dec c
	jr nz, .asm_27c2
	ret
; 27d3

Function27d3: ; 27d3
	ld hl, BGMapBufferPtrs
	push de
	call .asm_27df
	pop de
	ld a, $20
	add e
	ld e, a

.asm_27df
	ld c, $a
.asm_27e1
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	inc a
	inc a
	and $1f
	ld b, a
	ld a, e
	and $e0
	or b
	ld e, a
	dec c
	jr nz, .asm_27e1
	ld a, $14
	ld [$ffdc], a
	ret
; 27f8

Function27f8: ; 27f8
	ld hl, BGMapBufferPtrs
	ld c, $12
.asm_27fd
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, $20
	add e
	ld e, a
	jr nc, .asm_280e
	inc d
	ld a, d
	and $3
	or $98
	ld d, a

.asm_280e
	dec c
	jr nz, .asm_27fd
	ld a, $12
	ld [$ffdc], a
	ret
; 2816

Function2816: ; 2816
	ld hl, BGMapBuffer
	ld bc, $0078
	xor a
	call ByteFill
	ret
; 2821

Function2821: ; 2821
	ld hl, TilesetAddress
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [TilesetBank]
	ld e, a
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	ld a, e
	ld de, $d000
	call FarDecompress
	ld hl, $d000
	ld de, VTiles2
	ld bc, $0600
	call CopyBytes
	ld a, [rVBK]
	push af
	ld a, $1
	ld [rVBK], a
	ld hl, $d600
	ld de, VTiles2
	ld bc, $0600
	call CopyBytes
	pop af
	ld [rVBK], a
	pop af
	ld [rSVBK], a
	ld a, [$d199]
	cp $1
	jr z, .asm_286f
	cp $2
	jr z, .asm_286f
	cp $4
	jr z, .asm_286f
	jr .asm_2875

.asm_286f
	ld a, $7
	ld hl, $4000
	rst FarCall

.asm_2875
	xor a
	ld [hTileAnimFrame], a
	ret
; 2879

Function2879: ; 2879
	ld hl, $d194
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $dcb9
	ld c, $5
	ld b, $6
.asm_2886
	push bc
	push hl
.asm_2888
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_2888
	pop hl
	ld a, [$d19f]
	add $6
	ld c, a
	ld b, $0
	add hl, bc
	pop bc
	dec c
	jr nz, .asm_2886
	ret
; 289d

Function289d: ; 289d
	ld hl, $d194
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $dcb9
	ld a, [$d19f]
	add $6
	ld [hConnectionStripLength], a
	ld a, [$d151]
	and a
	jr z, .asm_28cb
	cp $1
	jr z, .asm_28c0
	cp $2
	jr z, .asm_28d4
	cp $3
	jr z, .asm_28da
	ret

.asm_28c0
	ld de, $dcbf
	ld a, [hConnectionStripLength]
	ld c, a
	ld b, $0
	add hl, bc
	jr .asm_28ce

.asm_28cb
	ld de, $dcb9

.asm_28ce
	ld b, $6
	ld c, $4
	jr .asm_28f7

.asm_28d4
	ld de, $dcba
	inc hl
	jr .asm_28dd

.asm_28da
	ld de, $dcb9

.asm_28dd
	ld b, $5
	ld c, $5
	jr .asm_28f7

	ld hl, $d194
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [$d19f]
	add $6
	ld [hConnectionStripLength], a
	ld de, $dcb9
	ld b, $6
	ld c, $5

.asm_28f7
	push bc
	push hl
	push de
.asm_28fa
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .asm_28fa
	pop de
	ld a, e
	add $6
	ld e, a
	jr nc, .asm_2908
	inc d

.asm_2908
	pop hl
	ld a, [hConnectionStripLength]
	ld c, a
	ld b, $0
	add hl, bc
	pop bc
	dec c
	jr nz, .asm_28f7
	ret
; 2914

Function2914: ; 2914
	xor a
	ld [TilePermissions], a
	call Function296c
	call Function294d
	ld a, [MapX]
	ld d, a
	ld a, [MapY]
	ld e, a
	call Function2a3c
	ld [StandingTile], a
	call Function29ff
	ret nz
	ld a, [StandingTile]
	and 7
	ld hl, .data_2945
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
	ld a, [hl]
	ld hl, TilePermissions
	or [hl]
	ld [hl], a
	ret
; 2945

.data_2945 ; 2945
	db 1, 2, 4, 8, 9, 10, 5, 6
; 294d

Function294d: ; 294d
	ld a, [MapX]
	ld d, a
	ld a, [MapY]
	ld e, a
	push de
	inc e
	call Function2a3c
	ld [TileDown], a
	call Function298b
	pop de
	dec e
	call Function2a3c
	ld [TileUp], a
	call Function29a8
	ret
; 296c

Function296c: ; 296c
	ld a, [MapX]
	ld d, a
	ld a, [MapY]
	ld e, a
	push de
	dec d
	call Function2a3c
	ld [TileLeft], a
	call Function29e2
	pop de
	inc d
	call Function2a3c
	ld [TileRight], a
	call Function29c5
	ret
; 298b

Function298b: ; 298b
	call Function29ff
	ret nz
	ld a, [TileDown]
	and $7
	cp $2
	jr z, .asm_299f
	cp $6
	jr z, .asm_299f
	cp $7
	ret nz

.asm_299f
	ld a, [TilePermissions]
	or $8
	ld [TilePermissions], a
	ret
; 29a8

Function29a8: ; 29a8
	call Function29ff
	ret nz
	ld a, [TileUp]
	and $7
	cp $3
	jr z, .asm_29bc
	cp $4
	jr z, .asm_29bc
	cp $5
	ret nz

.asm_29bc
	ld a, [TilePermissions]
	or $4
	ld [TilePermissions], a
	ret
; 29c5

Function29c5: ; 29c5
	call Function29ff
	ret nz
	ld a, [TileRight]
	and $7
	cp $1
	jr z, .asm_29d9
	cp $5
	jr z, .asm_29d9
	cp $7
	ret nz

.asm_29d9
	ld a, [TilePermissions]
	or $1
	ld [TilePermissions], a
	ret
; 29e2

Function29e2: ; 29e2
	call Function29ff
	ret nz
	ld a, [TileLeft]
	and $7
	cp $0
	jr z, .asm_29f6
	cp $4
	jr z, .asm_29f6
	cp $6
	ret nz

.asm_29f6
	ld a, [TilePermissions]
	or $2
	ld [TilePermissions], a
	ret
; 29ff

Function29ff: ; 29ff
	and $f0
	cp $b0
	ret z
	cp $c0
	ret
; 2a07


GetFacingTileCoord: ; 2a07
; Return map coordinates in (d, e) and tile id in a
; of the tile the player is facing.

	ld a, [PlayerDirection]
	and %1100
	srl a
	srl a
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, .Directions
	add hl, de

	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl

	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [MapX]
	add d
	ld d, a
	ld a, [MapY]
	add e
	ld e, a
	ld a, [hl]
	ret

.Directions
	;   x,  y
	db  0,  1
	dw TileDown
	db  0, -1
	dw TileUp
	db -1,  0
	dw TileLeft
	db  1,  0
	dw TileRight
; 2a3c


Function2a3c: ; 2a3c
	call Function2a66
	ld a, [hl]
	and a
	jr z, .asm_2a63
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	ld a, [TilesetCollisionAddress]
	ld c, a
	ld a, [$d1e1]
	ld b, a
	add hl, bc
	rr d
	jr nc, .asm_2a56
	inc hl

.asm_2a56
	rr e
	jr nc, .asm_2a5c
	inc hl
	inc hl

.asm_2a5c
	ld a, [TilesetCollisionBank]
	call GetFarByte
	ret

.asm_2a63
	ld a, $ff
	ret
; 2a66

Function2a66: ; 2a66
	ld a, [$d19f]
	add $6
	ld c, a
	ld b, $0
	ld hl, $c801
	add hl, bc
	ld a, e
	srl a
	jr z, .asm_2a84
	and a
.asm_2a78
	srl a
	jr nc, .asm_2a7d
	add hl, bc

.asm_2a7d
	sla c
	rl b
	and a
	jr nz, .asm_2a78

.asm_2a84
	ld c, d
	srl c
	ld b, $0
	add hl, bc
	ret
; 2a8b


CheckFacingSign: ; 2a8b
	call GetFacingTileCoord
	ld b, a
	ld a, d
	sub 4
	ld d, a
	ld a, e
	sub 4
	ld e, a
	ld a, [$dc01]
	and a
	ret z
	ld c, a
	ld a, [hROMBank]
	push af
	call Function2c52
	call Function2aaa
	pop hl
	ld a, h
	rst Bankswitch
	ret
; 2aaa

Function2aaa: ; 2aaa
	ld hl, $dc02
	ld a, [hli]
	ld h, [hl]
	ld l, a
.asm_2ab0
	push hl
	ld a, [hli]
	cp e
	jr nz, .asm_2abb
	ld a, [hli]
	cp d
	jr nz, .asm_2abb
	jr .asm_2ac8

.asm_2abb
	pop hl
	ld a, 5
	add l
	ld l, a
	jr nc, .asm_2ac3
	inc h

.asm_2ac3
	dec c
	jr nz, .asm_2ab0
	xor a
	ret

.asm_2ac8
	pop hl
	ld de, EngineBuffer1
	ld bc, 5
	call CopyBytes
	scf
	ret
; 2ad4

Function2ad4: ; 2ad4
	ld a, [$dbfe]
	and a
	ret z
	ld c, a
	ld a, [hROMBank]
	push af
	call Function2c52
	call Function2ae7
	pop hl
	ld a, h
	rst Bankswitch
	ret
; 2ae7

Function2ae7: ; 2ae7
	ld hl, $dbff
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Function211b
	ld b, a
	ld a, [MapX]
	sub $4
	ld d, a
	ld a, [MapY]
	sub $4
	ld e, a
.asm_2afd
	push hl
	ld a, [hli]
	cp b
	jr z, .asm_2b06
	cp $ff
	jr nz, .asm_2b10

.asm_2b06
	ld a, [hli]
	cp e
	jr nz, .asm_2b10
	ld a, [hli]
	cp d
	jr nz, .asm_2b10
	jr .asm_2b1d

.asm_2b10
	pop hl
	ld a, $8
	add l
	ld l, a
	jr nc, .asm_2b18
	inc h

.asm_2b18
	dec c
	jr nz, .asm_2afd
	xor a
	ret

.asm_2b1d
	pop hl
	ld de, EngineBuffer1
	ld bc, $0008
	call CopyBytes
	scf
	ret
; 2b29


FadeToMenu: ; 2b29
	xor a
	ld [hBGMapMode], a
	call Function1d6e
	ld a, $23
	ld hl, $4084
	rst FarCall
	call ClearSprites
	call Function2ed3
	ret
; 2b3c


Function2b3c: ; 2b3c
	call WhiteBGMap
	call Function2bae
	call Function1ad2
	call Function1d7d
	call Functiond90
	jr Function2b5c
; 2b4d

Function2b4d: ; 2b4d
	call WhiteBGMap
	call Function1d7d
	call Function2bae
	call Function1ad2
	call Functiond90
; 2b5c

Function2b5c: ; 2b5c
	ld b, $9
	call GetSGBLayout
	ld a, $12
	ld hl, $5409
	rst FarCall
	call Function3200
	ld a, $23
	ld hl, $4079
	rst FarCall
	call Function2ee4
	ret
; 2b74


Function2b74: ; 0x2b74
	push af
	ld a, $1
	ld [$c2ce], a
	call WhiteBGMap
	call ClearSprites
	call Function2bae
	ld hl, $c590 ; tile 0, 12
	ld bc, $0412
	call TextBox
	ld hl, VramState
	set 0, [hl]
	call Function1ad2
	call Function3200
	ld b, $9
	call GetSGBLayout
	callba Function49409
	call UpdateTimePals
	call DelayFrame
	ld a, $1
	ld [$ffde], a
	pop af
	ret
; 0x2bae

Function2bae: ; 2bae
	call DisableLCD
	call ClearSprites
	ld a, $5
	ld hl, $4168
	rst FarCall
	call Functione51
	call Functione5f
	ld a, [hROMBank]
	push af
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call Function2c24
	ld a, $23
	ld hl, $4001
	rst FarCall
	call Function2173
	call Function2821
	ld a, $9
	call Function3cb4
	pop af
	rst Bankswitch

	call EnableLCD
	ret
; 2be5


GetMapHeaderPointer: ; 2be5
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
; 2bed

GetAnyMapHeaderPointer: ; 0x2bed
; Prior to calling this function, you must have switched banks so that
; MapGroupPointers is visible.

; inputs:
; b = map group, c = map number
; XXX de = ???

; outputs:
; hl points to the map header
	push bc ; save map number for later

	; get pointer to map group
	dec b
	ld c, b
	ld b, $0
	ld hl, MapGroupPointers
	add hl, bc
	add hl, bc

	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc ; restore map number

	; find the cth map header
	dec c
	ld b, $0
	ld a, OlivineGym_MapHeader - OlivinePokeCenter1F_MapHeader
	call AddNTimes
	ret
; 0x2c04

GetMapHeaderMember: ; 0x2c04
; Extract data from the current map's header.

; inputs:
; de = offset of desired data within the mapheader

; outputs:
; bc = data from the current map's header
; (e.g., de = $0003 would return a pointer to the secondary map header)

	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	; fallthrough

GetAnyMapHeaderMember: ; 0x2c0c
	; bankswitch
	ld a, [hROMBank]
	push af
	ld a, BANK(MapGroupPointers)
	rst Bankswitch

	call GetAnyMapHeaderPointer
	add hl, de
	ld c, [hl]
	inc hl
	ld b, [hl]

	; bankswitch back
	pop af
	rst Bankswitch
	ret
; 0x2c1c


Function2c1c: ; 2c1c
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
; 2c24

Function2c24: ; 2c24
	call Function2c31
	rst Bankswitch
	ret
; 2c29


Function2c29: ; 2c29
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
; 2c31

Function2c31: ; 2c31
	push hl
	push de
	ld de, $0000
	call GetAnyMapHeaderMember
	ld a, c
	pop de
	pop hl
	ret
; 2c3d

Function2c3d: ; 2c3d
	ld a, [hROMBank]
	push af
	ld a, $25
	rst Bankswitch
	call GetMapHeaderPointer
	ld de, $d198
	ld bc, $0005
	call CopyBytes
	pop af
	rst Bankswitch
	ret
; 2c52

Function2c52: ; 2c52
	ld a, [MapEventBank]
	rst Bankswitch
	ret
; 2c57


GetMapEventBank: ; 2c57
	ld a, [MapEventBank]
	ret
; 2c5b

GetAnyMapBlockdataBank: ; 2c5b
; Return the blockdata bank for group b map c.
	push hl
	push de
	push bc

	push bc
	ld de, 3 ; second map header pointer
	call GetAnyMapHeaderMember
	ld l, c
	ld h, b
	pop bc

	push hl
	ld de, 0 ; second map header bank
	call GetAnyMapHeaderMember
	pop hl

	ld de, 3 ; blockdata bank
	add hl, de
	ld a, c
	call GetFarByte
	rst Bankswitch

	pop bc
	pop de
	pop hl
	ret
; 2c7d

GetSecondaryMapHeaderPointer: ; 0x2c7d
; returns the current map's secondary map header pointer in hl.
	push bc
	push de
	ld de, $0003 ; secondary map header pointer (offset within header)
	call GetMapHeaderMember
	ld l, c
	ld h, b
	pop de
	pop bc
	ret
; 2c8a

GetMapPermission: ; 2c8a
	push hl
	push de
	push bc
	ld de, 2
	call GetMapHeaderMember
	ld a, c
	pop bc
	pop de
	pop hl
	ret
; 2c98

Function2c98: ; 2c98
	ret
; 2c99

Function2c99: ; 2c99
	push hl
	push de
	push bc
	ld de, $0002
	call GetAnyMapHeaderMember
	ld a, c
	pop bc
	pop de
	pop hl
	ret
; 2ca7

Function2ca7: ; 2ca7
	ld de, $0001
	call GetAnyMapHeaderMember
	ld a, c
	ret
; 2caf

GetWorldMapLocation: ; 0x2caf
; given a map group/id in bc, return its location on the Pokégear map.
	push hl
	push de
	push bc
	ld de, 5
	call GetAnyMapHeaderMember
	ld a, c
	pop bc
	pop de
	pop hl
	ret
; 0x2cbd

Function2cbd: ; 2cbd
	push hl
	push bc
	ld de, $0006
	call GetMapHeaderMember
	ld a, c
	cp $64
	jr z, .asm_2cee
	bit 7, c
	jr nz, .asm_2cda
	ld a, $22
	ld hl, $7342
	rst FarCall
	ld e, c
	ld d, $0
.asm_2cd7
	pop bc
	pop hl
	ret

.asm_2cda
	ld a, [StatusFlags2]
	bit 0, a
	jr z, .asm_2ce6
	ld de, $0056
	jr .asm_2cd7

.asm_2ce6
	ld a, c
	and $7f
	ld e, a
	ld d, $0
	jr .asm_2cd7

.asm_2cee
	ld a, [StatusFlags2]
	bit 7, a
	jr z, .asm_2cfa
	ld de, $0048
	jr .asm_2cd7

.asm_2cfa
	ld de, $0026
	jr .asm_2cd7
; 2cff

Function2cff: ; 2cff
	call Function2d0d
	and $f
	ret
; 2d05

Function2d05: ; 2d05
	call Function2d0d
	and $f0
	swap a
	ret
; 2d0d

Function2d0d: ; 2d0d
	push hl
	push bc
	ld de, $0007
	call GetMapHeaderMember
	ld a, c
	pop bc
	pop hl
	ret
; 2d19

Function2d19: ; 2d19
	push de
	push hl
	push bc
	ld de, $0008
	call GetMapHeaderMember
	ld a, c
	pop bc
	pop hl
	pop de
	ret
; 2d27

Function2d27: ; 2d27
	push hl
	push bc
	ld hl, $5596
	ld bc, $000f
	ld a, [$d199]
	call AddNTimes
	ld de, TilesetBank
	ld bc, $000f
	ld a, $13
	call FarCopyBytes
	pop bc
	pop hl
	ret
; 2d43

Function2d43: ; 2d43
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ret
; 2d54


INCLUDE "engine/farcall.asm"


Predef: ; 2d83
; Call predefined function a.
; Preserves bc, de, hl and f.

	ld [PredefID], a
	ld a, [hROMBank]
	push af

	ld a, BANK(GetPredefPointer)
	rst Bankswitch
	call GetPredefPointer ; stores hl in PredefTemp

; Switch to the new function's bank
	rst Bankswitch

; Instead of directly calling stuff,
; push it to the stack in reverse.

	ld hl, .Return
	push hl
	
; Call the Predef function
	ld a, [PredefAddress]
	ld h, a
	ld a, [PredefAddress + 1]
	ld l, a
	push hl

; Get hl back
	ld a, [PredefTemp]
	ld h, a
	ld a, [PredefTemp + 1]
	ld l, a
	ret

.Return
; Clean up after the Predef call

	ld a, h
	ld [PredefTemp], a
	ld a, l
	ld [PredefTemp+1], a

	pop hl
	ld a, h
	rst Bankswitch

	ld a, [PredefTemp]
	ld h, a
	ld a, [PredefTemp + 1]
	ld l, a
	ret
; 2dba


ResetWindow: ; 2dba

	call Function1fbf
	ld a, [hROMBank]
	push af
	ld a, $1
	rst Bankswitch

	call $6454
	call Function2e20
	call $64bf

	pop af
	rst Bankswitch
	ret
; 2dcf


Function2dcf: ; 2dcf
	ld a, [hOAMUpdate]
	push af
	ld a, $1
	ld [hOAMUpdate], a
	call Function2de2
	pop af
	ld [hOAMUpdate], a
	ld hl, VramState
	res 6, [hl]
	ret
; 2de2

Function2de2: ; 2de2
	call Function1fbf
	xor a
	ld [hBGMapMode], a
	call Function2173
	call Function2e20
	xor a
	ld [hBGMapMode], a
	call Function2e31
	ld a, $90
	ld [hWY], a
	call Functione4a
	ld a, $2e
	ld hl, $4000
	rst FarCall
	ld a, $41
	ld hl, $6594
	rst FarCall
	ret
; 2e08

Function2e08: ; 2e08
	call Function1fbf
	ld a, [hROMBank]
	push af
	ld a, $1
	rst Bankswitch

	call $6454
	call SpeechTextBox
	call Function2e20
	call $64bf
	pop af
	rst Bankswitch

	ret
; 2e20

Function2e20: ; 2e20
	ld a, [hOAMUpdate]
	push af
	ld a, $1
	ld [hOAMUpdate], a
	ld a, $41
	ld hl, $4110
	rst FarCall
	pop af
	ld [hOAMUpdate], a
	ret
; 2e31

Function2e31: ; 2e31
	ld a, [hOAMUpdate]
	push af
	ld a, [hBGMapMode]
	push af
	xor a
	ld [hBGMapMode], a
	ld a, $1
	ld [hOAMUpdate], a
	call Function1ad2
	xor a
	ld [hOAMUpdate], a
	call DelayFrame
	pop af
	ld [hBGMapMode], a
	pop af
	ld [hOAMUpdate], a
	ret
; 2e4e

Function2e4e: ; 2e4e
	scf
	ret
; 2e50

Function2e50: ; 2e50
	xor a
	ld hl, $da72
	ld [hli], a
	ret
; 2e56

Function2e56: ; 2e56
	xor a
	ld hl, BikeFlags
	ld [hli], a
	ld [hl], a
	ret
; 2e5d

Function2e5d: ; 2e5d
	ld a, [$d19a]
	cp $2
	jr z, .asm_2e69
	cp $1
	jr z, .asm_2e69
	ret

.asm_2e69
	ld hl, StatusFlags
	res 2, [hl]
	ret
; 2e6f


EventFlagAction: ; 0x2e6f
	ld hl, EventFlags
	call FlagAction
	ret

FlagAction: ; 0x2e76
; Perform a function on a bit in memory.

; inputs:
; b: function
;    0 clear bit
;    1 set bit
;    2 check bit
; de: bit number
; hl: index within bit table

	; get index within the byte
	ld a, e
	and $7

	; shift de right by three bits (get the index within memory)
	srl d
	rr e
	srl d
	rr e
	srl d
	rr e
	add hl, de

	; implement a decoder
	ld c, $1
	rrca
	jr nc, .one
	rlc c
.one
	rrca
	jr nc, .two
	rlc c
	rlc c
.two
	rrca
	jr nc, .three
	swap c
.three

	; check b's value: 0, 1, 2
	ld a, b
	cp 1
	jr c, .clearbit ; 0
	jr z, .setbit ; 1

	; check bit
	ld a, [hl]
	and c
	ld c, a
	ret

.setbit
	; set bit
	ld a, [hl]
	or c
	ld [hl], a
	ret

.clearbit
	; clear bit
	ld a, c
	cpl
	and [hl]
	ld [hl], a
	ret
; 0x2ead


Function2ead: ; 2ead
	ld de, ENGINE_POKEDEX
	ld b, CHECK_FLAG
	callba EngineFlagAction
	ld a, c
	and a
	ret
; 2ebb

Function2ebb: ; 2ebb
	ld a, [$c2cc]
	bit 1, a
	ret z
	ld a, [hJoyDown]
	bit 1, a
	ret
; 2ec6


Function2ec6: ; 2ec6
	xor a
	ret
; 2ec8

Function2ec8: ; 2ec8
	xor a
	dec a
	ret
; 2ecb


Function2ecb: ; 2ecb
	push hl
	ld hl, $c2cc
	bit 1, [hl]
	pop hl
	ret
; 2ed3


Function2ed3: ; 0x2ed3
; disables overworld sprite updating?
	xor a
	ld [$ffde], a
	ld a, [VramState]
	res 0, a
	ld [VramState], a
	ld a, $0
	ld [$c2ce], a
	ret
; 0x2ee4

Function2ee4: ; 2ee4
	ld a, $1
	ld [$c2ce], a
	ld a, [VramState]
	set 0, a
	ld [VramState], a
	ld a, $1
	ld [$ffde], a
	ret
; 2ef6


InitString: ; 2ef6
; Init a string of length c.
	push hl
	jr _InitString
; 2ef9

InitName: ; 2ef9
; Intended for names, so this function is limited to ten characters.
	push hl
	ld c, 10
; 2efc

_InitString: ; 2efc
; if the string pointed to by hl is empty (defined as "zero or more spaces
; followed by a null"), then initialize it to the string pointed to by de.
	push bc
.loop
	ld a, [hli]
	cp "@"
	jr z, .blank
	cp " "
	jr nz, .notblank
	dec c
	jr nz, .loop
.blank
	pop bc
	ld l, e
	ld h, d
	pop de
	ld b, $0
	inc c
	call CopyBytes
	ret
.notblank
	pop bc
	pop hl
	ret
; 2f17

Function2f17: ; 2f17
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call GetWorldMapLocation
	cp $5f
	jr z, .asm_2f39
	cp $0
	jr nz, .asm_2f35
	ld a, [BackupMapGroup]
	ld b, a
	ld a, [BackupMapNumber]
	ld c, a
	call GetWorldMapLocation

.asm_2f35
	cp $2f
	jr nc, .asm_2f3b

.asm_2f39
	xor a
	ret

.asm_2f3b
	ld a, $1
	ret
; 2f3e


Function2f3e: ; 2f3e
	ret
; 2f3f

DoItemEffect: ; 2f3f
	callba _DoItemEffect
	ret
; 2f46

CheckTossableItem: ; 2f46
	push hl
	push de
	push bc
	callba _CheckTossableItem
	pop bc
	pop de
	pop hl
	ret
; 2f53

Function2f53: ; 2f53
	push hl
	push de
	push bc
	ld a, [hROMBank]
	push af
	ld a, $3
	rst Bankswitch

	call $520d
	pop bc
	ld a, b
	rst Bankswitch

	pop bc
	pop de
	pop hl
	ret
; 2f66

Function2f66: ; 2f66
	push bc
	ld a, [hROMBank]
	push af
	ld a, $3
	rst Bankswitch

	push hl
	push de
	call $51d5
	pop de
	pop hl
	pop bc
	ld a, b
	rst Bankswitch

	pop bc
	ret
; 2f79

PickUpItem: ; 2f79
	push hl
	push de
	push bc
	ld a, [hROMBank]
	push af
	ld a, BANK(_PickUpItem)
	rst Bankswitch

	call _PickUpItem

	pop bc
	ld a, b
	rst Bankswitch
	pop bc
	pop de
	pop hl
	ret
; 2f8c


Random: ; 2f8c
; A simple hardware-based random number generator (RNG).

; Two random numbers are generated by adding and subtracting
; the divider to the respective values every time it's called.

; The divider is a register that increments at a rate of 16384Hz.
; For comparison, the Game Boy operates at a clock speed of 4.2MHz.

; Additionally, an equivalent function is executed in VBlank.

; This leaves a with the value in hRandomSub.

	push bc

	ld a, [rDIV]
	ld b, a
	ld a, [hRandomAdd]
	adc b
	ld [hRandomAdd], a

	ld a, [rDIV]
	ld b, a
	ld a, [hRandomSub]
	sbc b
	ld [hRandomSub], a

	pop bc
	ret
; 2f9f

BattleRandom: ; 2f9f
; _BattleRandom lives in another bank.

; It handles all RNG calls in the battle engine, allowing
; link battles to remain in sync using a shared PRNG.

	ld a, [hROMBank]
	push af
	ld a, BANK(_BattleRandom)
	rst Bankswitch

	call _BattleRandom

	ld [$cfb6], a
	pop af
	rst Bankswitch
	ld a, [$cfb6]
	ret
; 2fb1


Function2fb1: ; 2fb1
	push bc
	ld c, a
	xor a
	sub c
.asm_2fb5
	sub c
	jr nc, .asm_2fb5
	add c
	ld b, a
	push bc
.asm_2fbb
	call Random
	ld a, [hRandomAdd]
	ld c, a
	add b
	jr c, .asm_2fbb
	ld a, c
	pop bc
	call SimpleDivide
	pop bc
	ret
; 2fcb

GetSRAMBank: ; 2fcb
; load sram bank a
; if invalid bank, sram is disabled
	cp NUM_SRAM_BANKS
	jr c, OpenSRAM
	jr CloseSRAM
; 2fd1

OpenSRAM: ; 2fd1
; switch to sram bank a
	push af
; latch clock data
	ld a, 1
	ld [MBC3LatchClock], a
; enable sram/clock write
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
; select sram bank
	pop af
	ld [MBC3SRamBank], a
	ret
; 2fe1

CloseSRAM: ; 2fe1
; preserve a
	push af
	ld a, SRAM_DISABLE
; reset clock latch for next time
	ld [MBC3LatchClock], a
; disable sram/clock write
	ld [MBC3SRamEnable], a
	pop af
	ret
; 2fec


; Register aliases

_hl_: ; 2fec
	jp [hl]
; 2fed

_de_: ; 2fed
	push de
	ret
; 2fef


Function2fef: ; 2fef
	ld hl, rKEY1
	bit 7, [hl]
	jr z, Function2ffd
	ret
; 2ff7

Function2ff7: ; 2ff7
	ld hl, rKEY1
	bit 7, [hl]
	ret z
; 2ffd

Function2ffd: ; 2ffd
	set 0, [hl]
	xor a
	ld [rIF], a
	ld [rIE], a
	ld a, $30
	ld [rJOYP], a
	stop ; rgbasm adds a nop after this instruction by default
	ret
; 300b


ClearSprites: ; 300b
	ld hl, Sprites
	ld b, TileMap - Sprites
	xor a
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret
; 3016

HideSprites: ; 3016
; Set all OBJ y-positions to 160 to hide them offscreen
	ld hl, Sprites
	ld de, $0004 ; length of an OBJ struct
	ld b, $28 ; number of OBJ structs
	ld a, 160 ; y-position
.loop
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop
	ret
; 3026

CopyBytes: ; 0x3026
; copy bc bytes from hl to de
	inc b  ; we bail the moment b hits 0, so include the last run
	inc c  ; same thing; include last byte
	jr .HandleLoop
.CopyByte
	ld a, [hli]
	ld [de], a
	inc de
.HandleLoop
	dec c
	jr nz, .CopyByte
	dec b
	jr nz, .CopyByte
	ret

SwapBytes: ; 0x3034
; swap bc bytes between hl and de
.Loop
	; stash [hl] away on the stack
	ld a, [hl]
	push af

	; copy a byte from [de] to [hl]
	ld a, [de]
	ld [hli], a

	; retrieve the previous value of [hl]; put it in [de]
	pop af
	ld [de], a

	; handle loop stuff
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .Loop
	ret

ByteFill: ; 0x3041
; fill bc bytes with the value of a, starting at hl
	inc b  ; we bail the moment b hits 0, so include the last run
	inc c  ; same thing; include last byte
	jr .HandleLoop
.PutByte
	ld [hli], a
.HandleLoop
	dec c
	jr nz, .PutByte
	dec b
	jr nz, .PutByte
	ret

GetFarByte: ; 0x304d
; retrieve a single byte from a:hl, and return it in a.
	; bankswitch to new bank
	ld [hBuffer], a
	ld a, [hROMBank]
	push af
	ld a, [hBuffer]
	rst Bankswitch

	; get byte from new bank
	ld a, [hl]
	ld [hBuffer], a

	; bankswitch to previous bank
	pop af
	rst Bankswitch

	; return retrieved value in a
	ld a, [hBuffer]
	ret

GetFarHalfword: ; 0x305d
; retrieve a halfword from a:hl, and return it in hl.
	; bankswitch to new bank
	ld [hBuffer], a
	ld a, [hROMBank]
	push af
	ld a, [hBuffer]
	rst Bankswitch

	; get halfword from new bank, put it in hl
	ld a, [hli]
	ld h, [hl]
	ld l, a

	; bankswitch to previous bank and return
	pop af
	rst Bankswitch
	ret
; 0x306b

Function306b: ; 306b
	ld [hBuffer], a
	ld a, [rSVBK]
	push af
	ld a, [hBuffer]
	ld [rSVBK], a
	call CopyBytes
	pop af
	ld [rSVBK], a
	ret
; 307b

Function307b: ; 307b
	ld [hBuffer], a
	ld a, [rSVBK]
	push af
	ld a, [hBuffer]
	ld [rSVBK], a
	ld a, [hl]
	ld [hBuffer], a
	pop af
	ld [rSVBK], a
	ld a, [hBuffer]
	ret
; 308d

Function308d: ; 308d
	ld [hBuffer], a
	ld a, [rSVBK]
	push af
	ld a, [hBuffer]
	ld [rSVBK], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	ld [rSVBK], a
	ret
; 309d

Function309d: ; 309d
	ld a, [rSVBK]
	push af
	ld a, $2
	ld [rSVBK], a
	ld hl, TileMap
	ld de, $d000
	ld bc, $0168
	call CopyBytes
	pop af
	ld [rSVBK], a
	ret
; 30b4

Function30b4: ; 30b4
	xor a
	ld [hBGMapMode], a
	call Function30bf
	ld a, $1
	ld [hBGMapMode], a
	ret
; 30bf

Function30bf: ; 30bf
	ld a, [rSVBK]
	push af
	ld a, $2
	ld [rSVBK], a
	ld hl, $d000
	ld de, TileMap
	ld bc, $0168
	call CopyBytes
	pop af
	ld [rSVBK], a
	ret
; 30d6


CopyName1: ; 30d6
	ld hl, StringBuffer2
; 30d9
CopyName2: ; 30d9
.loop
	ld a, [de]
	inc de
	ld [hli], a
	cp "@"
	jr nz, .loop
	ret
; 30e1

IsInArray: ; 30e1
; searches an array at hl for the value in a.
; skips (de - 1) bytes between reads, so to check every byte, de should be 1.
; if found, returns count in b and sets carry.
	ld b,0
	ld c,a
.loop
	ld a,[hl]
	cp a, $FF
	jr z,.NotInArray
	cp c
	jr z,.InArray
	inc b
	add hl,de
	jr .loop
.NotInArray
	and a
	ret
.InArray
	scf
	ret
; 0x30f4

SkipNames: ; 0x30f4
; skips n names where n = a
	ld bc, $000b ; name length
	and a
	ret z
.loop
	add hl, bc
	dec a
	jr nz, .loop
	ret
; 0x30fe

AddNTimes: ; 0x30fe
; adds bc n times where n = a
	and a
	ret z
.loop
	add hl, bc
	dec a
	jr nz, .loop
	ret
; 0x3105


SimpleMultiply: ; 3105
; Return a * c.
	and a
	ret z

	push bc
	ld b, a
	xor a
.loop
	add c
	dec b
	jr nz, .loop
	pop bc
	ret
; 3110


SimpleDivide: ; 3110
; Divide a by c. Return quotient b and remainder a.
	ld b, 0
.loop
	inc b
	sub c
	jr nc, .loop
	dec b
	add c
	ret
; 3119


Multiply: ; 3119
; Multiply hMultiplicand (3 bytes) by hMultiplier. Result in hProduct.
; All values are big endian.
	push hl
	push bc

	callab _Multiply

	pop bc
	pop hl
	ret
; 3124


Divide: ; 3124
; Divide hDividend length b (max 4 bytes) by hDivisor. Result in hQuotient.
; All values are big endian.
	push hl
	push de
	push bc
	ld a, [hROMBank]
	push af
	ld a, BANK(_Divide)
	rst Bankswitch

	call _Divide

	pop af
	rst Bankswitch
	pop bc
	pop de
	pop hl
	ret
; 3136


SubtractSigned: ; 3136
; Return a - b, sign in carry.
	sub b
	ret nc
	cpl
	add 1
	scf
	ret
; 313d


PrintLetterDelay: ; 313d
; wait some frames before printing the next letter
; the text speed setting in Options is actually a frame count
; 	fast: 1 frame
; 	mid:  3 frames
; 	slow: 5 frames
; $cfcf[!0] and A or B override text speed with a one-frame delay
; Options[4] and $cfcf[!1] disable the delay

; delay off?
	ld a, [Options]
	bit 4, a ; delay off
	ret nz
	
; non-scrolling text?
	ld a, [$cfcf]
	bit 1, a
	ret z
	
	push hl
	push de
	push bc
	
; save oam update status
	ld hl, hOAMUpdate
	ld a, [hl]
	push af
; orginally turned oam update off, commented out
;	ld a, 1
	ld [hl], a
	
; force fast scroll?
	ld a, [$cfcf]
	bit 0, a
	jr z, .fast
	
; text speed
	ld a, [Options]
	and a, %111 ; # frames to delay
	jr .updatedelay
	
.fast
	ld a, 1
.updatedelay
	ld [TextDelayFrames], a
	
.checkjoypad
	call GetJoypadPublic
	
; input override
	ld a, [$c2d7]
	and a
	jr nz, .wait
	
; wait one frame if holding a
	ld a, [hJoyDown] ; joypad
	bit 0, a ; A
	jr z, .checkb
	jr .delay
	
.checkb
; wait one frame if holding b
	bit 1, a ; B
	jr z, .wait
	
.delay
	call DelayFrame
	jr .end
	
.wait
; wait until frame counter hits 0 or the loop is broken
; this is a bad way to do this
	ld a, [TextDelayFrames]
	and a
	jr nz, .checkjoypad
	
.end
; restore oam update flag (not touched in this fn anymore)
	pop af
	ld [hOAMUpdate], a
	pop bc
	pop de
	pop hl
	ret
; 318c

CopyDataUntil: ; 318c
; Copies [hl, bc) to [de, bc - hl).
; In other words, the source data is from hl up to but not including bc,
; and the destination is de.
	ld a, [hli]
	ld [de], a
	inc de
	ld a, h
	cp b
	jr nz, CopyDataUntil
	ld a, l
	cp c
	jr nz, CopyDataUntil
	ret
; 0x3198

PrintNum: ; 3198
	ld a, [hROMBank]
	push af
	ld a, BANK(_PrintNum)
	rst Bankswitch
	call _PrintNum
	pop af
	rst Bankswitch
	ret
; 31a4


Function31a4: ; 31a4
	ld a, [hROMBank]
	push af
	ld a, $41
	rst Bankswitch

	call $61ef
	pop af
	rst Bankswitch

	ret
; 31b0


Function31b0: ; 31b0
	ld [hBuffer], a
	ld a, [hROMBank]
	push af
	ld a, [hBuffer]
	rst Bankswitch

	call PrintText
	pop af
	rst Bankswitch

	ret
; 31be

Function31be: ; 31be
	ld a, [hROMBank]
	push af
	ld a, [hli]
	rst Bankswitch

	ld a, [hli]
	ld h, [hl]
	ld l, a

	call _hl_

	pop hl
	ld a, h
	rst Bankswitch
	ret
; 31cd

Function31cd: ; 31cd
	ld a, [hROMBank]

Function31cf: ; 31cf
	ld [$d0e8], a
	ld a, l
	ld [$d0e9], a
	ld a, h
	ld [$d0ea], a
	ret
; 31db


StringCmp: ; 31db
; Compare strings, c bytes in length, at de and hl.
; Often used to compare big endian numbers in battle calculations.
	ld a, [de]
	cp [hl]
	ret nz
	inc de
	inc hl
	dec c
	jr nz, StringCmp
	ret
; 0x31e4


CompareLong: ; 31e4
; Compare bc bytes at de and hl. Return carry if they all match.

	ld a, [de]
	cp [hl]
	jr nz, .Diff

	inc de
	inc hl
	dec bc

	ld a, b
	or c
	jr nz, CompareLong

	scf
	ret

.Diff
	and a
	ret
; 31f3


WhiteBGMap: ; 31f3
	call ClearPalettes
WaitBGMap: ; 31f6
; Tell VBlank to update BG Map
	ld a, 1 ; BG Map 0 tiles
	ld [hBGMapMode], a
; Wait for it to do its magic
	ld c, 4
	call DelayFrames
	ret
; 3200

Function3200: ; 0x3200
	ld a, [hCGB]
	and a
	jr z, .asm_320e
	ld a, $2
	ld [hBGMapMode], a
	ld c, $4
	call DelayFrames

.asm_320e
	ld a, $1
	ld [hBGMapMode], a
	ld c, $4
	call DelayFrames
	ret
; 0x3218


Function3218: ; 3218
	ld a, [hCGB]
	and a
	ret
; 321c


Function321c: ; 321c
	ld a, [hCGB]
	and a
	jr z, .asm_322e
	ld a, [$c2ce]
	cp 0
	jr z, .asm_322e
	ld a, 1
	ld [hBGMapMode], a
	jr Function323d

.asm_322e
	ld a, 1
	ld [hBGMapMode], a
	ld c, 4
	call DelayFrames
	ret
; 3238

Function3238: ; 3238
	ld a, [hCGB]
	and a
	jr z, WaitBGMap

Function323d: ; 323d
	jr Function3246
; 323f

Function323f: ; 323f
	callba Function104000
	ret
; 3246

Function3246: ; 3246
	ld a, [hBGMapMode]
	push af
	xor a
	ld [hBGMapMode], a
	ld a, [$ffde]
	push af
	xor a
	ld [$ffde], a
.asm_3252
	ld a, [rLY]
	cp $7f
	jr c, .asm_3252 ; 3256 $fa
	di
	ld a, $1
	ld [rVBK], a
	ld hl, AttrMap
	call Function327b
	ld a, $0
	ld [rVBK], a
	ld hl, TileMap
	call Function327b
.asm_326d
	ld a, [rLY]
	cp $7f
	jr c, .asm_326d ; 3271 $fa
	ei
	pop af
	ld [$ffde], a
	pop af
	ld [hBGMapMode], a
	ret
; 327b

Function327b: ; 327b
	ld [hSPBuffer], sp
	ld sp, hl
	ld a, [$ffd7]
	ld h, a
	ld l, $0
	ld a, $12
	ld [$ffd3], a
	ld b, $2
	ld c, $41
.asm_328c
	pop de

rept 9
.loop\@
	ld a, [$ff00+c]
	and b
	jr nz, .loop\@
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
endr

.asm_32de
	ld a, [$ff00+c]
	and b
	jr nz, .asm_32de
	ld [hl], e
	inc l
	ld [hl], d
	inc l

	ld de, $000c
	add hl, de
	ld a, [$ffd3]
	dec a
	ld [$ffd3], a
	jr nz, .asm_328c
	ld a, [hSPBuffer]
	ld l, a
	ld a, [$ffda]
	ld h, a
	ld sp, hl
	ret
; 32f9



Function32f9: ; 32f9
	ld a, [hCGB]
	and a
	jr nz, .asm_3309
	ld a, $e4
	ld [rBGP], a
	ld a, $d0
	ld [rOBP0], a
	ld [rOBP1], a
	ret

.asm_3309
	push de
	ld a, $e4
	call DmgToCgbBGPals
	ld de, $e4e4
	call DmgToCgbObjPals
	pop de
	ret
; 3317


ClearPalettes: ; 3317
; Make all palettes white

; For CGB we make all the palette colors white
	ld a, [hCGB]
	and a
	jr nz, .cgb
	
; In DMG mode, we can just change palettes to 0 (white)
	xor a
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a
	ret
	
.cgb
; Save WRAM bank
	ld a, [rSVBK]
	push af
; WRAM bank 5
	ld a, 5
	ld [rSVBK], a
; Fill BGPals and OBPals with $ffff (white)
	ld hl, BGPals
	ld bc, $0080
	ld a, $ff
	call ByteFill
; Restore WRAM bank
	pop af
	ld [rSVBK], a
; Request palette update
	ld a, 1
	ld [hCGBPalUpdate], a
	ret
; 333e

ClearSGB: ; 333e
	ld b, $ff
GetSGBLayout: ; 3340
; load sgb packets unless dmg

; check cgb
	ld a, [hCGB]
	and a
	jr nz, .dosgb
	
; check sgb
	ld a, [hSGB]
	and a
	ret z
	
.dosgb
	ld a, $31 ; LoadSGBLayout
	jp Predef
; 334e


SetHPPal: ; 334e
; Set palette for hp bar pixel length e at hl.
	call GetHPPal
	ld [hl], d
	ret
; 3353


GetHPPal: ; 3353
; Get palette for hp bar pixel length e in d.

	ld d, 0 ; green
	ld a, e
	cp 24
	ret nc
	inc d ; yellow
	cp 10
	ret nc
	inc d ; red
	ret
; 335f


CountSetBits: ; 0x335f
; function to count how many bits are set in a string of bytes
; INPUT:
; hl = address of string of bytes
; b = length of string of bytes
; OUTPUT:
; [$d265] = number of set bits
	ld c, $0
.loop
	ld a, [hli]
	ld e, a
	ld d, $8
.innerLoop ; count how many bits are set in the current byte
	srl e
	ld a, $0
	adc c
	ld c, a
	dec d
	jr nz, .innerLoop
	dec b
	jr nz, .loop
	ld a, c
	ld [$d265], a
	ret
; 0x3376


GetWeekday: ; 3376
	ld a, [CurDay]
.loop
	sub 7
	jr nc, .loop
	add 7
	ret
; 3380


SetSeenAndCaughtMon: ; 3380
	push af
	ld c, a
	ld hl, PokedexSeen
	ld b, 1
	call GetWramFlag
	pop af
	; fallthrough
; 338b

SetCaughtMon: ; 338b
	ld c, a
	ld hl, PokedexCaught
	ld b, 1
	jr GetWramFlag
; 3393

CheckSeenMon: ; 3393
	ld c, a
	ld hl, PokedexSeen
	ld b, 2
	jr GetWramFlag
; 339b

CheckCaughtMon: ; 339b
	ld c, a
	ld hl, PokedexCaught
	ld b, 2
	; fallthrough
; 33a1

GetWramFlag: ; 33a1
	ld d, 0
	ld a, PREDEF_FLAG
	call Predef

	ld a, c
	and a
	ret
; 33ab


NamesPointerTable: ; 33ab
	dbw BANK(PokemonNames), PokemonNames
	dbw BANK(MoveNames), MoveNames
	dbw $00, $0000
	dbw BANK(ItemNames), ItemNames
	dbw $00, PartyMonOT
	dbw $00, OTPartyMonOT
	dbw BANK(TrainerClassNames), TrainerClassNames
	dbw $04, $4b52
; 33c3


GetName: ; 33c3
; Return name CurSpecies from name list $cf61 in StringBuffer1.
	ld a, [hROMBank]
	push af
	push hl
	push bc
	push de
	ld a, [$cf61]
	cp 1 ; Pokemon names
	jr nz, .NotPokeName

	ld a, [CurSpecies]
	ld [$d265], a
	call GetPokemonName
	ld hl, $000b
	add hl, de
	ld e, l
	ld d, h
	jr .done

.NotPokeName
	ld a, [$cf61]
	dec a
	ld e, a
	ld d, 0
	ld hl, NamesPointerTable
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	rst Bankswitch
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [CurSpecies]
	dec a
	call GetNthString

	ld de, StringBuffer1
	ld bc, $000d
	call CopyBytes

.done
	ld a, e
	ld [$d102], a
	ld a, d
	ld [$d103], a
	pop de
	pop bc
	pop hl
	pop af
	rst Bankswitch
	ret
; 3411


GetNthString: ; 3411
; Starting at hl, this function returns the start address of the ath string.
	and a
	ret z
	push bc
	ld b, a
	ld c, "@"
.readChar
	ld a, [hli]
	cp c
	jr nz, .readChar
	dec b
	jr nz, .readChar
	pop bc
	ret
; 3420


GetBasePokemonName: ; 3420
; Discards gender (Nidoran).
	push hl
	call GetPokemonName

	ld hl, StringBuffer1
.loop
	ld a, [hl]
	cp "@"
	jr z, .quit
	cp "♂"
	jr z, .end
	cp "♀"
	jr z, .end
	inc hl
	jr .loop
.end
	ld [hl], "@"
.quit
	pop hl
	ret

; 343b


GetPokemonName: ; 343b
; Get Pokemon name $d265.

	ld a, [hROMBank]
	push af
	push hl
	ld a, BANK(PokemonNames)
	rst Bankswitch

; Each name is ten characters
	ld a, [$d265]
	dec a
	ld d, 0
	ld e, a
	ld h, 0
	ld l, a
	add hl, hl
	add hl, hl
	add hl, de
	add hl, hl
	ld de, PokemonNames
	add hl, de

; Terminator
	ld de, StringBuffer1
	push de
	ld bc, PKMN_NAME_LENGTH - 1
	call CopyBytes
	ld hl, StringBuffer1 + PKMN_NAME_LENGTH - 1
	ld [hl], "@"
	pop de

	pop hl
	pop af
	rst Bankswitch
	ret
; 3468


GetItemName: ; 3468
; Get item name $d265.

	push hl
	push bc
	ld a, [$d265]

	cp TM_01
	jr nc, .TM

	ld [CurSpecies], a
	ld a, 4 ; Item names
	ld [$cf61], a
	call GetName
	jr .Copied
.TM
	call GetTMHMName
.Copied
	ld de, StringBuffer1
	pop bc
	pop hl
	ret
; 3487


GetTMHMName: ; 3487
; Get TM/HM name by item id $d265.

	push hl
	push de
	push bc
	ld a, [$d265]
	push af

; TM/HM prefix
	cp HM_01
	push af
	jr c, .TM

	ld hl, .HMText
	ld bc, .HMTextEnd - .HMText
	jr .asm_34a1

.TM
	ld hl, .TMText
	ld bc, .TMTextEnd - .TMText

.asm_34a1
	ld de, StringBuffer1
	call CopyBytes

; TM/HM number
	push de
	ld a, [$d265]
	ld c, a
	callab GetTMHMNumber
	pop de

; HM numbers start from 51, not 1
	pop af
	ld a, c
	jr c, .asm_34b9
	sub NUM_TMS

; Divide and mod by 10 to get the top and bottom digits respectively
.asm_34b9
	ld b, "0"
.mod10
	sub 10
	jr c, .asm_34c2
	inc b
	jr .mod10
.asm_34c2
	add 10

	push af
	ld a, b
	ld [de], a
	inc de
	pop af

	ld b, "0"
	add b
	ld [de], a

; End the string
	inc de
	ld a, "@"
	ld [de], a

	pop af
	ld [$d265], a
	pop bc
	pop de
	pop hl
	ret

.TMText
	db "TM"
.TMTextEnd
	db "@"

.HMText
	db "HM"
.HMTextEnd
	db "@"
; 34df


IsHM: ; 34df
	cp HM_01
	jr c, .NotHM
	scf
	ret
.NotHM
	and a
	ret
; 34e7


IsHMMove: ; 34e7
	ld hl, .HMMoves
	ld de, 1
	jp IsInArray

.HMMoves
	db CUT
	db FLY
	db SURF
	db STRENGTH
	db FLASH
	db WATERFALL
	db WHIRLPOOL
	db $ff
; 34f8


GetMoveName: ; 34f8
	push hl
; move name
	ld a, $2 ; move names
	ld [$cf61], a
; move id
	ld a, [$d265]
	ld [CurSpecies], a

	call GetName
	ld de, StringBuffer1
	pop hl
	ret
; 350c


Function350c: ; 350c
	call Function1c66
	ld a, [hROMBank]
	push af
	ld a, $9
	rst Bankswitch

	call $45af
	call Function3524
	call $45cb
	pop af
	rst Bankswitch

	ld a, [$cf73]
	ret
; 3524

Function3524: ; 3524
	ld hl, VramState
	bit 0, [hl]
	jp nz, UpdateTimePals
	jp Function32f9
; 352f

Function352f: ; 352f
	ld a, [$cf82]
	dec a
	ld b, a
	ld a, [$cf84]
	sub b
	ld d, a
	ld a, [$cf83]
	dec a
	ld c, a
	ld a, [$cf85]
	sub c
	ld e, a
	push de
	call Function1d05
	pop bc
	jp TextBox
; 354b

Function354b: ; 354b
	call DelayFrame
	ld a, [$ffaa]
	push af
	ld a, $1
	ld [$ffaa], a
	call Functiona57
	pop af
	ld [$ffaa], a
	ld a, [$ffa9]
	and $f0
	ld c, a
	ld a, [hJoyPressed]
	and $f
	or c
	ld c, a
	ret
; 3567


Function3567: ; 3567
	ld a, [hROMBank]
	push af
	call Function2c52
	call Function3574
	pop bc
	ld a, b
	rst Bankswitch

	ret
; 3574

Function3574: ; 3574
	ld hl, $0001
	add hl, de
	ld a, [hl]
	cp $ff
	jr z, .asm_3597
	ld l, a
	push hl
	call Function3599
	pop hl
	jr nc, .asm_3597
	ld d, a
	ld e, l
	call Function35de
	jr nc, .asm_3597
	call Function2631
	callba Function96c56
	scf
	ret

.asm_3597
	and a
	ret
; 3599

Function3599: ; 3599
	push de
	ld hl, $0010
	add hl, de
	ld a, [hl]
	ld hl, $0011
	add hl, de
	ld e, [hl]
	sub $4
	ld d, a
	ld a, e
	sub $4
	ld e, a
	call Function35b0
	pop de
	ret
; 35b0

Function35b0: ; 35b0
	ld hl, $dbfc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [$dbfb]
	and a
	jr z, .asm_35d3
.asm_35bc
	push af
	ld a, [hl]
	cp e
	jr nz, .asm_35c8
	inc hl
	ld a, [hld]
	cp d
	jr nz, .asm_35c8
	jr .asm_35d5

.asm_35c8
	ld a, $5
	add l
	ld l, a
	jr nc, .asm_35cf
	inc h

.asm_35cf
	pop af
	dec a
	jr nz, .asm_35bc

.asm_35d3
	and a
	ret

.asm_35d5
	pop af
	ld d, a
	ld a, [$dbfb]
	sub d
	inc a
	scf
	ret
; 35de

Function35de: ; 35de
	inc e
	ld hl, $0001
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.asm_35e6
	ld a, [hli]
	cp $ff
	jr z, .asm_35fc
	cp d
	jr nz, .asm_35f7
	ld a, [hli]
	cp e
	jr nz, .asm_35f8
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jr .asm_35fe

.asm_35f7
	inc hl

.asm_35f8
	inc hl
	inc hl
	jr .asm_35e6

.asm_35fc
	and a
	ret

.asm_35fe
	scf
	ret
; 3600


CheckTrainerBattle2: ; 3600

	ld a, [hROMBank]
	push af
	call Function2c52

	call CheckTrainerBattle

	pop bc
	ld a, b
	rst Bankswitch
	ret
; 360d


CheckTrainerBattle: ; 360d
; Check if any trainer on the map sees the player and wants to battle.

; Skip the player object.
	ld a, 1
	ld de, MapObjects + OBJECT_LENGTH

.loop

; Start a battle if the object:

	push af
	push de

; Has a sprite
	ld hl, $0001
	add hl, de
	ld a, [hl]
	and a
	jr z, .next

; Is a trainer
	ld hl, $0008
	add hl, de
	ld a, [hl]
	and $f
	cp $2
	jr nz, .next

; Is visible on the map
	ld hl, $0000
	add hl, de
	ld a, [hl]
	cp $ff
	jr z, .next

; Is facing the player...
	call Function1ae5
	call FacingPlayerDistance_bc
	jr nc, .next

; ...within their sight range
	ld hl, $0009
	add hl, de
	ld a, [hl]
	cp b
	jr c, .next

; And hasn't already been beaten
	push bc
	push de
	ld hl, $000a
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	pop de
	pop bc
	and a
	jr z, .asm_3666

.next
	pop de
	ld hl, OBJECT_LENGTH
	add hl, de
	ld d, h
	ld e, l

	pop af
	inc a
	cp NUM_OBJECTS
	jr nz, .loop
	xor a
	ret

.asm_3666
	pop de
	pop af
	ld [$ffe0], a
	ld a, b
	ld [CurFruit], a
	ld a, c
	ld [MartPointer], a
	jr Function367e
; 3674

Function3674: ; 3674
	ld a, $1
	ld [CurFruit], a
	ld a, $ff
	ld [MartPointer], a

Function367e: ; 367e
	call GetMapEventBank
	ld [EngineBuffer1], a
	ld a, [$ffe0]
	call GetMapObject
	ld hl, $000a
	add hl, bc
	ld a, [EngineBuffer1]
	call GetFarHalfword
	ld de, $d041
	ld bc, $000d
	ld a, [EngineBuffer1]
	call FarCopyBytes
	xor a
	ld [$d04d], a
	scf
	ret
; 36a5


FacingPlayerDistance_bc: ; 36a5

	push de
	call FacingPlayerDistance
	ld b, d
	ld c, e
	pop de
	ret
; 36ad


FacingPlayerDistance: ; 36ad
; Return carry if the sprite at bc is facing the player,
; and its distance in d.

	ld hl, $0010 ; x
	add hl, bc
	ld d, [hl]

	ld hl, $0011 ; y
	add hl, bc
	ld e, [hl]

	ld a, [MapX]
	cp d
	jr z, .CheckY

	ld a, [MapY]
	cp e
	jr z, .CheckX

	and a
	ret

.CheckY
	ld a, [MapY]
	sub e
	jr z, .NotFacing
	jr nc, .Above

; Below
	cpl
	inc a
	ld d, a
	ld e, UP << 2
	jr .CheckFacing

.Above
	ld d, a
	ld e, DOWN << 2
	jr .CheckFacing

.CheckX
	ld a, [MapX]
	sub d
	jr z, .NotFacing
	jr nc, .Left

; Right
	cpl
	inc a
	ld d, a
	ld e, LEFT << 2
	jr .CheckFacing

.Left
	ld d, a
	ld e, RIGHT << 2

.CheckFacing
	call GetSpriteDirection
	cp e
	jr nz, .NotFacing
	scf
	ret

.NotFacing
	and a
	ret
; 36f5


Function36f5: ; 36f5
	push bc
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	call GetMapObject
	ld hl, $000a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetMapEventBank
	call GetFarHalfword
	ld d, h
	ld e, l
	push de
	ld b, $2
	call EventFlagAction
	pop de
	ld a, c
	and a
	pop bc
	ret
; 3718


Function3718: ; 3718
	ld a, [BattleType]
	cp $1
	jr .asm_3724

	ld hl, WalkingTile
	jr .asm_3731

.asm_3724
	ld a, [$d0ee]
	ld hl, WalkingTile
	and $f
	jr z, .asm_3731
	ld hl, $d049

.asm_3731
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetMapEventBank
	call Function31b0
	call WaitBGMap
	call Functiona80
	ret
; 3741



IsAPokemon: ; 3741
; Return carry if species a is not a Pokemon.
	and a
	jr z, .NotAPokemon
	cp EGG
	jr z, .Pokemon
	cp NUM_POKEMON + 1
	jr c, .Pokemon

.NotAPokemon
	scf
	ret

.Pokemon
	and a
	ret
; 3750


DrawHPBar: ; 3750
; Draw an HP bar d tiles long at hl
; Fill it up to e pixels

	push hl
	push de
	push bc

; Place 'HP:'
	ld a, $60
	ld [hli], a
	ld a, $61
	ld [hli], a

; Draw a template
	push hl
	ld a, $62 ; empty bar
.template
	ld [hli], a
	dec d
	jr nz, .template
	ld a, $6b ; bar end
	add b
	ld [hl], a
	pop hl

; Safety check # pixels
	ld a, e
	and a
	jr nz, .fill
	ld a, c
	and a
	jr z, .done
	ld e, 1

.fill
; Keep drawing tiles until pixel length is reached
	ld a, e
	sub TILE_WIDTH
	jr c, .lastbar

	ld e, a
	ld a, $6a ; full bar
	ld [hli], a
	ld a, e
	and a
	jr z, .done
	jr .fill

.lastbar
	ld a, $62  ; empty bar
	add e      ; + e
	ld [hl], a

.done
	pop bc
	pop de
	pop hl
	ret
; 3786


Function3786: ; 3786
	ld a, $1
	ld [$c2c6], a

Function378b: ; 378b
	ld a, [CurPartySpecies]
	call IsAPokemon
	jr c, .asm_37ad
	push hl
	ld de, VTiles2
	ld a, $3c
	call Predef
	pop hl
	xor a
	ld [$ffad], a
	ld bc, $0707
	ld a, $13
	call Predef
	xor a
	ld [$c2c6], a
	ret

.asm_37ad
	xor a
	ld [$c2c6], a
	inc a
	ld [CurPartySpecies], a
	ret
; 37b6

Function37b6: ; 37b6
	push af
	ld a, $1
	ld [$c2bc], a
	pop af
	call Function37e2
	call WaitSFX
	ret
; 37c4

Function37c4: ; 37c4
	push af
	ld a, $1
	ld [$c2bc], a
	pop af
	jp Function37e2
; 37ce

Function37ce: ; 37ce
	call Function37d5
	call WaitSFX
	ret
; 37d5

Function37d5: ; 37d5
	push af
	xor a
	ld [$c2bc], a
	ld [CryTracks], a
	pop af
	call Function37e2
	ret
; 37e2

Function37e2: ; 37e2
	push hl
	push de
	push bc
	call Function381e
	jr c, .asm_37ef
	ld e, c
	ld d, b
	call PlayCryHeader

.asm_37ef
	pop bc
	pop de
	pop hl
	ret
; 37f3

Function37f3: ; 37f3
	call Function381e
	ret c
	ld a, [hROMBank]
	push af
	ld a, $3c
	rst Bankswitch

	ld hl, $6787
	add hl, bc
	add hl, bc
	add hl, bc
	add hl, bc
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hli]
	ld [CryPitch], a
	ld a, [hli]
	ld [CryEcho], a
	ld a, [hli]
	ld [CryLength], a
	ld a, [hl]
	ld [$c2b3], a
	pop af
	rst Bankswitch

	and a
	ret
; 381e

Function381e: ; 381e
	and a
	jr z, .asm_382b
	cp $fc
	jr nc, .asm_382b
	dec a
	ld c, a
	ld b, $0
	and a
	ret

.asm_382b
	scf
	ret
; 382d


PrintLevel: ; 382d
; Print TempMonLevel at hl

	ld a, [TempMonLevel]
	ld [hl], $6e ; ":L"
	inc hl

; How many digits?
	ld c, 2
	cp 100
	jr c, Function3842

; 3-digit numbers overwrite the :L.
	dec hl
	inc c
	jr Function3842
; 383d

Function383d: ; 383d
; Print :L and all 3 digits
	ld [hl], $6e
	inc hl
	ld c, 3
; 3842

Function3842: ; 3842
	ld [$d265], a
	ld de, $d265
	ld b,  %01000001 ; flags
	jp PrintNum
; 384d


Function384d: ; 384d
	ld hl, $d25e
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	ret
; 3856


GetBaseData: ; 3856
	push bc
	push de
	push hl
	ld a, [hROMBank]
	push af
	ld a, BANK(BaseData)
	rst Bankswitch
	
; Egg doesn't have BaseData
	ld a, [CurSpecies]
	cp EGG
	jr z, .egg

; Get BaseData
	dec a
	ld bc, BaseData1 - BaseData0
	ld hl, BaseData
	call AddNTimes
	ld de, CurBaseData
	ld bc, BaseData1 - BaseData0
	call CopyBytes
	jr .end
	
.egg
; ????
	ld de, $7d9c
	
; Sprite dimensions
	ld b, $55 ; 5x5
	ld hl, BasePicSize
	ld [hl], b
	
; ????
	ld hl, BasePadding
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	jr .end
	
.end
; Replace Pokedex # with species
	ld a, [CurSpecies]
	ld [BaseDexNo], a
	
	pop af
	rst Bankswitch
	pop hl
	pop de
	pop bc
	ret
; 389c


GetCurNick: ; 389c
	ld a, [CurPartyMon]
	ld hl, PartyMonNicknames

GetNick: ; 38a2
; Get nickname a from list hl.

	push hl
	push bc

	call SkipNames
	ld de, StringBuffer1

	push de
	ld bc, PKMN_NAME_LENGTH
	call CopyBytes
	pop de

	callab CheckNickErrors

	pop bc
	pop hl
	ret
; 38bb


PrintBCDNumber: ; 38bb
; function to print a BCD (Binary-coded decimal) number
; de = address of BCD number
; hl = destination address
; c = flags and length
; bit 7: if set, do not print leading zeroes
;        if unset, print leading zeroes
; bit 6: if set, left-align the string (do not pad empty digits with spaces)
;        if unset, right-align the string
; bit 5: if set, print currency symbol at the beginning of the string
;        if unset, do not print the currency symbol
; bits 0-4: length of BCD number in bytes
; Note that bits 5 and 7 are modified during execution. The above reflects
; their meaning at the beginning of the functions's execution.
	ld b, c ; save flags in b
	res 7, c
	res 6, c
	res 5, c ; c now holds the length
	bit 5, b
	jr z, .loop
	bit 7, b
	jr nz, .loop
	ld [hl], "¥"
	inc hl
.loop
	ld a, [de]
	swap a
	call PrintBCDDigit ; print upper digit
	ld a, [de]
	call PrintBCDDigit ; print lower digit
	inc de
	dec c
	jr nz, .loop
	bit 7, b ; were any non-zero digits printed?
	jr z, .done ; if so, we are done
.numberEqualsZero ; if every digit of the BCD number is zero
	bit 6, b ; left or right alignment?
	jr nz, .skipRightAlignmentAdjustment
	dec hl ; if the string is right-aligned, it needs to be moved back one space
.skipRightAlignmentAdjustment
	bit 5, b
	jr z, .skipCurrencySymbol
	ld [hl], "¥" ; currency symbol
	inc hl
.skipCurrencySymbol
	ld [hl], "0"
	call PrintLetterDelay
	inc hl
.done
	ret
; 0x38f2

PrintBCDDigit: ; 38f2
	and a, %00001111
	and a
	jr z, .zeroDigit
.nonzeroDigit
	bit 7, b ; have any non-space characters been printed?
	jr z, .outputDigit
; if bit 7 is set, then no numbers have been printed yet
	bit 5, b ; print the currency symbol?
	jr z, .skipCurrencySymbol
	ld [hl], "¥"
	inc hl
	res 5, b
.skipCurrencySymbol
	res 7, b ; unset 7 to indicate that a nonzero digit has been reached
.outputDigit
	add a, "0"
	ld [hli], a
	jp PrintLetterDelay
.zeroDigit
	bit 7, b ; either printing leading zeroes or already reached a nonzero digit?
	jr z, .outputDigit ; if so, print a zero digit
	bit 6, b ; left or right alignment?
	ret nz
	ld a, " "
	ld [hli], a ; if right-aligned, "print" a space by advancing the pointer
	ret
; 0x3917

GetPartyParamLocation: ; 3917
; Get the location of parameter a from CurPartyMon in hl
	push bc
	ld hl, PartyMons
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [CurPartyMon]
	call GetPartyLocation
	pop bc
	ret
; 3927

GetPartyLocation: ; 3927
; Add the length of a PartyMon struct to hl a times.
	ld bc, PartyMon2 - PartyMon1
	jp AddNTimes
; 392d


Function392d: ; 392d
	push hl
	ld a, b
	dec a
	ld b, $0
	add hl, bc
	ld hl, $5424
	ld bc, $0020
	call AddNTimes
	ld a, $14
	call GetFarHalfword
	ld b, l
	ld c, h
	pop hl
	ret
; 3945


UserPartyAttr: ; 3945
	push af
	ld a, [hBattleTurn]
	and a
	jr nz, .asm_394e
	pop af
	jr BattlePartyAttr
.asm_394e
	pop af
	jr OTPartyAttr
; 3951


OpponentPartyAttr: ; 3951
	push af
	ld a, [hBattleTurn]
	and a
	jr z, .asm_395a
	pop af
	jr BattlePartyAttr
.asm_395a
	pop af
	jr OTPartyAttr
; 395d


BattlePartyAttr: ; 395d
; Get attribute a from the active BattleMon's party struct.
	push bc
	ld c, a
	ld b, 0
	ld hl, PartyMons
	add hl, bc
	ld a, [CurBattleMon]
	call GetPartyLocation
	pop bc
	ret
; 396d


OTPartyAttr: ; 396d
; Get attribute a from the active EnemyMon's party struct.
	push bc
	ld c, a
	ld b, 0
	ld hl, OTPartyMon1Species
	add hl, bc
	ld a, [CurOTMon]
	call GetPartyLocation
	pop bc
	ret
; 397d


ResetDamage: ; 397d
	xor a
	ld [CurDamage], a
	ld [CurDamage + 1], a
	ret
; 3985

SetPlayerTurn: ; 3985
	xor a
	ld [hBattleTurn], a
	ret
; 3989

SetEnemyTurn: ; 3989
	ld a, 1
	ld [hBattleTurn], a
	ret
; 398e


UpdateOpponentInParty: ; 398e
	ld a, [hBattleTurn]
	and a
	jr z, UpdateEnemyMonInParty
	jr UpdateBattleMonInParty
; 3995

UpdateUserInParty: ; 3995
	ld a, [hBattleTurn]
	and a
	jr z, UpdateBattleMonInParty
	jr UpdateEnemyMonInParty
; 399c

UpdateBattleMonInParty: ; 399c
; Update level, status, current HP

	ld a, [CurBattleMon]

Function399f: ; 399f
	ld hl, PartyMon1Level
	call GetPartyLocation

	ld d, h
	ld e, l
	ld hl, BattleMonLevel
	ld bc, BattleMonMaxHP - BattleMonLevel
	jp CopyBytes
; 39b0

UpdateEnemyMonInParty: ; 39b0
; Update level, status, current HP

; No wildmons.
	ld a, [IsInBattle]
	dec a
	ret z

	ld a, [CurOTMon]
	ld hl, OTPartyMon1Level
	call GetPartyLocation

	ld d, h
	ld e, l
	ld hl, EnemyMonLevel
	ld bc, EnemyMonMaxHP - EnemyMonLevel
	jp CopyBytes
; 39c9


RefreshBattleHuds: ; 39c9
	call UpdateBattleHuds
	ld c, 3
	call DelayFrames
	jp WaitBGMap
; 39d4

UpdateBattleHuds: ; 39d4
	ld a, $f
	ld hl, $5f48
	rst FarCall ; UpdatePlayerHud
	ld a, $f
	ld hl, $6036
	rst FarCall ; UpdateEnemyHud
	ret
; 39e1


CleanGetBattleVarPair: ; 39e1
; Preserves hl.
	push hl
	call GetBattleVarPair
	pop hl
	ret
; 39e7

GetBattleVarPair: ; 39e7
; Get variable from pair a, depending on whose turn it is.
; There are 21 variable pairs.

	push bc
	
; get var pair
	ld hl, .battlevarpairs
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	
	ld a, [hli]
	ld h, [hl]
	ld l, a
	
; Enemy turn uses the second byte instead.
; This lets battle variable calls be side-neutral.
	ld a, [hBattleTurn]
	and a
	jr z, .getvar
	inc hl
	
.getvar
; get var id
	ld a, [hl]
	ld c, a
	ld b, 0
	
; seek
	ld hl, .vars
	add hl, bc
	add hl, bc
	
; get var address
	ld a, [hli]
	ld h, [hl]
	ld l, a
	
	ld a, [hl]
	
	pop bc
	ret


.battlevarpairs
	dw .substatus1         ; 0
	dw .substatus2         ; 1
	dw .substatus3         ; 2
	dw .substatus4         ; 3
	dw .substatus5         ; 4
	dw .substatus1opp      ; 5
	dw .substatus2opp      ; 6
	dw .substatus3opp      ; 7
	dw .substatus4opp      ; 8
	dw .substatus5opp      ; 9
	dw .status             ; a
	dw .statusopp          ; b
	dw .animation          ; c
	dw .effect             ; d
	dw .power              ; e
	dw .type               ; f
	dw .curmove            ; 10
	dw .lastcountermove    ; 11
	dw .lastcountermoveopp ; 12
	dw .lastmove           ; 13
	dw .lastmoveopp        ; 14

	;                  player             enemy
.substatus1
	db $00, $01 ; PLAYER_SUBSTATUS1, ENEMY_SUBSTATUS1
.substatus1opp
	db $01, $00 ; ENEMY_SUBSTATUS1, PLAYER_SUBSTATUS1
.substatus2
	db $02, $03 ; PLAYER_SUBSTATUS2, ENEMY_SUBSTATUS2
.substatus2opp
	db $03, $02 ; ENEMY_SUBSTATUS2, PLAYER_SUBSTATUS2
.substatus3
	db $04, $05 ; PLAYER_SUBSTATUS3, ENEMY_SUBSTATUS3
.substatus3opp
	db $05, $04 ; ENEMY_SUBSTATUS3, PLAYER_SUBSTATUS3
.substatus4
	db $06, $07 ; PLAYER_SUBSTATUS4, ENEMY_SUBSTATUS4
.substatus4opp
	db $07, $06 ; ENEMY_SUBSTATUS4, PLAYER_SUBSTATUS4
.substatus5
	db $08, $09 ; PLAYER_SUBSTATUS5, ENEMY_SUBSTATUS5
.substatus5opp
	db $09, $08 ; ENEMY_SUBSTATUS5, PLAYER_SUBSTATUS5
.status
	db $0a, $0b ; PLAYER_STATUS, ENEMY_STATUS
.statusopp
	db $0b, $0a ; ENEMY_STATUS, PLAYER_STATUS
.animation
	db $0c, $0d ; PLAYER_MOVE_ANIMATION, ENEMY_MOVE_ANIMATION
.effect
	db $0e, $0f ; PLAYER_MOVE_EFFECT, ENEMY_MOVE_EFFECT
.power
	db $10, $11 ; PLAYER_MOVE_POWER, ENEMY_MOVE_POWER
.type
	db $12, $13 ; PLAYER_MOVE_TYPE, ENEMY_MOVE_TYPE
.curmove
	db $14, $15 ; PLAYER_CUR_MOVE, ENEMY_CUR_MOVE
.lastcountermove
	db $16, $17 ; ENEMY_LAST_COUNTER_MOVE, PLAYER_LAST_COUNTER_MOVE
.lastcountermoveopp
	db $17, $16 ; PLAYER_LAST_COUNTER_MOVE, ENEMY_LAST_COUNTER_MOVE
.lastmove
	db $18, $19 ; PLAYER_LAST_MOVE, ENEMY_LAST_MOVE
.lastmoveopp
	db $19, $18 ; ENEMY_LAST_MOVE, PLAYER_LAST_MOVE

.vars
	dw PlayerSubStatus1
	dw EnemySubStatus1
	
	dw PlayerSubStatus2
	dw EnemySubStatus2
	
	dw PlayerSubStatus3
	dw EnemySubStatus3
	
	dw PlayerSubStatus4
	dw EnemySubStatus4
	
	dw PlayerSubStatus5
	dw EnemySubStatus5
	
	dw BattleMonStatus
	dw EnemyMonStatus
	
	dw PlayerMoveAnimation
	dw EnemyMoveAnimation
	
	dw PlayerMoveEffect
	dw EnemyMoveEffect
	
	dw PlayerMovePower
	dw EnemyMovePower
	
	dw PlayerMoveType
	dw EnemyMoveType
	
	dw CurPlayerMove
	dw CurEnemyMove
	
	dw LastEnemyCounterMove
	dw LastPlayerCounterMove
	
	dw LastPlayerMove
	dw LastEnemyMove
; 3a90


Function3a90: ; 3a90
	inc hl
	ld a, [hROMBank]
	push af
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld [hROMBank], a
	ld [MBC3RomBank], a
	ld a, e
	ld l, a
	ld a, d
	ld h, a
	ld de, $d00c
	ld bc, $0028
	call CopyBytes
	pop af
	ld [hROMBank], a
	ld [MBC3RomBank], a
	ret
; 3ab2


MobileTextBorder: ; 3ab2
; For mobile link battles only.
	ld a, [InLinkBattle]
	cp 4
	ret c
; Draw a cell phone icon at the top right corner of the border.
	ld hl, $c5a3 ; TileMap(19,12)
	ld [hl], $5e ; cell phone top
	ld hl, $c5b7 ; TileMap(19,13)
	ld [hl], $5f ; cell phone bottom
	ret
; 3ac3


BattleTextBox: ; 3ac3
; Open a textbox and print text at hl.
	push hl
	call SpeechTextBox
	call MobileTextBorder
	call Function1ad2
	call Function321c
	pop hl
	call PrintTextBoxText
	ret
; 3ad5


StdBattleTextBox: ; 3ad5
; Open a textbox and print battle text at 20:hl.

	ld a, [hROMBank]
	push af

	ld a, BANK(BattleText)
	rst Bankswitch

	call BattleTextBox

	pop af
	rst Bankswitch
	ret
; 3ae1


Function3ae1: ; 3ae1
	ld a, $32
	rst Bankswitch

	ld a, [hli]
	ld [$d410], a
	ld a, [hl]
	ld [$d411], a
	ld a, $33
	rst Bankswitch

	ret
; 3af0

Function3af0: ; 3af0
	push hl
	push de
	ld hl, $d410
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, $32
	rst Bankswitch

	ld a, [de]
	ld [$d417], a
	inc de
	ld a, $33
	rst Bankswitch

	ld [hl], d
	dec hl
	ld [hl], e
	pop de
	pop hl
	ld a, [$d417]
	ret
; 3b0c

Function3b0c: ; 3b0c
	ld a, [hLCDStatCustom]
	and a
	ret z

	ld a, $00
	ld [Requested2bppSource], a
	ld a, $d2
	ld [Requested2bppSource + 1], a

	ld a, $00
	ld [Requested2bppDest], a
	ld a, $d1
	ld [Requested2bppDest + 1], a

	ld a, $9
	ld [Requested2bpp], a
	ret
; 3b2a



Function3b2a: ; 3b2a
	ld [$c3b8], a
	ld a, [hROMBank]
	push af
	ld a, $23
	rst Bankswitch

	ld a, [$c3b8]
	call $4fd6
	pop af
	rst Bankswitch

	ret
; 3b3c


Function3b3c: ; 3b3c
	ld [$c3b8], a
	ld a, [hROMBank]
	push af
	ld a, $23
	rst Bankswitch

	ld a, [$c3b8]
	call $5120
	pop af
	rst Bankswitch

	ret
; 3b4e


CleanSoundRestart: ; 3b4e

	push hl
	push de
	push bc
	push af

	ld a, [hROMBank]
	push af
	ld a, BANK(SoundRestart)
	ld [hROMBank], a
	ld [MBC3RomBank], a

	call SoundRestart

	pop af
	ld [hROMBank], a
	ld [MBC3RomBank], a

	pop af
	pop bc
	pop de
	pop hl
	ret
; 3b6a


CleanUpdateSound: ; 3b6a

	push hl
	push de
	push bc
	push af

	ld a, [hROMBank]
	push af
	ld a, BANK(UpdateSound)
	ld [hROMBank], a
	ld [MBC3RomBank], a

	call UpdateSound

	pop af
	ld [hROMBank], a
	ld [MBC3RomBank], a

	pop af
	pop bc
	pop de
	pop hl
	ret
; 3b86


LoadMusicByte: ; 3b86
; CurMusicByte = [a:de]

	ld [hROMBank], a
	ld [MBC3RomBank], a

	ld a, [de]
	ld [CurMusicByte], a
	ld a, $3a ; manual bank restore

	ld [hROMBank], a
	ld [MBC3RomBank], a
	ret
; 3b97


StartMusic: ; 3b97
; Play music de.

	push hl
	push de
	push bc
	push af

	ld a, [hROMBank]
	push af
	ld a, BANK(LoadMusic) ; and BANK(SoundRestart)
	ld [hROMBank], a
	ld [MBC3RomBank], a

	ld a, e
	and a
	jr z, .nomusic

	call LoadMusic
	jr .end

.nomusic
	call SoundRestart

.end
	pop af
	ld [hROMBank], a
	ld [MBC3RomBank], a
	pop af
	pop bc
	pop de
	pop hl
	ret
; 3bbc


StartMusic2: ; 3bbc
; Stop playing music, then play music de.

	push hl
	push de
	push bc
	push af

	ld a, [hROMBank]
	push af
	ld a, BANK(LoadMusic)
	ld [hROMBank], a
	ld [MBC3RomBank], a

	push de
	ld de, MUSIC_NONE
	call LoadMusic
	call DelayFrame
	pop de
	call LoadMusic

	pop af
	ld [hROMBank], a
	ld [MBC3RomBank], a

	pop af
	pop bc
	pop de
	pop hl
	ret

; 3be3


PlayCryHeader: ; 3be3
; Play a cry given parameters in header de

	push hl
	push de
	push bc
	push af

; Save current bank
	ld a, [hROMBank]
	push af

; Cry headers are stuck in one bank.
	ld a, BANK(CryHeaders)
	ld [hROMBank], a
	ld [MBC3RomBank], a

; Each header is 6 bytes long:
	ld hl, CryHeaders
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	add hl, de

	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl

	ld a, [hli]
	ld [CryPitch], a
	ld a, [hli]
	ld [CryEcho], a
	ld a, [hli]
	ld [CryLength], a
	ld a, [hl]
	ld [CryLength+1], a

	ld a, BANK(PlayCry)
	ld [hROMBank], a
	ld [MBC3RomBank], a

	call PlayCry

	pop af
	ld [hROMBank], a
	ld [MBC3RomBank], a
	
	pop af
	pop bc
	pop de
	pop hl
	ret
; 3c23


StartSFX: ; 3c23
; Play sound effect de.
; Sound effects are ordered by priority (lowest to highest)

	push hl
	push de
	push bc
	push af

; Is something already playing?
	call CheckSFX
	jr nc, .play
; Does it have priority?
	ld a, [CurSFX]
	cp e
	jr c, .quit

.play
	ld a, [hROMBank]
	push af
	ld a, BANK(LoadSFX)
	ld [hROMBank], a
	ld [MBC3RomBank], a ; bankswitch

	ld a, e
	ld [CurSFX], a
	call LoadSFX

	pop af
	ld [hROMBank], a
	ld [MBC3RomBank], a ; bankswitch
.quit
	pop af
	pop bc
	pop de
	pop hl
	ret
; 3c4e


WaitPlaySFX: ; 3c4e
	call WaitSFX
	call StartSFX
	ret
; 3c55


WaitSFX: ; 3c55
; infinite loop until sfx is done playing

	push hl
	
.loop
	; ch5 on?
	ld hl, Channel5 + Channel1Flags - Channel1
	bit 0, [hl]
	jr nz, .loop
	; ch6 on?
	ld hl, Channel6 + Channel1Flags - Channel1
	bit 0, [hl]
	jr nz, .loop
	; ch7 on?
	ld hl, Channel7 + Channel1Flags - Channel1
	bit 0, [hl]
	jr nz, .loop
	; ch8 on?
	ld hl, Channel8 + Channel1Flags - Channel1
	bit 0, [hl]
	jr nz, .loop
	
	pop hl
	ret
; 3c74

Function3c74: ; 3c74
	push hl
	ld hl, $c1cc
	bit 0, [hl]
	jr nz, .asm_3c94
	ld hl, $c1fe
	bit 0, [hl]
	jr nz, .asm_3c94
	ld hl, $c230
	bit 0, [hl]
	jr nz, .asm_3c94
	ld hl, $c262
	bit 0, [hl]
	jr nz, .asm_3c94
	pop hl
	scf
	ret

.asm_3c94
	pop hl
	and a
	ret
; 3c97

MaxVolume: ; 3c97
	ld a, $77 ; max
	ld [Volume], a
	ret
; 3c9d

LowVolume: ; 3c9d
	ld a, $33 ; 40%
	ld [Volume], a
	ret
; 3ca3

VolumeOff: ; 3ca3
	xor a
	ld [Volume], a
	ret
; 3ca8

Function3ca8: ; 3ca8
	ld a, $4
	ld [MusicFade], a
	ret
; 3cae

Function3cae: ; 3cae
	ld a, $84
	ld [MusicFade], a
	ret
; 3cb4

Function3cb4: ; 3cb4
.asm_3cb4
	and a
	ret z
	dec a
	call CleanUpdateSound
	jr .asm_3cb4
; 3cbc

Function3cbc: ; 3cbc
	push hl
	push de
	push bc
	push af
	call Function3d97
	ld a, [CurMusic]
	cp e
	jr z, .asm_3cda
	ld a, $8
	ld [MusicFade], a
	ld a, e
	ld [MusicFadeIDLo], a
	ld a, d
	ld [MusicFadeIDHi], a
	ld a, e
	ld [CurMusic], a

.asm_3cda
	pop af
	pop bc
	pop de
	pop hl
	ret
; 3cdf

Function3cdf: ; 3cdf
	push hl
	push de
	push bc
	push af
	call Function3d97
	ld a, [CurMusic]
	cp e
	jr z, .asm_3cfe
	push de
	ld de, MUSIC_NONE
	call StartMusic
	call DelayFrame
	pop de
	ld a, e
	ld [CurMusic], a
	call StartMusic

.asm_3cfe
	pop af
	pop bc
	pop de
	pop hl
	ret
; 3d03

Function3d03: ; 3d03
	push hl
	push de
	push bc
	push af
	xor a
	ld [$c2c1], a
	ld de, MUSIC_BICYCLE
	ld a, [PlayerState]
	cp $1
	jr z, .asm_3d18
	call Function3d97
.asm_3d18
	push de
	ld de, MUSIC_NONE
	call StartMusic
	call DelayFrame
	pop de
	ld a, e
	ld [CurMusic], a
	call StartMusic
	pop af
	pop bc
	pop de
	pop hl
	ret
; 3d2f

Function3d2f: ; 3d2f
	ld a, [$c2c1]
	and a
	jr z, Function3d47
	xor a
	ld [CurMusic], a
	ld de, MUSIC_NONE
	call StartMusic
	call DelayFrame
	xor a
	ld [$c2c1], a
	ret
; 3d47

Function3d47: ; 3d47
	push hl
	push de
	push bc
	push af
	ld de, MUSIC_NONE
	call StartMusic
	call DelayFrame
	ld a, [CurMusic]
	ld e, a
	ld d, 0
	call StartMusic
	pop af
	pop bc
	pop de
	pop hl
	ret
; 3d62

Function3d62: ; 3d62
	ld a, [PlayerState]
	cp $4
	jr z, .asm_3d7b
	cp $8
	jr z, .asm_3d7b
	ld a, [StatusFlags2]
	bit 2, a
	jr nz, .asm_3d80
.asm_3d74
	and a
	ret

	ld de, $0013
	scf
	ret

.asm_3d7b
	ld de, $0021
	scf
	ret

.asm_3d80
	ld a, [MapGroup]
	cp $a
	jr nz, .asm_3d74
	ld a, [MapNumber]
	cp $f
	jr z, .asm_3d92
	cp $11
	jr nz, .asm_3d74

.asm_3d92
	ld de, $0058
	scf
	ret
; 3d97

Function3d97: ; 3d97
	call Function3d62
	ret c
	call Function2cbd
	ret
; 3d9f

Function3d9f: ; 3d9f
	ld a, $20
	ld [$c498], a
	ld [$c49c], a
	ld a, $50
	ld [$c499], a
	ld a, $58
	ld [$c49d], a
	xor a
	ld [$c49b], a
	ld [$c49f], a
	ld a, [$c296]
	cp $64
	jr nc, .asm_3dd5
	add $1
	daa
	ld b, a
	swap a
	and $f
	add $f6
	ld [$c49a], a
	ld a, b
	and $f
	add $f6
	ld [$c49e], a
	ret

.asm_3dd5
	ld a, $ff
	ld [$c49a], a
	ld [$c49e], a
	ret
; 3dde

CheckSFX: ; 3dde
; returns carry if sfx channels are active
	ld a, [$c1cc] ; 1
	bit 0, a
	jr nz, .quit
	ld a, [$c1fe] ; 2
	bit 0, a
	jr nz, .quit
	ld a, [$c230] ; 3
	bit 0, a
	jr nz, .quit
	ld a, [$c262] ; 4
	bit 0, a
	jr nz, .quit
	and a
	ret
.quit
	scf
	ret
; 3dfe

Function3dfe: ; 3dfe
	xor a
	ld [$c1cc], a
	ld [SoundInput], a
	ld [rNR10], a
	ld [rNR11], a
	ld [rNR12], a
	ld [rNR13], a
	ld [rNR14], a
	ret
; 3e10


ChannelsOff: ; 3e10
; Quickly turn off music channels
	xor a
	ld [Channel1Flags], a
	ld [$c136], a
	ld [$c168], a
	ld [$c19a], a
	ld [SoundInput], a
	ret
; 3e21

SFXChannelsOff: ; 3e21
; Quickly turn off sound effect channels
	xor a
	ld [$c1cc], a
	ld [$c1fe], a
	ld [$c230], a
	ld [$c262], a
	ld [SoundInput], a
	ret
; 3e32

Function3e32: ; 3e32
	cp $2
	ld [$c988], a
	ld a, l
	ld [$c986], a
	ld a, h
	ld [$c987], a
	jr nz, .asm_3e4f
	ld [$c982], a
	ld a, l
	ld [$c981], a
	ld hl, $c983
	ld a, c
	ld [hli], a
	ld a, b
	ld [hl], a

.asm_3e4f
	ld hl, $c822
	set 6, [hl]
	ld a, [hROMBank]
	push af
	ld a, $44
	ld [$c981], a
	rst Bankswitch

	jp $4030
; 3e60


Function3e60: ; 3e60
	ld [$c986], a
	ld a, l
	ld [$c987], a
	ld a, h
	ld [$c988], a
	pop bc
	ld a, b
	ld [$c981], a
	rst Bankswitch

	ld hl, $c822
	res 6, [hl]
	ld hl, $c987
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [$c986]
	ret
; 3e80


Function3e80: ; 3e80
	ld a, [hROMBank]
	push af
	ld a, $44
	ld [$c981], a
	rst Bankswitch

	call $56c5
	pop bc
	ld a, b
	ld [$c981], a
	rst Bankswitch

	ret
; 3e93


Timer: ; 3e93
	push af
	push bc
	push de
	push hl

	ld a, [$ffe9]
	and a
	jr z, .asm_3ed2

	xor a
	ld [rTAC], a

; Turn off timer interrupt
	ld a, [rIF]
	and 1 << VBLANK | 1 << LCD_STAT | 1 << SERIAL | 1 << JOYPAD
	ld [rIF], a

	ld a, [$c86a]
	or a
	jr z, .asm_3ed2

	ld a, [$c822]
	bit 1, a
	jr nz, .asm_3eca

	ld a, [rSC]
	and 1 << rSC_ON
	jr nz, .asm_3eca

	ld a, [hROMBank]
	push af
	ld a, $44
	ld [$c981], a
	rst Bankswitch

	call $58de

	pop bc
	ld a, b
	ld [$c981], a
	rst Bankswitch

.asm_3eca
	ld a, [rTMA]
	ld [rTIMA], a

	ld a, 1 << rTAC_ON | rTAC_65536_HZ
	ld [rTAC], a

.asm_3ed2
	pop hl
	pop de
	pop bc
	pop af
	reti
; 3ed7

Function3ed7: ; 3ed7
	ld [$dc02], a
	ld a, [hROMBank]
	push af
	ld a, $45
	rst Bankswitch

	call $4243
	pop bc
	ld a, b
	rst Bankswitch

	ld a, [$dc02]
	ret
; 3eea

Function3eea: ; 3eea
	push hl
	push bc
	ld de, $0939
	add hl, de
	inc b
	inc b
	inc c
	inc c
	call Function3f35
	pop bc
	pop hl
	call Function3f47
	ret
; 3efd

Function3efd: ; 3efd
	push hl
	ld hl, $c590
	ld b, $4
	ld c, $12
	call Function3f0d
	pop hl
	call PrintTextBoxText
	ret
; 3f0d

Function3f0d: ; 3f0d
	push hl
	push bc
	ld de, $0939
	add hl, de
	inc b
	inc b
	inc c
	inc c
	call Function3f35
	pop bc
	pop hl
	call TextBoxBorder
	ret
; 3f20

Function3f20: ; 3f20
	ld hl, AttrMap
	ld b, $6
	ld c, $14
	call Function3f35
	ld hl, TileMap
	ld b, $4
	ld c, $12
	call Function3f47
	ret
; 3f35

Function3f35: ; 3f35
	ld a, $6
	ld de, $0014
.asm_3f3a
	push bc
	push hl
.asm_3f3c
	ld [hli], a
	dec c
	jr nz, .asm_3f3c
	pop hl
	add hl, de
	pop bc
	dec b
	jr nz, .asm_3f3a
	ret
; 3f47

Function3f47: ; 3f47
	push bc
	call Function3f58
	pop bc
.asm_3f4c
	push bc
	call Function3f68
	pop bc
	dec b
	jr nz, .asm_3f4c
	call Function3f60
	ret
; 3f58

Function3f58: ; 3f58
	ld a, $63
	ld d, $62
	ld e, $64
	jr Function3f6e

Function3f60: ; 3f60
	ld a, $68
	ld d, $67
	ld e, $69
	jr Function3f6e

Function3f68: ; 3f68
	ld a, $7f
	ld d, $65
	ld e, $66

Function3f6e: ; 3f6e
	push hl
	ld [hl], d
	inc hl
.asm_3f71
	ld [hli], a
	dec c
	jr nz, .asm_3f71
	ld [hl], e
	pop hl
	ld de, $0014
	add hl, de
	ret
; 3f7c

Function3f7c: ; 3f7c
	call Function1cfd
	call Function1c53
	dec b
	dec c
	call Function3eea
	ret
; 3f88

Function3f88: ; 3f88
	ld hl, $d000
	ld b, $0
.asm_3f8d
	push bc
	ld c, $8
.asm_3f90
	ld a, [de]
	inc de
	cpl
	ld [hl], $0
	inc hl
	ld [hli], a
	dec c
	jr nz, .asm_3f90
	pop bc
	dec c
	jr nz, .asm_3f8d
	ret
; 3f9f

Function3f9f: ; 3f9f
	ld hl, $d000
.asm_3fa2
	push bc
	ld c, $8
.asm_3fa5
	ld a, [de]
	inc de
	inc de
	cpl
	ld [hl], $0
	inc hl
	ld [hli], a
	dec c
	jr nz, .asm_3fa5
	pop bc
	dec c
	jr nz, .asm_3fa2
	ret
; 3fb5


SECTION "bank1",ROMX,BANK[$1]


Function4000: ; 4000
	hlcoord 3, 10
	ld b, 1
	ld c, 11

	ld a, [IsInBattle]
	and a
	jr z, .asm_4012

	call TextBox
	jr .asm_4017

.asm_4012
	ld a, $10
	call Predef

.asm_4017
	hlcoord 4, 11
	ld de, .Waiting
	call PlaceString
	ld c, 50
	jp DelayFrames
; 4025

.Waiting ; 4025
	db "Waiting...!@"
; 4031

LoadPushOAM: ; 4031
	ld c, hPushOAM & $ff
	ld b, PushOAMEnd - PushOAM
	ld hl, PushOAM
.loop
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .loop
	ret
; 403f

PushOAM: ; 403f
	ld a, Sprites >> 8
	ld [rDMA], a
	ld a, $28
.loop
	dec a
	jr nz, .loop
	ret
PushOAMEnd
; 4049


DataPointers4049: ; 4049
	dw Data408b
	dw Data409c
	dw Data408b
	dw Data40ad
	dw Data40be
	dw Data40cf
	dw Data40be
	dw Data40e0
	dw Data40f1
	dw Data4113
	dw Data40f1
	dw Data4113
	dw Data4102
	dw Data4124
	dw Data4102
	dw Data4124
	dw Data4135
	dw Data414a
	dw Data415f
	dw Data4174
	dw Data4189
	dw Data419a
	dw Data4206
	dw Data41a3
	dw Data408b
	dw Data41e4
	dw Data408b
	dw Data41f5
	dw Data423f
	dw Data4250
	dw Data4261
	dw Data426a
	dw $0000
; 408b

Data408b: ; 408b
	db 4 ; #
	db $00, $00, $00, $00
	db $00, $08, $00, $01
	db $08, $00, $02, $02
	db $08, $08, $02, $03
; 409c

Data409c: ; 409c
	db 4 ; #
	db $00, $00, $00, $80
	db $00, $08, $00, $81
	db $08, $00, $02, $82
	db $08, $08, $02, $83
; 40ad

Data40ad: ; 40ad
	db 4 ; #
	db $00, $08, $20, $80
	db $00, $00, $20, $81
	db $08, $08, $22, $82
	db $08, $00, $22, $83
; 40be

Data40be: ; 40be
	db 4 ; #
	db $00, $00, $00, $04
	db $00, $08, $00, $05
	db $08, $00, $02, $06
	db $08, $08, $02, $07
; 40cf

Data40cf: ; 40cf
	db 4 ; #
	db $00, $00, $00, $84
	db $00, $08, $00, $85
	db $08, $00, $02, $86
	db $08, $08, $02, $87
; 40e0

Data40e0: ; 40e0
	db 4 ; #
	db $00, $08, $20, $84
	db $00, $00, $20, $85
	db $08, $08, $22, $86
	db $08, $00, $22, $87
; 40f1

Data40f1: ; 40f1
	db 4 ; #
	db $00, $00, $00, $08
	db $00, $08, $00, $09
	db $08, $00, $02, $0a
	db $08, $08, $02, $0b
; 4102

Data4102: ; 4102
	db 4 ; #
	db $00, $08, $20, $08
	db $00, $00, $20, $09
	db $08, $08, $22, $0a
	db $08, $00, $22, $0b
; 4113

Data4113: ; 4113
	db 4 ; #
	db $00, $00, $00, $88
	db $00, $08, $00, $89
	db $08, $00, $02, $8a
	db $08, $08, $02, $8b
; 4124

Data4124: ; 4124
	db 4 ; #
	db $00, $08, $20, $88
	db $00, $00, $20, $89
	db $08, $08, $22, $8a
	db $08, $00, $22, $8b
; 4135

Data4135: ; 4135
	db 5 ; #
	db $00, $00, $00, $00
	db $00, $08, $00, $01
	db $08, $00, $02, $02
	db $08, $08, $02, $03
	db $10, $00, $04, $fc
; 414a

Data414a: ; 414a
	db 5 ; #
	db $00, $00, $00, $04
	db $00, $08, $00, $05
	db $08, $00, $02, $06
	db $08, $08, $02, $07
	db $f8, $00, $04, $fc
; 415f

Data415f: ; 415f
	db 5 ; #
	db $00, $00, $00, $08
	db $00, $08, $00, $09
	db $08, $00, $02, $0a
	db $08, $08, $02, $0b
	db $05, $f8, $24, $fd
; 4174

Data4174: ; 4174
	db 5 ; #
	db $00, $08, $20, $08
	db $00, $00, $20, $09
	db $08, $08, $22, $0a
	db $08, $00, $22, $0b
	db $05, $10, $04, $fd
; 4189

Data4189: ; 4189
	db 4 ; #
	db $00, $00, $04, $f8
	db $00, $08, $04, $f9
	db $08, $00, $04, $fa
	db $08, $08, $04, $fb
; 419a

Data419a: ; 419a
	db 2 ; #
	db $00, $00, $04, $fc
	db $00, $08, $24, $fc
; 41a3

Data41a3: ; 41a3
	db 16 ; #
	db $00, $00, $00, $00
	db $00, $08, $00, $01
	db $08, $00, $00, $02
	db $08, $08, $00, $03
	db $10, $00, $00, $04
	db $10, $08, $00, $05
	db $18, $00, $00, $06
	db $18, $08, $00, $07
	db $00, $18, $20, $00
	db $00, $10, $20, $01
	db $08, $18, $20, $02
	db $08, $10, $20, $03
	db $10, $18, $20, $04
	db $10, $10, $20, $05
	db $18, $18, $20, $06
	db $18, $10, $20, $07
; 41e4

Data41e4: ; 41e4
	db 4 ; #
	db $00, $00, $00, $04
	db $00, $08, $00, $05
	db $08, $00, $00, $06
	db $08, $08, $00, $07
; 41f5

Data41f5: ; 41f5
	db 4 ; #
	db $00, $08, $20, $04
	db $00, $00, $20, $05
	db $08, $08, $20, $06
	db $08, $00, $20, $07
; 4206

Data4206: ; 4206
	db 14 ; #
	db $00, $00, $00, $00
	db $00, $08, $00, $01
	db $08, $00, $00, $04
	db $08, $08, $00, $05
	db $10, $08, $00, $07
	db $18, $08, $00, $0a
	db $00, $18, $00, $03
	db $00, $10, $00, $02
	db $08, $18, $20, $02
	db $08, $10, $00, $06
	db $10, $18, $00, $09
	db $10, $10, $00, $08
	db $18, $18, $20, $04
	db $18, $10, $00, $0b
; 423f

Data423f: ; 423f
	db 4 ; #
	db $00, $00, $04, $fe
	db $00, $08, $04, $fe
	db $08, $00, $04, $fe
	db $08, $08, $04, $fe
; 4250

Data4250: ; 4250
	db 4 ; #
	db $00, $00, $04, $ff
	db $00, $08, $04, $ff
	db $08, $00, $04, $ff
	db $08, $08, $04, $ff
; 4261

Data4261: ; 4261
	db 2 ; #
	db $08, $00, $04, $fe
	db $08, $08, $24, $fe
; 426a

Data426a: ; 426a
	db 2 ; #
	db $09, $ff, $04, $fe
	db $09, $09, $24, $fe
; 4273


Data4273: ; 4273
INCBIN "baserom.gbc", $4273, $4357 - $4273
; 4357


Function4357: ; 4357
	push bc
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	push af
	ld h, b
	ld l, c
	ld bc, $0028
	xor a
	call ByteFill
	pop af
	cp $ff
	jr z, .asm_4379
	bit 7, a
	jr nz, .asm_4379
	call GetMapObject
	ld hl, $0000
	add hl, bc
	ld [hl], $ff

.asm_4379
	pop bc
	ret
; 437b

Function437b: ; 437b
	call Function4386
	ret c
	call Function43f3
	call Function4427
	ret
; 4386

Function4386: ; 4386
	ld hl, $0005
	add hl, bc
	res 6, [hl]
	ld a, [XCoord]
	ld e, a
	ld hl, $0010
	add hl, bc
	ld a, [hl]
	add $1
	sub e
	jr c, .asm_43b2
	cp $c
	jr nc, .asm_43b2
	ld a, [YCoord]
	ld e, a
	ld hl, $0011
	add hl, bc
	ld a, [hl]
	add $1
	sub e
	jr c, .asm_43b2
	cp $b
	jr nc, .asm_43b2
	jr .asm_43dc

.asm_43b2
	ld hl, $0005
	add hl, bc
	set 6, [hl]
	ld a, [XCoord]
	ld e, a
	ld hl, $0014
	add hl, bc
	ld a, [hl]
	add $1
	sub e
	jr c, .asm_43de
	cp $c
	jr nc, .asm_43de
	ld a, [YCoord]
	ld e, a
	ld hl, $0015
	add hl, bc
	ld a, [hl]
	add $1
	sub e
	jr c, .asm_43de
	cp $b
	jr nc, .asm_43de

.asm_43dc
	and a
	ret

.asm_43de
	ld hl, $0004
	add hl, bc
	bit 1, [hl]
	jr nz, .asm_43eb
	call Function4357
	scf
	ret

.asm_43eb
	ld hl, $0005
	add hl, bc
	set 6, [hl]
	and a
	ret
; 43f3

Function43f3: ; 43f3
	ld hl, $0009
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_4409
	ld hl, $0005
	add hl, bc
	bit 5, [hl]
	jr nz, .asm_4426
	cp $1
	jr z, .asm_4414
	jr .asm_4421

.asm_4409
	call Function47bc
	ld hl, $0005
	add hl, bc
	bit 5, [hl]
	jr nz, .asm_4426

.asm_4414
	call Function47dd
	ld hl, $0009
	add hl, bc
	ld a, [hl]
	and a
	ret z
	cp $1
	ret z

.asm_4421
	ld hl, Pointers4b45
	rst JumpTable
	ret

.asm_4426
	ret
; 4427

Function4427: ; 4427
	ld hl, $0004
	add hl, bc
	bit 0, [hl]
	jr nz, Function44a3

	ld hl, $0005
	add hl, bc
	bit 6, [hl]
	jr nz, Function44a3

	bit 5, [hl]
	jr nz, Function4448

	ld de, Pointers445f
	jr Function444d
; 4440

Function4440: ; 4440
	ld hl, $0004
	add hl, bc
	bit 0, [hl]
	jr nz, Function44a3
	; fallthrough
; 4448

Function4448: ; 4448
	ld de, Pointers445f + 2
	jr Function444d
; 444d

Function444d: ; 444d
	ld hl, $000b
	add hl, bc
	ld a, [hl]
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call _hl_
	ret
; 445f

Pointers445f: ; 445f
	dw Function44a3
	dw Function44a3
	dw Function44b5
	dw Function44aa
	dw Function44c1
	dw Function44aa
	dw Function4508
	dw Function44aa
	dw Function4529
	dw Function44aa
	dw Function4539
	dw Function44a3
	dw Function456e
	dw Function456e
	dw Function457b
	dw Function44a3
	dw Function4582
	dw Function4582
	dw Function4589
	dw Function4589
	dw Function4590
	dw Function45a4
	dw Function45ab
	dw Function44aa
	dw Function45be
	dw Function45be
	dw Function45c5
	dw Function45c5
	dw Function45da
	dw Function44a3
	dw Function45ed
	dw Function44a3
	dw Function44e4
	dw Function44aa
; 44a3

Function44a3: ; 44a3
	ld hl, $000d
	add hl, bc
	ld [hl], $ff
	ret
; 44aa

Function44aa: ; 44aa
	call GetSpriteDirection
	or $0
	ld hl, $000d
	add hl, bc
	ld [hl], a
	ret
; 44b5

Function44b5: ; 44b5
	ld hl, $000d
	add hl, bc
	ld a, [hl]
	and $1
	jr nz, Function44c1
	jp Function44aa
; 44c1

Function44c1: ; 44c1
	ld hl, $0004
	add hl, bc
	bit 3, [hl]
	jp nz, Function44aa
	ld hl, $000c
	add hl, bc
	ld a, [hl]
	inc a
	and $f
	ld [hl], a
	rrca
	rrca
	and $3
	ld d, a
	call GetSpriteDirection
	or $0
	or d
	ld hl, $000d
	add hl, bc
	ld [hl], a
	ret
; 44e4

Function44e4: ; 44e4
	ld hl, $0004
	add hl, bc
	bit 3, [hl]
	jp nz, Function44aa
	ld hl, $000c
	add hl, bc
	ld a, [hl]
	add $2
	and $f
	ld [hl], a
	rrca
	rrca
	and $3
	ld d, a
	call GetSpriteDirection
	or $0
	or d
	ld hl, $000d
	add hl, bc
	ld [hl], a
	ret
; 4508

Function4508: ; 4508
	ld hl, $0004
	add hl, bc
	bit 3, [hl]
	jp nz, Function44aa
	ld hl, $000c
	add hl, bc
	inc [hl]
	ld a, [hl]
	rrca
	rrca
	rrca
	and $3
	ld d, a
	call GetSpriteDirection
	or $0
	or d
	ld hl, $000d
	add hl, bc
	ld [hl], a
	ret
; 4529

Function4529: ; 4529
	call Function453f
	ld hl, $0008
	add hl, bc
	ld a, [hl]
	or $0
	ld hl, $000d
	add hl, bc
	ld [hl], a
	ret
; 4539

Function4539: ; 4539
	call Function453f
	jp Function44a3
; 453f

Function453f: ; 453f
	ld hl, $000c
	add hl, bc
	ld a, [hl]
	and $f0
	ld e, a
	ld a, [hl]
	inc a
	and $f
	ld d, a
	cp $4
	jr c, .asm_4558
	ld d, 0
	ld a, e
	add $10
	and $30
	ld e, a

.asm_4558
	ld a, d
	or e
	ld [hl], a
	swap e
	ld d, 0
	ld hl, .Directions
	add hl, de
	ld a, [hl]
	ld hl, $0008
	add hl, bc
	ld [hl], a
	ret
; 456a

.Directions ; 456a
	db $00, $0c, $04, $08
; 456e

Function456e: ; 456e
	call GetSpriteDirection
	rrca
	rrca
	add $10
	ld hl, $000d
	add hl, bc
	ld [hl], a
	ret
; 457b

Function457b: ; 457b
	ld hl, $000d
	add hl, bc
	ld [hl], $15
	ret
; 4582

Function4582: ; 4582
	ld hl, $000d
	add hl, bc
	ld [hl], $14
	ret
; 4589

Function4589: ; 4589
	ld hl, $000d
	add hl, bc
	ld [hl], $17
	ret
; 4590

Function4590: ; 4590
	ld hl, $000c
	add hl, bc
	ld a, [hl]
	inc a
	and $f
	ld [hl], a
	and $8
	jr z, Function45a4
	ld hl, $000d
	add hl, bc
	ld [hl], $4
	ret
; 45a4

Function45a4: ; 45a4
	ld hl, $000d
	add hl, bc
	ld [hl], $0
	ret
; 45ab

Function45ab: ; 45ab
	ld hl, $000c
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $c
	rrca
	rrca
	add $18
	ld hl, $000d
	add hl, bc
	ld [hl], a
	ret
; 45be

Function45be: ; 45be
	ld hl, $000d
	add hl, bc
	ld [hl], $16
	ret
; 45c5

Function45c5: ; 45c5
	ld a, [$d831]
	ld d, $17
	cp $33
	jr z, .asm_45d4
	cp $47
	jr z, .asm_45d4
	ld d, $16

.asm_45d4
	ld hl, $000d
	add hl, bc
	ld [hl], d
	ret
; 45da

Function45da: ; 45da
	ld hl, $000c
	add hl, bc
	inc [hl]
	ld a, [hl]
	ld hl, $000d
	add hl, bc
	and $2
	ld a, $1c
	jr z, .asm_45eb
	inc a

.asm_45eb
	ld [hl], a
	ret
; 45ed

Function45ed: ; 45ed
	ld hl, $000c
	add hl, bc
	inc [hl]
	ld a, [hl]
	ld hl, $000d
	add hl, bc
	and $4
	ld a, $1e
	jr z, .asm_45fe
	inc a

.asm_45fe
	ld [hl], a
	ret
; 4600

Function4600: ; 4600
	ld hl, $0010
	add hl, bc
	ld a, [hl]
	ld hl, $0012
	add hl, bc
	ld [hl], a
	ld hl, $0011
	add hl, bc
	ld a, [hl]
	ld hl, $0013
	add hl, bc
	ld [hl], a
	ld hl, $000e
	add hl, bc
	ld a, [hl]
	ld hl, $000f
	add hl, bc
	ld [hl], a
	call Function4661
	ld hl, $000e
	add hl, bc
	ld a, [hl]
	call Function4679
	ret
; 462a

Function462a: ; 462a
	ld hl, $0012
	add hl, bc
	ld a, [hl]
	ld hl, $0010
	add hl, bc
	ld [hl], a
	ld hl, $0013
	add hl, bc
	ld a, [hl]
	ld hl, $0011
	add hl, bc
	ld [hl], a
	ret
; 463f

Function463f: ; 463f
	ld hl, $0005
	add hl, bc
	bit 3, [hl]
	jr z, .asm_464f
	ld hl, $000e
	add hl, bc
	ld a, [hl]
	call Function4661

.asm_464f
	ld hl, $000e
	add hl, bc
	ld a, [hl]
	call Function4679
	ret c
	ld hl, $000f
	add hl, bc
	ld a, [hl]
	call Function4679
	ret
; 4661

Function4661: ; 4661
	call Function188e
	jr z, .asm_466b
	call Function1875
	jr c, .asm_4672

.asm_466b
	ld hl, $0005
	add hl, bc
	set 3, [hl]
	ret

.asm_4672
	ld hl, $0005
	add hl, bc
	res 3, [hl]
	ret
; 4679

Function4679: ; 4679
	and a
	ret
; 467b

Function467b: ; 467b
	xor a
	ld hl, $000c
	add hl, bc
	ld [hl], a
	ld hl, $001b
	add hl, bc
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $0007
	add hl, bc
	ld [hl], $ff
	ret
; 4690

Function4690: ; 4690
	ld hl, $0007
	add hl, bc
	ld [hl], a
	ld hl, $0004
	add hl, bc
	bit 2, [hl]
	jr nz, .asm_46a6

	add a
	add a
	and $c
	ld hl, $0008
	add hl, bc
	ld [hl], a

.asm_46a6
	; fallthrough
; 46a6

Function46a6: ; 46a6
	call Function46e9
	ld hl, $000a
	add hl, bc
	ld [hl], a
	ld a, d
	call Function4730
	ld hl, $0012
	add hl, bc
	add [hl]
	ld hl, $0010
	add hl, bc
	ld [hl], a
	ld d, a
	ld a, e
	call Function4730
	ld hl, $0013
	add hl, bc
	add [hl]
	ld hl, $0011
	add hl, bc
	ld [hl], a
	ld e, a
	push bc
	call Function2a3c
	pop bc
	ld hl, $000e
	add hl, bc
	ld [hl], a
	ret
; 46d7

Function46d7: ; 46d7
	call Function46e9
	ld hl, $0017
	add hl, bc
	ld a, [hl]
	add d
	ld [hl], a
	ld hl, $0018
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a
	ret
; 46e9

Function46e9: ; 46e9
	ld hl, $0007
	add hl, bc
	ld a, [hl]
	and $f
	add a
	add a
	ld l, a
	ld h, 0
	ld de, .Steps
	add hl, de
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ret
; 4700

.Steps ; 4700
	;   x,  y, duration, speed
	; slow
	db  0,  1, $10, $01
	db  0, -1, $10, $01
	db -1,  0, $10, $01
	db  1,  0, $10, $01
	; normal
	db  0,  2, $08, $02
	db  0, -2, $08, $02
	db -2,  0, $08, $02
	db  2,  0, $08, $02
	; fast
	db  0,  4, $04, $04
	db  0, -4, $04, $04
	db -4,  0, $04, $04
	db  4,  0, $04, $04
; 4730

Function4730: ; 4730
	add a
	ret z
	ld a, 1
	ret nc
	ld a, -1
	ret
; 4738

Function4738: ; 4738
	ld hl, $0007
	add hl, bc
	ld a, [hl]
	and $3
	ld [$d151], a
	call Function46d7
	ld a, [$d14e]
	add d
	ld [$d14e], a
	ld a, [$d14f]
	add e
	ld [$d14f], a
	ld hl, $d150
	set 5, [hl]
	ret
; 4759

Function4759: ; 4759
	push bc
	ld e, a
	ld d, 0
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	call GetMapObject
	add hl, de
	ld a, [hl]
	pop bc
	ret
; 4769

Function4769: ; 4769
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .asm_477d
	push bc
	call GetMapObject
	ld hl, $0004
	add hl, bc
	ld a, [hl]
	pop bc
	ret

.asm_477d
	ld a, $6
	ret
; 4780

Function4780: ; 4780
	ld hl, $001b
	add hl, bc
	ld [hl], $0
	ret
; 4787

Function4787: ; 4787
	ld hl, $001b
	add hl, bc
	inc [hl]
	ret
; 478d

Function478d: ; 478d
	ld hl, $001b
	add hl, bc
	dec [hl]
	ret
; 4793

Function4793: ; 4793
	ld hl, $001b
	add hl, bc
	ld a, [hl]
	pop hl
	rst JumpTable
	ret
; 479b

Function479b: ; 479b
	ld hl, $001c
	add hl, bc
	ld [hl], $0
	ret
; 47a2

Function47a2: ; 47a2
	ld hl, $001c
	add hl, bc
	inc [hl]
	ret
; 47a8

Function47a8: ; 47a8
	ld hl, $001c
	add hl, bc
	ld a, [hl]
	pop hl
	rst JumpTable
	ret
; 47b0

Function47b0: ; 47b0
	ld hl, $001c
	add hl, bc
	ld a, [hl]
	ret
; 47b6

Function47b6: ; 47b6
	ld hl, $001c
	add hl, bc
	ld [hl], a
	ret
; 47bc

Function47bc: ; 47bc
	ld hl, $0010
	add hl, bc
	ld d, [hl]
	ld hl, $0011
	add hl, bc
	ld e, [hl]
	push bc
	call Function2a3c
	pop bc
	ld hl, $000e
	add hl, bc
	ld [hl], a
	call Function4600
	call Function467b
	ld hl, $0009
	add hl, bc
	ld [hl], $1
	ret
; 47dd

Function47dd: ; 47dd
	call Function479b
	call Function1a2f
	ld a, [hl]
	ld hl, .Pointers
	rst JumpTable
	ret
; 47e9

.Pointers ; 47e9
	dw Function4821
	dw Function4822
	dw Function482c
	dw Function4838
	dw Function4842
	dw Function4851
	dw Function4869
	dw Function487c
	dw Function4882
	dw Function4888
	dw Function488e
	dw Function4891
	dw Function4894
	dw Function4897
	dw Function489d
	dw Function48a0
	dw Function48a6
	dw Function48ac
	dw Function48ff
	dw Function49e5
	dw Function4a21
	dw Function4958
	dw Function496e
	dw Function4abc
	dw Function498d
	dw Function4984
	dw Function4a46
	dw Function4a89
; 4821

Function4821: ; 4821
	ret
; 4822

Function4822: ; 4822
	call Random
	ld a, [hRandomAdd]
	and 1
	jp Function4af0
; 482c

Function482c: ; 482c
	call Random
	ld a, [hRandomAdd]
	and 1
	or 2
	jp Function4af0
; 4838

Function4838: ; 4838
	call Random
	ld a, [hRandomAdd]
	and 3
	jp Function4af0
; 4842

Function4842: ; 4842
	call Random
	ld a, [hRandomAdd]
	and $c
	ld hl, $0008
	add hl, bc
	ld [hl], a
	jp Function4b1d
; 4851

Function4851: ; 4851
	ld hl, $0008
	add hl, bc
	ld a, [hl]
	and $c
	ld d, a
	call Random
	ld a, [hRandomAdd]
	and $c
	cp d
	jr nz, .asm_4865
	xor $c

.asm_4865
	ld [hl], a
	jp Function4b26
; 4869

Function4869: ; 4869
	call Function462a
	call Function467b
	ld hl, $000b
	add hl, bc
	ld [hl], $1
	ld hl, $0009
	add hl, bc
	ld [hl], $5
	ret
; 487c

Function487c: ; 487c
	ld hl, Function5000
	jp Function5041
; 4882

Function4882: ; 4882
	ld hl, Function5015
	jp Function5041
; 4888

Function4888: ; 4888
	ld hl, Function5026
	jp Function5041
; 488e

Function488e: ; 488e
	jp Function5037
; 4891

Function4891: ; 4891
	jp Function5037
; 4894

Function4894: ; 4894
	jp Function5037
; 4897

Function4897: ; 4897
	ld hl, Function5000
	jp Function5041
; 489d

Function489d: ; 489d
	jp Function5037
; 48a0

Function48a0: ; 48a0
	ld hl, Function54e6
	jp Function5041
; 48a6

Function48a6: ; 48a6
	ld hl, Function500e
	jp Function5041
; 48ac

Function48ac: ; 48ac
	call Function4793
	dw Function48b3
	dw Function48f8
; 48b3

Function48b3: ; 48b3
	ld hl, $000e
	add hl, bc
	ld a, [hl]
	call CheckPitTile
	jr z, .asm_48f5
	ld hl, $0005
	add hl, bc
	bit 2, [hl]
	res 2, [hl]
	jr z, .asm_48ee
	ld hl, $0020
	add hl, bc
	ld a, [hl]
	and $3
	or $0
	call Function4690
	call Function6ec1
	jr c, .asm_48eb
	ld de, SFX_STRENGTH
	call StartSFX
	call Function5538
	call Function463f
	ld hl, $0009
	add hl, bc
	ld [hl], $f
	ret

.asm_48eb
	call Function462a

.asm_48ee
	ld hl, $0007
	add hl, bc
	ld [hl], $ff
	ret

.asm_48f5
	call Function4787
	; fallthrough
; 48f8

Function48f8: ; 48f8
	ld hl, $0007
	add hl, bc
	ld [hl], $ff
	ret
; 48ff

Function48ff: ; 48ff
	ld hl, $0010
	add hl, bc
	ld d, [hl]
	ld hl, $0011
	add hl, bc
	ld e, [hl]
	ld hl, $0020
	add hl, bc
	ld a, [hl]
	push bc
	call Function1ae5
	ld hl, $0007
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .asm_494a
	ld hl, $0012
	add hl, bc
	ld a, [hl]
	cp d
	jr z, .asm_492d
	jr c, .asm_4929
	ld a, $3
	jr .asm_493d

.asm_4929
	ld a, $2
	jr .asm_493d

.asm_492d
	ld hl, $0013
	add hl, bc
	ld a, [hl]
	cp e
	jr z, .asm_494a
	jr c, .asm_493b
	ld a, $0
	jr .asm_493d

.asm_493b
	ld a, $1

.asm_493d
	ld d, a
	ld hl, $0007
	add hl, bc
	ld a, [hl]
	and $c
	or d
	pop bc
	jp Function5412

.asm_494a
	pop bc
	ld hl, $0007
	add hl, bc
	ld [hl], $ff
	ld hl, $000b
	add hl, bc
	ld [hl], $1
	ret
; 4958

Function4958: ; 4958
	call Function467b
	ld hl, $0007
	add hl, bc
	ld [hl], $ff
	ld hl, $000b
	add hl, bc
	ld [hl], $9
	ld hl, $0009
	add hl, bc
	ld [hl], $4
	ret
; 496e

Function496e: ; 496e
	call Function467b
	ld hl, $0007
	add hl, bc
	ld [hl], $ff
	ld hl, $000b
	add hl, bc
	ld [hl], $a
	ld hl, $0009
	add hl, bc
	ld [hl], $4
	ret
; 4984

Function4984: ; 4984
	call Function4793
	dw Function4996
	dw Function499c
	dw Function49b8
; 498d

Function498d: ; 498d
	call Function4793
	dw Function4996
	dw Function499c
	dw Function49c4
; 4996

Function4996: ; 4996
	call Function467b
	call Function4787
	; fallthrough
; 499c

Function499c: ; 499c
	ld hl, $000b
	add hl, bc
	ld [hl], $1
	ld hl, $0020
	add hl, bc
	ld a, [hl]
	ld a, $10
	ld hl, $000a
	add hl, bc
	ld [hl], a
	ld hl, $0009
	add hl, bc
	ld [hl], $3
	call Function4787
	ret
; 49b8

Function49b8: ; 49b8
	ld de, .data_49c0
	call Function49d0
	jr Function4984
; 49c0

.data_49c0 ; 49c0
	db $0c, $08, $00, $04
; 49c4

Function49c4: ; 49c4
	ld de, .data_49cc
	call Function49d0
	jr Function498d
; 49cc

.data_49cc ; 49cc
	db $08, $0c, $04, $00
; 49d0

Function49d0: ; 49d0
	ld hl, $0008
	add hl, bc
	ld a, [hl]
	and $c
	rrca
	rrca
	push hl
	ld l, a
	ld h, $0
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a
	call Function478d
	ret
; 49e5

Function49e5: ; 49e5
	call Function4aa8
	ld hl, $000b
	add hl, bc
	ld [hl], $7
	ld hl, $000a
	add hl, de
	ld a, [hl]
	inc a
	add a
	add $0
	ld hl, $000a
	add hl, bc
	ld [hl], a
	ld hl, $0007
	add hl, de
	ld a, [hl]
	and 3
	ld d, $e
	cp 0
	jr z, .asm_4a0f
	cp 1
	jr z, .asm_4a0f
	ld d, $c

.asm_4a0f
	ld hl, $001a
	add hl, bc
	ld [hl], d
	ld hl, $0019
	add hl, bc
	ld [hl], $0
	ld hl, $0009
	add hl, bc
	ld [hl], $13
	ret
; 4a21

Function4a21: ; 4a21
	call Function467b
	call Function4aa8
	ld hl, $000b
	add hl, bc
	ld [hl], $8
	ld hl, $000a
	add hl, bc
	ld [hl], $0
	ld hl, $001a
	add hl, bc
	ld [hl], $f0
	ld hl, $0019
	add hl, bc
	ld [hl], $0
	ld hl, $0009
	add hl, bc
	ld [hl], $13
	ret
; 4a46

Function4a46: ; 4a46
	call Function467b
	call Function4aa8
	ld hl, $000b
	add hl, bc
	ld [hl], $e
	ld hl, $000a
	add hl, de
	ld a, [hl]
	inc a
	add a
	ld hl, $000a
	add hl, bc
	ld [hl], a
	ld hl, $0007
	add hl, de
	ld a, [hl]
	and 3
	ld e, a
	ld d, 0
	ld hl, .data_4a81
	add hl, de
	add hl, de
	ld d, [hl]
	inc hl
	ld e, [hl]
	ld hl, $0019
	add hl, bc
	ld [hl], d
	ld hl, $001a
	add hl, bc
	ld [hl], e
	ld hl, $0009
	add hl, bc
	ld [hl], $13
	ret
; 4a81

.data_4a81  ; 4a81
	;   x,  y
	db  0, -4
	db  0,  8
	db  6,  2
	db -6,  2
; 4a89

Function4a89: ; 4a89
	call Function467b
	call Function4aa8
	ld hl, $000b
	add hl, bc
	ld [hl], $f
	ld hl, $000a
	add hl, de
	ld a, [hl]
	add $ff
	ld hl, $000a
	add hl, bc
	ld [hl], a
	ld hl, $0009
	add hl, bc
	ld [hl], $13
	ret
; 4aa8

Function4aa8: ; 4aa8
	ld hl, $0020
	add hl, bc
	ld a, [hl]
	push bc
	call Function1ae5
	ld d, b
	ld e, c
	pop bc
	ld hl, $001d
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ret
; 4abc

Function4abc: ; 4abc
	call Function467b
	ld hl, $000b
	add hl, bc
	ld [hl], $0
	ld hl, $0020
	add hl, bc
	ld a, [hl]
	call Function4ade
	ld hl, $000a
	add hl, bc
	ld [hl], e
	ld hl, $001e
	add hl, bc
	ld [hl], a
	ld hl, $0009
	add hl, bc
	ld [hl], $15
	ret
; 4ade

Function4ade: ; 4ade
	ld d, a
	and $3f
	ld e, a
	ld a, d
	rlca
	rlca
	and $3
	ld d, a
	inc d
	ld a, $1
.asm_4aeb
	dec d
	ret z
	add a
	jr .asm_4aeb
; 4af0

Function4af0: ; 4af0
	call Function4690
	call Function6ec1
	jr c, Function4b17
	call Function463f
	ld hl, $000b
	add hl, bc
	ld [hl], $2
	ld hl, $d4cf
	ld a, [hConnectionStripLength]
	cp [hl]
	jr z, .asm_4b10
	ld hl, $0009
	add hl, bc
	ld [hl], $7
	ret

.asm_4b10
	ld hl, $0009
	add hl, bc
	ld [hl], $6
	ret

Function4b17: ; 4b17
	call Function467b
	call Function462a
	; fallthrough
; 4b1d

Function4b1d: ; 4b1d
	call Random
	ld a, [hRandomAdd]
	and $7f
	jr Function4b2d
; 4b26

Function4b26: ; 4b26
	call Random
	ld a, [hRandomAdd]
	and $1f
	; fallthrough
; 4b2d

Function4b2d: ; 4b2d
	ld hl, $000a
	add hl, bc
	ld [hl], a
	ld hl, $0007
	add hl, bc
	ld [hl], $ff
	ld hl, $000b
	add hl, bc
	ld [hl], $1
	ld hl, $0009
	add hl, bc
	ld [hl], $3
	ret
; 4b45

Pointers4b45: ; 4b45
	dw Function47bc
	dw Function47dd
	dw Function4e2b
	dw Function4ddd
	dw Function4e21
	dw Function4e0c
	dw Function4e56
	dw Function4e47
	dw Function4b86
	dw Function4bbf
	dw Function4e83
	dw Function4dff
	dw Function4c18
	dw Function4c89
	dw Function4d14
	dw Function4ecd
	dw Function4d7e
	dw Function4daf
	dw Function4dc8
	dw Function4f04
	dw Function4f33
	dw Function4f33
	dw Function4f77
	dw Function4f7a
	dw Function4df0
	dw Function4f83
; 4b79

Function4b79: ; 4b79
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	ld hl, $0009
	add hl, bc
	ld [hl], $1
	ret
; 4b86

Function4b86: ; 4b86
	call Function47a8
	dw Function4b8d
	dw Function4ba9
; 4b8d

Function4b8d: ; 4b8d
	call Function46d7
	call UpdateJumpPosition
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	call Function4600
	call Function46a6
	ld hl, $0005
	add hl, bc
	res 3, [hl]
	call Function47a2
	ret
; 4ba9

Function4ba9: ; 4ba9
	call Function46d7
	call UpdateJumpPosition
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	call Function4600
	ld hl, $0009
	add hl, bc
	ld [hl], $1
	ret
; 4bbf

Function4bbf: ; 4bbf
	call Function47a8
	dw Function4bca
	dw Function4bd2
	dw Function4bf2
	dw Function4bfd
; 4bca

Function4bca: ; 4bca
	ld hl, $d150
	set 7, [hl]
	call Function47a2
;	fallthrough
; 4bd2

Function4bd2: ; 4bd2
	call UpdateJumpPosition
	call Function4738
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	call Function4600
	ld hl, $0005
	add hl, bc
	res 3, [hl]
	ld hl, $d150
	set 6, [hl]
	set 4, [hl]
	call Function47a2
	ret
; 4bf2

Function4bf2: ; 4bf2
	call Function46a6
	ld hl, $d150
	set 7, [hl]
	call Function47a2
;	fallthrough
; 4bfd

Function4bfd: ; 4bfd
	call UpdateJumpPosition
	call Function4738
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	ld hl, $d150
	set 6, [hl]
	call Function4600
	ld hl, $0009
	add hl, bc
	ld [hl], $1
	ret
; 4c18

Function4c18: ; 4c18
	call Function47a8
	dw Function4c23
	dw Function4c32
	dw Function4c42
	dw Function4c5d
; 4c23

Function4c23: ; 4c23
	ld hl, $000c
	add hl, bc
	ld [hl], $0
	ld hl, $000a
	add hl, bc
	ld [hl], $10
	call Function47a2
;	fallthrough
; 4c32

Function4c32: ; 4c32
	ld hl, $000b
	add hl, bc
	ld [hl], $4
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	call Function47a2
	ret
; 4c42

Function4c42: ; 4c42
	ld hl, $000c
	add hl, bc
	ld [hl], $0
	ld hl, $001f
	add hl, bc
	ld [hl], $10
	ld hl, $000a
	add hl, bc
	ld [hl], $10
	ld hl, $0005
	add hl, bc
	res 3, [hl]
	call Function47a2
;	fallthrough
; 4c5d

Function4c5d: ; 4c5d
	ld hl, $000b
	add hl, bc
	ld [hl], $4
	ld hl, $001f
	add hl, bc
	inc [hl]
	ld a, [hl]
	ld d, $60
	call Sine
	ld a, h
	sub $60
	ld hl, $001a
	add hl, bc
	ld [hl], a
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	ld hl, $000c
	add hl, bc
	ld [hl], $0
	ld hl, $0009
	add hl, bc
	ld [hl], $1
	ret
; 4c89

Function4c89: ; 4c89
	call Function47a8
	dw Function4c9a
	dw Function4caa
	dw Function4cb3
	dw Function4cc9
	dw Function4ceb
	dw Function4cf5
	dw Function4d01
; 4c9a

Function4c9a: ; 4c9a
	ld hl, $000b
	add hl, bc
	ld [hl], $0
	ld hl, $000a
	add hl, bc
	ld [hl], $10
	call Function47a2
	ret
; 4caa

Function4caa: ; 4caa
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	call Function47a2
;	fallthrough
; 4cb3

Function4cb3: ; 4cb3
	ld hl, $000c
	add hl, bc
	ld [hl], $0
	ld hl, $001f
	add hl, bc
	ld [hl], $0
	ld hl, $000a
	add hl, bc
	ld [hl], $10
	call Function47a2
	ret
; 4cc9

Function4cc9: ; 4cc9
	ld hl, $000b
	add hl, bc
	ld [hl], $4
	ld hl, $001f
	add hl, bc
	inc [hl]
	ld a, [hl]
	ld d, $60
	call Sine
	ld a, h
	sub $60
	ld hl, $001a
	add hl, bc
	ld [hl], a
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	call Function47a2
;	fallthrough
; 4ceb

Function4ceb: ; 4ceb
	ld hl, $000a
	add hl, bc
	ld [hl], $10
	call Function47a2
	ret
; 4cf5

Function4cf5: ; 4cf5
	ld hl, $000b
	add hl, bc
	ld [hl], $4
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
; 4d01

Function4d01: ; 4d01
	ld hl, $000c
	add hl, bc
	ld [hl], $0
	ld hl, $001a
	add hl, bc
	ld [hl], $0
	ld hl, $0009
	add hl, bc
	ld [hl], $1
	ret
; 4d14

Function4d14: ; 4d14
	call Function47a8
	dw Function4d1f
	dw Function4d2e
	dw Function4d4f
	dw Function4d6b
; 4d1f

Function4d1f: ; 4d1f
	ld hl, $000b
	add hl, bc
	ld [hl], $0
	ld hl, $000a
	add hl, bc
	ld [hl], $10
	call Function47a2
;	fallthrough
; 4d2e

Function4d2e: ; 4d2e
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	ld hl, $000b
	add hl, bc
	ld [hl], $2
	ld hl, $000c
	add hl, bc
	ld [hl], $0
	ld hl, $001f
	add hl, bc
	ld [hl], $0
	ld hl, $000a
	add hl, bc
	ld [hl], $10
	call Function47a2
;	fallthrough
; 4d4f

Function4d4f: ; 4d4f
	ld hl, $001f
	add hl, bc
	inc [hl]
	ld a, [hl]
	ld d, $60
	call Sine
	ld a, h
	sub $60
	ld hl, $001a
	add hl, bc
	ld [hl], a
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	call Function47a2
;	fallthrough
; 4d6b

Function4d6b: ; 4d6b
	ld hl, $000c
	add hl, bc
	ld [hl], $0
	ld hl, $001a
	add hl, bc
	ld [hl], $0
	ld hl, $0009
	add hl, bc
	ld [hl], $1
	ret
; 4d7e

Function4d7e: ; 4d7e
	call Function47a8
	dw Function4d85
	dw Function4d94
; 4d85

Function4d85: ; 4d85
	ld hl, $000a
	add hl, bc
	ld [hl], $8
	ld hl, $001a
	add hl, bc
	ld [hl], $0
	call Function47a2
	; fallthrough
; 4d94

Function4d94: ; 4d94
	ld hl, $001a
	add hl, bc
	ld a, [hl]
	xor 1
	ld [hl], a
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	ld hl, $001a
	add hl, bc
	ld [hl], $0
	ld hl, $0009
	add hl, bc
	ld [hl], $1
	ret
; 4daf

Function4daf: ; 4daf
	call Function4db5
	jp Function4b79
; 4db5

Function4db5: ; 4db5
	ld hl, $000a
	add hl, bc
	ld a, [hl]
	and $1
	ld a, $1
	jr z, .asm_4dc2
	ld a, $0

.asm_4dc2
	ld hl, $000b
	add hl, bc
	ld [hl], a
	ret
; 4dc8

Function4dc8: ; 4dc8
	ld hl, $000a
	add hl, bc
	ld a, [hl]
	and $1
	ld a, $4
	jr z, .asm_4dd5
	ld a, $5

.asm_4dd5
	ld hl, $000b
	add hl, bc
	ld [hl], a
	jp Function4b79
; 4ddd

Function4ddd: ; 4ddd
	ld hl, $0007
	add hl, bc
	ld [hl], $ff
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	ld hl, $0009
	add hl, bc
	ld [hl], $1
	ret
; 4df0

Function4df0: ; 4df0
	ld hl, $0007
	add hl, bc
	ld [hl], $ff
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	jp Function4357
; 4dff

Function4dff: ; 4dff
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	ld hl, $0009
	add hl, bc
	ld [hl], $1
	ret
; 4e0c

Function4e0c: ; 4e0c
	call Function47a8
	dw Function4e13
	dw Function4e21
; 4e13

Function4e13: ; 4e13
	call Function4769
	call Function1a47
	ld hl, $0008
	add hl, bc
	ld [hl], a
	call Function47a2
	; fallthrough
; 4e21

Function4e21: ; 4e21
	call Function4fb2
	ld hl, $0007
	add hl, bc
	ld [hl], $ff
	ret
; 4e2b

Function4e2b: ; 4e2b
	call Function4fb2
	call Function46d7
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	call Function4600
	ld hl, $0007
	add hl, bc
	ld [hl], $ff
	ld hl, $0009
	add hl, bc
	ld [hl], $1
	ret
; 4e47

Function4e47: ; 4e47
	call Function46d7
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	call Function4600
	jp Function4b1d
; 4e56

Function4e56: ; 4e56
; AnimateStep?
	call Function47a8
	dw Function4e5d
	dw Function4e65
; 4e5d

Function4e5d: ; 4e5d
	ld hl, $d150
	set 7, [hl]
	call Function47a2
	; fallthrough
; 4e65

Function4e65: ; 4e65
	call Function4738
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	ld hl, $d150
	set 6, [hl]
	call Function4600
	ld hl, $0007
	add hl, bc
	ld [hl], $ff
	ld hl, $0009
	add hl, bc
	ld [hl], $1
	ret
; 4e83

Function4e83: ; 4e83
	call Function47a8
	dw Function4e8e
	dw Function4ea4
	dw Function4ead
	dw Function4ec0
; 4e8e

Function4e8e: ; 4e8e
	ld hl, $0007
	add hl, bc
	ld [hl], $ff
	ld hl, $000c
	add hl, bc
	ld a, [hl]
	ld [hl], $2
	ld hl, $000a
	add hl, bc
	ld [hl], $2
	call Function47a2
	; fallthrough
; 4ea4

Function4ea4: ; 4ea4
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	call Function47a2
	; fallthrough
; 4ead

Function4ead: ; 4ead
	ld hl, $001d
	add hl, bc
	ld a, [hl]
	ld hl, $0008
	add hl, bc
	ld [hl], a
	ld hl, $000a
	add hl, bc
	ld [hl], $2
	call Function47a2
	; fallthrough
; 4ec0

Function4ec0: ; 4ec0
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	ld hl, $0009
	add hl, bc
	ld [hl], $1
	ret
; 4ecd

Function4ecd: ; 4ecd
	call Function46d7
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	push bc
	ld hl, $0010
	add hl, bc
	ld d, [hl]
	ld hl, $0011
	add hl, bc
	ld e, [hl]
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	ld b, a
	ld a, $2
	ld hl, $407e
	rst FarCall
	pop bc
	ld hl, $0005
	add hl, bc
	res 2, [hl]
	call Function4600
	ld hl, $0007
	add hl, bc
	ld [hl], $ff
	ld hl, $0009
	add hl, bc
	ld [hl], $1
	ret
; 4f04

Function4f04: ; 4f04
	ld hl, $001d
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $0000
	add hl, de
	ld a, [hl]
	and a
	jr z, .asm_4f30
	ld hl, $0017
	add hl, de
	ld a, [hl]
	ld hl, $0017
	add hl, bc
	ld [hl], a
	ld hl, $0018
	add hl, de
	ld a, [hl]
	ld hl, $0018
	add hl, bc
	ld [hl], a
	ld hl, $000a
	add hl, bc
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz

.asm_4f30
	jp Function4357
; 4f33

Function4f33: ; 4f33
	call Function47a8
	dw Function4f3a
	dw Function4f43
; 4f3a

Function4f3a: ; 4f3a
	xor a
	ld hl, $001d
	add hl, bc
	ld [hl], a
	call Function47a2
	; fallthrough
; 4f43

Function4f43: ; 4f43
	ld hl, $001d
	add hl, bc
	ld d, [hl]
	ld a, [$d14f]
	sub d
	ld [$d14f], a
	ld hl, $000a
	add hl, bc
	dec [hl]
	jr z, .asm_4f68
	ld a, [hl]
	call Function4f6c
	ld hl, $001d
	add hl, bc
	ld [hl], a
	ld d, a
	ld a, [$d14f]
	add d
	ld [$d14f], a
	ret

.asm_4f68
	call Function4357
	ret
; 4f6c

Function4f6c: ; 4f6c
	ld hl, $001e
	add hl, bc
	and 1
	ld a, [hl]
	ret z
	cpl
	inc a
	ret
; 4f77

Function4f77: ; 4f77
	call Function47a8 ; ????
; 4f7a

Function4f7a: ; 4f7a
	call Function47a8
	dw Function4f83
	dw Function4f83
	dw Function4f83
; 4f83

Function4f83: ; 4f83
	call Function47a8
	dw Function4f8a
	dw Function4f99
; 4f8a

Function4f8a: ; 4f8a
	ld hl, $000b
	add hl, bc
	ld [hl], $10
	ld hl, $000a
	add hl, bc
	ld [hl], $10
	call Function47a2
; 4f99

Function4f99: ; 4f99
	ld hl, $000a
	add hl, bc
	dec [hl]
	ret nz
	ld hl, $001a
	add hl, bc
	ld [hl], $60
	ld hl, $000c
	add hl, bc
	ld [hl], $0
	ld hl, $0009
	add hl, bc
	ld [hl], $1
	ret
; 4fb2

Function4fb2: ; 4fb2
	ret
; 4fb3

Function4fb3: ; 4fb3
	ld hl, $001d
	add hl, bc
	inc [hl]
	ld a, [hl]
	srl a
	srl a
	and 7
	ld l, a
	ld h, 0
	ld de, .y
	add hl, de
	ld a, [hl]
	ld hl, $001a
	add hl, bc
	ld [hl], a
	ret
; 4fcd

.y ; 4fcd
	db 0, -1, -2, -3, -4, -3, -2, -1
; 4fd5

UpdateJumpPosition: ; 4fd5
	call Function46e9
	ld a, h
	ld hl, $001f
	add hl, bc
	ld e, [hl]
	add e
	ld [hl], a
	nop
	srl e
	ld d, 0
	ld hl, .y
	add hl, de
	ld a, [hl]
	ld hl, $001a
	add hl, bc
	ld [hl], a
	ret
; 4ff0

.y ; 4ff0
	db  -4,  -6,  -8, -10, -11, -12, -12, -12
	db -11, -10,  -9,  -8,  -6,  -4,   0,   0
; 5000

Function5000: ; 5000
	ld a, [$c2de]
	ld hl, $c2df
	ld [hl], a
	ld a, $3e
	ld [$c2de], a
	ld a, [hl]
	ret
; 500e

Function500e: ; 500e
	ld hl, $c2e3
	call Function1aae
	ret
; 5015

Function5015: ; 5015
	ld hl, $001b
	add hl, bc
	ld e, [hl]
	inc [hl]
	ld d, 0
	ld hl, $c2e2
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld a, [hl]
	ret
; 5026

Function5026: ; 5026
	ld hl, $001b
	add hl, bc
	ld e, [hl]
	inc [hl]
	ld d, 0
	ld hl, $c2e6
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld a, [hl]
	ret
; 5037

Function5037: ; 5037
	ld hl, Function503d
	jp Function5041
; 503d

Function503d: ; 503d
	ld a, [$c2e2]
	ret
; 5041

Function5041: ; 5041
	call Function5055
.asm_5044
	xor a
	ld [$c2ea], a
	call Function505e
	call Function506b
	ld a, [$c2ea]
	and a
	jr nz, .asm_5044
	ret
; 5055

Function5055: ; 5055
	ld a, l
	ld [$c2eb], a
	ld a, h
	ld [$c2ec], a
	ret
; 505e

Function505e: ; 505e
	ld hl, $c2eb
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 5065

Function5065: ; 5065
	ld a, $1
	ld [$c2ea], a
	ret
; 506b

Function506b: ; 506b
	push af
	call Function54b8
	pop af
	ld hl, MovementPointers
	rst JumpTable
	ret
; 5075


; 5075
INCLUDE "engine/movement.asm"
; 54b8


Function54b8: ; 54b8
	ld e, a
	ld a, [$d4ce]
	cp $ff
	ret z
	ld a, [$d4cd]
	ld d, a
	ld a, [hConnectionStripLength]
	cp d
	ret nz
	ld a, e
	cp $3e
	ret z
	cp $47
	ret z
	cp $4b
	ret z
	cp $50
	ret z
	cp $8
	ret c
	push af
	ld hl, $d4d0
	inc [hl]
	ld e, [hl]
	ld d, 0
	ld hl, $d4d1
	add hl, de
	pop af
	ld [hl], a
	ret
; 54e6

Function54e6: ; 54e6
	ld hl, $d4d0
	ld a, [hl]
	and a
	jr z, .asm_5503
	cp $ff
	jr z, .asm_5503
	dec [hl]
	ld e, a
	ld d, 0
	ld hl, $d4d1
	add hl, de
	inc e
	ld a, $ff
.asm_54fc
	ld d, [hl]
	ld [hld], a
	ld a, d
	dec e
	jr nz, .asm_54fc
	ret

.asm_5503
	call Function550a
	ret c
	ld a, $3e
	ret
; 550a

Function550a: ; 550a
	ld a, [$d4cd]
	cp $ff
	jr z, .asm_5520
	push bc
	call Function1ae5
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	pop bc
	and a
	jr z, .asm_5520
	and a
	ret

.asm_5520
	ld a, $ff
	ld [$d4ce], a
	ld a, $47
	scf
	ret
; 5529

Function5529: ; 5529
	push bc
	ld de, .data_5535
	call Function55b9
	call Function55ac
	pop bc
	ret

.data_5535
	db $00, $05, $1b
; 5538

Function5538: ; 5538
	push bc
	ld de, .data_5544
	call Function55b9
	call Function55ac
	pop bc
	ret

.data_5544
	db $00, $05, $22
; 5547

Function5547: ; 5547
	push bc
	ld de, .data_5553
	call Function55b9
	call Function55ac
	pop bc
	ret

.data_5553
	db $00, $05, $1c
; 5556

Function5556: ; 5556
	push bc
	ld de, .data_5562
	call Function55b9
	call Function55ac
	pop bc
	ret

.data_5562
	db $00, $06, $23
; 5565

Function5565: ; 5565
	push bc
	push af
	ld de, .data_5576
	call Function55b9
	pop af
	ld [$c2f5], a
	call Function55ac
	pop bc
	ret

.data_5576
	db $00, $05, $1d
; 5579

Function5579: ; 5579
	push bc
	ld a, [hConnectionStripLength]
	ld c, a
	call Function5582
	pop bc
	ret
; 5582

Function5582: ; 5582
	ld de, $d4d6
	ld a, $d
.asm_5587
	push af
	ld hl, $0004
	add hl, de
	bit 7, [hl]
	jr z, .asm_55a1
	ld hl, $0000
	add hl, de
	ld a, [hl]
	and a
	jr z, .asm_55a1
	push bc
	xor a
	ld bc, $0028
	call ByteFill
	pop bc

.asm_55a1
	ld hl, $0028
	add hl, de
	ld d, h
	ld e, l
	pop af
	dec a
	jr nz, .asm_5587
	ret
; 55ac

Function55ac: ; 55ac
	call Function1a13
	ret nc
	ld d, h
	ld e, l
	ld a, $2
	ld hl, $4286
	rst FarCall
	ret
; 55b9

Function55b9: ; 55b9
	ld hl, $c2f0
	ld [hl], $ff
	inc hl
	ld [hl], $ff
	inc hl
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hli], a
	ld a, [hConnectionStripLength]
	ld [hli], a
	push hl
	ld hl, $0010
	add hl, bc
	ld d, [hl]
	ld hl, $0011
	add hl, bc
	ld e, [hl]
	pop hl
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl
	ld [hl], $ff
	ret
; 55e0

Function55e0: ; 55e0
	ld a, [VramState]
	bit 0, a
	ret z
	ld bc, $d4d6
	xor a
.asm_55ea
	ld [hConnectionStripLength], a
	call Function1af1
	jr z, .asm_55f4
	call Function565c

.asm_55f4
	ld hl, $0028
	add hl, bc
	ld b, h
	ld c, l
	ld a, [hConnectionStripLength]
	inc a
	cp $d
	jr nz, .asm_55ea
	ret
; 5602

Function5602: ; 5602
	call Function5645
	ld a, $0
	call Function5629
	ld a, [$d459]
	bit 7, a
	jr z, .asm_5619
	ld a, [$ffe0]
	and a
	jr z, .asm_5619
	call Function5629

.asm_5619
	call Function5920
	ret
; 561d

Function561d: ; 561d
	call Function5645
	ld a, $0
	call Function5629
	call Function5920
	ret
; 5629

Function5629: ; 5629
	cp $10
	ret nc
	call GetMapObject
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	cp $ff
	ret z
	cp $d
	ret nc
	call Function1ae5
	call Function1af1
	ret z
	call Function5673
	ret
; 5645

Function5645: ; 5645
	xor a
	ld bc, $d4d6
.asm_5649
	ld [hConnectionStripLength], a
	call Function5680
	ld hl, $0028
	add hl, bc
	ld b, h
	ld c, l
	ld a, [hConnectionStripLength]
	inc a
	cp $d
	jr nz, .asm_5649
	ret
; 565c

Function565c: ; 565c
	push bc
	call Function56cd
	pop bc
	jr c, Function5680
	call Function56a3
	jr c, Function5680
	call Function5688
	callba Function4440
	xor a
	ret
; 5673

Function5673: ; 5673
	call Function56a3
	jr c, Function5680
	callba Function4440
	xor a
	ret
; 5680

Function5680: ; 5680
	ld hl, $000d
	add hl, bc
	ld [hl], $ff
	scf
	ret
; 5688

Function5688: ; 5688
	push bc
	ld hl, $0010
	add hl, bc
	ld d, [hl]
	ld hl, $0011
	add hl, bc
	ld e, [hl]
	call Function2a3c
	pop bc
	ld hl, $000e
	add hl, bc
	ld [hl], a
	callba Function463f
	ret
; 56a3

Function56a3: ; 56a3
	ld hl, $0010
	add hl, bc
	ld d, [hl]
	ld hl, $0011
	add hl, bc
	ld e, [hl]
	inc d
	inc e
	ld a, [XCoord]
	cp d
	jr z, .asm_56bc
	jr nc, .asm_56cb
	add $b
	cp d
	jr c, .asm_56cb

.asm_56bc
	ld a, [YCoord]
	cp e
	jr z, .asm_56c9
	jr nc, .asm_56cb
	add $a
	cp e
	jr c, .asm_56cb

.asm_56c9
	xor a
	ret

.asm_56cb
	scf
	ret
; 56cd

Function56cd: ; 56cd
	ld a, [$d14c]
	ld d, a
	ld hl, $0019
	add hl, bc
	ld a, [hl]
	ld hl, $0017
	add hl, bc
	add [hl]
	add d
	cp $f0
	jr nc, .asm_56e5
	cp $a0
	jp nc, .asm_5768

.asm_56e5
	and $7
	ld d, $2
	cp $4
	jr c, .asm_56ef
	ld d, $3

.asm_56ef
	ld a, [hl]
	srl a
	srl a
	srl a
	cp $14
	jr c, .asm_56fc
	sub $20

.asm_56fc
	ld [$ffbd], a
	ld a, [$d14d]
	ld e, a
	ld hl, $001a
	add hl, bc
	ld a, [hl]
	ld hl, $0018
	add hl, bc
	add [hl]
	add e
	cp $f0
	jr nc, .asm_5715
	cp $90
	jr nc, .asm_5768

.asm_5715
	and $7
	ld e, $2
	cp $4
	jr c, .asm_571f
	ld e, $3

.asm_571f
	ld a, [hl]
	srl a
	srl a
	srl a
	cp $12
	jr c, .asm_572c
	sub $20

.asm_572c
	ld [$ffbe], a
	ld hl, $0006
	add hl, bc
	bit 7, [hl]
	jr z, .asm_573e
	ld a, d
	add $2
	ld d, a
	ld a, e
	add $2
	ld e, a

.asm_573e
	ld a, d
	ld [$ffbf], a
.asm_5741
	ld a, [$ffbf]
	ld d, a
	ld a, [$ffbe]
	add e
	dec a
	cp $12
	jr nc, .asm_5763
	ld b, a
.asm_574d
	ld a, [$ffbd]
	add d
	dec a
	cp $14
	jr nc, .asm_5760
	ld c, a
	push bc
	call Function1d05
	pop bc
	ld a, [hl]
	cp $60
	jr nc, .asm_5768

.asm_5760
	dec d
	jr nz, .asm_574d

.asm_5763
	dec e
	jr nz, .asm_5741
	and a
	ret

.asm_5768
	scf
	ret
; 576a

Function576a: ; 576a
	call Function5771
	call Function5781
	ret
; 5771

Function5771: ; 5771
	xor a
	ld [$d14e], a
	ld [$d14f], a
	ld [$d150], a
	ld a, $ff
	ld [$d151], a
	ret
; 5781

Function5781: ; 5781
	ld bc, $d4d6
	xor a
.asm_5785
	ld [hConnectionStripLength], a
	call Function1af1
	jr z, .asm_578f
	call Function437b

.asm_578f
	ld hl, $0028
	add hl, bc
	ld b, h
	ld c, l
	ld a, [hConnectionStripLength]
	inc a
	cp $d
	jr nz, .asm_5785
	ret
; 579d

Function579d: ; 579d
	ld a, $3e
	ld [$c2de], a
	ld [$c2df], a
	xor a
	ld [$d04e], a
	ld [$d4e2], a
	call Function57bc
	ld a, $5
	ld hl, $49c6
	rst FarCall
	call c, Function57d9
	call Function57ca
	ret
; 57bc

Function57bc: ; 57bc
	ld hl, $d45b
	bit 7, [hl]
	jr nz, .asm_57c4
	ret

.asm_57c4
	ld a, $0
	ld [$d4e1], a
	ret
; 57ca

Function57ca: ; 57ca
	ld hl, $d45b
	bit 5, [hl]
	ret z
	ld a, [$d45b]
	and $3
	add a
	add a
	jr Function57db
; 57d9

Function57d9: ; 57d9
	ld a, $0
	; fallthrough
; 57db

Function57db: ; 57db
	ld bc, $d4d6
	call Function1af8
	ret
; 57e2

Function57e2: ; 57e2
	ld a, d
	and $80
	ret z
	ld bc, $0000
	ld hl, $0008
	add hl, bc
	ld a, [hl]
	or d
	ld [hl], a
	ld a, d
	swap a
	and $7
	ld d, a
	ld bc, $d4d6
	ld hl, $0006
	add hl, bc
	ld a, [hl]
	and $f8
	or d
	ld [hl], a
	ret
; 5803

Function5803: ; 5803
	push bc
	ld a, b
	call Function5815
	pop bc
	ret c
	ld a, c
	call Function582c
	ld a, $2
	ld hl, $448a
	rst FarCall
	ret
; 5815

Function5815: ; 5815
	call Function18de
	ret c
	ld a, [hConnectedMapWidth]
	ld [$d4cd], a
	ret
; 581f

Function581f: ; 581f
	call Function5826
	call Function5847
	ret
; 5826

Function5826: ; 5826
	ld a, $ff
	ld [$d4cd], a
	ret
; 582c

Function582c: ; 582c
	push af
	call Function5847
	pop af
	call Function18de
	ret c
	ld hl, $0003
	add hl, bc
	ld [hl], $13
	ld hl, $0009
	add hl, bc
	ld [hl], $0
	ld a, [hConnectedMapWidth]
	ld [$d4ce], a
	ret
; 5847

Function5847: ; 5847
	ld a, [$d4ce]
	cp $ff
	ret z
	call Function1ae5
	callba Function58e3
	ld a, $ff
	ld [$d4ce], a
	ret
; 585c

Function585c: ; 585c
	ld a, c
	call Function18de
	ret c
	push bc
	call Function587a
	pop bc
	ld hl, $0005
	add hl, bc
	res 5, [hl]
	xor a
	ret
; 586e

Function586e: ; 586e
	call Function18de
	ret c
	ld hl, $0005
	add hl, bc
	set 5, [hl]
	xor a
	ret
; 587a

Function587a: ; 587a
	ld bc, $d4d6
	xor a
.asm_587e
	push af
	call Function1af1
	jr z, .asm_588a
	ld hl, $0005
	add hl, bc
	set 5, [hl]

.asm_588a
	ld hl, $0028
	add hl, bc
	ld b, h
	ld c, l
	pop af
	inc a
	cp $d
	jr nz, .asm_587e
	ret
; 5897

Function5897: ; 5897
	ld a, [$d4cd]
	cp $ff
	ret z
	push bc
	call Function1ae5
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	pop bc
	cp c
	ret nz
	ld a, [$d4ce]
	cp $ff
	ret z
	call Function1ae5
	ld hl, $0005
	add hl, bc
	res 5, [hl]
	ret
; 58b9

Function58b9: ; 58b9
	push bc
	ld bc, $d4d6
	xor a
.asm_58be
	push af
	call Function1af1
	jr z, .asm_58ca
	ld hl, $0005
	add hl, bc
	res 5, [hl]

.asm_58ca
	ld hl, $0028
	add hl, bc
	ld b, h
	ld c, l
	pop af
	inc a
	cp $d
	jr nz, .asm_58be
	pop bc
	ret
; 58d8

Function58d8: ; 58d8
	call Function18de
	ret c
	ld hl, $0005
	add hl, bc
	res 5, [hl]
	ret
; 58e3

Function58e3: ; 58e3
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	cp $ff
	jp z, Function5903
	push bc
	call GetMapObject
	ld hl, $0004
	add hl, bc
	ld a, [hl]
	pop bc
	ld hl, $0003
	add hl, bc
	ld [hl], a
	ld hl, $0009
	add hl, bc
	ld [hl], $0
	ret
; 5903

Function5903: ; 5903
	call GetSpriteDirection
	rrca
	rrca
	ld e, a
	ld d, 0
	ld hl, .data_591c
	add hl, de
	ld a, [hl]
	ld hl, $0003
	add hl, bc
	ld [hl], a
	ld hl, $0009
	add hl, bc
	ld [hl], $0
	ret

.data_591c
	db 6, 7, 8, 9
; 5920

Function5920: ; 5920
	ld a, [VramState]
	bit 0, a
	ret z
	xor a
	ld [$ffbd], a
	ld a, [hOAMUpdate]
	push af
	ld a, $1
	ld [hOAMUpdate], a
	call Function5991
	call Function593a
	pop af
	ld [hOAMUpdate], a
	ret
; 593a

Function593a: ; 593a
	ld a, [VramState]
	bit 1, a
	ld b, $a0
	jr z, .asm_5945
	ld b, $70

.asm_5945
	ld a, [$ffbd]
	cp b
	ret nc
	ld l, a
	ld h, $c4
	ld de, $0004
	ld a, b
	ld c, $a0
.asm_5952
	ld [hl], c
	add hl, de
	cp l
	jr nz, .asm_5952
	ret
; 5958

Function5958: ; 5958
	push hl
	push de
	push bc
	ld a, [$d14c]
	ld d, a
	ld a, [$d14d]
	ld e, a
	ld bc, $d4d6
	ld a, $d
.asm_5968
	push af
	call Function1af1
	jr z, .asm_597c
	ld hl, $0017
	add hl, bc
	ld a, [hl]
	add d
	ld [hl], a
	ld hl, $0018
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a

.asm_597c
	ld hl, $0028
	add hl, bc
	ld b, h
	ld c, l
	pop af
	dec a
	jr nz, .asm_5968
	xor a
	ld [$d14c], a
	ld [$d14d], a
	pop bc
	pop de
	pop hl
	ret
; 5991

Function5991: ; 5991
	call Function59a4
	ld c, $30
	call Function59f3
	ld c, $20
	call Function59f3
	ld c, $10
	call Function59f3
	ret
; 59a4

Function59a4: ; 59a4
	xor a
	ld hl, $c2eb
	ld bc, $000d
	call ByteFill
	ld d, 0
	ld bc, $d4d6
	ld hl, $c2eb
.asm_59b6
	push hl
	call Function1af1
	jr z, .asm_59d9
	ld hl, $000d
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .asm_59d9
	ld e, $10
	ld hl, $0005
	add hl, bc
	bit 0, [hl]
	jr nz, .asm_59e2
	ld e, $20
	bit 1, [hl]
	jr z, .asm_59e2
	ld e, $30
	jr .asm_59e2

.asm_59d9
	ld hl, $0028
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	jr .asm_59ec

.asm_59e2
	ld hl, $0028
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	ld a, d
	or e
	ld [hli], a

.asm_59ec
	inc d
	ld a, d
	cp $d
	jr nz, .asm_59b6
	ret
; 59f3

Function59f3: ; 59f3
	ld hl, $c2eb
.asm_59f6
	ld a, [hli]
	ld d, a
	and $f0
	ret z
	cp c
	jr nz, .asm_59f6
	push bc
	push hl
	ld a, d
	and $f
	call Function5ac2
	call Function5a0d
	pop hl
	pop bc
	jr .asm_59f6
; 5a0d

Function5a0d: ; 5a0d
	ld hl, $0002
	add hl, bc
	ld a, [hl]
	and $7f
	ld [$ffc1], a
	xor a
	bit 7, [hl]
	jr nz, .asm_5a1d
	or $8

.asm_5a1d
	ld hl, $0005
	add hl, bc
	ld e, [hl]
	bit 7, e
	jr z, .asm_5a28
	or $80

.asm_5a28
	bit 4, e
	jr z, .asm_5a2e
	or $10

.asm_5a2e
	ld hl, $0006
	add hl, bc
	ld d, a
	ld a, [hl]
	and $7
	or d
	ld d, a
	xor a
	bit 3, e
	jr z, .asm_5a3f
	or $80

.asm_5a3f
	ld [$ffc2], a
	ld hl, $0017
	add hl, bc
	ld a, [hl]
	ld hl, $0019
	add hl, bc
	add [hl]
	add $8
	ld e, a
	ld a, [$d14c]
	add e
	ld [$ffbf], a
	ld hl, $0018
	add hl, bc
	ld a, [hl]
	ld hl, $001a
	add hl, bc
	add [hl]
	add $c
	ld e, a
	ld a, [$d14d]
	add e
	ld [$ffc0], a

	ld hl, $000d
	add hl, bc
	ld a, [hl]
	cp $ff
	jp z, .asm_5abe
	cp $20
	jp nc, .asm_5abe

	ld l, a
	ld h, 0
	add hl, hl
	ld bc, DataPointers4049
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [$ffbd]
	ld c, a
	ld b, Sprites / $100
	ld a, [hli]
	ld [$ffbe], a
	add c
	cp SpritesEnd % $100
	jr nc, .full

.loop
	ld a, [$ffc0]
	add [hl]
	inc hl
	ld [bc], a
	inc c
	ld a, [$ffbf]
	add [hl]
	inc hl
	ld [bc], a
	inc c
	ld e, [hl]
	inc hl
	ld a, [$ffc1]
	bit 2, e
	jr z, .asm_5aa3
	xor a
.asm_5aa3
	add [hl]
	inc hl
	ld [bc], a
	inc c
	ld a, e
	bit 1, a
	jr z, .asm_5aaf
	ld a, [$ffc2]
	or e
.asm_5aaf
	and $f0
	or d
	ld [bc], a
	inc c
	ld a, [$ffbe]
	dec a
	ld [$ffbe], a
	jr nz, .loop

	ld a, c
	ld [$ffbd], a

.asm_5abe
	xor a
	ret

.full
	scf
	ret
; 5ac2

Function5ac2: ; 5ac2
	ld c, a
	ld b, 0
	ld hl, .Addresses
	add hl, bc
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ret
; 5ace

.Addresses ; 5ace
	dw $d4d6
	dw $d4fe
	dw $d526
	dw $d54e
	dw $d576
	dw $d59e
	dw $d5c6
	dw $d5ee
	dw $d616
	dw $d63e
	dw $d666
	dw $d68e
	dw $d6b6
; 5ae8

Function5ae8: ; 5ae8
	ld de, MUSIC_NONE
	call StartMusic
	call DelayFrame
	ld de, MUSIC_MAIN_MENU
	ld a, e
	ld [CurMusic], a
	call StartMusic
	ld a, $12
	ld hl, $5cdc
	rst FarCall
	jp $6219
; 5b04

Function5b04: ; 5b04
	ret
; 5b05

Function5b05: ; 5b05
	push de
	ld hl, .Days
	ld a, b
	call GetNthString
	ld d, h
	ld e, l
	pop hl
	call PlaceString
	ld h, b
	ld l, c
	ld de, .Day
	call PlaceString
	ret
; 5b1c

.Days ; 5b1c
	db "SUN@"
	db "MON@"
	db "TUES@"
	db "WEDNES@"
	db "THURS@"
	db "FRI@"
	db "SATUR@"
; 5b40

.Day ; 5b40
	db "DAY@"
; 5b44

Function5b44: ; 5b44
	xor a
	ld [$ffde], a
	call ClearTileMap
	call Functione5f
	call Functione51
	call Function1fbf
	ret
; 5b54

MysteryGift: ; 5b54
	call UpdateTime
	ld a, $4
	ld hl, $5548
	rst FarCall
	ld a, $41
	ld hl, $48ba
	rst FarCall
	ret
; 5b64

OptionsMenu: ; 5b64
	callba _OptionsMenu
	ret
; 5b6b

NewGame: ; 5b6b
	xor a
	ld [$c2cc], a
	call Function5ba7
	call Function5b44
	call Function5b8f
	call OakSpeech
	call Function5d23
	ld a, $1
	ld [$c2d8], a
	ld a, $0
	ld [$d001], a
	ld a, $f1
	ld [$ff9f], a
	jp Function5e5d
; 5b8f

Function5b8f: ; 5b8f
	ld a, $41
	ld hl, $632f
	rst FarCall
	jr c, .asm_5b9e
	ld a, $12
	ld hl, $4dcb
	rst FarCall
	ret

.asm_5b9e
	ld c, $0
	ld a, $12
	ld hl, $402f
	rst FarCall
	ret
; 5ba7

Function5ba7: ; 5ba7
	xor a
	ld [hBGMapMode], a
	call Function5bae
	ret
; 5bae

Function5bae: ; 5bae

	ld hl, Sprites
	ld bc, Options - Sprites
	xor a
	call ByteFill

	ld hl, $d000
	ld bc, PlayerID - $d000
	xor a
	call ByteFill

	ld hl, PlayerID
	ld bc, $dff5 - PlayerID
	xor a
	call ByteFill

	ld a, [rLY]
	ld [$ffe3], a
	call DelayFrame
	ld a, [hRandomSub]
	ld [PlayerID], a

	ld a, [rLY]
	ld [$ffe3], a
	call DelayFrame
	ld a, [hRandomAdd]
	ld [PlayerID + 1], a

	call Random
	ld [$d84a], a
	call DelayFrame
	call Random
	ld [$d84b], a

	ld hl, PartyCount
	call Function5ca1

	xor a
	ld [$db72], a
	ld [$d4b4], a

	call Function5ca6

	ld a, 1
	call GetSRAMBank
	ld hl, BoxCount
	call Function5ca1
	call CloseSRAM
	
	ld hl, NumItems
	call Function5ca1

	ld hl, NumKeyItems
	call Function5ca1

	ld hl, NumBalls
	call Function5ca1

	ld hl, PCItems
	call Function5ca1

	xor a
	ld [RoamMon1Species], a
	ld [RoamMon2Species], a
	ld [RoamMon3Species], a
	ld a, -1
	ld [RoamMon1MapGroup], a
	ld [RoamMon2MapGroup], a
	ld [RoamMon3MapGroup], a
	ld [RoamMon1MapNumber], a
	ld [RoamMon2MapNumber], a
	ld [RoamMon3MapNumber], a

	ld a, 0
	call GetSRAMBank
	ld hl, $abe2
	xor a
	ld [hli], a
	dec a
	ld [hl], a
	call CloseSRAM

	call Function5d33
	call Function5cd3

	xor a
	ld [MonType], a

	ld [JohtoBadges], a
	ld [KantoBadges], a

	ld [Coins], a
	ld [Coins + 1], a

	ld [Money], a
	ld a, 3000 >> 8
	ld [Money + 1], a
	ld a, 3000 & $ff
	ld [Money + 2], a

	xor a
	ld [$dc17], a

	ld hl, $dc19
	ld [hl], $0
	inc hl
	ld [hl], $8
	inc hl
	ld [hl], $fc

	call Function5ce9

	ld a, $9
	ld hl, $6751
	rst FarCall

	ld a, $11
	ld hl, $4765
	rst FarCall

	ld a, $41
	ld hl, $61c0
	rst FarCall

	call ResetGameTime
	ret
; 5ca1

Function5ca1: ; 5ca1
	xor a
	ld [hli], a
	dec a
	ld [hl], a
	ret
; 5ca6

Function5ca6: ; 5ca6
	ld hl, Box1Name
	ld c, $0
.asm_5cab
	push hl
	ld de, .Box
	call CopyName2
	dec hl
	ld a, c
	inc a
	cp $a
	jr c, .asm_5cbe
	sub $a
	ld [hl], $f7
	inc hl

.asm_5cbe
	add $f6
	ld [hli], a
	ld [hl], $50
	pop hl
	ld de, $0009
	add hl, de
	inc c
	ld a, c
	cp $e
	jr c, .asm_5cab
	ret

.Box
	db "BOX@"
; 5cd3

Function5cd3: ; 5cd3
	ld hl, $dfe8
	ld a, $3
	ld [hli], a
	ld a, $6
	ld [hli], a
	ld de, .Ralph
	call CopyName2
	ret
; 5ce3

.Ralph ; 5ce3
	db "RALPH@"
; 5ce9

Function5ce9: ; 5ce9
	ld hl, .Rival
	ld de, RivalName
	call .Copy

	ld hl, .Mom
	ld de, MomsName
	call .Copy

	ld hl, .Red
	ld de, RedsName
	call .Copy

	ld hl, .Green
	ld de, GreensName

.Copy
	ld bc, $000b
	call CopyBytes
	ret

.Rival
	db "???@"
.Red
	db "RED@"
.Green
	db "GREEN@"
.Mom
	db "MOM@"
; 5d23

Function5d23: ; 5d23
	call Function610f
	ld a, $2
	ld hl, $4029
	rst FarCall
	ld a, $4
	ld hl, $53d6
	rst FarCall
	ret
; 5d33

Function5d33: ; 5d33
	ld a, $0
	call GetSRAMBank
	ld a, [CurDay]
	inc a
	ld b, a
	ld a, [$ac68]
	cp b
	ld a, [$ac6a]
	ld c, a
	ld a, [$ac69]
	jr z, .asm_5d55
	ld a, b
	ld [$ac68], a
	call Random
	ld c, a
	call Random

.asm_5d55
	ld [$dc9f], a
	ld [$ac69], a
	ld a, c
	ld [$dca0], a
	ld [$ac6a], a
	jp CloseSRAM
; 5d65

Continue: ; 5d65
	ld a, $5
	ld hl, $4ea5
	rst FarCall
	jr c, .asm_5dd6
	ld a, $5
	ld hl, $50b9
	rst FarCall
	call Function1d6e
	call Function5e85
	ld a, $1
	ld [hBGMapMode], a
	ld c, $14
	call DelayFrames
	call Function5e34
	jr nc, .asm_5d8c
	call Function1c17
	jr .asm_5dd6

.asm_5d8c
	call Function5e48
	jr nc, .asm_5d96
	call Function1c17
	jr .asm_5dd6

.asm_5d96
	ld a, $8
	ld [MusicFade], a
	ld a, MUSIC_NONE % $100
	ld [MusicFadeIDLo], a
	ld a, MUSIC_NONE / $100
	ld [MusicFadeIDHi], a
	call WhiteBGMap
	call Function5df0
	call Function1c17
	call ClearTileMap
	ld c, $14
	call DelayFrames
	ld a, $a
	ld hl, $6394
	rst FarCall
	ld a, $41
	ld hl, $5091
	rst FarCall
	ld a, $5
	ld hl, $40ae
	rst FarCall
	ld a, [$d4b5]
	cp $1
	jr z, .asm_5dd7
	ld a, $f2
	ld [$ff9f], a
	jp Function5e5d

.asm_5dd6
	ret

.asm_5dd7
	ld a, $e
	ld [$d001], a
	call Function5de7
	jp Function5e5d
; 5de2

Function5de2: ; 5de2
	ld a, $1a
	ld [$d001], a
; 5de7

Function5de7: ; 5de7
	xor a
	ld [$d4b5], a
	ld a, $f1
	ld [$ff9f], a
	ret
; 5df0

Function5df0: ; 5df0
	ld a, $41
	ld hl, $632f
	rst FarCall
	ret nc
	ld hl, $d479
	bit 1, [hl]
	ret nz
	ld a, $5
	ld [MusicFade], a
	ld a, MUSIC_MOBILE_ADAPTER_MENU % $100
	ld [MusicFadeIDLo], a
	ld a, MUSIC_MOBILE_ADAPTER_MENU / $100
	ld [MusicFadeIDHi], a
	ld c, 20
	call DelayFrames
	ld c, $1
	ld a, $12
	ld hl, $402f
	rst FarCall
	ld a, $5
	ld hl, $509a
	rst FarCall
	ld a, $8
	ld [MusicFade], a
	ld a, MUSIC_NONE % $100
	ld [MusicFadeIDLo], a
	ld a, MUSIC_NONE / $100
	ld [MusicFadeIDHi], a
	ld c, 35
	call DelayFrames
	ret
; 5e34

Function5e34: ; 5e34
.asm_5e34
	call DelayFrame
	call GetJoypadPublic
	ld hl, hJoyPressed
	bit 0, [hl]
	jr nz, .asm_5e47
	bit 1, [hl]
	jr z, .asm_5e34
	scf
	ret

.asm_5e47
	ret
; 5e48

Function5e48: ; 5e48
	call Function6e3
	and $80
	jr z, .asm_5e5b
	ld a, $8
	ld hl, $4021
	rst FarCall
	ld a, c
	and a
	jr z, .asm_5e5b
	scf
	ret

.asm_5e5b
	xor a
	ret
; 5e5d

Function5e5d: ; 5e5d
.asm_5e5d
	xor a
	ld [$c2c1], a
	ld [InLinkBattle], a
	ld hl, GameTimerPause
	set 0, [hl]
	res 7, [hl]
	ld hl, $d83e
	set 1, [hl]
	callba Function966b0
	ld a, [$d4b5]
	cp $2
	jr z, .asm_5e80
	jp Reset

.asm_5e80
	call Function5de2
	jr .asm_5e5d
; 5e85

Function5e85: ; 5e85
	call Function6e3
	and $80
	jr z, .asm_5e93
	ld de, $0408
	call Function5eaf
	ret

.asm_5e93
	ld de, $0408
	call Function5e9f
	ret
; 5e9a

Function5e9a: ; 5e9a
	ld de, $0400
	jr Function5e9f
; 5e9f

Function5e9f: ; 5e9f
	call Function5ebf
	call Function5f1c
	call Function5f40
	call Functione5f
	call Function1ad2
	ret
; 5eaf

Function5eaf: ; 5eaf
	call Function5ebf
	call Function5f1c
	call Function5f48
	call Functione5f
	call Function1ad2
	ret
; 5ebf

Function5ebf: ; 5ebf
	xor a
	ld [hBGMapMode], a
	ld hl, MenuDataHeader_0x5ed9
	ld a, [StatusFlags]
	bit 0, a ; pokedex
	jr nz, .asm_5ecf
	ld hl, MenuDataHeader_0x5efb

.asm_5ecf
	call Function1e35
	call Function1cbb
	call Function1c89
	ret
; 5ed9

MenuDataHeader_0x5ed9: ; 5ed9
	db $40 ; flags
	db 00, 00 ; start coords
	db 09, 15 ; end coords
	dw MenuData2_0x5ee1
	db 1 ; default option
; 5ee1

MenuData2_0x5ee1: ; 5ee1
	db $00 ; flags
	db 4 ; items
	db "PLAYER@"
	db "BADGES@"
	db "#DEX@"
	db "TIME@"
; 5efb

MenuDataHeader_0x5efb: ; 5efb
	db $40 ; flags
	db 00, 00 ; start coords
	db 09, 15 ; end coords
	dw MenuData2_0x5f03
	db 1 ; default option
; 5f03

MenuData2_0x5f03: ; 5f03
	db $00 ; flags
	db 4 ; items
	db "PLAYER ", $52, "@"
	db "BADGES@"
	db " @"
	db "TIME@"
; 5f1c


Function5f1c: ; 5f1c
	call Function1cfd
	push hl
	ld de, $005d
	add hl, de
	call Function5f58
	pop hl
	push hl
	ld de, $0084
	add hl, de
	call Function5f6b
	pop hl
	push hl
	ld de, $0030
	add hl, de
	ld de, .Player
	call PlaceString
	pop hl
	ret

.Player
	db $52, "@"
; 5f40

Function5f40: ; 5f40
	ld de, $00a9
	add hl, de
	call Function5f84
	ret
; 5f48

Function5f48: ; 5f48
	ld de, $00a9
	add hl, de
	ld de, .text_5f53
	call PlaceString
	ret

.text_5f53
	db " ???@"
; 5f58

Function5f58: ; 5f58
	push hl
	ld hl, JohtoBadges
	ld b, $2
	call CountSetBits
	pop hl
	ld de, $d265
	ld bc, $0102
	jp PrintNum
; 5f6b

Function5f6b: ; 5f6b
	ld a, [StatusFlags]
	bit 0, a
	ret z
	push hl
	ld hl, PokedexSeen
	ld b, $20
	call CountSetBits
	pop hl
	ld de, $d265
	ld bc, $0103
	jp PrintNum
; 5f84

Function5f84: ; 5f84
	ld de, GameTimeHours
	ld bc, $0203
	call PrintNum
	ld [hl], $6d
	inc hl
	ld de, GameTimeMinutes
	ld bc, $8102
	jp PrintNum
; 5f99


OakSpeech: ; 0x5f99
	ld a, $24
	ld hl, $4672
	rst FarCall
	call Function4dd
	call ClearTileMap

	ld de, MUSIC_ROUTE_30
	call StartMusic

	call Function4a3
	call Function4b6
	xor a
	ld [CurPartySpecies], a
	ld a, POKEMON_PROF
	ld [TrainerClass], a
	call Function619c

	ld b, $1c
	call GetSGBLayout
	call Function616a

	ld hl, OakText1
	call PrintText
	call Function4b6
	call ClearTileMap

	ld a, $c2
	ld [CurSpecies], a
	ld [CurPartySpecies], a
	call GetBaseData

	hlcoord 6, 4
	call Function3786

	xor a
	ld [TempMonDVs], a
	ld [$d124], a

	ld b, $1c
	call GetSGBLayout
	call Function6182

	ld hl, OakText2
	call PrintText
	ld hl, OakText4
	call PrintText
	call Function4b6
	call ClearTileMap

	xor a
	ld [CurPartySpecies], a
	ld a, POKEMON_PROF
	ld [TrainerClass], a
	call Function619c

	ld b, $1c
	call GetSGBLayout
	call Function616a

	ld hl, OakText5
	call PrintText
	call Function4b6
	call ClearTileMap

	xor a
	ld [CurPartySpecies], a
	callba DrawIntroPlayerPic

	ld b, $1c
	call GetSGBLayout
	call Function616a

	ld hl, OakText6
	call PrintText
	call NamePlayer
	ld hl, OakText7
	call PrintText
	ret

OakText1: ; 0x6045
	TX_FAR _OakText1
	db "@"

OakText2: ; 0x604a
	TX_FAR _OakText2
	start_asm
	ld a,WOOPER
	call Function37ce
	call WaitSFX
	ld hl,OakText3
	ret

OakText3: ; 0x605b
	TX_FAR _OakText3
	db "@"

OakText4: ; 0x6060
	TX_FAR _OakText4
	db "@"

OakText5: ; 0x6065
	TX_FAR _OakText5
	db "@"

OakText6: ; 0x606a
	TX_FAR _OakText6
	db "@"

OakText7: ; 0x606f
	TX_FAR _OakText7
	db "@"

NamePlayer: ; 0x6074
	callba MovePlayerPicRight
	callba ShowPlayerNamingChoices
	ld a, [$cfa9]
	dec a
	jr z, .NewName
	call Function60fa
	ld a, $2
	ld hl, $4c1d
	rst FarCall
	callba MovePlayerPicLeft
	ret

.NewName
	ld b, 1
	ld de, PlayerName
	ld a, $4
	ld hl, $56c1
	rst FarCall

	call Function4b6
	call ClearTileMap

	call Functione5f
	call WaitBGMap

	xor a
	ld [CurPartySpecies], a
	ld a, $22
	ld hl, $4874
	rst FarCall

	ld b, $1c
	call GetSGBLayout
	call Function4f0

	ld hl, PlayerName
	ld de, .Chris
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_60cf
	ld de, .Kris
.asm_60cf
	call InitName
	ret

.Chris
	db "CHRIS@@@@@@"
.Kris
	db "KRIS@@@@@@@"
; 60e9

Function60e9: ; 60e9
	call LoadMenuDataHeader
	call Function1d81
	ld a, [$cfa9]
	dec a
	call Function1db8
	call Function1c17
	ret
; 60fa

Function60fa: ; 60fa
	ld a, $50
	ld bc, $000b
	ld hl, PlayerName
	call ByteFill
	ld hl, PlayerName
	ld de, StringBuffer2
	call CopyName2
	ret
; 610f

Function610f: ; 610f

	ld a, [hROMBank]
	push af

	ld a, 0 << 7 | 32 ; fade out
	ld [MusicFade], a
	ld de, MUSIC_NONE
	ld a, e
	ld [MusicFadeIDLo], a
	ld a, d
	ld [MusicFadeIDHi], a

	ld de, SFX_ESCAPE_ROPE
	call StartSFX
	pop af
	rst Bankswitch

	ld c, 8
	call DelayFrames

	ld hl, $5249
	ld b, $13
	call Function61b4

	ld c, 8
	call DelayFrames

	ld hl, $52d9
	ld b, $13
	call Function61b4

	ld c, 8
	call DelayFrames

	ld hl, $c50a
	ld b, 7
	ld c, 7
	call ClearBox

	ld c, 3
	call DelayFrames

	call Function61cd
	call Functione5f

	ld c, 50
	call DelayFrames

	call Function4b6
	call ClearTileMap
	ret
; 616a

Function616a: ; 616a
	ld hl, IntroFadePalettes
	ld b, IntroFadePalettesEnd - IntroFadePalettes
.asm_616f
	ld a, [hli]
	call DmgToCgbBGPals
	ld c, 10
	call DelayFrames
	dec b
	jr nz, .asm_616f
	ret
; 617c

IntroFadePalettes: ; 0x617c
	db %01010100
	db %10101000
	db %11111100
	db %11111000
	db %11110100
	db %11100100
IntroFadePalettesEnd
; 6182

Function6182: ; 6182
	ld a, $77
	ld [hWX], a
	call DelayFrame
	ld a, $e4
	call DmgToCgbBGPals
.asm_618e
	call DelayFrame
	ld a, [hWX]
	sub $8
	cp $ff
	ret z
	ld [hWX], a
	jr .asm_618e
; 619c

Function619c: ; 619c
	ld de, VTiles2
	callba Function5120d
	xor a
	ld [$ffad], a
	ld hl, $c4f6
	ld bc, $0707
	ld a, $13
	call Predef
	ret
; 61b4

Function61b4: ; 61b4
	ld de, VTiles2
	ld c, $31
	ld a, $40
	call Predef
	xor a
	ld [$ffad], a
	ld hl, $c4f6
	ld bc, $0707
	ld a, $13
	call Predef
	ret
; 61cd

Function61cd: ; 61cd

	callba GetPlayerIcon
	ld c, $c
	ld hl, VTiles0
	call Request2bpp

	ld hl, Sprites
	ld de, .data_61fe
	ld a, [de]
	inc de

	ld c, a
.asm_61e4
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a

	ld b, 0
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_61f8
	ld b, 1
.asm_61f8
	ld a, b

	ld [hli], a
	dec c
	jr nz, .asm_61e4
	ret
; 61fe

.data_61fe ; 61fe
	db 4
	db $4c, $48, $00
	db $4c, $50, $01
	db $54, $48, $02
	db $54, $50, $03
; 620b


Function620b: ; 620b
	ld hl, $4579
	ld a, $39
	rst FarCall
	jr c, .asm_6219
	ld a, $39
	ld hl, Function48ac
	rst FarCall

.asm_6219
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	call TitleScreen
	call DelayFrame
.asm_6226
	call Function627b
	jr nc, .asm_6226
	call ClearSprites
	call WhiteBGMap
	pop af
	ld [rSVBK], a
	ld hl, rLCDC
	res 2, [hl]
	call Functionfdb
	call Function3200
	xor a
	ld [hLCDStatCustom], a
	ld [hSCX], a
	ld [hSCY], a
	ld a, $7
	ld [hWX], a
	ld a, $90
	ld [hWY], a
	ld b, $8
	call GetSGBLayout
	call UpdateTimePals
	ld a, [$cf64]
	cp $5
	jr c, .asm_625e
	xor a
.asm_625e
	ld e, a
	ld d, 0
	ld hl, .data_626a
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 626a

.data_626a
	dw Function5ae8
	dw Function6389
	dw Function620b
	dw Function620b
	dw Function6392
; 6274


TitleScreen: ; 6274
	callba _TitleScreen
	ret
; 627b

Function627b: ; 627b
	ld a, [$cf63]
	bit 7, a
	jr nz, .asm_6290
	call Function62a3
	ld a, $43
	ld hl, $6ea7
	rst FarCall
	call DelayFrame
	and a
	ret

.asm_6290
	scf
	ret
; 6292

Function6292: ; 6292
	ld a, [$ff9b]
	and $7
	ret nz
	ld hl, $d15f
	ld a, [hl]
	dec a
	ld bc, $0028
	call ByteFill
	ret
; 62a3

Function62a3: ; 62a3
	ld e, a
	ld d, 0
	ld hl, .data_62af
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 62af

.data_62af
	dw TitleScreenEntrance
	dw Function62f6
	dw Function6304
	dw Function6375
; 62b7

Function62b7: ; 62b7
	ld hl, $cf63
	inc [hl]
	ret
; 62bc


TitleScreenEntrance: ; 62bc

; Animate the logo:
; Move each line by 4 pixels until our count hits 0.
	ld a, [hSCX]
	and a
	jr z, .done
	sub 4
	ld [hSCX], a

; Lay out a base (all lines scrolling together).
	ld e, a
	ld hl, $d100
	ld bc, 8 * 10 ; logo height
	call ByteFill

; Alternate signage for each line's position vector.
; This is responsible for the interlaced effect.
	ld a, e
	xor $ff
	inc a

	ld b, 8 * 10 / 2 ; logo height / 2
	ld hl, $d101
.loop
	ld [hli], a
	inc hl
	dec b
	jr nz, .loop

	callba AnimateTitleCrystal
	ret

.done
; Next scene
	ld hl, $cf63
	inc [hl]
	xor a
	ld [hLCDStatCustom], a
	
; Play the title screen music.
	ld de, MUSIC_TITLE
	call StartMusic

	ld a, $88
	ld [hWY], a
	ret
; 62f6


Function62f6: ; 62f6
	ld hl, $cf63
	inc [hl]
	ld hl, $cf65
	ld de, $1140
	ld [hl], e
	inc hl
	ld [hl], d
	ret
; 6304

Function6304: ; 6304
	ld hl, $cf65
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, e
	or d
	jr z, .asm_6355
	dec de
	ld [hl], d
	dec hl
	ld [hl], e
	call GetJoypadPublic
	ld hl, hJoyDown
	ld a, [hl]
	and $46
	cp $46
	jr z, .asm_634a
	ld a, [$ffeb]
	cp $34
	jr z, .asm_6332
	ld a, [hl]
	and $86
	cp $86
	jr nz, .asm_6340
	ld a, $34
	ld [$ffeb], a
	jr .asm_6340

.asm_6332
	bit 2, [hl]
	jr nz, .asm_6340
	xor a
	ld [$ffeb], a
	ld a, [hl]
	and $60
	cp $60
	jr z, .asm_636a

.asm_6340
	ld a, [hl]
	and $9
	jr nz, .asm_6346
	ret

.asm_6346
	ld a, $0
	jr .asm_634c

.asm_634a
	ld a, $1

.asm_634c
	ld [$cf64], a
	ld hl, $cf63
	set 7, [hl]
	ret

.asm_6355
	ld hl, $cf63
	inc [hl]
	xor a
	ld [MusicFadeIDLo], a
	ld [MusicFadeIDHi], a
	ld hl, MusicFade
	ld [hl], $8
	ld hl, $cf65
	inc [hl]
	ret

.asm_636a
	ld a, $4
	ld [$cf64], a
	ld hl, $cf63
	set 7, [hl]
	ret
; 6375

Function6375: ; 6375
	ld hl, $cf65
	inc [hl]
	ld a, [MusicFade]
	and a
	ret nz
	ld a, $2
	ld [$cf64], a
	ld hl, $cf63
	set 7, [hl]
	ret
; 6389

Function6389: ; 6389
	ld a, $13
	ld hl, $554c
	rst FarCall
	jp Init
; 6392

Function6392: ; 6392
	ld a, $13
	ld hl, $53b1
	rst FarCall
	jp Init
; 639b

Function639b: ; 639b
	ld a, [$cf65]
	and $3
	ret nz
	ld bc, $c3a4
	ld hl, $000a
	add hl, bc
	ld l, [hl]
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, Data63ca
	add hl, de
	ld a, [$cf65]
	and $4
	srl a
	srl a
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	and a
	ret z
	ld e, a
	ld d, [hl]
	ld a, $1
	call Function3b2a
	ret
; 63ca

Data63ca: ; 63ca
INCBIN "baserom.gbc", $63ca, $63e2 - $63ca


Copyright: ; 63e2
	call ClearTileMap
	call Functione5f
	ld de, CopyrightGFX
	ld hl, VTiles2 + $600 ; tile $60
	ld bc, BANK(CopyrightGFX) << 8 + $1d
	call Request2bpp
	hlcoord 2, 7
	ld de, CopyrightString
	jp PlaceString
; 63fd

CopyrightString: ; 63fd
	; ©1995-2001 Nintendo
	db $60, $61, $62, $63, $64, $65, $66
	db $67, $68, $69, $6a, $6b, $6c

	db $4e

	; ©1995-2001 Creatures inc.
	db $60, $61, $62, $63, $64, $65, $66, $6d
	db $6e, $6f, $70, $71, $72, $7a, $7b, $7c

	db $4e

	; ©1995-2001 GAME FREAK inc.
	db $60, $61, $62, $63, $64, $65, $66, $73, $74
	db $75, $76, $77, $78, $79, $7a, $7b, $7c

	db "@"
; 642e

GameInit: ; 642e
	ld a, $5
	ld hl, $4f1c
	rst FarCall
	call Function1fbf
	call WhiteBGMap
	call ClearTileMap
	ld a, $98
	ld [$ffd7], a
	xor a
	ld [hBGMapAddress], a
	ld [hJoyDown], a
	ld [hSCX], a
	ld [hSCY], a
	ld a, $90
	ld [hWY], a
	call WaitBGMap
	jp Function620b
; 6454

Function6454: ; 6454
	call DelayFrame
	ld a, [hOAMUpdate]
	push af
	ld a, $1
	ld [hOAMUpdate], a
	ld a, [hBGMapMode]
	push af
	xor a
	ld [hBGMapMode], a
	call Function6473
	pop af
	ld [hBGMapMode], a
	pop af
	ld [hOAMUpdate], a
	ld hl, VramState
	set 6, [hl]
	ret
; 6473

Function6473: ; 6473
	xor a
	ld [hLCDStatCustom], a
	ld [hBGMapMode], a
	ld a, $90
	ld [hWY], a
	call Function2173
	ld a, $9c
	call Function64b9
	call Function2e20
	ld a, $12
	ld hl, $5409
	rst FarCall
	ld a, $2
	ld hl, $56a4
	rst FarCall
	ld a, $1
	ld [hCGBPalUpdate], a
	xor a
	ld [hBGMapMode], a
	ld [hWY], a
	ld a, $1
	ld hl, $64db
	rst FarCall
	ld a, $98
	call Function64b9
	xor a
	ld [$d152], a
	ld a, $98
	ld [$d153], a
	xor a
	ld [hSCX], a
	ld [hSCY], a
	call Function5958
	ret
; 64b9

Function64b9: ; 64b9
	ld [$ffd7], a
	xor a
	ld [hBGMapAddress], a
	ret
; 64bf

Function64bf: ; 64bf
	ld a, [hOAMUpdate]
	push af
	ld a, $1
	ld [hOAMUpdate], a
	call Function64cd
	pop af
	ld [hOAMUpdate], a
	ret
; 64cd

Function64cd: ; 64cd
	call Functione5f
	ld a, $90
	ld [hWY], a
	call Function2e31
	call Functione51
	ret
; 64db

Function64db: ; 64db
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	ld a, $60
	ld hl, $d000
	ld bc, VBlank5
	call ByteFill
	ld a, $d0
	ld [rHDMA1], a
	ld a, $0
	ld [rHDMA2], a
	ld a, $18
	ld [rHDMA3], a
	ld a, $0
	ld [rHDMA4], a
	ld a, $3f
	ld [hDMATransfer], a
	call DelayFrame
	pop af
	ld [rSVBK], a
	ret
; 6508

Function6508: ; 6508
	call Function309d
	ld a, [CurPartyMon]
	ld hl, PartyMon1Nickname
	call GetNick
	ld hl, StringBuffer1
	ld de, $d050
	ld bc, $000b
	call CopyBytes
	ld hl, PartyMon1Move1
	ld bc, $0030
	ld a, [CurPartyMon]
	call AddNTimes
	ld d, h
	ld e, l
	ld b, $4
.asm_6530
	ld a, [hl]
	and a
	jr z, .asm_6564
	inc hl
	dec b
	jr nz, .asm_6530
	push de
	call Function65d3
	pop de
	jp c, Function65b5
	push hl
	push de
	ld [$d265], a
	ld b, a
	ld a, [IsInBattle]
	and a
	jr z, .asm_6559
	ld a, [DisabledMove]
	cp b
	jr nz, .asm_6559
	xor a
	ld [DisabledMove], a
	ld [PlayerDisableCount], a

.asm_6559
	call GetMoveName
	ld hl, UnknownText_0x6684
	call PrintText
	pop de
	pop hl

.asm_6564
	ld a, [$d262]
	ld [hl], a
	ld bc, $0015
	add hl, bc
	push hl
	push de
	dec a
	ld hl, $5b00
	ld bc, $0007
	call AddNTimes
	ld a, $10
	call GetFarByte
	pop de
	pop hl
	ld [hl], a
	ld a, [IsInBattle]
	and a
	jp z, Function65ca
	ld a, [CurPartyMon]
	ld b, a
	ld a, [CurBattleMon]
	cp b
	jp nz, Function65ca
	ld a, [PlayerSubStatus5]
	bit 3, a
	jp nz, Function65ca
	ld h, d
	ld l, e
	ld de, BattleMonMove1
	ld bc, $0004
	call CopyBytes
	ld bc, $0011
	add hl, bc
	ld de, BattleMonPPMove1
	ld bc, $0004
	call CopyBytes
	jp Function65ca
; 65b5

Function65b5: ; 65b5
	ld hl, UnknownText_0x6675
	call PrintText
	call Function1dcf
	jp c, $6520
	ld hl, UnknownText_0x667a
	call PrintText
	ld b, $0
	ret
; 65ca

Function65ca: ; 65ca
	ld hl, UnknownText_0x666b
	call PrintText
	ld b, $1
	ret
; 65d3

Function65d3: ; 65d3
	push hl
	ld hl, UnknownText_0x667f
	call PrintText
	call Function1dcf
	pop hl
	ret c
	ld bc, $fffc
	add hl, bc
	push hl
	ld de, $d25e
	ld bc, $0004
	call CopyBytes
	pop hl
.asm_65ee
	push hl
	ld hl, UnknownText_0x6670
	call PrintText
	ld hl, $c4cd
	ld b, $8
	ld c, $d
	call TextBox
	ld hl, $c4f7
	ld a, $28
	ld [Buffer1], a
	ld a, $20
	call Predef
	ld a, $4
	ld [$cfa1], a
	ld a, $6
	ld [$cfa2], a
	ld a, [$d0eb]
	inc a
	ld [$cfa3], a
	ld a, $1
	ld [$cfa4], a
	ld [$cfa9], a
	ld [$cfaa], a
	ld a, $3
	ld [$cfa8], a
	ld a, $20
	ld [$cfa5], a
	xor a
	ld [$cfa6], a
	ld a, $20
	ld [$cfa7], a
	call Function1bc9
	push af
	call Function30b4
	pop af
	pop hl
	bit 1, a
	jr nz, .asm_6669
	push hl
	ld a, [$cfa9]
	dec a
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	push af
	push bc
	call IsHMMove
	pop bc
	pop de
	ld a, d
	jr c, .asm_6660
	pop hl
	add hl, bc
	and a
	ret

.asm_6660
	ld hl, UnknownText_0x669a
	call PrintText
	pop hl
	jr .asm_65ee

.asm_6669
	scf
	ret
; 666b

UnknownText_0x666b: ; 666b
	text_jump UnknownText_0x1c5660, BANK(UnknownText_0x1c5660)
	db "@"
; 6670

UnknownText_0x6670: ; 6670
	text_jump UnknownText_0x1c5678, BANK(UnknownText_0x1c5678)
	db "@"
; 6675

UnknownText_0x6675: ; 6675
	text_jump UnknownText_0x1c5699, BANK(UnknownText_0x1c5699)
	db "@"
; 667a

UnknownText_0x667a: ; 667a
	text_jump UnknownText_0x1c56af, BANK(UnknownText_0x1c56af)
	db "@"
; 667f

UnknownText_0x667f: ; 667f
	text_jump UnknownText_0x1c56c9, BANK(UnknownText_0x1c56c9)
	db "@"
; 6684

UnknownText_0x6684: ; 6684
	text_jump UnknownText_0x1c5740, BANK(UnknownText_0x1c5740)
	start_asm
; 6689

; 6689
	push de
	ld de, SFX_SWITCH_POKEMON
	call StartSFX
	pop de
	ld hl, UnknownText_0x6695
	ret
; 6695

UnknownText_0x6695: ; 6695
	text_jump UnknownText_0x1c574e, BANK(UnknownText_0x1c574e)
	db "@"
; 669a

UnknownText_0x669a: ; 669a
	text_jump UnknownText_0x1c5772, BANK(UnknownText_0x1c5772)
	db "@"
; 669f


CheckNickErrors: ; 669f
; error-check monster nick before use
; must be a peace offering to gamesharkers

; input: de = nick location

	push bc
	push de
	ld b, PKMN_NAME_LENGTH

.checkchar
; end of nick?
	ld a, [de]
	cp "@" ; terminator
	jr z, .end

; check if this char is a text command
	ld hl, .textcommands
	dec hl
.loop
; next entry
	inc hl
; reached end of commands table?
	ld a, [hl]
	cp a, $ff
	jr z, .done

; is the current char between this value (inclusive)...
	ld a, [de]
	cp [hl]
	inc hl
	jr c, .loop
; ...and this one?
	cp [hl]
	jr nc, .loop

; replace it with a "?"
	ld a, "?"
	ld [de], a
	jr .loop

.done
; next char
	inc de
; reached end of nick without finding a terminator?
	dec b
	jr nz, .checkchar

; change nick to "?@"
	pop de
	push de
	ld a, "?"
	ld [de], a
	inc de
	ld a, "@"
	ld [de], a
.end
; if the nick has any errors at this point it's out of our hands
	pop de
	pop bc
	ret
; 66cf

.textcommands ; 66cf
; table definining which characters
; are actually text commands
; format:
;       >=   <
	db $00, $05
	db $14, $19
	db $1d, $26
	db $35, $3a
	db $3f, $40
	db $49, $5d
	db $5e, $7f
	db $ff ; end
; 66de


_Multiply: ; 66de

; hMultiplier is one byte.
	ld a, 8
	ld b, a

	xor a
	ld [hMultiplicand - 1], a
	ld [hMathBuffer + 1], a
	ld [hMathBuffer + 2], a
	ld [hMathBuffer + 3], a
	ld [hMathBuffer + 4], a


.loop
	ld a, [hMultiplier]
	srl a
	ld [hMultiplier], a
	jr nc, .next

	ld a, [hMathBuffer + 4]
	ld c, a
	ld a, [hMultiplicand + 2]
	add c
	ld [hMathBuffer + 4], a

	ld a, [hMathBuffer + 3]
	ld c, a
	ld a, [hMultiplicand + 1]
	adc c
	ld [hMathBuffer + 3], a

	ld a, [hMathBuffer + 2]
	ld c, a
	ld a, [hMultiplicand + 0]
	adc c
	ld [hMathBuffer + 2], a

	ld a, [hMathBuffer + 1]
	ld c, a
	ld a, [hMultiplicand - 1]
	adc c
	ld [hMathBuffer + 1], a

.next
	dec b
	jr z, .done


; hMultiplicand <<= 1

	ld a, [hMultiplicand + 2]
	add a
	ld [hMultiplicand + 2], a

	ld a, [hMultiplicand + 1]
	rla
	ld [hMultiplicand + 1], a

	ld a, [hMultiplicand + 0]
	rla
	ld [hMultiplicand + 0], a

	ld a, [hMultiplicand - 1]
	rla
	ld [hMultiplicand - 1], a

	jr .loop


.done
	ld a, [hMathBuffer + 4]
	ld [hProduct + 3], a

	ld a, [hMathBuffer + 3]
	ld [hProduct + 2], a

	ld a, [hMathBuffer + 2]
	ld [hProduct + 1], a

	ld a, [hMathBuffer + 1]
	ld [hProduct + 0], a

	ret
; 673e


_Divide: ; 673e
	xor a
	ld [hMathBuffer + 0], a
	ld [hMathBuffer + 1], a
	ld [hMathBuffer + 2], a
	ld [hMathBuffer + 3], a
	ld [hMathBuffer + 4], a

	ld a, 9
	ld e, a

.loop
	ld a, [hMathBuffer + 0]
	ld c, a
	ld a, [hDividend + 1]
	sub c
	ld d, a

	ld a, [hDivisor]
	ld c, a
	ld a, [hDividend + 0]
	sbc c
	jr c, .asm_6767

	ld [hDividend + 0], a

	ld a, d
	ld [hDividend + 1], a

	ld a, [hMathBuffer + 4]
	inc a
	ld [hMathBuffer + 4], a

	jr .loop

.asm_6767
	ld a, b
	cp 1
	jr z, .done

	ld a, [hMathBuffer + 4]
	add a
	ld [hMathBuffer + 4], a

	ld a, [hMathBuffer + 3]
	rla
	ld [hMathBuffer + 3], a

	ld a, [hMathBuffer + 2]
	rla
	ld [hMathBuffer + 2], a

	ld a, [hMathBuffer + 1]
	rla
	ld [hMathBuffer + 1], a

	dec e
	jr nz, .asm_6798

	ld e, 8
	ld a, [hMathBuffer + 0]
	ld [hDivisor], a
	xor a
	ld [hMathBuffer + 0], a

	ld a, [hDividend + 1]
	ld [hDividend + 0], a

	ld a, [hDividend + 2]
	ld [hDividend + 1], a

	ld a, [hDividend + 3]
	ld [hDividend + 2], a

.asm_6798
	ld a, e
	cp 1
	jr nz, .asm_679e
	dec b

.asm_679e
	ld a, [hDivisor]
	srl a
	ld [hDivisor], a

	ld a, [hMathBuffer + 0]
	rr a
	ld [hMathBuffer + 0], a

	jr .loop

.done
	ld a, [hDividend + 1]
	ld [hDivisor], a

	ld a, [hMathBuffer + 4]
	ld [hDividend + 3], a

	ld a, [hMathBuffer + 3]
	ld [hDividend + 2], a

	ld a, [hMathBuffer + 2]
	ld [hDividend + 1], a

	ld a, [hMathBuffer + 1]
	ld [hDividend + 0], a

	ret
; 67c1


ItemAttributes: ; 67c1
INCLUDE "items/item_attributes.asm"
; 6ec1


Function6ec1: ; 6ec1

	ld hl, $0006
	add hl, bc
	bit 5, [hl]
	jr z, .asm_6ed9
	ld hl, $0004
	add hl, bc
	bit 4, [hl]
	push hl
	push bc
	call Function6f2c
	pop bc
	pop hl
	ret c
	jr .asm_6ee9

.asm_6ed9
	ld hl, $0004
	add hl, bc
	bit 4, [hl]
	jr nz, .asm_6ee9
	push hl
	push bc
	call Function6f07
	pop bc
	pop hl
	ret c

.asm_6ee9
	bit 6, [hl]
	jr nz, Function6ef5
	push hl
	push bc
	; fallthrough
; 6eef

DrawGraphic: ; 6eef
; input:
;   hl: draw location
;   b: height
;   c: width
;   d: tile to start drawing from
;   e: number of tiles to advance for each row
	call Function7009
	pop bc
	pop hl
	ret c
	; fallthrough
; 6ef5

Function6ef5: ; 6ef5
	bit 5, [hl]
	jr nz, .asm_6f05
	push hl
	call Function70a4
	pop hl
	ret c
	push hl
	call Function70ed
	pop hl
	ret c
.asm_6f05
	and a
	ret
; 6f07


Function6f07: ; 6f07
	call Function6f5f
	ret c
	ld hl, $0010
	add hl, bc
	ld d, [hl]
	ld hl, $0011
	add hl, bc
	ld e, [hl]
	ld hl, $0006
	add hl, bc
	bit 7, [hl]
	jp nz, Function6fa1
	ld hl, $000e
	add hl, bc
	ld a, [hl]
	ld d, a
	call GetTileCollision
	and a
	jr z, Function6f3e
	scf
	ret
; 6f2c

Function6f2c: ; 6f2c
	call Function6f5f
	ret c
	ld hl, $000e
	add hl, bc
	ld a, [hl]
	call GetTileCollision
	cp $1
	jr z, Function6f3e
	scf
	ret
; 6f3e

Function6f3e: ; 6f3e
	ld hl, $000e
	add hl, bc
	ld a, [hl]
	call Function6f7f
	ret nc
	push af
	ld hl, $0007
	add hl, bc
	ld a, [hl]
	and 3
	ld e, a
	ld d, 0
	ld hl, .data_6f5b
	add hl, de
	pop af
	and [hl]
	ret z
	scf
	ret
; 6f5b

.data_6f5b
	db 1, 2, 8, 4
; 6f5f

Function6f5f: ; 6f5f
	ld hl, $000f
	add hl, bc
	ld a, [hl]
	call Function6f7f
	ret nc
	push af
	ld hl, $0007
	add hl, bc
	and 3
	ld e, a
	ld d, 0
	ld hl, .data_6f7b
	add hl, de
	pop af
	and [hl]
	ret z
	scf
	ret
; 6f7b

.data_6f7b
	db 2, 1, 4, 8
; 6f7f

Function6f7f: ; 6f7f
	ld d, a
	and $f0
	cp $b0
	jr z, .asm_6f8c
	cp $c0
	jr z, .asm_6f8c
	xor a
	ret

.asm_6f8c
	ld a, d
	and 7
	ld e, a
	ld d, 0
	ld hl, .data_6f99
	add hl, de
	ld a, [hl]
	scf
	ret
; 6f99

.data_6f99
	db 8, 4, 1, 2
	db 10, 6, 9, 5
; 6fa1

Function6fa1: ; 6fa1
	ld hl, $0007
	add hl, bc
	ld a, [hl]
	and 3
	jr z, .asm_6fb2
	dec a
	jr z, .asm_6fb7
	dec a
	jr z, .asm_6fbb
	jr .asm_6fbf

.asm_6fb2
	inc e
	push de
	inc d
	jr .asm_6fc2

.asm_6fb7
	push de
	inc d
	jr .asm_6fc2

.asm_6fbb
	push de
	inc e
	jr .asm_6fc2

.asm_6fbf
	inc d
	push de
	inc e

.asm_6fc2
	call Function2a3c
	call GetTileCollision
	pop de
	and a
	jr nz, .asm_6fd7
	call Function2a3c
	call GetTileCollision
	and a
	jr nz, .asm_6fd7
	xor a
	ret

.asm_6fd7
	scf
	ret
; 6fd9



CheckFacingObject: ; 6fd9

	call GetFacingTileCoord

; Double the distance for counter tiles.
	call CheckCounterTile
	jr nz, .asm_6ff1

	ld a, [MapX]
	sub d
	cpl
	inc a
	add d
	ld d, a

	ld a, [MapY]
	sub e
	cpl
	inc a
	add e
	ld e, a

.asm_6ff1
	ld bc, $d4d6
	ld a, 0
	ld [hConnectionStripLength], a
	call Function7041
	ret nc
	ld hl, $0007
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .asm_7007
	xor a
	ret

.asm_7007
	scf
	ret
; 7009


Function7009: ; 7009
	ld hl, $0010
	add hl, bc
	ld d, [hl]
	ld hl, $0011
	add hl, bc
	ld e, [hl]
	jr Function7041
; 7015

Function7015: ; 7015
	ld a, [hConnectionStripLength]
	call Function1ae5
	call Function7021
	call Function7041
	ret

Function7021: ; 7021
	ld hl, $0010
	add hl, bc
	ld d, [hl]
	ld hl, $0011
	add hl, bc
	ld e, [hl]
	call GetSpriteDirection
	and a
	jr z, .asm_703b
	cp $4
	jr z, .asm_703d
	cp $8
	jr z, .asm_703f
	inc d
	ret

.asm_703b
	inc e
	ret

.asm_703d
	dec e
	ret

.asm_703f
	dec d
	ret
; 7041

Function7041: ; 7041
	ld bc, $d4d6
	xor a
.asm_7045
	ld [hConnectedMapWidth], a
	call Function1af1
	jr z, .asm_7093
	ld hl, $0004
	add hl, bc
	bit 7, [hl]
	jr nz, .asm_7093
	ld hl, $0006
	add hl, bc
	bit 7, [hl]
	jr z, .asm_7063
	call Function7171
	jr nc, .asm_707b
	jr .asm_7073

.asm_7063
	ld hl, $0010
	add hl, bc
	ld a, [hl]
	cp d
	jr nz, .asm_707b
	ld hl, $0011
	add hl, bc
	ld a, [hl]
	cp e
	jr nz, .asm_707b

.asm_7073
	ld a, [hConnectionStripLength]
	ld l, a
	ld a, [hConnectedMapWidth]
	cp l
	jr nz, .asm_70a2

.asm_707b
	ld hl, $0012
	add hl, bc
	ld a, [hl]
	cp d
	jr nz, .asm_7093
	ld hl, $0013
	add hl, bc
	ld a, [hl]
	cp e
	jr nz, .asm_7093
	ld a, [hConnectionStripLength]
	ld l, a
	ld a, [hConnectedMapWidth]
	cp l
	jr nz, .asm_70a2

.asm_7093
	ld hl, $0028
	add hl, bc
	ld b, h
	ld c, l
	ld a, [hConnectedMapWidth]
	inc a
	cp $d
	jr nz, .asm_7045
	and a
	ret

.asm_70a2
	scf
	ret
; 70a4

Function70a4: ; 70a4
	ld hl, $0016
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_70e9
	and $f
	jr z, .asm_70c7
	ld e, a
	ld d, a
	ld hl, $0014
	add hl, bc
	ld a, [hl]
	sub d
	ld d, a
	ld a, [hl]
	add e
	ld e, a
	ld hl, $0010
	add hl, bc
	ld a, [hl]
	cp d
	jr z, .asm_70eb
	cp e
	jr z, .asm_70eb

.asm_70c7
	ld hl, $0016
	add hl, bc
	ld a, [hl]
	swap a
	and $f
	jr z, .asm_70e9
	ld e, a
	ld d, a
	ld hl, $0015
	add hl, bc
	ld a, [hl]
	sub d
	ld d, a
	ld a, [hl]
	add e
	ld e, a
	ld hl, $0011
	add hl, bc
	ld a, [hl]
	cp d
	jr z, .asm_70eb
	cp e
	jr z, .asm_70eb

.asm_70e9
	xor a
	ret

.asm_70eb
	scf
	ret
; 70ed

Function70ed: ; 70ed
	ld hl, $0010
	add hl, bc
	ld a, [XCoord]
	cp [hl]
	jr z, .asm_70fe
	jr nc, .asm_7111
	add $9
	cp [hl]
	jr c, .asm_7111

.asm_70fe
	ld hl, $0011
	add hl, bc
	ld a, [YCoord]
	cp [hl]
	jr z, .asm_710f
	jr nc, .asm_7111
	add $8
	cp [hl]
	jr c, .asm_7111

.asm_710f
	and a
	ret

.asm_7111
	scf
	ret
; 7113

Function7113: ; 7113
	ld a, [MapX]
	ld d, a
	ld a, [MapY]
	ld e, a
	ld bc, $d4d6
	xor a
.asm_711f
	ld [hConnectedMapWidth], a
	call Function1af1
	jr z, .asm_7160
	ld hl, $0003
	add hl, bc
	ld a, [hl]
	cp $15
	jr nz, .asm_7136
	call Function7171
	jr c, .asm_716f
	jr .asm_7160

.asm_7136
	ld hl, $0011
	add hl, bc
	ld a, [hl]
	cp e
	jr nz, .asm_714e
	ld hl, $0010
	add hl, bc
	ld a, [hl]
	cp d
	jr nz, .asm_714e
	ld a, [hConnectedMapWidth]
	cp $0
	jr z, .asm_7160
	jr .asm_716f

.asm_714e
	ld hl, $0013
	add hl, bc
	ld a, [hl]
	cp e
	jr nz, .asm_7160
	ld hl, $0012
	add hl, bc
	ld a, [hl]
	cp d
	jr nz, .asm_7160
	jr .asm_716f

.asm_7160
	ld hl, $0028
	add hl, bc
	ld b, h
	ld c, l
	ld a, [hConnectedMapWidth]
	inc a
	cp $d
	jr nz, .asm_711f
	xor a
	ret

.asm_716f
	scf
	ret
; 7171


Function7171: ; 7171
	ld hl, $0010
	add hl, bc
	ld a, d
	sub [hl]
	jr c, .asm_718b
	cp $2
	jr nc, .asm_718b
	ld hl, $0011
	add hl, bc
	ld a, e
	sub [hl]
	jr c, .asm_718b
	cp $2
	jr nc, .asm_718b
	scf
	ret

.asm_718b
	and a
	ret
; 718d

Function718d: ; 718d
	ld hl, PartyMon1Happiness
	ld bc, PartyMon2 - PartyMon1
	ld de, PartySpecies
.asm_7196
	ld a, [de]
	cp EGG
	jr nz, .asm_719f
	inc de
	add hl, bc
	jr .asm_7196

.asm_719f
	ld [$d265], a
	ld a, [hl]
	ld [ScriptVar], a
	call GetPokemonName
	jp Function746e
; 71ac

Function71ac: ; 71ac
	ld a, [PartySpecies]
	ld [$d265], a
	cp EGG
	ld a, $1
	jr z, .asm_71b9
	xor a

.asm_71b9
	ld [ScriptVar], a
	call GetPokemonName
	jp Function746e
; 71c2


ChangeHappiness: ; 71c2
; Perform happiness action c on CurPartyMon

	ld a, [CurPartyMon]
	inc a
	ld e, a
	ld d, 0
	ld hl, PartySpecies - 1
	add hl, de
	ld a, [hl]
	cp EGG
	ret z

	push bc
	ld hl, PartyMon1Happiness
	ld bc, PartyMon2 - PartyMon1
	ld a, [CurPartyMon]
	call AddNTimes
	pop bc

	ld d, h
	ld e, l

	push de
	ld a, [de]
	cp 100
	ld e, 0
	jr c, .asm_71ef
	inc e
	cp 200
	jr c, .asm_71ef
	inc e

.asm_71ef
	dec c
	ld b, 0
	ld hl, .Actions
	add hl, bc
	add hl, bc
	add hl, bc
	ld d, 0
	add hl, de
	ld a, [hl]
	cp 100
	pop de

	ld a, [de]
	jr nc, .negative
	add [hl]
	jr nc, .asm_720d
	ld a, $ff
	jr .asm_720d

.negative
	add [hl]
	jr c, .asm_720d
	xor a

.asm_720d
	ld [de], a
	ld a, [IsInBattle]
	and a
	ret z
	ld a, [CurPartyMon]
	ld b, a
	ld a, [$d0d8]
	cp b
	ret nz
	ld a, [de]
	ld [BattleMonHappiness], a
	ret
; 7221

.Actions
	db  +5,  +3,  +2
	db  +5,  +3,  +2
	db  +1,  +1,  +0
	db  +3,  +2,  +1
	db  +1,  +1,  +0
	db  -1,  -1,  -1
	db  -5,  -5, -10
	db  -5,  -5, -10
	db  +1,  +1,  +1
	db  +3,  +3,  +1
	db  +5,  +5,  +2
	db  +1,  +1,  +1
	db  +3,  +3,  +1
	db +10, +10,  +4
	db  -5,  -5, -10
	db -10, -10, -15
	db -15, -15, -20
	db  +3,  +3,  +1
	db +10,  +6,  +4
; 725a


StepHappiness: ; 725a
; Raise the party's happiness by 1 point every other step cycle.

	ld hl, $dc77
	ld a, [hl]
	inc a
	and 1
	ld [hl], a
	ret nz

	ld de, PartyCount
	ld a, [de]
	and a
	ret z

	ld c, a
	ld hl, PartyMon1Happiness
.loop
	inc de
	ld a, [de]
	cp EGG
	jr z, .next
	inc [hl]
	jr nz, .next
	ld [hl], $ff

.next
	push de
	ld de, PartyMon2 - PartyMon1
	add hl, de
	pop de
	dec c
	jr nz, .loop
	ret
; 7282


DaycareStep: ; 7282

	ld a, [DaycareMan]
	bit 0, a
	jr z, .asm_72a4

	ld a, [$df2b] ; level
	cp 100
	jr nc, .asm_72a4
	ld hl, $df16 ; exp
	inc [hl]
	jr nz, .asm_72a4
	dec hl
	inc [hl]
	jr nz, .asm_72a4
	dec hl
	inc [hl]
	ld a, [hl]
	cp $50
	jr c, .asm_72a4
	ld a, $50
	ld [hl], a

.asm_72a4
	ld a, [DaycareLady]
	bit 0, a
	jr z, .asm_72c6

	ld a, [$df64] ; level
	cp 100
	jr nc, .asm_72c6
	ld hl, $df4f ; exp
	inc [hl]
	jr nz, .asm_72c6
	dec hl
	inc [hl]
	jr nz, .asm_72c6
	dec hl
	inc [hl]
	ld a, [hl]
	cp $50
	jr c, .asm_72c6
	ld a, $50
	ld [hl], a

.asm_72c6
	ld hl, DaycareMan
	bit 5, [hl] ; egg
	ret z
	ld hl, StepsToEgg
	dec [hl]
	ret nz

	call Random
	ld [hl], a
	ld hl, $6e1d
	ld a, $5
	rst FarCall
	ld a, [$d265]
	cp $e6
	ld b, $50
	jr nc, .asm_72f8
	ld a, [$d265]
	cp $aa
	ld b, $28
	jr nc, .asm_72f8
	ld a, [$d265]
	cp $6e
	ld b, $1e
	jr nc, .asm_72f8
	ld b, $a

.asm_72f8
	call Random
	cp b
	ret nc
	ld hl, DaycareMan
	res 5, [hl]
	set 6, [hl]
	ret
; 7305


SpecialGiveShuckle: ; 7305

; Adding to the party.
	xor a
	ld [MonType], a

; Level 15 Shuckle.
	ld a, SHUCKLE
	ld [CurPartySpecies], a
	ld a, 15
	ld [CurPartyLevel], a

	ld a, PREDEF_ADDPARTYMON
	call Predef
	jr nc, .NotGiven

; Caught data.
	ld b, 0
	ld a, $13
	ld hl, $5ba3
	rst FarCall

; Holding a Berry.
	ld bc, PartyMon2 - PartyMon1
	ld a, [PartyCount]
	dec a
	push af
	push bc
	ld hl, PartyMon1Item
	call AddNTimes
	ld [hl], BERRY
	pop bc
	pop af

; OT ID.
	ld hl, PartyMon1ID
	call AddNTimes
	ld a, $2
	ld [hli], a
	ld [hl], $6

; Nickname.
	ld a, [PartyCount]
	dec a
	ld hl, PartyMon1Nickname
	call SkipNames
	ld de, SpecialShuckleNick
	call CopyName2

; OT.
	ld a, [PartyCount]
	dec a
	ld hl, PartyMon1OT
	call SkipNames
	ld de, SpecialShuckleOT
	call CopyName2

; Engine flag for this event.
	ld hl, $dc1e
	set 5, [hl]

	ld a, 1
	ld [ScriptVar], a
	ret

.NotGiven
	xor a
	ld [ScriptVar], a
	ret

SpecialShuckleOT:
	db "MANIA@"
SpecialShuckleNick:
	db "SHUCKIE@"
; 737e


SpecialReturnShuckle: ; 737e
	callba Function50000
	jr c, .asm_73e6

	ld a, [CurPartySpecies]
	cp SHUCKLE
	jr nz, .DontReturn

	ld a, [CurPartyMon]
	ld hl, PartyMon1ID
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes

; OT ID
	ld a, [hli]
	cp $2
	jr nz, .DontReturn
	ld a, [hl]
	cp $6
	jr nz, .DontReturn

; OT
	ld a, [CurPartyMon]
	ld hl, PartyMon1OT
	call SkipNames
	ld de, SpecialShuckleOT
.CheckOT
	ld a, [de]
	cp [hl]
	jr nz, .DontReturn
	cp "@"
	jr z, .asm_73bb
	inc de
	inc hl
	jr .CheckOT

.asm_73bb
	callba Functione538
	jr c, .asm_73f1
	ld a, [CurPartyMon]
	ld hl, PartyMon1Happiness
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld a, [hl]
	cp 150
	ld a, $3
	jr nc, .asm_73e2
	xor a
	ld [$d10b], a
	callab Functione039
	ld a, $2

.asm_73e2
	ld [ScriptVar], a
	ret

.asm_73e6
	ld a, $1
	ld [ScriptVar], a
	ret

.DontReturn
	xor a
	ld [ScriptVar], a
	ret

.asm_73f1
	ld a, $4
	ld [ScriptVar], a
	ret
; 73f7

Function73f7: ; 73f7
	callba Function50000
	jr c, .asm_740e
	ld a, [CurPartySpecies]
	ld [ScriptVar], a
	ld [$d265], a
	call GetPokemonName
	jp Function746e

.asm_740e
	xor a
	ld [ScriptVar], a
	ret
; 7413

Function7413: ; 7413
	ld hl, Data7459
	jr Function7420

Function7418: ; 7418
	ld hl, Data7462
	jr Function7420

Function741d: ; 741d
	ld hl, Data746b

Function7420: ; 7420
	push hl
	callba Function50000
	pop hl
	jr c, .asm_744e
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_7453
	push hl
	call GetCurNick
	call Function746e
	pop hl
	call Random
.next
	sub [hl]
	jr c, .asm_7444
	inc hl
	inc hl
	inc hl
	jr .next

.asm_7444
	inc hl
	ld a, [hli]
	ld [ScriptVar], a
	ld c, [hl]
	call ChangeHappiness
	ret

.asm_744e
	xor a
	ld [ScriptVar], a
	ret

.asm_7453
	ld a, $1
	ld [ScriptVar], a
	ret
; 7459

Data7459: ; 7459
	db $4c, $02, $09
	db $80, $03, $0a
	db $ff, $04, $0b

Data7462: ; 7462
	db $9a, $02, $0c
	db $4c, $03, $0d
	db $ff, $04, $0e

Data746b: ; 746b
	db $ff, $02, $12
; 746e

Function746e: ; 746e
	ld hl, StringBuffer1
	ld de, StringBuffer3
	ld bc, $000b
	jp CopyBytes
; 747a

Function747a: ; 747a
	ret
; 747b


SECTION "bank2",ROMX,BANK[$2]

Function8000: ; 8000
	call Function2ed3
	xor a
	ld [hBGMapMode], a
	call WhiteBGMap
	call ClearSprites
	ld hl, TileMap
	ld bc, $0168
	ld a, " "
	call ByteFill
	ld hl, AttrMap
	ld bc, $0168
	ld a, $7
	call ByteFill
	call Function3200
	call Function32f9
	ret
; 8029

Function8029: ; 8029
	ld a, $ff
	ld [$d4cd], a
	ld [$d4ce], a
	ld a, $0
	ld hl, $4071
	call Function19a6
	ld b, $0
	call Function808f
	ld a, $0
	call GetMapObject
	ld hl, $0008
	add hl, bc
	ld e, $80
	ld a, [$d45b]
	bit 2, a
	jr nz, .asm_8059
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_8059
	ld e, $90

.asm_8059
	ld [hl], e
	ld a, $0
	ld [hConnectionStripLength], a
	ld bc, MapObjects
	ld a, $0
	ld [hConnectedMapWidth], a
	ld de, $d4d6
	call Function8116
	ld a, $0
	ld [$d4cf], a
	ret
; 8071

INCBIN "baserom.gbc", $8071, $807e - $8071


Function807e: ; 807e
	push de
	ld a, b
	call GetMapObject
	pop de
	ld hl, $0003
	add hl, bc
	ld [hl], d
	ld hl, $0002
	add hl, bc
	ld [hl], e
	ret
; 808f

Function808f: ; 808f
	push bc
	ld a, [XCoord]
	add $4
	ld d, a
	ld a, [YCoord]
	add $4
	ld e, a
	pop bc
	call Function807e
	ret
; 80a1


Function80a1: ; 80a1
	ld a, b
	call Function18de
	ret c
	ld hl, $0010
	add hl, bc
	ld d, [hl]
	ld hl, $0011
	add hl, bc
	ld e, [hl]
	ld a, [hConnectionStripLength]
	ld b, a
	call Function807e
	and a
	ret
; 80b8

Function80b8: ; 80b8
	ld a, [XCoord]
	add $4
	ld d, a
	ld hl, MapX
	sub [hl]
	ld [hl], d
	ld hl, $d721
	ld [hl], d
	ld hl, MapX2
	ld [hl], d
	ld d, a
	ld a, [YCoord]
	add $4
	ld e, a
	ld hl, MapY
	sub [hl]
	ld [hl], e
	ld hl, $d720
	ld [hl], e
	ld hl, MapY2
	ld [hl], e
	ld e, a
	ld a, [$d4cd]
	cp $0
	ret nz
	ret
; 80e7


Function80e7: ; 80e7
	call Function2707
	and a
	ret nz
	ld hl, $d4fe
	ld a, $1
	ld de, $0028
.asm_80f4
	ld [hConnectedMapWidth], a
	ld a, [hl]
	and a
	jr z, .asm_8104
	add hl, de
	ld a, [hConnectedMapWidth]
	inc a
	cp $d
	jr nz, .asm_80f4
	scf
	ret

.asm_8104
	ld d, h
	ld e, l
	call Function8116
	ld hl, VramState
	bit 7, [hl]
	ret z
	ld hl, $0005
	add hl, de
	set 5, [hl]
	ret
; 8116

Function8116: ; 8116
	call Function811d
	call Function8286
	ret
; 811d

Function811d: ; 811d
	ld a, [hConnectedMapWidth]
	ld hl, $0000
	add hl, bc
	ld [hl], a
	ld a, [hConnectionStripLength]
	ld [$c2f0], a
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	ld [$c2f1], a
	call Function180e
	ld [$c2f2], a
	ld a, [hl]
	call GetSpritePalette
	ld [$c2f3], a
	ld hl, $0008
	add hl, bc
	ld a, [hl]
	and $f0
	jr z, .asm_814e
	swap a
	and $7
	ld [$c2f3], a

.asm_814e
	ld hl, $0004
	add hl, bc
	ld a, [hl]
	ld [$c2f4], a
	ld hl, $0009
	add hl, bc
	ld a, [hl]
	ld [$c2f5], a
	ld hl, $0003
	add hl, bc
	ld a, [hl]
	ld [$c2f6], a
	ld hl, $0002
	add hl, bc
	ld a, [hl]
	ld [$c2f7], a
	ld hl, $0005
	add hl, bc
	ld a, [hl]
	ld [$c2f8], a
	ret
; 8177

Function8177: ; 8177
	ld bc, $d72e
	ld a, $1
.asm_817c
	ld [hConnectionStripLength], a
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_81bb
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	cp $ff
	jr nz, .asm_81bb
	ld a, [XCoord]
	ld d, a
	ld a, [YCoord]
	ld e, a
	ld hl, $0003
	add hl, bc
	ld a, [hl]
	add $1
	sub d
	jr c, .asm_81bb
	cp $c
	jr nc, .asm_81bb
	ld hl, $0002
	add hl, bc
	ld a, [hl]
	add $1
	sub e
	jr c, .asm_81bb
	cp $b
	jr nc, .asm_81bb
	push bc
	call Function80e7
	pop bc
	jp c, Function81c9

.asm_81bb
	ld hl, $0010
	add hl, bc
	ld b, h
	ld c, l
	ld a, [hConnectionStripLength]
	inc a
	cp $10
	jr nz, .asm_817c
	ret
; 81c9

Function81c9: ; 81c9
	ret
; 81ca

Function81ca: ; 81ca
	nop
	ld a, [$d151]
	cp $ff
	ret z
	ld hl, Table81d6
	rst JumpTable
	ret
; 81d6

Table81d6: ; 81d6
	dw Function81e5
	dw Function81de
	dw Function8232
	dw Function8239
; 81de

Function81de: ; 81de
	ld a, [YCoord]
	sub $1
	jr Function81ea

Function81e5: ; 81e5
	ld a, [YCoord]
	add $9

Function81ea: ; 81ea
	ld d, a
	ld a, [XCoord]
	ld e, a
	ld bc, $d72e
	ld a, $1
.asm_81f4
	ld [hConnectionStripLength], a
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_8224
	ld hl, $0002
	add hl, bc
	ld a, d
	cp [hl]
	jr nz, .asm_8224
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	cp $ff
	jr nz, .asm_8224
	ld hl, $0003
	add hl, bc
	ld a, [hl]
	add $1
	sub e
	jr c, .asm_8224
	cp $c
	jr nc, .asm_8224
	push de
	push bc
	call Function80e7
	pop bc
	pop de

.asm_8224
	ld hl, $0010
	add hl, bc
	ld b, h
	ld c, l
	ld a, [hConnectionStripLength]
	inc a
	cp $10
	jr nz, .asm_81f4
	ret
; 8232

Function8232: ; 8232
	ld a, [XCoord]
	sub $1
	jr Function823e

Function8239: ; 8239
	ld a, [XCoord]
	add $a

Function823e: ; 823e
	ld e, a
	ld a, [YCoord]
	ld d, a
	ld bc, $d72e
	ld a, $1
.asm_8248
	ld [hConnectionStripLength], a
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_8278
	ld hl, $0003
	add hl, bc
	ld a, e
	cp [hl]
	jr nz, .asm_8278
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	cp $ff
	jr nz, .asm_8278
	ld hl, $0002
	add hl, bc
	ld a, [hl]
	add $1
	sub d
	jr c, .asm_8278
	cp $b
	jr nc, .asm_8278
	push de
	push bc
	call Function80e7
	pop bc
	pop de

.asm_8278
	ld hl, $0010
	add hl, bc
	ld b, h
	ld c, l
	ld a, [hConnectionStripLength]
	inc a
	cp $10
	jr nz, .asm_8248
	ret
; 8286


Function8286: ; 8286
	ld a, [$c2f0]
	ld hl, $0001
	add hl, de
	ld [hl], a
	ld a, [$c2f4]
	call Function1a61
	ld a, [$c2f3]
	ld hl, $0006
	add hl, de
	or [hl]
	ld [hl], a
	ld a, [$c2f7]
	call Function82d5
	ld a, [$c2f6]
	call Function82f1
	ld a, [$c2f1]
	ld hl, $0000
	add hl, de
	ld [hl], a
	ld a, [$c2f2]
	ld hl, $0002
	add hl, de
	ld [hl], a
	ld hl, $0009
	add hl, de
	ld [hl], $0
	ld hl, $000d
	add hl, de
	ld [hl], $ff
	ld a, [$c2f8]
	call Function830d
	ld a, [$c2f5]
	ld hl, $0020
	add hl, de
	ld [hl], a
	and a
	ret
; 82d5

Function82d5: ; 82d5
	ld hl, $0015
	add hl, de
	ld [hl], a
	ld hl, $0011
	add hl, de
	ld [hl], a
	ld hl, YCoord
	sub [hl]
	and $f
	swap a
	ld hl, $d14d
	sub [hl]
	ld hl, $0018
	add hl, de
	ld [hl], a
	ret
; 82f1

Function82f1: ; 82f1
	ld hl, $0014
	add hl, de
	ld [hl], a
	ld hl, $0010
	add hl, de
	ld [hl], a
	ld hl, XCoord
	sub [hl]
	and $f
	swap a
	ld hl, $d14c
	sub [hl]
	ld hl, $0017
	add hl, de
	ld [hl], a
	ret
; 830d

Function830d: ; 830d
	ld h, a
	inc a
	and $f
	ld l, a
	ld a, h
	add $10
	and $f0
	or l
	ld hl, $0016
	add hl, de
	ld [hl], a
	ret
; 831e

Function831e: ; 831e
	ld a, [$ffe0]
	call Function1b1e
	ld a, $3e
	call Function1b3f
	ld a, [CurFruit]
	dec a
	jr z, Function833b
	ld a, [$ffe0]
	ld b, a
	ld c, $0
	ld d, $1
	call Function8341
	call Function1b35

Function833b
	ld a, $47
	call Function1b3f
	ret
; 8341

Function8341: ; 8341
	push de
	push bc
	ld a, c
	call GetMapObject
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	call Function1ae5
	ld d, b
	ld e, c
	pop bc
	ld a, b
	call GetMapObject
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	call Function1ae5
	ld hl, $0010
	add hl, bc
	ld a, [hl]
	ld hl, $0011
	add hl, bc
	ld c, [hl]
	ld b, a
	ld hl, $0010
	add hl, de
	ld a, [hl]
	ld hl, $0011
	add hl, de
	ld e, [hl]
	ld d, a
	pop af
	call Function1b5f
	ret
; 8379

Function8379: ; 8379
	call Function1b1e
	call Function8388
	call Function1b3f
	ld a, $47
	call Function1b3f
	ret
; 8388

Function8388: ; 8388
	ld a, [PlayerDirection]
	srl a
	srl a
	and 3
	ld e, a
	ld d, 0
	ld hl, .data_839a
	add hl, de
	ld a, [hl]
	ret
; 839a

.data_839a
	db 8, 9, 10, 11
; 839e


Function839e: ; 839e
	push bc
	ld a, c
	call Function18de
	ld d, b
	ld e, c
	pop bc
	ret c
	ld a, b
	call Function18de
	ret c
	ld hl, $0010
	add hl, bc
	ld a, [hl]
	ld hl, $0011
	add hl, bc
	ld c, [hl]
	ld b, a
	ld hl, $0010
	add hl, de
	ld a, [hl]
	cp b
	jr z, .asm_83c7
	jr c, .asm_83c4
	inc b
	jr .asm_83d5

.asm_83c4
	dec b
	jr .asm_83d5

.asm_83c7
	ld hl, $0011
	add hl, de
	ld a, [hl]
	cp c
	jr z, .asm_83d5
	jr c, .asm_83d4
	inc c
	jr .asm_83d5

.asm_83d4
	dec c

.asm_83d5
	ld hl, $0010
	add hl, de
	ld [hl], b
	ld a, b
	ld hl, XCoord
	sub [hl]
	and $f
	swap a
	ld hl, $d14c
	sub [hl]
	ld hl, $0017
	add hl, de
	ld [hl], a
	ld hl, $0011
	add hl, de
	ld [hl], c
	ld a, c
	ld hl, YCoord
	sub [hl]
	and $f
	swap a
	ld hl, $d14d
	sub [hl]
	ld hl, $0018
	add hl, de
	ld [hl], a
	ld a, [hConnectedMapWidth]
	ld hl, $0020
	add hl, de
	ld [hl], a
	ld hl, $0003
	add hl, de
	ld [hl], $1a
	ld hl, $0009
	add hl, de
	ld [hl], $0
	ret
; 8417

Function8417: ; 8417
	ld a, d
	call GetMapObject
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	cp $d
	jr nc, .asm_8437
	ld d, a
	ld a, e
	call GetMapObject
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	cp $d
	jr nc, .asm_8437
	ld e, a
	call Function8439
	ret

.asm_8437
	scf
	ret
; 8439

Function8439: ; 8439
	ld a, d
	call Function1ae5
	ld hl, $0010
	add hl, bc
	ld a, [hl]
	ld hl, $0011
	add hl, bc
	ld c, [hl]
	ld b, a
	push bc
	ld a, e
	call Function1ae5
	ld hl, $0010
	add hl, bc
	ld d, [hl]
	ld hl, $0011
	add hl, bc
	ld e, [hl]
	pop bc
	ld a, b
	sub d
	jr z, .asm_846c
	jr nc, .asm_8460
	cpl
	inc a

.asm_8460
	ld h, a
	ld a, c
	sub e
	jr z, .asm_847a
	jr nc, .asm_8469
	cpl
	inc a

.asm_8469
	sub h
	jr c, .asm_847a

.asm_846c
	ld a, c
	cp e
	jr z, .asm_8488
	jr c, .asm_8476
	ld d, $0
	and a
	ret

.asm_8476
	ld d, $1
	and a
	ret

.asm_847a
	ld a, b
	cp d
	jr z, .asm_8488
	jr c, .asm_8484
	ld d, $3
	and a
	ret

.asm_8484
	ld d, $2
	and a
	ret

.asm_8488
	scf
	ret
; 848a

Function848a: ; 848a
	call Function849d
	jr c, .asm_8497
	ld [$d4d1], a
	xor a
	ld [$d4d0], a
	ret

.asm_8497
	ld a, $ff
	ld [$d4d0], a
	ret
; 849d

Function849d: ; 849d
	ld a, [$d4cd]
	call Function1ae5
	ld hl, $0010
	add hl, bc
	ld d, [hl]
	ld hl, $0011
	add hl, bc
	ld e, [hl]
	ld a, [$d4ce]
	call Function1ae5
	ld hl, $0010
	add hl, bc
	ld a, d
	cp [hl]
	jr z, .asm_84c5
	jr c, .asm_84c1
	and a
	ld a, $f
	ret

.asm_84c1
	and a
	ld a, $e
	ret

.asm_84c5
	ld hl, $0011
	add hl, bc
	ld a, e
	cp [hl]
	jr z, .asm_84d7
	jr c, .asm_84d3
	and a
	ld a, $c
	ret

.asm_84d3
	and a
	ld a, $d
	ret

.asm_84d7
	scf
	ret
; 84d9

_Sine: ; 84d9
; A simple sine function.
; Return d * sin(e) in hl.

; e is a signed 6-bit value.
	ld a, e
	and %111111
	cp  %100000
	jr nc, .negative

	call Function84ef
	ld a, h
	ret

.negative
	and %011111
	call Function84ef
	ld a, h
	xor $ff
	inc a
	ret
; 84ef

Function84ef: ; 84ef
	ld e, a
	ld a, d
	ld d, 0
	ld hl, SineWave
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, 0

; Factor amplitude
.multiply
	srl a
	jr nc, .even
	add hl, de
.even
	sla e
	rl d
	and a
	jr nz, .multiply
	ret
; 850b

SineWave: ; 850b
; A $20-word table representing a sine wave.
; 90 degrees is index $10 at a base amplitude of $100.
x	set 0
	rept $20
	dw (sin(x) + (sin(x) & $ff)) >> 8 ; round up
x	set x + $100 * $40000
	endr
; 854b


GetPredefPointer: ; 854b
; Return the bank and address of PredefID in a and PredefAddress.

; Save hl for later (back in Predef)
	ld a, h
	ld [PredefTemp], a
	ld a, l
	ld [PredefTemp + 1], a

	push de
	ld a, [PredefID]
	ld e, a
	ld d, 0
	ld hl, PredefPointers
	add hl, de
	add hl, de
	add hl, de
	pop de

	ld a, [hli]
	ld [PredefAddress + 1], a
	ld a, [hli]
	ld [PredefAddress], a
	ld a, [hl]

	ret
; 856b

PredefPointers: ; 856b
; $4b Predef pointers
; address, bank

	dwb Function6508, BANK(Function6508)
	dwb $747a, $01
	dwb $4658, $03
	dwb $57c1, $13 ; Flag, BANK(Flag)
	dwb $4699, $03
	dwb FillPP, BANK(FillPP)
	dwb Functiond88c, BANK(Functiond88c)
	dwb $5a96, $03
	dwb $5b3f, $03
	dwb Functionde6e, BANK(Functionde6e)
	dwb Functiondf8c, BANK(Functiondf8c)
	dwb $46e0, $03
	dwb Functione167, BANK(Functione167)
	dwb Functione17b, BANK(Functione17b)
	dwb CanLearnTMHMMove, BANK(CanLearnTMHMMove)
	dwb $566a, $04
	dwb $4eef, $0a
	dwb $4b3e, $0b ; PrintMoveDescription, BANK(PrintMoveDescription)
	dwb Function3df48, BANK(Function3df48) ; UpdatePlayerHUD
	dwb FillBox, BANK(FillBox)
	dwb Function3d873, BANK(Function3d873)
	dwb Function3e036, BANK(Function3e036) ; UpdateEnemyHUD
	dwb StartBattle, BANK(StartBattle)
	dwb FillInExpBar, BANK(FillInExpBar)
	dwb Function3f43d, BANK(Function3f43d)
	dwb Function3f47c, BANK(Function3f47c)
	dwb Function42487, BANK(Function42487)
	dwb FillMoves, BANK(FillMoves)
	dwb $61e6, $10
	dwb $4f63, $0a
	dwb $4f24, $0a
	dwb $484a, $14
	dwb $4d6f, $14
	dwb $4d2e, $14
	dwb $4cdb, $14
	dwb $4c50, $14
	dwb GetGender, BANK(GetGender)
	dwb StatsScreenInit, BANK(StatsScreenInit)
	dwb DrawPlayerHP, BANK(DrawPlayerHP)
	dwb DrawEnemyHP, BANK(DrawEnemyHP)
	dwb $4b7b, $14
	dwb GetTypeName, BANK(GetTypeName)
	dwb PrintMoveType, BANK(PrintMoveType)
	dwb PrintType, BANK(PrintType)
	dwb PrintMonTypes, BANK(PrintMonTypes)
	dwb $5040, $14 ; GetUnownLetter
	dwb $7cdd, $32
	dwb $40d5, $33
	dwb $5853, $02
	dwb $464c, $02 ; LoadSGBLayout, BANK(LoadSGBLayout)
	dwb $5d11, $24
	dwb CheckContestMon, BANK(CheckContestMon)
	dwb Function8c20f, BANK(Function8c20f)
	dwb $4000, $23
	dwb $4000, $23
	dwb Functioncc0d6, BANK(Functioncc0d6)
	dwb $40d5, $33
	dwb $40d5, $33
	dwb $51d0, $3f
	dwb PartyMonItemName, BANK(PartyMonItemName)
	dwb $5077, $14
	dwb $516c, $14
	dwb $508b, $14
	dwb Function5120d, BANK(Function5120d)
	dwb DecompressPredef, BANK(DecompressPredef)
	dwb Function0x347d3, BANK(Function0x347d3)
	dwb $7908, $3e
	dwb $7877, $3e
	dwb $4000, $34
	dwb Function50d0a, BANK(Function50d0a)
	dwb $40a3, $34
	dwb $408e, $34
	dwb $4669, $34
	dwb $466e, $34
	dwb $43ff, $2d
; 864c


Function864c: ; 864c
	call Function8d55
	jp nz, Function8d59
	ld a, b
	cp $ff
	jr nz, .asm_865a
	ld a, [SGBPredef]

.asm_865a
	cp $fc
	jp z, Function8ade
	ld l, a
	ld h, 0
	add hl, hl
	ld de, $466f
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, Function8a60
	push de
	jp [hl]
; 866f

INCBIN "baserom.gbc", $866f, $8a60 - $866f

Function8a60: ; 8a60
	push de
	call Function9809
	pop hl
	jp Function9809
; 8a68


CheckShininess: ; 8a68
; Check if a mon is shiny by DVs at bc.
; Return carry if shiny.

	ld l, c
	ld h, b

; Attack
	ld a, [hl]
	and %0010 << 4
	jr z, .NotShiny

; Defense
	ld a, [hli]
	and %1111
	cp  %1010
	jr nz, .NotShiny

; Speed
	ld a, [hl]
	and %1111 << 4
	cp  %1010 << 4
	jr nz, .NotShiny

; Special
	ld a, [hl]
	and %1111
	cp  %1010
	jr nz, .NotShiny

.Shiny
	scf
	ret

.NotShiny
	and a
	ret
; 8a88


CheckContestMon: ; 8a88
; Check a mon's DVs at hl in the bug catching contest.
; Return shiny if its DVs are good enough to place in the contest.

; Attack
	ld a, [hl]
	cp 10 << 4
	jr c, .Bad

; Defense
	ld a, [hli]
	and $f
	cp 10
	jr c, .Bad

; Speed
	ld a, [hl]
	cp 10 << 4
	jr c, .Bad

; Special
	ld a, [hl]
	and $f
	cp 10
	jr c, .Bad

.Good
	scf
	ret

.Bad
	and a
	ret
; 8aa4


Function8aa4: ; 8aa4
	push de
	push bc
	ld hl, $5ce6
	ld de, $cda9
	ld bc, $0010
	call CopyBytes
	pop bc
	pop de
	ld a, c
	ld [$cdac], a
	ld a, b
	ld [$cdad], a
	ld a, e
	ld [$cdae], a
	ld a, d
	ld [$cdaf], a
	ld hl, $cda9
	call Function9809
	ld hl, $5a86
	call Function9809
	ret
; 8ad1


Function8ad1: ; 8ad1
	ld hl, $5c57
	call Function9610
	call Function971a
	call Function9699
	ret
; 8ade

Function8ade: ; 8ade
	ld hl, $cd9b
	ld a, [$cda9]
	ld e, a
	ld d, $0
	add hl, de
	ld e, l
	ld d, h
	ld a, [de]
	and a
	ld e, $5
	jr z, .asm_8af7
	dec a
	ld e, $a
	jr z, .asm_8af7
	ld e, $f

.asm_8af7
	push de
	ld hl, $cdb3
	ld bc, $0006
	ld a, [$cda9]
	call AddNTimes
	pop de
	ld [hl], e
	ret
; 8b07

Function8b07: ; 8b07
	call Function8d55
	ret z
	ld hl, $4b2f
	ld de, $d000
	ld bc, $0008
	ld a, $5
	call Function306b
	ld hl, $4b37
	ld de, MartPointer
	ld bc, $0008
	ld a, $5
	call Function306b
	call Function96a4
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 8b2f

INCBIN "baserom.gbc", $8b2f, $8cb4 - $8b2f

Function8cb4: ; 8cb4
	ld l, e
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, $4d05
	add hl, de
	call Function8d55
	jr nz, .asm_8cf0
	push hl
	ld hl, $5ce6
	ld de, $cda9
	ld bc, $0010
	call CopyBytes
	pop hl
	inc hl
	inc hl
	ld a, [hli]
	ld [$cdac], a
	ld a, [hli]
	ld [$cdad], a
	ld a, [hli]
	ld [$cdae], a
	ld a, [hli]
	ld [$cdaf], a
	ld hl, $cda9
	call Function9809
	ld hl, $5a86
	call Function9809
	ret

.asm_8cf0
	ld de, $d000
	ld bc, $0008
	ld a, $5
	call Function306b
	call Function96a4
	call Function9699
	call Function96b3
	ret
; 8d05

INCBIN "baserom.gbc", $8d05, $8d55 - $8d05


Function8d55: ; 8d55
	ld a, [hCGB]
	and a
	ret
; 8d59

Function8d59: ; 8d59
	ld a, b
	cp $ff
	jr nz, .asm_8d61
	ld a, [SGBPredef]

.asm_8d61
	cp $fc
	jp z, Function96f3
	call Function9673
	ld l, a
	ld h, $0
	add hl, hl
	ld de, $4d7a
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, Function8d79
	push de
	jp [hl]
; 8d79

Function8d79: ; 8d79
	ret
; 8d7a

INCBIN "baserom.gbc", $8d7a, $8db8 - $8d7a

Function8db8: ; 8db8
	ld hl, $5c67
	ld de, $d000
	ld c, $4
	call $5615
	ld hl, $5c67
	ld de, $d020
	ld c, $4
	call $5615
	ld hl, $5c67
	ld de, MartPointer
	ld c, $2
	call $5615
	jr .asm_8e23

	ld de, $d000
	call Function9729
	push hl
	call Function9643
	call Function973a
	push hl
	call Function9643
	ld a, [EnemyHPPal]
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	ld bc, $68be
	add hl, bc
	call Function9643
	ld a, [PlayerHPPal]
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	ld bc, $68be
	add hl, bc
	call Function9643
	ld hl, $68ca
	call Function9643
	ld de, MartPointer
	pop hl
	call Function9643
	pop hl
	call Function9643
	ld a, $1
	ld [SGBPredef], a
	call Function96a4

.asm_8e23
	call Function8e85
	ld hl, AttrMap
	ld bc, $0168
	ld a, $2
	call ByteFill
	ld hl, $ce29
	ld bc, $080a
	ld a, $0
	call Function9663
	ld hl, $cde3
	ld bc, $070a
	ld a, $1
	call Function9663
	ld hl, AttrMap
	ld bc, $040a
	ld a, $2
	call Function9663
	ld hl, $ce6f
	ld bc, $050a
	ld a, $3
	call Function9663
	ld hl, $cebf
	ld bc, $0109
	ld a, $4
	call Function9663
	ld hl, $cec9
	ld bc, $0078
	ld a, $7
	call ByteFill
	ld hl, $579c
	ld de, $d050
	ld bc, $0030
	ld a, $5
	call Function306b
	call Function96b3
	ret
; 8e85


Function8e85: ; 8e85
	ld a, $40
	ld hl, $4dc0
	rst FarCall
	ld hl, $7311
	jr nc, .asm_8e93
	ld hl, $7309

.asm_8e93
	ld de, $d038
	ld bc, $0008
	ld a, $5
	call Function306b
	ret
; 8e9f

Function8e9f: ; 8e9f
	callba Function100dc0
	ld hl, $7311
	jr nc, .asm_8ead
	ld hl, $7309

.asm_8ead
	ld de, $d000
	ld bc, $0008
	ld a, $5
	call Function306b
	ret
; 8eb9

Function8eb9: ; 8eb9
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_8ec5
	ld hl, $7759
	jr .asm_8ec8

.asm_8ec5
	ld hl, $7729

.asm_8ec8
	ld de, $d000
	ld bc, $0030
	ld a, $5
	call Function306b
	call Function96a4
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 8edb

Function8edb: ; 8edb
	ld de, $d000
	ld a, [$cda1]
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	ld bc, $68be
	add hl, bc
	call Function9643
	ld a, [CurPartySpecies]
	ld bc, TempMonDVs
	call Function974b
	call Function9643
	ld hl, $68ca
	call Function9643
	ld hl, $4f52
	ld de, $d018
	ld bc, $0018
	ld a, $5
	call Function306b
	call Function9699
	ld hl, AttrMap
	ld bc, $0814
	ld a, $1
	call Function9663
	ld hl, $cf23
	ld bc, $000a
	ld a, $2
	call ByteFill
	ld hl, $ce4a
	ld bc, $0202
	ld a, $3
	call Function9663
	ld hl, $ce4c
	ld bc, $0202
	ld a, $4
	call Function9663
	ld hl, $ce4e
	ld bc, $0202
	ld a, $5
	call Function9663
	call Function96b3
	call Function96a4
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 8f52

INCBIN "baserom.gbc", $8f52, $9610 - $8f52


Function9610: ; 9610
	ld de, $d000
	ld c, $4
.asm_9615
	push bc
	ld a, [hli]
	push hl
	call Function9625
	call Function9630
	pop hl
	inc hl
	pop bc
	dec c
	jr nz, .asm_9615
	ret
; 9625

Function9625: ; 9625
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, $5df6
	add hl, bc
	ret
; 9630

Function9630: ; 9630
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld c, $8
.asm_9639
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_9639
	pop af
	ld [rSVBK], a
	ret
; 9643

Function9643: ; 9643
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld a, $ff
	ld [de], a
	inc de
	ld a, $7f
	ld [de], a
	inc de
	ld c, $4
.asm_9654
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_9654
	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de
	pop af
	ld [rSVBK], a
	ret
; 9663

Function9663: ; 9663
.asm_9663
	push bc
	push hl
.asm_9665
	ld [hli], a
	dec c
	jr nz, .asm_9665
	pop hl
	ld bc, $0014
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_9663
	ret
; 9673

Function9673: ; 9673
	push af
	push bc
	push de
	push hl
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, $d000
	ld c, $8
.asm_9683
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec c
	jr nz, .asm_9683
	pop af
	ld [rSVBK], a
	pop hl
	pop de
	pop bc
	pop af
	ret
; 9699


Function9699: ; 9699
	ld hl, AttrMap
	ld bc, $0168
	xor a
	call ByteFill
	ret
; 96a4

Function96a4: ; 96a4
	ld hl, $d000
	ld de, $d080
	ld bc, $0080
	ld a, $5
	call Function306b
	ret
; 96b3

Function96b3: ; 96b3
	ld a, [rLCDC]
	bit 7, a
	jr z, .asm_96d0
	ld a, [hBGMapMode]
	push af
	ld a, $2
	ld [hBGMapMode], a
	call DelayFrame
	call DelayFrame
	call DelayFrame
	call DelayFrame
	pop af
	ld [hBGMapMode], a
	ret

.asm_96d0
	ld hl, AttrMap
	ld de, VBGMap0
	ld b, $12
	ld a, $1
	ld [rVBK], a
.asm_96dc
	ld c, $14
.asm_96de
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_96de
	ld a, $c
	add e
	jr nc, .asm_96ea
	inc d

.asm_96ea
	ld e, a
	dec b
	jr nz, .asm_96dc
	ld a, $0
	ld [rVBK], a
	ret
; 96f3

Function96f3: ; 96f3
	ld hl, $cd9b
	ld a, [$cda9]
	ld e, a
	ld d, $0
	add hl, de
	ld e, l
	ld d, h
	ld a, [de]
	inc a
	ld e, a
	ld hl, $ce0c
	ld bc, $0028
	ld a, [$cda9]
.asm_970b
	and a
	jr z, .asm_9712
	add hl, bc
	dec a
	jr .asm_970b

.asm_9712
	ld bc, $0208
	ld a, e
	call Function9663
	ret
; 971a


Function971a: ; 971a
	ld hl, $7681
	ld de, MartPointer
	ld bc, $0010
	ld a, $5
	call Function306b
	ret
; 9729

Function9729: ; 9729
	push de
	callba Function3da85
	ld c, l
	ld b, h
	ld a, [TempBattleMonSpecies]
	call Function974b
	pop de
	ret
; 973a

Function973a: ; 973a
	push de
	callba Function3da97
	ld c, l
	ld b, h
	ld a, [TempEnemyMonSpecies]
	call Function9764
	pop de
	ret
; 974b

Function974b: ; 974b
	and a
	jp nz, Function97f9
	ld a, [$d45b]
	bit 2, a
	jr nz, .asm_9760
	ld a, [PlayerGender]
	and a
	jr z, .asm_9760
	ld hl, FalknerPalette
	ret

.asm_9760
	ld hl, $70ce
	ret
; 9764

Function9764: ; 9764
	and a
	jp nz, Function97f9
	ld a, [TrainerClass]
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	ld bc, $70ce
	add hl, bc
	ret
; 9775

INCBIN "baserom.gbc", $9775, $97ee - $9775

Function97ee: ; 97ee
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, $68ce
	add hl, bc
	ret
; 97f9

Function97f9: ; 97f9
	push bc
	call Function97ee
	pop bc
	push hl
	call CheckShininess
	pop hl
	ret nc
	inc hl
	inc hl
	inc hl
	inc hl
	ret
; 9809

Function9809: ; 9809
	ld a, [$cfbe]
	push af
	set 7, a
	ld [$cfbe], a
	call Function981a
	pop af
	ld [$cfbe], a
	ret
; 981a

Function981a: ; 981a
	ld a, [hl]
	and $7
	ret z
	ld b, a
.asm_981f
	push bc
	xor a
	ld [rJOYP], a
	ld a, $30
	ld [rJOYP], a
	ld b, $10
.asm_9829
	ld e, $8
	ld a, [hli]
	ld d, a
.asm_982d
	bit 0, d
	ld a, $10
	jr nz, .asm_9835
	ld a, $20

.asm_9835
	ld [rJOYP], a
	ld a, $30
	ld [rJOYP], a
	rr d
	dec e
	jr nz, .asm_982d
	dec b
	jr nz, .asm_9829
	ld a, $20
	ld [rJOYP], a
	ld a, $30
	ld [rJOYP], a
	call Function9a7a
	pop bc
	dec b
	jr nz, .asm_981f
	ret
; 9853

INCBIN "baserom.gbc", $9853, $9890 - $9853


Function9890: ; 9890
	call Function8d55
	ret z
	ld a, $1
	ld [rVBK], a
	ld hl, VTiles0
	ld bc, $2000
	xor a
	call ByteFill
	ld a, $0
	ld [rVBK], a
	ld a, $80
	ld [rBGPI], a
	ld c, $20
.asm_98ac
	ld a, $ff
	ld [rBGPD], a
	ld a, $7f
	ld [rBGPD], a
	dec c
	jr nz, .asm_98ac
	ld a, $80
	ld [rOBPI], a
	ld c, $20
.asm_98bd
	ld a, $ff
	ld [rOBPD], a
	ld a, $7f
	ld [rOBPD], a
	dec c
	jr nz, .asm_98bd
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, $d000
	call Function98df
	ld hl, $d080
	call Function98df
	pop af
	ld [rSVBK], a
	ret
; 98df

Function98df: ; 98df
	ld c, $40
.asm_98e1
	ld a, $ff
	ld [hli], a
	ld a, $7f
	ld [hli], a
	dec c
	jr nz, .asm_98e1
	ret
; 98eb

INCBIN "baserom.gbc", $98eb, $9a52 - $98eb

CopyData: ; 0x9a52
; copy bc bytes of data from hl to de
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, CopyData
	ret
; 0x9a5b

ClearBytes: ; 0x9a5b
; clear bc bytes of data starting from de
	xor a
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, ClearBytes
	ret
; 0x9a64

DrawDefaultTiles: ; 0x9a64
; Draw 240 tiles (2/3 of the screen) from tiles in VRAM
	ld hl, VBGMap0 ; BG Map 0
	ld de, 32 - 20
	ld a, $80 ; starting tile
	ld c, 12 + 1
.line
	ld b, 20
.tile
	ld [hli], a
	inc a
	dec b
	jr nz, .tile
; next line
	add hl, de
	dec c
	jr nz, .line
	ret
; 0x9a7a

Function9a7a: ; 9a7a
	ld de, $1b58
.asm_9a7d
	nop
	nop
	nop
	dec de
	ld a, d
	or e
	jr nz, .asm_9a7d
	ret
; 9a86

INCBIN "baserom.gbc", $9a86, $a51e - $9a86

SGBBorder:
INCBIN "gfx/misc/sgb_border.2bpp"

INCBIN "baserom.gbc", $a8be, $a8d6 - $a8be

PokemonPalettes:
INCLUDE "gfx/pics/palette_pointers.asm"

INCBIN "baserom.gbc", $b0ae, $b0d2 - $b0ae

TrainerPalettes:
INCLUDE "gfx/trainers/palette_pointers.asm"

INCBIN "baserom.gbc", $b1de, $b319 - $b1de

MornPal: ; 0xb319
INCBIN "tilesets/morn.pal"
; 0xb359

DayPal: ; 0xb359
INCBIN "tilesets/day.pal"
; 0xb399

NitePal: ; 0xb399
INCBIN "tilesets/nite.pal"
; 0xb3d9

DarkPal: ; 0xb3d9
INCBIN "tilesets/dark.pal"
; 0xb419

INCBIN "baserom.gbc", $b419, $b825 - $b419


SECTION "bank3",ROMX,BANK[$3]

Functionc000: ; c000
	ld a, [TimeOfDay]
	ld hl, $4012
	ld de, $0002
	call IsInArray
	inc hl
	ld c, [hl]
	ret c
	xor a
	ld c, a
	ret
; c012

INCBIN "baserom.gbc", $c012, $c01b - $c012


Functionc01b: ; c01b
	ld hl, SpecialsPointers
	add hl, de
	add hl, de
	add hl, de
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, b
	rst FarCall
	ret
; c029


SpecialsPointers: ; c029
	dbw BANK(Function97c28), Function97c28
	dbw $0a, $5ce8
	dbw $0a, $5d11
	dbw $0a, $5d92
	dbw $0a, $5e66
	dbw $0a, $5e82
	dbw $0a, $5efa
	dbw $0a, $5eee
	dbw $0a, $5c92
	dbw $0a, $5cf1
	dbw $0a, $5cfa
	dbw $0a, $5bfb
	dbw $0a, $5c7b
	dbw $0a, $5ec4
	dbw $0a, $5ed9
	dbw $0a, $5eaf
	dbw $0a, $5f47
	dbw $03, $42f6
	dbw $03, $4309
	dbw $41, $50b9
	dbw $03, $434a
	dbw $13, $59e5
	dbw $04, $7a12
	dbw $04, $7a31
	dbw $04, $75db
	dbw $3e, $7b32
	dbw $3e, $7cd2
	dbw $03, $4658
	dbw $05, $559a
	dbw $03, $42e7
	dbw $05, $66d6
	dbw $05, $672a
	dbw $05, $6936
	dbw $0b, $4547
	dbw $05, $6218
	dbw $23, $4c04
	dbw BANK(SpecialNameRival), SpecialNameRival
	dbw $24, $4913
	dbw $03, $42c0
	dbw $03, $42cd
	dbw $03, $4355
	dbw $03, $4360
	dbw $03, $4373
	dbw $03, $4380
	dbw $03, $438d
	dbw $03, $43db
	dbw BANK(Function8c084), Function8c084
	dbw $23, $4092
	dbw $23, $40b6
	dbw BANK(Function8c079), Function8c079
	dbw $23, $40ab
	dbw BANK(Functiond91), Functiond91
	dbw BANK(WhiteBGMap), WhiteBGMap
	dbw BANK(UpdateTimePals), UpdateTimePals
	dbw BANK(ClearTileMap), ClearTileMap
	dbw BANK(Function1ad2), Function1ad2
	dbw BANK(Functione4a), Functione4a
	dbw $03, $4230
	dbw $03, $4252
	dbw BANK(WaitSFX),WaitSFX
	dbw BANK(Function3cdf), Function3cdf
	dbw BANK(Function3d47), Function3d47
	dbw $04, $6324
	dbw $02, $4379
	dbw $03, $425a
	dbw $03, $4268
	dbw $03, $4276
	dbw $03, $4284
	dbw $03, $43ef
	dbw $05, $7421
	dbw $05, $7440
	dbw $04, $79a8
	dbw $03, $43fc
	dbw $09, $6feb
	dbw $09, $7043
	dbw BANK(SpecialGiveShuckle), SpecialGiveShuckle
	dbw BANK(SpecialReturnShuckle), SpecialReturnShuckle
	dbw $01, $73f7
	dbw BANK(SpecialCheckPokerus),SpecialCheckPokerus
	dbw BANK(Function24b25), Function24b25
	dbw $09, $4b4e
	dbw BANK(Function24ae8), Function24ae8
	dbw $13, $587a
	dbw $03, $4434
	dbw $03, $4422
	dbw $13, $59d3
	dbw $22, $4018
	dbw $03, $42b9
	dbw $03, $42da
	dbw $01, $718d
	dbw $01, $71ac
	dbw $0a, $64ab
	dbw $0a, $651f
	dbw $0a, $6567
	dbw BANK(Function14209), Function14209
	dbw $3e, $7841
	dbw BANK(SpecialSnorlaxAwake),SpecialSnorlaxAwake
	dbw $01, $7413
	dbw $01, $7418
	dbw $01, $741d
	dbw $03, $4472
	dbw BANK(ProfOaksPCBoot), ProfOaksPCBoot
	dbw BANK(SpecialGameboyCheck),SpecialGameboyCheck
	dbw BANK(SpecialTrainerHouse),SpecialTrainerHouse
	dbw $05, $6dc7
	dbw BANK(InitRoamMons), InitRoamMons
	dbw $03, $448f
	dbw $03, $449f
	dbw $03, $44ac
	dbw $46, $6c3e
	dbw $46, $7444
	dbw $46, $75e8
	dbw $46, $77e5
	dbw $46, $7879
	dbw $46, $7920
	dbw $46, $793b
	dbw $5c, $40b0
	dbw $5c, $40ba
	dbw $5c, $4114
	dbw $5c, $4215
	dbw $5c, $44e1
	dbw $5c, $421d
	dbw $5c, $4b44
	dbw $46, $7a38
	dbw $5c, $4bd3
	dbw $45, $7656
	dbw BANK(Reset), Reset
	dbw $40, $51f1
	dbw $40, $5220
	dbw $40, $5225
	dbw $40, $5231
	dbw BANK(Function4925b), Function4925b
	dbw $22, $6def
	dbw $47, $41ab
	dbw $5c, $4687
	dbw $22, $6e68
	dbw $5f, $5224
	dbw $5f, $52b6
	dbw $5f, $52ce
	dbw $5f, $753d
	dbw $40, $7612
	dbw BANK(SpecialHoOhChamber),SpecialHoOhChamber
	dbw $40, $6142
	dbw $12, $589a
	dbw $12, $5bf9
	dbw $13, $70bc
	dbw $22, $6f6b
	dbw $22, $6fd4
	dbw BANK(SpecialDratini),SpecialDratini
	dbw $04, $5485
	dbw BANK(SpecialBeastsCheck),SpecialBeastsCheck
	dbw BANK(SpecialMonCheck),SpecialMonCheck
	dbw $03, $4225
	dbw $5c, $4bd2
	dbw $40, $766e
	dbw $40, $77eb
	dbw $40, $783c
	dbw $41, $60a2
	dbw BANK(Function14168), Function14168
	dbw $40, $77c2
	dbw $41, $630f
	dbw $40, $7780
	dbw $40, $787b
	dbw $12, $6e12
	dbw $41, $47eb
	dbw $12, $6927
	dbw $24, $4a54
	dbw $24, $4a88
	dbw $03, $4224
; c224

INCBIN "baserom.gbc", $c224, $c29d - $c224

SpecialNameRival: ; 0xc29d
	ld b, $2 ; rival
	ld de, RivalName
	ld a, BANK(Function116b7)
	ld hl, Function116b7
	rst $8
	; default to "SILVER"
	ld hl, RivalName
	ld de, DefaultRivalName
	call InitName
	ret
; 0xc2b2

DefaultRivalName: ; 0xc2b2
	db "SILVER@"

INCBIN "baserom.gbc", $c2b9, $c3e2 - $c2b9

ScriptReturnCarry: ; c3e2
	jr c, .carry
	xor a
	ld [ScriptVar], a
	ret
.carry
	ld a, 1
	ld [ScriptVar], a
	ret
; c3ef

INCBIN "baserom.gbc", $c3ef, $c403 - $c3ef


Functionc403: ; c403
	ld a, c
	and a
	jr nz, .asm_c410
	ld a, d
	ld [$dfcc], a
	ld a, e
	ld [$dfcd], a
	ret

.asm_c410
	ld a, d
	ld [$dc5a], a
	ld a, e
	ld [$dc5b], a
	ret
; c419


SpecialCheckPokerus: ; c419
; Check if a monster in your party has Pokerus
	callba CheckPokerus
	jp ScriptReturnCarry
; c422

INCBIN "baserom.gbc", $c422, $c43d - $c422

SpecialSnorlaxAwake: ; 0xc43d
; Check if the Poké Flute channel is playing, and if the player is standing
; next to Snorlax.

; outputs:
; ScriptVar is 1 if the conditions are met, otherwise 0.

; check background music
	ld a, [CurMusic]
	cp $40 ; Poké Flute Channel
	jr nz, .nope

	ld a, [XCoord]
	ld b, a
	ld a, [YCoord]
	ld c, a

	ld hl, .ProximityCoords
.loop
	ld a, [hli]
	cp $ff
	jr z, .nope
	cp b
	jr nz, .nextcoord
	ld a, [hli]
	cp c
	jr nz, .loop

	ld a, $1
	jr .done

.nextcoord
	inc hl
	jr .loop

.nope
	xor a
.done
	ld [ScriptVar], a
	ret

.ProximityCoords
	db $21, $08
	db $22, $0a
	db $23, $0a
	db $24, $08
	db $24, $09
	db $ff

INCBIN "baserom.gbc", $c472, $c478 - $c472

SpecialGameboyCheck: ; c478
; check cgb
	ld a, [hCGB]
	and a
	jr nz, .cgb
; check sgb
	ld a, [hSGB]
	and a
	jr nz, .sgb
; gb
	xor a
	jr .done
	
.sgb
	ld a, 1
	jr .done

.cgb
	ld a, 2
	
.done
	ld [ScriptVar], a
	ret

INCBIN "baserom.gbc", $c48f, $c4b9 - $c48f

SpecialTrainerHouse: ; 0xc4b9
	ld a, 0
	call GetSRAMBank
	ld a, [$abfd] ; XXX what is this memory location?
	ld [ScriptVar], a
	jp CloseSRAM

_PrintNum: ; c4c7
	push bc
	bit 5, b
	jr z, .asm_c4d9
	bit 7, b
	jr nz, .asm_c4d4
	bit 6, b
	jr z, .asm_c4d9

.asm_c4d4
	ld a, $f0
	ld [hli], a
	res 5, b

.asm_c4d9
	xor a
	ld [hProduct], a
	ld [hMultiplicand], a
	ld [$ffb5], a
	ld a, b
	and $f
	cp $1
	jr z, .asm_c501
	cp $2
	jr z, .asm_c4f8
	ld a, [de]
	ld [hMultiplicand], a
	inc de
	ld a, [de]
	ld [$ffb5], a
	inc de
	ld a, [de]
	ld [$ffb6], a
	jr .asm_c504

.asm_c4f8
	ld a, [de]
	ld [$ffb5], a
	inc de
	ld a, [de]
	ld [$ffb6], a
	jr .asm_c504

.asm_c501
	ld a, [de]
	ld [$ffb6], a

.asm_c504
	push de
	ld d, b
	ld a, c
	swap a
	and $f
	ld e, a
	ld a, c
	and $f
	ld b, a
	ld c, $0
	cp $2
	jr z, .asm_c57c
	cp $3
	jr z, .asm_c56c
	cp $4
	jr z, .asm_c55b
	cp $5
	jr z, .asm_c54a
	cp $6
	jr z, .asm_c538
	ld a, $f
	ld [hMultiplier], a
	ld a, $42
	ld [hMathBuffer], a
	ld a, $40
	ld [$ffb9], a
	call $45cb
	call PrintNumber_AdvancePointer

.asm_c538
	ld a, $1
	ld [hMultiplier], a
	ld a, $86
	ld [hMathBuffer], a
	ld a, $a0
	ld [$ffb9], a
	call $45cb
	call PrintNumber_AdvancePointer

.asm_c54a
	xor a
	ld [hMultiplier], a
	ld a, $27
	ld [hMathBuffer], a
	ld a, $10
	ld [$ffb9], a
	call $45cb
	call PrintNumber_AdvancePointer

.asm_c55b
	xor a
	ld [hMultiplier], a
	ld a, $3
	ld [hMathBuffer], a
	ld a, $e8
	ld [$ffb9], a
	call $45cb
	call PrintNumber_AdvancePointer

.asm_c56c
	xor a
	ld [hMultiplier], a
	xor a
	ld [hMathBuffer], a
	ld a, $64
	ld [$ffb9], a
	call $45cb
	call PrintNumber_AdvancePointer

.asm_c57c
	dec e
	jr nz, .asm_c583
	ld a, $f6
	ld [hProduct], a

.asm_c583
	ld c, $0
	ld a, [$ffb6]
.asm_c587
	cp $a
	jr c, .asm_c590
	sub $a
	inc c
	jr .asm_c587

.asm_c590
	ld b, a
	ld a, [hProduct]
	or c
	jr nz, .asm_c59b
	call PrintNumber_PrintLeadingZero
	jr .asm_c5ad

.asm_c59b
	call Functionc5ba
	push af
	ld a, $f6
	add c
	ld [hl], a
	pop af
	ld [hProduct], a
	inc e
	dec e
	jr nz, .asm_c5ad
	inc hl
	ld [hl], $f2

.asm_c5ad
	call PrintNumber_AdvancePointer
	call Functionc5ba
	ld a, $f6
	add b
	ld [hli], a
	pop de
	pop bc
	ret
; c5ba

Functionc5ba: ; c5ba
	push af
	ld a, [hProduct]
	and a
	jr nz, .asm_c5c9
	bit 5, d
	jr z, .asm_c5c9
	ld a, $f0
	ld [hli], a
	res 5, d

.asm_c5c9
	pop af
	ret
; c5cb

INCBIN "baserom.gbc", $c5cb, $c5d2 - $c5cb

PrintNumber_PrintDigit: ; c5d2
INCBIN "baserom.gbc", $c5d2, $c644 - $c5d2

PrintNumber_PrintLeadingZero: ; c644
; prints a leading zero unless they are turned off in the flags
	bit 7, d ; print leading zeroes?
	ret z
	ld [hl], "0"
	ret

PrintNumber_AdvancePointer: ; c64a
; increments the pointer unless leading zeroes are not being printed,
; the number is left-aligned, and no nonzero digits have been printed yet
	bit 7, d ; print leading zeroes?
	jr nz, .incrementPointer
	bit 6, d ; left alignment or right alignment?
	jr z, .incrementPointer
	ld a, [hPastLeadingZeroes]
	and a
	ret z
.incrementPointer
	inc hl
	ret
; 0xc658

INCBIN "baserom.gbc", $c658, $c6ea - $c658


Functionc6ea: ; c6ea
	xor a
	ld hl, MagikarpLength
	ld bc, $0007
	call ByteFill
	ret
; c6f5

Functionc6f5: ; c6f5
	ld a, [MagikarpLength]
	rst JumpTable
	ld [MagikarpLength], a
	bit 7, a
	jr nz, .asm_c702
	and a
	ret

.asm_c702
	and $7f
	scf
	ret
; c706


GetPartyNick: ; c706
; write CurPartyMon nickname to StringBuffer1-3
	ld hl, PartyMon1Nickname
	ld a, BOXMON
	ld [MonType], a
	ld a, [CurPartyMon]
	call GetNick
	call CopyName1
; copy text from StringBuffer2 to StringBuffer3
	ld de, StringBuffer2
	ld hl, StringBuffer3
	call CopyName2
	ret
; c721

CheckEngineFlag: ; c721
; Check engine flag de
; Return carry if flag is not set
	ld b, CHECK_FLAG
	callba EngineFlagAction
	ld a, c
	and a
	jr nz, .isset
	scf
	ret
.isset
	xor a
	ret
; c731

CheckBadge: ; c731
; Check engine flag a (ENGINE_ZEPHYRBADGE thru ENGINE_EARTHBADGE)
; Display "Badge required" text and return carry if the badge is not owned
	call CheckEngineFlag
	ret nc
	ld hl, BadgeRequiredText
	call Function1d67 ; push text to queue
	scf
	ret
; c73d

BadgeRequiredText: ; c73d
	; Sorry! A new BADGE
	; is required.
	TX_FAR _BadgeRequiredText
	db "@"
; c742

CheckPartyMove: ; c742
; checks if a pokemon in your party has a move
; e = partymon being checked

; input: d = move id
	ld e, $00 ; mon #
	xor a
	ld [CurPartyMon], a
.checkmon
; check for valid species
	ld c, e
	ld b, $00
	ld hl, PartySpecies
	add hl, bc
	ld a, [hl]
	and a ; no id
	jr z, .quit
	cp a, $ff ; terminator
	jr z, .quit
	cp a, EGG
	jr z, .nextmon
; navigate to appropriate move table
	ld bc, PartyMon2 - PartyMon1
	ld hl, PartyMon1Moves
	ld a, e
	call AddNTimes
	ld b, $04 ; number of moves
.checkmove
	ld a, [hli]
	cp d ; move id
	jr z, .end
	dec b ; how many moves left?
	jr nz, .checkmove
.nextmon
	inc e ; mon #
	jr .checkmon
.end
	ld a, e
	ld [CurPartyMon], a ; which mon has the move
	xor a
	ret
.quit
	scf
	ret
; c779

Functionc779: ; c779
	ld hl, UnknownText_0xc780
	call Function1d67
	ret
; c780

UnknownText_0xc780: ; 0xc780
	text_jump UnknownText_0x1c05c8, BANK(UnknownText_0x1c05c8)
	db "@"
; 0xc785

Functionc785: ; c785
	call Functionc6ea
.asm_c788
	ld hl, $4796
	call Functionc6f5
	jr nc, .asm_c788
	and $7f
	ld [$d0ec], a
	ret
; c796

INCBIN "baserom.gbc", $c796, $c7c4 - $c796

UnknownText_0xc7c4: ; 0xc7c4
	text_jump UnknownText_0x1c05dd, BANK(UnknownText_0x1c05dd)
	db $50
; 0xc7c9

INCBIN "baserom.gbc", $c7c9, $c7ce - $c7c9

Functionc7ce: ; c7ce
	call GetFacingTileCoord
	ld c, a
	push de
	ld a, $5
	ld hl, $49f5
	rst FarCall
	pop de
	jr nc, .asm_c7fc
	call Function2a66
	ld c, [hl]
	push hl
	ld hl, $4862
	call Functionc840
	pop hl
	jr nc, .asm_c7fc
	ld a, l
	ld [$d1ec], a
	ld a, h
	ld [$d1ed], a
	ld a, b
	ld [$d1ee], a
	ld a, c
	ld [$d1ef], a
	xor a
	ret

.asm_c7fc
	scf
	ret
; c7fe

INCBIN "baserom.gbc", $c7fe, $c802 - $c7fe

UnknownScript_0xc802: ; 0xc802
	3callasm BANK(GetPartyNick), GetPartyNick
	2writetext UnknownText_0xc7c4
	reloadmappart
	3callasm BANK(Functionc810), Functionc810
	loadmovesprites
	end
; 0xc810

Functionc810: ; c810
	ld hl, $d1ec
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [$d1ee]
	ld [hl], a
	xor a
	ld [hBGMapMode], a
	call Function2173
	call Function1ad2
	call DelayFrame
	ld a, [$d1ef]
	ld e, a
	callba Function8c940
	call Function2879
	call Function2914
	call Function1ad2
	call DelayFrame
	call Functione51
	ret
; c840

Functionc840: ; c840
	push bc
	ld a, [$d199]
	ld de, 3
	call IsInArray
	pop bc
	jr nc, .asm_c860
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, 3
	ld a, c
	call IsInArray
	jr nc, .asm_c860
	inc hl
	ld b, [hl]
	inc hl
	ld c, [hl]
	scf
	ret

.asm_c860
	xor a
	ret
; c862

INCBIN "baserom.gbc", $c862, $c8ac - $c862

Functionc8ac: ; c8ac
	call Functionc8b5
	and $7f
	ld [$d0ec], a
	ret
; c8b5

Functionc8b5: ; c8b5
; Flash
	ld de, ENGINE_ZEPHYRBADGE
	callba CheckBadge
	jr c, .asm_c8dd
	push hl
	ld a, $22
	ld hl, $6e30
	rst FarCall
	pop hl
	jr c, .asm_c8d1
	ld a, [$d847]
	cp $ff
	jr nz, .asm_c8d7

.asm_c8d1
	call Functionc8e0
	ld a, $81
	ret

.asm_c8d7
	call Functionc779
	ld a, $80
	ret

.asm_c8dd
	ld a, $80
	ret
; c8e0

Functionc8e0: ; c8e0
	ld hl, UnknownScript_0xc8e6
	jp Function31cd
; c8e6

UnknownScript_0xc8e6: ; 0xc8e6
	reloadmappart
	special $0035
	2writetext UnknownText_0xc8f3
	3callasm $23, $47e1
	loadmovesprites
	end
; 0xc8f3

UnknownText_0xc8f3: ; 0xc8f3
	text_jump UnknownText_0x1c0609, BANK(UnknownText_0x1c0609)
	start_asm
; 0xc8f8

Functionc8f8: ; c8f8
	call WaitSFX
	ld de, SFX_FLASH
	call StartSFX
	call WaitSFX
	ld hl, UnknownText_0xc908
	ret
; c908

UnknownText_0xc908: ; 0xc908
	db "@"
; 0xc909

Functionc909: ; c909
	call Functionc6ea
.asm_c90c
	ld hl, $491a
	call Functionc6f5
	jr nc, .asm_c90c
	and $7f
	ld [$d0ec], a
	ret
; c91a

INCBIN "baserom.gbc", $c91a, $c986 - $c91a


UsedSurfScript: ; c986
	2writetext UsedSurfText ; "used SURF!"
	closetext
	loadmovesprites

	3callasm BANK(Functionc9a2), Functionc9a2 ; empty function

	copybytetovar Buffer2
	writevarcode VAR_MOVEMENT

	special SPECIAL_UPDATESPRITETILES
	special SPECIAL_BIKESURFMUSIC
; step into the water
	special SPECIAL_LOADFACESTEP ; (slow_step_x, step_end)
	applymovement 0, MovementBuffer ; PLAYER, MovementBuffer
	end
; c9a2

Functionc9a2: ; c9a2
	callba Function1060bb ; empty
	ret
; c9a9

UsedSurfText: ; c9a9
	TX_FAR _UsedSurfText ; [MONSTER] used
	db "@"	       ; SURF!
; c9ae

CantSurfText: ; c9ae
	TX_FAR _CantSurfText ; You can't SURF
	db "@"	       ; here.
; c9b3

AlreadySurfingText: ; c9b3
	TX_FAR _AlreadySurfingText ; You're already
	db "@"		     ; SURFING.
; c9b8


GetSurfType: ; c9b8
; Surfing on Pikachu uses an alternate sprite.
; This is done by using a separate movement type.

	ld a, [CurPartyMon]
	ld e, a
	ld d, 0
	ld hl, PartySpecies
	add hl, de

	ld a, [hl]
	cp PIKACHU
	ld a, PLAYER_SURF_PIKA
	ret z
	ld a, PLAYER_SURF
	ret
; c9cb


CheckDirection: ; c9cb
; Return carry if a tile permission prevents you
; from moving in the direction you're facing.

; Get player direction
	ld a, [PlayerDirection]
	and a, %00001100 ; bits 2 and 3 contain direction
	rrca
	rrca
	ld e, a
	ld d, 0
	ld hl, .Directions
	add hl, de

; Can you walk in this direction?
	ld a, [TilePermissions]
	and [hl]
	jr nz, .quit
	xor a
	ret

.quit
	scf
	ret

.Directions
	db FACE_DOWN
	db FACE_UP
	db FACE_LEFT
	db FACE_RIGHT
; c9e7


TrySurfOW: ; c9e7
; Checking a tile in the overworld.
; Return carry if surfing is allowed.

; Don't ask to surf if already surfing.
	ld a, [PlayerState]
	cp PLAYER_SURF_PIKA
	jr z, .quit
	cp PLAYER_SURF
	jr z, .quit

; Must be facing water.
	ld a, [EngineBuffer1]
	call GetTileCollision
	cp 1 ; surfable
	jr nz, .quit

; Check tile permissions.
	call CheckDirection
	jr c, .quit

	ld de, ENGINE_FOGBADGE
	call CheckEngineFlag
	jr c, .quit

	ld d, SURF
	call CheckPartyMove
	jr c, .quit

	ld hl, BikeFlags
	bit 1, [hl] ; always on bike (can't surf)
	jr nz, .quit

	call GetSurfType
	ld [MovementType], a
	call GetPartyNick

	ld a, BANK(AskSurfScript)
	ld hl, AskSurfScript
	call CallScript

	scf
	ret

.quit
	xor a
	ret
; ca2c


AskSurfScript: ; ca2c
	loadfont
	2writetext AskSurfText
	yesorno
	iftrue UsedSurfScript
	loadmovesprites
	end
; ca36

AskSurfText: ; ca36
	TX_FAR _AskSurfText ; The water is calm.
	db "@"              ; Want to SURF?
; ca3b


Functionca3b: ; ca3b
	call Functionc6ea
.asm_ca3e
	ld hl, .data_ca4c
	call Functionc6f5
	jr nc, .asm_ca3e
	and $7f
	ld [$d0ec], a
	ret
; ca4c

.data_ca4c
 	dw Functionca52
 	dw Functionca94
 	dw Functionca9d
; ca52


Functionca52: ; ca52
; Fly
	ld de, ENGINE_STORMBADGE
	call CheckBadge
	jr c, .asm_ca85
	call GetMapPermission
	call CheckOutdoorMap
	jr z, .asm_ca64
	jr .indoors

.asm_ca64
	xor a
	ld [$ffde], a
	call Function1d6e
	call ClearSprites
	callba Function91af3
	ld a, e
	cp $ff
	jr z, .asm_ca8b
	cp $1c
	jr nc, .asm_ca8b
	ld [$d001], a
	call Function1c17
	ld a, $1
	ret

.asm_ca85
	ld a, $82
	ret

.indoors
	ld a, $2
	ret

.asm_ca8b
	call Function1c17
	call WaitBGMap
	ld a, $80
	ret
; ca94

Functionca94: ; ca94
	ld hl, UnknownScript_0xcaa3
	call Function31cd
	ld a, $81
	ret
; ca9d

Functionca9d: ; ca9d
	call Functionc779
	ld a, $82
	ret
; caa3

UnknownScript_0xcaa3: ; 0xcaa3
	reloadmappart
	3callasm BANK(HideSprites), HideSprites
	special $0035
	3callasm $23, $4aed
	3call BANK(UnknownScript_0x122c1), UnknownScript_0x122c1
	special $0000
	3callasm $05, $54f1
	writecode $8, $0
	newloadmap $fc
	3callasm $23, $4b33
	special $003b
	3callasm BANK(Functioncacb), Functioncacb
	end
; 0xcacb

Functioncacb: ; cacb
	callba Function561d
	call DelayFrame
	call Functione4a
	callba Function106594
	ret
; cade

Functioncade: ; cade
	call Functioncae7
	and $7f
	ld [$d0ec], a
	ret
; cae7

Functioncae7: ; cae7
; Waterfall
	ld de, ENGINE_RISINGBADGE
	callba CheckBadge
	ld a, $80
	ret c
	call Functioncb07
	jr c, .asm_cb01
	ld hl, UnknownScript_0xcb1c
	call Function31cd
	ld a, $81
	ret

.asm_cb01
	call Functionc779
	ld a, $80
	ret
; cb07

Functioncb07: ; cb07
	ld a, [PlayerDirection]
	and $c
	cp FACE_UP
	jr nz, .asm_cb1a
	ld a, [TileUp]
	call CheckWaterfallTile
	jr nz, .asm_cb1a
	xor a
	ret

.asm_cb1a
	scf
	ret
; cb1c

UnknownScript_0xcb1c: ; 0xcb1c
	reloadmappart
	special $0035

UnknownScript_0xcb20: ; 0xcb20
	3callasm BANK(GetPartyNick), GetPartyNick
	2writetext UnknownText_0xcb51
	closetext
	loadmovesprites
	playsound SFX_BUBBLEBEAM
.loop
	applymovement $0, WaterfallStep
	3callasm BANK(Functioncb38), Functioncb38
	iffalse .loop
	end
; 0xcb38

Functioncb38: ; cb38
	xor a
	ld [ScriptVar], a
	ld a, [StandingTile]
	call CheckWaterfallTile
	ret z
	ld a, $41
	ld hl, $60c1
	rst FarCall
	ld a, $1
	ld [ScriptVar], a
	ret
; cb4f

WaterfallStep: ; cb4f
	turn_waterfall_up
	step_end
; cb51

UnknownText_0xcb51: ; 0xcb51
	text_jump UnknownText_0x1c068e, BANK(UnknownText_0x1c068e)
	db "@"
; 0xcb56

TryWaterfallOW: ; cb56
	ld d, WATERFALL
	call CheckPartyMove
	jr c, .asm_cb74
	ld de, ENGINE_RISINGBADGE
	call CheckEngineFlag
	jr c, .asm_cb74
	call Functioncb07
	jr c, .asm_cb74
	ld a, BANK(UnknownScript_0xcb86)
	ld hl, UnknownScript_0xcb86
	call CallScript
	scf
	ret

.asm_cb74
	ld a, BANK(UnknownScript_0xcb7e)
	ld hl, UnknownScript_0xcb7e
	call CallScript
	scf
	ret
; cb7e

UnknownScript_0xcb7e: ; 0xcb7e
	jumptext UnknownText_0xcb81
; 0xcb81

UnknownText_0xcb81: ; 0xcb81
	text_jump UnknownText_0x1c06a3, BANK(UnknownText_0x1c06a3)
	db "@"
; 0xcb86

UnknownScript_0xcb86: ; 0xcb86
	loadfont
	2writetext UnknownText_0xcb90
	yesorno
	iftrue UnknownScript_0xcb20
	loadmovesprites
	end
; 0xcb90

UnknownText_0xcb90: ; 0xcb90
	text_jump UnknownText_0x1c06bf, BANK(UnknownText_0x1c06bf)
	db "@"
; 0xcb95


Functioncb95: ; cb95
	call Functionc6ea
	ld a, $1
	jr .asm_cba1

	call Functionc6ea
	ld a, $2

.asm_cba1
	ld [Buffer2], a
.asm_cba4
	ld hl, Tablecbb2
	call Functionc6f5
	jr nc, .asm_cba4
	and $7f
	ld [$d0ec], a
	ret
; cbb2

Tablecbb2: ; cbb2
	dw Functioncbb8
	dw Functioncbd8
	dw Functioncc06
; cbb8

Functioncbb8: ; cbb8
	call GetMapPermission
	cp $4
	jr z, .asm_cbc6
	cp $7
	jr z, .asm_cbc6
.asm_cbc3
	ld a, $2
	ret

.asm_cbc6
	ld hl, $dca9
	ld a, [hli]
	and a
	jr z, .asm_cbc3
	ld a, [hli]
	and a
	jr z, .asm_cbc3
	ld a, [hl]
	and a
	jr z, .asm_cbc3
	ld a, $1
	ret
; cbd8

Functioncbd8: ; cbd8
	ld hl, $dca9
	ld de, $d146
	ld bc, $0003
	call CopyBytes
	call GetPartyNick
	ld a, [Buffer2]
	cp $2
	jr nz, .asm_cbf7
	ld hl, UnknownScript_0xcc35
	call Function31cd
	ld a, $81
	ret

.asm_cbf7
	callba Function8ae4e
	ld hl, UnknownScript_0xcc2b
	call Function31cd
	ld a, $81
	ret
; cc06

Functioncc06: ; cc06
	ld a, [Buffer2]
	cp $2
	jr nz, .asm_cc19
	ld hl, UnknownText_0xcc26
	call Function1d4f
	call Functiona80
	call Function1c17

.asm_cc19
	ld a, $80
	ret
; cc1c

UnknownText_0xcc1c: ; 0xcc1c
	; used DIG!
	text_jump UnknownText_0x1c06de, BANK(UnknownText_0x1c06de)
	db "@"
; 0xcc21

UnknownText_0xcc21: ; 0xcc21
	; used an ESCAPE ROPE.
	text_jump UnknownText_0x1c06ed, BANK(UnknownText_0x1c06ed)
	db "@"
; 0xcc26

UnknownText_0xcc26: ; 0xcc26
	; Can't use that here.
	text_jump UnknownText_0x1c0705, BANK(UnknownText_0x1c0705)
	db "@"
; 0xcc2b

UnknownScript_0xcc2b: ; 0xcc2b
	reloadmappart
	special $0035
	2writetext UnknownText_0xcc21
	2jump UnknownScript_0xcc3c
; 0xcc35

UnknownScript_0xcc35: ; 0xcc35
	reloadmappart
	special $0035
	2writetext UnknownText_0xcc1c

UnknownScript_0xcc3c: ; 0xcc3c
	closetext
	loadmovesprites
	playsound SFX_WARP_TO
	applymovement $0, MovementData_0xcc59
	3call BANK(UnknownScript_0x122c1), UnknownScript_0x122c1
	special $0000
	writecode $8, $0
	newloadmap $f5
	playsound SFX_WARP_FROM
	applymovement $0, MovementData_0xcc5d
	end
; 0xcc59

MovementData_0xcc59: ; 0xcc59
	step_wait5
	turn_away_down
	hide_person
	step_end
; 0xcc5d

MovementData_0xcc5d: ; 0xcc5d
	db $3c, $58
	turn_away_down
	step_end
; 0xcc61

Functioncc61: ; cc61
	call Functionc6ea
.asm_cc64
	ld hl, Tablecc72
	call Functionc6f5
	jr nc, .asm_cc64
	and $7f
	ld [$d0ec], a
	ret
; cc72

Tablecc72: ; cc72
	dw Functioncc78
	dw Functioncc9c
	dw Functioncca8
; cc78

Functioncc78: ; cc78
	call GetMapPermission
	call CheckOutdoorMap
	jr z, .asm_cc82
	jr .asm_cc99

.asm_cc82
	ld a, [$dcb2]
	ld d, a
	ld a, [$dcb3]
	ld e, a
	callba Function15344
	jr nc, .asm_cc99
	ld a, c
	ld [$d001], a
	ld a, $1
	ret

.asm_cc99
	ld a, $2
	ret
; cc9c

Functioncc9c: ; cc9c
	call GetPartyNick
	ld hl, $4cbb
	call Function31cd
	ld a, $81
	ret
; cca8

Functioncca8: ; cca8
	ld hl, $4cb6
	call Function1d67
	ld a, $80
	ret
; ccb1

INCBIN "baserom.gbc", $ccb1, $cce5 - $ccb1

Functioncce5: ; cce5
	call Functionccee
	and $7f
	ld [$d0ec], a
	ret
; ccee

Functionccee: ; ccee
; Strength
	ld de, ENGINE_PLAINBADGE
	call CheckBadge
	jr c, Functioncd06
	jr Functioncd09
; ccf8

Functionccf8: ; ccf8
	ld hl, UnknownText_0xcd01
	call Function1d67
	ld a, $80
	ret
; cd01

UnknownText_0xcd01: ; 0xcd01
	text_jump UnknownText_0x1c0751, BANK(UnknownText_0x1c0751)
	db "@"
; 0xcd06

Functioncd06: ; cd06
	ld a, $80
	ret
; cd09

Functioncd09: ; cd09
	ld hl, UnknownScript_0xcd29
	call Function31cd
	ld a, $81
	ret
; cd12

Functioncd12: ; cd12
	ld hl, BikeFlags
	set 0, [hl]
	ld a, [CurPartyMon]
	ld e, a
	ld d, 0
	; fallthrough
; cd1d

Functioncd1d: ; cd1d
	ld hl, PartySpecies
	add hl, de
	ld a, [hl]
	ld [$d1ef], a
	call GetPartyNick
	ret
; cd29

UnknownScript_0xcd29: ; 0xcd29
	reloadmappart
	special $0035
	3callasm BANK(Functioncd12), Functioncd12
	2writetext UnknownText_0xcd41
	copybytetovar $d1ef
	cry $0000
	pause 3
	2writetext UnknownText_0xcd46
	loadmovesprites
	end
; 0xcd41

UnknownText_0xcd41: ; 0xcd41
	text_jump UnknownText_0x1c0774, BANK(UnknownText_0x1c0774)
	db $50
; 0xcd46

UnknownText_0xcd46: ; 0xcd46
	text_jump UnknownText_0x1c0788, BANK(UnknownText_0x1c0788)
	db $50
; 0xcd4b

INCBIN "baserom.gbc", $cd4b, $cd9d - $cd4b

Functioncd9d: ; cd9d
	call Functionc6ea
.asm_cda0
	ld hl, $4dae
	call Functionc6f5
	jr nc, .asm_cda0
	and $7f
	ld [$d0ec], a
	ret
; cdae

INCBIN "baserom.gbc", $cdae, $cdd9 - $cdae

UnknownText_0xcdd9: ; 0xcdd9
	text_jump UnknownText_0x1c0816, BANK(UnknownText_0x1c0816)
	db "@"
; 0xcdde

Functioncdde: ; cdde
	call GetFacingTileCoord
	ld c, a
	push de
	call CheckWhirlpoolTile
	pop de
	jr c, .asm_ce09
	call Function2a66
	ld c, [hl]
	push hl
	ld hl, $48a4
	call Functionc840
	pop hl
	jr nc, .asm_ce09
	ld a, l
	ld [$d1ec], a
	ld a, h
	ld [$d1ed], a
	ld a, b
	ld [$d1ee], a
	ld a, c
	ld [$d1ef], a
	xor a
	ret

.asm_ce09
	scf
	ret
; ce0b

INCBIN "baserom.gbc", $ce0b, $ce0f - $ce0b

UnknownScript_0xce0f: ; 0xce0f
	3callasm BANK(GetPartyNick), GetPartyNick
	2writetext UnknownText_0xcdd9
	reloadmappart
	3callasm BANK(Functionce1d), Functionce1d
	loadmovesprites
	end
; 0xce1d

Functionce1d: ; ce1d
	ld hl, $d1ec
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [$d1ee]
	ld [hl], a
	xor a
	ld [hBGMapMode], a
	call Function2173
	ld a, [$d1ef]
	ld e, a
	ld a, $23
	ld hl, $47d4
	rst FarCall
	call Function2879
	call Function2914
	ret
; ce3e

TryWhirlpoolOW: ; ce3e
	ld d, WHIRLPOOL
	call CheckPartyMove
	jr c, .asm_ce5c
	ld de, ENGINE_GLACIERBADGE
	call CheckEngineFlag
	jr c, .asm_ce5c
	call Functioncdde
	jr c, .asm_ce5c
	ld a, BANK(UnknownScript_0xce6e)
	ld hl, UnknownScript_0xce6e
	call CallScript
	scf
	ret

.asm_ce5c
	ld a, BANK(UnknownScript_0xce66)
	ld hl, UnknownScript_0xce66
	call CallScript
	scf
	ret
; ce66

UnknownScript_0xce66: ; 0xce66
	jumptext UnknownText_0xce69
; 0xce69

UnknownText_0xce69: ; 0xce69
	text_jump UnknownText_0x1c082b, BANK(UnknownText_0x1c082b)
	db "@"
; 0xce6e

UnknownScript_0xce6e: ; 0xce6e
	loadfont
	2writetext UnknownText_0xce78
	yesorno
	iftrue UnknownScript_0xce0f
	loadmovesprites
	end
; 0xce78

UnknownText_0xce78: ; 0xce78
	text_jump UnknownText_0x1c0864, BANK(UnknownText_0x1c0864)
	db "@"
; 0xce7d

Functionce7d: ; ce7d
	call Functionce86
	and $7f
	ld [$d0ec], a
	ret
; ce86

Functionce86: ; ce86
	call GetFacingTileCoord
	call CheckHeadbuttTreeTile
	jr nz, .asm_ce97
	ld hl, UnknownScript_0xcea7
	call Function31cd
	ld a, $81
	ret

.asm_ce97
	call Functionc779
	ld a, $80
	ret
; ce9d

UnknownText_0xce9d: ; 0xce9d
	text_jump UnknownText_0x1c0897, BANK(UnknownText_0x1c0897)
	db $50
; 0xcea2

UnknownText_0xcea2: ; 0xcea2
	text_jump UnknownText_0x1c08ac, BANK(UnknownText_0x1c08ac)
	db $50
; 0xcea7

UnknownScript_0xcea7: ; 0xcea7
	reloadmappart
	special $0035
	3callasm BANK(GetPartyNick), GetPartyNick
	2writetext UnknownText_0xce9d
	reloadmappart
	3callasm $23, $480a
	3callasm $2e, $41ea
	iffalse UnknownScript_0xcec3
	loadmovesprites
	battlecheck
	startbattle
	returnafterbattle
	end
; 0xcec3

UnknownScript_0xcec3: ; 0xcec3
	2writetext UnknownText_0xcea2
	closetext
	loadmovesprites
	end
; 0xcec9

TryHeadbuttOW: ; cec9
	ld d, $1d
	call CheckPartyMove
	jr c, .asm_ceda
	ld a, $3
	ld hl, $4edc
	call CallScript
	scf
	ret

.asm_ceda
	xor a
	ret
; cedc

INCBIN "baserom.gbc", $cedc, $ceeb - $cedc

Functionceeb: ; ceeb
	call Functioncef4
	and $7f
	ld [$d0ec], a
	ret
; cef4

Functioncef4: ; cef4
	call Functioncf0d
	jr c, .asm_cf07
	ld a, d
	cp $18
	jr nz, .asm_cf07
	ld hl, UnknownScript_0xcf2e
	call Function31cd
	ld a, $81
	ret

.asm_cf07
	call Functionc779
	ld a, $80
	ret
; cf0d

Functioncf0d: ; cf0d
	callba CheckFacingObject
	jr nc, .asm_cf2c
	ld a, [hConnectedMapWidth]
	call Function1ae5
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	ld [$ffe0], a
	call GetMapObject
	ld hl, $0004
	add hl, bc
	ld a, [hl]
	ld d, a
	and a
	ret

.asm_cf2c
	scf
	ret
; cf2e

UnknownScript_0xcf2e: ; 0xcf2e
	reloadmappart
	special $0035
	3callasm BANK(GetPartyNick), GetPartyNick
	2writetext UnknownText_0xcf58
	loadmovesprites
	special $003b
	playsound SFX_STRENGTH
	earthquake 84
	applymovement2 MovementData_0xcf55
	disappear $fe
	3callasm $2e, $4219
	copybytetovar $d22e
	iffalse .done
	battlecheck
	startbattle
	returnafterbattle
.done
	end
; 0xcf55

MovementData_0xcf55: ; 0xcf55
	db $57, $0a
	step_end

UnknownText_0xcf58: ; 0xcf58
	text_jump UnknownText_0x1c08f0, BANK(UnknownText_0x1c08f0)
	db $50
; 0xcf5d

INCBIN "baserom.gbc", $cf5d, $cf8e - $cf5d


Functioncf8e: ; cf8e
	ld a, e
	push af
	call Functionc6ea
	pop af
	ld [Buffer2], a
.asm_cf97
	ld hl, $4fa5
	call Functionc6f5
	jr nc, .asm_cf97
	and $7f
	ld [$d0ec], a
	ret
; cfa5


INCBIN "baserom.gbc", $cfa5, $d0b3 - $cfa5


Functiond0b3: ; d0b3
	call Functiond0bc
	and $7f
	ld [$d0ec], a
	ret
; d0bc

Functiond0bc: ; d0bc
	call Functiond121
	jr c, .asm_d110
	ld a, [PlayerState]
	cp $0
	jr z, .asm_d0ce
	cp $1
	jr z, .asm_d0f7
	jr .asm_d110

.asm_d0ce
	ld hl, $513e
	ld de, $514e
	call Functiond119
	call Function31cd
	xor a
	ld [MusicFade], a
	ld de, $0000
	call StartMusic
	call DelayFrame
	call MaxVolume
	ld de, $0013
	ld a, e
	ld [CurMusic], a
	call StartMusic
	ld a, $1
	ret

.asm_d0f7
	ld hl, BikeFlags
	bit 1, [hl]
	jr nz, .asm_d10b
	ld hl, $5158
	ld de, $516b
	call Functiond119
	ld a, $3
	jr .asm_d113

.asm_d10b
	ld hl, $5171
	jr .asm_d113

.asm_d110
	ld a, $0
	ret

.asm_d113
	call Function31cd
	ld a, $1
	ret
; d119

Functiond119: ; d119
	ld a, [$d0ef]
	and a
	ret z
	ld h, d
	ld l, e
	ret
; d121

Functiond121: ; d121
	call GetMapPermission
	call CheckOutdoorMap
	jr z, .asm_d133
	cp $4
	jr z, .asm_d133
	cp $6
	jr z, .asm_d133
	jr .asm_d13c

.asm_d133
	call Function184a
	and $f
	jr nz, .asm_d13c
	xor a
	ret

.asm_d13c
	scf
	ret
; d13e

INCBIN "baserom.gbc", $d13e, $d186 - $d13e

TryCutOW: ; d186
	ld d, CUT
	call CheckPartyMove
	jr c, .asm_d19f
	ld de, ENGINE_HIVEBADGE
	call CheckEngineFlag
	jr c, .asm_d19f
	ld a, BANK(UnknownScript_0xd1a9)
	ld hl, UnknownScript_0xd1a9
	call CallScript
	scf
	ret

.asm_d19f
	ld a, BANK(UnknownScript_0xd1cd)
	ld hl, UnknownScript_0xd1cd
	call CallScript
	scf
	ret
; d1a9

UnknownScript_0xd1a9: ; 0xd1a9
	loadfont
	2writetext UnknownText_0xd1c8
	yesorno
	iffalse .script_d1b8
	3callasm BANK(Functiond1ba), Functiond1ba
	iftrue UnknownScript_0xc802
.script_d1b8
	loadmovesprites
	end
; 0xd1ba

Functiond1ba: ; d1ba
	xor a
	ld [ScriptVar], a
	call Functionc7ce
	ret c
	ld a, $1
	ld [ScriptVar], a
	ret
; d1c8

UnknownText_0xd1c8: ; 0xd1c8
	text_jump UnknownText_0x1c09dd, BANK(UnknownText_0x1c09dd)
	db "@"
; 0xd1cd

UnknownScript_0xd1cd: ; 0xd1cd
	jumptext UnknownText_0xd1d0
; 0xd1d0

UnknownText_0xd1d0: ; 0xd1d0
	text_jump UnknownText_0x1c0a05, BANK(UnknownText_0x1c0a05)
	db "@"
; 0xd1d5


Functiond1d5: ; d1d5
	call Functiond27b
	jp nz, Functiond29c
	push hl
	call CheckItemPocket
	pop de
	ld a, [$d142]
	dec a
	ld hl, Tabled1e9
	rst JumpTable
	ret
; d1e9

Tabled1e9: ; d1e9
	dw Functiond1f1
	dw Functiond1f6
	dw Functiond1fb
	dw Functiond201
; d1f1

Functiond1f1: ; d1f1
	ld h, d
	ld l, e
	jp Functiond29c
; d1f6

Functiond1f6: ; d1f6
	ld h, d
	ld l, e
	jp Functiond35a
; d1fb

Functiond1fb: ; d1fb
	ld hl, NumBalls
	jp Functiond29c
; d201

Functiond201: ; d201
	ld h, d
	ld l, e
	ld a, [CurItem]
	ld c, a
	call GetTMHMNumber
	jp Functiond3c4
; d20d


Functiond20d: ; d20d
	call Functiond27b
	jr nz, .asm_d241
	push hl
	call CheckItemPocket
	pop de
	ld a, [$d142]
	dec a
	ld hl, .data_d220
	rst JumpTable
	ret

.data_d220
	dw .Item
	dw .KeyItem
	dw .Ball
	dw .TMHM
; d228

.Ball ; d228
	ld hl, NumBalls
	jp Functiond2ff
; d22e

.TMHM ; d22e
	ld h, d
	ld l, e
	ld a, [CurItem]
	ld c, a
	call GetTMHMNumber
	jp Functiond3d8
; d23a

.KeyItem ; d23a
	ld h, d
	ld l, e
	jp Functiond374
; d23f

.Item ; d23f
	ld h, d
	ld l, e
; d241

.asm_d241
	jp Functiond2ff
; d244

_PickUpItem: ; d244
	call Functiond27b
	jr nz, .asm_d278
	push hl
	call CheckItemPocket
	pop de
	ld a, [$d142]
	dec a
	ld hl, .data_d257
	rst JumpTable
	ret

.data_d257
	dw .Item
	dw .KeyItem
	dw .Ball
	dw .TMHM
; d25f

.Ball ; d25f
	ld hl, NumBalls
	jp Functiond349
; d265

.TMHM ; d265
	ld h, d
	ld l, e
	ld a, [CurItem]
	ld c, a
	call GetTMHMNumber
	jp Functiond3fb
; d271

.KeyItem ; d271
	ld h, d
	ld l, e
	jp Functiond3b1
; d276

.Item ; d276
	ld h, d
	ld l, e
; d278

.asm_d278
	jp Functiond349
; d27b

Functiond27b: ; d27b
	ld a, l
	cp TMsHMsEnd % $100
	ret nz
	ld a, h
	cp TMsHMsEnd / $100
	ret
; d283

Functiond283: ; d283
	ld c, $14
	ld a, e
	cp TMsHMsEnd % $100
	jr nz, .asm_d28e
	ld a, d
	cp TMsHMsEnd / $100
	ret z

.asm_d28e
	ld c, $32
	ld a, e
	cp BallsEnd % $100
	jr nz, .asm_d299
	ld a, d
	cp BallsEnd / $100
	ret z

.asm_d299
	ld c, $c
	ret
; d29c

Functiond29c: ; d29c
	ld d, h
	ld e, l
	inc hl
	ld a, [CurItem]
	ld c, a
	ld b, 0
.asm_d2a5
	ld a, [hli]
	cp $ff
	jr z, .asm_d2bd
	cp c
	jr nz, .asm_d2ba
	ld a, $63
	sub [hl]
	add b
	ld b, a
	ld a, [$d10c]
	cp b
	jr z, .asm_d2c6
	jr c, .asm_d2c6

.asm_d2ba
	inc hl
	jr .asm_d2a5

.asm_d2bd
	call Functiond283
	ld a, [de]
	cp c
	jr c, .asm_d2c6
	and a
	ret

.asm_d2c6
	ld h, d
	ld l, e
	ld a, [CurItem]
	ld c, a
	ld a, [$d10c]
	ld [$d10d], a
.asm_d2d2
	inc hl
	ld a, [hli]
	cp $ff
	jr z, .asm_d2ef
	cp c
	jr nz, .asm_d2d2
	ld a, [$d10d]
	add [hl]
	cp $64
	jr nc, .asm_d2e6
	ld [hl], a
	jr .asm_d2fd

.asm_d2e6
	ld [hl], $63
	sub $63
	ld [$d10d], a
	jr .asm_d2d2

.asm_d2ef
	dec hl
	ld a, [CurItem]
	ld [hli], a
	ld a, [$d10d]
	ld [hli], a
	ld [hl], $ff
	ld h, d
	ld l, e
	inc [hl]

.asm_d2fd
	scf
	ret
; d2ff

Functiond2ff: ; d2ff
	ld d, h
	ld e, l
	ld a, [hli]
	ld c, a
	ld a, [$d107]
	cp c
	jr nc, .asm_d318
	ld c, a
	ld b, $0
	add hl, bc
	add hl, bc
	ld a, [CurItem]
	cp [hl]
	inc hl
	jr z, .asm_d327
	ld h, d
	ld l, e
	inc hl

.asm_d318
	ld a, [CurItem]
	ld b, a
.asm_d31c
	ld a, [hli]
	cp b
	jr z, .asm_d327
	cp $ff
	jr z, .asm_d347
	inc hl
	jr .asm_d31c

.asm_d327
	ld a, [$d10c]
	ld b, a
	ld a, [hl]
	sub b
	jr c, .asm_d347
	ld [hl], a
	ld [$d10d], a
	and a
	jr nz, .asm_d345
	dec hl
	ld b, h
	ld c, l
	inc hl
	inc hl
.asm_d33b
	ld a, [hli]
	ld [bc], a
	inc bc
	cp $ff
	jr nz, .asm_d33b
	ld h, d
	ld l, e
	dec [hl]

.asm_d345
	scf
	ret

.asm_d347
	and a
	ret
; d349

Functiond349: ; d349
	ld a, [CurItem]
	ld c, a
.asm_d34d
	inc hl
	ld a, [hli]
	cp $ff
	jr z, .asm_d358
	cp c
	jr nz, .asm_d34d
	scf
	ret

.asm_d358
	and a
	ret
; d35a

Functiond35a: ; d35a
	ld hl, NumKeyItems
	ld a, [hli]
	cp $19
	jr nc, .asm_d372
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [CurItem]
	ld [hli], a
	ld [hl], $ff
	ld hl, NumKeyItems
	inc [hl]
	scf
	ret

.asm_d372
	and a
	ret
; d374

Functiond374: ; d374
	ld a, [$d107]
	ld e, a
	ld d, $0
	ld hl, NumKeyItems
	ld a, [hl]
	cp e
	jr nc, .asm_d387
	call Functiond396
	ret nc
	jr .asm_d38a

.asm_d387
	dec [hl]
	inc hl
	add hl, de

.asm_d38a
	ld d, h
	ld e, l
	inc hl
.asm_d38d
	ld a, [hli]
	ld [de], a
	inc de
	cp $ff
	jr nz, .asm_d38d
	scf
	ret
; d396

Functiond396: ; d396
	ld hl, NumKeyItems
	ld a, [CurItem]
	ld c, a
.asm_d39d
	inc hl
	ld a, [hl]
	cp c
	jr z, .asm_d3a8
	cp $ff
	jr nz, .asm_d39d
	xor a
	ret

.asm_d3a8
	ld a, [NumKeyItems]
	dec a
	ld [NumKeyItems], a
	scf
	ret
; d3b1

Functiond3b1: ; d3b1
	ld a, [CurItem]
	ld c, a
	ld hl, KeyItems
.asm_d3b8
	ld a, [hli]
	cp c
	jr z, .asm_d3c2
	cp $ff
	jr nz, .asm_d3b8
	and a
	ret

.asm_d3c2
	scf
	ret
; d3c4



Functiond3c4: ; d3c4
	dec c
	ld b, $0
	ld hl, TMsHMs
	add hl, bc
	ld a, [$d10c]
	add [hl]
	cp $64
	jr nc, .asm_d3d6
	ld [hl], a
	scf
	ret

.asm_d3d6
	and a
	ret
; d3d8

Functiond3d8: ; d3d8
	dec c
	ld b, $0
	ld hl, TMsHMs
	add hl, bc
	ld a, [$d10c]
	ld b, a
	ld a, [hl]
	sub b
	jr c, .asm_d3f9
	ld [hl], a
	ld [$d10d], a
	jr nz, .asm_d3f7
	ld a, [$d0e2]
	and a
	jr z, .asm_d3f7
	dec a
	ld [$d0e2], a

.asm_d3f7
	scf
	ret

.asm_d3f9
	and a
	ret
; d3fb

Functiond3fb: ; d3fb
	dec c
	ld b, $0
	ld hl, TMsHMs
	add hl, bc
	ld a, [hl]
	and a
	ret z
	scf
	ret
; d407



GetTMHMNumber: ; d407
; Return the number of a TM/HM by item id c.

	ld a, c

; Skip any dummy items.
	cp $c3 ; TM04-05
	jr c, .done
	cp $dc ; TM28-29
	jr c, .skip

	dec a
.skip
	dec a
.done
	sub TM_01
	inc a
	ld c, a
	ret
; d417


GetNumberedTMHM: ; d417
; Return the item id of a TM/HM by number c.

	ld a, c 

; Skip any gaps.
	cp 5
	jr c, .done
	cp 29
	jr c, .skip

	inc a
.skip
	inc a
.done
	add TM_01
	dec a
	ld c, a
	ret
; d427


_CheckTossableItem: ; d427
; Return 1 in $d142 and carry if CurItem can't be removed from the bag.
	ld a, 4
	call GetItemAttr
	bit 7, a
	jr nz, Function0xd47f
	and a
	ret
; d432

CheckSelectableItem: ; d432
; Return 1 in $d142 and carry if CurItem can't be selected.
	ld a, 4
	call GetItemAttr
	bit 6, a
	jr nz, Function0xd47f
	and a
	ret
; d43d

CheckItemPocket: ; d43d
; Return the pocket for CurItem in $d142.
	ld a, 5
	call GetItemAttr
	and $f
	ld [$d142], a
	ret
; d448

CheckItemContext: ; d448
; Return the context for CurItem in $d142.
	ld a, 6
	call GetItemAttr
	and $f
	ld [$d142], a
	ret
; d453

CheckItemMenu: ; d453
; Return the menu for CurItem in $d142.
	ld a, 6
	call GetItemAttr
	swap a
	and $f
	ld [$d142], a
	ret
; d460

GetItemAttr: ; d460
; Get attribute a of CurItem.

	push hl
	push bc

	ld hl, ItemAttributes
	ld c, a
	ld b, 0
	add hl, bc

	xor a
	ld [$d142], a

	ld a, [CurItem]
	dec a
	ld c, a
	ld a, 7
	call AddNTimes
	ld a, BANK(ItemAttributes)
	call GetFarByte

	pop bc
	pop hl
	ret
; d47f

Function0xd47f: ; d47f
	ld a, 1
	ld [$d142], a
	scf
	ret
; d486


GetItemPrice: ; d486
; Return the price of CurItem in de.
	push hl
	push bc
	ld a, $0
	call GetItemAttr
	ld e, a
	ld a, $1
	call GetItemAttr
	ld d, a
	pop bc
	pop hl
	ret
; d497

INCBIN "baserom.gbc", $d497, $d88c - $d497


Functiond88c: ; d88c
	ld de, PartyCount
	ld a, [MonType]
	and $f
	jr z, .asm_d899
	ld de, OTPartyCount

.asm_d899
	ld a, [de]
	inc a
	cp $7
	ret nc
	ld [de], a
	ld a, [de]
	ld [$ffae], a
	add e
	ld e, a
	jr nc, .asm_d8a7
	inc d

.asm_d8a7
	ld a, [CurPartySpecies]
	ld [de], a
	inc de
	ld a, $ff
	ld [de], a
	ld hl, PartyMon1OT
	ld a, [MonType]
	and $f
	jr z, .asm_d8bc
	ld hl, OTPartyMon1OT

.asm_d8bc
	ld a, [$ffae]
	dec a
	call SkipNames
	ld d, h
	ld e, l
	ld hl, PlayerName
	ld bc, $000b
	call CopyBytes
	ld a, [MonType]
	and a
	jr nz, .asm_d8f0
	ld a, [CurPartySpecies]
	ld [$d265], a
	call GetPokemonName
	ld hl, PartyMon1Nickname
	ld a, [$ffae]
	dec a
	call SkipNames
	ld d, h
	ld e, l
	ld hl, StringBuffer1
	ld bc, $000b
	call CopyBytes

.asm_d8f0
	ld hl, PartyMon1Species
	ld a, [MonType]
	and $f
	jr z, .asm_d8fd
	ld hl, OTPartyMon1Species

.asm_d8fd
	ld a, [$ffae]
	dec a
	ld bc, $0030
	call AddNTimes
	ld e, l
	ld d, h
	push hl
	ld a, [CurPartySpecies]
	ld [CurSpecies], a
	call GetBaseData
	ld a, [BaseDexNo]
	ld [de], a
	inc de
	ld a, [IsInBattle]
	and a
	ld a, $0
	jr z, .asm_d922
	ld a, [EnemyMonItem]

.asm_d922
	ld [de], a
	inc de
	push de
	ld h, d
	ld l, e
	ld a, [IsInBattle]
	and a
	jr z, .asm_d943
	ld a, [MonType]
	and a
	jr nz, .asm_d943
	ld de, EnemyMonMove1
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	jr .asm_d950

.asm_d943
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [MagikarpLength], a
	ld a, $1b
	call Predef

.asm_d950
	pop de
	inc de
	inc de
	inc de
	inc de
	ld a, [PlayerID]
	ld [de], a
	inc de
	ld a, [$d47c]
	ld [de], a
	inc de
	push de
	ld a, [CurPartyLevel]
	ld d, a
	ld hl, $4e47
	ld a, $14
	rst FarCall
	pop de
	ld a, [hMultiplicand]
	ld [de], a
	inc de
	ld a, [$ffb5]
	ld [de], a
	inc de
	ld a, [$ffb6]
	ld [de], a
	inc de
	xor a
	ld b, $a
.asm_d97a
	ld [de], a
	inc de
	dec b
	jr nz, .asm_d97a
	pop hl
	push hl
	ld a, [MonType]
	and $f
	jr z, .asm_d992
	push hl
	callba GetTrainerDVs
	pop hl
	jr .asm_d9b5

.asm_d992
	ld a, [CurPartySpecies]
	ld [$d265], a
	dec a
	push de
	call CheckSeenMon
	ld a, [$d265]
	dec a
	call SetSeenAndCaughtMon
	pop de
	pop hl
	push hl
	ld a, [IsInBattle]
	and a
	jr nz, .asm_d9f3
	call Random
	ld b, a
	call Random
	ld c, a

.asm_d9b5
	ld a, b
	ld [de], a
	inc de
	ld a, c
	ld [de], a
	inc de
	push hl
	push de
	inc hl
	inc hl
	call FillPP
	pop de
	pop hl
	inc de
	inc de
	inc de
	inc de
	ld a, $46
	ld [de], a
	inc de
	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld a, [CurPartyLevel]
	ld [de], a
	inc de
	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld bc, $000a
	add hl, bc
	ld a, $1
	ld c, a
	ld b, $0
	call Functione17b
	ld a, [$ffb5]
	ld [de], a
	inc de
	ld a, [$ffb6]
	ld [de], a
	inc de
	jr .asm_da29

.asm_d9f3
	ld a, [EnemyMonAtkDefDV]
	ld [de], a
	inc de
	ld a, [EnemyMonSpdSpclDV]
	ld [de], a
	inc de
	push hl
	ld hl, EnemyMonPPMove1
	ld b, $4
.asm_da03
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_da03
	pop hl
	ld a, $46
	ld [de], a
	inc de
	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld a, [CurPartyLevel]
	ld [de], a
	inc de
	ld hl, EnemyMonStatus
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de

.asm_da29
	ld a, [IsInBattle]
	dec a
	jr nz, .asm_da3b
	ld hl, EnemyMonMaxHPHi
	ld bc, $000c
	call CopyBytes
	pop hl
	jr .asm_da45

.asm_da3b
	pop hl
	ld bc, $000a
	add hl, bc
	ld b, $0
	call Functione167

.asm_da45
	ld a, [MonType]
	and $f
	jr nz, .asm_da6b
	ld a, [CurPartySpecies]
	cp $c9
	jr nz, .asm_da6b
	ld hl, PartyMon1DVs
	ld a, [PartyCount]
	dec a
	ld bc, $0030
	call AddNTimes
	ld a, $2d
	call Predef
	ld hl, $7a18
	ld a, $3e
	rst FarCall

.asm_da6b
	scf
	ret
; da6d

FillPP: ; da6d
	push bc
	ld b, $4
.asm_da70
	ld a, [hli]
	and a
	jr z, .asm_da8f
	dec a
	push hl
	push de
	push bc
	ld hl, $5afb
	ld bc, $0007
	call AddNTimes
	ld de, StringBuffer1
	ld a, $10
	call FarCopyBytes
	pop bc
	pop de
	pop hl
	ld a, [$d078]

.asm_da8f
	ld [de], a
	inc de
	dec b
	jr nz, .asm_da70
	pop bc
	ret
; da96

INCBIN "baserom.gbc", $da96, $dcb6 - $da96


Functiondcb6: ; dcb6

	ld a, b
	ld hl, BoxMons
	ld bc, BoxMon2 - BoxMon1
	call AddNTimes
	ld b, h
	ld c, l
	ld hl, BoxMon1PP - BoxMon1
	add hl, bc
	push hl
	push bc
	ld de, TempMonPP
	ld bc, NUM_MOVES
	call CopyBytes
	pop bc
	ld hl, BoxMon1Moves - BoxMon1
	add hl, bc
	push hl
	ld de, TempMonMoves
	ld bc, NUM_MOVES
	call CopyBytes
	pop hl
	pop de

	ld a, [$cfa9]
	push af
	ld a, [MonType]
	push af
	ld b, 0
.asm_dcec
	ld a, [hli]
	and a
	jr z, .asm_dd18
	ld [TempMonMove1], a
	ld a, BOXMON
	ld [MonType], a
	ld a, b
	ld [$cfa9], a
	push bc
	push hl
	push de
	ld a, $3
	ld hl, $78ec
	rst FarCall
	pop de
	pop hl
	ld a, [$d265]
	ld b, a
	ld a, [de]
	and $c0
	add b
	ld [de], a
	pop bc
	inc de
	inc b
	ld a, b
	cp NUM_MOVES
	jr c, .asm_dcec

.asm_dd18
	pop af
	ld [MonType], a
	pop af
	ld [$cfa9], a
	ret
; dd21


INCBIN "baserom.gbc", $dd21, $de6e - $dd21


Functionde6e: ; de6e
	ld a, 1 ; BANK(BoxCount)
	call GetSRAMBank
	ld de, BoxCount
	ld a, [de]
	cp 20
	jp nc, Functiondf42
	inc a
	ld [de], a
	ld a, [CurPartySpecies]
	ld [CurSpecies], a
	ld c, a
.asm_de85
	inc de
	ld a, [de]
	ld b, a
	ld a, c
	ld c, b
	ld [de], a
	inc a
	jr nz, .asm_de85
	call GetBaseData
	call ShiftBoxMon
	ld hl, PlayerName
	ld de, BoxMonOT
	ld bc, BoxMon2OT - BoxMon1OT
	call CopyBytes
	ld a, [CurPartySpecies]
	ld [$d265], a
	call GetPokemonName
	ld de, BoxMon1Nickname
	ld hl, StringBuffer1
	ld bc, BoxMon2Nickname - BoxMon1Nickname
	call CopyBytes
	ld hl, EnemyMon
	ld de, BoxMon1
	ld bc, 6 ; species + item + moves
	call CopyBytes
	ld hl, PlayerID
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	push de
	ld a, [CurPartyLevel]
	ld d, a
	ld hl, $4e47
	ld a, $14
	rst FarCall
	pop de
	ld a, [hMultiplicand]
	ld [de], a
	inc de
	ld a, [$ffb5]
	ld [de], a
	inc de
	ld a, [$ffb6]
	ld [de], a
	inc de
	xor a
	ld b, $a
.asm_dee5
	ld [de], a
	inc de
	dec b
	jr nz, .asm_dee5
	ld hl, EnemyMonAtkDefDV
	ld b, $6
.asm_deef
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_deef
	ld a, $46
	ld [de], a
	inc de
	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld a, [CurPartyLevel]
	ld [de], a
	ld a, [CurPartySpecies]
	dec a
	call SetSeenAndCaughtMon
	ld a, [CurPartySpecies]
	cp UNOWN
	jr nz, .asm_df20
	ld hl, BoxMon1DVs
	ld a, $2d
	call Predef
	ld hl, $7a18
	ld a, $3e
	rst FarCall

.asm_df20
	ld hl, BoxMon1Moves
	ld de, TempMonMove1
	ld bc, NUM_MOVES
	call CopyBytes
	ld hl, BoxMon1PP
	ld de, TempMonPP
	ld bc, NUM_MOVES
	call CopyBytes
	ld b, 0
	call Functiondcb6
	call CloseSRAM
	scf
	ret
; df42

Functiondf42: ; df42
	call CloseSRAM
	and a
	ret
; df47

ShiftBoxMon: ; df47
	ld hl, BoxMonOT
	ld bc, BoxMon2OT - BoxMon1OT
	call .asm_df5f

	ld hl, BoxMonNicknames
	ld bc, BoxMon2Nickname - BoxMon1Nickname
	call .asm_df5f

	ld hl, BoxMons
	ld bc, BoxMon2 - BoxMon1

.asm_df5f
	ld a, [BoxCount]
	cp 2
	ret c

	push hl
	call AddNTimes
	dec hl
	ld e, l
	ld d, h
	pop hl

	ld a, [BoxCount]
	dec a
	call AddNTimes
	dec hl

	push hl
	ld a, [BoxCount]
	dec a
	ld hl, 0
	call AddNTimes
	ld c, l
	ld b, h
	pop hl
.loop
	ld a, [hld]
	ld [de], a
	dec de
	dec bc
	ld a, c
	or b
	jr nz, .loop
	ret
; df8c

Functiondf8c: ; df8c
	ld a, [CurPartySpecies]
	push af
	callab GetPreEvolution
	callab GetPreEvolution
	ld a, [CurPartySpecies]
	dec a
	push af
	call CheckSeenMon
	pop af
	push bc
	call CheckCaughtMon
	push bc
	call Functiond88c
	pop bc
	ld a, c
	and a
	jr nz, .asm_dfc3
	ld a, [CurPartySpecies]
	dec a
	ld c, a
	ld d, $0
	ld hl, PokedexSeen
	ld b, $0
	ld a, $3
	call Predef

.asm_dfc3
	pop bc
	ld a, c
	and a
	jr nz, .asm_dfd9
	ld a, [CurPartySpecies]
	dec a
	ld c, a
	ld d, $0
	ld hl, PokedexCaught
	ld b, $0
	ld a, $3
	call Predef

.asm_dfd9
	pop af
	ld [CurPartySpecies], a
	ld a, [PartyCount]
	dec a
	ld bc, $0030
	ld hl, PartyMon1Species
	call AddNTimes
	ld a, [CurPartySpecies]
	ld [hl], a
	ld hl, PartyCount
	ld a, [hl]
	ld b, $0
	ld c, a
	add hl, bc
	ld a, $fd
	ld [hl], a
	ld a, [PartyCount]
	dec a
	ld hl, PartyMon1Nickname
	call SkipNames
	ld de, $6035
	call CopyName2
	ld a, [PartyCount]
	dec a
	ld hl, PartyMon1Happiness
	ld bc, $0030
	call AddNTimes
	ld a, [$c2cc]
	bit 1, a
	ld a, $1
	jr nz, .asm_e022
	ld a, [BaseEggSteps]

.asm_e022
	ld [hl], a
	ld a, [PartyCount]
	dec a
	ld hl, PartyMon1CurHP
	ld bc, $0030
	call AddNTimes
	xor a
	ld [hli], a
	ld [hl], a
	and a
	ret
; e035

INCBIN "baserom.gbc", $e035, $e039 - $e035


Functione039: ; e039

	ld hl, PartyCount

	ld a, [$d10b]
	and a
	jr z, .asm_e04a

	ld a, 1 ; BANK(BoxCount)
	call GetSRAMBank
	ld hl, BoxCount

.asm_e04a
	ld a, [hl]
	dec a
	ld [hli], a
	ld a, [CurPartyMon]
	ld c, a
	ld b, 0
	add hl, bc
	ld e, l
	ld d, h
	inc de
.asm_e057
	ld a, [de]
	inc de
	ld [hli], a
	inc a
	jr nz, .asm_e057
	ld hl, PartyMon1OT
	ld d, $5
	ld a, [$d10b]
	and a
	jr z, .asm_e06d
	ld hl, BoxMonOT
	ld d, $13

.asm_e06d
	ld a, [CurPartyMon]
	call SkipNames
	ld a, [CurPartyMon]
	cp d
	jr nz, .asm_e07e
	ld [hl], $ff
	jp .asm_60f0

.asm_e07e
	ld d, h
	ld e, l
	ld bc, $000b
	add hl, bc
	ld bc, PartyMon1Nickname
	ld a, [$d10b]
	and a
	jr z, .asm_e090
	ld bc, BoxMonNicknames
.asm_e090
	call CopyDataUntil

	ld hl, PartyMons
	ld bc, PartyMon2 - PartyMon1
	ld a, [$d10b]
	and a
	jr z, .asm_e0a5
	ld hl, BoxMons
	ld bc, BoxMon2 - BoxMon1

.asm_e0a5
	ld a, [CurPartyMon]
	call AddNTimes
	ld d, h
	ld e, l
	ld a, [$d10b]
	and a
	jr z, .asm_e0bc
	ld bc, BoxMon2 - BoxMon1
	add hl, bc
	ld bc, BoxMonOT
	jr .asm_e0c3

.asm_e0bc
	ld bc, PartyMon2 - PartyMon1
	add hl, bc
	ld bc, PartyMon1OT

.asm_e0c3
	call CopyDataUntil
	ld hl, PartyMon1Nickname
	ld a, [$d10b]
	and a
	jr z, .asm_e0d2
	ld hl, BoxMonNicknames

.asm_e0d2
	ld bc, BoxMon2Nickname - BoxMon1Nickname
	ld a, [CurPartyMon]
	call AddNTimes
	ld d, h
	ld e, l
	ld bc, BoxMon2Nickname - BoxMon1Nickname
	add hl, bc
	ld bc, PartyMonNicknamesEnd
	ld a, [$d10b]
	and a
	jr z, .asm_e0ed
	ld bc, BoxMonNicknamesEnd

.asm_e0ed
	call CopyDataUntil

.asm_60f0
	ld a, [$d10b]
	and a
	jp nz, CloseSRAM
	ld a, [InLinkBattle]
	and a
	ret nz
	ld a, $0
	call GetSRAMBank
	ld hl, PartyCount
	ld a, [CurPartyMon]
	cp [hl]
	jr z, .asm_e131
	ld hl, $a600
	ld bc, $002f
	call AddNTimes
	push hl
	add hl, bc
	pop de
	ld a, [CurPartyMon]
	ld b, a
.asm_e11a
	push bc
	push hl
	ld bc, $002f
	call CopyBytes
	pop hl
	push hl
	ld bc, $002f
	add hl, bc
	pop de
	pop bc
	inc b
	ld a, [PartyCount]
	cp b
	jr nz, .asm_e11a

.asm_e131
	jp CloseSRAM
; e134

Functione134: ; e134
	ld a, $1f
	call GetPartyParamLocation
	ld a, [hl]
	ld [$001f], a
	ld a, $0
	call GetPartyParamLocation
	ld a, [hl]
	ld [CurSpecies], a
	call GetBaseData
	ld a, $24
	call GetPartyParamLocation
	ld d, h
	ld e, l
	push de
	ld a, $a
	call GetPartyParamLocation
	ld b, $1
	call Functione167
	pop de
	ld a, $22
	call GetPartyParamLocation
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	ret
; e167

Functione167: ; e167
	ld c, $0
.asm_e169
	inc c
	call Functione17b
	ld a, [$ffb5]
	ld [de], a
	inc de
	ld a, [$ffb6]
	ld [de], a
	inc de
	ld a, c
	cp $6
	jr nz, .asm_e169
	ret
; e17b

Functione17b: ; e17b
	push hl
	push de
	push bc
	ld a, b
	ld d, a
	push hl
	ld hl, BaseHP
	dec hl
	ld b, $0
	add hl, bc
	ld a, [hl]
	ld e, a
	pop hl
	push hl
	ld a, c
	cp $6
	jr nz, .asm_e193
	dec hl
	dec hl

.asm_e193
	sla c
	ld a, d
	and a
	jr z, .asm_e1a5
	add hl, bc
	push de
	ld a, [hld]
	ld e, a
	ld d, [hl]
	callba GetSquareRoot
	pop de

.asm_e1a5
	srl c
	pop hl
	push bc
	ld bc, $000b
	add hl, bc
	pop bc
	ld a, c
	cp $2
	jr z, .asm_e1e3
	cp $3
	jr z, .asm_e1ea
	cp $4
	jr z, .asm_e1ef
	cp $5
	jr z, .asm_e1f7
	cp $6
	jr z, .asm_e1f7
	push bc
	ld a, [hl]
	swap a
	and $1
	add a
	add a
	add a
	ld b, a
	ld a, [hli]
	and $1
	add a
	add a
	add b
	ld b, a
	ld a, [hl]
	swap a
	and $1
	add a
	add b
	ld b, a
	ld a, [hl]
	and $1
	add b
	pop bc
	jr .asm_e1fb

.asm_e1e3
	ld a, [hl]
	swap a
	and $f
	jr .asm_e1fb

.asm_e1ea
	ld a, [hl]
	and $f
	jr .asm_e1fb

.asm_e1ef
	inc hl
	ld a, [hl]
	swap a
	and $f
	jr .asm_e1fb

.asm_e1f7
	inc hl
	ld a, [hl]
	and $f

.asm_e1fb
	ld d, $0
	add e
	ld e, a
	jr nc, .asm_e202
	inc d

.asm_e202
	sla e
	rl d
	srl b
	srl b
	ld a, b
	add e
	jr nc, .asm_e20f
	inc d

.asm_e20f
	ld [$ffb6], a
	ld a, d
	ld [$ffb5], a
	xor a
	ld [hMultiplicand], a
	ld a, [CurPartyLevel]
	ld [hMultiplier], a
	call Multiply
	ld a, [hMultiplicand]
	ld [hProduct], a
	ld a, [$ffb5]
	ld [hMultiplicand], a
	ld a, [$ffb6]
	ld [$ffb5], a
	ld a, $64
	ld [hMultiplier], a
	ld a, $3
	ld b, a
	call Divide
	ld a, c
	cp $1
	ld a, $5
	jr nz, .asm_e24e
	ld a, [CurPartyLevel]
	ld b, a
	ld a, [$ffb6]
	add b
	ld [$ffb6], a
	jr nc, .asm_e24c
	ld a, [$ffb5]
	inc a
	ld [$ffb5], a

.asm_e24c
	ld a, $a

.asm_e24e
	ld b, a
	ld a, [$ffb6]
	add b
	ld [$ffb6], a
	jr nc, .asm_e25b
	ld a, [$ffb5]
	inc a
	ld [$ffb5], a

.asm_e25b
	ld a, [$ffb5]
	cp $4
	jr nc, .asm_e26b
	cp $3
	jr c, .asm_e273
	ld a, [$ffb6]
	cp $e8
	jr c, .asm_e273

.asm_e26b
	ld a, $3
	ld [$ffb5], a
	ld a, $e7
	ld [$ffb6], a

.asm_e273
	pop bc
	pop de
	pop hl
	ret
; e277

Functione277: ; e277
	push de
	push bc
	xor a
	ld [MonType], a
	call Functiond88c
	jr nc, .asm_e2b0
	ld hl, PartyMon1Nickname
	ld a, [PartyCount]
	dec a
	ld [CurPartyMon], a
	call SkipNames
	ld d, h
	ld e, l
	pop bc
	ld a, b
	ld b, $0
	push bc
	push de
	push af
	ld a, [CurItem]
	and a
	jr z, .asm_e2e1
	ld a, [CurPartyMon]
	ld hl, PartyMon1Item
	ld bc, $0030
	call AddNTimes
	ld a, [CurItem]
	ld [hl], a
	jr .asm_e2e1

.asm_e2b0
	ld a, [CurPartySpecies]
	ld [TempEnemyMonSpecies], a
	callab LoadEnemyMon
	call Functionde6e
	jp nc, Functione3d4
	ld a, $2
	ld [MonType], a
	xor a
	ld [CurPartyMon], a
	ld de, $d050
	pop bc
	ld a, b
	ld b, $1
	push bc
	push de
	push af
	ld a, [CurItem]
	and a
	jr z, .asm_e2e1
	ld a, [CurItem]
	ld [$ad27], a

.asm_e2e1
	ld a, [CurPartySpecies]
	ld [$d265], a
	ld [TempEnemyMonSpecies], a
	call GetPokemonName
	ld hl, StringBuffer1
	ld de, $d050
	ld bc, $000b
	call CopyBytes
	pop af
	and a
	jp z, $6390
	pop de
	pop bc
	pop hl
	push bc
	push hl
	ld a, [ScriptBank]
	call GetFarHalfword
	ld bc, $000b
	ld a, [ScriptBank]
	call FarCopyBytes
	pop hl
	inc hl
	inc hl
	ld a, [ScriptBank]
	call GetFarHalfword
	pop bc
	ld a, b
	and a
	push de
	push bc
	jr nz, .asm_e35e
	push hl
	ld a, [CurPartyMon]
	ld hl, PartyMon1OT
	call SkipNames
	ld d, h
	ld e, l
	pop hl
.asm_e32f
	ld a, [ScriptBank]
	call GetFarByte
	ld [de], a
	inc hl
	inc de
	cp $50
	jr nz, .asm_e32f
	ld a, [ScriptBank]
	call GetFarByte
	ld b, a
	push bc
	ld a, [CurPartyMon]
	ld hl, PartyMon1ID
	ld bc, $0030
	call AddNTimes
	ld a, $3
	ld [hli], a
	ld [hl], $e9
	pop bc
	ld a, $13
	ld hl, $5ba3
	rst FarCall
	jr .asm_e3b2

.asm_e35e
	ld a, $1
	call GetSRAMBank
	ld de, $afa6
.asm_e366
	ld a, [ScriptBank]
	call GetFarByte
	ld [de], a
	inc hl
	inc de
	cp $50
	jr nz, .asm_e366
	ld a, [ScriptBank]
	call GetFarByte
	ld b, a
	ld hl, $ad2c
	call Random
	ld [hli], a
	call Random
	ld [hl], a
	call CloseSRAM
	ld a, $13
	ld hl, $5b92
	rst FarCall
	jr .asm_e3b2

	pop de
	pop bc
	push bc
	push de
	ld a, b
	and a
	jr z, .asm_e3a0
	ld a, $13
	ld hl, $5b83
	rst FarCall
	jr .asm_e3a6

.asm_e3a0
	ld a, $13
	ld hl, $5b49
	rst FarCall

.asm_e3a6
	ld a, $13
	ld hl, $5b3b
	rst FarCall
	pop de
	jr c, .asm_e3b2
	call Functione3de

.asm_e3b2
	pop bc
	pop de
	ld a, b
	and a
	ret z
	ld hl, $63d9
	call PrintText
	ld a, $1
	call GetSRAMBank
	ld hl, $d050
	ld de, $b082
	ld bc, $000b
	call CopyBytes
	call CloseSRAM
	ld b, $1
	ret
; e3d4

Functione3d4: ; e3d4
	pop bc
	pop de
	ld b, $2
	ret
; e3d9

INCBIN "baserom.gbc", $e3d9, $e3de - $e3d9


Functione3de: ; e3de
	push de
	call Function1d6e
	call Function2ed3
	pop de
	push de
	ld b, $0
	ld a, $4
	ld hl, $56c1
	rst FarCall
	pop hl
	ld de, StringBuffer1
	call InitName
	ld a, $4
	ld hl, Function2b4d
	rst FarCall
	ret
; e3fd

INCBIN "baserom.gbc", $e3fd, $e538 - $e3fd


Functione538: ; e538
	ld hl, PartyMon1CurHP
	ld de, $0030
	ld b, $0
.asm_e540
	ld a, [CurPartyMon]
	cp b
	jr z, .asm_e54b
	ld a, [hli]
	or [hl]
	jr nz, .asm_e557
	dec hl

.asm_e54b
	inc b
	ld a, [PartyCount]
	cp b
	jr z, .asm_e555
	add hl, de
	jr .asm_e540

.asm_e555
	scf
	ret

.asm_e557
	and a
	ret
; e559

INCBIN "baserom.gbc", $e559, $e58b - $e559

ClearPCItemScreen: ; e58b
	call Function2ed3
	xor a
	ld [hBGMapMode], a
	call WhiteBGMap
	call ClearSprites
	ld hl, TileMap
	ld bc, 18 * 20
	ld a, " "
	call ByteFill
	hlcoord 0,0
	ld bc, $0a12
	call TextBox
	hlcoord 0,12
	ld bc, $0412
	call TextBox
	call Function3200
	call Function32f9 ; load regular palettes?
	ret
; 0xe5bb

Functione5bb: ; e5bb
	ld a, [CurPartyMon]
	ld hl, $ad26
	ld bc, $0020
	call AddNTimes
	ld de, TempMonSpecies
	ld bc, $0020
	ld a, $1
	call GetSRAMBank
	call CopyBytes
	call CloseSRAM
	ret
; e5d9

INCBIN "baserom.gbc", $e5d9, $e6ce - $e5d9


Functione6ce: ; e6ce
	ld a, [$df9c]
	and a
	jr z, .asm_e6ea
	ld [$d265], a
	ld a, $33
	ld hl, $40c7
	rst FarCall
	ld a, $33
	ld hl, $4000
	rst FarCall
	ld bc, $0e07
	call Function1dd2
	ret c

.asm_e6ea
	call Functione6fd
	ld a, [TempEnemyMonSpecies]
	ld [$d265], a
	call GetPokemonName
	ld hl, $671d
	call PrintText
	ret
; e6fd

Functione6fd: ; e6fd
	ld a, [TempEnemyMonSpecies]
	ld [CurSpecies], a
	ld [CurPartySpecies], a
	call GetBaseData
	xor a
	ld bc, $0030
	ld hl, $df9c
	call ByteFill
	xor a
	ld [MonType], a
	ld hl, $df9c
	jp $5906
; e71d

INCBIN "baserom.gbc", $e71d, $e722 - $e71d


_DoItemEffect: ; e722
	ld a, [CurItem]
	ld [$d265], a
	call GetItemName
	call CopyName1
	ld a, 1
	ld [$d0ec], a
	ld a, [CurItem]
	dec a
	ld hl, ItemEffects
	rst JumpTable
	ret
; e73c


ItemEffects: ; e73c
	dw MasterBall
	dw UltraBall
	dw Brightpowder
	dw GreatBall
	dw PokeBall
	dw Item06
	dw Bicycle
	dw MoonStone
	dw Antidote
	dw BurnHeal
	dw IceHeal
	dw Awakening
	dw ParlyzHeal
	dw FullRestore
	dw MaxPotion
	dw HyperPotion
	dw SuperPotion
	dw Potion
	dw EscapeRope
	dw Repel
	dw MaxElixer
	dw FireStone
	dw Thunderstone
	dw WaterStone
	dw Item19
	dw HpUp
	dw Protein
	dw Iron
	dw Carbos
	dw LuckyPunch
	dw Calcium
	dw RareCandy
	dw XAccuracy
	dw LeafStone
	dw MetalPowder
	dw Nugget
	dw PokeDoll
	dw FullHeal
	dw Revive
	dw MaxRevive
	dw GuardSpec
	dw SuperRepel
	dw MaxRepel
	dw DireHit
	dw Item2D
	dw FreshWater
	dw SodaPop
	dw Lemonade
	dw XAttack
	dw Item32
	dw XDefend
	dw XSpeed
	dw XSpecial
	dw CoinCase
	dw Itemfinder
	dw Item38
	dw ExpShare
	dw OldRod
	dw GoodRod
	dw SilverLeaf
	dw SuperRod
	dw PpUp
	dw Ether
	dw MaxEther
	dw Elixer
	dw RedScale
	dw Secretpotion
	dw SSTicket
	dw MysteryEgg
	dw ClearBell
	dw SilverWing
	dw MoomooMilk
	dw QuickClaw
	dw Psncureberry
	dw GoldLeaf
	dw SoftSand
	dw SharpBeak
	dw Przcureberry
	dw BurntBerry
	dw IceBerry
	dw PoisonBarb
	dw KingsRock
	dw BitterBerry
	dw MintBerry
	dw RedApricorn
	dw Tinymushroom
	dw BigMushroom
	dw Silverpowder
	dw BluApricorn
	dw Item5A
	dw AmuletCoin
	dw YlwApricorn
	dw GrnApricorn
	dw CleanseTag
	dw MysticWater
	dw Twistedspoon
	dw WhtApricorn
	dw Blackbelt
	dw BlkApricorn
	dw Item64
	dw PnkApricorn
	dw Blackglasses
	dw Slowpoketail
	dw PinkBow
	dw Stick
	dw SmokeBall
	dw Nevermeltice
	dw Magnet
	dw Miracleberry
	dw Pearl
	dw BigPearl
	dw Everstone
	dw SpellTag
	dw Ragecandybar
	dw GsBall
	dw BlueCard
	dw MiracleSeed
	dw ThickClub
	dw FocusBand
	dw Item78
	dw Energypowder
	dw EnergyRoot
	dw HealPowder
	dw RevivalHerb
	dw HardStone
	dw LuckyEgg
	dw CardKey
	dw MachinePart
	dw EggTicket
	dw LostItem
	dw Stardust
	dw StarPiece
	dw BasementKey
	dw Pass
	dw Item87
	dw Item88
	dw Item89
	dw Charcoal
	dw BerryJuice
	dw ScopeLens
	dw Item8D
	dw Item8E
	dw MetalCoat
	dw DragonFang
	dw Item91
	dw Leftovers
	dw Item93
	dw Item94
	dw Item95
	dw Mysteryberry
	dw DragonScale
	dw BerserkGene
	dw Item99
	dw Item9A
	dw Item9B
	dw SacredAsh
	dw HeavyBall
	dw FlowerMail
	dw LevelBall
	dw LureBall
	dw FastBall
	dw ItemA2
	dw LightBall
	dw FriendBall
	dw MoonBall
	dw LoveBall
	dw NormalBox
	dw GorgeousBox
	dw SunStone
	dw PolkadotBow
	dw ItemAB
	dw UpGrade
	dw Berry
	dw GoldBerry
	dw Squirtbottle
	dw ItemB0
	dw ParkBall
	dw RainbowWing
	dw ItemB3
; e8a2

INCLUDE "items/item_effects.asm"


Functionf780: ; f780
	push de
	ld de, SFX_FULL_HEAL
	call WaitPlaySFX
	pop de
	ret
; f789

Functionf789: ; f789
	ld hl, $783d
	call PrintText
	call Functionf780
	call Functiona80
	; fallthrough
; f795

Functionf795: ; f795
	ld hl, NumItems
	ld a, $1
	ld [$d10c], a
	jp Function2f53
; f7a0

Functionf7a0: ; f7a0
	call $6dfa
	ld de, Start
	ld a, e
	ld [FXAnimIDLo], a
	ld a, d
	ld [FXAnimIDHi], a
	xor a
	ld [$c689], a
	ld [hBattleTurn], a
	ld [$cfca], a
	ld a, $37
	call Predef
	ld hl, $7824
	call PrintText
	ld hl, $7829
	call PrintText
	jr Functionf795
; f7ca

Functionf7ca: ; f7ca
	ld hl, $781f
	call PrintText
	ld a, $2
	ld [$d0ec], a
	ret
; f7d6

Functionf7d6: ; f7d6
	ld hl, $780b
	jp PrintText
; f7dc

Functionf7dc: ; f7dc
	ld hl, $7838
	call PrintText
	ld a, $2
	ld [$d0ec], a
	ret
; f7e8

Functionf7e8: ; f7e8
	ld hl, $7810
	jr .asm_f804

	ld hl, $7815
	jr .asm_f804

	ld hl, $781f
	jr .asm_f804

	ld hl, $781a
	jr .asm_f804

	ld hl, $782e
	jr .asm_f804

	ld hl, $7833

.asm_f804
	xor a
	ld [$d0ec], a
	jp PrintText
; f80b

INCBIN "baserom.gbc", $f80b, $f84c - $f80b


Functionf84c: ; f84c
	ld a, $2
	call GetPartyParamLocation
	push hl
	ld de, MagikarpLength
	ld a, $5
	call Predef
	pop hl
	ld bc, $0015
	add hl, bc
	ld de, MagikarpLength
	ld b, $0
.asm_f864
	inc b
	ld a, b
	cp $5
	ret z
	ld a, [$d265]
	dec a
	jr nz, .asm_f876
	ld a, [$cfa9]
	inc a
	cp b
	jr nz, .asm_f87d

.asm_f876
	ld a, [hl]
	and $c0
	ld a, [de]
	call nz, Functionf881

.asm_f87d
	inc hl
	inc de
	jr .asm_f864
; f881



Functionf881: ; f881
	push bc
	ld a, [de]
	ld [$ffb6], a
	xor a
	ld [hProduct], a
	ld [hMultiplicand], a
	ld [$ffb5], a
	ld a, $5
	ld [hMultiplier], a
	ld b, $4
	call Divide
	ld a, [hl]
	ld b, a
	swap a
	and $f
	srl a
	srl a
	ld c, a
	and a
	jr z, .asm_f8b6
.asm_f8a3
	ld a, [$ffb6]
	cp $8
	jr c, .asm_f8ab
	ld a, $7

.asm_f8ab
	add b
	ld b, a
	ld a, [$d265]
	dec a
	jr z, .asm_f8b6
	dec c
	jr nz, .asm_f8a3

.asm_f8b6
	ld [hl], b
	pop bc
	ret
; f8b9

INCBIN "baserom.gbc", $f8b9, $f8ec - $f8b9


Functionf8ec: ; f8ec
	ld a, [StringBuffer1]
	push af
	ld a, [$d074]
	push af
	ld a, [MonType]
	and a
	ld hl, PartyMon1Moves
	ld bc, PartyMon2 - PartyMon1
	jr z, .asm_f91a
	ld hl, OTPartyMon1Moves
	dec a
	jr z, .asm_f91a
	ld hl, TempMonMoves
	dec a
	jr z, .asm_f915
	ld hl, TempMonMoves
	dec a
	jr z, .asm_f915
	ld hl, BattleMonMoves

.asm_f915
	call Function7969
	jr .asm_f91d

.asm_f91a
	call Functionf963

.asm_f91d
	ld a, [hl]
	dec a
	push hl
	ld hl, $5b00
	ld bc, $0007
	call AddNTimes
	ld a, $10
	call GetFarByte
	ld b, a
	ld de, StringBuffer1
	ld [de], a
	pop hl
	push bc
	ld bc, $0015
	ld a, [MonType]
	cp WILDMON
	jr nz, .asm_f942
	ld bc, $0006

.asm_f942
	add hl, bc
	ld a, [hl]
	and $c0
	pop bc
	or b
	ld hl, $d074
	ld [hl], a
	xor a
	ld [$d265], a
	ld a, b
	call Functionf881
	ld a, [hl]
	and $3f
	ld [$d265], a
	pop af
	ld [$d074], a
	pop af
	ld [StringBuffer1], a
	ret
; f963

Functionf963: ; f963
	ld a, [CurPartyMon]
	call AddNTimes

Function7969: ; 7969
	ld a, [$cfa9]
	ld c, a
	ld b, $0
	add hl, bc
	ret
; f971

INCBIN "baserom.gbc", $f971, $f9ea - $f971


Functionf9ea: ; f9ea
	ld a, $2
	call GetPartyParamLocation
	ld a, [$d262]
	ld b, a
	ld c, $4
.asm_f9f5
	ld a, [hli]
	cp b
	jr z, .asm_f9fe
	dec c
	jr nz, .asm_f9f5
	and a
	ret

.asm_f9fe
	ld hl, $7a06
	call PrintText
	scf
	ret
; fa06

INCBIN "baserom.gbc", $fa06, $fa0b - $fa06


SECTION "bank4",ROMX,BANK[$4]

Function10000: ; 10000
	ld hl, Options
	set 4, [hl]
	call Function1068a
.asm_10008
	call Functiona57
	ld a, [$cf63]
	bit 7, a
	jr nz, .asm_1001a
	call Function10026
	call DelayFrame
	jr .asm_10008

.asm_1001a
	ld a, [$cf65]
	ld [$d0d6], a
	ld hl, Options
	res 4, [hl]
	ret
; 10026

Function10026: ; 10026
	ld a, [$cf63]
	ld hl, $4030
	call Function1086b
	jp [hl]
; 10030

INCBIN "baserom.gbc", $10030, $10493 - $10030


Function10493: ; 10493
	ld hl, Options
	set 4, [hl]
	call Function1068a
.asm_1049b
	call Functiona57
	ld a, [$cf63]
	bit 7, a
	jr nz, .asm_104ad
	call Function104b9
	call DelayFrame
	jr .asm_1049b

.asm_104ad
	ld a, [$cf65]
	ld [$d0d6], a
	ld hl, Options
	res 4, [hl]
	ret
; 104b9

Function104b9: ; 104b9
	ld a, [$cf63]
	ld hl, $44c3
	call Function1086b
	jp [hl]
; 104c3

INCBIN "baserom.gbc", $104c3, $1068a - $104c3


Function1068a: ; 1068a
	xor a
	ld [$cf63], a
	ld a, [$d0d6]
	and $3
	ld [$cf65], a
	inc a
	add a
	dec a
	ld [$cf64], a
	xor a
	ld [$cf66], a
	xor a
	ld [$d0e3], a
	ret
; 106a5

Function106a5: ; 106a5
	xor a
	ld [hBGMapMode], a
	ld [$cf63], a
	ld [$cf64], a
	ld [$cf65], a
	ld [$cf66], a
	ld [$d0e3], a
	call Function10955
	call Function10a40
	ret
; 106be

Function106be: ; 106be
.asm_106be
	call Function106c7
	call Function1076f
	jr c, .asm_106be
	ret
; 106c7

Function106c7: ; 106c7
	ld a, [$cf63]
	ld hl, $46d1
	call Function1086b
	jp [hl]
; 106d1

INCBIN "baserom.gbc", $106d1, $1076f - $106d1


Function1076f: ; 1076f
	ld hl, $cf73
	ld a, [hl]
	and $1
	jr nz, .asm_10788
	ld a, [hl]
	and $2
	jr nz, .asm_1078f
	ld a, [hl]
	and $20
	jr nz, .asm_10795
	ld a, [hl]
	and $10
	jr nz, .asm_107a8
	scf
	ret

.asm_10788
	ld a, $1
	ld [$cf66], a
	and a
	ret

.asm_1078f
	xor a
	ld [$cf66], a
	and a
	ret

.asm_10795
	ld a, [$cf63]
	dec a
	and $3
	ld [$cf63], a
	push de
	ld de, SFX_UNKNOWN_62
	call StartSFX
	pop de
	scf
	ret

.asm_107a8
	ld a, [$cf63]
	inc a
	and $3
	ld [$cf63], a
	push de
	ld de, SFX_UNKNOWN_62
	call StartSFX
	pop de
	scf
	ret
; 107bb

Function107bb: ; 107bb
	call Function106a5
	ld a, [InputType]
	or a
	jr z, .asm_107ca
	callba Function1de28f

.asm_107ca
	call Function107d7
	call Function1076f
	jr c, .asm_107ca
	xor a
	ld [$cf66], a
	ret
; 107d7

Function107d7: ; 107d7
	ld a, [$cf63]
	ld hl, $47e1
	call Function1086b
	jp [hl]
; 107e1

INCBIN "baserom.gbc", $107e1, $1086b - $107e1


Function1086b: ; 1086b
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret
; 10874

INCBIN "baserom.gbc", $10874, $1089d - $10874


Function1089d: ; 1089d
	ld a, [$cf65]
	and $3
	ld e, a
	ld d, $0
	ld a, [BattleType]
	cp $3
	jr z, .asm_108b3
	ld a, [PlayerGender]
	bit 0, a
	jr nz, .asm_108c5

.asm_108b3
	ld hl, $48cc
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, $9500
	ld bc, $040f
	call Request2bpp
	ret

.asm_108c5
	ld a, $12
	ld hl, $4e81
	rst FarCall
	ret
; 108cc

INCBIN "baserom.gbc", $108cc, $10955 - $108cc


Function10955: ; 10955
	call WhiteBGMap
	call ClearTileMap
	call ClearSprites
	call DisableLCD
	ld hl, $4b16
	ld de, VTiles2
	ld bc, $0600
	ld a, $4
	call FarCopyBytes
	ld hl, $c4b4
	ld bc, $00dc
	ld a, $24
	call ByteFill
	ld hl, $c4b9
	ld bc, $0b0f
	call ClearBox
	ld hl, TileMap
	ld a, $28
	ld c, $14
.asm_1098a
	ld [hli], a
	inc a
	dec c
	jr nz, .asm_1098a
	call Function109bb
	call Function109a5
	ld hl, $c590
	ld bc, $0412
	call TextBox
	call EnableLCD
	call Function1089d
	ret
; 109a5

Function109a5: ; 109a5
	ld hl, $c4dc
	ld a, $50
	ld de, $000f
	ld b, $3
.asm_109af
	ld c, $5
.asm_109b1
	ld [hli], a
	inc a
	dec c
	jr nz, .asm_109b1
	add hl, de
	dec b
	jr nz, .asm_109af
	ret
; 109bb

Function109bb: ; 109bb
	ld a, [$cf65]
	ld d, a
	swap a
	sub d
	ld d, $0
	ld e, a
	ld hl, $49e1
	add hl, de
	ld d, h
	ld e, l
	ld hl, $c52c
	ld c, $3
.asm_109d0
	ld b, $5
.asm_109d2
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .asm_109d2
	ld a, c
	ld c, $f
	add hl, bc
	ld c, a
	dec c
	jr nz, .asm_109d0
	ret
; 109e1

INCBIN "baserom.gbc", $109e1, $10a40 - $109e1


Function10a40: ; 10a40
	call WaitBGMap
	ld b, $14
	call GetSGBLayout
	call Function32f9
	call DelayFrame
	ret
; 10a4f

INCBIN "baserom.gbc", $10a4f, $10b16 - $10a4f

PackGFX:
INCBIN "gfx/misc/pack.2bpp"

Function113d6: ; 113d6
	call Function114dd
	ret
; 113da

Function113da: ; 113da
	xor a
	ld [$dc2d], a
	ld [$dc3a], a
	ld [$dc1c], a
	ret
; 113e5

Function113e5: ; 113e5
	xor a
	ld [$d464], a

Function113e9: ; 113e9
	ld a, [$d464]
	cp 3
	jr c, .asm_113f2
	ld a, 3

.asm_113f2
	ld e, a
	ld d, 0
	ld hl, .data_113fd
	add hl, de
	ld a, [hl]
	jp Function1142e
; 113fd

.data_113fd
	db 20, 10, 5, 3
; 11401

Function11401: ; 11401
	call Function1143c
	ret nc
	ld hl, $d464
	ld a, [hl]
	cp 3
	jr nc, .asm_1140e
	inc [hl]

.asm_1140e
	call Function113e9
	scf
	ret
; 11413

Function11413: ; 11413
	ld a, 1

Function11415: ; 11415
	ld [hl], a
	push hl
	call UpdateTime
	pop hl
	inc hl
	call Function11621
	ret
; 11420

Function11420: ; 11420
	inc hl
	push hl
	call Function115cf
	call Function115c8
	pop hl
	dec hl
	call Function11586
	ret
; 1142e

Function1142e: ; 1142e
	ld hl, $d465
	ld [hl], a
	call UpdateTime
	ld hl, $d466
	call Function1162e
	ret
; 1143c

Function1143c: ; 1143c
	ld hl, $d466
	call Function115d6
	call Function115ae
	ld hl, $d465
	call Function11586
	ret
; 1144c

Function1144c: ; 1144c
	ld hl, $dc1c
	jp Function11413
; 11452

Function11452: ; 11452
	ld hl, $dc1c
	call Function11420
	ret nc
	xor a
	ld hl, $dc1e
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $dc4c
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $dc50
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $dc54
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $dc58
	ld a, [hl]
	and a
	jr z, .asm_11480
	dec [hl]
	jr nz, .asm_11483

.asm_11480
	call Function11485

.asm_11483
	jr Function1144c
; 11485

Function11485: ; 11485
	call Random
	and 3
	add 3
	ld [$dc58], a
	ret
; 11490

INCBIN "baserom.gbc", $11490, $114dd - $11490


Function114dd: ; 114dd
	call UpdateTime
	ld hl, $dc23
	call Function11621
	ret
; 114e7

Function114e7: ; 114e7
	ld hl, $dc23
	call Function115cf
	call Function115c8
	and a
	jr z, .asm_114fa

	ld b, a
	callba Function13988

.asm_114fa
	xor a
	ret
; 114fc

Function114fc: ; 114fc
	ld a, $2
	ld hl, $dc3a
	ld [hl], a
	call UpdateTime
	ld hl, $dc3b
	call Function11621
	ret
; 1150c

Function1150c: ; 1150c
	ld hl, $dc3b
	call Function115cf
	call Function115c8
	ld hl, $dc3a
	call Function11586
	ret
; 1151c

Function1151c: ; 1151c
	ld hl, $dc1e
	set 2, [hl]
	ret
; 11522

Function11522: ; 11522
	and a
	ld hl, $dc1e
	bit 2, [hl]
	ret nz
	scf
	ret
; 1152b

Function1152b: ; 1152b
	call Function11534
	ld hl, $dc2d
	jp Function11415
; 11534

Function11534: ; 11534
	call GetWeekday
	ld c, a
	ld a, $5
	sub c
	jr z, .asm_1153f
	jr nc, .asm_11541

.asm_1153f
	add $7

.asm_11541
	ret
; 11542

Function11542: ; 11542
	ld hl, $dc2d
	jp Function11420
; 11548

Function11548: ; 11548
	ld a, $0
	call GetSRAMBank
	ld hl, $abfa
	ld a, [hli]
	ld [Buffer1], a
	ld a, [hl]
	ld [Buffer2], a
	call CloseSRAM
	ld hl, Buffer1
	call Function11420
	jr nc, .asm_11572
	ld hl, Buffer1
	call Function11413
	call CloseSRAM
	callba Function1050c8

.asm_11572
	ld a, $0
	call GetSRAMBank
	ld hl, Buffer1
	ld a, [hli]
	ld [$abfa], a
	ld a, [hl]
	ld [$abfb], a
	call CloseSRAM
	ret
; 11586

Function11586: ; 11586
	cp $ff
	jr z, .asm_11595
	ld c, a
	ld a, [hl]
	sub c
	jr nc, .asm_11590
	xor a

.asm_11590
	ld [hl], a
	jr z, .asm_11595
	xor a
	ret

.asm_11595
	xor a
	ld [hl], a
	scf
	ret
; 11599

Function11599: ; 11599
	ld a, [$cfd7]
	and a
	jr nz, Function115cc
	ld a, [$cfd6]
	and a
	jr nz, Function115cc
	ld a, [$cfd5]
	jr nz, Function115cc
	ld a, [$cfd4]
	ret
; 115ae

Function115ae: ; 115ae
	ld a, [$cfd7]
	and a
	jr nz, Function115cc
	ld a, [$cfd6]
	and a
	jr nz, Function115cc
	ld a, [$cfd5]
	ret
; 115be

Function115be: ; 115be
	ld a, [$cfd7]
	and a
	jr nz, Function115cc
	ld a, [$cfd6]
	ret
; 115c8

Function115c8: ; 115c8
	ld a, [$cfd7]
	ret
; 115cc

Function115cc: ; 115cc
	ld a, $ff
	ret
; 115cf

Function115cf: ; 115cf
	xor a
	jr Function11605
; 115d2

Function115d2: ; 115d2
	inc hl
	xor a
	jr Function115f8
; 115d6

Function115d6: ; 115d6
	inc hl
	inc hl
	xor a
	jr Function115eb
; 115db

Function115db: ; 115db
	inc hl
	inc hl
	inc hl
	ld a, [hSeconds]
	ld c, a
	sub [hl]
	jr nc, .asm_115e6
	add 60
.asm_115e6
	ld [hl], c
	dec hl
	ld [$cfd4], a

Function115eb: ; 115eb
	ld a, [hMinutes]
	ld c, a
	sbc [hl]
	jr nc, .asm_115f3
	add 60
.asm_115f3
	ld [hl], c
	dec hl
	ld [$cfd5], a

Function115f8: ; 115f8
	ld a, [hHours]
	ld c, a
	sbc [hl]
	jr nc, .asm_11600
	add 24
.asm_11600
	ld [hl], c
	dec hl
	ld [$cfd6], a

Function11605
	ld a, [CurDay]
	ld c, a
	sbc [hl]
	jr nc, .asm_1160e
	add 140
.asm_1160e
	ld [hl], c
	ld [$cfd7], a
	ret
; 11613

Function11613: ; 11613
	ld a, [CurDay]
	ld [hli], a
	ld a, [hHours]
	ld [hli], a
	ld a, [hMinutes]
	ld [hli], a
	ld a, [hSeconds]
	ld [hli], a
	ret
; 11621

Function11621: ; 11621
	ld a, [CurDay]
	ld [hl], a
	ret
; 11626

Function11626: ; 11626
	ld a, [CurDay]
	ld [hli], a
	ld a, [hHours]
	ld [hli], a
	ret
; 1162e

Function1162e: ; 1162e
	ld a, [CurDay]
	ld [hli], a
	ld a, [hHours]
	ld [hli], a
	ld a, [hMinutes]
	ld [hli], a
	ret
; 11639

CanLearnTMHMMove: ; 11639
	ld a, [CurPartySpecies]
	ld [CurSpecies], a
	call GetBaseData
	ld hl, BaseTMHM
	push hl

	ld a, [$d262]
	ld b, a
	ld c, 0
	ld hl, TMHMMoves
.loop
	ld a, [hli]
	and a
	jr z, .end
	cp b
	jr z, .asm_11659
	inc c
	jr .loop

.asm_11659
	pop hl
	ld b, CHECK_FLAG
	push de
	ld d, 0
	ld a, PREDEF_FLAG
	call Predef
	pop de
	ret

.end
	pop hl
	ld c, 0
	ret
; 1166a

GetTMHMMove: ; 1166a
	ld a, [$d265]
	dec a
	ld hl, TMHMMoves
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [$d265], a
	ret
; 1167a

TMHMMoves: ; 1167a
	db DYNAMICPUNCH
	db HEADBUTT
	db CURSE
	db ROLLOUT
	db ROAR
	db TOXIC
	db ZAP_CANNON
	db ROCK_SMASH
	db PSYCH_UP
	db HIDDEN_POWER
	db SUNNY_DAY
	db SWEET_SCENT
	db SNORE
	db BLIZZARD
	db HYPER_BEAM
	db ICY_WIND
	db PROTECT
	db RAIN_DANCE
	db GIGA_DRAIN
	db ENDURE
	db FRUSTRATION
	db SOLARBEAM
	db IRON_TAIL
	db DRAGONBREATH
	db THUNDER
	db EARTHQUAKE
	db RETURN
	db DIG
	db PSYCHIC_M
	db SHADOW_BALL
	db MUD_SLAP
	db DOUBLE_TEAM
	db ICE_PUNCH
	db SWAGGER
	db SLEEP_TALK
	db SLUDGE_BOMB
	db SANDSTORM
	db FIRE_BLAST
	db SWIFT
	db DEFENSE_CURL
	db THUNDERPUNCH
	db DREAM_EATER
	db DETECT
	db REST
	db ATTRACT
	db THIEF
	db STEEL_WING
	db FIRE_PUNCH
	db FURY_CUTTER
	db NIGHTMARE
	db CUT
	db FLY
	db SURF
	db STRENGTH
	db FLASH
	db WHIRLPOOL
	db WATERFALL

; Move tutor
	db FLAMETHROWER
	db THUNDERBOLT
	db ICE_BEAM

	db 0 ; end
; 116b7

Function116b7: ; 0x116b7
	call Function2ed3
	call Function116c1
	call Function2b74
	ret
; 0x116c1

Function116c1: ; 116c1
	ld hl, PlayerSDefLevel
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, EnemyAtkLevel
	ld [hl], b
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	ld a, [$ffde]
	push af
	xor a
	ld [$ffde], a
	ld a, [$ffaa]
	push af
	ld a, $1
	ld [$ffaa], a
	call Function116f8
	call DelayFrame
.asm_116e5
	call Function11915
	jr nc, .asm_116e5
	pop af
	ld [$ffaa], a
	pop af
	ld [$ffde], a
	pop af
	ld [Options], a
	call ClearJoypadPublic
	ret
; 116f8

Function116f8: ; 116f8
	call WhiteBGMap
	ld b, $8
	call GetSGBLayout
	call DisableLCD
	call Function11c51
	call Function118a8
	ld a, $e3
	ld [rLCDC], a
	call Function1171d
	call WaitBGMap
	call WaitTop
	call Function32f9
	call Function11be0
	ret
; 1171d

Function1171d: ; 1171d
	ld a, [EnemyAtkLevel]
	and $7
	ld e, a
	ld d, $0
	ld hl, $572e
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 1172e

INCBIN "baserom.gbc", $1172e, $1189c - $1172e


Function1189c: ; 1189c
	push bc
	push af
	ld a, [EnemyAtkLevel]
	sub $3
	ld b, a
	pop af
	dec b
	pop bc
	ret
; 118a8

Function118a8: ; 118a8
	call WaitTop
	ld hl, TileMap
	ld bc, $0168
	ld a, $60
	call ByteFill
	ld hl, $c4b5
	ld bc, $0612
	call Function1189c
	jr nz, .asm_118c4
	ld bc, $0412

.asm_118c4
	call ClearBox
	ld de, $5da2
	call Function1189c
	jr nz, .asm_118d5
	ld hl, $0055
	add hl, de
	ld d, h
	ld e, l

.asm_118d5
	push de
	ld hl, $c541
	ld bc, $0712
	call Function1189c
	jr nz, .asm_118e7
	ld hl, $c519
	ld bc, $0912

.asm_118e7
	call ClearBox
	ld hl, $c5e1
	ld bc, $0112
	call ClearBox
	pop de
	ld hl, $c542
	ld b, $5
	call Function1189c
	jr nz, .asm_11903
	ld hl, $c51a
	ld b, $6

.asm_11903
	ld c, $11
.asm_11905
	ld a, [de]
	ld [hli], a
	inc de
	dec c
	jr nz, .asm_11905
	push de
	ld de, $0017
	add hl, de
	pop de
	dec b
	jr nz, .asm_11903
	ret
; 11915

Function11915: ; 11915
	call Functiona57
	ld a, [$cf63]
	bit 7, a
	jr nz, .asm_11930
	call Function11968
	ld a, $23
	ld hl, $4f62
	rst FarCall
	call Function11940
	call DelayFrame
	and a
	ret

.asm_11930
	callab Function8cf53
	call ClearSprites
	xor a
	ld [hSCX], a
	ld [hSCY], a
	scf
	ret
; 11940

Function11940: ; 11940
	xor a
	ld [hBGMapMode], a
	ld hl, $c505
	call Function1189c
	jr nz, .asm_1194e
	ld hl, $c4dd

.asm_1194e
	ld bc, $0112
	call ClearBox
	ld hl, PlayerSDefLevel
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, EnemySDefLevel
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PlaceString
	ld a, $1
	ld [hBGMapMode], a
	ret
; 11968

Function11968: ; 11968
	ld a, [$cf63]
	ld e, a
	ld d, $0
	ld hl, $5977
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 11977

INCBIN "baserom.gbc", $11977, $11be0 - $11977


Function11be0: ; 11be0
	ld hl, PlayerSDefLevel
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [hl], $f2
	inc hl
	ld a, [$c6d3]
	dec a
	ld c, a
	ld a, $eb
.asm_11bf0
	ld [hli], a
	dec c
	jr nz, .asm_11bf0
	ld [hl], $50
	ret
; 11bf7

INCBIN "baserom.gbc", $11bf7, $11c51 - $11bf7


Function11c51: ; 11c51
	call ClearSprites
	callab Function8cf53
	call Functione51
	call Functione5f
	ld de, $5e65
	ld hl, $8eb0
	ld bc, $0401
	call Get1bpp
	ld de, $5e6d
	ld hl, $8f20
	ld bc, $0401
	call Get1bpp
	ld de, $9600
	ld hl, $5cb7
	ld bc, $0010
	ld a, $4
	call FarCopyBytes
	ld de, $87e0
	ld hl, $5cc7
	ld bc, $0020
	ld a, $4
	call FarCopyBytes
	ld a, $5
	ld hl, $c312
	ld [hli], a
	ld [hl], $7e
	xor a
	ld [hSCY], a
	ld [$c3bf], a
	ld [hSCX], a
	ld [$c3c0], a
	ld [$cf63], a
	ld [$cf64], a
	ld [hBGMapMode], a
	ld [PlayerEvaLevel], a
	ld a, $7
	ld [hWX], a
	ret
; 11cb7

INCBIN "baserom.gbc", $11cb7, $11ce7 - $11cb7

NameInputLower:
	db "a b c d e f g h i"
	db "j k l m n o p q r"
	db "s t u v w x y z  "
	db "× ( ) : ; [ ] ", $e1, " ", $e2
	db "UPPER  DEL   END "
BoxNameInputLower:
	db "a b c d e f g h i"
	db "j k l m n o p q r"
	db "s t u v w x y z  "
	db "é 'd 'l 'm 'r 's 't 'v 0"
	db "1 2 3 4 5 6 7 8 9"
	db "UPPER  DEL   END "
NameInputUpper:
	db "A B C D E F G H I"
	db "J K L M N O P Q R"
	db "S T U V W X Y Z  "
	db "- ? ! / . ,      "
	db "lower  DEL   END "
BoxNameInputUpper:
	db "A B C D E F G H I"
	db "J K L M N O P Q R"
	db "S T U V W X Y Z  "
	db "× ( ) : ; [ ] ", $e1, " ", $e2
	db "- ? ! ♂ ♀ / . , &"
	db "lower  DEL   END "


INCBIN "baserom.gbc", $11e5d, $122c1 - $11e5d

UnknownScript_0x122c1: ; 0x122c1
	checkbit2 $0011
	iffalse $62cd
	setbit2 $0051
	special $0017
	end
; 0x122ce

INCBIN "baserom.gbc", $122ce, $124c8 - $122ce

UnknownScript_0x124c8: ; 0x124c8
	refreshscreen $0
	3callasm BANK(Function124fa), Function124fa
	2writetext UnknownText_0x124f5
	closetext
	special $002e
	pause 40
	special $001b
	checkbit2 $0011
	iftrue .script_64f2
	3callasm BANK(HalveMoney), HalveMoney
	3callasm BANK(Function12527), Function12527
	3call BANK(UnknownScript_0x122c1), UnknownScript_0x122c1
	special $0000
	newloadmap $f1
	resetfuncs

.script_64f2
	jumpstd $0016
; 0x124f5

UnknownText_0x124f5: ; 0x124f5
	text_jump UnknownText_0x1c0a4e, BANK(UnknownText_0x1c0a4e)
	db $50
; 0x124fa

Function124fa: ; 124fa
	call ClearPalettes
	call Functionfdb
	call Function3200
	call HideSprites
	call Function4f0
	ret
; 1250a

INCBIN "baserom.gbc", $1250a, $12513 - $1250a


HalveMoney: ; 12513

; Empty function...
	ld a, $41
	ld hl, $60c7
	rst FarCall

; Halve the player's money.
	ld hl, Money
	ld a, [hl]
	srl a
	ld [hli], a
	ld a, [hl]
	rra
	ld [hli], a
	ld a, [hl]
	rra
	ld [hl], a
	ret
; 12527


Function12527: ; 12527
	ld a, [$dcb2]
	ld d, a
	ld a, [$dcb3]
	ld e, a
	ld a, $5
	ld hl, $5344
	rst FarCall
	ld a, c
	jr c, .asm_12539
	xor a

.asm_12539
	ld [$d001], a
	ret
; 1253d

INCBIN "baserom.gbc", $1253d, $12580 - $1253d


Function12580: ; 12580
	ld a, $2e
	ld hl, $4172
	rst FarCall
	jr c, .asm_1258d
	ld hl, $65ba
	jr .asm_12590

.asm_1258d
	ld hl, $65ad

.asm_12590
	call Function31cd
	ld a, $1
	ld [$d0ec], a
	ret
; 12599

INCBIN "baserom.gbc", $12599, $125cd - $12599


StartMenu: ; 125cd

	call Function1fbf

	ld de, SFX_MENU
	call StartSFX

	ld a, $1
	ld hl, $6454
	rst FarCall

	ld hl, StatusFlags2
	bit 2, [hl] ; bug catching contest
	ld hl, .MenuDataHeader
	jr z, .GotMenuData
	ld hl, .ContestMenuDataHeader
.GotMenuData

	call LoadMenuDataHeader
	call .SetUpMenuItems
	ld a, [$d0d2]
	ld [$cf88], a
	call .DrawMenuAccount_
	call MenuFunc_1e7f
	call .DrawBugContestStatusBox
	call Function2e31
	call Function2e20
	callba Function64bf
	call .DrawBugContestStatus
	call UpdateTimePals
	jr .Select

.Reopen
	call Function1ad2
	call UpdateTimePals
	call .SetUpMenuItems
	ld a, [$d0d2]
	ld [$cf88], a

.Select
	call .GetInput
	jr c, .Exit
	call .DrawMenuAccount
	ld a, [$cf88]
	ld [$d0d2], a
	call PlayClickSFX
	call Function1bee
	call .OpenMenu

; Menu items have different return functions.
; For example, saving exits the menu.
	ld hl, .MenuReturns
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
	
.MenuReturns
	dw .Reopen
	dw .Exit
	dw .ReturnTwo
	dw .ReturnThree
	dw .ReturnFour
	dw .ReturnEnd
	dw .ReturnRedraw

.Exit
	ld a, [hOAMUpdate]
	push af
	ld a, 1
	ld [hOAMUpdate], a
	call Functione5f
	pop af
	ld [hOAMUpdate], a
.ReturnEnd
	call Function1c07
.ReturnEnd2
	call Function2dcf
	call UpdateTimePals
	ret

.GetInput
; Return carry on exit, and no-carry on selection.
	xor a
	ld [hBGMapMode], a
	call .DrawMenuAccount
	call SetUpMenu
	ld a, $ff
	ld [MenuSelection], a
.loop
	call .PrintMenuAccount
	call Function1f1a
	ld a, [$cf73]
	cp BUTTON_B
	jr z, .b
	cp BUTTON_A
	jr z, .a
	jr .loop
.a
	call PlayClickSFX
	and a
	ret
.b
	scf
	ret
; 12691

.ReturnFour ; 12691
	call Function1c07
	ld a, $80
	ld [$ffa0], a
	ret
; 12699

.ReturnThree ; 12699
	call Function1c07
	ld a, $80
	ld [$ffa0], a
	jr .ReturnEnd2
; 126a2

.ReturnTwo ; 126a2
	call Function1c07
	ld hl, $d0e9
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [$d0e8]
	rst FarCall
	jr .ReturnEnd2
; 126b1

.ReturnRedraw ; 126b1
	call .Clear
	jp .Reopen
; 126b7

.Clear ; 126b7
	call WhiteBGMap
	call Function1d7d
	call Function2bae
	call .DrawMenuAccount_
	call MenuFunc_1e7f
	call .DrawBugContestStatus
	call Function1ad2
	call Functiond90
	call Function2b5c
	ret
; 126d3


.MenuDataHeader
	db $40 ; tile backup
	db 0, 10 ; start coords
	db 17, 19 ; end coords
	dw .MenuData
	db 1 ; default selection

.ContestMenuDataHeader
	db $40 ; tile backup
	db 2, 10 ; start coords
	db 17, 19 ; end coords
	dw .MenuData
	db 1 ; default selection

.MenuData
	db %10101000 ; x padding, wrap around, start can close
	dn 0, 0 ; rows, columns
	dw MenuItemsList
	dw .MenuString
	dw .Items

.Items
	dw StartMenu_Pokedex,  .PokedexString,  .PokedexDesc
	dw StartMenu_Pokemon,  .PartyString,    .PartyDesc
	dw StartMenu_Pack,     .PackString,     .PackDesc
	dw StartMenu_Status,   .StatusString,   .StatusDesc
	dw StartMenu_Save,     .SaveString,     .SaveDesc
	dw StartMenu_Option,   .OptionString,   .OptionDesc
	dw StartMenu_Exit,     .ExitString,     .ExitDesc
	dw StartMenu_Pokegear, .PokegearString, .PokegearDesc
	dw StartMenu_Quit,     .QuitString,     .QuitDesc

.PokedexString 	db "#DEX@"
.PartyString   	db "#MON@"
.PackString    	db "PACK@"
.StatusString  	db $52, "@"
.SaveString    	db "SAVE@"
.OptionString  	db "OPTION@"
.ExitString    	db "EXIT@"
.PokegearString	db $24, "GEAR@"
.QuitString    	db "QUIT@"

.PokedexDesc 	db "#MON", $4e, "database@"
.PartyDesc   	db "Party ", $4a, $4e, "status@"
.PackDesc    	db "Contains", $4e, "items@"
.PokegearDesc	db "Trainer's", $4e, "key device@"
.StatusDesc  	db "Your own", $4e, "status@"
.SaveDesc    	db "Save your", $4e, "progress@"
.OptionDesc  	db "Change", $4e, "settings@"
.ExitDesc    	db "Close this", $4e, "menu@"
.QuitDesc    	db "Quit and", $4e, "be judged.@"


.OpenMenu ; 127e5
	ld a, [MenuSelection]
	call .GetMenuAccountTextPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 127ef

.MenuString ; 127ef
	push de
	ld a, [MenuSelection]
	call .GetMenuAccountTextPointer
	inc hl
	inc hl
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	call PlaceString
	ret
; 12800

.MenuDesc ; 12800
	push de
	ld a, [MenuSelection]
	cp $ff
	jr z, .none 
	call .GetMenuAccountTextPointer
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	call PlaceString
	ret
.none
	pop de
	ret
; 12819


.GetMenuAccountTextPointer ; 12819
	ld e, a
	ld d, 0
	ld hl, $cf97
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	ret
; 12829


.SetUpMenuItems ; 12829
	xor a
	ld [$cf76], a
	call .FillMenuList

	ld hl, StatusFlags
	bit 0, [hl]
	jr z, .no_pokedex
	ld a, 0 ; pokedex
	call .AppendMenuList
.no_pokedex

	ld a, [PartyCount]
	and a
	jr z, .no_pokemon
	ld a, 1 ; pokemon
	call .AppendMenuList
.no_pokemon

	ld a, [InLinkBattle]
	and a
	jr nz, .no_pack
	ld hl, StatusFlags2
	bit 2, [hl] ; bug catching contest
	jr nz, .no_pack
	ld a, 2 ; pack
	call .AppendMenuList
.no_pack

	ld hl, $d957
	bit 7, [hl]
	jr z, .no_pokegear
	ld a, 7 ; pokegear
	call .AppendMenuList
.no_pokegear

	ld a, 3 ; status
	call .AppendMenuList

	ld a, [InLinkBattle]
	and a
	jr nz, .no_save
	ld hl, StatusFlags2
	bit 2, [hl] ; bug catching contest
	ld a, 8 ; quit
	jr nz, .write
	ld a, 4 ; save
.write
	call .AppendMenuList
.no_save

	ld a, 5 ; option
	call .AppendMenuList
	ld a, 6 ; exit
	call .AppendMenuList
	ld a, c
	ld [MenuItemsList], a
	ret
; 1288d


.FillMenuList ; 1288d
	xor a
	ld hl, MenuItemsList
	ld [hli], a
	ld a, $ff
	ld bc, $000f
	call ByteFill
	ld de, MenuItemsList + 1
	ld c, 0
	ret
; 128a0

.AppendMenuList ; 128a0
	ld [de], a
	inc de
	inc c
	ret
; 128a4

.DrawMenuAccount_ ; 128a4
	jp .DrawMenuAccount
; 128a7

.PrintMenuAccount ; 128a7
	call .IsMenuAccountOn
	ret z
	call .DrawMenuAccount
	decoord 0, 14
	jp .MenuDesc
; 128b4

.DrawMenuAccount ; 128b4
	call .IsMenuAccountOn
	ret z
	hlcoord 0, 13
	ld bc, $050a
	call ClearBox
	hlcoord 0, 13
	ld b, 3
	ld c, 8
	jp TextBoxPalette
; 128cb

.IsMenuAccountOn ; 128cb
	ld a, [Options2]
	and 1
	ret
; 128d1

.DrawBugContestStatusBox ; 128d1
	ld hl, StatusFlags2
	bit 2, [hl] ; bug catching contest
	ret z
	ld a, $9
	ld hl, $4bdc
	rst FarCall
	ret
; 128de

.DrawBugContestStatus ; 128de
	ld hl, StatusFlags2
	bit 2, [hl] ; bug catching contest
	jr nz, .contest
	ret
.contest
	ld a, $9
	ld hl, $4be7
	rst FarCall
	ret
; 128ed


StartMenu_Exit: ; 128ed
; Exit the menu.

	ld a, 1
	ret
; 128f0


StartMenu_Quit: ; 128f0
; Retire from the bug catching contest.

	ld hl, .EndTheContestText
	call Function12cf5
	jr c, .asm_12903
	ld a, $4
	ld hl, $760b
	call Function31cf
	ld a, 4
	ret
.asm_12903
	ld a, 0
	ret

.EndTheContestText
	text_jump UnknownText_0x1c1a6c, BANK(UnknownText_0x1c1a6c)
	db "@"
; 1290b


StartMenu_Save: ; 1290b
; Save the game.

	call Function2879
	ld a, $5
	ld hl, $4a1a
	rst FarCall
	jr nc, .asm_12919
	ld a, 0
	ret
.asm_12919
	ld a, 1
	ret
; 1291c


StartMenu_Option: ; 1291c
; Game options.

	call FadeToMenu
	callba OptionsMenu
	ld a, 6
	ret
; 12928


StartMenu_Status: ; 12928
; Player status.

	call FadeToMenu
	ld a, $9
	ld hl, $5105
	rst FarCall
	call Function2b3c
	ld a, 0
	ret
; 12937


StartMenu_Pokedex: ; 12937

	ld a, [PartyCount]
	and a
	jr z, .asm_12949

	call FadeToMenu
	ld a, $10
	ld hl, $4000
	rst FarCall
	call Function2b3c

.asm_12949
	ld a, 0
	ret
; 1294c


StartMenu_Pokegear: ; 1294c

	call FadeToMenu
	ld a, $24
	ld hl, $4b8d
	rst FarCall
	call Function2b3c
	ld a, 0
	ret
; 1295b


StartMenu_Pack: ; 1295b

	call FadeToMenu
	ld a, $4
	ld hl, $4000
	rst FarCall
	ld a, [$cf66]
	and a
	jr nz, .asm_12970
	call Function2b3c
	ld a, 0
	ret
.asm_12970
	call Function2b4d
	ld a, 4
	ret
; 12976


StartMenu_Pokemon: ; 12976

	ld a, [PartyCount]
	and a
	jr z, .return

	call FadeToMenu

.choosemenu
	xor a
	ld [PartyMenuActionText], a ; Choose a POKéMON.
	call WhiteBGMap

.menu
	ld a, $14
	ld hl, $404f
	rst FarCall ; load gfx
	ld a, $14
	ld hl, $4405
	rst FarCall ; setup menu?
	ld a, $14
	ld hl, $43e0
	rst FarCall ; load menu pokémon sprites

.menunoreload
	callba WritePartyMenuTilemap
	callba PrintPartyMenuText
	call WaitBGMap
	call Function32f9 ; load regular palettes?
	call DelayFrame
	callba PartyMenuSelect
	jr c, .return ; if cancelled or pressed B

	call PokemonActionSubmenu
	cp 3
	jr z, .menu
	cp 0
	jr z, .choosemenu
	cp 1
	jr z, .menunoreload
	cp 2
	jr z, .quit

.return
	call Function2b3c
	ld a, 0
	ret

.quit
	ld a, b
	push af
	call Function2b4d
	pop af
	ret
; 129d5


INCBIN "baserom.gbc", $129d5, $12a60 - $129d5


CantUseItem: ; 12a60
	ld hl, CantUseItemText
	call Function2012
	ret
; 12a67

CantUseItemText: ; 12a67
	text_jump UnknownText_0x1c1b03, BANK(UnknownText_0x1c1b03)
	db "@"
; 12a6c


PartyMonItemName: ; 12a6c
	ld a, [CurItem]
	ld [$d265], a
	call GetItemName
	call CopyName1
	ret
; 12a79


CancelPokemonAction: ; 12a79
	ld a, $14
	ld hl, $4405
	rst FarCall
	ld a, $23
	ld hl, $6a71
	rst FarCall
	ld a, 1
	ret
; 12a88


PokemonActionSubmenu: ; 12a88
	hlcoord 1, 15
	ld bc, $0212 ; box size
	call ClearBox
	ld a, $9
	ld hl, $4d19
	rst FarCall
	call GetCurNick
	ld a, [MenuSelection]
	ld hl, .Actions
	ld de, 3
	call IsInArray
	jr nc, .nothing

	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

.nothing
	ld a, 0
	ret

.Actions
	dbw  1, Function12e1b ; Cut
	dbw  2, Function12e30 ; Fly
	dbw  3, Function12ebd ; Surf
	dbw  4, Function12e6a ; Strength
	dbw  6, Function12e55 ; Flash
	dbw  7, Function12e7f ; Whirlpool
	dbw  8, Function12ed1 ; Dig
	dbw  9, Function12ea9 ; Teleport
	dbw 10, Function12ee6 ; Softboiled
	dbw 13, Function12ee6 ; MilkDrink
	dbw 11, Function12f26 ; Headbutt
	dbw  5, Function12e94 ; Flash
	dbw 12, Function12f3b ; RockSmash
	dbw 14, Function12f50 ; SweetScent
	dbw 15, OpenPartyStats
	dbw 16, SwitchPartyMons
	dbw 17, GiveTakePartyMonItem
	dbw 18, CancelPokemonAction
	dbw 19, Function12fba ; move
	dbw 20, Function12d45 ; mail
; 12aec


SwitchPartyMons: ; 12aec

; Don't try if there's nothing to switch!
	ld a, [PartyCount]
	cp 2
	jr c, .DontSwitch

	ld a, [CurPartyMon]
	inc a
	ld [$d0e3], a

	ld a, $23
	ld hl, $6a8c
	rst FarCall
	ld a, $14
	ld hl, $442d
	rst FarCall

	ld a, 4
	ld [PartyMenuActionText], a
	callba WritePartyMenuTilemap
	callba PrintPartyMenuText

	hlcoord 0, 1
	ld bc, 20 * 2
	ld a, [$d0e3]
	dec a
	call AddNTimes
	ld [hl], "▷"
	call WaitBGMap
	call Function32f9
	call DelayFrame

	callba PartyMenuSelect
	bit 1, b
	jr c, .DontSwitch

	ld a, $14
	ld hl, $4f12
	rst FarCall

	xor a
	ld [PartyMenuActionText], a

	ld a, $14
	ld hl, $404f
	rst FarCall
	ld a, $14
	ld hl, $4405
	rst FarCall
	ld a, $14
	ld hl, $43e0
	rst FarCall

	ld a, 1
	ret

.DontSwitch
	xor a
	ld [PartyMenuActionText], a
	call CancelPokemonAction
	ret
; 12b60


GiveTakePartyMonItem: ; 12b60

; Eggs can't hold items!
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_12ba6

	ld hl, GiveTakeItemMenuData
	call LoadMenuDataHeader
	call Function1d81
	call Function1c07
	jr c, .asm_12ba6

	call GetCurNick
	ld hl, StringBuffer1
	ld de, $d050
	ld bc, $b
	call CopyBytes
	ld a, [$cfa9]
	cp 1
	jr nz, .asm_12ba0

	call Function1d6e
	call ClearPalettes
	call Function12ba9
	call ClearPalettes
	call Functione58
	call Function1c07
	ld a, 0
	ret

.asm_12ba0
	call TakePartyItem
	ld a, 3
	ret

.asm_12ba6
	ld a, 3
	ret
; 12ba9


Function12ba9: ; 12ba9

	ld a, $4
	ld hl, $46a5
	rst FarCall

.loop
	ld a, $4
	ld hl, $46be
	rst FarCall

	ld a, [$cf66]
	and a
	jr z, .quit

	ld a, [$cf65]
	cp 2
	jr z, .next

	call CheckTossableItem
	ld a, [$d142]
	and a
	jr nz, .next

	call Function12bd9
	jr .quit

.next
	ld hl, CantBeHeldText
	call Function1d67
	jr .loop

.quit
	ret
; 12bd9


Function12bd9: ; 12bd9

	call SpeechTextBox
	call PartyMonItemName
	call GetPartyItemLocation
	ld a, [hl]
	and a
	jr z, .asm_12bf4

	push hl
	ld d, a
	ld a, $2e
	ld hl, $5e76
	rst FarCall
	pop hl
	jr c, .asm_12c01
	ld a, [hl]
	jr .asm_12c08

.asm_12bf4
	call $6cea
	ld hl, MadeHoldText
	call Function1d67
	call GivePartyItem
	ret

.asm_12c01
	ld hl, PleaseRemoveMailText
	call Function1d67
	ret

.asm_12c08
	ld [$d265], a
	call GetItemName
	ld hl, SwitchAlreadyHoldingText
	call Function12cf5
	jr c, .asm_12c4b

	call $6cea
	ld a, [$d265]
	push af
	ld a, [CurItem]
	ld [$d265], a
	pop af
	ld [CurItem], a
	call Function12cdf
	jr nc, .asm_12c3c

	ld hl, TookAndMadeHoldText
	call Function1d67
	ld a, [$d265]
	ld [CurItem], a
	call GivePartyItem
	ret

.asm_12c3c
	ld a, [$d265]
	ld [CurItem], a
	call Function12cdf
	ld hl, ItemStorageIsFullText
	call Function1d67

.asm_12c4b
	ret
; 12c4c


GivePartyItem: ; 12c4c

	call GetPartyItemLocation
	ld a, [CurItem]
	ld [hl], a
	ld d, a
	ld a, $2e
	ld hl, $5e76
	rst FarCall
	jr nc, .asm_12c5f
	call $6cfe

.asm_12c5f
	ret
; 12c60


TakePartyItem: ; 12c60

	call SpeechTextBox
	call GetPartyItemLocation
	ld a, [hl]
	and a
	jr z, .asm_12c8c

	ld [CurItem], a
	call Function12cdf
	jr nc, .asm_12c94

	ld a, $2e
	ld hl, $5e76
	rst FarCall
	call GetPartyItemLocation
	ld a, [hl]
	ld [$d265], a
	ld [hl], NO_ITEM
	call GetItemName
	ld hl, TookFromText
	call Function1d67
	jr .asm_12c9a

.asm_12c8c
	ld hl, IsntHoldingAnythingText
	call Function1d67
	jr .asm_12c9a

.asm_12c94
	ld hl, ItemStorageIsFullText
	call Function1d67

.asm_12c9a
	ret
; 12c9b


GiveTakeItemMenuData: ; 12c9b
	db %01010000
	db 12, 12 ; start coords
	db 17, 19 ; end coords
	dw .Items
	db 1 ; default option

.Items
	db %10000000 ; x padding
	db 2 ; # items
	db "GIVE@"
	db "TAKE@"
; 12caf


TookAndMadeHoldText: ; 12caf
	text_jump UnknownText_0x1c1b2c, BANK(UnknownText_0x1c1b2c)
	db "@"
; 12cb4

MadeHoldText: ; 12cb4
	text_jump UnknownText_0x1c1b57, BANK(UnknownText_0x1c1b57)
	db "@"
; 12cb9

PleaseRemoveMailText: ; 12cb9
	text_jump UnknownText_0x1c1b6f, BANK(UnknownText_0x1c1b6f)
	db "@"
; 12cbe

IsntHoldingAnythingText: ; 12cbe
	text_jump UnknownText_0x1c1b8e, BANK(UnknownText_0x1c1b8e)
	db "@"
; 12cc3

ItemStorageIsFullText: ; 12cc3
	text_jump UnknownText_0x1c1baa, BANK(UnknownText_0x1c1baa)
	db "@"
; 12cc8

TookFromText: ; 12cc8
	text_jump UnknownText_0x1c1bc4, BANK(UnknownText_0x1c1bc4)
	db "@"
; 12ccd

SwitchAlreadyHoldingText: ; 12ccd
	text_jump UnknownText_0x1c1bdc, BANK(UnknownText_0x1c1bdc)
	db "@"
; 12cd2

CantBeHeldText: ; 12cd2
	text_jump UnknownText_0x1c1c09, BANK(UnknownText_0x1c1c09)
	db "@"
; 12cd7


GetPartyItemLocation: ; 12cd7
	push af
	ld a, PartyMon1Item - PartyMon1
	call GetPartyParamLocation
	pop af
	ret
; 12cdf


Function12cdf: ; 12cdf
	ld a, $1
	ld [$d10c], a
	ld hl, NumItems
	jp Function2f66
; 12cea

INCBIN "baserom.gbc", $12cea, $12cf5 - $12cea

Function12cf5: ; 12cf5
	call Function1d4f
	call Function1dcf
	jp Function1c07
; 12cfe

INCBIN "baserom.gbc", $12cfe, $12d45 - $12cfe

Function12d45: ; 12d45
	ld a, [InLinkBattle]
	cp $1
	jr z, .asm_12d6d
	cp $2
	jr z, .asm_12d6d
	ld hl, $6dc9
	call LoadMenuDataHeader
	call Function1d81
	call Function1c07
	jp c, .asm_12dc6
	ld a, [$cfa9]
	cp $1
	jr z, .asm_12d6d
	cp $2
	jr z, .asm_12d76
	jp .asm_12dc6

.asm_12d6d
	ld a, $2e
	ld hl, $5229
	rst FarCall
	ld a, $0
	ret

.asm_12d76
	ld hl, UnknownText_0x12df1
	call Function12cf5
	jr c, .asm_12d9a
	ld a, [CurPartyMon]
	ld b, a
	callba Function4456e
	jr c, .asm_12d92
	ld hl, UnknownText_0x12dfb
	call Function1d67
	jr .asm_12dc6

.asm_12d92
	ld hl, UnknownText_0x12df6
	call Function1d67
	jr .asm_12dc6

.asm_12d9a
	ld hl, UnknownText_0x12de2
	call Function12cf5
	jr c, .asm_12dc6
	call GetPartyItemLocation
	ld a, [hl]
	ld [CurItem], a
	call Function12cdf
	jr nc, .asm_12dbe
	call GetPartyItemLocation
	ld [hl], $0
	call GetCurNick
	ld hl, UnknownText_0x12de7
	call Function1d67
	jr .asm_12dc6

.asm_12dbe
	ld hl, UnknownText_0x12dec
	call Function1d67
	jr .asm_12dc6

.asm_12dc6
	ld a, $3
	ret
; 12dc9


INCBIN "baserom.gbc", $12dc9, $12de2 - $12dc9


UnknownText_0x12de2: ; 0x12de2
	text_jump UnknownText_0x1c1c22, BANK(UnknownText_0x1c1c22)
	db "@"
; 0x12de7

UnknownText_0x12de7: ; 0x12de7
	text_jump UnknownText_0x1c1c47, BANK(UnknownText_0x1c1c47)
	db "@"
; 0x12dec

UnknownText_0x12dec: ; 0x12dec
	text_jump UnknownText_0x1c1c62, BANK(UnknownText_0x1c1c62)
	db "@"
; 0x12df1

UnknownText_0x12df1: ; 0x12df1
	text_jump UnknownText_0x1c1c86, BANK(UnknownText_0x1c1c86)
	db "@"
; 0x12df6

UnknownText_0x12df6: ; 0x12df6
	text_jump UnknownText_0x1c1ca9, BANK(UnknownText_0x1c1ca9)
	db "@"
; 0x12dfb

UnknownText_0x12dfb: ; 0x12dfb
	text_jump UnknownText_0x1c1cc4, BANK(UnknownText_0x1c1cc4)
	db "@"
; 0x12e00


OpenPartyStats: ; 12e00
	call Function1d6e
	call ClearSprites
; PartyMon
	xor a
	ld [MonType], a
	call LowVolume
	ld a, $25
	call Predef
	call MaxVolume
	call Function1d7d
	ld a, 0
	ret
; 12e1b


Function12e1b: ; 12e1b
	ld a, $3
	ld hl, $4785
	rst FarCall
	ld a, [$d0ec]
	cp $1
	jr nz, .asm_12e2d
	ld b, $4
	ld a, $2
	ret

.asm_12e2d
	ld a, $3
	ret
; 12e30


Function12e30: ; 12e30
	callba Functionca3b
	ld a, [$d0ec]
	cp $2
	jr z, .asm_12e4c
	cp $0
	jr z, .asm_12e4f
	ld a, $41
	ld hl, $60b5
	rst FarCall
	ld b, $4
	ld a, $2
	ret

.asm_12e4c
	ld a, $3
	ret

.asm_12e4f
	ld a, $0
	ret
; 12e52

INCBIN "baserom.gbc", $12e52, $12e55 - $12e52

Function12e55: ; 12e55
	ld a, $3
	ld hl, $48ac
	rst FarCall
	ld a, [$d0ec]
	cp $1
	jr nz, .asm_12e67
	ld b, $4
	ld a, $2
	ret

.asm_12e67
	ld a, $3
	ret
; 12e6a

Function12e6a: ; 12e6a
	callba Functioncce5
	ld a, [$d0ec]
	cp $1
	jr nz, .asm_12e7c
	ld b, $4
	ld a, $2
	ret

.asm_12e7c
	ld a, $3
	ret
; 12e7f

Function12e7f: ; 12e7f
	ld a, $3
	ld hl, $4d9d
	rst FarCall
	ld a, [$d0ec]
	cp $1
	jr nz, .asm_12e91
	ld b, $4
	ld a, $2
	ret

.asm_12e91
	ld a, $3
	ret
; 12e94

Function12e94: ; 12e94
	ld a, $3
	ld hl, $4ade
	rst FarCall
	ld a, [$d0ec]
	cp $1
	jr nz, .asm_12ea6
	ld b, $4
	ld a, $2
	ret

.asm_12ea6
	ld a, $3
	ret
; 12ea9

Function12ea9: ; 12ea9
	ld a, $3
	ld hl, $4c61
	rst FarCall
	ld a, [$d0ec]
	and a
	jr z, .asm_12eba
	ld b, $4
	ld a, $2
	ret

.asm_12eba
	ld a, $3
	ret
; 12ebd

Function12ebd: ; 12ebd
	ld a, $3
	ld hl, $4909
	rst FarCall
	ld a, [$d0ec]
	and a
	jr z, .asm_12ece
	ld b, $4
	ld a, $2
	ret

.asm_12ece
	ld a, $3
	ret
; 12ed1

Function12ed1: ; 12ed1
	ld a, $3
	ld hl, $4b9c
	rst FarCall
	ld a, [$d0ec]
	cp $1
	jr nz, .asm_12ee3
	ld b, $4
	ld a, $2
	ret

.asm_12ee3
	ld a, $3
	ret
; 12ee6

Function12ee6: ; 12ee6
	call Function12f05
	jr nc, .asm_12ef3
	ld a, $3
	ld hl, $73df
	rst FarCall
	jr .asm_12ef9

.asm_12ef3
	ld hl, $6f00
	call PrintText

.asm_12ef9
	xor a
	ld [PartyMenuActionText], a
	ld a, $3
	ret
; 12f00

INCBIN "baserom.gbc", $12f00, $12f05 - $12f00

Function12f05: ; 12f05
	ld a, $24
	call GetPartyParamLocation
	ld a, [hli]
	ld [hProduct], a
	ld a, [hl]
	ld [hMultiplicand], a
	ld a, $5
	ld [hMultiplier], a
	ld b, $2
	call Divide
	ld a, $23
	call GetPartyParamLocation
	ld a, [$ffb6]
	sub [hl]
	dec hl
	ld a, [$ffb5]
	sbc [hl]
	ret
; 12f26

Function12f26: ; 12f26
	ld a, $3
	ld hl, $4e7d
	rst FarCall
	ld a, [$d0ec]
	cp $1
	jr nz, .asm_12f38
	ld b, $4
	ld a, $2
	ret

.asm_12f38
	ld a, $3
	ret
; 12f3b

Function12f3b: ; 12f3b
	ld a, $3
	ld hl, $4eeb
	rst FarCall
	ld a, [$d0ec]
	cp $1
	jr nz, .asm_12f4d
	ld b, $4
	ld a, $2
	ret

.asm_12f4d
	ld a, $3
	ret
; 12f50

Function12f50: ; 12f50
	ld a, $14
	ld hl, $46bc
	rst FarCall
	ld b, $4
	ld a, $2
	ret
; 12f5b

INCBIN "baserom.gbc", $12f5b, $12fba - $12f5b

Function12fba: ; 12fba
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_12fd2
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	call Function12fd5
	pop af
	ld [Options], a
	call WhiteBGMap

.asm_12fd2
	ld a, $0
	ret
; 12fd5

Function12fd5: ; 12fd5
	ld a, [CurPartyMon]
	inc a
	ld [$d0d8], a
	call Function13172
	call Function132d3
	ld de, $7163
	call Function1bb1
	call Function131ef
	ld hl, $cfa5
	set 6, [hl]
	jr .asm_13009

	call Function1bd3
	bit 1, a
	jp nz, Function13038
	bit 0, a
	jp nz, Function130c6
	bit 4, a
	jp nz, Function1305b
	bit 5, a
	jp nz, Function13075

.asm_13009
	call Function13235
	ld a, [$d0e3]
	and a
	jr nz, .asm_13018
	call Function13256
	jp $6ff2

.asm_13018
	ld a, $7f
	ld hl, $c57d
	ld bc, $0005
	call ByteFill
	ld hl, $c591
	ld bc, $0512
	call ClearBox
	ld hl, $c591
	ld de, $716b
	call PlaceString
	jp $6ff2
; 13038

Function13038: ; 13038
	call PlayClickSFX
	call WaitSFX
	ld a, [$d0e3]
	and a
	jp z, Function13154
	ld a, [$d0e3]
	ld [$cfa9], a
	xor a
	ld [$d0e3], a
	ld hl, $c4c9
	ld bc, $0812
	call ClearBox
	jp $6fe8
; 1305b

Function1305b: ; 1305b
	ld a, [$d0e3]
	and a
	jp nz, $6ff2
	ld a, [CurPartyMon]
	ld b, a
	push bc
	call Function1308f
	pop bc
	ld a, [CurPartyMon]
	cp b
	jp z, $6ff2
	jp Function12fd5
; 13075

Function13075: ; 13075
	ld a, [$d0e3]
	and a
	jp nz, $6ff2
	ld a, [CurPartyMon]
	ld b, a
	push bc
	call $70a7
	pop bc
	ld a, [CurPartyMon]
	cp b
	jp z, $6ff2
	jp Function12fd5
; 1308f

Function1308f: ; 1308f
.asm_1308f
	ld a, [CurPartyMon]
	inc a
	ld [CurPartyMon], a
	ld c, a
	ld b, 0
	ld hl, PartySpecies
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .asm_130a7
	cp EGG
	ret nz
	jr .asm_1308f

.asm_130a7
	ld a, [CurPartyMon]
	and a
	ret z
.asm_130ac
	ld a, [CurPartyMon]
	dec a
	ld [CurPartyMon], a
	ld c, a
	ld b, 0
	ld hl, PartySpecies
	add hl, bc
	ld a, [hl]
	cp EGG
	ret nz
	ld a, [CurPartyMon]
	and a
	jr z, .asm_1308f
	jr .asm_130ac
; 130c6

Function130c6: ; 130c6
	call PlayClickSFX
	call WaitSFX
	ld a, [$d0e3]
	and a
	jr nz, .asm_130de
	ld a, [$cfa9]
	ld [$d0e3], a
	call Function1bee
	jp $7018

.asm_130de
	ld hl, PartyMon1Move1
	ld bc, $0030
	ld a, [CurPartyMon]
	call AddNTimes
	push hl
	call Function1313a
	pop hl
	ld bc, $0015
	add hl, bc
	call Function1313a
	ld a, [IsInBattle]
	jr z, .asm_13113
	ld hl, BattleMonMove1
	ld bc, $0020
	ld a, [CurPartyMon]
	call AddNTimes
	push hl
	call Function1313a
	pop hl
	ld bc, $0006
	add hl, bc
	call Function1313a

.asm_13113
	ld de, $0020
	call StartSFX
	call WaitSFX
	ld de, $0020
	call StartSFX
	call WaitSFX
	ld hl, $c4c9
	ld bc, $0812
	call ClearBox
	ld hl, $c572
	ld bc, $0109
	call ClearBox
	jp $6fe8
; 1313a

Function1313a: ; 1313a
	push hl
	ld a, [$cfa9]
	dec a
	ld c, a
	ld b, $0
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [$d0e3]
	dec a
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [de]
	ld b, [hl]
	ld [hl], a
	ld a, b
	ld [de], a
	ret
; 13154

Function13154: ; 13154
	xor a
	ld [$d0e3], a
	ld hl, $cfa5
	res 6, [hl]
	call ClearSprites
	jp ClearTileMap
; 13163

INCBIN "baserom.gbc", $13163, $13172 - $13163

Function13172: ; 13172
	call WhiteBGMap
	call ClearTileMap
	call ClearSprites
	xor a
	ld [hBGMapMode], a
	ld a, $3e
	ld hl, $7571
	rst FarCall
	callba Function8e814
	ld a, [CurPartyMon]
	ld e, a
	ld d, $0
	ld hl, PartySpecies
	add hl, de
	ld a, [hl]
	ld [$d265], a
	ld e, $2
	ld a, $23
	ld hl, $683f
	rst FarCall
	ld hl, $c4b4
	ld b, $9
	ld c, $12
	call TextBox
	ld hl, $c57c
	ld b, $5
	ld c, $12
	call TextBox
	ld hl, $c4a2
	ld bc, $0203
	call ClearBox
	xor a
	ld [MonType], a
	ld hl, PartyMon1Nickname
	ld a, [CurPartyMon]
	call GetNick
	ld hl, $c4b9
	call PlaceString
	push bc
	ld a, $14
	ld hl, $484a
	rst FarCall
	pop hl
	call PrintLevel
	ld hl, PlayerHPPal
	call SetHPPal
	ld b, $e
	call GetSGBLayout
	ld hl, $c4b0
	ld bc, $0103
	jp ClearBox
; 131ef

Function131ef: ; 131ef
	xor a
	ld [hBGMapMode], a
	ld [$d0e3], a
	ld [MonType], a
	ld a, $1f
	call Predef
	ld hl, TempMonMove1
	ld de, $d25e
	ld bc, $0004
	call CopyBytes
	ld a, $28
	ld [Buffer1], a
	ld hl, $c4de
	ld a, $20
	call Predef
	ld hl, $c4fa
	ld a, $23
	call Predef
	call WaitBGMap
	call Function32f9
	ld a, [$d0eb]
	inc a
	ld [$cfa3], a
	ld hl, $c57c
	ld b, $5
	ld c, $12
	jp TextBox
; 13235

Function13235: ; 13235
	ld hl, PartyMon1Move1
	ld bc, $0030
	ld a, [CurPartyMon]
	call AddNTimes
	ld a, [$cfa9]
	dec a
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	ld [CurSpecies], a
	ld hl, $c591
	ld bc, $0512
	jp ClearBox
; 13256

Function13256: ; 13256
	xor a
	ld [hBGMapMode], a
	ld hl, $c568
	ld de, $72ba
	call PlaceString
	ld hl, $c57c
	ld de, $72c2
	call PlaceString
	ld hl, $c59c
	ld de, $72ca
	call PlaceString
	ld a, [CurSpecies]
	ld b, a
	ld hl, $c592
	ld a, PREDEF_PRINT_MOVE_TYPE
	call Predef
	ld a, [CurSpecies]
	dec a
	ld hl, $5afd
	ld bc, $0007
	call AddNTimes
	ld a, $10
	call GetFarByte
	ld hl, $c5a0
	cp $2
	jr c, .asm_132a7
	ld [$d265], a
	ld de, $d265
	ld bc, $0103
	call PrintNum
	jr .asm_132ad

.asm_132a7
	ld de, $72cf
	call PlaceString

.asm_132ad
	ld hl, $c5b9
	ld a, $11
	call Predef
	ld a, $1
	ld [hBGMapMode], a
	ret
; 132ba

INCBIN "baserom.gbc", $132ba, $132d3 - $132ba

Function132d3: ; 132d3
	call Function132da
	call Function132fe
	ret
; 132da

Function132da: ; 132da
	ld a, [CurPartyMon]
	and a
	ret z
	ld c, a
	ld e, a
	ld d, 0
	ld hl, PartyCount
	add hl, de
.asm_132e7
	ld a, [hl]
	and a
	jr z, .asm_132f3
	cp EGG
	jr z, .asm_132f3
	cp NUM_POKEMON + 1
	jr c, .asm_132f8

.asm_132f3
	dec hl
	dec c
	jr nz, .asm_132e7
	ret

.asm_132f8
	ld hl, $c4b0
	ld [hl], $71
	ret
; 132fe

Function132fe: ; 132fe
	ld a, [CurPartyMon]
	inc a
	ld c, a
	ld a, [PartyCount]
	cp c
	ret z
	ld e, c
	ld d, 0
	ld hl, PartySpecies
	add hl, de
.asm_1330f
	ld a, [hl]
	cp $ff
	ret z
	and a
	jr z, .asm_1331e
	cp EGG
	jr z, .asm_1331e
	cp NUM_POKEMON + 1
	jr c, .asm_13321

.asm_1331e
	inc hl
	jr .asm_1330f

.asm_13321
	hlcoord 18, 0
	ld [hl], "▶"
	ret
; 13327


SelectMenu: ; 13327

	call CheckRegisteredItem
	jr c, .NotRegistered
	jp UseRegisteredItem

.NotRegistered
	call Function2e08
	ld b, BANK(ItemMayBeRegisteredText)
	ld hl, ItemMayBeRegisteredText
	call Function269a
	call Functiona46
	jp Function2dcf
; 13340


ItemMayBeRegisteredText: ; 13340
	text_jump UnknownText_0x1c1cf3, BANK(UnknownText_0x1c1cf3)
	db "@"
; 13345


CheckRegisteredItem: ; 13345

	ld a, [WhichRegisteredItem]
	and a
	jr z, .NoRegisteredItem
	and REGISTERED_POCKET
	rlca
	rlca
	ld hl, .Pockets
	rst JumpTable
	ret

.Pockets
	dw .CheckItem
	dw .CheckBall
	dw .CheckKeyItem
	dw .CheckTMHM

.CheckItem
	ld hl, NumItems
	call .CheckRegisteredNo
	jr c, .NoRegisteredItem
	inc hl
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	call .IsSameItem
	jr c, .NoRegisteredItem
	and a
	ret

.CheckKeyItem
	ld a, [RegisteredItem]
	ld hl, KeyItems
	ld de, 1
	call IsInArray
	jr nc, .NoRegisteredItem
	ld a, [RegisteredItem]
	ld [CurItem], a
	and a
	ret

.CheckBall
	ld hl, NumBalls
	call .CheckRegisteredNo
	jr nc, .NoRegisteredItem
	inc hl
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	call .IsSameItem
	jr c, .NoRegisteredItem
	ret

.CheckTMHM
	jr .NoRegisteredItem

.NoRegisteredItem
	xor a
	ld [WhichRegisteredItem], a
	ld [RegisteredItem], a
	scf
	ret
; 133a6


.CheckRegisteredNo ; 133a6
	ld a, [WhichRegisteredItem]
	and REGISTERED_NUMBER
	dec a
	cp [hl]
	jr nc, .NotEnoughItems
	ld [$d107], a
	and a
	ret

.NotEnoughItems
	scf
	ret
; 133b6


.IsSameItem ; 133b6
	ld a, [RegisteredItem]
	cp [hl]
	jr nz, .NotSameItem
	ld [CurItem], a
	and a
	ret

.NotSameItem
	scf
	ret
; 133c3


UseRegisteredItem: ; 133c3

	callba CheckItemMenu
	ld a, [$d142]
	ld hl, .SwitchTo
	rst JumpTable
	ret

.SwitchTo
	dw .CantUse
	dw .NoFunction
	dw .NoFunction
	dw .NoFunction
	dw .Current
	dw .Party
	dw .Overworld
; 133df

.NoFunction ; 133df
	call Function2e08
	call CantUseItem
	call Function2dcf
	and a
	ret
; 133ea

.Current ; 133ea
	call Function2e08
	call DoItemEffect
	call Function2dcf
	and a
	ret
; 133f5

.Party ; 133f5
	call ResetWindow
	call FadeToMenu
	call DoItemEffect
	call Function2b3c
	call Function2dcf
	and a
	ret
; 13406

.Overworld ; 13406
	call ResetWindow
	ld a, 1
	ld [$d0ef], a
	call DoItemEffect
	xor a
	ld [$d0ef], a
	ld a, [$d0ec]
	cp 1
	jr nz, .asm_13425
	scf
	ld a, $80
	ld [$ffa0], a
	ret
; 13422

.CantUse ; 13422
	call ResetWindow

.asm_13425
	call CantUseItem
	call Function2dcf
	and a
	ret
; 1342d


Function1342d: ; 1342d
	call Function1344a
	call Function1347d
	jr c, .asm_13448
	ld [$d041], a
	call Function134dd
	jr c, .asm_13448
	ld hl, $d041
	cp [hl]
	jr z, .asm_13448
	call Function134c0
	and a
	ret

.asm_13448
	scf
	ret
; 1344a

Function1344a: ; 1344a
	ld a, b
	ld [EngineBuffer1], a
	ld a, e
	ld [CurFruit], a
	ld a, d
	ld [MartPointer], a
	call Function1345a
	ret
; 1345a

Function1345a: ; 1345a
	ld de, CurMart
	ld bc, $0004
	ld hl, CurFruit
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [EngineBuffer1]
	call GetFarByte
	inc hl
	ld [de], a
	inc de
.asm_1346f
	ld a, [EngineBuffer1]
	call GetFarByte
	ld [de], a
	inc de
	add hl, bc
	cp $ff
	jr nz, .asm_1346f
	ret
; 1347d

Function1347d: ; 1347d
	ld hl, CurFruit
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [EngineBuffer1]
	call GetFarByte
	ld c, a
	inc hl
	ld a, [BackupMapGroup]
	ld d, a
	ld a, [BackupMapNumber]
	ld e, a
	ld b, $0
.asm_13495
	ld a, [EngineBuffer1]
	call GetFarByte
	cp $ff
	jr z, .asm_134be
	inc hl
	inc hl
	ld a, [EngineBuffer1]
	call GetFarByte
	inc hl
	cp d
	jr nz, .asm_134b7
	ld a, [EngineBuffer1]
	call GetFarByte
	inc hl
	cp e
	jr nz, .asm_134b8
	jr .asm_134bb

.asm_134b7
	inc hl

.asm_134b8
	inc b
	jr .asm_13495

.asm_134bb
	xor a
	ld a, b
	ret

.asm_134be
	scf
	ret
; 134c0

Function134c0: ; 134c0
	push af
	ld hl, CurFruit
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	pop af
	ld bc, $0004
	call AddNTimes
	inc hl
	ld de, $dcac
	ld a, [EngineBuffer1]
	ld bc, $0003
	call FarCopyBytes
	ret
; 134dd

Function134dd: ; 134dd
	call Function1d6e
	ld hl, $750d
	call PrintText
	call Function13512
	ld hl, $7550
	call Function1d3c
	call Function352f
	call Function1ad2
	xor a
	ld [$d0e4], a
	call Function350c
	call Function1c17
	ld a, [$cf73]
	cp $2
	jr z, .asm_1350b
	xor a
	ld a, [$cf77]
	ret

.asm_1350b
	scf
	ret
; 1350d

INCBIN "baserom.gbc", $1350d, $13512 - $1350d


Function13512: ; 13512
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	ld hl, TileMap
	ld b, $4
	ld c, $8
	call TextBox
	ld hl, $c4c9
	ld de, $7537
	call PlaceString
	ld hl, $c4f4
	call Function1353f
	pop af
	ld [Options], a
	ret
; 13537

INCBIN "baserom.gbc", $13537, $1353f - $13537


Function1353f: ; 1353f
	push hl
	ld a, [$d041]
	ld e, a
	ld d, 0
	ld hl, $d0f1
	add hl, de
	ld a, [hl]
	pop de
	call Function1356b
	ret
; 13550

INCBIN "baserom.gbc", $13550, $1356b - $13550


Function1356b: ; 1356b
	push de
	call Function13575
	ld d, h
	ld e, l
	pop hl
	jp PlaceString
; 13575

Function13575: ; 13575
	push de
	ld e, a
	ld d, 0
	ld hl, .floors
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	ret
; 13583

.floors
	dw .b4f
	dw .b3f
	dw .b2f
	dw .b1f
	dw ._1f
	dw ._2f
	dw ._3f
	dw ._4f
	dw ._5f
	dw ._6f
	dw ._7f
	dw ._8f
	dw ._9f
	dw ._10f
	dw ._11f
	dw .roof

.b4f
	db "B4F@"
.b3f
	db "B3F@"
.b2f
	db "B2F@"
.b1f
	db "B1F@"
._1f
	db "1F@"
._2f
	db "2F@"
._3f
	db "3F@"
._4f
	db "4F@"
._5f
	db "5F@"
._6f
	db "6F@"
._7f
	db "7F@"
._8f
	db "8F@"
._9f
	db "9F@"
._10f
	db "10F@"
._11f
	db "11F@"
.roof
	db "ROOF@"
; 135db


INCBIN "baserom.gbc", $135db, $135eb - $135db

UnknownScript_0x135eb: ; 0x135eb
	writecode $3, $6
	battlecheck
	startbattle
	returnafterbattle
	copybytetovar $dc79
	iffalse UnknownScript_0x13603
	end
; 0x135f8

INCBIN "baserom.gbc", $135f8, $13603 - $135f8

UnknownScript_0x13603: ; 0x13603
	playsound SFX_ELEVATOR_END
	loadfont
	2writetext UnknownText_0x13614
	closetext
	loadmovesprites
	jumpstd $0016
; 0x1360f

INCBIN "baserom.gbc", $1360f, $13614 - $1360f

UnknownText_0x13614: ; 0x13614
	text_jump UnknownText_0x1bd2e7, BANK(UnknownText_0x1bd2e7)
	db $50
; 0x13619

INCBIN "baserom.gbc", $13619, $1365b - $13619


Function1365b: ; 1365b
	ld a, c
	ld de, .table2 - .table1
	ld hl, .table1
	call IsInArray
	jr nc, .asm_1367f

	ld a, $c ; jumpstd
	ld [$d03f], a
	inc hl
	ld a, [hli]
	ld [$d03f + 1], a
	ld a, [hli]
	ld [$d03f + 2], a
	ld a, BANK(UnknownScript_0x1369a)
	ld hl, UnknownScript_0x1369a
	call CallScript
	scf
	ret

.asm_1367f
	xor a
	ret
; 13681

.table1
	dbw $91, $0003 ; bookshelf
.table2
	dbw $93, $0031 ; pc
	dbw $94, $000b ; radio
	dbw $95, $0007 ; map
	dbw $96, $0006 ; merchandise
	dbw $97, $0009 ; tv
	dbw $9d, $0008 ; window
	dbw $9f, $0005 ; incense burner
	dbw $ff ; end
; 1369a

UnknownScript_0x1369a: ; 0x1369a
	2jump $d03f
; 0x1369d


INCBIN "baserom.gbc", $1369d, $13988 - $1369d

Function13988: ; 13988
	ld hl, PartyMon1PokerusStatus
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
.asm_13991
	ld a, [hl]
	and $f
	jr z, .asm_139a0
	sub b
	jr nc, .asm_1399a
	xor a

.asm_1399a
	ld d, a
	ld a, [hl]
	and $f0
	add d
	ld [hl], a

.asm_139a0
	ld de, PartyMon2 - PartyMon1
	add hl, de
	dec c
	jr nz, .asm_13991
	ret
; 139a8

INCBIN "baserom.gbc", $139a8, $13b87 - $139a8


GetSquareRoot: ; 13b87
; Return the square root of de in b.

; Rather than calculating the result, we take the index of the
; first value in a table of squares that isn't lower than de.

	ld hl, Squares
	ld b, 0
.loop
; Make sure we don't go past the end of the table.
	inc b
	ld a, b
	cp $ff
	ret z

; Iterate over the table until b**2 >= de.
	ld a, [hli]
	sub e
	ld a, [hli]
	sbc d

	jr c, .loop
	ret

Squares: ; 13b98
root	set 1
	rept $ff
	dw root*root
root	set root+1
	endr
; 13d96


SECTION "bank5",ROMX,BANK[$5]


Function14000: ; 14000
	ld a, $a
	ld [$0000], a
	call LatchClock
	ld a, $c
	ld [Function14000], a
	ld a, [$a000]
	set 6, a
	ld [$a000], a
	call CloseSRAM
	ret
; 14019



Function14019: ; 14019
	ld a, $a
	ld [$0000], a
	call LatchClock
	ld a, $c
	ld [Function14000], a
	ld a, [$a000]
	res 6, a
	ld [$a000], a
	call CloseSRAM
	ret
; 14032



GetTimeOfDay: ; 14032
; get time of day based on the current hour
	ld a, [hHours] ; hour
	ld hl, TimesOfDay
	
.check
; if we're within the given time period,
; get the corresponding time of day
	cp [hl]
	jr c, .match
; else, get the next entry
	inc hl
	inc hl
; try again
	jr .check
	
.match
; get time of day
	inc hl
	ld a, [hl]
	ld [TimeOfDay], a
	ret
; 14044

TimesOfDay: ; 14044
; hours for the time of day
; 04-09 morn | 10-17 day | 18-03 nite
	db 04, NITE
	db 10, MORN
	db 18, DAY
	db 24, NITE
; 1404c


INCBIN "baserom.gbc", $1404c, $14056 - $1404c


Function14056: ; 14056
	call UpdateTime
	ld hl, $d4ba
	ld a, [CurDay]
	ld [hli], a
	ld a, [hHours]
	ld [hli], a
	ld a, [hMinutes]
	ld [hli], a
	ld a, [hSeconds]
	ld [hli], a
	ret
; 1406a

Function1406a: ; 1406a
	ld a, $a
	ld [$0000], a
	call LatchClock
	ld hl, $a000
	ld a, $c
	ld [Function14000], a
	res 7, [hl]
	ld a, $0
	ld [Function14000], a
	xor a
	ld [$ac60], a
	call CloseSRAM
	ret
; 14089



StartClock: ; 14089
	call GetClock
	call Function1409b
	call FixDays
	jr nc, .asm_14097
	call Function6d3

.asm_14097
	call Function14019
	ret
; 1409b

Function1409b: ; 1409b
	ld hl, hRTCDayHi
	bit 7, [hl]
	jr nz, .asm_140a8
	bit 6, [hl]
	jr nz, .asm_140a8
	xor a
	ret

.asm_140a8
	ld a, $80
	call Function6d3
	ret
; 140ae

Function140ae: ; 140ae
	call Function6e3
	ld c, a
	and $c0
	jr nz, .asm_140c8
	ld a, c
	and $20
	jr z, .asm_140eb
	call UpdateTime
	ld a, [$d4ba]
	ld b, a
	ld a, [CurDay]
	cp b
	jr c, .asm_140eb

.asm_140c8
	ld a, $4
	ld hl, $53da
	rst FarCall
	ld a, $5c
	ld hl, $4923
	rst FarCall
	ld a, $5
	call GetSRAMBank
	ld a, [$aa8c]
	inc a
	ld [$aa8c], a
	ld a, [$b2fa]
	inc a
	ld [$b2fa], a
	call CloseSRAM
	ret

.asm_140eb
	xor a
	ret
; 140ed



Function140ed: ; 140ed
	call GetClock
	call FixDays
	ld hl, hRTCSeconds
	ld de, StartSecond
	ld a, [$d089]
	sub [hl]
	dec hl
	jr nc, .asm_14102
	add $3c

.asm_14102
	ld [de], a
	dec de
	ld a, [$d088]
	sbc [hl]
	dec hl
	jr nc, .asm_1410d
	add $3c

.asm_1410d
	ld [de], a
	dec de
	ld a, [$d087]
	sbc [hl]
	dec hl
	jr nc, .asm_14118
	add $18

.asm_14118
	ld [de], a
	dec de
	ld a, [StringBuffer2]
	sbc [hl]
	dec hl
	jr nc, .asm_14128
	add $8c
	ld c, $7
	call SimpleDivide

.asm_14128
	ld [de], a
	ret
; 1412a

Function1412a: ; 1412a
	ld a, $1
	ld [rVBK], a
	call Get2bpp
	xor a
	ld [rVBK], a
	ret
; 14135

Function14135: ; 14135
	call GetPlayerSprite
	ld a, [UsedSprites]
	ld [$ffbd], a
	ld a, [$d155]
	ld [$ffbe], a
	call Function143c8
	ret
; 14146

INCBIN "baserom.gbc", $14146, $14168 - $14146


Function14168: ; 14168
	call Function1416f
	call Function14209
	ret
; 1416f

Function1416f: ; 1416f
	xor a
	ld bc, $0040
	ld hl, UsedSprites
	call ByteFill
	call GetPlayerSprite
	call AddMapSprites
	call Function142db
	ret
; 14183



GetPlayerSprite: ; 14183
; Get Chris or Kris's sprite.

	ld hl, .Chris
	ld a, [$d45b]
	bit 2, a
	jr nz, .go
	ld a, [PlayerGender]
	bit 0, a
	jr z, .go
	ld hl, .Kris

.go
	ld a, [PlayerState]
	ld c, a
.loop
	ld a, [hli]
	cp c
	jr z, .asm_141ac
	inc hl
	cp $ff
	jr nz, .loop

; Any player state not in the array defaults to Chris's sprite.
	xor a ; ld a, PLAYER_NORMAL
	ld [PlayerState], a
	ld a, SPRITE_CHRIS
	jr .asm_141ad

.asm_141ac
	ld a, [hl]

.asm_141ad
	ld [UsedSprites + 0], a
	ld [$d4d6], a
	ld [$d71f], a
	ret

.Chris
	db PLAYER_NORMAL, SPRITE_CHRIS
	db PLAYER_BIKE, SPRITE_CHRIS_BIKE
	db PLAYER_SURF, SPRITE_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Kris
	db PLAYER_NORMAL, SPRITE_KRIS
	db PLAYER_BIKE, SPRITE_KRIS_BIKE
	db PLAYER_SURF, SPRITE_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff
; 141c9


AddMapSprites: ; 141c9
	call GetMapPermission
	call CheckOutdoorMap
	jr z, .outdoor
	call AddIndoorSprites
	ret
.outdoor
	call AddOutdoorSprites
	ret
; 141d9


AddIndoorSprites: ; 141d9
	ld hl, MapObjects + 1 * OBJECT_LENGTH + 1 ; sprite
	ld a, 1
.loop
	push af
	ld a, [hl]
	call AddSpriteGFX
	ld de, OBJECT_LENGTH
	add hl, de
	pop af
	inc a
	cp NUM_OBJECTS
	jr nz, .loop
	ret
; 141ee


AddOutdoorSprites: ; 141ee
	ld a, [MapGroup]
	dec a
	ld c, a
	ld b, 0
	ld hl, OutdoorSprites
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld c, $17
.loop
	push bc
	ld a, [hli]
	call AddSpriteGFX
	pop bc
	dec c
	jr nz, .loop
	ret
; 14209


Function14209: ; 14209
	ld a, $4
	call Function263b
	call Function1439b
	call Function14215
	ret
; 14215

Function14215: ; 14215
	ld a, [$d13e]
	bit 6, a
	ret nz
	ld c, $8
	ld a, $5
	ld hl, $442f
	rst FarCall
	call GetMapPermission
	call CheckOutdoorMap
	ld c, $b
	jr z, .asm_1422f
	ld c, $a

.asm_1422f
	ld a, $5
	ld hl, $442f
	rst FarCall
	ret
; 14236



SafeGetSprite: ; 14236
	push hl
	call GetSprite
	pop hl
	ret
; 1423c

GetSprite: ; 1423c
	call GetMonSprite
	ret c

	ld hl, SpriteHeaders
	dec a
	ld c, a
	ld b, 0
	ld a, 6
	call AddNTimes
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	swap a
	ld c, a
	ld b, [hl]
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ret
; 14259


GetMonSprite: ; 14259
; Return carry if a monster sprite was loaded.

	cp SPRITE_POKEMON
	jr c, .Normal
	cp SPRITE_DAYCARE_MON_1
	jr z, .BreedMon1
	cp SPRITE_DAYCARE_MON_2
	jr z, .BreedMon2
	cp SPRITE_VARS
	jr nc, .Variable
	jr .Icon

.Normal
	and a
	ret

.Icon
	sub SPRITE_POKEMON
	ld e, a
	ld d, 0
	ld hl, SpriteMons
	add hl, de
	ld a, [hl]
	jr .Mon

.BreedMon1
	ld a, [BreedMon1Species]
	jr .Mon

.BreedMon2
	ld a, [BreedMon2Species]

.Mon
	ld e, a
	and a
	jr z, .asm_1429f

	ld a, $23
	ld hl, $682b
	rst FarCall ; callba LoadMonSprite

	ld l, 1
	ld h, 0
	scf
	ret

.Variable
	sub SPRITE_VARS
	ld e, a
	ld d, 0
	ld hl, VariableSprites
	add hl, de
	ld a, [hl]
	and a
	jp nz, GetMonSprite

.asm_1429f
	ld a, 1
	ld l, 1
	ld h, 0
	and a
	ret
; 142a7


Function142a7: ; 142a7
	cp SPRITE_POKEMON
	jr nc, .asm_142c2

	push hl
	push bc
	ld hl, SpriteHeaders + 4
	dec a
	ld c, a
	ld b, 0
	ld a, 6
	call AddNTimes
	ld a, [hl]
	pop bc
	pop hl
	cp 3
	jr nz, .asm_142c2
	scf
	ret

.asm_142c2
	and a
	ret
; 142c4


_GetSpritePalette: ; 142c4
	ld a, c
	call GetMonSprite
	jr c, .asm_142d8

	ld hl, SpriteHeaders + 5 ; palette
	dec a
	ld c, a
	ld b, 0
	ld a, 6
	call AddNTimes
	ld c, [hl]
	ret

.asm_142d8
	xor a
	ld c, a
	ret
; 142db


Function142db: ; 142db
	call LoadSpriteGFX
	call SortUsedSprites
	call ArrangeUsedSprites
	ret
; 142e5


AddSpriteGFX: ; 142e5
; Add any new sprite ids to a list of graphics to be loaded.
; Return carry if the list is full.

	push hl
	push bc
	ld b, a
	ld hl, UsedSprites + 2
	ld c, $1f
.loop
	ld a, [hl]
	cp b
	jr z, .exists
	and a
	jr z, .new
	inc hl
	inc hl
	dec c
	jr nz, .loop

	pop bc
	pop hl
	scf
	ret

.exists
	pop bc
	pop hl
	and a
	ret

.new
	ld [hl], b
	pop bc
	pop hl
	and a
	ret
; 14306


LoadSpriteGFX: ; 14306

	ld hl, UsedSprites
	ld b, $20
.loop
	ld a, [hli]
	and a
	jr z, .done
	push hl
	call .LoadSprite
	pop hl
	ld [hli], a
	dec b
	jr nz, .loop

.done
	ret

.LoadSprite
	call GetSprite
	ld a, l
	ret
; 1431e


SortUsedSprites: ; 1431e
; Bubble-sort sprites by type.

; Run backwards through UsedSprites to find the last one.

	ld c, $20
	ld de, UsedSprites + ($20 - 1) * 2
.FindLastSprite
	ld a, [de]
	and a
	jr nz, .FoundLastSprite
	dec de
	dec de
	dec c
	jr nz, .FindLastSprite
.FoundLastSprite
	dec c
	jr z, .quit

; If the length of the current sprite is
; higher than a later one, swap them.

	inc de
	ld hl, UsedSprites + 1

.CheckSprite
	push bc
	push de
	push hl

.CheckFollowing
	ld a, [de]
	cp [hl]
	jr nc, .next

; Swap the two sprites.

	ld b, a
	ld a, [hl]
	ld [hl], b
	ld [de], a
	dec de
	dec hl
	ld a, [de]
	ld b, a
	ld a, [hl]
	ld [hl], b
	ld [de], a
	inc de
	inc hl

; Keep doing this until everything's in order.

.next
	dec de
	dec de
	dec c
	jr nz, .CheckFollowing

	pop hl
	inc hl
	inc hl
	pop de
	pop bc
	dec c
	jr nz, .CheckSprite

.quit
	ret
; 14355


ArrangeUsedSprites: ; 14355
; Get the length of each sprite and space them out in VRAM.
; Crystal introduces a second table in VRAM bank 0.

	ld hl, UsedSprites
	ld c, $20
	ld b, 0
.FirstTableLength
; Keep going until the end of the list.
	ld a, [hli]
	and a
	jr z, .quit

	ld a, [hl]
	call GetSpriteLength

; Spill over into the second table after $80 tiles.
	add b
	cp $80
	jr z, .next
	jr nc, .SecondTable

.next
	ld [hl], b
	inc hl
	ld b, a

; Assumes the next table will be reached before c hits 0.
	dec c
	jr nz, .FirstTableLength

.SecondTable
; The second tile table starts at tile $80.
	ld b, $80
	dec hl
.SecondTableLength
; Keep going until the end of the list.
	ld a, [hli]
	and a
	jr z, .quit

	ld a, [hl]
	call GetSpriteLength

; There are only two tables, so don't go any further than that.
	add b
	jr c, .quit

	ld [hl], b
	ld b, a
	inc hl

	dec c
	jr nz, .SecondTableLength

.quit
	ret
; 14386


GetSpriteLength: ; 14386
; Return the length of sprite type a in tiles.

	cp WALKING_SPRITE
	jr z, .AnyDirection
	cp STANDING_SPRITE
	jr z, .AnyDirection
	cp STILL_SPRITE
	jr z, .OneDirection

	ld a, 12
	ret

.AnyDirection
	ld a, 12
	ret

.OneDirection
	ld a, 4
	ret
; 1439b


Function1439b: ; 1439b
	ld hl, UsedSprites
	ld c, $20
.asm_143a0
	ld a, [$d13e]
	res 5, a
	ld [$d13e], a
	ld a, [hli]
	and a
	jr z, .asm_143c7
	ld [$ffbd], a
	ld a, [hli]
	ld [$ffbe], a
	bit 7, a
	jr z, .asm_143bd
	ld a, [$d13e]
	set 5, a
	ld [$d13e], a

.asm_143bd
	push bc
	push hl
	call Function143c8
	pop hl
	pop bc
	dec c
	jr nz, .asm_143a0

.asm_143c7
	ret
; 143c8

Function143c8: ; 143c8
	ld a, [$ffbd]
	call SafeGetSprite
	ld a, [$ffbe]
	call Function14406
	push hl
	push de
	push bc
	ld a, [$d13e]
	bit 7, a
	jr nz, .asm_143df
	call Function14418

.asm_143df
	pop bc
	ld l, c
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	pop de
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld a, [$d13e]
	bit 5, a
	jr nz, .asm_14405
	bit 6, a
	jr nz, .asm_14405
	ld a, [$ffbd]
	call Function142a7
	jr c, .asm_14405
	ld a, h
	add $8
	ld h, a
	call Function14418

.asm_14405
	ret
; 14406

Function14406: ; 14406
	and $7f
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, l
	add $0
	ld l, a
	ld a, h
	adc $80
	ld h, a
	ret
; 14418

Function14418: ; 14418
	ld a, [rVBK]
	push af
	ld a, [$d13e]
	bit 5, a
	ld a, $1
	jr z, .asm_14426
	ld a, $0

.asm_14426
	ld [rVBK], a
	call Get2bpp
	pop af
	ld [rVBK], a
	ret
; 1442f

Function1442f: ; 1442f
	ld a, c
	ld bc, $0006
	ld hl, $444d
	call AddNTimes
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld c, [hl]
	swap c
	inc hl
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	and a
	ret z
	call Function1412a
	ret
; 1444d

INCBIN "baserom.gbc", $1444d, $14495 - $1444d


SpriteMons: ; 14495
	db UNOWN
	db GEODUDE
	db GROWLITHE
	db WEEDLE
	db SHELLDER
	db ODDISH
	db GENGAR
	db ZUBAT
	db MAGIKARP
	db SQUIRTLE
	db TOGEPI
	db BUTTERFREE
	db DIGLETT
	db POLIWAG
	db PIKACHU
	db CLEFAIRY
	db CHARMANDER
	db JYNX
	db STARMIE
	db BULBASAUR
	db JIGGLYPUFF
	db GRIMER
	db EKANS
	db PARAS
	db TENTACOOL
	db TAUROS
	db MACHOP
	db VOLTORB
	db LAPRAS
	db RHYDON
	db MOLTRES
	db SNORLAX
	db GYARADOS
	db LUGIA
	db HO_OH
; 144b8
	

OutdoorSprites: ; 144b8
; Valid sprite IDs for each map group.

	dw Group1Sprites
	dw Group2Sprites
	dw Group3Sprites
	dw Group4Sprites
	dw Group5Sprites
	dw Group6Sprites
	dw Group7Sprites
	dw Group8Sprites
	dw Group9Sprites
	dw Group10Sprites
	dw Group11Sprites
	dw Group12Sprites
	dw Group13Sprites
	dw Group14Sprites
	dw Group15Sprites
	dw Group16Sprites
	dw Group17Sprites
	dw Group18Sprites
	dw Group19Sprites
	dw Group20Sprites
	dw Group21Sprites
	dw Group22Sprites
	dw Group23Sprites
	dw Group24Sprites
	dw Group25Sprites
	dw Group26Sprites
; 144ec


Group13Sprites: ; 144ec
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_BLUE
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_SWIMMER_GIRL
	db SPRITE_SWIMMER_GUY
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
; 14503

Group23Sprites: ; 14503
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_BLUE
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_SWIMMER_GIRL
	db SPRITE_SWIMMER_GUY
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
; 1451a

Group14Sprites: ; 1451a
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_BLUE
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_SWIMMER_GIRL
	db SPRITE_SWIMMER_GUY
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
; 14531

Group6Sprites: ; 14531
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_BLUE
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_SWIMMER_GIRL
	db SPRITE_SWIMMER_GUY
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
; 14548

Group7Sprites: ; 14548
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_COOLTRAINER_M
	db SPRITE_SUPER_NERD
	db SPRITE_COOLTRAINER_F
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_POKEFAN_M
	db SPRITE_ROCKET
	db SPRITE_MISTY
	db SPRITE_POKE_BALL
	db SPRITE_SLOWPOKE
; 1455f

Group25Sprites: ; 1455f
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_COOLTRAINER_M
	db SPRITE_SUPER_NERD
	db SPRITE_COOLTRAINER_F
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_POKEFAN_M
	db SPRITE_ROCKET
	db SPRITE_MISTY
	db SPRITE_POKE_BALL
	db SPRITE_SLOWPOKE
; 14576

Group21Sprites: ; 14576
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_FISHER
	db SPRITE_POLIWAG
	db SPRITE_TEACHER
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_BIKER
	db SPRITE_SILVER
	db SPRITE_BLUE
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
; 1458d

Group18Sprites: ; 1458d
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_POKEFAN_M
	db SPRITE_MACHOP
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_FISHER
	db SPRITE_TEACHER
	db SPRITE_SUPER_NERD
	db SPRITE_BIG_SNORLAX
	db SPRITE_BIKER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
; 145a4

Group12Sprites: ; 145a4
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_POKEFAN_M
	db SPRITE_MACHOP
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_FISHER
	db SPRITE_TEACHER
	db SPRITE_SUPER_NERD
	db SPRITE_BIG_SNORLAX
	db SPRITE_BIKER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
; 145bb

Group17Sprites: ; 145bb
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_POKEFAN_M
	db SPRITE_MACHOP
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_FISHER
	db SPRITE_TEACHER
	db SPRITE_SUPER_NERD
	db SPRITE_BIG_SNORLAX
	db SPRITE_BIKER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
; 145d2

Group16Sprites: ; 145d2
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_POKEFAN_M
	db SPRITE_BUENA
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_FISHER
	db SPRITE_TEACHER
	db SPRITE_SUPER_NERD
	db SPRITE_MACHOP
	db SPRITE_BIKER
	db SPRITE_POKE_BALL
	db SPRITE_BOULDER
; 145e9

Group24Sprites: ; 145e9
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_SILVER
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_MONSTER
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
; 14600

Group26Sprites: ; 14600
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_SILVER
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_MONSTER
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
; 14617

Group19Sprites: ; 14617
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_SILVER
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_MONSTER
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
; 1462e

Group10Sprites: ; 1462e
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_FISHER
	db SPRITE_LASS
	db SPRITE_OFFICER
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_COOLTRAINER_M
	db SPRITE_BUG_CATCHER
	db SPRITE_SUPER_NERD
	db SPRITE_WEIRD_TREE
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
; 14645

Group4Sprites: ; 14645
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_FISHER
	db SPRITE_LASS
	db SPRITE_OFFICER
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_COOLTRAINER_M
	db SPRITE_BUG_CATCHER
	db SPRITE_SUPER_NERD
	db SPRITE_WEIRD_TREE
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
; 1465c

Group8Sprites: ; 1465c
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_KURT_OUTSIDE
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_OFFICER
	db SPRITE_POKEFAN_M
	db SPRITE_BLACK_BELT
	db SPRITE_TEACHER
	db SPRITE_AZALEA_ROCKET
	db SPRITE_LASS
	db SPRITE_SILVER
	db SPRITE_FRUIT_TREE
	db SPRITE_SLOWPOKE
; 14673

Group11Sprites: ; 14673
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_POKE_BALL
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_OFFICER
	db SPRITE_POKEFAN_M
	db SPRITE_DAYCARE_MON_1
	db SPRITE_COOLTRAINER_F
	db SPRITE_ROCKET
	db SPRITE_LASS
	db SPRITE_DAYCARE_MON_2
	db SPRITE_FRUIT_TREE
	db SPRITE_SLOWPOKE
; 1468a

Group22Sprites: ; 1468a
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_STANDING_YOUNGSTER
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_OLIVINE_RIVAL
	db SPRITE_POKEFAN_M
	db SPRITE_LASS
	db SPRITE_BUENA
	db SPRITE_SWIMMER_GIRL
	db SPRITE_SAILOR
	db SPRITE_POKEFAN_F
	db SPRITE_SUPER_NERD
	db SPRITE_TAUROS
	db SPRITE_FRUIT_TREE
	db SPRITE_ROCK
; 146a1

Group1Sprites: ; 146a1
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_STANDING_YOUNGSTER
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_OLIVINE_RIVAL
	db SPRITE_POKEFAN_M
	db SPRITE_LASS
	db SPRITE_BUENA
	db SPRITE_SWIMMER_GIRL
	db SPRITE_SAILOR
	db SPRITE_POKEFAN_F
	db SPRITE_SUPER_NERD
	db SPRITE_TAUROS
	db SPRITE_FRUIT_TREE
	db SPRITE_ROCK
; 146b8

Group9Sprites: ; 146b8
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_LANCE
	db SPRITE_GRAMPS
	db SPRITE_SUPER_NERD
	db SPRITE_COOLTRAINER_F
	db SPRITE_FISHER
	db SPRITE_COOLTRAINER_M
	db SPRITE_LASS
	db SPRITE_YOUNGSTER
	db SPRITE_GYARADOS
	db SPRITE_FRUIT_TREE
	db SPRITE_POKE_BALL
; 146cf

Group2Sprites: ; 146cf
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_SUPER_NERD
	db SPRITE_COOLTRAINER_M
	db SPRITE_POKEFAN_M
	db SPRITE_BLACK_BELT
	db SPRITE_COOLTRAINER_F
	db SPRITE_FISHER
	db SPRITE_FRUIT_TREE
	db SPRITE_POKE_BALL
; 146e6

Group5Sprites: ; 146e6
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_SUPER_NERD
	db SPRITE_COOLTRAINER_M
	db SPRITE_POKEFAN_M
	db SPRITE_BLACK_BELT
	db SPRITE_COOLTRAINER_F
	db SPRITE_FISHER
	db SPRITE_FRUIT_TREE
	db SPRITE_POKE_BALL
; 146fd

Group3Sprites: ; 146fd
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_GAMEBOY_KID
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_LASS
	db SPRITE_POKEFAN_F
	db SPRITE_TEACHER
	db SPRITE_YOUNGSTER
	db SPRITE_GROWLITHE
	db SPRITE_POKEFAN_M
	db SPRITE_ROCKER
	db SPRITE_FISHER
	db SPRITE_SCIENTIST
	db SPRITE_POKE_BALL
	db SPRITE_BOULDER
; 14714

Group15Sprites: ; 14714
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_SAILOR
	db SPRITE_FISHING_GURU
	db SPRITE_GENTLEMAN
	db SPRITE_SUPER_NERD
	db SPRITE_HO_OH
	db SPRITE_TEACHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_YOUNGSTER
	db SPRITE_FAIRY
	db SPRITE_POKE_BALL
	db SPRITE_ROCK
; 1472b

Group20Sprites: ; 1472b
	db SPRITE_OAK
	db SPRITE_FISHER
	db SPRITE_TEACHER
	db SPRITE_TWIN
	db SPRITE_POKEFAN_M
	db SPRITE_GRAMPS
	db SPRITE_FAIRY
	db SPRITE_SILVER
	db SPRITE_FISHING_GURU
	db SPRITE_POKE_BALL
	db SPRITE_POKEDEX
; 14736


SpriteHeaders: ; 14736
INCLUDE "gfx/overworld/sprite_headers.asm"
; 1499a


Function1499a: ; 1499a
	ld a, [StandingTile]
	cp $60
	jr z, .asm_149ad
	cp $68
	jr z, .asm_149ad
	and $f0
	cp $70
	jr z, .asm_149ad
	and a
	ret

.asm_149ad
	scf
	ret
; 149af

Function149af: ; 149af
	ld a, [StandingTile]
	cp $70
	jr z, .asm_149c4
	cp $76
	jr z, .asm_149c4
	cp $78
	jr z, .asm_149c4
	cp $7e
	jr z, .asm_149c4
	scf
	ret

.asm_149c4
	xor a
	ret
; 149c6

INCBIN "baserom.gbc", $149c6, $149dd - $149c6

Function149dd: ; 149dd
	ld a, [StandingTile]
	ld hl, $49ea
	ld de, $0001
	call IsInArray
	ret
; 149ea

INCBIN "baserom.gbc", $149ea, $149f5 - $149ea

Function149f5: ; 149f5
	ld a, c
	ld hl, $4a00
	ld de, $0001
	call IsInArray
	ret
; 14a00

INCBIN "baserom.gbc", $14a00, $14a07 - $14a00


Function14a07: ; 14a07
	ld a, [StandingTile]
	ld de, $001f
	cp $71
	ret z
	ld de, $0013
	cp $7c
	ret z
	ld de, $0023
	ret
; 14a1a

INCBIN "baserom.gbc", $14a1a, $14b5f - $14a1a


Function14b5f: ; 14b5f
	ld a, $1
	call GetSRAMBank
	ld hl, $bdd9
	ld de, $be3b
	ld bc, $0b1a
.asm_14b6d
	ld a, [hld]
	ld [de], a
	dec de
	dec bc
	ld a, c
	or b
	jr nz, .asm_14b6d
	ld hl, OverworldMap
	ld de, $b2c0
	ld bc, $0062
	call CopyBytes
	call CloseSRAM
	ret
; 14b85

Function14b85: ; 14b85
	call Function14c10
	ret
; 14b89

INCBIN "baserom.gbc", $14b89, $14c10 - $14b89


Function14c10: ; 14c10
	ld a, $1
	ld [$cfcd], a
	ld a, $5
	ld hl, $4056
	rst FarCall
	ld a, $41
	ld hl, $50d9
	rst FarCall
	call Function14da9
	call Function14dbb
	call Function14dd7
	call Function14df7
	call Function14e0c
	call Function14e13
	call Function14e2d
	call Function14e40
	call Function14e55
	call Function14e76
	call Function14e8b
	call Function14c6b
	ld a, $11
	ld hl, $4725
	rst FarCall
	ld a, $41
	ld hl, $6187
	rst FarCall
	ld a, $5
	ld hl, $406a
	rst FarCall
	ld a, $1
	call GetSRAMBank
	ld a, [$be45]
	cp $4
	jr nz, .asm_14c67
	xor a
	ld [$be45], a

.asm_14c67
	call CloseSRAM
	ret
; 14c6b

Function14c6b: ; 14c6b
	call Function14c90
	ld a, $0
	call GetSRAMBank
	ld a, [$bf10]
	ld e, a
	ld a, [$bf11]
	ld d, a
	or e
	jr z, .asm_14c84
	ld a, e
	sub l
	ld a, d
	sbc h
	jr c, .asm_14c8c

.asm_14c84
	ld a, l
	ld [$bf10], a
	ld a, h
	ld [$bf11], a

.asm_14c8c
	call CloseSRAM
	ret
; 14c90

Function14c90: ; 14c90
	ld hl, $c000
.asm_14c93
	ld a, [hl]
	or a
	ret nz
	inc hl
	jr .asm_14c93
; 14c99

INCBIN "baserom.gbc", $14c99, $14cbb - $14c99


Function14cbb: ; 14cbb
	call Function151fb
	call Function14d06
	call Function14ce2
	call Function14cf4
	call Function14d68
	call Function14d5c
	ld a, $0
	call GetSRAMBank
	xor a
	ld [$bf10], a
	ld [$bf11], a
	call CloseSRAM
	ld a, $1
	ld [$d4b4], a
	ret
; 14ce2

Function14ce2: ; 14ce2
	ld a, $1
	call GetSRAMBank
	ld hl, $b260
	ld bc, $0060
	xor a
	call ByteFill
	jp CloseSRAM
; 14cf4

Function14cf4: ; 14cf4
	ld a, $0
	call GetSRAMBank
	ld hl, $abe4
	ld bc, $004c
	xor a
	call ByteFill
	jp CloseSRAM
; 14d06

Function14d06: ; 14d06
	ld a, $1
	call GetSRAMBank
	ld hl, $b2c0
	ld bc, $0b7c
	xor a
	call ByteFill
	jp CloseSRAM
; 14d18

INCBIN "baserom.gbc", $14d18, $14d5c - $14d18


Function14d5c: ; 14d5c
	ld a, $1
	call GetSRAMBank
	xor a
	ld [$be45], a
	jp CloseSRAM
; 14d68

Function14d68: ; 14d68
	call Function1509a
	ret
; 14d6c

INCBIN "baserom.gbc", $14d6c, $14da0 - $14d6c


Function14da0: ; 14da0
	ld a, [$d4b4]
	and a
	ret nz
	call Function14cbb
	ret
; 14da9

Function14da9: ; 14da9
	ld a, $1
	call GetSRAMBank
	ld a, $63
	ld [$a008], a
	ld a, $7f
	ld [$ad0f], a
	jp CloseSRAM
; 14dbb

Function14dbb: ; 14dbb
	ld a, $1
	call GetSRAMBank
	ld hl, Options
	ld de, $a000
	ld bc, $0008
	call CopyBytes
	ld a, [Options]
	and $ef
	ld [$a000], a
	jp CloseSRAM
; 14dd7

Function14dd7: ; 14dd7
	ld a, $1
	call GetSRAMBank
	ld hl, PlayerID
	ld de, $a009
	ld bc, $082a
	call CopyBytes
	ld hl, FlypointPerms
	ld de, $a833
	ld bc, $0032
	call CopyBytes
	jp CloseSRAM
; 14df7

Function14df7: ; 14df7
	ld a, $1
	call GetSRAMBank
	ld hl, PartyCount
	ld de, $a865
	ld bc, $031e
	call CopyBytes
	call CloseSRAM
	ret
; 14e0c

Function14e0c: ; 14e0c
	call Function150d8
	call Function150f9
	ret
; 14e13

Function14e13: ; 14e13
	ld hl, $a009
	ld bc, $0b7a
	ld a, $1
	call GetSRAMBank
	call Function15273
	ld a, e
	ld [$ad0d], a
	ld a, d
	ld [$ad0e], a
	call CloseSRAM
	ret
; 14e2d

Function14e2d: ; 14e2d
	ld a, $0
	call GetSRAMBank
	ld a, $63
	ld [$b208], a
	ld a, $7f
	ld [$bf0f], a
	call CloseSRAM
	ret
; 14e40

Function14e40: ; 14e40
	ld a, $0
	call GetSRAMBank
	ld hl, Options
	ld de, $b200
	ld bc, $0008
	call CopyBytes
	call CloseSRAM
	ret
; 14e55

Function14e55: ; 14e55
	ld a, $0
	call GetSRAMBank
	ld hl, PlayerID
	ld de, $b209
	ld bc, $082a
	call CopyBytes
	ld hl, FlypointPerms
	ld de, $ba33
	ld bc, $0032
	call CopyBytes
	call CloseSRAM
	ret
; 14e76

Function14e76: ; 14e76
	ld a, $0
	call GetSRAMBank
	ld hl, PartyCount
	ld de, $ba65
	ld bc, $031e
	call CopyBytes
	call CloseSRAM
	ret
; 14e8b

Function14e8b: ; 14e8b
	ld hl, $b209
	ld bc, $0b7a
	ld a, $0
	call GetSRAMBank
	call Function15273
	ld a, e
	ld [$bf0d], a
	ld a, d
	ld [$bf0e], a
	call CloseSRAM
	ret
; 14ea5

INCBIN "baserom.gbc", $14ea5, $14f1c - $14ea5


Function14f1c: ; 14f1c
	xor a
	ld [$cfcd], a
	call Function14f84
	ld a, [$cfcd]
	and a
	jr z, .asm_14f46
	ld a, $1
	call GetSRAMBank
	ld hl, $a044
	ld de, StartDay
	ld bc, $0008
	call CopyBytes
	ld hl, $a3da
	ld de, StatusFlags
	ld a, [hl]
	ld [de], a
	call CloseSRAM
	ret

.asm_14f46
	call Function14faf
	ld a, [$cfcd]
	and a
	jr z, .asm_14f6c
	ld a, $0
	call GetSRAMBank
	ld hl, $b244
	ld de, StartDay
	ld bc, $0008
	call CopyBytes
	ld hl, $b5da
	ld de, StatusFlags
	ld a, [hl]
	ld [de], a
	call CloseSRAM
	ret

.asm_14f6c
	ld hl, $4f7c
	ld de, Options
	ld bc, $0008
	call CopyBytes
	call Function67e
	ret
; 14f7c

INCBIN "baserom.gbc", $14f7c, $14f84 - $14f7c


Function14f84: ; 14f84
	ld a, $1
	call GetSRAMBank
	ld a, [$a008]
	cp $63
	jr nz, .asm_14fab
	ld a, [$ad0f]
	cp $7f
	jr nz, .asm_14fab
	ld hl, $a000
	ld de, Options
	ld bc, $0008
	call CopyBytes
	call CloseSRAM
	ld a, $1
	ld [$cfcd], a

.asm_14fab
	call CloseSRAM
	ret
; 14faf

Function14faf: ; 14faf
	ld a, $0
	call GetSRAMBank
	ld a, [$b208]
	cp $63
	jr nz, .asm_14fd3
	ld a, [$bf0f]
	cp $7f
	jr nz, .asm_14fd3
	ld hl, $b200
	ld de, Options
	ld bc, $0008
	call CopyBytes
	ld a, $2
	ld [$cfcd], a

.asm_14fd3
	call CloseSRAM
	ret
; 14fd7

INCBIN "baserom.gbc", $14fd7, $1500c - $14fd7

Function1500c: ; 1500c
	ld a, $1
	call GetSRAMBank
	ld hl, $a865
	ld de, PartyCount
	ld bc, $031e
	call CopyBytes
	call CloseSRAM
	ret
; 15021

INCBIN "baserom.gbc", $15021, $1509a - $15021


Function1509a: ; 1509a
	ld a, $1
	call GetSRAMBank
	ld hl, PlayerGender
	ld de, $be3d
	ld bc, $0007
	call CopyBytes
	ld hl, $d479
	ld a, [hli]
	ld [$a60e], a
	ld a, [hli]
	ld [$a60f], a
	jp CloseSRAM
; 150b9

INCBIN "baserom.gbc", $150b9, $150d8 - $150b9


Function150d8: ; 150d8
	ld a, [$db72]
	cp $e
	jr c, .asm_150e3
	xor a
	ld [$db72], a

.asm_150e3
	ld e, a
	ld d, $0
	ld hl, $522d
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	push af
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	ret
; 150f9

Function150f9: ; 150f9
	push hl
	push af
	push de
	ld a, $1
	call GetSRAMBank
	ld hl, $ad10
	ld de, EnemyMoveAnimation
	ld bc, $01e0
	call CopyBytes
	call CloseSRAM
	pop de
	pop af
	push af
	push de
	call GetSRAMBank
	ld hl, EnemyMoveAnimation
	ld bc, $01e0
	call CopyBytes
	call CloseSRAM
	ld a, $1
	call GetSRAMBank
	ld hl, $aef0
	ld de, EnemyMoveAnimation
	ld bc, $01e0
	call CopyBytes
	call CloseSRAM
	pop de
	pop af
	ld hl, $01e0
	add hl, de
	ld e, l
	ld d, h
	push af
	push de
	call GetSRAMBank
	ld hl, EnemyMoveAnimation
	ld bc, $01e0
	call CopyBytes
	call CloseSRAM
	ld a, $1
	call GetSRAMBank
	ld hl, $b0d0
	ld de, EnemyMoveAnimation
	ld bc, $008e
	call CopyBytes
	call CloseSRAM
	pop de
	pop af
	ld hl, $01e0
	add hl, de
	ld e, l
	ld d, h
	call GetSRAMBank
	ld hl, EnemyMoveAnimation
	ld bc, $008e
	call CopyBytes
	call CloseSRAM
	pop hl
	ret
; 1517d

INCBIN "baserom.gbc", $1517d, $151fb - $1517d


Function151fb: ; 151fb
	ld hl, $522d
	ld c, $e
.asm_15200
	push bc
	ld a, [hli]
	call GetSRAMBank
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	xor a
	ld [de], a
	inc de
	ld a, $ff
	ld [de], a
	inc de
	ld bc, $044c
.asm_15213
	xor a
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .asm_15213
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, $ff
	ld [de], a
	inc de
	xor a
	ld [de], a
	call CloseSRAM
	pop bc
	dec c
	jr nz, .asm_15200
	ret
; 1522d

INCBIN "baserom.gbc", $1522d, $15273 - $1522d


Function15273: ; 15273
	ld de, $0000
.asm_15276
	ld a, [hli]
	add e
	ld e, a
	ld a, $0
	adc d
	ld d, a
	dec bc
	ld a, b
	or c
	jr nz, .asm_15276
	ret
; 15283

INCBIN "baserom.gbc", $15283, $152ab - $15283


BlackoutPoints: ; 0x152ab
	db GROUP_KRISS_HOUSE_2F, MAP_KRISS_HOUSE_2F, 3, 3
	db GROUP_VIRIDIAN_POKECENTER_1F, MAP_VIRIDIAN_POKECENTER_1F, 5, 3 ; unused
	db GROUP_PALLET_TOWN, MAP_PALLET_TOWN, 5, 6
	db GROUP_VIRIDIAN_CITY, MAP_VIRIDIAN_CITY, 23, 26
	db GROUP_PEWTER_CITY, MAP_PEWTER_CITY, 13, 26
	db GROUP_CERULEAN_CITY, MAP_CERULEAN_CITY, 19, 22
	db GROUP_ROUTE_10A, MAP_ROUTE_10A, 11, 2
	db GROUP_VERMILION_CITY, MAP_VERMILION_CITY, 9, 6
	db GROUP_LAVENDER_TOWN, MAP_LAVENDER_TOWN, 5, 6
	db GROUP_SAFFRON_CITY, MAP_SAFFRON_CITY, 9, 30
	db GROUP_CELADON_CITY, MAP_CELADON_CITY, 29, 10
	db GROUP_FUCHSIA_CITY, MAP_FUCHSIA_CITY, 19, 28
	db GROUP_CINNABAR_ISLAND, MAP_CINNABAR_ISLAND, 11, 12
	db GROUP_ROUTE_23, MAP_ROUTE_23, 9, 6
	db GROUP_NEW_BARK_TOWN, MAP_NEW_BARK_TOWN, 13, 6
	db GROUP_CHERRYGROVE_CITY, MAP_CHERRYGROVE_CITY, 29, 4
	db GROUP_VIOLET_CITY, MAP_VIOLET_CITY, 31, 26
	db GROUP_ROUTE_32, MAP_ROUTE_32, 11, 74
	db GROUP_AZALEA_TOWN, MAP_AZALEA_TOWN, 15, 10
	db GROUP_CIANWOOD_CITY, MAP_CIANWOOD_CITY, 23, 44
	db GROUP_GOLDENROD_CITY, MAP_GOLDENROD_CITY, 15, 28
	db GROUP_OLIVINE_CITY, MAP_OLIVINE_CITY, 13, 22
	db GROUP_ECRUTEAK_CITY, MAP_ECRUTEAK_CITY, 23, 28
	db GROUP_MAHOGANY_TOWN, MAP_MAHOGANY_TOWN, 15, 14
	db GROUP_LAKE_OF_RAGE, MAP_LAKE_OF_RAGE, 21, 29
	db GROUP_BLACKTHORN_CITY, MAP_BLACKTHORN_CITY, 21, 30
	db GROUP_SILVER_CAVE_OUTSIDE, MAP_SILVER_CAVE_OUTSIDE, 23, 20
	db GROUP_FAST_SHIP_CABINS_SW_SSW_NW, MAP_FAST_SHIP_CABINS_SW_SSW_NW, 6, 2
	db $ff, $ff, $ff, $ff

INCBIN "baserom.gbc", $1531f, $15344 - $1531f

Function15344: ; 15344
	ld hl, BlackoutPoints
	ld c, $0
.asm_15349
	ld a, [hl]
	cp $ff
	jr z, .asm_1535f
	cp d
	jr nz, .asm_15356
	inc hl
	ld a, [hld]
	cp e
	jr z, .asm_15361

.asm_15356
	push bc
	ld bc, $0004
	add hl, bc
	pop bc
	inc c
	jr .asm_15349

.asm_1535f
	and a
	ret

.asm_15361
	scf
	ret
; 15363


Function15363: ; 15363
	ld a, [$ff9f]
	and $f
	dec a
	ld c, a
	ld b, $0
	ld hl, $5377
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Function1541d
	ret
; 15377

INCBIN "baserom.gbc", $15377, $1541d - $15377


Function1541d: ; 1541d
.asm_1541d
	ld a, [hli]
	cp $ff
	ret z
	push hl
	ld c, a
	ld b, $0
	ld hl, $5440
	add hl, bc
	add hl, bc
	add hl, bc
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	bit 7, b
	jr z, .asm_15439
	pop de
	ld a, [de]
	ld c, a
	inc de
	push de

.asm_15439
	ld a, b
	and $7f
	rst FarCall
	pop hl
	jr .asm_1541d
; 15440

INCBIN "baserom.gbc", $15440, $15736 - $15440

KrissPCMenuData: ; 0x15736
	db %01000000
	db  0,  0 ; top left corner coords (y, x)
	db 12, 15 ; bottom right corner coords (y, x)
	dw .KrissPCMenuData2
	db 1 ; default selected option

.KrissPCMenuData2
	db %10100000 ; bit7
	db 0 ; # items?
	dw .KrissPCMenuList1
	db $8d
	db $1f
	dw .KrissPCMenuPointers

.KrissPCMenuPointers ; 0x15746
	dw KrisWithdrawItemMenu, .WithdrawItem
	dw KrisDepositItemMenu,  .DepositItem
	dw KrisTossItemMenu,     .TossItem
	dw KrisMailBoxMenu,      .MailBox
	dw KrisDecorationMenu,   .Decoration
	dw KrisLogOffMenu,       .LogOff
	dw KrisLogOffMenu,       .TurnOff

.WithdrawItem db "WITHDRAW ITEM@"
.DepositItem  db "DEPOSIT ITEM@"
.TossItem     db "TOSS ITEM@"
.MailBox      db "MAIL BOX@"
.Decoration   db "DECORATION@"
.TurnOff      db "TURN OFF@"
.LogOff       db "LOG OFF@"

WITHDRAW_ITEM EQU 0
DEPOSIT_ITEM  EQU 1
TOSS_ITEM     EQU 2
MAIL_BOX      EQU 3
DECORATION    EQU 4
TURN_OFF      EQU 5
LOG_OFF       EQU 6

.KrissPCMenuList1
	db 5
	db WITHDRAW_ITEM
	db DEPOSIT_ITEM
	db TOSS_ITEM
	db MAIL_BOX
	db TURN_OFF
	db $ff

.KrissPCMenuList2
	db 6
	db WITHDRAW_ITEM
	db DEPOSIT_ITEM
	db TOSS_ITEM
	db MAIL_BOX
	db DECORATION
	db LOG_OFF
	db $ff

INCBIN "baserom.gbc", $157bb, $157d1 - $157bb

KrisWithdrawItemMenu: ; 0x157d1
	call Function1d6e
	ld a, BANK(ClearPCItemScreen)
	ld hl, ClearPCItemScreen
	rst $8
.asm_157da
	call Function15985
	jr c, .asm_157e4
	call Function157e9
	jr .asm_157da

.asm_157e4
	call Function2b3c
	xor a
	ret
; 0x157e9

Function157e9: ; 0x157e9
	; check if the item has a quantity
	ld a, BANK(_CheckTossableItem)
	ld hl, _CheckTossableItem
	rst $8
	ld a, [$d142]
	and a
	jr z, .askquantity

	; items without quantity are always ×1
	ld a, 1
	ld [$d10c], a
	jr .withdraw

.askquantity
	ld hl, .HowManyText
	call Function1d4f
	callba Function24fbf
	call Function1c07
	call Function1c07
	jr c, .done

.withdraw
	ld a, [$d10c]
	ld [Buffer1], a ; quantity
	ld a, [$d107]
	ld [Buffer2], a
	ld hl, NumItems
	call Function2f66
	jr nc, .PackFull
	ld a, [Buffer1]
	ld [$d10c], a
	ld a, [Buffer2]
	ld [$d107], a
	ld hl, PCItems
	call Function2f53
	ld a, $3b
	call Predef
	ld hl, .WithdrewText
	call Function1d4f
	xor a
	ld [hBGMapMode], a
	call Function1c07
	ret

.PackFull
	ld hl, .NoRoomText
	call Function1d67
	ret

.done
	ret
; 0x15850

.HowManyText ; 0x15850
	TX_FAR _KrissPCHowManyWithdrawText
	db "@"

.WithdrewText ; 0x15855
	TX_FAR _KrissPCWithdrewItemsText
	db "@"

.NoRoomText ; 0x1585a
	TX_FAR _KrissPCNoRoomWithdrawText
	db "@"


KrisTossItemMenu: ; 0x1585f
	call Function1d6e
	ld a, BANK(ClearPCItemScreen)
	ld hl, ClearPCItemScreen
	rst $8
.asm_15868
	call Function15985
	jr c, .asm_15878
	ld de, PCItems
	ld a, $4
	ld hl, $69f4
	rst $8
	jr .asm_15868

.asm_15878
	call Function2b3c
	xor a
	ret
; 0x1587d


KrisDecorationMenu: ; 0x1587d
	ld a, BANK(_KrisDecorationMenu)
	ld hl, _KrisDecorationMenu
	rst $8
	ld a, c
	and a
	ret z
	scf
	ret
; 0x15888


KrisLogOffMenu: ; 0x15888
	xor a
	scf
	ret
; 0x1588b


KrisDepositItemMenu: ; 0x1588b
	call Function158b8
	jr c, .asm_158b6
	call Function2ed3
	call Function1d6e
	callba Function106a5
.asm_1589c
	callba Function106be
	ld a, [$cf66]
	and a
	jr z, .asm_158b3
	call Function158cc
	callba CheckRegisteredItem
	jr .asm_1589c

.asm_158b3
	call Function2b3c

.asm_158b6
	xor a
	ret
; 0x158b8

Function158b8: ; 0x158b8
	ld a, $4
	ld hl, $69d5
	rst $8
	ret nc
	ld hl, Text158c7
	call Function1d67
	scf
	ret
; 0x158c7

Text158c7: ; 0x15c87
	TX_FAR UnknownText_0x1c13df
	db "@"


Function158cc: ; 0x158cc
	ld a, [$c2ce]
	push af
	ld a, $0
	ld [$c2ce], a
	callba CheckItemMenu
	ld a, [$d142]
	ld hl, JumpTable158e7
	rst JumpTable
	pop af
	ld [$c2ce], a
	ret
; 0x158e7

JumpTable158e7: ; 0x158e7
	dw .jump2
	dw .jump1
	dw .jump1
	dw .jump1
	dw .jump2
	dw .jump2
	dw .jump2

.jump1:
	ret
.jump2:
	ld a, [Buffer1]
	push af
	ld a, [Buffer2]
	push af
	call Function1590a
	pop af
	ld [Buffer2], a
	pop af
	ld [Buffer1], a
	ret
; 0x1590a

Function1590a: ; 0x1590a
	callba _CheckTossableItem
	ld a, [$d142]
	and a
	jr z, .asm_1591d
	ld a, $1
	ld [$d10c], a
	jr .asm_15933

.asm_1591d
	ld hl, .HowManyText
	call Function1d4f
	callba Function24fbf
	push af
	call Function1c07
	call Function1c07
	pop af
	jr c, .asm_1596c

.asm_15933
	ld a, [$d10c]
	ld [Buffer1], a
	ld a, [$d107]
	ld [Buffer2], a
	ld hl, PCItems
	call Function2f66
	jr nc, .asm_15965
	ld a, [Buffer1]
	ld [$d10c], a
	ld a, [Buffer2]
	ld [$d107], a
	ld hl, NumItems
	call Function2f53
	ld a, $3b
	call Predef
	ld hl, .DepositText
	call PrintText
	ret

.asm_15965
	ld hl, .NoRoomText
	call PrintText
	ret

.asm_1596c
	and a
	ret
; 0x1596e


.HowManyText ; 0x1596e
	TX_FAR _KrissPCHowManyDepositText
	db "@"

.DepositText ; 0x15973
	TX_FAR _KrissPCDepositItemsText
	db "@"

.NoRoomText ; 0x15978
	TX_FAR _KrissPCNoRoomDepositText
	db "@"


KrisMailBoxMenu: ; 0x1597d
	callba _KrisMailBoxMenu
	xor a
	ret
; 0x15985


Function15985: ; 0x15985
	xor a
	ld [$d0e3], a
	ld a, [$c2ce]
	push af
	ld a, $0
	ld [$c2ce], a
	ld hl, MenuData15a08
	call Function1d3c
	hlcoord 0, 0
	ld b, $a
	ld c, $12
	call TextBox
	ld a, [$d0d7]
	ld [$cf88], a
	ld a, [$d0dd]
	ld [$d0e4], a
	call Function350c
	ld a, [$d0e4]
	ld [$d0dd], a
	ld a, [$cfa9]
	ld [$d0d7], a
	pop af
	ld [$c2ce], a
	ld a, [$d0e3]
	and a
	jr nz, .asm_159d8
	ld a, [$cf73]
	cp $2
	jr z, .asm_15a06
	cp $1
	jr z, .asm_159fb
	cp $4
	jr z, .asm_159f2
	jr .asm_159f8

.asm_159d8
	ld a, [$cf73]
	cp $2
	jr z, .asm_159e9
	cp $1
	jr z, .asm_159ef
	cp $4
	jr z, .asm_159ef
	jr .asm_159f8

.asm_159e9
	xor a
	ld [$d0e3], a
	jr .asm_159f8

.asm_159ef
	call $56c7

.asm_159f2
	ld a, $9
	ld hl, $490c
	rst $8

.asm_159f8
	jp $5989

.asm_159fb
	ld a, $9
	ld hl, $4706
	rst $8
	call Function1bee
	and a
	ret

.asm_15a06
	scf
	ret
; 0x15a08

MenuData15a08: ; 0x15a08
	db %01000000
	db 1, 4 ; top left corner coords (y, x)
	db $a, $12 ; bottorm right corner coords (y, x)
	dw .MenuData2
	db 1 ; default selected option

.MenuData2
	db %10110000
	db 4, 8 ; rows/cols?
	db 2 ; horizontal spacing?
	dbw 0, PCItems
	dbw BANK(Function24ab4), Function24ab4
	dbw BANK(Function24ac3), Function24ac3
	dbw BANK(Function244c3), Function244c3

INCBIN "baserom.gbc", $15a20, $15a45 - $15a20


OpenMartDialog: ; 15a45
	call GetMart
	ld a, c
	ld [EngineBuffer1], a
	call Function15b10
	ld a, [EngineBuffer1]
	ld hl, .dialogs
	rst JumpTable
	ret
; 15a57

.dialogs
       dw MartDialog
       dw HerbShop
       dw BargainShop
       dw Pharmacist
       dw VendingMachine
; 15a61

MartDialog: ; 15a61
	ld a, 0
	ld [EngineBuffer1], a
	xor a
	ld [MovementAnimation], a
	call Function15b47
	ret
; 15a6e

HerbShop: ; 15a6e
	call ReadMart
	call Function1d6e
	ld hl, $5e4a
	call Function15fcd
	call Function15c62
	ld hl, $5e68
	call Function15fcd
	ret
; 15a84

BargainShop: ; 15a84
	ld b, $5
	ld de, $5c51
	call Function15b10
	call Function15c25
	call Function1d6e
	ld hl, $5e6d
	call Function15fcd
	call Function15c62
	ld hl, WalkingDirection
	ld a, [hli]
	or [hl]
	jr z, .asm_15aa7
	ld hl, $dc1e
	set 6, [hl]

.asm_15aa7
	ld hl, $5e8b
	call Function15fcd
	ret
; 15aae

Pharmacist: ; 15aae
	call ReadMart
	call Function1d6e
	ld hl, $5e90
	call Function15fcd
	call Function15c62
	ld hl, $5eae
	call Function15fcd
	ret
; 15ac4

VendingMachine: ; 15ac4
	ld b, $5
	ld de, $5aee
	ld hl, StatusFlags
	bit 6, [hl]
	jr z, .asm_15ad5
	ld b, $5
	ld de, $5aff

.asm_15ad5
	call Function15b10
	call Function15c25
	call Function1d6e
	ld hl, UnknownText_0x15f83
	call Function15fcd
	call Function15c62
	ld hl, $5fb4
	call Function15fcd
	ret
; 15aee

INCBIN "baserom.gbc", $15aee, $15b10 - $15aee


Function15b10: ; 15b10
	ld a, b
	ld [CurFruit], a
	ld a, e
	ld [MartPointer], a
	ld a, d
	ld [MartPointer + 1], a
	ld hl, CurMart
	xor a
	ld bc, CurMartEnd - CurMart
	call ByteFill
	xor a
	ld [MovementAnimation], a
	ld [WalkingDirection], a
	ld [FacingDirection], a
	ret
; 15b31

GetMart: ; 15b31
	ld a, e
	cp (MartsEnd - Marts) / 2
	jr c, .IsAMart
	ld b, $5
	ld de, DefaultMart
	ret

.IsAMart
	ld hl, Marts
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld b, $5
	ret
; 15b47

Function15b47: ; 15b47
.asm_15b47
	ld a, [MovementAnimation]
	ld hl, .table_15b56
	rst JumpTable
	ld [MovementAnimation], a
	cp $ff
	jr nz, .asm_15b47
	ret

.table_15b56
       dw Function15b62
       dw Function15b6e
       dw Function15b8d
       dw Function15b9a
       dw Function15ba3
       dw Function15baf
; 15b62

Function15b62: ; 15b62
	call Function1d6e
	ld hl, UnknownText_0x15f83
	call PrintText
	ld a, $1
	ret
; 15b6e

Function15b6e: ; 15b6e
	ld hl, $5f88
	call Function1d3c
	call Function1d81
	jr c, .asm_15b84
	ld a, [$cfa9]
	cp $1
	jr z, .asm_15b87
	cp $2
	jr z, .asm_15b8a
.asm_15b84
	ld a, $4
	ret
.asm_15b87
	ld a, $2
	ret
.asm_15b8a
	ld a, $3
	ret
; 15b8d

Function15b8d: ; 15b8d
	call Function1c07
	call ReadMart
	call Function15c62
	and a
	ld a, $5
	ret
; 15b9a

Function15b9a: ; 15b9a
	call Function1c07
	call Function15eb3
	ld a, $5
	ret
; 15ba3

Function15ba3: ; 15ba3
	call Function1c07
	ld hl, $5fb4
	call Function15fcd
	ld a, $ff
	ret
; 15baf

Function15baf: ; 15baf
	call Function1d6e
	ld hl, UnknownText_0x15fb9
	call PrintText
	ld a, $1
	ret
; 15bbb

ReadMart: ; 15bbb
	ld hl, MartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, CurMart
.CopyMart
	ld a, [CurFruit]
	call GetFarByte
	ld [de], a
	inc hl
	inc de
	cp $ff
	jr nz, .CopyMart
	ld hl, DefaultFlypoint
	ld de, CurMart + 1
.ReadMartItem
	ld a, [de]
	inc de
	cp $ff
	jr z, .asm_15be4
	push de
	call GetMartItemPrice
	pop de
	jr .ReadMartItem

.asm_15be4
	ret
; 15be5

GetMartItemPrice: ; 15be5
; Return the price of item a in BCD at hl and in tiles at StringBuffer1.
	push hl
	ld [CurItem], a
	callba GetItemPrice
	pop hl

GetMartPrice: ; 15bf0
; Return price de in BCD at hl and in tiles at StringBuffer1.
	push hl
	ld a, d
	ld [StringBuffer2], a
	ld a, e
	ld [StringBuffer2 + 1], a
	ld hl, StringBuffer1
	ld de, StringBuffer2
	ld bc, $82 << 8 + 6 ; 6 digits
	call PrintNum
	pop hl

	ld de, StringBuffer1
	ld c, 6 / 2 ; 6 digits
.asm_15c0b
	call .TileToNum
	swap a
	ld b, a
	call .TileToNum
	or b
	ld [hli], a
	dec c
	jr nz, .asm_15c0b
	ret
; 15c1a

.TileToNum ; 15c1a
	ld a, [de]
	inc de
	cp " "
	jr nz, .asm_15c22
	ld a, "0"

.asm_15c22
	sub "0"
	ret
; 15c25

Function15c25: ; 15c25
	ld hl, MartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	inc hl
	ld bc, DefaultFlypoint
	ld de, CurMart + 1
.asm_15c33
	ld a, [hli]
	ld [de], a
	inc de
	cp $ff
	jr z, .asm_15c4b

	push de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	ld h, b
	ld l, c
	call GetMartPrice
	ld b, h
	ld c, l
	pop hl
	pop de
	jr .asm_15c33

.asm_15c4b
	pop hl
	ld a, [hl]
	ld [CurMart], a
	ret
; 15c51

INCBIN "baserom.gbc", $15c51, $15c62 - $15c51


Function15c62: ; 15c62
	call FadeToMenu
	callba Function8000
	xor a
	ld [WalkingY], a
	ld a, 1
	ld [WalkingX], a
.asm_15c74
	call Function15cef
	jr nc, .asm_15c74
	call Function2b3c
	ret
; 15c7d

Function15c7d: ; 15c7d
	push af
	call Function15ca3
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	ret
; 15c91

Function15c91: ; 15c91
	call Function15ca3
	inc hl
	inc hl
	ld a, [hl]
	and a
	jp z, Function15d83
	cp 1
	jp z, Function15da5
	jp Function15de2
; 15ca3

Function15ca3: ; 15ca3
	ld a, [EngineBuffer1]
	ld e, a
	ld d, 0
	ld hl, .data_15cb0
	add hl, de
	add hl, de
	add hl, de
	ret
; 15cb0

.data_15cb0 ; 15cb0
       dwb $5cbf, 0
       dwb $5ccb, 0
       dwb $5cd7, 1
       dwb $5ce3, 0
       dwb $5cbf, 2
; 15cbf

INCBIN "baserom.gbc", $15cbf, $15cef - $15cbf


Function15cef: ; 15cef
	ld a, $9
	ld hl, $4ae8
	rst FarCall
	call Function1ad2
	ld hl, $5e18
	call Function1d3c
	ld a, [WalkingX]
	ld [$cf88], a
	ld a, [WalkingY]
	ld [$d0e4], a
	call Function350c
	ld a, [$d0e4]
	ld [WalkingY], a
	ld a, [$cfa9]
	ld [WalkingX], a
	call SpeechTextBox
	ld a, [$cf73]
	cp $2
	jr z, .asm_15d6d
	cp $1
	jr z, .asm_15d27

.asm_15d27
	call Function15c91
	jr c, .asm_15d68
	call Function15d97
	jr c, .asm_15d68
	ld de, Money
	ld bc, $ffc3
	ld a, $3
	call Function1600b
	jr c, .asm_15d79
	ld hl, NumItems
	call Function2f66
	jr nc, .asm_15d6f
	ld a, [$d107]
	ld e, a
	ld d, $0
	ld b, $1
	ld hl, WalkingDirection
	call FlagAction
	call Function15fc3
	ld de, Money
	ld bc, $ffc3
	call Function15ffa
	ld a, $4
	call Function15c7d
	call Functiona36

.asm_15d68
	call SpeechTextBox
	and a
	ret

.asm_15d6d
	scf
	ret

.asm_15d6f
	ld a, $3
	call Function15c7d
	call Functiona36
	and a
	ret

.asm_15d79
	ld a, $2
	call Function15c7d
	call Functiona36
	and a
	ret
; 15d83

Function15d83: ; 15d83
	ld a, $63
	ld [$d10d], a
	ld a, $0
	call Function15c7d
	ld a, $9
	ld hl, $4fc9
	rst FarCall
	call Function1c07
	ret
; 15d97

Function15d97: ; 15d97
	ld a, $3b
	call Predef
	ld a, $1
	call Function15c7d
	call Function1dcf
	ret
; 15da5

Function15da5: ; 15da5
	ld a, $1
	ld [$d10c], a
	ld a, [$d107]
	ld e, a
	ld d, $0
	ld b, $2
	ld hl, WalkingDirection
	call FlagAction
	ld a, c
	and a
	jr nz, .asm_15dd8
	ld a, [$d107]
	ld e, a
	ld d, $0
	ld hl, MartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	add hl, de
	add hl, de
	add hl, de
	inc hl
	ld a, [hli]
	ld [$ffc5], a
	ld a, [hl]
	ld [$ffc4], a
	xor a
	ld [$ffc3], a
	and a
	ret

.asm_15dd8
	ld a, $5
	call Function15c7d
	call Functiona36
	scf
	ret
; 15de2

Function15de2: ; 15de2
	ld a, $0
	call Function15c7d
	call Function15df9
	ld a, $63
	ld [$d10d], a
	ld a, $9
	ld hl, $4fcf
	rst FarCall
	call Function1c07
	ret
; 15df9

Function15df9: ; 15df9
	ld a, [$d107]
	ld e, a
	ld d, $0
	ld hl, MartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	add hl, de
	add hl, de
	add hl, de
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret
; 15e0e

INCBIN "baserom.gbc", $15e0e, $15eb3 - $15e0e


Function15eb3: ; 15eb3
	call Function2ed3
	ld a, $4
	ld hl, $46a5
	rst FarCall
.asm_15ebc
	ld a, $4
	ld hl, $46be
	rst FarCall
	ld a, [$cf66]
	and a
	jp z, Function15ece
	call Function15ee0
	jr .asm_15ebc
; 15ece

Function15ece: ; 15ece
	call Function2b74
	and a
	ret
; 15ed3

INCBIN "baserom.gbc", $15ed3, $15ee0 - $15ed3


Function15ee0: ; 15ee0
	callba CheckItemMenu
	ld a, [$d142]
	ld hl, Table15eee
	rst JumpTable
	ret
; 15eee

Table15eee: ; 15eee
	dw Function15efd
	dw Function15efc
	dw Function15efc
	dw Function15efc
	dw Function15efd
	dw Function15efd
	dw Function15efd
; 15efc

Function15efc: ; 15efc
	ret
; 15efd


Function15efd: ; 15efd
	callba _CheckTossableItem
	ld a, [$d142]
	and a
	jr z, .asm_15f11
	ld hl, $5faf
	call PrintText
	and a
	ret

.asm_15f11
	ld hl, UnknownText_0x15f73
	call PrintText
	ld a, $9
	ld hl, $4af8
	rst FarCall
	ld a, $9
	ld hl, $4fe1
	rst FarCall
	call Function1c07
	jr c, .asm_15f6e
	ld hl, $c5b9
	ld bc, $0312
	call ClearBox
	ld hl, UnknownText_0x15f78
	call PrintTextBoxText
	call Function1dcf
	jr c, .asm_15f6e
	ld de, Money
	ld bc, $ffc3
	call Function15fd7
	ld a, [$d107]
	ld hl, NumItems
	call Function2f53
	ld a, $3b
	call Predef
	ld hl, $c5b9
	ld bc, $0312
	call ClearBox
	ld hl, UnknownText_0x15fbe
	call PrintTextBoxText
	call Function15fc3
	ld a, $9
	ld hl, $4af0
	rst FarCall
	call Functiona36

.asm_15f6e
	call Function1c07
	and a
	ret
; 15f73

UnknownText_0x15f73: ; 0x15f73
	text_jump UnknownText_0x1c4f33, BANK(UnknownText_0x1c4f33)
	db "@"
; 0x15f78

UnknownText_0x15f78: ; 0x15f78
	text_jump UnknownText_0x1c4f3e, BANK(UnknownText_0x1c4f3e)
	db "@"
; 0x15f7d

INCBIN "baserom.gbc", $15f7d, $15f83 - $15f7d

UnknownText_0x15f83: ; 0x15f83
	text_jump UnknownText_0x1c4f62, BANK(UnknownText_0x1c4f62)
	db "@"
; 0x15f88

INCBIN "baserom.gbc", $15f88, $15fb9 - $15f88

UnknownText_0x15fb9: ; 0x15fb9
	text_jump UnknownText_0x1c500d, BANK(UnknownText_0x1c500d)
	db "@"
; 0x15fbe

UnknownText_0x15fbe: ; 0x15fbe
	text_jump UnknownText_0x1c502e, BANK(UnknownText_0x1c502e)
	db "@"
; 0x15fc3

Function15fc3: ; 15fc3
	call WaitSFX
	ld de, SFX_TRANSACTION
	call StartSFX
	ret
; 15fcd

Function15fcd: ; 15fcd
	call Function1d4f
	call Functiona36
	call Function1c07
	ret
; 15fd7

Function15fd7: ; 15fd7
	ld a, $3
	call Function16053
	ld bc, $5ff7
	ld a, $3
	call Function1600b
	jr z, .asm_15ff5
	jr c, .asm_15ff5
	ld hl, $5ff7
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	scf
	ret

.asm_15ff5
	and a
	ret
; 15ff7

INCBIN "baserom.gbc", $15ff7, $15ffa - $15ff7


Function15ffa: ; 15ffa
	ld a, $3
	call Function16035
	jr nc, .asm_16009
	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	scf
	ret

.asm_16009
	and a
	ret
; 1600b

Function1600b: ; 1600b
	ld a, $3
	push hl
	push de
	push bc
	ld h, b
	ld l, c
	ld c, $0
	ld b, a
.asm_16015
	dec a
	jr z, .asm_1601c
	inc de
	inc hl
	jr .asm_16015

.asm_1601c
	and a
.asm_1601d
	ld a, [de]
	sbc [hl]
	jr z, .asm_16022
	inc c

.asm_16022
	dec de
	dec hl
	dec b
	jr nz, .asm_1601d
	jr c, .asm_1602d
	ld a, c
	and a
	jr .asm_16031

.asm_1602d
	ld a, $1
	and a
	scf

.asm_16031
	pop bc
	pop de
	pop hl
	ret
; 16035

Function16035: ; 16035
	ld a, $3
	push hl
	push de
	push bc
	ld h, b
	ld l, c
	ld b, a
	ld c, $0
.asm_1603f
	dec a
	jr z, .asm_16046
	inc de
	inc hl
	jr .asm_1603f

.asm_16046
	and a
.asm_16047
	ld a, [de]
	sbc [hl]
	ld [de], a
	dec de
	dec hl
	dec b
	jr nz, .asm_16047
	pop bc
	pop de
	pop hl
	ret
; 16053

Function16053: ; 16053
	ld a, $3
	push hl
	push de
	push bc
	ld h, b
	ld l, c
	ld b, a
.asm_1605b
	dec a
	jr z, .asm_16062
	inc de
	inc hl
	jr .asm_1605b

.asm_16062
	and a
.asm_16063
	ld a, [de]
	adc [hl]
	ld [de], a
	dec de
	dec hl
	dec b
	jr nz, .asm_16063
	pop bc
	pop de
	pop hl
	ret
; 1606f

Function1606f: ; 1606f
	ld a, $2
	ld de, Coins
	call $6055
	ld a, $2
	ld bc, $608d
	call $600d
	jr c, .asm_1608b
	ld hl, $608d
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	scf
	ret

.asm_1608b
	and a
	ret
; 1608d

INCBIN "baserom.gbc", $1608d, $1608f - $1608d


Function1608f: ; 1608f
	ld a, $2
	ld de, Coins
	call $6037
	jr nc, .asm_1609f
	xor a
	ld [de], a
	inc de
	ld [de], a
	scf
	ret

.asm_1609f
	and a
	ret
; 160a1

Function160a1: ; 160a1
	ld a, $2
	ld de, Coins
	jp $600d
; 160a9


INCLUDE "items/marts.asm"


INCBIN "baserom.gbc", $16218, $16e1d - $16218


Function16e1d: ; 16e1d
	call Function16ed6
	ld c, $0
	jp nc, $6eb7
	ld a, [BreedMon1Species]
	ld [CurPartySpecies], a
	ld a, [$df21]
	ld [TempMonDVs], a
	ld a, [$df22]
	ld [$d124], a
	ld a, $3
	ld [MonType], a
	ld a, $24
	call Predef
	jr c, .asm_16e70
	ld b, $1
	jr nz, .asm_16e48
	inc b

.asm_16e48
	push bc
	ld a, [BreedMon2Species]
	ld [CurPartySpecies], a
	ld a, [$df5a]
	ld [TempMonDVs], a
	ld a, [$df5b]
	ld [$d124], a
	ld a, $3
	ld [MonType], a
	ld a, $24
	call Predef
	pop bc
	jr c, .asm_16e70
	ld a, $1
	jr nz, .asm_16e6d
	inc a

.asm_16e6d
	cp b
	jr nz, .asm_16e89

.asm_16e70
	ld c, $0
	ld a, [BreedMon1Species]
	cp $84
	jr z, .asm_16e82
	ld a, [BreedMon2Species]
	cp $84
	jr nz, .asm_16eb7
	jr .asm_16e89

.asm_16e82
	ld a, [BreedMon2Species]
	cp $84
	jr z, .asm_16eb7

.asm_16e89
	call $6ebc
	ld c, $ff
	jp z, $6eb7
	ld a, [BreedMon2Species]
	ld b, a
	ld a, [BreedMon1Species]
	cp b
	ld c, $fe
	jr z, .asm_16e9f
	ld c, $80

.asm_16e9f
	ld a, [$df12]
	ld b, a
	ld a, [$df4b]
	cp b
	jr nz, .asm_16eb7
	ld a, [$df13]
	ld b, a
	ld a, [$df4c]
	cp b
	jr nz, .asm_16eb7
	ld a, c
	sub $4d
	ld c, a

.asm_16eb7
	ld a, c
	ld [$d265], a
	ret
; 16ebc

INCBIN "baserom.gbc", $16ebc, $16ecd - $16ebc


Function16ecd: ; 16ecd
	rlca
	ld b, a
	ld a, [$df5b]
	and $7
	cp b
	ret
; 16ed6

Function16ed6: ; 16ed6
	ld a, [BreedMon2Species]
	ld [CurSpecies], a
	call GetBaseData
	ld a, [BaseEggGroups]
	cp $ff
	jr z, .asm_16f3a
	ld a, [BreedMon1Species]
	ld [CurSpecies], a
	call GetBaseData
	ld a, [BaseEggGroups]
	cp $ff
	jr z, .asm_16f3a
	ld a, [BreedMon2Species]
	cp $84
	jr z, .asm_16f3c
	ld [CurSpecies], a
	call GetBaseData
	ld a, [BaseEggGroups]
	push af
	and $f
	ld b, a
	pop af
	and $f0
	swap a
	ld c, a
	ld a, [BreedMon1Species]
	cp $84
	jr z, .asm_16f3c
	ld [CurSpecies], a
	push bc
	call GetBaseData
	pop bc
	ld a, [BaseEggGroups]
	push af
	and $f
	ld d, a
	pop af
	and $f0
	swap a
	ld e, a
	ld a, d
	cp b
	jr z, .asm_16f3c
	cp c
	jr z, .asm_16f3c
	ld a, e
	cp b
	jr z, .asm_16f3c
	cp c
	jr z, .asm_16f3c

.asm_16f3a
	and a
	ret

.asm_16f3c
	scf
	ret
; 16f3e

Function16f3e: ; 16f3e
	ld de, PartySpecies
	ld hl, PartyMon1Happiness
	ld c, 0
.loop
	ld a, [de]
	inc de
	cp $ff
	ret z
	cp EGG
	jr nz, .next
	dec [hl]
	jr nz, .next
	ld a, 1
	and a
	ret

.next
	push de
	ld de, PartyMon2 - PartyMon1
	add hl, de
	pop de
	jr .loop
; 16f5e

INCBIN "baserom.gbc", $16f5e, $174ba - $16f5e


SECTION "bank6",ROMX,BANK[$6]

INCLUDE "tilesets/data_1.asm"


SECTION "bank7",ROMX,BANK[$7]

Function1c000: ; 1c000
	ld a, [MapGroup]
	ld e, a
	ld d, $0
	ld hl, $4021
	add hl, de
	ld a, [hl]
	cp $ff
	ret z
	ld hl, $403c
	ld bc, $0090
	call AddNTimes
	ld de, $90a0
	ld bc, $0090
	call CopyBytes
	ret
; 1c021

INCBIN "baserom.gbc", $1c021, $1c30c - $1c021

INCLUDE "tilesets/data_2.asm"

;                           Songs i

Music_Credits:       INCLUDE "audio/music/credits.asm"
Music_Clair:         INCLUDE "audio/music/clair.asm"
Music_MobileAdapter: INCLUDE "audio/music/mobileadapter.asm"


SECTION "bank8",ROMX,BANK[$8]

INCBIN "baserom.gbc", $20000, $20181 - $20000

INCLUDE "tilesets/data_3.asm"

EggMovePointers: ; 0x23b11
INCLUDE "stats/egg_move_pointers.asm"

INCLUDE "stats/egg_moves.asm"


SECTION "bank9",ROMX,BANK[$9]

INCBIN "baserom.gbc", $24000, $2400e - $24000


Function2400e: ; 2400e
	ld hl, Function1c66
	ld a, [$cf94]
	rst FarCall
	call Function24085
	call Function1ad2
	call Function321c
	call Function2408f
	ret
; 24022

Function24022: ; 24022
	ld hl, Function1c66
	ld a, [$cf94]
	rst FarCall
	call Function24085
	callba MobileTextBorder
	call Function1ad2
	call Function321c
	call Function2408f
	ret
; 2403c

Function2403c: ; 2403c
	ld hl, Function1c66
	ld a, [$cf94]
	rst FarCall
	call Function24085
	callba MobileTextBorder
	call Function1ad2
	call Function321c
	call $411a
	ld hl, $cfa5
	set 7, [hl]
.asm_2405a
	call DelayFrame
	ld a, $40
	ld hl, $432e
	rst FarCall
	ld a, [$cd2b]
	and a
	jr nz, .asm_24076
	call Function241ba
	ld a, [$cfa8]
	and c
	jr z, .asm_2405a
	call $4098
	ret

.asm_24076
	ld a, [$cfa4]
	ld c, a
	ld a, [$cfa3]
	call SimpleMultiply
	ld [$cf88], a
	and a
	ret
; 24085



Function24085: ; 24085
	xor a
	ld [hBGMapMode], a
	call Function1cbb
	call Function240db
	ret
; 2408f

Function2408f: ; 2408f
	call $411a
	call Function1bc9
	call Function1ff8
	ld a, [$cf91]
	bit 1, a
	jr z, .asm_240a6
	call Function1bdd
	bit 2, a
	jr nz, .asm_240c9

.asm_240a6
	ld a, [$cf91]
	bit 0, a
	jr nz, .asm_240b4
	call Function1bdd
	bit 1, a
	jr nz, .asm_240cb

.asm_240b4
	ld a, [$cfa4]
	ld c, a
	ld a, [$cfa9]
	dec a
	call SimpleMultiply
	ld c, a
	ld a, [$cfaa]
	add c
	ld [$cf88], a
	and a
	ret

.asm_240c9
	scf
	ret

.asm_240cb
	scf
	ret
; 240cd

Function240cd: ; 240cd
	ld a, [$cf92]
	and $f
	ret
; 240d3

Function240d3: ; 240d3
	ld a, [$cf92]
	swap a
	and $f
	ret
; 240db

Function240db: ; 240db
	ld hl, $cf95
	ld e, [hl]
	inc hl
	ld d, [hl]
	call Function1cc6
	call Function1d05
	call Function240d3
	ld b, a
.asm_240eb
	push bc
	push hl
	call Function240cd
	ld c, a
.asm_240f1
	push bc
	ld a, [$cf94]
	call Function201c
	inc de
	ld a, [$cf93]
	ld c, a
	ld b, $0
	add hl, bc
	pop bc
	dec c
	jr nz, .asm_240f1
	pop hl
	ld bc, $0028
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_240eb
	ld hl, $cf98
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, [$cf97]
	rst FarCall
	ret
; 2411a

INCBIN "baserom.gbc", $2411a, $24177 - $2411a


Function24177: ; 24177
	rst FarCall
	ret
; 24179

Function24179: ; 24179
	xor a
	ld hl, $cfa5
	ld [hli], a
	ld [hld], a
	ld a, [$cf91]
	bit 5, a
	ret z
	set 5, [hl]
	set 4, [hl]
	ret
; 2418a

Function2418a: ; 2418a
	ld a, [$cf93]
	or $20
	ld [$cfa7], a
	ret
; 24193

Function24193: ; 24193
	ld hl, $cf91
	ld a, $1
	bit 0, [hl]
	jr nz, .asm_2419e
	or $2

.asm_2419e
	bit 1, [hl]
	jr z, .asm_241a4
	or $4

.asm_241a4
	ld [$cfa8], a
	ret
; 241a8


Function241a8: ; 241a8
	call $4329
	ld hl, $cfa6
	res 7, [hl]
	ld a, [hBGMapMode]
	push af
	call Function24216
	pop af
	ld [hBGMapMode], a
	ret
; 241ba

Function241ba: ; 241ba
	ld hl, $cfa6
	res 7, [hl]
	ld a, [hBGMapMode]
	push af
	call Function2431a
	call Function24249
	jr nc, .asm_241cd
	call Function24270

.asm_241cd
	pop af
	ld [hBGMapMode], a
	call Function1bdd
	ld c, a
	ret
; 241d5

INCBIN "baserom.gbc", $241d5, $24216 - $241d5


Function24216: ; 24216
.asm_24216
	call Function2431a
	call Function24238
	call Function24249
	jr nc, .asm_24237
	call Function24270
	jr c, .asm_24237
	ld a, [$cfa5]
	bit 7, a
	jr nz, .asm_24237
	call Function1bdd
	ld b, a
	ld a, [$cfa8]
	and b
	jr z, .asm_24216

.asm_24237
	ret
; 24238

Function24238: ; 24238
	ld a, [hOAMUpdate]
	push af
	ld a, $1
	ld [hOAMUpdate], a
	call WaitBGMap
	pop af
	ld [hOAMUpdate], a
	xor a
	ld [hBGMapMode], a
	ret
; 24249

Function24249: ; 24249
.asm_24249
	call RTC
	call Function24259
	ret c
	ld a, [$cfa5]
	bit 7, a
	jr z, .asm_24249
	and a
	ret
; 24259

Function24259: ; 24259
	ld a, [$cfa5]
	bit 6, a
	jr z, .asm_24266
	ld hl, $4f62
	ld a, $23
	rst FarCall

.asm_24266
	call Functiona57
	call Function1bdd
	and a
	ret z
	scf
	ret
; 24270

Function24270: ; 24270
	call Function1bdd
	bit 0, a
	jp nz, Function24318
	bit 1, a
	jp nz, Function24318
	bit 2, a
	jp nz, Function24318
	bit 3, a
	jp nz, Function24318
	bit 4, a
	jr nz, .asm_242fa
	bit 5, a
	jr nz, .asm_242dc
	bit 6, a
	jr nz, .asm_242be
	bit 7, a
	jr nz, .asm_242a0
	and a
	ret

	ld hl, $cfa6
	set 7, [hl]
	scf
	ret

.asm_242a0
	ld hl, $cfa9
	ld a, [$cfa3]
	cp [hl]
	jr z, .asm_242ac
	inc [hl]
	xor a
	ret

.asm_242ac
	ld a, [$cfa5]
	bit 5, a
	jr nz, .asm_242ba
	bit 3, a
	jp nz, $4299
	xor a
	ret

.asm_242ba
	ld [hl], $1
	xor a
	ret

.asm_242be
	ld hl, $cfa9
	ld a, [hl]
	dec a
	jr z, .asm_242c8
	ld [hl], a
	xor a
	ret

.asm_242c8
	ld a, [$cfa5]
	bit 5, a
	jr nz, .asm_242d6
	bit 2, a
	jp nz, $4299
	xor a
	ret

.asm_242d6
	ld a, [$cfa3]
	ld [hl], a
	xor a
	ret

.asm_242dc
	ld hl, $cfaa
	ld a, [hl]
	dec a
	jr z, .asm_242e6
	ld [hl], a
	xor a
	ret

.asm_242e6
	ld a, [$cfa5]
	bit 4, a
	jr nz, .asm_242f4
	bit 1, a
	jp nz, $4299
	xor a
	ret

.asm_242f4
	ld a, [$cfa4]
	ld [hl], a
	xor a
	ret

.asm_242fa
	ld hl, $cfaa
	ld a, [$cfa4]
	cp [hl]
	jr z, .asm_24306
	inc [hl]
	xor a
	ret

.asm_24306
	ld a, [$cfa5]
	bit 4, a
	jr nz, .asm_24314
	bit 0, a
	jp nz, $4299
	xor a
	ret

.asm_24314
	ld [hl], $1
	xor a
	ret
; 24318

Function24318: ; 24318
	xor a
	ret
; 2431a

Function2431a: ; 2431a
	ld hl, $cfac
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	cp $ed
	jr nz, .asm_24329
	ld a, [$cfab]
	ld [hl], a

.asm_24329
	ld a, [$cfa1]
	ld b, a
	ld a, [$cfa2]
	ld c, a
	call Function1d05
	ld a, [$cfa7]
	swap a
	and $f
	ld c, a
	ld a, [$cfa9]
	ld b, a
	xor a
	dec b
	jr z, .asm_24348
.asm_24344
	add c
	dec b
	jr nz, .asm_24344

.asm_24348
	ld c, $14
	call AddNTimes
	ld a, [$cfa7]
	and $f
	ld c, a
	ld a, [$cfaa]
	ld b, a
	xor a
	dec b
	jr z, .asm_2435f
.asm_2435b
	add c
	dec b
	jr nz, .asm_2435b

.asm_2435f
	ld c, a
	add hl, bc
	ld a, [hl]
	cp $ed
	jr z, .asm_2436b
	ld [$cfab], a
	ld [hl], $ed

.asm_2436b
	ld a, l
	ld [$cfac], a
	ld a, h
	ld [$cfad], a
	ret
; 24374

Function24374: ; 24374
	ld a, [rSVBK]
	push af
	ld a, $7
	ld [rSVBK], a
	ld hl, $cf71
	ld e, [hl]
	inc hl
	ld d, [hl]
	push de
	ld b, $10
	ld hl, $cf81
.asm_24387
	ld a, [hli]
	ld [de], a
	dec de
	dec b
	jr nz, .asm_24387
	ld a, [$cf81]
	bit 6, a
	jr nz, .asm_24398
	bit 7, a
	jr z, .asm_243ae

.asm_24398
	ld hl, $cf71
	ld a, [hli]
	ld h, [hl]
	ld l, a
	set 0, [hl]
	call Function1cfd
	call Function243cd
	call Function1d19
	call Function243cd
	jr .asm_243b5

.asm_243ae
	pop hl
	push hl
	ld a, [hld]
	ld l, [hl]
	ld h, a
	res 0, [hl]

.asm_243b5
	pop hl
	call Function243e7
	ld a, h
	ld [de], a
	dec de
	ld a, l
	ld [de], a
	dec de
	ld hl, $cf71
	ld [hl], e
	inc hl
	ld [hl], d
	pop af
	ld [rSVBK], a
	ld hl, $cf78
	inc [hl]
	ret
; 243cd

Function243cd: ; 243cd
	call Function1c53
	inc b
	inc c
	call Function243e7
.asm_243d5
	push bc
	push hl
.asm_243d7
	ld a, [hli]
	ld [de], a
	dec de
	dec c
	jr nz, .asm_243d7
	pop hl
	ld bc, $0014
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_243d5
	ret
; 243e7

Function243e7: ; 243e7
	ret
; 243e8

Function243e8: ; 243e8
	xor a
	ld [hBGMapMode], a
	ld a, [rSVBK]
	push af
	ld a, $7
	ld [rSVBK], a
	call Function1c7e
	ld a, l
	or h
	jp z, Function2445d
	ld a, l
	ld [$cf71], a
	ld a, h
	ld [$cf72], a
	call Function1c47
	ld a, [$cf81]
	bit 0, a
	jr z, .asm_24411
	ld d, h
	ld e, l
	call Function1c23

.asm_24411
	call Function1c7e
	ld a, h
	or l
	jr z, .asm_2441b
	call Function1c47

.asm_2441b
	pop af
	ld [rSVBK], a
	ld hl, $cf78
	dec [hl]
	ret
; 24423

INCBIN "baserom.gbc", $24423, $24426 - $24423


Function24426: ; 24426
	bit 0, a
	ret z
	xor a
	call GetSRAMBank
	ld hl, TileMap
	ld de, $a000
	ld bc, $0168
	call CopyBytes
	call CloseSRAM
	call Function2173
	xor a
	call GetSRAMBank
	ld hl, $a000
	ld de, TileMap
	ld bc, $0168
.asm_2444c
	ld a, [hl]
	cp $61
	jr c, .asm_24452
	ld [de], a

.asm_24452
	inc hl
	inc de
	dec bc
	ld a, c
	or b
	jr nz, .asm_2444c
	call CloseSRAM
	ret
; 2445d

Function2445d: ; 2445d
	ld hl, UnknownText_0x24468
	call PrintText
	call WaitBGMap
.asm_24466
	jr .asm_24466
; 24468

UnknownText_0x24468: ; 24468
	text_jump UnknownText_0x1c46b7, BANK(UnknownText_0x1c46b7)
	db "@"
; 2446d

Function2446d: ; 2446d
	ld a, [$cf91]
	ld b, a
	ld hl, $cfa1
	ld a, [$cf82]
	inc a
	bit 6, b
	jr nz, .asm_2447d
	inc a

.asm_2447d
	ld [hli], a
	ld a, [$cf83]
	inc a
	ld [hli], a
	ld a, [$cf92]
	ld [hli], a
	ld a, $1
	ld [hli], a
	ld [hl], $0
	bit 5, b
	jr z, .asm_24492
	set 5, [hl]

.asm_24492
	ld a, [$cf81]
	bit 4, a
	jr z, .asm_2449b
	set 6, [hl]

.asm_2449b
	inc hl
	xor a
	ld [hli], a
	ld a, $20
	ld [hli], a
	ld a, $1
	bit 0, b
	jr nz, .asm_244a9
	add $2

.asm_244a9
	ld [hli], a
	ld a, [$cf88]
	and a
	jr z, .asm_244b7
	ld c, a
	ld a, [$cf92]
	cp c
	jr nc, .asm_244b9

.asm_244b7
	ld c, $1

.asm_244b9
	ld [hl], c
	inc hl
	ld a, $1
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ret
; 244c3


Function244c3: ; 0x244c3
	ld a, [MenuSelection]
	ld [CurSpecies], a
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call TextBox
	ld a, [MenuSelection]
	cp $ff
	ret z
	ld de, $c5b9
	callba GetItemDescription
	ret
; 0x244e3

Function244e3: ; 244e3
	ld hl, $4547
	call Function1d3c
	call Function1cbb
	call Function1ad2
	call Function321c
	ld b, $12
	call GetSGBLayout
	xor a
	ld [hBGMapMode], a
	ld a, [CurPartySpecies]
	ld [CurSpecies], a
	call GetBaseData
	ld de, VTiles1
	ld a, $3c
	call Predef
	ld a, [$cf82]
	inc a
	ld b, a
	ld a, [$cf83]
	inc a
	ld c, a
	call Function1d05
	ld a, $80
	ld [$ffad], a
	ld bc, $0707
	ld a, $13
	call Predef
	call WaitBGMap
	ret
; 24528

Function24528: ; 24528
	ld hl, $4547
	call Function1d3c
	call Function1ce1
	call WaitBGMap
	call ClearSGB
	xor a
	ld [hBGMapMode], a
	call Function2173
	call Function321c
	call Function1ad2
	call Functione51
	ret
; 24547

INCBIN "baserom.gbc", $24547, $245af - $24547


Function245af: ; 245af
	xor a
	ld [$cf73], a
	ld [hBGMapMode], a
	inc a
	ld [$ffaa], a
	call Function2471a
	call Function24764
	call Function247dd
	call Function245f1
	call Function321c
	xor a
	ld [hBGMapMode], a
	ret
; 245cb

Function245cb: ; 245cb
.asm_245cb
	call Function24609
	jp c, Function245d6
	call z, Function245e1
	jr .asm_245cb
; 245d6

Function245d6: ; 245d6
	call Function1ff8
	ld [$cf73], a
	ld a, $0
	ld [$ffaa], a
	ret
; 245e1

Function245e1: ; 245e1
	call Function245f1
	ld a, $1
	ld [hBGMapMode], a
	ld c, $3
	call DelayFrames
	xor a
	ld [hBGMapMode], a
	ret
; 245f1

Function245f1: ; 245f1
	xor a
	ld [hBGMapMode], a
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	call Function247f0
	call Function2488b
	call Function248b8
	pop af
	ld [Options], a
	ret
; 24609

Function24609: ; 24609
.asm_24609
	call Function1bd3
	ld a, [$ffa9]
	and $f0
	ld b, a
	ld a, [hJoyPressed]
	and $f
	or b
	bit 0, a
	jp nz, Function24644
	bit 1, a
	jp nz, $466f
	bit 2, a
	jp nz, Function24673
	bit 3, a
	jp nz, Function24695
	bit 4, a
	jp nz, Function246b5
	bit 5, a
	jp nz, Function246a1
	bit 6, a
	jp nz, Function246c9
	bit 7, a
	jp nz, Function246df
	jr .asm_24609
; 24640

INCBIN "baserom.gbc", $24640, $24644 - $24640


Function24644: ; 24644
	call Function1bee
	ld a, [$cfa9]
	dec a
	call Function248d5
	ld a, [MenuSelection]
	ld [CurItem], a
	ld a, [$cf75]
	ld [$d10d], a
	call Function246fc
	dec a
	ld [$cf77], a
	ld [$d107], a
	ld a, [MenuSelection]
	cp $ff
	jr z, .asm_2466f
	ld a, $1
	scf
	ret

.asm_2466f
	ld a, $2
	scf
	ret
; 24673

Function24673: ; 24673
	ld a, [$cf91]
	bit 7, a
	jp z, Function2ec8
	ld a, [$cfa9]
	dec a
	call Function248d5
	ld a, [MenuSelection]
	cp $ff
	jp z, Function2ec8
	call Function246fc
	dec a
	ld [$cf77], a
	ld a, $4
	scf
	ret
; 24695

Function24695: ; 24695
	ld a, [$cf91]
	bit 6, a
	jp z, Function2ec8
	ld a, $8
	scf
	ret
; 246a1

Function246a1: ; 246a1
	ld hl, $cfa6
	bit 7, [hl]
	jp z, Function2ec8
	ld a, [$cf91]
	bit 3, a
	jp z, Function2ec8
	ld a, $20
	scf
	ret
; 246b5

Function246b5: ; 246b5
	ld hl, $cfa6
	bit 7, [hl]
	jp z, Function2ec8
	ld a, [$cf91]
	bit 2, a
	jp z, Function2ec8
	ld a, $10
	scf
	ret
; 246c9

Function246c9: ; 246c9
	ld hl, $cfa6
	bit 7, [hl]
	jp z, Function2ec6
	ld hl, $d0e4
	ld a, [hl]
	and a
	jr z, .asm_246dc
	dec [hl]
	jp Function2ec6

.asm_246dc
	jp Function2ec8
; 246df

Function246df: ; 246df
	ld hl, $cfa6
	bit 7, [hl]
	jp z, Function2ec6
	ld hl, $d0e4
	ld a, [$cf92]
	add [hl]
	ld b, a
	ld a, [$d144]
	cp b
	jr c, .asm_246f9
	inc [hl]
	jp Function2ec6

.asm_246f9
	jp Function2ec8
; 246fc

Function246fc: ; 246fc
	ld a, [$d0e4]
	ld c, a
	ld a, [$cfa9]
	add c
	ld c, a
	ret
; 24706

INCBIN "baserom.gbc", $24706, $2471a - $24706


Function2471a: ; 2471a
	ld hl, $cf96
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [$cf95]
	call GetFarByte
	ld [$d144], a
	ld a, [$cf92]
	ld c, a
	ld a, [$d0e4]
	add c
	ld c, a
	ld a, [$d144]
	inc a
	cp c
	jr nc, .asm_24748
	ld a, [$cf92]
	ld c, a
	ld a, [$d144]
	inc a
	sub c
	jr nc, .asm_24745
	xor a

.asm_24745
	ld [$d0e4], a

.asm_24748
	ld a, [$d0e4]
	ld c, a
	ld a, [$cf88]
	add c
	ld b, a
	ld a, [$d144]
	inc a
	cp b
	jr c, .asm_2475a
	jr nc, .asm_24763

.asm_2475a
	xor a
	ld [$d0e4], a
	ld a, $1
	ld [$cf88], a

.asm_24763
	ret
; 24764

Function24764: ; 24764
	ld a, [$cf91]
	ld c, a
	ld a, [$d144]
	ld b, a
	ld a, [$cf82]
	add $1
	ld [$cfa1], a
	ld a, [$cf83]
	add $0
	ld [$cfa2], a
	ld a, [$cf92]
	cp b
	jr c, .asm_24786
	jr z, .asm_24786
	ld a, b
	inc a

.asm_24786
	ld [$cfa3], a
	ld a, $1
	ld [$cfa4], a
	ld a, $8c
	bit 2, c
	jr z, .asm_24796
	set 0, a

.asm_24796
	bit 3, c
	jr z, .asm_2479c
	set 1, a

.asm_2479c
	ld [$cfa5], a
	xor a
	ld [$cfa6], a
	ld a, $20
	ld [$cfa7], a
	ld a, $c3
	bit 7, c
	jr z, .asm_247b0
	add $4

.asm_247b0
	bit 6, c
	jr z, .asm_247b6
	add $8

.asm_247b6
	ld [$cfa8], a
	ld a, [$cfa3]
	ld b, a
	ld a, [$cf88]
	and a
	jr z, .asm_247c8
	cp b
	jr z, .asm_247ca
	jr c, .asm_247ca

.asm_247c8
	ld a, $1

.asm_247ca
	ld [$cfa9], a
	ld a, $1
	ld [$cfaa], a
	xor a
	ld [$cfac], a
	ld [$cfad], a
	ld [$cfab], a
	ret
; 247dd

Function247dd: ; 247dd
	ld a, [$d144]
	ld c, a
	ld a, [$d0e3]
	and a
	jr z, .asm_247ef
	dec a
	cp c
	jr c, .asm_247ef
	xor a
	ld [$d0e3], a

.asm_247ef
	ret
; 247f0

Function247f0: ; 247f0
	call Function1cf1
	ld a, [$cf91]
	bit 4, a
	jr z, .asm_2480d
	ld a, [$d0e4]
	and a
	jr z, .asm_2480d
	ld a, [$cf82]
	ld b, a
	ld a, [$cf85]
	ld c, a
	call Function1d05
	ld [hl], $61

.asm_2480d
	call Function1cfd
	ld bc, $0015
	add hl, bc
	ld a, [$cf92]
	ld b, a
	ld c, $0
.asm_2481a
	ld a, [$d0e4]
	add c
	ld [$cf77], a
	ld a, c
	call Function248d5
	ld a, [MenuSelection]
	cp $ff
	jr z, .asm_24851
	push bc
	push hl
	call Function2486e
	pop hl
	ld bc, $0028
	add hl, bc
	pop bc
	inc c
	ld a, c
	cp b
	jr nz, .asm_2481a
	ld a, [$cf91]
	bit 4, a
	jr z, .asm_24850
	ld a, [$cf84]
	ld b, a
	ld a, [$cf85]
	ld c, a
	call Function1d05
	ld [hl], $ee

.asm_24850
	ret

.asm_24851
	ld a, [$cf91]
	bit 0, a
	jr nz, .asm_24866
	ld de, .data_2485f
	call PlaceString
	ret

.data_2485f
	db $82
	db $80
	db $8d
	db $82
	db $84
	db $8b
	db $50

.asm_24866
	ld d, h
	ld e, l
	ld hl, $cf98
	jp Function31be
; 2486e

Function2486e: ; 2486e
	push hl
	ld d, h
	ld e, l
	ld hl, $cf98
	call Function31be
	pop hl
	ld a, [$cf93]
	and a
	jr z, .asm_2488a
	ld e, a
	ld d, $0
	add hl, de
	ld d, h
	ld e, l
	ld hl, $cf9b
	call Function31be

.asm_2488a
	ret
; 2488b

Function2488b: ; 2488b
	ld a, [$d0e3]
	and a
	jr z, .asm_248b7
	ld b, a
	ld a, [$d0e4]
	cp b
	jr nc, .asm_248b7
	ld c, a
	ld a, [$cf92]
	add c
	cp b
	jr c, .asm_248b7
	ld a, b
	sub c
	dec a
	add a
	add $1
	ld c, a
	ld a, [$cf82]
	add c
	ld b, a
	ld a, [$cf83]
	add $0
	ld c, a
	call Function1d05
	ld [hl], $ec

.asm_248b7
	ret
; 248b8

Function248b8: ; 248b8
	ld a, [$cf91]
	bit 5, a
	ret z
	bit 1, a
	jr z, .asm_248c7
	ld a, [$d0e3]
	and a
	ret nz

.asm_248c7
	ld a, [$cfa9]
	dec a
	call Function248d5
	ld hl, $cf9e
	call Function31be
	ret
; 248d5

Function248d5: ; 248d5
	push de
	push hl
	ld e, a
	ld a, [$d0e4]
	add e
	ld e, a
	ld d, $0
	ld hl, $cf96
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	ld a, [$cf94]
	cp $1
	jr z, .asm_248f2
	cp $2
	jr z, .asm_248f1

.asm_248f1
	add hl, de

.asm_248f2
	add hl, de
	ld a, [$cf95]
	call GetFarByte
	ld [MenuSelection], a
	ld [CurItem], a
	inc hl
	ld a, [$cf95]
	call GetFarByte
	ld [$cf75], a
	pop hl
	pop de
	ret
; 2490c

INCBIN "baserom.gbc", $2490c, $24ab4 - $2490c

Function24ab4: ; 0x24ab4
	push de
	ld a, [MenuSelection]
	ld [$d265], a
	call GetItemName
	pop hl
	call PlaceString
	ret
; 0x24ac3

Function24ac3: ; 0x24ac3
	push de
	ld a, [MenuSelection]
	ld [CurItem], a
	ld a, BANK(_CheckTossableItem)
	ld hl, _CheckTossableItem
	rst $8
	ld a, [$d142]
	pop hl
	and a
	jr nz, .done
	ld de, $0015
	add hl, de
	ld [hl], $f1
	inc hl
	ld de, $cf75
	ld bc, $0102
	call PrintNum

.done
	ret
; 0x24ae8

Function24ae8: ; 24ae8
	ld hl, $4b15
	call Function1d3c
	jr .asm_24b01

	ld hl, $4b1d
	call Function1d3c
	jr .asm_24b01

	ld hl, $4b15
	ld de, $000b
	call Function1e2e

.asm_24b01
	call Function1cbb
	call Function1cfd
	ld de, $0015
	add hl, de
	ld de, Money
	ld bc, $2306
	call PrintNum
	ret
; 24b15

INCBIN "baserom.gbc", $24b15, $24b25 - $24b15

Function24b25: ; 24b25
	ld hl, $c4ab
	ld b, $1
	ld c, $7
	call TextBox
	ld hl, $c4ac
	ld de, CoinString
	call PlaceString
	ld hl, $c4c5
	ld de, String24b8e
	call PlaceString
	ld de, Coins
	ld bc, $0204
	ld hl, $c4c1
	call PrintNum
	ret
; 24b4e

Function24b4e: ; 24b4e
	ld hl, $c4a5
	ld b, $3
	ld c, $d
	call TextBox
	ld hl, $c4ba
	ld de, MoneyString
	call PlaceString
	ld hl, $c4c0
	ld de, Money
	ld bc, $2306
	call PrintNum
	ld hl, $c4e2
	ld de, CoinString
	call PlaceString
	ld hl, $c4eb
	ld de, Coins
	ld bc, $0204
	call PrintNum
	ret
; 24b83

MoneyString: ; 24b83
	db "MONEY@"
CoinString: ; 24b89
	db "COIN@"
String24b8e: ; 24b8e
	db "@"
; 24b8f

Function24b8f: ; 24b8f
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	ld hl, TileMap
	ld b, $3
	ld c, $7
	call TextBox
	ld hl, $c4b5
	ld de, $dc7a
	ld bc, $0203
	call PrintNum
	ld hl, $c4b8
	ld de, String24bcf
	call PlaceString
	ld hl, $c4dd
	ld de, String24bd4
	call PlaceString
	ld hl, $c4e1
	ld de, $dc79
	ld bc, $0102
	call PrintNum
	pop af
	ld [Options], a
	ret
; 24bcf

String24bcf: ; 24bcf
	db "/500@"
String24bd4: ; 24bd4
	db "ボール   こ@"
; 24bdc

Function24bdc: ; 24bdc
	ld hl, TileMap
	ld b, $5
	ld c, $11
	call TextBox
	ret
; 24be7

Function24be7: ; 24be7
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	call Function24bdc
	ld hl, $c505
	ld de, String24c52
	call PlaceString
	ld hl, $c50c
	ld de, $dc79
	ld bc, $4102
	call PrintNum
	ld hl, $c4b5
	ld de, String24c4b
	call PlaceString
	ld a, [$df9c]
	and a
	ld de, String24c59
	jr z, .asm_24c1e
	ld [$d265], a
	call GetPokemonName

.asm_24c1e
	ld hl, $c4bc
	call PlaceString
	ld a, [$df9c]
	and a
	jr z, .asm_24c3e
	ld hl, $c4dd
	ld de, String24c5e
	call PlaceString
	ld a, [$dfbb]
	ld h, b
	ld l, c
	inc hl
	ld c, $3
	call Function3842

.asm_24c3e
	pop af
	ld [Options], a
	ret
; 24c43

String24c43: ; 24c43
	db "ボール   こ@"
String24c4b: ; 24c4b
	db "CAUGHT@"
String24c52: ; 24c52
	db "BALLS:@"
String24c59: ; 24c59
	db "None@"
String24c5e: ; 24c5e
	db "LEVEL@"
; 24c64


Function24c64: ; 24c64
	ld hl, Buffer1
	xor a
	ld [hli], a
	dec a
	ld bc, $000a
	call ByteFill

	ld hl, ApricornBalls
.asm_24c73
	ld a, [hl]
	cp $ff
	jr z, .asm_24c8d
	push hl
	ld [CurItem], a
	ld hl, NumItems
	call PickUpItem
	pop hl
	jr nc, .asm_24c89
	ld a, [hl]
	call Function24c94
.asm_24c89
	inc hl
	inc hl
	jr .asm_24c73

.asm_24c8d
	ld a, [Buffer1]
	and a
	ret nz
	scf
	ret
; 24c94

Function24c94: ; 24c94
	push hl
	ld hl, Buffer1
	inc [hl]
	ld e, [hl]
	ld d, 0
	add hl, de
	ld [hl], a
	pop hl
	ret
; 24ca0

ApricornBalls: ; 24ca0
	db RED_APRICORN, LEVEL_BALL
	db BLU_APRICORN, LURE_BALL
	db YLW_APRICORN, MOON_BALL
	db GRN_APRICORN, FRIEND_BALL
	db WHT_APRICORN, FAST_BALL
	db BLK_APRICORN, HEAVY_BALL
	db PNK_APRICORN, LOVE_BALL
	db $ff
; 24caf


MonMenuOptionStrings: ; 24caf
	db "STATS@"
	db "SWITCH@"
	db "ITEM@"
	db "CANCEL@"
	db "MOVE@"
	db "MAIL@"
	db "ERROR!@"
; 24cd9

MonMenuOptions: ; 24cd9

; Moves
	db 0,  1, CUT
	db 0,  2, FLY
	db 0,  3, SURF
	db 0,  4, STRENGTH
	db 0,  6, FLASH
	db 0,  5, WATERFALL
	db 0,  7, WHIRLPOOL
	db 0,  8, DIG
	db 0,  9, TELEPORT
	db 0, 10, SOFTBOILED
	db 0, 11, HEADBUTT
	db 0, 12, ROCK_SMASH
	db 0, 13, MILK_DRINK
	db 0, 14, SWEET_SCENT

; Options
	db 1, 15, 1 ; STATS
	db 1, 16, 2 ; SWITCH
	db 1, 17, 3 ; ITEM
	db 1, 18, 4 ; CANCEL
	db 1, 19, 5 ; MOVE
	db 1, 20, 6 ; MAIL
	db 1, 21, 7 ; ERROR!

	db $ff
; 24d19

Function24d19: ; 24d19
	xor a
	ld [hBGMapMode], a
	call Function24dd4
	callba Function8ea4a
	ld hl, MenuDataHeader_0x24d3f
	call LoadMenuDataHeader
	call Function24d47
	call Function24d91

	ld a, 1
	ld [hBGMapMode], a
	call Function24d59
	ld [MenuSelection], a

	call Function1c07
	ret
; 24d3f

MenuDataHeader_0x24d3f: ; 24d3f
	db $40 ; tile backup
	db 00, 06 ; start coords
	db 17, 19 ; end coords
	dw $0000
	db 1 ; default option
; 24d47

Function24d47: ; 24d47
	ld a, [Buffer1]
	inc a
	add a
	ld b, a
	ld a, [$cf84]
	sub b
	inc a
	ld [$cf82], a
	call Function1cbb
	ret
; 24d59

Function24d59: ; 24d59
.asm_24d59
	ld a, $a0
	ld [$cf91], a
	ld a, [Buffer1]
	ld [$cf92], a
	call Function1c10
	ld hl, $cfa5
	set 6, [hl]
	call Function1bc9
	ld de, SFX_READ_TEXT_2
	call StartSFX
	ld a, [hJoyPressed]
	bit 0, a ; A
	jr nz, .asm_24d84
	bit 1, a ; B
	jr nz, .asm_24d81
	jr .asm_24d59

.asm_24d81
	ld a, 18 ; CANCEL
	ret

.asm_24d84
	ld a, [$cfa9]
	dec a
	ld c, a
	ld b, 0
	ld hl, Buffer2
	add hl, bc
	ld a, [hl]
	ret
; 24d91

Function24d91: ; 24d91
	call Function1cfd
	ld bc, $002a
	add hl, bc
	ld de, Buffer2
.asm_24d9b
	ld a, [de]
	inc de
	cp $ff
	ret z
	push de
	push hl
	call Function24db0
	pop hl
	call PlaceString
	ld bc, $0028
	add hl, bc
	pop de
	jr .asm_24d9b
; 24db0

Function24db0: ; 24db0
	ld hl, MonMenuOptions + 1
	ld de, $0003
	call IsInArray
	dec hl
	ld a, [hli]
	cp $1
	jr z, .asm_24dc8
	inc hl
	ld a, [hl]
	ld [$d265], a
	call GetMoveName
	ret

.asm_24dc8
	inc hl
	ld a, [hl]
	dec a
	ld hl, MonMenuOptionStrings
	call GetNthString
	ld d, h
	ld e, l
	ret
; 24dd4

Function24dd4: ; 24dd4
	call Function24e68
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_24e3f
	ld a, [InLinkBattle]
	and a
	jr nz, .asm_24e03
	ld a, $2
	call GetPartyParamLocation
	ld d, h
	ld e, l
	ld c, $4
.asm_24ded
	push bc
	push de
	ld a, [de]
	and a
	jr z, .asm_24dfd
	push hl
	call Function24e52
	pop hl
	jr nc, .asm_24dfd
	call Function24e83

.asm_24dfd
	pop de
	inc de
	pop bc
	dec c
	jr nz, .asm_24ded

.asm_24e03
	ld a, $f
	call Function24e83
	ld a, $10
	call Function24e83
	ld a, $13
	call Function24e83
	ld a, [InLinkBattle]
	and a
	jr nz, .asm_24e2f
	push hl
	ld a, $1
	call GetPartyParamLocation
	ld d, [hl]
	callba Functionb9e76
	pop hl
	ld a, $14
	jr c, .asm_24e2c
	ld a, $11

.asm_24e2c
	call Function24e83

.asm_24e2f
	ld a, [Buffer1]
	cp $8
	jr z, .asm_24e3b
	ld a, $12
	call Function24e83

.asm_24e3b
	call Function24e76
	ret

.asm_24e3f
	ld a, $f
	call Function24e83
	ld a, $10
	call Function24e83
	ld a, $12
	call Function24e83
	call Function24e76
	ret
; 24e52

Function24e52: ; 24e52
	ld b, a
	ld hl, MonMenuOptions
.asm_24e56
	ld a, [hli]
	cp $ff
	jr z, .asm_24e67
	cp $1
	jr z, .asm_24e67
	ld d, [hl]
	inc hl
	ld a, [hli]
	cp b
	jr nz, .asm_24e56
	ld a, d
	scf

.asm_24e67
	ret
; 24e68

Function24e68: ; 24e68
	xor a
	ld [Buffer1], a
	ld hl, Buffer2
	ld bc, $0009
	call ByteFill
	ret
; 24e76

Function24e76: ; 24e76
	ld a, [Buffer1]
	ld e, a
	ld d, $0
	ld hl, Buffer2
	add hl, de
	ld [hl], $ff
	ret
; 24e83

Function24e83: ; 24e83
	push hl
	push de
	push af
	ld a, [Buffer1]
	ld e, a
	inc a
	ld [Buffer1], a
	ld d, $0
	ld hl, Buffer2
	add hl, de
	pop af
	ld [hl], a
	pop de
	pop hl
	ret
; 24e99

Function24e99: ; 24e99
; BattleMonMenu
	ld hl, MenuDataHeader_0x24ed4
	call Function1d3c
	xor a
	ld [hBGMapMode], a
	call Function1cbb
	call Function1ad2
	call Function1c89
	call WaitBGMap
	call Function1c66
	ld a, [$cf91]
	bit 7, a
	jr z, .asm_24ed0
	call Function1c10
	ld hl, $cfa5
	set 6, [hl]
	call Function1bc9
	ld de, SFX_READ_TEXT_2
	call StartSFX
	ld a, [hJoyPressed]
	bit 1, a
	jr z, .asm_24ed2
	ret z

.asm_24ed0
	scf
	ret

.asm_24ed2
	and a
	ret
; 24ed4

MenuDataHeader_0x24ed4: ; 24ed4
	db $00 ; flags
	db 11, 11 ; start coords
	db 17, 19 ; end coords
	dw MenuData2_0x24edc
	db 1 ; default option
; 24edc

MenuData2_0x24edc: ; 24edc
	db $c0 ; flags
	db 3 ; items
	db "SWITCH@"
	db "STATS@"
	db "CANCEL@"
; 24ef2


Function24ef2: ; 4ef2
	ld hl, MenuDataHeader_0x24f2c
	call LoadMenuDataHeader
	ld a, [$d0d2]
	ld [$cf88], a
	call Function2039
	ld a, [$cf88]
	ld [$d0d2], a
	call Function1c07
	ret
; 24f0b


Function24f0b: ; 24f0b
; Safari battle menu (untranslated).
	ld hl, MenuDataHeader_0x24f4e
	call LoadMenuDataHeader
	jr Function24f19
; 24f13

Function24f13: ; 24f13
; Park battle menu.
	ld hl, MenuDataHeader_0x24f89
	call LoadMenuDataHeader
; 24f19

Function24f19: ; 24f19
	ld a, [$d0d2]
	ld [$cf88], a
	call Function202a
	ld a, [$cf88]
	ld [$d0d2], a
	call Function1c07
	ret
; 24f2c


MenuDataHeader_0x24f2c: ; 24f2c
	db $40 ; flags
	db 12, 08 ; start coords
	db 17, 19 ; end coords
	dw MenuData_0x24f34
	db 1 ; default option
; 24f34

MenuData_0x24f34: ; 0x24f34
	db $81 ; flags
	dn 2, 2 ; rows, columns
	db 6 ; spacing
	dbw BANK(Strings24f3d), Strings24f3d
	dbw $09, $0000
; 0x24f3d

Strings24f3d: ; 0x24f3d
	db "FIGHT@"
	db $4a, "@"
	db "PACK@"
	db "RUN@"
; 24f4e


MenuDataHeader_0x24f4e: ; 24f4e
	db $40 ; flags
	db 12, 00 ; start coords
	db 17, 19 ; end coords
	dw MenuData_0x24f56
	db 1 ; default option
; 24f56

MenuData_0x24f56: ; 24f56
	db $81 ; flags
	dn 2, 2 ; rows, columns
	db 11 ; spacing
	dbw BANK(Strings24f5f), Strings24f5f
	dbw BANK(Function24f7c), Function24f7c
; 24f5f

Strings24f5f: ; 24f5f
	db "サファりボール×  @" ; "SAFARI BALL×  @"
	db "エサをなげる@" ; "THROW BAIT"
	db "いしをなげる@" ; "THROW ROCK"
	db "にげる@" ; "RUN"
; 24f7c

Function24f7c: ; 24f7c
	ld hl, $c5b5
	ld de, $dc79
	ld bc, $8102
	call PrintNum
	ret
; 24f89


MenuDataHeader_0x24f89: ; 24f89
	db $40 ; flags
	db 12, 02 ; start coords
	db 17, 19 ; end coords
	dw MenuData_0x24f91
	db 1 ; default option
; 24f91

MenuData_0x24f91: ; 24f91
	db $81 ; flags
	dn 2, 2 ; rows, columns
	db 12 ; spacing
	dbw BANK(Strings24f9a), Strings24f9a
	dbw BANK(Function24fb2), Function24fb2
; 24f9a

Strings24f9a: ; 24f9a
	db "FIGHT@"
	db $4a, "@"
	db "PARKBALL×  @"
	db "RUN@"
; 24fb2

Function24fb2: ; 24fb2
	ld hl, $c5ed
	ld de, $dc79
	ld bc, $8102
	call PrintNum
	ret
; 24fbf


Function24fbf: ; 24fbf
	ld hl, $50ed
	call LoadMenuDataHeader
	call Function24ff9
	ret
; 24fc9


Function24fc9: ; 24fc9
	callba GetItemPrice
	ld a, d
	ld [Buffer1], a
	ld a, e
	ld [Buffer2], a
	ld hl, $50f5
	call LoadMenuDataHeader
	call Function24ff9
	ret
; 24fe1

Function24fe1: ; 24fe1
	callba GetItemPrice
	ld a, d
	ld [Buffer1], a
	ld a, e
	ld [Buffer2], a
	ld hl, $50fd
	call LoadMenuDataHeader
	call Function24ff9
	ret
; 24ff9

Function24ff9: ; 24ff9
	ld a, $1
	ld [$d10c], a
.asm_24ffe
	call Function25072
	call Function2500e
	jr nc, .asm_24ffe
	cp $ff
	jr nz, .asm_2500c
	scf
	ret

.asm_2500c
	and a
	ret
; 2500e

Function2500e: ; 2500e
	call Function354b
	bit 1, c
	jr nz, .asm_2502b
	bit 0, c
	jr nz, .asm_2502f
	bit 7, c
	jr nz, .asm_25033
	bit 6, c
	jr nz, .asm_2503f
	bit 5, c
	jr nz, .asm_2504d
	bit 4, c
	jr nz, .asm_2505f
	and a
	ret

.asm_2502b
	ld a, $ff
	scf
	ret

.asm_2502f
	ld a, $0
	scf
	ret

.asm_25033
	ld hl, $d10c
	dec [hl]
	jr nz, .asm_2503d
	ld a, [$d10d]
	ld [hl], a

.asm_2503d
	and a
	ret

.asm_2503f
	ld hl, $d10c
	inc [hl]
	ld a, [$d10d]
	cp [hl]
	jr nc, .asm_2504b
	ld [hl], $1

.asm_2504b
	and a
	ret

.asm_2504d
	ld a, [$d10c]
	sub $a
	jr c, .asm_25058
	jr z, .asm_25058
	jr .asm_2505a

.asm_25058
	ld a, $1

.asm_2505a
	ld [$d10c], a
	and a
	ret

.asm_2505f
	ld a, [$d10c]
	add $a
	ld b, a
	ld a, [$d10d]
	cp b
	jr nc, .asm_2506c
	ld b, a

.asm_2506c
	ld a, b
	ld [$d10c], a
	and a
	ret
; 25072

Function25072: ; 25072
	call Function1cbb
	call Function1cfd
	ld de, $0015
	add hl, de
	ld [hl], $f1
	inc hl
	ld de, $d10c
	ld bc, $8102
	call PrintNum
	ld a, [$cf86]
	ld e, a
	ld a, [$cf87]
	ld d, a
	ld a, [$cf8a]
	call FarCall_de
	ret
; 25097


Function25097: ; 25097
	ret
; 25098

Function25098: ; 25098
	call Function250a9
	call Function250d1
	ret
; 2509f

Function2509f: ; 2509f
	call Function250a9
	call Function250c1
	call Function250d1
	ret
; 250a9

Function250a9: ; 250a9
	xor a
	ld [hMultiplicand], a
	ld a, [Buffer1]
	ld [$ffb5], a
	ld a, [Buffer2]
	ld [$ffb6], a
	ld a, [$d10c]
	ld [hMultiplier], a
	push hl
	call Multiply
	pop hl
	ret
; 250c1

Function250c1: ; 250c1
	push hl
	ld hl, hMultiplicand
	ld a, [hl]
	srl a
	ld [hli], a
	ld a, [hl]
	rra
	ld [hli], a
	ld a, [hl]
	rra
	ld [hl], a
	pop hl
	ret
; 250d1

Function250d1: ; 250d1
	push hl
	ld hl, $ffc3
	ld a, [hMultiplicand]
	ld [hli], a
	ld a, [$ffb5]
	ld [hli], a
	ld a, [$ffb6]
	ld [hl], a
	pop hl
	inc hl
	ld de, $ffc3
	ld bc, $2306
	call PrintNum
	call WaitBGMap
	ret
; 250ed


INCBIN "baserom.gbc", $250ed, $265d3 - $250ed


ProfOaksPC: ; 0x265d3
	ld hl, OakPCText1
	call Function1d4f
	call Function1dcf
	jr c, .shutdown
	call ProfOaksPCBoot ; player chose "yes"?
.shutdown
	ld hl, OakPCText4
	call PrintText
	call Functiona36
	call Function1c07
	ret
; 0x265ee

ProfOaksPCBoot ; 0x265ee
	ld hl, OakPCText2
	call PrintText
	call Rate
	call StartSFX ; sfx loaded by previous Rate function call
	call Functiona36
	call WaitSFX
	ret
; 0x26601

Function26601: ; 0x26601
	call Rate
	push de
	ld de, MUSIC_NONE
	call StartMusic
	pop de
	call StartSFX
	call Functiona36
	call WaitSFX
	ret
; 0x26616

Rate: ; 0x26616
; calculate Seen/Owned
	ld hl, PokedexCaught
	ld b, EndPokedexCaught - PokedexCaught
	call CountSetBits
	ld [DefaultFlypoint], a
	ld hl, PokedexSeen
	ld b, EndPokedexSeen - PokedexSeen
	call CountSetBits
	ld [$d003], a

; print appropriate rating
	call ClearOakRatingBuffers
	ld hl, OakPCText3
	call PrintText
	call Functiona36
	ld a, [$d003]
	ld hl, OakRatings
	call FindOakRating
	push de
	call PrintText
	pop de
	ret
; 0x26647

ClearOakRatingBuffers: ; 0x26647
	ld hl, StringBuffer3
	ld de, DefaultFlypoint
	call ClearOakRatingBuffer
	ld hl, StringBuffer4
	ld de, $d003
	call ClearOakRatingBuffer
	ret
; 0x2665a

ClearOakRatingBuffer: ; 0x2665a
	push hl
	ld a, "@"
	ld bc, $000d
	call ByteFill
	pop hl
	ld bc, $4103
	call PrintNum
	ret
; 0x2666b

FindOakRating: ; 0x2666b
; return sound effect in de
; return text pointer in hl
	nop
	ld c, a
.loop
	ld a, [hli]
	cp c
	jr nc, .match
	inc hl
	inc hl
	inc hl
	inc hl
	jr .loop

.match
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret
; 0x2667f

OakRatings: ; 0x2667f
; db count (if number caught ≤ this number, then this entry is used)
; dw sound effect
; dw text pointer

	db 9
	dw SFX_DEX_FANFARE_LESS_THAN_20
	dw OakRating01

	db 19
	dw SFX_DEX_FANFARE_LESS_THAN_20
	dw OakRating02

	db 34
	dw SFX_DEX_FANFARE_20_49
	dw OakRating03

	db 49
	dw SFX_DEX_FANFARE_20_49
	dw OakRating04

	db 64
	dw SFX_DEX_FANFARE_50_79
	dw OakRating05

	db 79
	dw SFX_DEX_FANFARE_50_79
	dw OakRating06

	db 94
	dw SFX_DEX_FANFARE_80_109
	dw OakRating07

	db 109
	dw SFX_DEX_FANFARE_80_109
	dw OakRating08

	db 124
	dw SFX_CAUGHT_MON
	dw OakRating09

	db 139
	dw SFX_CAUGHT_MON
	dw OakRating10

	db 154
	dw SFX_DEX_FANFARE_140_169
	dw OakRating11

	db 169
	dw SFX_DEX_FANFARE_140_169
	dw OakRating12

	db 184
	dw SFX_DEX_FANFARE_170_199
	dw OakRating13

	db 199
	dw SFX_DEX_FANFARE_170_199
	dw OakRating14

	db 214
	dw SFX_DEX_FANFARE_200_229
	dw OakRating15

	db 229
	dw SFX_DEX_FANFARE_200_229
	dw OakRating16

	db 239
	dw SFX_DEX_FANFARE_230_PLUS
	dw OakRating17

	db 248
	dw SFX_DEX_FANFARE_230_PLUS
	dw OakRating18

	db 255
	dw SFX_DEX_FANFARE_230_PLUS
	dw OakRating19

OakPCText1: ; 0x266de
	TX_FAR _OakPCText1
	db "@"

OakPCText2: ; 0x266e3
	TX_FAR _OakPCText2
	db "@"

OakPCText3: ; 0x266e8
	TX_FAR _OakPCText3
	db "@"

OakRating01:
	TX_FAR _OakRating01
	db "@"

OakRating02:
	TX_FAR _OakRating02
	db "@"

OakRating03:
	TX_FAR _OakRating03
	db "@"

OakRating04:
	TX_FAR _OakRating04
	db "@"

OakRating05:
	TX_FAR _OakRating05
	db "@"

OakRating06:
	TX_FAR _OakRating06
	db "@"

OakRating07:
	TX_FAR _OakRating07
	db "@"

OakRating08:
	TX_FAR _OakRating08
	db "@"

OakRating09:
	TX_FAR _OakRating09
	db "@"

OakRating10:
	TX_FAR _OakRating10
	db "@"

OakRating11:
	TX_FAR _OakRating11
	db "@"

OakRating12:
	TX_FAR _OakRating12
	db "@"

OakRating13:
	TX_FAR _OakRating13
	db "@"

OakRating14:
	TX_FAR _OakRating14
	db "@"

OakRating15:
	TX_FAR _OakRating15
	db "@"

OakRating16:
	TX_FAR _OakRating16
	db "@"

OakRating17:
	TX_FAR _OakRating17
	db "@"

OakRating18:
	TX_FAR _OakRating18
	db "@"

OakRating19:
	TX_FAR _OakRating19
	db "@"

OakPCText4: ; 0x2674c
	TX_FAR _OakPCText4
	db "@"

INCBIN "baserom.gbc", $26751, $2675c - $26751

_KrisDecorationMenu: ; 0x2675c
	ld a, [$cf76]
	push af
	ld hl, $679a
	call LoadMenuDataHeader
	xor a
	ld [$d1ee], a
	ld a, $1
	ld [$d1ef], a
.asm_2676f
	ld a, [$d1ef]
	ld [$cf88], a
	call $6806
	call Function1e5d
	ld a, [$cfa9]
	ld [$d1ef], a
	jr c, .asm_2678e
	ld a, [MenuSelection]
	ld hl, $67aa
	call Function1fa7
	jr nc, .asm_2676f

.asm_2678e
	call Function1c07
	pop af
	ld [$cf76], a
	ld a, [$d1ee]
	ld c, a
	ret
; 0x2679a

INCBIN "baserom.gbc", $2679a, $269dd - $2679a


Function269dd: ; 269dd
	ld hl, $6a4f
	ld bc, $0006
	call AddNTimes
	ret
; 269e7

Function269e7: ; 269e7
	push hl
	call Function269dd
	call Function26c72
	pop hl
	call CopyName2
	ret
; 269f3

INCBIN "baserom.gbc", $269f3, $26a30 - $269f3


Function26a30: ; 26a30
	call Function269dd
	ld de, $0003
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ret
; 26a3b

Function26a3b: ; 26a3b
	push bc
	call Function26a30
	pop bc
	call EventFlagAction
	ret
; 26a44

INCBIN "baserom.gbc", $26a44, $26b8d - $26a44


DecorationNames: ; 26b8d
	db "CANCEL@"
	db "PUT IT AWAY@"
	db "MAGNAPLANT@"
	db "TROPICPLANT@"
	db "JUMBOPLANT@"
	db "TOWN MAP@"
	db "NES@"
	db "SUPER NES@"
	db "NINTENDO 64@"
	db "VIRTUAL BOY@"
	db "GOLD TROPHY@"
	db "SILVER TROPHY@"
	db "SURF PIKACHU DOLL@"
	db " BED@"
	db " CARPET@"
	db " POSTER@"
	db " DOLL@"
	db "BIG @"
	db "FEATHERY@"
	db "PIKACHU@"
	db "PINK@"
	db "POLKADOT@"
	db "RED@"
	db "BLUE@"
	db "YELLOW@"
	db "GREEN@"
; 26c72

Function26c72: ; 26c72
	ld a, [hli]
	ld e, [hl]
	ld bc, StringBuffer2
	push bc
	ld hl, Table26c7e
	rst JumpTable
	pop de
	ret
; 26c7e

Table26c7e: ; 26c7e
	dw Function26c8c
	dw Function26c8d
	dw Function26c90
	dw Function26c97
	dw Function26c9e
	dw Function26ca6
	dw Function26cae
; 26c8c


Function26c8c: ; 26c8c
	ret
; 26c8d

Function26c8d: ; 26c8d
	ld a, e
	jr Function26cca

Function26c90: ; 26c90
	call Function26c8d
	ld a, $d
	jr Function26cca

Function26c97: ; 26c97
	call Function26c8d
	ld a, $e
	jr Function26cca

Function26c9e: ; 26c9e
	ld a, e
	call Function26cc0
	ld a, $f
	jr Function26cca

Function26ca6: ; 26ca6
	ld a, e
	call Function26cc0
	ld a, $10
	jr Function26cca

Function26cae: ; 26cae
	push de
	ld a, $11
	call Function26cca
	pop de
	ld a, e
	jr Function26cc0

Function26cb8: ; 26cb8
	push de
	call Function26cca
	pop de
	ld a, e
	jr Function26cca

Function26cc0: ; 26cc0
	push bc
	ld [$d265], a
	call GetPokemonName
	pop bc
	jr Function26cda

Function26cca: ; 26cca
	call $6ccf
	jr Function26cda

Function26ccf: ; 26ccf
	push bc
	ld hl, DecorationNames
	call GetNthString
	ld d, h
	ld e, l
	pop bc
	ret

Function26cda: ; 26cda
	ld h, b
	ld l, c
	call CopyName2
	dec hl
	ld b, h
	ld c, l
	ret
; 26ce3

INCBIN "baserom.gbc", $26ce3, $26eea - $26ce3


Function26eea: ; 26eea
	ld a, c
	ld h, d
	ld l, e
	call Function269e7
	ret
; 26ef1

Function26ef1: ; 26ef1
	ld a, c
	jp Function26a3b
; 26ef5

INCBIN "baserom.gbc", $26ef5, $26f02 - $26ef5


Function26f02: ; 26f02
	ld a, c
	call Function26f0c
	ld b, $1
	call Function26a3b
	ret
; 26f0c

Function26f0c: ; 26f0c
	push hl
	push de
	ld e, a
	ld d, $0
	ld hl, $6f2b
	add hl, de
	ld a, [hl]
	pop de
	pop hl
	ret
; 26f19

INCBIN "baserom.gbc", $26f19, $26f59 - $26f19


Function26f59: ; 26f59
	ld a, b
	ld hl, $6f5f
	rst JumpTable
	ret
; 26f5f

Table26f5f: ; 26f5f
	dw Function26f69
	dw Function26fb9
	dw Function26fbe
	dw Function26fdd
	dw Function26fc3
; 26f69

Function26f69: ; 26f69
	ld a, [Poster]
	ld hl, $6f84
	ld de, $0003
	call IsInArray
	jr c, .asm_26f7d
	ld de, $6fb8
	ld b, $9
	ret

.asm_26f7d
	ld b, $9
	inc hl
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ret
; 26f84

INCBIN "baserom.gbc", $26f84, $26fb9 - $26f84


Function26fb9: ; 26fb9
	ld a, [LeftOrnament]
	jr Function26fc8

Function26fbe: ; 26fbe
	ld a, [RightOrnament]
	jr Function26fc8

Function26fc3: ; 26fc3
	ld a, [Console]
	jr Function26fc8

Function26fc8: ; 26fc8
	ld c, a
	ld de, StringBuffer3
	call Function26eea
	ld b, $9
	ld de, $6fd5
	ret
; 26fd5

INCBIN "baserom.gbc", $26fd5, $26fdd - $26fd5


Function26fdd: ; 26fdd
	ld b, $9
	ld de, $6fe3
	ret
; 26fe3

INCBIN "baserom.gbc", $26fe3, $2709e - $26fe3


Function2709e: ; 2709e
	ld a, [CurPartyMon]
	ld hl, PartyMon1CaughtLocation
	call GetPartyLocation
	ld a, [hl]
	and $7f
	ld d, a
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call GetWorldMapLocation
	cp d
	ld c, $1
	jr nz, .asm_270bd
	ld c, $13

.asm_270bd
	callab ChangeHappiness
	ret
; 270c4

INCLUDE "trainers/dvs.asm"

Function2715c: ; 2715c
	call WhiteBGMap
	call ClearTileMap
	ld a, [BattleType]
	cp $3
	jr z, .asm_27171
	callba Function3f43d
	jr .asm_27177

.asm_27171
	callba GetBattleBackpic

.asm_27177
	callba Function3f47c
	callba Function3ed9f
	call ClearSGB
	call Function1c17
	call Function1d6e
	call WaitBGMap
	jp Function32f9
; 27192

Function27192: ; 27192
	push hl
	push de
	push bc
	ld a, [hBattleTurn]
	and a
	ld hl, OTPartyMon1Item
	ld de, EnemyMonItem
	ld a, [CurOTMon]
	jr z, .asm_271ac
	ld hl, PartyMon1Item
	ld de, BattleMonItem
	ld a, [CurBattleMon]

.asm_271ac
	push hl
	push af
	ld a, [de]
	ld b, a
	callba GetItem
	ld hl, $71de
.asm_271b9
	ld a, [hli]
	cp b
	jr z, .asm_271c6
	inc a
	jr nz, .asm_271b9
	pop af
	pop hl
	pop bc
	pop de
	pop hl
	ret

.asm_271c6
	xor a
	ld [de], a
	pop af
	pop hl
	call GetPartyLocation
	ld a, [hBattleTurn]
	and a
	jr nz, .asm_271d8
	ld a, [IsInBattle]
	dec a
	jr z, .asm_271da

.asm_271d8
	ld [hl], $0

.asm_271da
	pop bc
	pop de
	pop hl
	ret
; 271de

INCBIN "baserom.gbc", $271de, $271f4 - $271de

MoveEffectsPointers: ; 271f4
INCLUDE "battle/moves/move_effects_pointers.asm"

MoveEffects: ; 2732e
INCLUDE "battle/moves/move_effects.asm"

INCBIN "baserom.gbc", $27a28, $27a2d - $27a28


SECTION "bankA",ROMX,BANK[$A]

INCBIN "baserom.gbc", $28000, $2a0e7 - $28000

Function2a0e7: ; 2a0e7
; Try to trigger a wild encounter.
	call Function2a103
	jr nc, .asm_2a0f8
	call Function2a14f
	jr nz, .asm_2a0f8
	call Function2a1df
	jr nc, .asm_2a0f8
	xor a
	ret

.asm_2a0f8
	xor a
	ld [$d22e], a
	ld [BattleType], a
	ld a, 1
	and a
	ret
; 2a103

Function2a103: ; 2a103
	call Function2a111
	call Function2a124
	call Function2a138
	call Random
	cp b
	ret
; 2a111

Function2a111: ; 2a111
	ld hl, $d25a
	call Function1852
	ld a, 3
	jr z, .asm_2a11e
	ld a, [TimeOfDay]
.asm_2a11e
	ld c, a
	ld b, 0
	add hl, bc
	ld b, [hl]
	ret
; 2a124

Function2a124: ; 2a124
; Pokemon March and Ruins of Alph signal double encounter rate.
; Pokemon Lullaby halves encounter rate.
	ld a, [CurMusic]
	cp MUSIC_POKEMON_MARCH
	jr z, .asm_2a135
	cp MUSIC_RUINS_OF_ALPH_RADIO
	jr z, .asm_2a135
	cp MUSIC_POKEMON_LULLABY
	ret nz
	srl b
	ret

.asm_2a135
	sla b
	ret
; 2a138

Function2a138: ; 2a138
; Cleanse Tag halves encounter rate.
	ld hl, PartyMon1Item
	ld de, PartyMon2 - PartyMon1
	ld a, [PartyCount]
	ld c, a
.next
	ld a, [hl]
	cp CLEANSE_TAG
	jr z, .asm_2a14c
	add hl, de
	dec c
	jr nz, .next
	ret

.asm_2a14c
	srl b
	ret
; 2a14f

Function2a14f: ; 2a14f
	call Function2a200
	jp nc, .asm_2a1c1
	call Function2a2ce
	jp c, .asm_2a1c9

	inc hl
	inc hl
	inc hl
	call Function1852
	ld de, $61d9
	jr z, .asm_2a174
	inc hl
	inc hl
	ld a, [TimeOfDay]
	ld bc, $e
	call AddNTimes
	ld de, $61cb

.asm_2a174
	push hl
.asm_2a175
	call Random
	cp 100
	jr nc, .asm_2a175
	inc a
	ld b, a
	ld h, d
	ld l, e
.asm_2a180
	ld a, [hli]
	cp b
	jr nc, .asm_2a187
	inc hl
	jr .asm_2a180

.asm_2a187
	ld c, [hl]
	ld b, 0
	pop hl
	add hl, bc
	ld a, [hli]
	ld b, a
	call Function1852
	jr nz, .asm_2a1aa

	call Random
	cp 89
	jr c, .asm_2a1aa
	inc b
	cp 165
	jr c, .asm_2a1aa
	inc b
	cp 216
	jr c, .asm_2a1aa
	inc b
	cp 242
	jr c, .asm_2a1aa
	inc b

.asm_2a1aa
	ld a, b
	ld [CurPartyLevel], a
	ld b, [hl]
	call Function2a4a0
	jr c, .asm_2a1c1

	ld a, b
	cp UNOWN
	jr nz, .asm_2a1bf

	ld a, [UnlockedUnowns]
	and a
	jr z, .asm_2a1c1

.asm_2a1bf
	jr .asm_2a1c5

.asm_2a1c1
	ld a, 1
	and a
	ret

.asm_2a1c5
	ld a, b
	ld [$d22e], a

.asm_2a1c9
	xor a
	ret
; 2a1cb


INCBIN "baserom.gbc", $2a1cb, $2a1df - $2a1cb


Function2a1df: ; 2a1df
	ld a, [$dca1]
	and a
	jr z, .asm_2a1fe
	ld hl, PartyMon1CurHP
	ld bc, PartyMon2 - PartyMon1 - 1
.asm_2a1eb
	ld a, [hli]
	or [hl]
	jr nz, .asm_2a1f2
	add hl, bc
	jr .asm_2a1eb

.asm_2a1f2
; to PartyMonLevel
	dec hl
	dec hl
	dec hl
	dec hl

	ld a, [CurPartyLevel]
	cp [hl]
	jr nc, .asm_2a1fe
	and a
	ret

.asm_2a1fe
	scf
	ret
; 2a200

Function2a200: ; 2a200
	call Function1852
	jr z, .asm_2a21d
	ld hl, WildMons5
	ld bc, $002f
	call .asm_2a23d
	ret c
	ld hl, WildMons1
	ld de, WildMons3
	call .asm_2a235
	ld bc, $002f
	jr .asm_2a27a

.asm_2a21d
	ld hl, WildMons6
	ld bc, $0009
	call .asm_2a23d
	ret c
	ld hl, WildMons2
	ld de, WildMons4
	call .asm_2a235
	ld bc, $0009
	jr .asm_2a27a

.asm_2a235
	call Function2f17
	and a
	ret z
	ld h, d
	ld l, e
	ret

.asm_2a23d
	call Function2a27f
	push hl
	ld hl, $dc20
	bit 2, [hl]
	pop hl
	jr z, .asm_2a25c
	ld a, [$dfcc]
	cp d
	jr nz, .asm_2a25c
	ld a, [$dfcd]
	cp e
	jr nz, .asm_2a25c
	call Function2a288
	jr nc, .asm_2a278
	scf
	ret

.asm_2a25c
	push hl
	ld hl, $dc20
	bit 3, [hl]
	pop hl
	jr z, .asm_2a278
	ld a, [$dc5a]
	cp d
	jr nz, .asm_2a278
	ld a, [$dc5b]
	cp e
	jr nz, .asm_2a278
	call Function2a288
	jr nc, .asm_2a278
	scf
	ret

.asm_2a278
	and a
	ret

.asm_2a27a
	call Function2a27f
	jr Function2a288
; 2a27f

Function2a27f: ; 2a27f
	ld a, [MapGroup]
	ld d, a
	ld a, [MapNumber]
	ld e, a
	ret
; 2a288

Function2a288: ; 2a288
	push hl
	ld a, [hl]
	inc a
	jr z, .asm_2a29a
	ld a, d
	cp [hl]
	jr nz, .asm_2a296
	inc hl
	ld a, e
	cp [hl]
	jr z, .asm_2a29d

.asm_2a296
	pop hl
	add hl, bc
	jr Function2a288

.asm_2a29a
	pop hl
	and a
	ret

.asm_2a29d
	pop hl
	scf
	ret
; 2a2a0


InitRoamMons: ; 2a2a0
; initialize RoamMon structs

; species
	ld a, RAIKOU
	ld [RoamMon1Species], a
	ld a, ENTEI
	ld [RoamMon2Species], a
;	ld a, SUICUNE
;	ld [RoamMon3Species], a

; level
	ld a, 40
	ld [RoamMon1Level], a
	ld [RoamMon2Level], a
;	ld [RoamMon3Level], a

; raikou starting map
	ld a, GROUP_ROUTE_42
	ld [RoamMon1MapGroup], a
	ld a, MAP_ROUTE_42
	ld [RoamMon1MapNumber], a

; entei starting map
	ld a, GROUP_ROUTE_37
	ld [RoamMon2MapGroup], a
	ld a, MAP_ROUTE_37
	ld [RoamMon2MapNumber], a

; suicune starting map
;	ld a, GROUP_ROUTE_38
;	ld [RoamMon3MapGroup], a
;	ld a, MAP_ROUTE_38
;	ld [RoamMon3MapNumber], a

; hp
	xor a ; generate new stats
	ld [RoamMon1CurHP], a
	ld [RoamMon2CurHP], a
;	ld [RoamMon3CurHP], a

	ret
; 2a2ce


Function2a2ce: ; 2a2ce
	push hl
	call Function1852
	jr z, .asm_2a30a
	call Function2a27f
	call Random
	cp 100
	jr nc, .asm_2a30a
	and 3
	jr z, .asm_2a30a
	dec a
	ld hl, RoamMon1MapGroup
	ld c, a
	ld b, 0
	ld a, 7
	call AddNTimes
	ld a, d
	cp [hl]
	jr nz, .asm_2a30a
	inc hl
	ld a, e
	cp [hl]
	jr nz, .asm_2a30a
	dec hl
	dec hl
	dec hl
	ld a, [hli]
	ld [$d22e], a
	ld a, [hl]
	ld [CurPartyLevel], a
	ld a, BATTLETYPE_ROAMING
	ld [BattleType], a
	pop hl
	scf
	ret

.asm_2a30a
	pop hl
	and a
	ret
; 2a30d


Function2a30d: ; 2a30d
	ld a, [RoamMon1MapGroup]
	cp $ff
	jr z, .asm_2a324
	ld b, a
	ld a, [RoamMon1MapNumber]
	ld c, a
	call Function2a355
	ld a, b
	ld [RoamMon1MapGroup], a
	ld a, c
	ld [RoamMon1MapNumber], a

.asm_2a324
	ld a, [RoamMon2MapGroup]
	cp $ff
	jr z, .asm_2a33b
	ld b, a
	ld a, [RoamMon2MapNumber]
	ld c, a
	call Function2a355
	ld a, b
	ld [RoamMon2MapGroup], a
	ld a, c
	ld [RoamMon2MapNumber], a

.asm_2a33b
	ld a, [RoamMon3MapGroup]
	cp $ff
	jr z, .asm_2a352
	ld b, a
	ld a, [RoamMon3MapNumber]
	ld c, a
	call Function2a355
	ld a, b
	ld [RoamMon3MapGroup], a
	ld a, c
	ld [RoamMon3MapNumber], a

.asm_2a352
	jp Function2a3f6
; 2a355


Function2a355: ; 2a355
	ld hl, $640f
.asm_2a358
	ld a, [hl]
	cp $ff
	ret z
	ld a, b
	cp [hl]
	jr nz, .asm_2a365
	inc hl
	ld a, c
	cp [hl]
	jr z, .asm_2a36b

.asm_2a365
	ld a, [hli]
	and a
	jr nz, .asm_2a365
	jr .asm_2a358

.asm_2a36b
	inc hl
	ld d, h
	ld e, l
.asm_2a36e
	ld h, d
	ld l, e
	call Random
	and $1f
	jr z, .asm_2a3cd
	and $3
	cp [hl]
	jr nc, .asm_2a36e
	inc hl
	ld c, a
	ld b, $0
	add hl, bc
	add hl, bc
	ld a, [$dfe7]
	cp [hl]
	jr nz, .asm_2a390
	inc hl
	ld a, [$dfe6]
	cp [hl]
	jr z, .asm_2a36e
	dec hl

.asm_2a390
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ret

	ld a, [RoamMon1MapGroup]
	cp $ff
	jr z, .asm_2a3a6
	call $63cd
	ld a, b
	ld [RoamMon1MapGroup], a
	ld a, c
	ld [RoamMon1MapNumber], a

.asm_2a3a6
	ld a, [RoamMon2MapGroup]
	cp $ff
	jr z, .asm_2a3b8
	call $63cd
	ld a, b
	ld [RoamMon2MapGroup], a
	ld a, c
	ld [RoamMon2MapNumber], a

.asm_2a3b8
	ld a, [RoamMon3MapGroup]
	cp $ff
	jr z, .asm_2a3ca
	call $63cd
	ld a, b
	ld [RoamMon3MapGroup], a
	ld a, c
	ld [RoamMon3MapNumber], a

.asm_2a3ca
	jp Function2a3f6

.asm_2a3cd
	ld hl, $640f
.asm_2a3d0
	call Random
	and $f
	cp $10
	jr nc, .asm_2a3d0
	inc a
	ld b, a
.asm_2a3db
	dec b
	jr z, .asm_2a3e4
.asm_2a3de
	ld a, [hli]
	and a
	jr nz, .asm_2a3de
	jr .asm_2a3db

.asm_2a3e4
	ld a, [MapGroup]
	cp [hl]
	jr nz, .asm_2a3f2
	inc hl
	ld a, [MapNumber]
	cp [hl]
	jr z, .asm_2a3cd
	dec hl

.asm_2a3f2
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ret
; 2a3f6

Function2a3f6: ; 2a3f6
	ld a, [$dfe4]
	ld [$dfe6], a
	ld a, [$dfe5]
	ld [$dfe7], a
	ld a, [MapNumber]
	ld [$dfe4], a
	ld a, [MapGroup]
	ld [$dfe5], a
	ret
; 2a40f

INCBIN "baserom.gbc", $2a40f, $2a4a0 - $2a40f

Function2a4a0: ; 2a4a0
	and a
	jr z, .asm_2a4a9
	cp $fc
	jr nc, .asm_2a4a9
	and a
	ret

.asm_2a4a9
	scf
	ret
; 2a4ab

INCBIN "baserom.gbc", $2a4ab, $2a5e9 - $2a4ab


WildMons1: ; 0x2a5e9
INCLUDE "stats/wild/johto_grass.asm"

WildMons2: ; 0x2b11d
INCLUDE "stats/wild/johto_water.asm"

WildMons3: ; 0x2b274
INCLUDE "stats/wild/kanto_grass.asm"

WildMons4: ; 0x2b7f7
INCLUDE "stats/wild/kanto_water.asm"

WildMons5: ; 0x2b8d0
INCLUDE "stats/wild/swarm_grass.asm"

WildMons6: ; 0x2b92f
INCLUDE "stats/wild/swarm_water.asm"


Function2b930: ; 2b930
	callba UpdateEnemyMonInParty
	ld hl, PartyMon1CurHP
	call Function2b995
	push bc
	ld hl, OTPartyMon1CurHP
	call Function2b995
	ld a, c
	pop bc
	cp c
	jr z, .asm_2b94c
	jr c, .asm_2b97f
	jr .asm_2b976

.asm_2b94c
	call Function2b9e1
	jr z, .asm_2b98a
	ld a, e
	cp $1
	jr z, .asm_2b976
	cp $2
	jr z, .asm_2b97f
	ld hl, PartyMon1CurHP
	call Function2b9a6
	push de
	ld hl, OTPartyMon1CurHP
	call Function2b9a6
	pop hl
	ld a, d
	cp h
	jr c, .asm_2b976
	jr z, .asm_2b970
	jr .asm_2b97f

.asm_2b970
	ld a, e
	cp l
	jr z, .asm_2b98a
	jr nc, .asm_2b97f

.asm_2b976
	ld a, [$d0ee]
	and $f0
	ld [$d0ee], a
	ret

.asm_2b97f
	ld a, [$d0ee]
	and $f0
	add $1
	ld [$d0ee], a
	ret

.asm_2b98a
	ld a, [$d0ee]
	and $f0
	add $2
	ld [$d0ee], a
	ret
; 2b995

Function2b995: ; 2b995
	ld c, $0
	ld b, $3
	ld de, $002f
.asm_2b99c
	ld a, [hli]
	or [hl]
	jr nz, .asm_2b9a1
	inc c

.asm_2b9a1
	add hl, de
	dec b
	jr nz, .asm_2b99c
	ret
; 2b9a6

Function2b9a6: ; 2b9a6
	ld de, $0000
	ld c, $3
.asm_2b9ab
	ld a, [hli]
	or [hl]
	jr z, .asm_2b9d7
	dec hl
	xor a
	ld [hProduct], a
	ld a, [hli]
	ld [hMultiplicand], a
	ld a, [hli]
	ld [$ffb5], a
	xor a
	ld [$ffb6], a
	ld a, [hli]
	ld b, a
	ld a, [hld]
	srl b
	rr a
	srl b
	rr a
	ld [hMultiplier], a
	ld b, $4
	call Divide
	ld a, [$ffb6]
	add e
	ld e, a
	ld a, [$ffb5]
	adc d
	ld d, a
	dec hl

.asm_2b9d7
	push de
	ld de, $002f
	add hl, de
	pop de
	dec c
	jr nz, .asm_2b9ab
	ret
; 2b9e1

Function2b9e1: ; 2b9e1
	ld hl, PartyMon1CurHP
	call Function2ba01
	jr nz, .asm_2b9f2
	ld hl, OTPartyMon1CurHP
	call Function2ba01
	ld e, $1
	ret

.asm_2b9f2
	ld hl, OTPartyMon1CurHP
	call Function2ba01
	ld e, $0
	ret nz
	ld e, $2
	ld a, $1
	and a
	ret
; 2ba01

Function2ba01: ; 2ba01
	ld d, $3
.asm_2ba03
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	or b
	jr z, .asm_2ba10
	ld a, [hli]
	cp b
	ret nz
	ld a, [hld]
	cp c
	ret nz

.asm_2ba10
	push de
	ld de, $002e
	add hl, de
	pop de
	dec d
	jr nz, .asm_2ba03
	ret
; 2ba1a


ChrisBackpic: ; 2ba1a
INCBIN "gfx/misc/player.lz"
; 2bba1

db 0, 0, 0, 0, 0, 0, 0, 0, 0 ; filler

DudeBackpic: ; 2bbaa
INCBIN "gfx/misc/dude.lz"
; 2bce1


SECTION "bankB",ROMX,BANK[$B]

Function2c000: ; 2c000
	ld a, $e4
	ld [rOBP0], a
	call Function2c165
	call Function2c01c
	ld a, [IsInBattle]
	dec a
	ret z
	jp Function2c03a
; 2c012



Function2c012: ; 2c012
	ld a, $e4
	ld [rOBP0], a
	call Function2c165
	jp Function2c03a
; 2c01c

Function2c01c: ; 2c01c
	call Function2c0ad
	ld hl, PartyMon1CurHP
	ld de, PartyCount
	call Function2c059
	ld a, $60
	ld hl, $cfc4
	ld [hli], a
	ld [hl], a
	ld a, $8
	ld [$d003], a
	ld hl, Sprites
	jp Function2c143
; 2c03a



Function2c03a: ; 2c03a
	call Function2c0c5
	ld hl, OTPartyMon1CurHP
	ld de, OTPartyCount
	call Function2c059
	ld hl, $cfc4
	ld a, $48
	ld [hli], a
	ld [hl], $20
	ld a, $f8
	ld [$d003], a
	ld hl, $c418
	jp Function2c143
; 2c059


Function2c059: ; 2c059
	ld a, [de]
	push af
	ld de, Buffer1
	ld c, $6
	ld a, $34
.asm_2c062
	ld [de], a
	inc de
	dec c
	jr nz, .asm_2c062
	pop af
	ld de, Buffer1
.asm_2c06b
	push af
	call Function2c075
	inc de
	pop af
	dec a
	jr nz, .asm_2c06b
	ret
; 2c075

Function2c075: ; 2c075
	ld a, [hli]
	and a
	jr nz, .asm_2c07f
	ld a, [hl]
	and a
	ld b, $33
	jr z, .asm_2c08b

.asm_2c07f
	dec hl
	dec hl
	dec hl
	ld a, [hl]
	and a
	ld b, $32
	jr nz, .asm_2c08e
	dec b
	jr .asm_2c08e

.asm_2c08b
	dec hl
	dec hl
	dec hl

.asm_2c08e
	ld a, b
	ld [de], a
	ld bc, $0032
	add hl, bc
	ret
; 2c095

DrawPlayerExpBar: ; 2c095
	ld hl, .data_2c0a9
	ld de, $d004
	ld bc, 4
	call CopyBytes
	ld hl, $c57a
	ld de, -1
	jr Function2c0f1

.data_2c0a9
	db $73
	db $77
	db $6f
	db $76
; 2c0ad

Function2c0ad: ; 2c0ad
	ld hl, .data_2c0c1
	ld de, $d004
	ld bc, 4
	call CopyBytes
	ld hl, $c57a
	ld de, -1
	jr Function2c0f1

.data_2c0c1
	db $73, $5c, $6f, $76
; 2c0c5

Function2c0c5: ; 2c0c5
	ld hl, .data_2c0ed
	ld de, $d004
	ld bc, 4
	call CopyBytes
	ld hl, $c4c9
	ld de, 1
	call Function2c0f1
	ld a, [IsInBattle]
	dec a
	ret nz
	ld a, [TempEnemyMonSpecies]
	dec a
	call CheckSeenMon
	ret z
	ld hl, $c4b5
	ld [hl], $5d
	ret

.data_2c0ed
	db $6d
	db $74
	db $78
	db $76
; 2c0f1

Function2c0f1: ; 2c0f1
	ld a, [$d004]
	ld [hl], a
	ld bc, $0014
	add hl, bc
	ld a, [StartFlypoint]
	ld [hl], a
	ld b, $8
.asm_2c0ff
	add hl, de
	ld a, [MovementBuffer]
	ld [hl], a
	dec b
	jr nz, .asm_2c0ff
	add hl, de
	ld a, [EndFlypoint]
	ld [hl], a
	ret
; 2c10d


Function2c10d: ; 2c10d
	call Function2c165
	ld hl, PartyMon1CurHP
	ld de, PartyCount
	call Function2c059
	ld hl, $cfc4
	ld a, $50
	ld [hli], a
	ld [hl], $40
	ld a, $8
	ld [$d003], a
	ld hl, Sprites
	call Function2c143
	ld hl, OTPartyMon1CurHP
	ld de, OTPartyCount
	call Function2c059
	ld hl, $cfc4
	ld a, $50
	ld [hli], a
	ld [hl], $68
	ld hl, $c418
	jp Function2c143
; 2c143

Function2c143: ; 2c143
	ld de, Buffer1
	ld c, $6
.asm_2c148
	ld a, [$cfc5]
	ld [hli], a
	ld a, [$cfc4]
	ld [hli], a
	ld a, [de]
	ld [hli], a
	ld a, $3
	ld [hli], a
	ld a, [$cfc4]
	ld b, a
	ld a, [$d003]
	add b
	ld [$cfc4], a
	inc de
	dec c
	jr nz, .asm_2c148
	ret
; 2c165

Function2c165: ; 2c165
	ld de, $4172
	ld hl, $8310
	ld bc, $0b04
	call Functiondc9
	ret
; 2c172

INCBIN "baserom.gbc", $2c172, $2c1b2 - $2c172


Function2c1b2: ; 2c1b2
	call WhiteBGMap
	call Functione5f
	ld hl, $c4de
	ld b, $9
	ld c, $e
	call TextBox
	ld hl, $c508
	ld de, PlayerName
	call PlaceString
	ld hl, $c56c
	ld de, $d26b
	call PlaceString
	ld hl, $c549
	ld a, $69
	ld [hli], a
	ld [hl], $6a
	ld a, $b
	ld hl, $410d
	rst FarCall
	ld b, $8
	call GetSGBLayout
	call Function32f9
	ld a, $e4
	ld [rOBP0], a
	ret
; 2c1ef


TrainerClassNames: ; 2c1ef
	db "LEADER@"
	db "LEADER@"
	db "LEADER@"
	db "LEADER@"
	db "LEADER@"
	db "LEADER@"
	db "LEADER@"
	db "LEADER@"
	db "RIVAL@"
	db "#MON PROF.@"
	db "ELITE FOUR@"
	db $4a, " TRAINER@"
	db "ELITE FOUR@"
	db "ELITE FOUR@"
	db "ELITE FOUR@"
	db "CHAMPION@"
	db "LEADER@"
	db "LEADER@"
	db "LEADER@"
	db "SCIENTIST@"
	db "LEADER@"
	db "YOUNGSTER@"
	db "SCHOOLBOY@"
	db "BIRD KEEPER@"
	db "LASS@"
	db "LEADER@"
	db "COOLTRAINER@"
	db "COOLTRAINER@"
	db "BEAUTY@"
	db "#MANIAC@"
	db "ROCKET@"
	db "GENTLEMAN@"
	db "SKIER@"
	db "TEACHER@"
	db "LEADER@"
	db "BUG CATCHER@"
	db "FISHER@"
	db "SWIMMER♂@"
	db "SWIMMER♀@"
	db "SAILOR@"
	db "SUPER NERD@"
	db "RIVAL@"
	db "GUITARIST@"
	db "HIKER@"
	db "BIKER@"
	db "LEADER@"
	db "BURGLAR@"
	db "FIREBREATHER@"
	db "JUGGLER@"
	db "BLACKBELT@"
	db "ROCKET@"
	db "PSYCHIC@"
	db "PICNICKER@"
	db "CAMPER@"
	db "ROCKET@"
	db "SAGE@"
	db "MEDIUM@"
	db "BOARDER@"
	db "#FAN@"
	db "KIMONO GIRL@"
	db "TWINS@"
	db "#FAN@"
	db $4a, " TRAINER@"
	db "LEADER@"
	db "OFFICER@"
	db "ROCKET@"
	db "MYSTICALMAN@"


INCBIN "baserom.gbc", $2c41a, $2c7fb - $2c41a


Function2c7fb: ; 2c7fb
	ld hl, StringBuffer2
	ld de, $d066
	ld bc, $000c
	call CopyBytes
	call WhiteBGMap
	ld a, $14
	ld hl, $404f
	rst FarCall
	ld a, $14
	ld hl, $4405
	rst FarCall
	ld a, $14
	ld hl, $43e0
	rst FarCall
	ld a, $3
	ld [PartyMenuActionText], a
.asm_2c821
	callba WritePartyMenuTilemap
	callba PrintPartyMenuText
	call WaitBGMap
	call Function32f9
	call DelayFrame
	callba PartyMenuSelect
	push af
	ld a, [CurPartySpecies]
	cp EGG
	pop bc
	jr z, .asm_2c854
	push bc
	ld hl, $d066
	ld de, StringBuffer2
	ld bc, $000c
	call CopyBytes
	pop af
	ret

.asm_2c854
	push hl
	push de
	push bc
	push af
	ld de, SFX_WRONG
	call StartSFX
	call WaitSFX
	pop af
	pop bc
	pop de
	pop hl
	jr .asm_2c821
; 2c867


INCBIN "baserom.gbc", $2c867, $2cb3e - $2c867


PrintMoveDescription: ; 2cb3e
	push hl
	ld hl, MoveDescriptions
	ld a, [CurSpecies]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop hl
	jp PlaceString
; 2cb52

MoveDescriptions: ; 2cb52
INCLUDE "battle/moves/move_descriptions.asm"
; 2ed44


Function2ed44: ; 2ed44
	call Function2ede6
	ld hl, PartyMon1PokerusStatus
	ld a, [PartyCount]
	ld b, a
	ld de, $0030
.asm_2ed51
	ld a, [hl]
	and $f
	jr nz, .asm_2ed9a
	add hl, de
	dec b
	jr nz, .asm_2ed51
	ld hl, StatusFlags2
	bit 6, [hl]
	ret z
	call Random
	ld a, [hRandomAdd]
	and a
	ret nz
	ld a, [hRandomSub]
	cp $3
	ret nc
	ld a, [PartyCount]
	ld b, a
.asm_2ed70
	call Random
	and $7
	cp b
	jr nc, .asm_2ed70
	ld hl, PartyMon1PokerusStatus
	call GetPartyLocation
	ld a, [hl]
	and $f0
	ret nz
.asm_2ed82
	call Random
	and a
	jr z, .asm_2ed82
	ld b, a
	and $f0
	jr z, .asm_2ed91
	ld a, b
	and $7
	inc a

.asm_2ed91
	ld b, a
	swap b
	and $3
	inc a
	add b
	ld [hl], a
	ret

.asm_2ed9a
	call Random
	cp $55
	ret nc
	ld a, [PartyCount]
	cp $1
	ret z
	ld c, [hl]
	ld a, b
	cp $2
	jr c, .asm_2edc3
	call Random
	cp $80
	jr c, .asm_2edc3
.asm_2edb3
	add hl, de
	ld a, [hl]
	and a
	jr z, .asm_2edd9
	ld c, a
	and $3
	ret z
	dec b
	ld a, b
	cp $1
	jr nz, .asm_2edb3
	ret

.asm_2edc3
	ld a, [PartyCount]
	cp b
	ret z
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	ld a, [hl]
	and a
	jr z, .asm_2edd9
	ld c, a
	and $3
	ret z
	inc b
	jr .asm_2edc3

.asm_2edd9
	ld a, c
	and $f0
	ld b, a
	ld a, c
	swap a
	and $3
	inc a
	add b
	ld [hl], a
	ret
; 2ede6

Function2ede6: ; 2ede6
	ld hl, StatusFlags2
	bit 6, [hl]
	ret z
	call Random
	cp $10
	ret nc
	ld hl, PartyMons
	ld a, [PartyCount]
.asm_2edf8
	push af
	push hl
	ld a, [hl]
	cp SHUCKLE
	jr nz, .asm_2ee08
	ld bc, PartyMon1Item - PartyMon1Species
	add hl, bc
	ld a, [hl]
	cp BERRY
	jr z, .asm_2ee12

.asm_2ee08
	pop hl
	ld bc, PartyMon2 - PartyMon1
	add hl, bc
	pop af
	dec a
	jr nz, .asm_2edf8
	ret

.asm_2ee12
	ld a, BERRY_JUICE
	ld [hl], a
	pop hl
	pop af
	ret
; 2ee18

Function2ee18: ; 2ee18
	ld a, [InLinkBattle]
	and a
	ret z
	ld a, $b
	ld hl, $41b2
	rst FarCall
	ld c, 150
	call DelayFrames
	call ClearTileMap
	call ClearSprites
	ret
; 2ee2f


Function2ee2f: ; 2ee2f
	xor a
	ld [$ffde], a
	call DelayFrame
	ld b, 6
	ld hl, PartyMon1CurHP
	ld de, PartyMon2 - PartyMon1 - 1
.asm_2ee3d
	ld a, [hli]
	or [hl]
	jr nz, .asm_2ee45
	add hl, de
	dec b
	jr nz, .asm_2ee3d

.asm_2ee45
	ld de, PartyMon1Level - PartyMon1CurHP
	add hl, de
	ld a, [hl]
	ld [BattleMonLevel], a
	ld a, PREDEF_BATTLE_TRANSITION
	call Predef
	callba Function3ed9f
	ld a, 1
	ld [hBGMapMode], a
	call ClearSprites
	call ClearTileMap
	xor a
	ld [hBGMapMode], a
	ld [hWY], a
	ld [rWY], a
	ld [$ffde], a
	ret
; 2ee6c


PlayBattleMusic: ; 2ee6c

	push hl
	push de
	push bc

	xor a
	ld [MusicFade], a
	ld de, MUSIC_NONE
	call StartMusic
	call DelayFrame
	call MaxVolume

	ld a, [BattleType]
	cp BATTLETYPE_SUICUNE
	ld de, MUSIC_SUICUNE_BATTLE
	jp z, .done
	cp BATTLETYPE_ROAMING
	jp z, .done

	; Are we fighting a trainer?
	ld a, [OtherTrainerClass]
	and a
	jr nz, .trainermusic

	ld a, BANK(RegionCheck)
	ld hl, RegionCheck
	rst FarCall
	ld a, e
	and a
	jr nz, .kantowild

	ld de, MUSIC_JOHTO_WILD_BATTLE
	ld a, [TimeOfDay]
	cp NITE
	jr nz, .done
	ld de, MUSIC_JOHTO_WILD_BATTLE_NIGHT
	jr .done

.kantowild
	ld de, MUSIC_KANTO_WILD_BATTLE
	jr .done

.trainermusic
	ld de, MUSIC_CHAMPION_BATTLE
	cp CHAMPION
	jr z, .done
	cp RED
	jr z, .done

	; really, they should have included admins and scientists here too...
	ld de, MUSIC_ROCKET_BATTLE
	cp GRUNTM
	jr z, .done
	cp GRUNTF
	jr z, .done

	ld de, MUSIC_KANTO_GYM_LEADER_BATTLE
	ld a, BANK(IsKantoGymLeader)
	ld hl, IsKantoGymLeader
	rst FarCall
	jr c, .done

	ld de, MUSIC_JOHTO_GYM_LEADER_BATTLE
	ld a, BANK(IsJohtoGymLeader)
	ld hl, IsJohtoGymLeader
	rst FarCall
	jr c, .done

	ld de, MUSIC_RIVAL_BATTLE
	ld a, [OtherTrainerClass]
	cp RIVAL1
	jr z, .done
	cp RIVAL2
	jr nz, .othertrainer

	ld a, [OtherTrainerID]
	cp 4 ; Rival in Indigo Plateau
	jr c, .done
	ld de, MUSIC_CHAMPION_BATTLE
	jr .done

.othertrainer
	ld a, [InLinkBattle]
	and a
	jr nz, .johtotrainer

	ld a, BANK(RegionCheck)
	ld hl, RegionCheck
	rst FarCall
	ld a, e
	and a
	jr nz, .kantotrainer

.johtotrainer
	ld de, MUSIC_JOHTO_TRAINER_BATTLE
	jr .done

.kantotrainer
	ld de, MUSIC_KANTO_TRAINER_BATTLE

.done
	call StartMusic

	pop bc
	pop de
	pop hl
	ret
; 2ef18


ClearBattleRAM: ; 2ef18
	xor a
	ld [$d0ec], a
	ld [$d0ee], a

	ld hl, $d0d8
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a

	ld [$d0e4], a
	ld [CriticalHit], a
	ld [BattleMonSpecies], a
	ld [$c664], a
	ld [CurBattleMon], a
	ld [$d232], a
	ld [TimeOfDayPal], a
	ld [PlayerTurnsTaken], a
	ld [EnemyTurnsTaken], a
	ld [EvolvableFlags], a

	ld hl, PlayerHPPal
	ld [hli], a
	ld [hl], a

	ld hl, BattleMonDVs
	ld [hli], a
	ld [hl], a

	ld hl, EnemyMonDVs
	ld [hli], a
	ld [hl], a

; Clear the entire BattleMons area
	ld hl, EnemyMoveStruct
	ld bc, $0139
	xor a
	call ByteFill

	ld hl, $5867
	ld a, $f
	rst FarCall

	call Function1fbf

	ld hl, hBGMapAddress
	xor a
	ld [hli], a
	ld [hl], $98
	ret
; 2ef6e


FillBox: ; 2ef6e
; Fill $c2c6-aligned box width b height c
; with iterating tile starting from $ffad at hl.
; Predef $13

	ld de, 20

	ld a, [$c2c6]
	and a
	jr nz, .left

	ld a, [$ffad]
.x1
	push bc
	push hl

.y1
	ld [hl], a
	add hl, de
	inc a
	dec c
	jr nz, .y1

	pop hl
	inc hl
	pop bc
	dec b
	jr nz, .x1
	ret

.left
; Right-aligned.
	push bc
	ld b, 0
	dec c
	add hl, bc
	pop bc

	ld a, [$ffad]
.x2
	push bc
	push hl

.y2
	ld [hl], a
	add hl, de
	inc a
	dec c
	jr nz, .y2

	pop hl
	dec hl
	pop bc
	dec b
	jr nz, .x2
	ret
; 2ef9f



SECTION "bankC",ROMX,BANK[$C]

INCLUDE "tilesets/data_4.asm"

INCBIN "baserom.gbc", $329f0, $333f0 - $329f0


SECTION "bankD",ROMX,BANK[$D]

INCLUDE "battle/effect_commands.asm"


SECTION "bankE",ROMX,BANK[$E]

Function38000: ; 38000
	and a
	ld a, [IsInBattle]
	dec a
	ret z
	ld a, [InLinkBattle]
	and a
	ret nz
	ld a, $f
	ld hl, $68d1
	rst FarCall
	ret nz
	ld a, [PlayerSubStatus5]
	bit 7, a
	jr nz, Function38041
	ld a, [$c731]
	and a
	jr nz, Function38041
	ld hl, $55a1
	ld a, [$cfc0]
	and a
	jr nz, .asm_38032
	ld a, [TrainerClass]
	dec a
	ld bc, $0007
	call AddNTimes

.asm_38032
	bit 0, [hl]
	jp nz, Function38045
	bit 1, [hl]
	jp nz, Function38083
	bit 2, [hl]
	jp nz, Function380c1
	; fallthrough
; 38041

Function38041: ; 38041
	call Function38105
	ret
; 38045

Function38045: ; 38045
	callab Function0x34941
	ld a, [$c717]
	and $f0
	jp z, Function38041
	cp $10
	jr nz, .asm_38061
	call Random
	cp $80
	jr c, .asm_38077
	jp Function38041

.asm_38061
	cp $20
	jr nz, .asm_3806f
	call Random
	cp $c8
	jr c, .asm_38077
	jp Function38041

.asm_3806f
	call Random
	cp $a
	jp c, Function38041

.asm_38077
	ld a, [$c717]
	and $f
	inc a
	ld [$c718], a
	jp Function3844b
; 38083

Function38083: ; 38083
	callab Function0x34941
	ld a, [$c717]
	and $f0
	jp z, Function38041
	cp $10
	jr nz, .asm_3809f
	call Random
	cp $14
	jr c, .asm_380b5
	jp Function38041

.asm_3809f
	cp $20
	jr nz, .asm_380ad
	call Random
	cp $1e
	jr c, .asm_380b5
	jp Function38041

.asm_380ad
	call Random
	cp $c8
	jp c, Function38041

.asm_380b5
	ld a, [$c717]
	and $f
	inc a
	ld [$c718], a
	jp Function3844b
; 380c1

Function380c1: ; 380c1
	callab Function0x34941
	ld a, [$c717]
	and $f0
	jp z, Function38041
	cp $10
	jr nz, .asm_380dd
	call Random
	cp $32
	jr c, .asm_380f3
	jp Function38041

.asm_380dd
	cp $20
	jr nz, .asm_380eb
	call Random
	cp $80
	jr c, .asm_380f3
	jp Function38041

.asm_380eb
	call Random
	cp $32
	jp c, Function38041

.asm_380f3
	ld a, [$c717]
	and $f
	inc a
	ld [$c718], a
	jp Function3844b
; 380ff


Function380ff: ; 380ff
	ld a, [EnemySubStatus5]
	bit 7, a
	ret
; 38105


Function38105: ; 38105
	ld a, [$cfc0]
	and a
	ret nz
	ld a, [$c650]
	ld b, a
	ld a, [$c651]
	or b
	ret z
	call Function38170
	ret nc
	ld a, [TrainerClass]
	dec a
	ld hl, $55a1
	ld bc, $0007
	call AddNTimes
	ld b, h
	ld c, l
	ld hl, $4196
	ld de, $c650
.asm_3812c
	ld a, [hl]
	and a
	inc a
	ret z
	ld a, [de]
	cp [hl]
	jr z, .asm_3813f
	inc de
	ld a, [de]
	cp [hl]
	jr z, .asm_3813f
	dec de
	inc hl
	inc hl
	inc hl
	jr .asm_3812c

.asm_3813f
	inc hl
	push hl
	push de
	ld de, $414a
	push de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 3814a

INCBIN "baserom.gbc", $3814a, $38170 - $3814a


Function38170: ; 38170
	ld a, [OTPartyCount]
	ld d, a
	ld e, $0
	ld hl, OTPartyMon1Level
	ld bc, $0030
.asm_3817c
	ld a, [hl]
	cp e
	jr c, .asm_38181
	ld e, a
.asm_38181
	add hl, bc
	dec d
	jr nz, .asm_3817c

	ld a, [CurOTMon]
	ld hl, OTPartyMon1Level
	call AddNTimes
	ld a, [hl]
	cp e
	jr nc, .asm_38194
	and a
	ret

.asm_38194
	scf
	ret
; 38196

INCBIN "baserom.gbc", $38196, $38387 - $38196


Function38387: ; 38387
	call UpdateEnemyMonInParty
	callba Function3e036
	ld a, $1
	ld [hBGMapMode], a
	ld hl, $c6e6
	dec [hl]
	scf
	ret
; 3839a

Function3839a: ; 3839a
	push de
	ld de, SFX_FULL_HEAL
	call StartSFX
	pop de
	ret
; 383a3

INCBIN "baserom.gbc", $383a3, $3844b - $383a3


Function3844b: ; 3844b
	ld a, [OTPartyCount]
	ld c, a
	ld hl, OTPartyMon1CurHP
	ld d, 0
.asm_38454
	ld a, [hli]
	ld b, a
	ld a, [hld]
	or b
	jr z, .asm_3845b
	inc d

.asm_3845b
	push bc
	ld bc, $0030
	add hl, bc
	pop bc
	dec c
	jr nz, .asm_38454
	ld a, d
	cp $2
	jp nc, Function3846c
	and a
	ret
; 3846c

Function3846c: ; 3846c
	ld a, $1
	ld [$c711], a
	ld [$c70f], a
	ld hl, EnemySubStatus4
	res 6, [hl]
	xor a
	ld [hBattleTurn], a
	ld hl, $5c5b
	ld a, $f
	rst FarCall
	push af
	ld a, [CurOTMon]
	ld hl, OTPartyMon1Status
	ld bc, $0030
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, EnemyMonStatus
	ld bc, $0004
	call CopyBytes
	pop af
	jr c, .asm_384a3
	ld hl, UnknownText_0x384d0
	call PrintText

.asm_384a3
	ld a, $1
	ld [$d264], a
	ld hl, $5834
	ld a, $f
	rst FarCall
	ld hl, $5867
	ld a, $f
	rst FarCall
	ld hl, PlayerSubStatus1
	res 7, [hl]
	ld a, $f
	ld hl, $54e1
	rst FarCall
	ld a, $f
	ld hl, $557a
	rst FarCall
	xor a
	ld [$d264], a
	ld a, [InLinkBattle]
	and a
	ret nz
	scf
	ret
; 384d0

UnknownText_0x384d0: ; 384d0
	text_jump UnknownText_0x1bcf9c, BANK(UnknownText_0x1bcf9c)
	db "@"
; 384d5

Function384d5: ; 384d5
	call Function3839a
	call Function384e0
	ld a, $34
	jp Function38568
; 384e0

Function384e0: ; 384e0
	ld a, [CurOTMon]
	ld hl, OTPartyMon1Status
	ld bc, $0030
	call AddNTimes
	xor a
	ld [hl], a
	ld [EnemyMonStatus], a
	ld hl, EnemySubStatus5
	res 0, [hl]
	ret
; 384f7

Function384f7: ; 384f7
	call Function3839a
	ld hl, EnemySubStatus4
	set 0, [hl]
	ld a, $21
	jp Function38568
; 38504

Function38504: ; 38504
	call Function3839a
	ld hl, EnemySubStatus4
	set 1, [hl]
	ld a, $29
	jp Function38568
; 38511

Function38511: ; 38511
	call Function3839a
	ld hl, EnemySubStatus4
	set 2, [hl]
	ld a, $2c
	jp Function38568
; 3851e

Function3851e: ; 3851e
	ld [hMultiplier], a
	ld hl, EnemyMonMaxHPHi
	ld a, [hli]
	ld [hProduct], a
	ld a, [hl]
	ld [hMultiplicand], a
	ld b, $2
	call Divide
	ld a, [$ffb6]
	ld c, a
	ld a, [$ffb5]
	ld b, a
	ld hl, EnemyMonHPLo
	ld a, [hld]
	ld e, a
	ld a, [hl]
	ld d, a
	ld a, d
	sub b
	ret nz
	ld a, e
	sub c
	ret
; 38541

Function38541: ; 38541
	ld b, $0
	ld a, $31
	jr Function38557
; 38547

Function38547: ; 38547
	ld b, $1
	ld a, $33
	jr Function38557
; 3854d

Function3854d: ; 3854d
	ld b, $2
	ld a, $34
	jr Function38557
; 38553

Function38553: ; 38553
	ld b, $3
	ld a, $35

Function38557
	ld [$d1f1], a
	push bc
	call Function38571
	pop bc
	callba Function0x361ef
	jp Function38387
; 38568


Function38568: ; 38568
	ld [$d1f1], a
	call Function38571
	jp Function38387
; 38571

Function38571: ; 38571
	ld a, [$d1f1]
	ld [$d265], a
	call GetItemName
	ld hl, StringBuffer1
	ld de, $d050
	ld bc, $000d
	call CopyBytes
	ld hl, UnknownText_0x3858c
	jp PrintText
; 3858c

UnknownText_0x3858c: ; 3858c
	text_jump UnknownText_0x1bcfaf, BANK(UnknownText_0x1bcfaf)
	db "@"
; 38591


AIScoring: ; 38591
INCLUDE "battle/ai/scoring.asm"


Function3952d: ; 3952d
	ld hl, RivalName
	ld a, c
	cp $9
	jr z, .asm_39544
	ld [CurSpecies], a
	ld a, $7
	ld [$cf61], a
	call GetName
	ld de, StringBuffer1
	ret

.asm_39544
	ld de, StringBuffer1
	push de
	ld bc, $000b
	call CopyBytes
	pop de
	ret
; 39550

Function39550: ; 39550
	ld hl, $d26b
	ld a, [InLinkBattle]
	and a
	jr nz, .asm_3956f
	ld hl, RivalName
	ld a, c
	cp $9
	jr z, .asm_3956f
	ld [CurSpecies], a
	ld a, $7
	ld [$cf61], a
	call GetName
	ld hl, StringBuffer1

.asm_3956f
	ld bc, $000d
	ld de, $c656
	push de
	call CopyBytes
	pop de
	ret
; 3957b

Function3957b: ; 3957b
	ld a, [TrainerClass]
	ld c, a
	call Function39550
	ld a, [TrainerClass]
	dec a
	ld hl, $559c
	ld bc, $0007
	call AddNTimes
	ld de, $c650
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, [hl]
	ld [$c652], a
	ret
; 3959c


INCBIN "baserom.gbc", $3959c, $39771 - $3959c


Function39771: ; 39771
	ld a, [$cfc0]
	bit 0, a
	ret nz
	ld a, [InLinkBattle]
	and a
	ret nz
	ld hl, OTPartyCount
	xor a
	ld [hli], a
	dec a
	ld [hl], a
	ld hl, OTPartyMon1Species
	ld bc, $0120
	xor a
	call ByteFill
	ld a, [OtherTrainerClass]
	cp $c
	jr nz, .asm_3979e
	ld a, [OtherTrainerID]
	cp $2
	jr z, .asm_397d3
	ld a, [OtherTrainerClass]

.asm_3979e
	dec a
	ld c, a
	ld b, $0
	ld hl, TrainerGroups
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [OtherTrainerID]
	ld b, a
.asm_397ae
	dec b
	jr z, .asm_397b8
.asm_397b1
	ld a, [hli]
	cp $ff
	jr nz, .asm_397b1
	jr .asm_397ae

.asm_397b8
	ld a, [hli]
	cp $50
	jr nz, .asm_397b8
	ld a, [hli]
	ld c, a
	ld b, $0
	ld d, h
	ld e, l
	ld hl, $57e3
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, .data_397d0
	push bc
	jp [hl]

.data_397d0
.asm_397d0
	db $c3
	db $1b
	db $59

.asm_397d3
	ld a, $0
	call GetSRAMBank
	ld de, $ac0a
	call Function39806
	call CloseSRAM
	jr .asm_397d0
; 397e3

INCBIN "baserom.gbc", $397e3, $39806 - $397e3


Function39806: ; 39806
	ld h, d
	ld l, e
.asm_39808
	ld a, [hli]
	cp $ff
	ret z
	ld [CurPartyLevel], a
	ld a, [hli]
	ld [CurPartySpecies], a
	ld a, $1
	ld [MonType], a
	push hl
	ld a, $6
	call Predef
	ld a, [OTPartyCount]
	dec a
	ld hl, OTPartyMon1Move1
	ld bc, $0030
	call AddNTimes
	ld d, h
	ld e, l
	pop hl
	ld b, $4
.asm_39830
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_39830
	push hl
	ld a, [OTPartyCount]
	dec a
	ld hl, OTPartyMon1Species
	ld bc, $0030
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, $0017
	add hl, de
	push hl
	ld hl, $0002
	add hl, de
	pop de
	ld b, $4
.asm_39852
	ld a, [hli]
	and a
	jr z, .asm_3986e
	push hl
	push bc
	dec a
	ld hl, $5b00
	ld bc, $0007
	call AddNTimes
	ld a, $10
	call GetFarByte
	pop bc
	pop hl
	ld [de], a
	inc de
	dec b
	jr nz, .asm_39852

.asm_3986e
	pop hl
	jr .asm_39808
; 39871

INCBIN "baserom.gbc", $39871, $39939 - $39871


Function39939: ; 39939
	ld a, [$cfc0]
	bit 0, a
	ld hl, $d26b
	jp nz, $5984
	ld a, [OtherTrainerID]
	ld b, a
	ld a, [OtherTrainerClass]
	ld c, a
	ld a, c
	cp $c
	jr nz, .asm_3996d
	ld a, $0
	call GetSRAMBank
	ld a, [$abfd]
	and a
	call CloseSRAM
	jr z, .asm_3996d
	ld a, $0
	call GetSRAMBank
	ld hl, $abfe
	call $5984
	jp CloseSRAM

.asm_3996d
	dec c
	push bc
	ld b, 0
	ld hl, TrainerGroups
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc
.asm_3997a
	dec b
	jr z, .asm_39984
.asm_3997d
	ld a, [hli]
	cp $ff
	jr nz, .asm_3997d
	jr .asm_3997a

.asm_39984
	ld de, StringBuffer1
	push de
	ld bc, $000b
	call CopyBytes
	pop de
	ret
; 39990

Function39990: ; 39990
	ld de, StringBuffer1
	push de
	ld bc, $000b
	pop de
	ret
; 39999



TrainerGroups: ; 0x39999
INCLUDE "trainers/trainer_pointers.asm"

INCLUDE "trainers/trainers.asm"


SECTION "bankF",ROMX,BANK[$F]

Function3c000: ; 3c000
	xor a
	ld [$c664], a
	ld [$c6fc], a
	ld [$d0ec], a
	ld [BattleEnded], a
	inc a
	ld [$d264], a
	ld hl, OTPartyMon1CurHP
	ld bc, $002f
	ld d, $3
.asm_3c019
	inc d
	ld a, [hli]
	or [hl]
	jr nz, .asm_3c021
	add hl, bc
	jr .asm_3c019

.asm_3c021
	ld a, d
	ld [$d430], a
	ld a, [InLinkBattle]
	and a
	jr z, .asm_3c031
	ld a, [$ffcb]
	cp $2
.data_3c02f
	db $28
	db $1b

.asm_3c031
	ld a, [IsInBattle]
	dec a
	jr z, .asm_3c047
	xor a
	ld [$c718], a
	call Function3d834
	call Function3d867
	call Function3dc18
	call Function3d4e1

.asm_3c047
	ld c, $28
	call DelayFrames
	call Function309d
	call Function3d873
	ld a, d
	and a
	jp z, LostBattle
	call Function30b4
	ld a, [BattleType]
	cp $2
	jp z, Function3c0e2
	cp $3
	jp z, Function3c0e2
	xor a
	ld [CurPartyMon], a
.asm_3c06b
	call Function3d887
	jr nz, .asm_3c076
	ld hl, CurPartyMon
	inc [hl]
	jr .asm_3c06b

.asm_3c076
	ld a, [CurBattleMon]
	ld [$c71a], a
	ld a, [CurPartyMon]
	ld [CurBattleMon], a
	inc a
	ld hl, PartyCount
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	ld [CurPartySpecies], a
	ld [TempBattleMonSpecies], a
	ld hl, $c505
	ld a, $9
	call Function3d490
	call Function309d
	call Function3d57a
	call Function3da0d
	call Function3dab1
	call Function3f26d
	call Function3dbde
	call Function3dc18
	call Function3db5f
	call EmptyBattleTextBox
	call Function309d
	call SetPlayerTurn
	call Function3dc23
	ld a, [InLinkBattle]
	and a
	jr z, .asm_3c0df
	ld a, [$ffcb]
	cp $2
	jr nz, .asm_3c0df
	xor a
	ld [$c718], a
	call Function3d834
	call Function3d867
	call Function3dc18
	call Function3d4e1
	call SetEnemyTurn
	call Function3dc23

.asm_3c0df
	jp Function3c12f
; 3c0e2

Function3c0e2: ; 3c0e2
	jp Function3e139
; 3c0e5



Function3c0e5: ; 3c0e5
	call Function30b4
	ld a, [$d0ee]
	and $c0
	add $2
	ld [$d0ee], a
	ld a, [InLinkBattle]
	and a
	ld hl, $47bd
	jr z, .asm_3c115
	ld a, [$d0ee]
	and $c0
	ld [$d0ee], a
	ld hl, $47cf
	call Function3d2e0
	jr nc, .asm_3c115
	ld hl, $cd2a
	bit 4, [hl]
	jr nz, .asm_3c118
	ld hl, $5863

.asm_3c115
	call StdBattleTextBox

.asm_3c118
	call Function3ceec
	call Function3d2e0
	jr c, .asm_3c126

	ld de, SFX_RUN
	call StartSFX

.asm_3c126
	call SetPlayerTurn
	ld a, 1
	ld [BattleEnded], a
	ret
; 3c12f

Function3c12f: ; 3c12f
	call Function3c1bf
	call Function3c3f5
	jp c, $41be
	xor a
	ld [$c710], a
	ld [$c711], a
	ld [$d264], a
	ld [$c73f], a
	ld [$c740], a
	ld [CurDamage], a
	ld [$d257], a
	call Function3c27c
	call UpdateBattleMonInParty
	callba AIChooseMove
	call Function3d2f1
	jr nz, .asm_3c174
	callba Function100da5
	callba Function100641
	callba Function100dd8
	jp c, $41be

.asm_3c174
	call Function3c410
	jr c, .asm_3c18a
.asm_3c179
	call Function3e139
	jr c, .asm_3c1be
	ld a, [BattleEnded]
	and a
	jr nz, .asm_3c1be
	ld a, [$d232]
	and a
	jr nz, .asm_3c1be

.asm_3c18a
	call Function3c434
	jr nz, .asm_3c179
	call Function3c300
	jr c, .asm_3c1be
	call Function3c314
	jr c, .asm_3c19e
	call Function3c5fe
	jr .asm_3c1a1

.asm_3c19e
	call Function3c664

.asm_3c1a1
	call Function3d2e0
	jr c, .asm_3c1be
	ld a, [$d232]
	and a
	jr nz, .asm_3c1be
	ld a, [BattleEnded]
	and a
	jr nz, .asm_3c1be
	call Function3c1d6
	ld a, [BattleEnded]
	and a
	jr nz, .asm_3c1be
	jp Function3c12f

.asm_3c1be
	ret
; 3c1bf

Function3c1bf: ; 3c1bf
	ret
; 3c1c0


Function3c1c0: ; 3c1c0
	ld a, $5
	call GetSRAMBank
	ld hl, $a89b
	inc [hl]
	jr nz, .asm_3c1d2
	dec hl
	inc [hl]
	jr nz, .asm_3c1d2
	dec [hl]
	inc hl
	dec [hl]

.asm_3c1d2
	call CloseSRAM
	ret
; 3c1d6


Function3c1d6: ; 3c1d6
	ld a, [$ffcb]
	cp $1
	jr z, .asm_3c1fe
	call Function3c23c
	ret c
	call Function3ca26
	call Function3c23c
	ret c
	call HandleWeather
	call Function3c23c
	ret c
	call Function3c874
	call Function3c23c
	ret c
	call Function3c801
	call Function3c23c
	ret c
	jr .asm_3c21e

.asm_3c1fe
	call Function3c25c
	ret c
	call Function3ca26
	call Function3c25c
	ret c
	call HandleWeather
	call Function3c25c
	ret c
	call Function3c874
	call Function3c25c
	ret c
	call Function3c801
	call Function3c25c
	ret c

.asm_3c21e
	call Function3c8eb
	call Function3c93c
	call Function3ca8f
	call Function3cafb
	call Function3cb36
	call Function3de97
	call Function3dcf9
	call UpdateBattleMonInParty
	call Function309d
	jp Function3c4df
; 3c23c

Function3c23c: ; 3c23c
	call $4710
	jr nz, .asm_3c24a
	call Function3d14e
	ld a, [BattleEnded]
	and a
	jr nz, .asm_3c25a

.asm_3c24a
	call $470b
	jr nz, .asm_3c258
	call Function3cd55
	ld a, [BattleEnded]
	and a
	jr nz, .asm_3c25a

.asm_3c258
	and a
	ret

.asm_3c25a
	scf
	ret
; 3c25c

Function3c25c: ; 3c25c
	call $470b
	jr nz, .asm_3c26a
	call Function3cd55
	ld a, [BattleEnded]
	and a
	jr nz, .asm_3c27a

.asm_3c26a
	call $4710
	jr nz, .asm_3c278
	call Function3d14e
	ld a, [BattleEnded]
	and a
	jr nz, .asm_3c27a

.asm_3c278
	and a
	ret

.asm_3c27a
	scf
	ret
; 3c27c

Function3c27c: ; 3c27c
	ld a, [$ffcb]
	cp $1
	jr z, .asm_3c287
	call $428a
	jr .asm_3c296

.asm_3c287
	call $4296
	call SetPlayerTurn
	ld de, PartyMon1Item
	ld a, [CurBattleMon]
	ld b, a
	jr .asm_3c2a0

.asm_3c296
	call SetEnemyTurn
	ld de, OTPartyMon1Item
	ld a, [CurOTMon]
	ld b, a

.asm_3c2a0
	push de
	push bc
	callab GetUserItem
	ld a, [hl]
	ld [$d265], a
	sub $98
	pop bc
	pop de
	ret nz
	ld [hl], a
	ld h, d
	ld l, e
	ld a, b
	call GetPartyLocation
	xor a
	ld [hl], a
	ld a, $2
	call GetBattleVarPair
	push af
	set 7, [hl]
	ld a, $c
	call GetBattleVarPair
	push hl
	push af
	xor a
	ld [hl], a
	ld [AttackMissed], a
	ld [EffectFailed], a
	callba BattleCommand77
	pop af
	pop hl
	ld [hl], a
	call GetItemName
	ld hl, $4bde
	call StdBattleTextBox
	callab BattleCommand8c
	pop af
	bit 7, a
	ret nz
	xor a
	ld [$cfca], a
	ld de, $0103
	call Function3ee0f
	call Function3c8e4
	ld hl, $4d97
	jp StdBattleTextBox
; 3c300

Function3c300: ; 3c300
	ld a, [InLinkBattle]
	and a
	jr z, .asm_3c30d
	ld a, [$d430]
	cp $f
	jr z, .asm_3c30f

.asm_3c30d
	and a
	ret

.asm_3c30f
	call Function3c0e5
	scf
	ret
; 3c314

Function3c314: ; 3c314
	ld a, [InLinkBattle]
	and a
	jr z, .asm_3c35b
	ld a, [$d430]
	cp $e
	jr z, .asm_3c35b
	cp $d
	jr z, .asm_3c35b
	sub $4
	jr c, .asm_3c35b
	ld a, [$d0ec]
	cp $2
	jr nz, .asm_3c34c
	ld a, [$ffcb]
	cp $2
	jr z, .asm_3c341
	call BattleRandom
	cp $80
	jp c, $43f1
	jp Function3c3f3

.asm_3c341
	call BattleRandom
	cp $80
	jp c, Function3c3f3
	jp $43f1

.asm_3c34c
	callab Function3846c
	call SetEnemyTurn
	call Function3dc23
	jp Function3c3f3

.asm_3c35b
	ld a, [$d0ec]
	and a
	jp nz, $43f1
	call Function3c5b4
	jr z, .asm_3c36d
	jp c, $43f1
	jp Function3c3f3

.asm_3c36d
	call SetPlayerTurn
	callab GetUserItem
	push bc
	callab GetOpponentItem
	pop de
	ld a, d
	cp $4a
	jr nz, .asm_3c391
	ld a, b
	cp $4a
	jr z, .asm_3c39f
	call BattleRandom
	cp e
	jr nc, .asm_3c3c5
	jp $43f1

.asm_3c391
	ld a, b
	cp $4a
	jr nz, .asm_3c3c5
	call BattleRandom
	cp c
	jr nc, .asm_3c3c5
	jp Function3c3f3

.asm_3c39f
	ld a, [$ffcb]
	cp $2
	jr z, .asm_3c3b5
	call BattleRandom
	cp c
	jp c, Function3c3f3
	call BattleRandom
	cp e
	jp c, $43f1
	jr .asm_3c3c5

.asm_3c3b5
	call BattleRandom
	cp e
	jp c, $43f1
	call BattleRandom
	cp c
	jp c, Function3c3f3
	jr .asm_3c3c5

.asm_3c3c5
	ld de, BattleMonSpd
	ld hl, EnemyMonSpd
	ld c, $2
	call StringCmp
	jr z, .asm_3c3d8
	jp nc, $43f1
	jp Function3c3f3

.asm_3c3d8
	ld a, [$ffcb]
	cp $2
	jr z, .asm_3c3e9
	call BattleRandom
	cp $80
	jp c, $43f1
	jp Function3c3f3

.asm_3c3e9
	call BattleRandom
	cp $80
	jp c, Function3c3f3
	scf
	ret
; 3c3f3

Function3c3f3: ; 3c3f3
	and a
	ret
; 3c3f5

Function3c3f5: ; 3c3f5
	ld a, [BattleType]
	cp $6
	jr nz, .asm_3c40e
	ld a, [$dc79]
	and a
	jr nz, .asm_3c40e
	ld a, [$d0ee]
	and $c0
	add $2
	ld [$d0ee], a
	scf
	ret

.asm_3c40e
	and a
	ret
; 3c410

Function3c410: ; 3c410
	ld a, [PlayerSubStatus4]
	and $20
	jp nz, Function3c432
	ld hl, EnemySubStatus3
	res 3, [hl]
	ld hl, PlayerSubStatus3
	res 3, [hl]
	ld a, [hl]
	and $12
	jp nz, Function3c432
	ld hl, PlayerSubStatus1
	bit 6, [hl]
	jp nz, Function3c432
	and a
	ret
; 3c432

Function3c432: ; 3c432
	scf
	ret
; 3c434

Function3c434: ; 3c434
	call Function3c410
	jp c, $44ba
	ld hl, PlayerSubStatus5
	bit 4, [hl]
	jr z, .asm_3c449
	ld a, [LastPlayerMove]
	ld [CurPlayerMove], a
	jr .asm_3c47c

.asm_3c449
	ld a, [$d0ec]
	cp $2
	jr z, .asm_3c4ce
	and a
	jr nz, .asm_3c4b5
	ld a, [PlayerSubStatus3]
	and $1
	jr nz, .asm_3c4ba
	xor a
	ld [$d235], a
	inc a
	ld [FXAnimIDLo], a
	call Function3e4bc
	push af
	call Function30b4
	call UpdateBattleHuds
	ld a, [CurPlayerMove]
	cp $a5
	jr z, .asm_3c476
	call PlayClickSFX

.asm_3c476
	ld a, $1
	ld [hBGMapMode], a
	pop af
	ret nz

.asm_3c47c
	call SetPlayerTurn
	callab UpdateMoveData
	xor a
	ld [$c732], a
	ld a, [PlayerMoveEffect]
	cp $77
	jr z, .asm_3c494
	xor a
	ld [PlayerFuryCutterCount], a

.asm_3c494
	ld a, [PlayerMoveEffect]
	cp $51
	jr z, .asm_3c4a4
	ld hl, PlayerSubStatus4
	res 6, [hl]
	xor a
	ld [$c72b], a

.asm_3c4a4
	ld a, [PlayerMoveEffect]
	cp $6f
	jr z, .asm_3c4c9
	cp $74
	jr z, .asm_3c4c9
	xor a
	ld [$c679], a
	jr .asm_3c4c9

.asm_3c4b5
	ld hl, PlayerSubStatus3
	res 0, [hl]

.asm_3c4ba
	xor a
	ld [PlayerFuryCutterCount], a
	ld [$c679], a
	ld [$c72b], a
	ld hl, PlayerSubStatus4
	res 6, [hl]

.asm_3c4c9
	call Function3e7c1
	xor a
	ret

.asm_3c4ce
	xor a
	ld [PlayerFuryCutterCount], a
	ld [$c679], a
	ld [$c72b], a
	ld hl, PlayerSubStatus4
	res 6, [hl]
	xor a
	ret
; 3c4df

Function3c4df: ; 3c4df
	ld a, [$ffcb]
	cp $1
	jr z, .asm_3c4ea
	call $44ed
	jr .asm_3c518

.asm_3c4ea
	call $4518
	ld hl, PlayerSubStatus5
	bit 4, [hl]
	ret z
	ld a, [PlayerEncoreCount]
	dec a
	ld [PlayerEncoreCount], a
	jr z, .asm_3c50a
	ld hl, BattleMonPPMove1
	ld a, [CurMoveNum]
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	and $3f
	ret nz

.asm_3c50a
	ld hl, PlayerSubStatus5
	res 4, [hl]
	call SetEnemyTurn
	ld hl, $4c8a
	jp StdBattleTextBox

.asm_3c518
	ld hl, EnemySubStatus5
	bit 4, [hl]
	ret z
	ld a, [EnemyEncoreCount]
	dec a
	ld [EnemyEncoreCount], a
	jr z, .asm_3c535
	ld hl, EnemyMonPPMove1
	ld a, [CurEnemyMoveNum]
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	and $3f
	ret nz

.asm_3c535
	ld hl, EnemySubStatus5
	res 4, [hl]
	call SetPlayerTurn
	ld hl, $4c8a
	jp StdBattleTextBox
; 3c543


Function3c543: ; 3c543
	ld a, [IsInBattle]
	dec a
	jr nz, .Stay

	ld a, [PlayerSubStatus5]
	bit 7, a
	jr nz, .Stay

	ld a, [$c731]
	and a
	jr nz, .Stay

	ld a, [EnemyMonStatus]
	and 1 << FRZ | SLP
	jr nz, .Stay

	ld a, [TempEnemyMonSpecies]
	ld de, 1
	ld hl, .Always
	call IsInArray
	jr c, .Flee

	call BattleRandom
	ld b, a
	cp $80
	jr nc, .Stay

	push bc
	ld a, [TempEnemyMonSpecies]
	ld de, 1
	ld hl, .Often
	call IsInArray
	pop bc
	jr c, .Flee

	ld a, b
	cp $1a
	jr nc, .Stay

	ld a, [TempEnemyMonSpecies]
	ld de, 1
	ld hl, .Sometimes
	call IsInArray
	jr c, .Flee

.Stay
	and a
	ret

.Flee
	scf
	ret
; 3c59a

.Sometimes
	db MAGNEMITE
	db GRIMER
	db TANGELA
	db MR__MIME
	db EEVEE
	db PORYGON
	db DRATINI
	db DRAGONAIR
	db TOGETIC
	db UMBREON
	db UNOWN
	db SNUBBULL
	db HERACROSS
	db $ff

.Often
	db CUBONE
	db ARTICUNO
	db ZAPDOS
	db MOLTRES
	db QUAGSIRE
	db DELIBIRD
	db PHANPY
	db TEDDIURSA
	db $ff

.Always
	db RAIKOU
	db ENTEI
;	db SUICUNE
	db $ff
; 3c5b4


Function3c5b4: ; 3c5b4
	ld a, [CurPlayerMove]
	call GetMovePriority
	ld b, a
	push bc
	ld a, [CurEnemyMove]
	call GetMovePriority
	pop bc
	cp b
	ret
; 3c5c5

GetMovePriority: ; 3c5c5
	ld b, a
	cp VITAL_THROW
	ld a, 0
	ret z
	call Function3c5ec
	ld hl, .data_3c5df
.loop
	ld a, [hli]
	cp b
	jr z, .asm_3c5dd
	inc hl
	cp $ff
	jr nz, .loop
	ld a, 1
	ret

.asm_3c5dd
	ld a, [hl]
	ret
; 3c5df

.data_3c5df
	db EFFECT_PROTECT,      3
	db EFFECT_ENDURE,       3
	db EFFECT_PRIORITY_HIT, 2
	db EFFECT_WHIRLWIND,    0
	db EFFECT_COUNTER,      0
	db EFFECT_MIRROR_COAT,  0
	db $ff
; 3c5ec


Function3c5ec: ; 3c5ec
	ld a, b
	dec a
	ld hl, $5afc
	ld bc, $0007
	call AddNTimes
	ld a, $10
	call GetFarByte
	ld b, a
	ret
; 3c5fe

Function3c5fe: ; 3c5fe
	call Function309d
	call Function3c543
	jp c, Function3c0e5
	call SetEnemyTurn
	ld a, $1
	ld [$c70f], a
	callab Function38000
	jr c, .asm_3c62f
	call Function3c6de
	call Function3d2e0
	ret c
	ld a, [$d232]
	and a
	ret nz
	call $4710
	jp z, Function3d14e
	call $470b
	jp z, Function3cd55

.asm_3c62f
	call SetEnemyTurn
	call Function3c716
	jp z, Function3cd55
	call RefreshBattleHuds
	call Function3c6cf
	call Function3d2e0
	ret c
	ld a, [$d232]
	and a
	ret nz
	call $470b
	jp z, Function3cd55
	call $4710
	jp z, Function3d14e
	call SetPlayerTurn
	call Function3c716
	jp z, Function3d14e
	call RefreshBattleHuds
	xor a
	ld [$d0ec], a
	ret
; 3c664

Function3c664: ; 3c664
	xor a
	ld [$c70f], a
	call SetEnemyTurn
	callab Function38000
	push af
	call Function3c6cf
	pop bc
	ld a, [$d232]
	and a
	ret nz
	call Function3d2e0
	ret c
	call $470b
	jp z, Function3cd55
	call $4710
	jp z, Function3d14e
	push bc
	call SetPlayerTurn
	call Function3c716
	pop bc
	jp z, Function3d14e
	push bc
	call RefreshBattleHuds
	pop af
	jr c, .asm_3c6be
	call Function309d
	call Function3c543
	jp c, Function3c0e5
	call Function3c6de
	call Function3d2e0
	ret c
	ld a, [$d232]
	and a
	ret nz
	call $4710
	jp z, Function3d14e
	call $470b
	jp z, Function3cd55

.asm_3c6be
	call SetEnemyTurn
	call Function3c716
	jp z, Function3cd55
	call RefreshBattleHuds
	xor a
	ld [$d0ec], a
	ret
; 3c6cf

Function3c6cf: ; 3c6cf
	call SetPlayerTurn
	call Function3c6fe
	callab DoPlayerTurn
	jp Function3c6ed
; 3c6de

Function3c6de: ; 3c6de
	call SetEnemyTurn
	call Function3c6fe
	callab DoEnemyTurn
	jp Function3c6ed
; 3c6ed

Function3c6ed: ; 3c6ed
	ld a, $5
	call GetBattleVarPair
	res 2, [hl]
	res 5, [hl]
	ld a, $9
	call GetBattleVarPair
	res 6, [hl]
	ret
; 3c6fe

Function3c6fe: ; 3c6fe
	ld a, $4
	call GetBattleVarPair
	res 6, [hl]
	ret
; 3c706

Function3c706: ; 3c706
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3c710
	ld hl, EnemyMonHPHi
	jr .asm_3c713

.asm_3c710
	ld hl, BattleMonHP

.asm_3c713
	ld a, [hli]
	or [hl]
	ret
; 3c716

Function3c716: ; 3c716
	call Function3c706
	ret z
	ld a, $a
	call CleanGetBattleVarPair
	and $18
	jr z, .asm_3c768
	ld hl, $47e2
	ld de, $0106
	and $10
	jr z, .asm_3c733
	ld hl, $47f8
	ld de, $0105

.asm_3c733
	push de
	call StdBattleTextBox
	pop de
	xor a
	ld [$cfca], a
	call Function3ee0f
	call GetEighthMaxHP
	ld de, $c674
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3c74d
	ld de, $c67c

.asm_3c74d
	ld a, $4
	call CleanGetBattleVarPair
	bit 0, a
	jr z, .asm_3c765
	call Function3cc76
	ld a, [de]
	inc a
	ld [de], a
	ld hl, $0000
.asm_3c75f
	add hl, bc
	dec a
	jr nz, .asm_3c75f
	ld b, h
	ld c, l

.asm_3c765
	call Function3cc3f

.asm_3c768
	call Function3c706
	jp z, $47f7
	ld a, $3
	call GetBattleVarPair
	bit 7, [hl]
	jr z, .asm_3c7a1
	call Function3c8e4
	xor a
	ld [$cfca], a
	ld de, $0107
	ld a, $7
	call CleanGetBattleVarPair
	and $60
	call z, Function3ee0f
	call Function3c8e4
	call GetEighthMaxHP
	call Function3cc3f
	ld a, $1
	ld [hBGMapMode], a
	call Function3ccef
	ld hl, $480e
	call StdBattleTextBox

.asm_3c7a1
	call Function3c706
	jr z, .asm_3c7f7
	ld a, $0
	call GetBattleVarPair
	bit 0, [hl]
	jr z, .asm_3c7c5
	xor a
	ld [$cfca], a
	ld de, $010c
	call Function3ee0f
	call GetQuarterMaxHP
	call Function3cc3f
	ld hl, $4822
	call StdBattleTextBox

.asm_3c7c5
	call Function3c706
	jr z, .asm_3c7f7
	ld a, $0
	call GetBattleVarPair
	bit 1, [hl]
	jr z, .asm_3c7e9
	xor a
	ld [$cfca], a
	ld de, $010c
	call Function3ee0f
	call GetQuarterMaxHP
	call Function3cc3f
	ld hl, $4836
	call StdBattleTextBox

.asm_3c7e9
	ld hl, BattleMonHP
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3c7f4
	ld hl, EnemyMonHPHi

.asm_3c7f4
	ld a, [hli]
	or [hl]
	ret nz

.asm_3c7f7
	call RefreshBattleHuds
	ld c, $14
	call DelayFrames
	xor a
	ret
; 3c801

Function3c801: ; 3c801
	ld a, [$ffcb]
	cp $1
	jr z, .asm_3c813
	call SetPlayerTurn
	call $481c
	call SetEnemyTurn
	jp $481c

.asm_3c813
	call SetEnemyTurn
	call $481c
	call SetPlayerTurn
	ld hl, PlayerPerishCount
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3c827
	ld hl, EnemyPerishCount

.asm_3c827
	ld a, $0
	call CleanGetBattleVarPair
	bit 4, a
	ret z
	dec [hl]
	ld a, [hl]
	ld [$d265], a
	push af
	ld hl, $4864
	call StdBattleTextBox
	pop af
	ret nz
	ld a, $0
	call GetBattleVarPair
	res 4, [hl]
	ld a, [hBattleTurn]
	and a
	jr nz, .asm_3c85c
	ld hl, BattleMonHP
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, PartyMon1CurHP
	ld a, [CurBattleMon]
	call GetPartyLocation
	xor a
	ld [hli], a
	ld [hl], a
	ret

.asm_3c85c
	ld hl, EnemyMonHPHi
	xor a
	ld [hli], a
	ld [hl], a
	ld a, [IsInBattle]
	dec a
	ret z
	ld hl, OTPartyMon1CurHP
	ld a, [CurOTMon]
	call GetPartyLocation
	xor a
	ld [hli], a
	ld [hl], a
	ret
; 3c874

Function3c874: ; 3c874
	ld a, [$ffcb]
	cp $1
	jr z, .asm_3c886
	call SetPlayerTurn
	call $488f
	call SetEnemyTurn
	jp $488f

.asm_3c886
	call SetEnemyTurn
	call $488f
	call SetPlayerTurn
	ld hl, $c730
	ld de, $c72e
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3c8a0
	ld hl, $c731
	ld de, $c72f

.asm_3c8a0
	ld a, [hl]
	and a
	ret z
	ld a, $3
	call CleanGetBattleVarPair
	bit 4, a
	ret nz
	ld a, [de]
	ld [$d265], a
	ld [FXAnimIDLo], a
	call GetMoveName
	dec [hl]
	jr z, .asm_3c8de
	ld a, $2
	call CleanGetBattleVarPair
	and $60
	jr nz, .asm_3c8d3
	call Function3c8e4
	xor a
	ld [$cfca], a
	ld [FXAnimIDHi], a
	ld a, $37
	call Predef
	call Function3c8e4

.asm_3c8d3
	call Function3cc76
	call Function3cc3f
	ld hl, $4de2
	jr .asm_3c8e1

.asm_3c8de
	ld hl, $4df5

.asm_3c8e1
	jp StdBattleTextBox
; 3c8e4

Function3c8e4: ; 3c8e4
	ld a, [hBattleTurn]
	xor $1
	ld [hBattleTurn], a
	ret
; 3c8eb

Function3c8eb: ; 3c8eb
	ld a, [$ffcb]
	cp $1
	jr z, .asm_3c8fd
	call SetPlayerTurn
	call $4906
	call SetEnemyTurn
	jp $4906

.asm_3c8fd
	call SetEnemyTurn
	call $4906
	call SetPlayerTurn
	callab GetUserItem
	ld a, [hl]
	ld [$d265], a
	call GetItemName
	ld a, b
	cp $3
	ret nz
	ld hl, BattleMonHP
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3c922
	ld hl, EnemyMonHPHi

.asm_3c922
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	cp b
	jr nz, .asm_3c92d
	ld a, [hl]
	cp c
	ret z

.asm_3c92d
	call Function3cc76
	call Function3c8e4
	call Function3ccef
	ld hl, $4880
	jp StdBattleTextBox
; 3c93c

Function3c93c: ; 3c93c
	ld a, [$ffcb]
	cp $1
	jr z, .asm_3c94e
	call SetPlayerTurn
	call $4957
	call SetEnemyTurn
	jp $4957

.asm_3c94e
	call SetEnemyTurn
	call $4957
	call SetPlayerTurn
	callab GetUserItem
	ld a, b
	cp $6
	jr nz, .asm_3c9ae
	ld hl, PartyMon1PP
	ld a, [CurBattleMon]
	call GetPartyLocation
	ld d, h
	ld e, l
	ld hl, PartyMon1Move1
	ld a, [CurBattleMon]
	call GetPartyLocation
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3c99b
	ld de, $c739
	ld hl, $c735
	ld a, [IsInBattle]
	dec a
	jr z, .asm_3c99b
	ld hl, OTPartyMon1PPMove1
	ld a, [CurOTMon]
	call GetPartyLocation
	ld d, h
	ld e, l
	ld hl, OTPartyMon1Move1
	ld a, [CurOTMon]
	call GetPartyLocation

.asm_3c99b
	ld c, $0
.asm_3c99d
	ld a, [hl]
	and a
	jr z, .asm_3c9ae
	ld a, [de]
	and $3f
	jr z, .asm_3c9af
	inc hl
	inc de
	inc c
	ld a, c
	cp $4
	jr nz, .asm_3c99d

.asm_3c9ae
	ret

.asm_3c9af
	ld a, [hl]
	cp $a6
	ld b, $1
	jr z, .asm_3c9b8
	ld b, $5

.asm_3c9b8
	ld a, [de]
	add b
	ld [de], a
	push bc
	push bc
	ld a, [hl]
	ld [$d265], a
	ld de, BattleMonItem
	ld hl, BattleMonPPMove1
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3c9d2
	ld de, EnemyMonItem
	ld hl, EnemyMonPPMove1

.asm_3c9d2
	inc de
	pop bc
	ld b, $0
	add hl, bc
	push hl
	ld h, d
	ld l, e
	add hl, bc
	pop de
	pop bc
	ld a, [$d265]
	cp [hl]
	jr nz, .asm_3c9f5
	ld a, [hBattleTurn]
	and a
	ld a, [PlayerSubStatus5]
	jr z, .asm_3c9ee
	ld a, [EnemySubStatus5]

.asm_3c9ee
	bit 3, a
	jr nz, .asm_3c9f5
	ld a, [de]
	add b
	ld [de], a

.asm_3c9f5
	callab GetUserItem
	ld a, [hl]
	ld [$d265], a
	xor a
	ld [hl], a
	call Function3df12
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3ca12
	ld a, [IsInBattle]
	dec a
	jr z, .asm_3ca14
	call Function3df1f

.asm_3ca12
	xor a
	ld [hl], a

.asm_3ca14
	call GetItemName
	call Function3c8e4
	call Function3ddc8
	call Function3c8e4
	ld hl, $4899
	jp StdBattleTextBox
; 3ca26

Function3ca26: ; 3ca26
	ld a, [$ffcb]
	cp $1
	jr z, .asm_3ca38
	call SetPlayerTurn
	call $4a41
	call SetEnemyTurn
	jp $4a41

.asm_3ca38
	call SetEnemyTurn
	call $4a41
	call SetPlayerTurn
	ld hl, $c71d
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3ca4c
	ld hl, $c71e

.asm_3ca4c
	ld a, [hl]
	and a
	ret z
	dec a
	ld [hl], a
	cp $1
	ret nz
	ld hl, $48b6
	call StdBattleTextBox
	ld a, $10
	call GetBattleVarPair
	push af
	ld a, $f8
	ld [hl], a
	callab UpdateMoveData
	xor a
	ld [AttackMissed], a
	ld [AlreadyDisobeyed], a
	ld a, $a
	ld [TypeModifier], a
	callab DoMove
	xor a
	ld [CurDamage], a
	ld [$d257], a
	ld a, $10
	call GetBattleVarPair
	pop af
	ld [hl], a
	call UpdateBattleMonInParty
	jp UpdateEnemyMonInParty
; 3ca8f

Function3ca8f: ; 3ca8f
	ld a, [$ffcb]
	cp $1
	jr z, .asm_3ca9a
	call $4a9d
	jr .asm_3cac9

.asm_3ca9a
	call $4ac9
	ld a, [BattleMonStatus]
	bit 5, a
	ret z
	ld a, [$c73f]
	and a
	ret nz
	call BattleRandom
	cp $19
	ret nc
	xor a
	ld [BattleMonStatus], a
	ld a, [CurBattleMon]
	ld hl, PartyMon1Status
	call GetPartyLocation
	ld [hl], $0
	call UpdateBattleHuds
	call SetEnemyTurn
	ld hl, $524b
	jp StdBattleTextBox

.asm_3cac9
	ld a, [EnemyMonStatus]
	bit 5, a
	ret z
	ld a, [$c740]
	and a
	ret nz
	call BattleRandom
	cp $19
	ret nc
	xor a
	ld [EnemyMonStatus], a
	ld a, [IsInBattle]
	dec a
	jr z, .asm_3caef
	ld a, [CurOTMon]
	ld hl, OTPartyMon1Status
	call GetPartyLocation
	ld [hl], $0

.asm_3caef
	call UpdateBattleHuds
	call SetPlayerTurn
	ld hl, $524b
	jp StdBattleTextBox
; 3cafb

Function3cafb: ; 3cafb
	ld a, [$ffcb]
	cp $1
	jr z, .asm_3cb06
	call $4b09
	jr .asm_3cb1c

.asm_3cb06
	call $4b1c
	ld a, [PlayerScreens]
	bit 2, a
	ret z
	ld hl, $c701
	dec [hl]
	ret nz
	res 2, a
	ld [PlayerScreens], a
	xor a
	jr .asm_3cb2e

.asm_3cb1c
	ld a, [EnemyScreens]
	bit 2, a
	ret z
	ld hl, $c705
	dec [hl]
	ret nz
	res 2, a
	ld [EnemyScreens], a
	ld a, $1

.asm_3cb2e
	ld [hBattleTurn], a
	ld hl, $48d2
	jp StdBattleTextBox
; 3cb36


Function3cb36: ; 3cb36
	ld a, [$ffcb]
	cp 1
	jr z, .Both
	call .CheckPlayer
	jr .CheckEnemy

.Both
	call .CheckEnemy

.CheckPlayer
	call SetPlayerTurn
	ld de, .Your
	call .asm_3cb6f
	ld hl, PlayerScreens
	ld de, PlayerLightScreenCount
	jr .FadeScreens

.CheckEnemy
	call SetEnemyTurn
	ld de, .Enemy
	call .asm_3cb6f
	ld hl, EnemyScreens
	ld de, EnemyLightScreenCount

.FadeScreens
	bit SCREENS_LIGHT_SCREEN, [hl]
	call nz, FadeLightScreen
	bit SCREENS_REFLECT, [hl]
	call nz, FadeReflect
	ret

.asm_3cb6f
	ld hl, StringBuffer1
	jp CopyName2
; 3cb75

.Your
	db "Your@"
.Enemy
	db "Enemy@"
; 3cb80


FadeLightScreen: ; 3cb80
	ld a, [de]
	dec a
	ld [de], a
	ret nz
	res SCREENS_LIGHT_SCREEN, [hl]
	push hl
	push de
	ld hl, BattleText_0x808e7
	call StdBattleTextBox
	pop de
	pop hl
	ret
; 3cb91

FadeReflect: ; 3cb91
	inc de
	ld a, [de]
	dec a
	ld [de], a
	ret nz
	res SCREENS_REFLECT, [hl]
	ld hl, BattleText_0x80905
	jp StdBattleTextBox
; 3cb9e

HandleWeather: ; 3cb9e

	ld a, [Weather]
	cp 0
	ret z

	ld hl, WeatherCount
	dec [hl]
	jr z, .asm_3cc13

	ld hl, .WeatherMessages
	call .asm_3cc1e
	ld a, [Weather]
	cp WEATHER_SANDSTORM
	ret nz
	ld a, [$ffcb]
	cp 1
	jr z, .asm_3cbc7

; Player first
	call SetPlayerTurn
	call .asm_3cbd0
	call SetEnemyTurn
	jr .asm_3cbd0

.asm_3cbc7
; Enemy first
	call SetEnemyTurn
	call .asm_3cbd0
	call SetPlayerTurn

.asm_3cbd0
	ld a, BATTLE_VARS_SUBSTATUS3
	call CleanGetBattleVarPair
	bit SUBSTATUS_UNDERGROUND, a
	ret nz

	ld hl, BattleMonType1
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3cbe3
	ld hl, EnemyMonType1

.asm_3cbe3
	ld a, [hli]
	cp ROCK
	ret z
	cp GROUND
	ret z
	cp STEEL
	ret z

	ld a, [hl]
	cp ROCK
	ret z
	cp GROUND
	ret z
	cp STEEL
	ret z

	call Function3c8e4
	xor a
	ld [$cfca], a
	ld de, $010b
	call Function3ee17
	call Function3c8e4
	call GetEighthMaxHP
	call Function3cc3f

	ld hl, BattleText_0x8084d
	jp StdBattleTextBox

.asm_3cc13
	ld hl, .WeatherEndedMessages
	call .asm_3cc1e
	xor a
	ld [Weather], a
	ret

.asm_3cc1e
	ld a, [Weather]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp StdBattleTextBox
; 3cc2d

.WeatherMessages
	dw BattleText_0x8091f
	dw BattleText_0x80938
	dw BattleText_0x80951
.WeatherEndedMessages
	dw BattleText_0x80967
	dw BattleText_0x8097a
	dw BattleText_0x8098f
; 3cc39

Function3cc39: ; 3cc39
	call Function3cc45
	jp Function3cd3c
; 3cc3f

Function3cc3f: ; 3cc3f
	call Function3cc45
	jp Function3cd36
; 3cc45



Function3cc45: ; 3cc45
	ld hl, BattleMonHP
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3cc50
	ld hl, EnemyMonHPHi

.asm_3cc50
	inc hl
	ld a, [hl]
	ld [$d1ec], a
	sub c
	ld [hld], a
	ld [$d1ee], a
	ld a, [hl]
	ld [$d1ed], a
	sbc b
	ld [hl], a
	ld [$d1ef], a
	ret nc
	ld a, [$d1ec]
	ld c, a
	ld a, [$d1ed]
	ld b, a
	xor a
	ld [hli], a
	ld [hl], a
	ld [$d1ee], a
	ld [$d1ef], a
	ret
; 3cc76

Function3cc76: ; 3cc76
	call GetQuarterMaxHP
	srl c
	srl c
	ld a, c
	and a
	jr nz, .asm_3cc82
	inc c

.asm_3cc82
	ret
; 3cc83


GetEighthMaxHP: ; 3cc83
; output: bc
	call GetQuarterMaxHP
; assumes nothing can have 1024 or more hp
; halve result
	srl c
; round up
	ld a, c
	and a
	jr nz, .end
	inc c
.end
	ret
; 3cc8e


GetQuarterMaxHP: ; 3cc8e
; output: bc
	call GetMaxHP

; quarter result
	srl b
	rr c
	srl b
	rr c

; assumes nothing can have 1024 or more hp
; round up
	ld a, c
	and a
	jr nz, .end
	inc c
.end
	ret
; 3cc9f


GetHalfMaxHP: ; 3cc9f
; output: bc
	call GetMaxHP

; halve reslut
	srl b
	rr c

; floor = 1
	ld a, c
	or b
	jr nz, .end
	inc c
.end
	ret
; 3ccac


GetMaxHP: ; 3ccac
; output: bc, Buffer1-2

; player
	ld hl, BattleMonMaxHP

; whose turn?
	ld a, [hBattleTurn]
	and a
	jr z, .gethp

; enemy
	ld hl, EnemyMonMaxHP

.gethp
	ld a, [hli]
	ld [Buffer2], a
	ld b, a

	ld a, [hl]
	ld [Buffer1], a
	ld c, a
	ret
; 3ccc2

Function3ccc2: ; 3ccc2
	ld hl, BattleMonHP
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3cccd
	ld hl, EnemyMonHP

.asm_3cccd
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	srl b
	rr c
	ld a, [hli]
	ld [Buffer2], a
	ld a, [hl]
	ld [Buffer1], a
	ret
; 3ccde

Function3ccde: ; 3ccde
	ld hl, BattleMonHP + 1
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3cce9
	ld hl, EnemyMonHP + 1

.asm_3cce9
	ld a, c
	sub [hl]
	dec hl
	ld a, b
	sbc [hl]
	ret
; 3ccef


Function3ccef: ; 3ccef
	ld hl, EnemyMonMaxHP
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3ccfa
	ld hl, BattleMonMaxHP

.asm_3ccfa
	ld a, [hli]
	ld [Buffer2], a
	ld a, [hld]
	ld [Buffer1], a
	dec hl
	ld a, [hl]
	ld [$d1ec], a
	add c
	ld [hld], a
	ld [$d1ee], a
	ld a, [hl]
	ld [$d1ed], a
	adc b
	ld [hli], a
	ld [$d1ef], a
	ld a, [Buffer1]
	ld c, a
	ld a, [hld]
	sub c
	ld a, [Buffer2]
	ld b, a
	ld a, [hl]
	sbc b
	jr c, .asm_3cd2d
	ld a, b
	ld [hli], a
	ld [$d1ef], a
	ld a, c
	ld [hl], a
	ld [$d1ee], a

.asm_3cd2d
	call Function3c8e4
	call Function3cd36
	jp Function3c8e4
; 3cd36

Function3cd36: ; 3cd36
	call Function3cd3c
	jp UpdateBattleHuds
; 3cd3c


Function3cd3c: ; 3cd3c
	ld hl, $c55e
	ld a, [hBattleTurn]
	and a
	ld a, $1
	jr z, .asm_3cd4a
	ld hl, $c4ca
	xor a

.asm_3cd4a
	push bc
	ld [$d10a], a
	ld a, $b
	call Predef
	pop bc
	ret
; 3cd55

Function3cd55: ; 3cd55
	call Function3cf14
	ld hl, BattleMonHP
	ld a, [hli]
	or [hl]
	call z, Function3cef1
	xor a
	ld [$c6f7], a
	call Function3ce01
	call Function3d873
	ld a, d
	and a
	jp z, LostBattle
	ld hl, BattleMonHP
	ld a, [hli]
	or [hl]
	call nz, Function3df48
	ld a, $1
	ld [hBGMapMode], a
	ld c, $3c
	call DelayFrames
	ld a, [IsInBattle]
	dec a
	jr nz, .asm_3cd8c
	ld a, $1
	ld [BattleEnded], a
	ret

.asm_3cd8c
	call Function3cf35
	jp z, Function3cfa4
	ld hl, BattleMonHP
	ld a, [hli]
	or [hl]
	jr nz, .asm_3cdba
	call Function3d1f8
	jr nc, .asm_3cda4
	ld a, $1
	ld [BattleEnded], a
	ret

.asm_3cda4
	call Function3d227
	call Function3d2e0
	jp c, Function3c0e5
	ld a, $1
	ld [$d0ec], a
	call Function3cf4a
	jp z, Function3c0e5
	jr .asm_3cdca

.asm_3cdba
	ld a, $1
	ld [$d0ec], a
	call Function3cf4a
	jp z, Function3c0e5
	xor a
	ld [$d0ec], a
	ret

.asm_3cdca
	ld a, [$ffcb]
	cp $1
	jr z, .asm_3cde6
	call ClearSprites
	ld hl, $c4a1
	ld bc, $040a
	call ClearBox
	call Function3d2b3
	ld a, $1
	call $4f78
	jr .asm_3cdfc

.asm_3cde6
	ld a, [CurPartyMon]
	push af
	ld a, $1
	call $4f78
	call ClearSprites
	call Function309d
	pop af
	ld [CurPartyMon], a
	call Function3d2b3

.asm_3cdfc
	xor a
	ld [$d0ec], a
	ret
; 3ce01

Function3ce01: ; 3ce01
	call UpdateBattleMonInParty
	ld a, [IsInBattle]
	dec a
	jr z, .asm_3ce16
	ld a, [CurOTMon]
	ld hl, OTPartyMon1CurHP
	call GetPartyLocation
	xor a
	ld [hli], a
	ld [hl], a

.asm_3ce16
	ld hl, PlayerSubStatus3
	res 2, [hl]
	xor a
	ld hl, EnemyDamageTaken
	ld [hli], a
	ld [hl], a
	call Function3d834
	call Function3dc18
	ld a, [IsInBattle]
	dec a
	jr z, .asm_3ce2f
	jr .asm_3ce37

.asm_3ce2f
	call Function3ceec
	ld a, $1
	ld [$c6fd], a

.asm_3ce37
	ld hl, BattleMonHP
	ld a, [hli]
	or [hl]
	jr nz, .asm_3ce47
	ld a, [$c6f7]
	and a
	jr nz, .asm_3ce47
	call Function3d1aa

.asm_3ce47
	call Function3d873
	ld a, d
	and a
	ret z
	ld a, [IsInBattle]
	dec a
	call z, Function3d0ea
	call EmptyBattleTextBox
	call Function309d
	ld a, [$d0ee]
	and $c0
	ld [$d0ee], a
	call Function3ceaa
	jr z, .asm_3ce72
	ld hl, EnemyMonBaseStats
	ld b, $7
.asm_3ce6c
	srl [hl]
	inc hl
	dec b
	jr nz, .asm_3ce6c

.asm_3ce72
	ld hl, EnemyMonBaseStats
	ld de, $c720
	ld bc, $0007
	call CopyBytes
	xor a
	ld [$c71f], a
	call Function3ee3b
	call Function3ceaa
	ret z
	ld a, [$c664]
	push af
	ld a, d
	ld [$c664], a
	ld hl, $c720
	ld de, EnemyMonBaseStats
	ld bc, $0007
	call CopyBytes
	ld a, $1
	ld [$c71f], a
	call Function3ee3b
	pop af
	ld [$c664], a
	ret
; 3ceaa

Function3ceaa: ; 3ceaa
	ld a, [PartyCount]
	ld b, a
	ld hl, PartyMon1Species
	ld c, $1
	ld d, $0
.asm_3ceb5
	push hl
	push bc
	ld bc, $0022
	add hl, bc
	ld a, [hli]
	or [hl]
	pop bc
	pop hl
	jr z, .asm_3ced1
	push hl
	push bc
	ld bc, $0001
	add hl, bc
	pop bc
	ld a, [hl]
	pop hl
	cp $39
	jr nz, .asm_3ced1
	ld a, d
	or c
	ld d, a

.asm_3ced1
	sla c
	push de
	ld de, $0030
	add hl, de
	pop de
	dec b
	jr nz, .asm_3ceb5
	ld a, d
	ld e, $0
	ld b, $6
.asm_3cee1
	srl a
	jr nc, .asm_3cee6
	inc e

.asm_3cee6
	dec b
	jr nz, .asm_3cee1
	ld a, e
	and a
	ret
; 3ceec



Function3ceec: ; 3ceec
	xor a
	ld [Danger], a
	ret
; 3cef1

Function3cef1: ; 3cef1
	call Function3ceec
	call WaitSFX
	ld a, $f0
	ld [CryTracks], a
	ld a, [BattleMonSpecies]
	call Function37b6
	call Function3d43b
	ld hl, $c535
	ld bc, $050b
	call ClearBox
	ld hl, BattleText_0x80a75
	jp StdBattleTextBox
; 3cf14

Function3cf14: ; 3cf14
	call WaitSFX
	ld de, SFX_KINESIS
	call StartSFX
	call Function3d432
	ld de, SFX_UNKNOWN_2A
	call StartSFX
	hlcoord 1, 0
	ld bc, $040a
	call ClearBox
	ld hl, BattleText_0x809a8
	jp StdBattleTextBox
; 3cf35

Function3cf35: ; 3cf35
	ld a, [OTPartyCount]
	ld b, a
	xor a
	ld hl, OTPartyMon1CurHP
	ld de, $0030
.asm_3cf40
	or [hl]
	inc hl
	or [hl]
	dec hl
	add hl, de
	dec b
	jr nz, .asm_3cf40
	and a
	ret
; 3cf4a

Function3cf4a: ; 3cf4a
	ld hl, EnemyHPPal
	ld e, $30
	call Function3e12e
	call WaitBGMap
	ld a, $b
	ld hl, $4012
	rst FarCall
	ld a, [InLinkBattle]
	and a
	jr z, .asm_3cf6d
	call Function3e8e4
	ld a, [$d430]
	cp $f
	ret z
	call Function30b4

.asm_3cf6d
	ld hl, BattleMonHP
	ld a, [hli]
	or [hl]
	ld a, $0
	jr nz, .asm_3cf78
	inc a
	ret

.asm_3cf78
	push af
	xor a
	ld [$c718], a
	call Function3d834
	call Function3d867
	call Function3dc18
	pop af
	and a
	jr nz, .asm_3cf8f
	call Function3d4e1
	jr .asm_3cf92

.asm_3cf8f
	call $5517

.asm_3cf92
	call Function3d57a
	call SetEnemyTurn
	call Function3dc23
	xor a
	ld [EnemyMoveAnimation], a
	ld [$d0ec], a
	inc a
	ret
; 3cfa4

Function3cfa4: ; 3cfa4
	call Function3ceec
	ld a, $1
	ld [$c6fd], a
	ld [BattleEnded], a
	ld a, [InLinkBattle]
	and a
	ld a, b
	call z, Function3d0ea
	callab Function39939
	ld hl, BattleText_0x809da
	call StdBattleTextBox
	call Function3d2f1
	jr z, .asm_3cff5
	ld a, [InLinkBattle]
	and a
	ret nz
	ld a, [$cfc0]
	bit 0, a
	jr nz, .asm_3d006
	call Function3ebd8
	ld c, $28
	call DelayFrames
	ld a, [BattleType]
	cp $1
	jr nz, .asm_3cfe8
	ld a, $2
	call Predef

.asm_3cfe8
	ld a, [$c2cc]
	bit 0, a
	jr nz, .asm_3cff2
	call Function3718

.asm_3cff2
	jp Function3d02b

.asm_3cff5
	call Function3ebd8
	ld c, $28
	call DelayFrames
	ld c, $4
	ld a, $13
	ld hl, $6a0a
	rst FarCall
	ret

.asm_3d006
	call Function3ebd8
	ld c, $28
	call DelayFrames
	call EmptyBattleTextBox
	ld c, $3
	ld a, $47
	ld hl, $4000
	rst FarCall
	call Functiona80
	ld hl, $c6ec
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	ret nz
	call ClearTileMap
	call WhiteBGMap
	ret
; 3d02b

Function3d02b: ; 3d02b
	ld a, [$c73d]
	and a
	call nz, Function3d099
	call Function3d0b1
	push af
	ld a, $0
	jr nc, .asm_3d044
	ld a, [$d854]
	and $7
	cp $3
	jr nz, .asm_3d044
	inc a

.asm_3d044
	ld b, a
	ld c, $4
.asm_3d047
	ld a, b
	and a
	jr z, .asm_3d052
	call Function3d081
	dec c
	dec b
	jr .asm_3d047

.asm_3d052
	ld a, c
	and a
	jr z, .asm_3d05c
	call Function3d08d
	dec c
	jr .asm_3d052

.asm_3d05c
	call Function3d099
	call Function3d099
	pop af
	jr nc, .asm_3d07b
	ld a, [$d854]
	and $7
	jr z, .asm_3d07b
	ld hl, SentToMomTexts
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp StdBattleTextBox

.asm_3d07b
	ld hl, BattleText_0x809be
	jp StdBattleTextBox
; 3d081

Function3d081: ; 3d081
	push bc
	ld hl, $c688
	ld de, $d853
	call Function3d0be
	pop bc
	ret
; 3d08d

Function3d08d: ; 3d08d
	push bc
	ld hl, $c688
	ld de, $d850
	call Function3d0be
	pop bc
	ret
; 3d099

Function3d099: ; 3d099
	ld hl, $c688
	sla [hl]
	dec hl
	rl [hl]
	dec hl
	rl [hl]
	ret nc
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret
; 3d0ab

SentToMomTexts: ; 3d0ab
	dw BattleText_0x809fc
	dw BattleText_0x80a2a
	dw BattleText_0x80a3d
; 3d0b1


Function3d0b1: ; 3d0b1
	ld hl, $d853
	ld a, [hld]
	cp $3f
	ld a, [hld]
	sbc $42
	ld a, [hl]
	sbc $f
	ret
; 3d0be

Function3d0be: ; 3d0be
	ld c, $3
	and a
	push de
	push hl
	push bc
	ld b, h
	ld c, l
	ld a, $41
	ld hl, $6008
	rst FarCall
	pop bc
	pop hl
.asm_3d0ce
	ld a, [de]
	adc [hl]
	ld [de], a
	dec de
	dec hl
	dec c
	jr nz, .asm_3d0ce
	pop hl
	ld a, [hld]
	cp $3f
	ld a, [hld]
	sbc $42
	ld a, [hl]
	sbc $f
	ret c
	ld [hl], $f
	inc hl
	ld [hl], $42
	inc hl
	ld [hl], $3f
	ret
; 3d0ea

Function3d0ea: ; 3d0ea
	push de
	ld de, MUSIC_NONE
	call StartMusic
	call DelayFrame
	ld de, MUSIC_WILD_VICTORY
	ld a, [IsInBattle]
	dec a
	jr nz, .asm_3d113
	push de
	call Function3ceaa
	pop de
	jr nz, .asm_3d11e
	ld hl, $c6ec
	ld a, [hli]
	or [hl]
	jr nz, .asm_3d11e
	ld a, [$c664]
	and a
	jr z, .asm_3d121
	jr .asm_3d11e

.asm_3d113
	ld de, MUSIC_GYM_VICTORY
	call IsJohtoGymLeader
	jr c, .asm_3d11e
	ld de, MUSIC_TRAINER_VICTORY

.asm_3d11e
	call StartMusic

.asm_3d121
	pop de
	ret
; 3d123



; These functions check if the current opponent is a gym leader or one of a
; few other special trainers.

; Note: KantoGymLeaders is a subset of JohtoGymLeaders. If you wish to
; differentiate between the two, call IsKantoGymLeader first.

; The Lance and Red entries are unused for music checks; those trainers are
; accounted for elsewhere.

IsKantoGymLeader: ; 0x3d123
	ld hl, KantoGymLeaders
	jr IsGymLeaderCommon

IsJohtoGymLeader: ; 0x3d128
	ld hl, JohtoGymLeaders
IsGymLeaderCommon:
	push de
	ld a, [OtherTrainerClass]
	ld de, $0001
	call IsInArray
	pop de
	ret
; 0x3d137

JohtoGymLeaders:
	db FALKNER
	db WHITNEY
	db BUGSY
	db MORTY
	db PRYCE
	db JASMINE
	db CHUCK
	db CLAIR
	db WILL
	db BRUNO
	db KAREN
	db KOGA
; fallthrough
; these two entries are unused
	db CHAMPION
	db RED
; fallthrough
KantoGymLeaders:
	db BROCK
	db MISTY
	db LT_SURGE
	db ERIKA
	db JANINE
	db SABRINA
	db BLAINE
	db BLUE
	db $ff


Function3d14e: ; 3d14e
	call Function3cef1
	ld hl, EnemyMonHPHi
	ld a, [hli]
	or [hl]
	call z, Function3cf14
	ld a, $1
	ld [$c6f7], a
	call Function3d1aa
	call Function3d873
	ld a, d
	and a
	jp z, LostBattle
	ld hl, EnemyMonHPHi
	ld a, [hli]
	or [hl]
	jr nz, .asm_3d185
	call Function3ce01
	ld a, [IsInBattle]
	dec a
	jr nz, .asm_3d17f
	ld a, $1
	ld [BattleEnded], a
	ret

.asm_3d17f
	call Function3cf35
	jp z, Function3cfa4

.asm_3d185
	call Function3d1f8
	jr nc, .asm_3d190
	ld a, $1
	ld [BattleEnded], a
	ret

.asm_3d190
	call Function3d227
	call Function3d2e0
	jp c, Function3c0e5
	ld a, c
	and a
	ret nz
	ld a, $1
	ld [$d0ec], a
	call Function3cf4a
	jp z, Function3c0e5
	jp $4dca
; 3d1aa

Function3d1aa: ; 3d1aa
	ld a, [CurBattleMon]
	ld c, a
	ld hl, $c664
	ld b, $0
	ld a, $3
	call Predef
	ld hl, EnemySubStatus3
	res 2, [hl]
	xor a
	ld [Danger], a
	ld hl, PlayerDamageTaken
	ld [hli], a
	ld [hl], a
	ld [BattleMonStatus], a
	call UpdateBattleMonInParty
	ld c, $6
	ld a, [BattleMonLevel]
	add $1e
	ld b, a
	ld a, [EnemyMonLevel]
	cp b
	jr c, .asm_3d1dc
	ld c, $8

.asm_3d1dc
	ld a, [CurBattleMon]
	ld [CurPartyMon], a
	callab ChangeHappiness
	ld a, [$d0ee]
	and $c0
	add $1
	ld [$d0ee], a
	ld a, [$c6f7]
	and a
	ret z
	ret
; 3d1f8

Function3d1f8: ; 3d1f8
	call EmptyBattleTextBox
	call Function309d
	ld a, [IsInBattle]
	and a
	dec a
	ret nz
	ld hl, BattleText_0x80a83
	call StdBattleTextBox
.asm_3d20a
	ld bc, $0107
	call Function1dd2
	ld a, [$cfa9]
	jr c, .asm_3d217
	and a
	ret

.asm_3d217
	ld a, [$cfa9]
	cp $1
	jr z, .asm_3d20a
	ld hl, PartyMon1Spd
	ld de, EnemyMonSpd
	jp Function3d8b3
; 3d227

Function3d227: ; 3d227
	call EmptyBattleTextBox
	call Function1d6e
	call Function3d2f7
	call Function3d362
	ld a, [InLinkBattle]
	and a
	jr z, .asm_3d241
	ld a, $1
	ld [$d0ec], a
	call Function3e8e4

.asm_3d241
	xor a
	ld [$d0ec], a
	call Function3d2e0
	jr c, .asm_3d251
	ld hl, EnemyMonHPHi
	ld a, [hli]
	or [hl]
	jr nz, .asm_3d26c

.asm_3d251
	call ClearSprites
	call WhiteBGMap
	call Function3eda6
	call Function1c07
	call Function309d
	call WaitBGMap
	call ClearSGB
	call Function32f9
	xor a
	ld c, a
	ret

.asm_3d26c
	call ClearSprites
	ld a, [CurBattleMon]
	ld [$c71a], a
	ld a, [CurPartyMon]
	ld [CurBattleMon], a
	call $5581
	call Function3da0d
	call Function3dab1
	call ClearPalettes
	call DelayFrame
	call Function3eda6
	call Function1c17
	call ClearSGB
	call Function32f9
	call Function3f26d
	call Function3dbde
	call Function3dc18
	call Function3db5f
	call EmptyBattleTextBox
	call Function309d
	call SetPlayerTurn
	call Function3dc23
	ld a, $1
	and a
	ld c, a
	ret
; 3d2b3

Function3d2b3: ; 3d2b3
	ld a, [CurBattleMon]
	ld [$c71a], a
	ld a, [CurPartyMon]
	ld [CurBattleMon], a
	call $5581
	call Function3da0d
	call Function3dab1
	call Function3f26d
	call Function3dbde
	call Function3dc18
	call Function3db5f
	call EmptyBattleTextBox
	call Function309d
	call SetPlayerTurn
	jp Function3dc23
; 3d2e0



Function3d2e0: ; 3d2e0
	ld a, [InLinkBattle]
	cp $4
	jr nz, .asm_3d2ef
	ld a, [$cd2b]
	and a
	jr z, .asm_3d2ef
	scf
	ret

.asm_3d2ef
	xor a
	ret
; 3d2f1

Function3d2f1: ; 3d2f1
	ld a, [InLinkBattle]
	cp $4
	ret
; 3d2f7

Function3d2f7: ; 3d2f7
	call WhiteBGMap
	callba Function5004f
	callba Function50405
	ld a, $2
	ld hl, $4e85
	rst FarCall
	callba Function503e0
	ret
; 3d313

Function3d313: ; 3d313
	callba WritePartyMenuTilemap
	callba PrintPartyMenuText
	call WaitBGMap
	call Function32f9
	call DelayFrame
	ret
; 3d329

Function3d329: ; 3d329
	call Function3d2f1
	jr z, .asm_3d335
	callba PartyMenuSelect
	ret

.asm_3d335
	ld a, $40
	ld hl, $4cb5
	rst FarCall
	ret
; 3d33c

Function3d33c: ; 3d33c
.asm_3d33c
	ld a, $2
	ld [PartyMenuActionText], a
	call Function3d313
	call Function3d329
	ret c
	call Function3d887
	jr z, .asm_3d33c
	xor a
	ret
; 3d34f

Function3d34f: ; 3d34f
	ld hl, CurBattleMon
	ld a, [CurPartyMon]
	cp [hl]
	jr nz, .asm_3d360
	ld hl, BattleText_0x80c0d
	call StdBattleTextBox
	scf
	ret

.asm_3d360
	xor a
	ret
; 3d362

Function3d362: ; 3d362
.asm_3d362
	call Function3d33c
	ret nc
	call Function3d2e0
	ret c
	ld de, SFX_WRONG
	call StartSFX
	call WaitSFX
	jr .asm_3d362
; 3d375



Function3d375: ; 3d375
.asm_3d375
	call Function3d33c
	ret c
	call Function3d34f
	jr c, .asm_3d375
	xor a
	ret
; 3d380

Function3d380: ; 3d380
.asm_3d380
	call Function3d362
	call Function3d2e0
	ret c
	call Function3d34f
	jr c, .asm_3d380
	xor a
	ret
; 3d38e


LostBattle: ; 3d38e
	ld a, 1
	ld [BattleEnded], a

	ld a, [$cfc0]
	bit 0, a
	jr nz, .asm_3d3bd

	ld a, [BattleType]
	cp BATTLETYPE_CANLOSE
	jr nz, .asm_3d3e3

; Remove the enemy from the screen.
	hlcoord 0, 0
	ld bc, $0815
	call ClearBox
	call Function3ebd8

	ld c, 40
	call DelayFrames

	ld a, [$c2cc]
	bit 0, a
	jr nz, .asm_3d3bc
	call Function3718
.asm_3d3bc
	ret

.asm_3d3bd
; Remove the enemy from the screen.
	hlcoord 0, 0
	ld bc, $0815
	call ClearBox
	call Function3ebd8

	ld c, 40
	call DelayFrames

	call EmptyBattleTextBox
	ld c, 2
	ld a, $47
	ld hl, $4000
	rst FarCall
	call Functiona80
	call ClearTileMap
	call WhiteBGMap
	ret

.asm_3d3e3
	ld a, [InLinkBattle]
	and a
	jr nz, .LostLinkBattle

; Greyscale
	ld b, 0
	call GetSGBLayout
	call Function32f9
	jr .end

.LostLinkBattle
	call UpdateEnemyMonInParty
	call Function3cf35
	jr nz, .asm_3d40a
	ld hl, TiedAgainstText
	ld a, [$d0ee]
	and $c0
	add 2
	ld [$d0ee], a
	jr .asm_3d412

.asm_3d40a
	ld hl, LostAgainstText
	call Function3d2f1
	jr z, .asm_3d417

.asm_3d412
	call StdBattleTextBox

.end
	scf
	ret

.asm_3d417
; Remove the enemy from the screen.
	hlcoord 0, 0
	ld bc, $0815
	call ClearBox
	call Function3ebd8

	ld c, 40
	call DelayFrames

	ld c, $3
	ld a, $13
	ld hl, $6a0a
	rst FarCall
	scf
	ret
; 3d432


Function3d432: ; 3d432
	ld hl, $c510
	ld de, $c524
	jp Function3d444
; 3d43b

Function3d43b: ; 3d43b
	ld hl, $c569
	ld de, $c57d
	jp Function3d444
; 3d444

Function3d444: ; 3d444
	ld a, [$cfbe]
	push af
	set 6, a
	ld [$cfbe], a
	ld b, $7
.asm_3d44f
	push bc
	push de
	push hl
	ld b, $6
.asm_3d454
	push bc
	push hl
	push de
	ld bc, $0007
	call CopyBytes
	pop de
	pop hl
	ld bc, -20
	add hl, bc
	push hl
	ld h, d
	ld l, e
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	pop bc
	dec b
	jr nz, .asm_3d454
	ld bc, 20
	add hl, bc
	ld de, .Spaces
	call PlaceString
	ld c, 2
	call DelayFrames
	pop hl
	pop de
	pop bc
	dec b
	jr nz, .asm_3d44f
	pop af
	ld [$cfbe], a
	ret
; 3d488

.Spaces
	db "       @"
; 3d490


Function3d490: ; 3d490
	ld [hConnectionStripLength], a
	ld c, a
.asm_3d493
	push bc
	push hl
	ld b, $7
.asm_3d497
	push hl
	call Function3d4ae
	pop hl
	ld de, 20
	add hl, de
	dec b
	jr nz, .asm_3d497
	ld c, 2
	call DelayFrames
	pop hl
	pop bc
	dec c
	jr nz, .asm_3d493
	ret
; 3d4ae

Function3d4ae: ; 3d4ae
	ld a, [hConnectionStripLength]
	ld c, a
	cp $8
	jr nz, .asm_3d4bc
.asm_3d4b5
	ld a, [hli]
	ld [hld], a
	dec hl
	dec c
	jr nz, .asm_3d4b5
	ret

.asm_3d4bc
	ld a, [hld]
	ld [hli], a
	inc hl
	dec c
	jr nz, .asm_3d4bc
	ret
; 3d4c3


Function3d4c3: ; 3d4c3
	call Function3d557
	ld a, [$c718]
	dec a
	ld b, a
	call Function3d6ca
	call Function3d7a0
	call Function3d834
	call Function3d867
	call Function3d7c7
	call Function3dc18
	call Function3d57a
	ret
; 3d4e1


Function3d4e1: ; 3d4e1
	call Function3d714
	jr nc, .asm_3d517
	call Function3d557
	call Function3d533
	jr c, .asm_3d4f1
	call Function3d599

.asm_3d4f1
	call Function3d6ca
	call Function3d74b
	push af
	call Function3d7a0
	call Function3d7b8
	call Function3d7c7
	pop af
	ret c
	xor a
	ld [$c664], a
	ld [$c6fc], a
	ld [$d0ec], a
	inc a
	ld [$c711], a
	call Function309d
	jp Function3e3ad

.asm_3d517
	call Function3d557
	call Function3d533
	jr c, .asm_3d522
	call Function3d599

.asm_3d522
	call Function3d6ca
	ld a, $1
	ld [$c711], a
	call Function3d7a0
	call Function3d7b8
	jp Function3d7c7
; 3d533

Function3d533: ; 3d533
	ld a, [InLinkBattle]
	and a
	jr z, .asm_3d541
	ld a, [$d430]
	sub $4
	ld b, a
	jr .asm_3d555

.asm_3d541
	ld a, [$c718]
	and a
	jr z, .asm_3d54b
	dec a
	ld b, a
	jr .asm_3d555

.asm_3d54b
	ld a, [$d264]
	and a
	ld b, $0
	jr nz, .asm_3d555
	and a
	ret

.asm_3d555
	scf
	ret
; 3d557

Function3d557: ; 3d557
	xor a
	ld [LastEnemyCounterMove], a
	ld [LastPlayerCounterMove], a
	ld [LastEnemyMove], a
	ld [CurEnemyMove], a
	dec a
	ld [$c6e6], a
	xor a
	ld [$c730], a
	ld hl, $c4b2
	ld a, $8
	call Function3d490
	call EmptyBattleTextBox
	jp Function1d6e
; 3d57a

Function3d57a: ; 3d57a
	xor a
	ld [$c664], a
	ld [$c6fc], a
	ld a, [CurBattleMon]
	ld c, a
	ld hl, $c664
	ld b, $1
	push bc
	ld a, $3
	call Predef
	pop bc
	ld hl, $c6fc
	ld a, $3
	jp Predef
; 3d599

Function3d599: ; 3d599
	ld b, $ff
	ld a, $1
	ld [Buffer1], a
	ld [Buffer2], a
.asm_3d5a3
	ld hl, Buffer1
	sla [hl]
	inc hl
	sla [hl]
	inc b
	ld a, [OTPartyCount]
	cp b
	jp z, Function3d672
	ld a, [CurOTMon]
	cp b
	jr z, .asm_3d5d0
	ld hl, OTPartyMon1CurHP
	push bc
	ld a, b
	call GetPartyLocation
	ld a, [hli]
	ld c, a
	ld a, [hl]
	or c
	pop bc
	jr z, .asm_3d5d0
	call Function3d5d7
	call Function3d618
	jr .asm_3d5a3

.asm_3d5d0
	ld hl, Buffer2
	set 0, [hl]
	jr .asm_3d5a3
; 3d5d7

Function3d5d7: ; 3d5d7
	push bc
	ld hl, OTPartyMon1Move1
	ld a, b
	call GetPartyLocation
	pop bc
	ld e, $5
.asm_3d5e2
	dec e
	jr z, .asm_3d617
	ld a, [hli]
	and a
	jr z, .asm_3d617
	push hl
	push de
	push bc
	dec a
	ld hl, $5afb
	ld bc, $0007
	call AddNTimes
	ld de, EnemyMoveAnimation
	ld a, $10
	call FarCopyBytes
	call SetEnemyTurn
	callab Function0x347c8
	pop bc
	pop de
	pop hl
	ld a, [$d265]
	cp $b
	jr c, .asm_3d5e2
	ld hl, Buffer1
	set 0, [hl]
	ret

.asm_3d617
	ret
; 3d618

Function3d618: ; 3d618
	push bc
	ld hl, OTPartyCount
	ld a, b
	inc a
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	dec a
	ld hl, $542b
	ld bc, $0020
	call AddNTimes
	ld de, EnemyMonType1
	ld bc, $0002
	ld a, $14
	call FarCopyBytes
	ld a, [BattleMonType1]
	ld [PlayerMoveType], a
	call SetPlayerTurn
	callab Function0x347c8
	ld a, [$d265]
	cp $b
	jr nc, .asm_3d663
	ld a, [BattleMonType2]
	ld [PlayerMoveType], a
	callab Function0x347c8
	ld a, [$d265]
	cp $b
	jr nc, .asm_3d663
	pop bc
	ret

.asm_3d663
	pop bc
	ld hl, Buffer1
	bit 0, [hl]
	jr nz, .asm_3d66f
	inc hl
	set 0, [hl]
	ret

.asm_3d66f
	res 0, [hl]
	ret
; 3d672

Function3d672: ; 3d672
.asm_3d672
	ld hl, Buffer1
	sla [hl]
	inc hl
	sla [hl]
	jr nc, .asm_3d672
	ld a, [OTPartyCount]
	ld b, a
	ld c, [hl]
.asm_3d681
	sla c
	jr nc, .asm_3d68a
	dec b
	jr z, .asm_3d6a7
	jr .asm_3d681

.asm_3d68a
	ld a, [Buffer1]
	and a
	jr z, .asm_3d69a
	ld b, $ff
	ld c, a
.asm_3d693
	inc b
	sla c
	jr nc, .asm_3d693
	jr .asm_3d6c9

.asm_3d69a
	ld b, $ff
	ld a, [Buffer2]
	ld c, a
.asm_3d6a0
	inc b
	sla c
	jr c, .asm_3d6a0
	jr .asm_3d6c9

.asm_3d6a7
	ld a, [OTPartyCount]
	ld b, a
	call BattleRandom
	and $7
	cp b
	jr nc, .asm_3d6a7
	ld b, a
	ld a, [CurOTMon]
	cp b
	jr z, .asm_3d6a7
	ld hl, OTPartyMon1CurHP
	push bc
	ld a, b
	call GetPartyLocation
	pop bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	or c
	jr z, .asm_3d6a7

.asm_3d6c9
	ret
; 3d6ca

Function3d6ca: ; 3d6ca
	ld a, b
	ld [CurPartyMon], a
	ld hl, OTPartyMon1Level
	call GetPartyLocation
	ld a, [hl]
	ld [CurPartyLevel], a
	ld a, [CurPartyMon]
	inc a
	ld hl, OTPartyCount
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	ld [TempEnemyMonSpecies], a
	ld [CurPartySpecies], a
	call LoadEnemyMon
	ld a, [CurPartySpecies]
	cp $c9
	jr nz, .asm_3d708
	ld a, [$def4]
	and a
	jr nz, .asm_3d708
	ld hl, EnemyMonAtkDefDV
	ld a, $2d
	call Predef
	ld a, [UnownLetter]
	ld [$def4], a

.asm_3d708
	ld hl, EnemyMonHPHi
	ld a, [hli]
	ld [$c6ea], a
	ld a, [hl]
	ld [$c6eb], a
	ret
; 3d714

Function3d714: ; 3d714
	ld a, [$d264]
	dec a
	jp z, $5749
	ld a, [PartyCount]
	dec a
	jp z, $5749
	ld a, [InLinkBattle]
	and a
	jp nz, $5749
	ld a, [Options]
	bit 6, a
	jr nz, .asm_3d749
	ld a, [CurPartyMon]
	push af
	ld a, [CurBattleMon]
	ld [CurPartyMon], a
	callba Functione538
	pop bc
	ld a, b
	ld [CurPartyMon], a
	jr c, .asm_3d749
	scf
	ret

.asm_3d749
	and a
	ret
; 3d74b

Function3d74b: ; 3d74b
	ld a, [CurPartyMon]
	push af
	callab Function39939
	ld hl, BattleText_0x80aca
	call StdBattleTextBox
	ld bc, $0107
	call Function1dd2
	ld a, [$cfa9]
	dec a
	jr nz, .asm_3d79a
	call Function3d2f7
	call Function3d375
	jr c, .asm_3d791
	ld a, [CurBattleMon]
	ld [$c71a], a
	ld a, [CurPartyMon]
	ld [CurBattleMon], a
	call ClearPalettes
	call DelayFrame
	call Function3eda6
	pop af
	ld [CurPartyMon], a
	xor a
	ld [CurEnemyMove], a
	ld [CurPlayerMove], a
	and a
	ret

.asm_3d791
	call ClearPalettes
	call DelayFrame
	call Function3eda6

.asm_3d79a
	pop af
	ld [CurPartyMon], a
	scf
	ret
; 3d7a0

Function3d7a0: ; 3d7a0
	xor a
	ld [hBGMapMode], a
	call Function1c07
	call ClearSprites
	ld hl, $c4a1
	ld bc, $040a
	call ClearBox
	call WaitBGMap
	jp Function3ee27
; 3d7b8

Function3d7b8: ; 3d7b8
	callab Function39939
	ld hl, BattleText_0x80af8
	call StdBattleTextBox
	jp WaitBGMap
; 3d7c7

Function3d7c7: ; 3d7c7
	ld a, [TempEnemyMonSpecies]
	ld [CurPartySpecies], a
	ld [CurSpecies], a
	call GetBaseData
	ld a, $1
	ld [MonType], a
	ld a, $1f
	call Predef
	call Function3f47c
	xor a
	ld [$cfca], a
	ld [$c689], a
	call SetEnemyTurn
	ld de, $0101
	call Function3ee17
	call $5a79
	jr nc, .asm_3d800
	ld a, $1
	ld [$c689], a
	ld de, $0101
	call Function3ee17

.asm_3d800
	ld bc, TempMonSpecies
	callba Function4e53f
	jr c, .asm_3d82c
	ld a, $13
	ld hl, $6a44
	rst FarCall
	jr c, .asm_3d821
	ld hl, $c4ac
	ld d, $0
	ld e, $0
	ld a, $47
	call Predef
	jr .asm_3d82c

.asm_3d821
	ld a, $f
	ld [CryTracks], a
	ld a, [TempEnemyMonSpecies]
	call Function37b6

.asm_3d82c
	call Function3e036
	ld a, $1
	ld [hBGMapMode], a
	ret
; 3d834

Function3d834: ; 3d834
	xor a
	ld [LastEnemyCounterMove], a
	ld [LastPlayerCounterMove], a
	ld [LastEnemyMove], a
	ld hl, EnemySubStatus1
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [EnemyDisableCount], a
	ld [EnemyFuryCutterCount], a
	ld [$c681], a
	ld [$c72c], a
	ld [EnemyDisabledMove], a
	ld [$c6fa], a
	ld [$c730], a
	ld [$c731], a
	ld [EnemyTurnsTaken], a
	ld hl, PlayerSubStatus5
	res 7, [hl]
	ret
; 3d867

Function3d867: ; 3d867
	ld a, $7
	ld b, $8
	ld hl, EnemyAtkLevel
.asm_3d86e
	ld [hli], a
	dec b
	jr nz, .asm_3d86e
	ret
; 3d873

Function3d873: ; 3d873
	ld a, [PartyCount]
	ld e, a
	xor a
	ld hl, PartyMon1CurHP
	ld bc, $002f
.asm_3d87e
	or [hl]
	inc hl
	or [hl]
	add hl, bc
	dec e
	jr nz, .asm_3d87e
	ld d, a
	ret
; 3d887


Function3d887: ; 3d887
	ld a, [CurPartyMon]
	ld hl, PartyMon1CurHP
	call GetPartyLocation
	ld a, [hli]
	or [hl]
	ret nz
	ld a, [$d264]
	and a
	jr nz, .asm_3d8b1
	ld hl, PartySpecies
	ld a, [CurPartyMon]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	cp EGG
	ld hl, BattleText_0x80b26
	jr z, .asm_3d8ae
	ld hl, BattleText_0x80b0b

.asm_3d8ae
	call StdBattleTextBox

.asm_3d8b1
	xor a
	ret
; 3d8b3


Function3d8b3: ; 3d8b3
	ld a, [BattleType]
	cp $2
	jp z, .asm_3d9a2
	cp $6
	jp z, .asm_3d9a2
	cp $9
	jp z, .asm_3d98d
	cp $b
	jp z, .asm_3d98d
	cp $7
	jp z, .asm_3d98d
	cp $c
	jp z, .asm_3d98d

	ld a, [InLinkBattle]
	and a
	jp nz, .asm_3d9a2

	ld a, [IsInBattle]
	dec a
	jp nz, .asm_3d992

	ld a, [EnemySubStatus5]
	bit 7, a
	jp nz, .asm_3d98d

	ld a, [$c730]
	and a
	jp nz, .asm_3d98d

	push hl
	push de
	ld a, [BattleMonItem]
	ld [$d265], a
	ld b, a
	callab GetItem
	ld a, b
	cp $48
	pop de
	pop hl
	jr nz, .asm_3d916

	call SetPlayerTurn
	call GetItemName
	ld hl, BattleText_0x80b89
	call StdBattleTextBox
	jp .asm_3d9a2

.asm_3d916
	ld a, [$d267]
	inc a
	ld [$d267], a
	ld a, [hli]
	ld [$ffb5], a
	ld a, [hl]
	ld [$ffb6], a
	ld a, [de]
	inc de
	ld [$ffb1], a
	ld a, [de]
	ld [$ffb2], a
	call Function30b4
	ld de, $ffb5
	ld hl, $ffb1
	ld c, $2
	call StringCmp
	jr nc, .asm_3d9a2
	xor a
	ld [hMultiplicand], a
	ld a, $20
	ld [hMultiplier], a
	call Multiply
	ld a, [$ffb5]
	ld [hProduct], a
	ld a, [$ffb6]
	ld [hMultiplicand], a
	ld a, [$ffb1]
	ld b, a
	ld a, [$ffb2]
	srl b
	rr a
	srl b
	rr a
	and a
	jr z, .asm_3d9a2
	ld [hMultiplier], a
	ld b, $2
	call Divide
	ld a, [$ffb5]
	and a
	jr nz, .asm_3d9a2
	ld a, [$d267]
	ld c, a
.asm_3d96c
	dec c
	jr z, .asm_3d97a
	ld b, $1e
	ld a, [$ffb6]
	add b
	ld [$ffb6], a
	jr c, .asm_3d9a2
	jr .asm_3d96c

.asm_3d97a
	call BattleRandom
	ld b, a
	ld a, [$ffb6]
	cp b
	jr nc, .asm_3d9a2
	ld a, $1
	ld [$d0ec], a
	ld hl, BattleText_0x80b3b
	jr .asm_3d995

.asm_3d98d
	ld hl, BattleText_0x80ba0
	jr .asm_3d995

.asm_3d992
	ld hl, BattleText_0x80b49

.asm_3d995
	call StdBattleTextBox
	ld a, $1
	ld [$d266], a
	call Function309d
	and a
	ret

.asm_3d9a2
	ld a, [InLinkBattle]
	and a
	ld a, $2
	jr z, .asm_3d9cf
	call Function309d
	xor a
	ld [$d0ec], a
	ld a, $f
	ld [CurMoveNum], a
	xor a
	ld [CurPlayerMove], a
	call Function3e8e4
	call Function30b4
	call Function3d2e0
	jr c, .asm_3d9f5

; Got away safely
	ld a, [$d430]
	cp $f
	ld a, $2
	jr z, .asm_3d9cf
	dec a
.asm_3d9cf
	ld b, a
	ld a, [$d0ee]
	and $c0
	add b
	ld [$d0ee], a
	call Function3ceec
	push de
	ld de, SFX_RUN
	call WaitPlaySFX
	pop de
	call WaitSFX
	ld hl, BattleText_0x80b77
	call StdBattleTextBox
	call WaitSFX
	call Function309d
	scf
	ret

.asm_3d9f5
	call Function3ceec
	ld hl, $cd2a
	bit 4, [hl]
	jr nz, .asm_3da05
	ld hl, BattleText_0x81863
	call StdBattleTextBox

.asm_3da05
	call WaitSFX
	call Function309d
	scf
	ret
; 3da0d


Function3da0d: ; 3da0d
	ld a, $0
	call GetPartyParamLocation
	ld de, BattleMonSpecies
	ld bc, $0006
	call CopyBytes
	ld bc, $000f
	add hl, bc
	ld de, BattleMonAtkDefDV
	ld bc, $0007
	call CopyBytes
	inc hl
	inc hl
	inc hl
	ld de, BattleMonLevel
	ld bc, $0011
	call CopyBytes
	ld a, [BattleMonSpecies]
	ld [TempBattleMonSpecies], a
	ld [CurPartySpecies], a
	ld [CurSpecies], a
	call GetBaseData
	ld a, [BaseType1]
	ld [BattleMonType1], a
	ld a, [BaseType2]
	ld [BattleMonType2], a
	ld hl, PartyMon1Nickname
	ld a, [CurBattleMon]
	call SkipNames
	ld de, BattleMonNick
	ld bc, $000b
	call CopyBytes
	ld hl, BattleMonAtk
	ld de, PlayerStats
	ld bc, $000a
	call CopyBytes
	call Function3ec2c
	call BadgeStatBoosts
	ret
; 3da74

Function3da74: ; 3da74
	call Function3da85
	jr .asm_3da7c

	call Function3da97

.asm_3da7c
	ld b, h
	ld c, l
	callab CheckShininess
	ret
; 3da85

Function3da85: ; 3da85
	ld hl, BattleMonAtkDefDV
	ld a, [PlayerSubStatus5]
	bit 3, a
	ret z
	ld hl, PartyMon1DVs
	ld a, [CurBattleMon]
	jp GetPartyLocation
; 3da97

Function3da97: ; 3da97
	ld hl, EnemyMonAtkDefDV
	ld a, [EnemySubStatus5]
	bit 3, a
	ret z
	ld hl, $c6f2
	ld a, [IsInBattle]
	dec a
	ret z
	ld hl, OTPartyMon1AtkDefDV
	ld a, [CurOTMon]
	jp GetPartyLocation
; 3dab1

Function3dab1: ; 3dab1
	ld a, $7
	ld b, $8
	ld hl, PlayerAtkLevel
.asm_3dab8
	ld [hli], a
	dec b
	jr nz, .asm_3dab8
	ret
; 3dabd


Function3dabd: ; 3dabd
	ld a, [CurPartyMon]
	ld hl, OTPartyMon1Species
	call GetPartyLocation
	ld de, EnemyMonSpecies
	ld bc, $0006
	call CopyBytes
	ld bc, $000f
	add hl, bc
	ld de, EnemyMonAtkDefDV
	ld bc, $0007
	call CopyBytes
	inc hl
	inc hl
	inc hl
	ld de, EnemyMonLevel
	ld bc, $0011
	call CopyBytes
	ld a, [EnemyMonSpecies]
	ld [CurSpecies], a
	call GetBaseData
	ld hl, OTPartyMon1Nickname
	ld a, [CurPartyMon]
	call SkipNames
	ld de, EnemyMonNick
	ld bc, $000b
	call CopyBytes
	ld hl, EnemyMonAtk
	ld de, EnemyStats
	ld bc, $000a
	call CopyBytes
	call Function3ec30
	ld hl, BaseType1
	ld de, EnemyMonType1
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld hl, BaseHP
	ld de, EnemyMonBaseStats
	ld b, $5
.asm_3db25
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_3db25
	ld a, [CurPartyMon]
	ld [CurOTMon], a
	ret
; 3db32


Function3db32: ; 3db32
	call ClearSprites
	ld a, [CurBattleMon]
	ld [$c71a], a
	ld a, [CurPartyMon]
	ld [CurBattleMon], a
	call $5581
	call Function3da0d
	call Function3dab1
	call Function3dbde
	call Function3dc18
	call Function3db5f
	call EmptyBattleTextBox
	call Function309d
	ld hl, EnemyMonHPHi
	ld a, [hli]
	or [hl]
	ret
; 3db5f


Function3db5f: ; 3db5f
	ld hl, BattleMonAtkDefDV
	ld a, $2d
	call Predef
	ld hl, $c505
	ld b, $7
	ld c, $8
	call ClearBox
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	call Function3f43d
	xor a
	ld [$ffad], a
	ld [$d0d2], a
	ld [CurMoveNum], a
	ld [TypeModifier], a
	ld [PlayerMoveAnimation], a
	ld [LastEnemyCounterMove], a
	ld [LastPlayerCounterMove], a
	ld [LastPlayerMove], a
	call Function3e4a8
	call Function3ee27
	xor a
	ld [$c731], a
	call SetPlayerTurn
	xor a
	ld [$cfca], a
	ld [$c689], a
	ld de, $0101
	call Function3ee17
	call Function3da74
	jr nc, .asm_3dbbc
	ld a, $1
	ld [$c689], a
	ld de, $0101
	call Function3ee17

.asm_3dbbc
	ld a, $0
	call GetPartyParamLocation
	ld b, h
	ld c, l
	callba Function4e53f
	jr c, .asm_3dbd6
	ld a, $f0
	ld [CryTracks], a
	ld a, [CurPartySpecies]
	call Function37b6

.asm_3dbd6
	call Function3df48
	ld a, $1
	ld [hBGMapMode], a
	ret
; 3dbde

Function3dbde: ; 3dbde
	xor a
	ld [LastEnemyCounterMove], a
	ld [LastPlayerCounterMove], a
	ld [LastPlayerMove], a
	ld hl, PlayerSubStatus1
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, PlayerUsedMoves
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [PlayerDisableCount], a
	ld [PlayerFuryCutterCount], a
	ld [$c679], a
	ld [$c72b], a
	ld [DisabledMove], a
	ld [$c6fe], a
	ld [$c731], a
	ld [$c730], a
	ld [PlayerTurnsTaken], a
	ld hl, EnemySubStatus5
	res 7, [hl]
	ret
; 3dc18

Function3dc18: ; 3dc18
	ld hl, PlayerSubStatus1
	res 7, [hl]
	ld hl, EnemySubStatus1
	res 7, [hl]
	ret
; 3dc23

Function3dc23: ; 3dc23
	ld hl, PlayerScreens
	ld de, BattleMonType1
	ld bc, Function3df48
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3dc3a
	ld hl, EnemyScreens
	ld de, EnemyMonType1
	ld bc, Function3e036

.asm_3dc3a
	bit 0, [hl]
	ret z
	ld a, [de]
	cp $2
	ret z
	inc de
	ld a, [de]
	cp $2
	ret z
	push bc
	ld hl, BattleText_0x80bae
	call StdBattleTextBox
	call GetEighthMaxHP
	call Function3cc39
	pop hl
	call Function3dc5a
	jp WaitBGMap
; 3dc5a

Function3dc5a: ; 3dc5a
	jp [hl]
; 3dc5b

Function3dc5b: ; 3dc5b
	ld a, $10
	call CleanGetBattleVarPair
	ld b, a
	call Function3c5ec
	ld a, b
	cp $80
	jr nz, .asm_3dce4
	ld a, [CurBattleMon]
	push af
	ld hl, Function3c000
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3dc7e
	ld hl, $400a
	ld a, [$c71a]
	ld [CurBattleMon], a

.asm_3dc7e
	ld a, $d
	rst FarCall
	ld a, $10
	call GetBattleVarPair
	ld a, $ff
	ld [hl], a
	pop af
	ld [CurBattleMon], a
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3dcc0
	ld a, [$c71a]
	call Function399f
	ld hl, BattleMonHP
	ld a, [hli]
	or [hl]
	jr nz, .asm_3dce4
	ld a, $f0
	ld [CryTracks], a
	ld a, [BattleMonSpecies]
	call Function37b6
	ld a, [$c71a]
	ld c, a
	ld hl, $c664
	ld b, $0
	ld a, $3
	call Predef
	call Function3d43b
	ld hl, BattleText_0x80a75
	jr .asm_3dcdf

.asm_3dcc0
	ld hl, EnemyMonHPHi
	ld a, [hli]
	or [hl]
	jr nz, .asm_3dce4
	ld de, SFX_KINESIS
	call StartSFX
	call WaitSFX
	ld de, SFX_UNKNOWN_2A
	call StartSFX
	call WaitSFX
	call Function3d432
	ld hl, BattleText_0x809a8

.asm_3dcdf
	call StdBattleTextBox
	scf
	ret

.asm_3dce4
	and a
	ret
; 3dce6

Function3dce6: ; 3dce6
	ld a, [hBattleTurn]
	push af
	xor a
	ld [hBattleTurn], a
	ld [$cfca], a
	ld de, $0102
	call Function3ee17
	pop af
	ld [hBattleTurn], a
	ret
; 3dcf9

Function3dcf9: ; 3dcf9
	ld a, [$ffcb]
	cp $1
	jr z, .asm_3dd17
	call SetPlayerTurn
	call Function3dd2f
	call Function3dde9
	call Function3de51
	call SetEnemyTurn
	call Function3dd2f
	call Function3dde9
	jp Function3de51

.asm_3dd17
	call SetEnemyTurn
	call Function3dd2f
	call Function3dde9
	call Function3de51
	call SetPlayerTurn
	call Function3dd2f
	call Function3dde9
	jp Function3de51
; 3dd2f

Function3dd2f: ; 3dd2f
	callab GetOpponentItem
	ld a, b
	cp $1
	ret nz
	ld de, EnemyMonHPLo
	ld hl, EnemyMonMaxHPHi
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3dd4a
	ld de, $c63d
	ld hl, BattleMonMaxHP

.asm_3dd4a
	push bc
	ld a, [de]
	ld [$d1ec], a
	add a
	ld c, a
	dec de
	ld a, [de]
	inc de
	ld [$d1ed], a
	adc a
	ld b, a
	ld a, b
	cp [hl]
	ld a, c
	pop bc
	jr z, .asm_3dd62
	jr c, .asm_3dd66
	ret

.asm_3dd62
	inc hl
	cp [hl]
	dec hl
	ret nc

.asm_3dd66
	call Function3ddc8
	ld a, [hli]
	ld [Buffer2], a
	ld a, [hl]
	ld [Buffer1], a
	ld a, [de]
	add c
	ld [$d1ee], a
	ld c, a
	dec de
	ld a, [de]
	adc $0
	ld [$d1ef], a
	ld b, a
	ld a, [hld]
	cp c
	ld a, [hl]
	sbc b
	jr nc, .asm_3dd8d
	ld a, [hli]
	ld [$d1ef], a
	ld a, [hl]
	ld [$d1ee], a

.asm_3dd8d
	ld a, [$d1ef]
	ld [de], a
	inc de
	ld a, [$d1ee]
	ld [de], a
	ld a, [hBattleTurn]
	ld [$d10a], a
	and a
	ld hl, $c4ca
	jr z, .asm_3dda4
	ld hl, $c55e

.asm_3dda4
	ld [$d10a], a
	ld a, $b
	call Predef
	call RefreshBattleHuds
	callab GetOpponentItem
	ld a, [hl]
	ld [$d265], a
	call GetItemName
	ld hl, $7192
	ld a, $9
	rst FarCall
	ld hl, RecoveredUsingText
	jp StdBattleTextBox
; 3ddc8


Function3ddc8: ; 3ddc8
	push hl
	push de
	push bc
	call EmptyBattleTextBox
	ld a, $69
	ld [FXAnimIDLo], a
	call Function3c8e4
	xor a
	ld [$cfca], a
	ld [FXAnimIDHi], a
	ld a, $37
	call Predef
	call Function3c8e4
	pop bc
	pop de
	pop hl
	ret
; 3dde9

Function3dde9: ; 3dde9
	callab GetOpponentItem
	ld hl, .Statuses
.asm_3ddf2
	ld a, [hli]
	cp $ff
	ret z
	inc hl
	cp b
	jr nz, .asm_3ddf2
	dec hl
	ld b, [hl]
	ld a, $b
	call GetBattleVarPair
	and b
	ret z
	xor a
	ld [hl], a
	push bc
	call UpdateOpponentInParty
	pop bc
	ld a, $9
	call GetBattleVarPair
	and [hl]
	res 0, [hl]
	ld a, $5
	call GetBattleVarPair
	and [hl]
	res 0, [hl]
	ld a, b
	cp $7f
	jr nz, .asm_3de26
	ld a, $7
	call GetBattleVarPair
	res 7, [hl]

.asm_3de26
	ld hl, $65fd
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3de31
	ld hl, $65d7

.asm_3de31
	call Function3c8e4
	ld a, $d
	rst FarCall
	call Function3c8e4
	call Function3ddc8
	call $5dac
	ld a, $1
	and a
	ret
; 3de44

.Statuses ; 3de44
	db HELD_HEAL_POISON, 1 << PSN
	db HELD_HEAL_FREEZE, 1 << FRZ
	db HELD_HEAL_BURN, 1 << BRN
	db HELD_HEAL_SLEEP, SLP
	db HELD_HEAL_PARALYZE, 1 << PAR
	db HELD_HEAL_STATUS, 1 << PSN | 1 << FRZ | 1 << BRN | SLP | 1 << PAR
	db $ff
; 3de51


Function3de51: ; 3de51
	ld a, $7
	call CleanGetBattleVarPair
	bit 7, a
	ret z
	callab GetOpponentItem
	ld a, b
	cp $10
	jr z, .asm_3de67
	cp $f
	ret nz

.asm_3de67
	ld a, [hl]
	ld [$d265], a
	ld a, $7
	call GetBattleVarPair
	res 7, [hl]
	call GetItemName
	call Function3ddc8
	ld hl, BattleText_0x80dab
	call StdBattleTextBox
	ld a, [hBattleTurn]
	and a
	jr nz, .asm_3de90
	call Function3df1f
	xor a
	ld [bc], a
	ld a, [IsInBattle]
	dec a
	ret z
	ld [hl], $0
	ret

.asm_3de90
	call Function3df12
	xor a
	ld [bc], a
	ld [hl], a
	ret
; 3de97

Function3de97: ; 3de97
	ld a, [$ffcb]
	cp $1
	jr z, .asm_3dea3
	call Function3dea9
	jp Function3deb1

.asm_3dea3
	call Function3deb1
	jp Function3dea9
; 3dea9

Function3dea9: ; 3dea9
	call Function3df12
	ld a, $0
	jp $5eb6
; 3deb1

Function3deb1: ; 3deb1
	call Function3df1f
	ld a, $1
	ld [hBattleTurn], a
	ld d, h
	ld e, l
	push de
	push bc
	ld a, [bc]
	ld b, a
	callab GetItem
	ld hl, .data_3defc
.asm_3dec7
	ld a, [hli]
	cp $ff
	jr z, .asm_3def9
	inc hl
	inc hl
	cp b
	jr nz, .asm_3dec7
	pop bc
	ld a, [bc]
	ld [$d265], a
	push bc
	dec hl
	dec hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $d
	rst FarCall
	pop bc
	pop de
	ld a, [FailedMessage]
	and a
	ret nz
	xor a
	ld [bc], a
	ld [de], a
	call GetItemName
	ld hl, BattleText_0x80bde
	call StdBattleTextBox
	callab BattleCommand8c
	ret

.asm_3def9
	pop bc
	pop de
	ret
; 3defc

.data_3defc
	dbw $1f, $61ac
	dbw $20, $61b0
	dbw $21, $61b4
	dbw $22, $61b8
	dbw $23, $61bc
	dbw $24, $61c0
	dbw $25, $61c4
	db $ff
; 3df12


Function3df12: ; 3df12
	ld hl, PartyMon1Item
	ld a, [CurBattleMon]
	call GetPartyLocation
	ld bc, BattleMonItem
	ret
; 3df1f

Function3df1f: ; 3df1f
	ld hl, OTPartyMon1Item
	ld a, [CurOTMon]
	call GetPartyLocation
	ld bc, EnemyMonItem
	ret
; 3df2c

Function3df2c: ; 3df2c
	push hl
	push de
	push bc
	call DrawPlayerHUD
	ld hl, PlayerHPPal
	call SetHPPal
	call CheckDanger
	call Function3e043
	ld hl, EnemyHPPal
	call SetHPPal
	pop bc
	pop de
	pop hl
	ret
; 3df48



Function3df48: ; 3df48
	push hl
	push de
	push bc
	call DrawPlayerHUD
	call UpdatePlayerHPPal
	call CheckDanger
	pop bc
	pop de
	pop hl
	ret
; 3df58

DrawPlayerHUD: ; 3df58
	xor a
	ld [hBGMapMode], a

; Clear the area
	hlcoord 9, 7
	ld bc, $050b
	call ClearBox

	callba DrawPlayerExpBar

	hlcoord 18, 9
	ld [hl], $73 ; vertical bar
	call PrintPlayerHUD

; HP bar
	hlcoord 10, 9
	ld b, OTPARTYMON
	xor a
	ld [MonType], a
	ld a, PREDEF_DRAW_PLAYER_HP
	call Predef

; Exp bar
	push de
	ld a, [CurBattleMon]
	ld hl, PartyMon1Exp + 2
	call GetPartyLocation
	ld d, h
	ld e, l

	hlcoord 10, 11
	ld a, [TempMonLevel]
	ld b, a
	call FillInExpBar
	pop de
	ret
; 3df98

UpdatePlayerHPPal: ; 3df98
	ld hl, PlayerHPPal
	jp Function3e12e
; 3df9e

CheckDanger: ; 3df9e
	ld hl, BattleMonHP
	ld a, [hli]
	or [hl]
	jr z, .asm_3dfb2
	ld a, [$c6fd]
	and a
	jr nz, .asm_3dfbe
	ld a, [PlayerHPPal]
	cp $2
	jr z, .asm_3dfb9

.asm_3dfb2
	ld hl, Danger
	res 7, [hl]
	jr .asm_3dfbe

.asm_3dfb9
	ld hl, Danger
	set 7, [hl]

.asm_3dfbe
	ret
; 3dfbf

PrintPlayerHUD: ; 3dfbf
	ld de, BattleMonNick
	hlcoord 10, 7
	call Function3e138
	call PlaceString

	push bc

	ld a, [CurBattleMon]
	ld hl, PartyMon1DVs
	call GetPartyLocation
	ld de, TempMonDVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld hl, BattleMonLevel
	ld de, TempMonLevel
	ld bc, $0011
	call CopyBytes
	ld a, [CurBattleMon]
	ld hl, PartyMon1Species
	call GetPartyLocation
	ld a, [hl]
	ld [CurPartySpecies], a
	ld [CurSpecies], a
	call GetBaseData

	pop hl
	dec hl

	ld a, $3
	ld [MonType], a
	callab GetGender
	ld a, $7f
	jr c, .asm_3e013
	ld a, $ef
	jr nz, .asm_3e013
	ld a, $f5

.asm_3e013
	ld hl, $c551
	ld [hl], a
	ld hl, $c54e
	push af
	push hl
	ld de, BattleMonStatus
	ld a, $21
	call Predef
	pop hl
	pop bc
	ret nz
	ld a, b
	cp $7f
	jr nz, .asm_3e02d
	dec hl

.asm_3e02d
	ld a, [BattleMonLevel]
	ld [TempMonLevel], a
	jp PrintLevel
; 3e036

Function3e036: ; 3e036
	push hl
	push de
	push bc
	call Function3e043
	call Function3e127
	pop bc
	pop de
	pop hl
	ret
; 3e043

Function3e043: ; 3e043
	xor a
	ld [hBGMapMode], a
	ld hl, $c4a1
	ld bc, $040b
	call ClearBox
	ld a, $b
	ld hl, $40c5
	rst FarCall
	ld a, [TempEnemyMonSpecies]
	ld [CurSpecies], a
	ld [CurPartySpecies], a
	call GetBaseData
	ld de, EnemyMonNick
	ld hl, $c4a1
	call Function3e138
	call PlaceString
	ld h, b
	ld l, c
	dec hl
	ld hl, EnemyMonAtkDefDV
	ld de, TempMonDVs
	ld a, [EnemySubStatus5]
	bit 3, a
	jr z, .asm_3e080
	ld hl, $c6f2

.asm_3e080
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld a, $3
	ld [MonType], a
	callab GetGender
	ld a, $7f
	jr c, .asm_3e09a
	ld a, $ef
	jr nz, .asm_3e09a
	ld a, $f5

.asm_3e09a
	ld hl, $c4bd
	ld [hl], a
	ld hl, $c4ba
	push af
	push hl
	ld de, EnemyMonStatus
	ld a, $21
	call Predef
	pop hl
	pop bc
	jr nz, .asm_3e0be
	ld a, b
	cp $7f
	jr nz, .asm_3e0b5
	dec hl

.asm_3e0b5
	ld a, [EnemyMonLevel]
	ld [TempMonLevel], a
	call PrintLevel

.asm_3e0be
	ld hl, EnemyMonHPHi
	ld a, [hli]
	ld [$ffb5], a
	ld a, [hld]
	ld [$ffb6], a
	or [hl]
	jr nz, .asm_3e0d1
	ld c, a
	ld e, a
	ld d, $6
	jp $611a

.asm_3e0d1
	xor a
	ld [hMultiplicand], a
	ld a, $30
	ld [hMultiplier], a
	call Multiply
	ld hl, EnemyMonMaxHPHi
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld [hMultiplier], a
	ld a, b
	and a
	jr z, .asm_3e105
	ld a, [hMultiplier]
	srl b
	rr a
	srl b
	rr a
	ld [hMultiplier], a
	ld a, [$ffb5]
	ld b, a
	srl b
	ld a, [$ffb6]
	rr a
	srl b
	rr a
	ld [$ffb6], a
	ld a, b
	ld [$ffb5], a

.asm_3e105
	ld a, [$ffb5]
	ld [hProduct], a
	ld a, [$ffb6]
	ld [hMultiplicand], a
	ld a, $2
	ld b, a
	call Divide
	ld a, [$ffb6]
	ld e, a
	ld a, $6
	ld d, a
	ld c, a
	xor a
	ld [$d10a], a
	ld hl, $c4ca
	ld b, $0
	call DrawHPBar
	ret
; 3e127

Function3e127: ; 3e127
	ld hl, EnemyHPPal
	call Function3e12e
	ret
; 3e12e

Function3e12e: ; 3e12e
	ld b, [hl]
	call SetHPPal
	ld a, [hl]
	cp b
	ret z
	jp Function3ee27
; 3e138

Function3e138: ; 3e138
	ret
; 3e139

Function3e139: ; 3e139
	xor a
	ld [hBGMapMode], a
	call Function30bf
	ld a, [BattleType]
	cp $2
	jr z, .asm_3e156
	cp $3
	jr z, .asm_3e156
	call EmptyBattleTextBox
	call UpdateBattleHuds
	call EmptyBattleTextBox
	call Function309d

.asm_3e156
	ld a, [BattleType]
	cp $6
	jr nz, .asm_3e165
	ld a, $9
	ld hl, $4f13
	rst FarCall
	jr .asm_3e175

.asm_3e165
	ld a, [InputType]
	or a
	jr z, .asm_3e171
	callba Function1de294
.asm_3e171
	call Function3e19b
	ret c

.asm_3e175
	ld a, $1
	ld [hBGMapMode], a
	ld a, [$d0d2]
	cp $1
	jp z, Function3e192
	cp $3
	jp z, Function3e1c7
	cp $2
	jp z, Function3e28d
	cp $4
	jp z, Function3e489
	jr .asm_3e156
; 3e192

Function3e192: ; 3e192
	xor a
	ld [$d267], a
	call Function30b4
	and a
	ret
; 3e19b

Function3e19b: ; 3e19b
	call Function3d2f1
	jr z, .asm_3e1a8
	callba Function24ef2
	and a
	ret

.asm_3e1a8
	ld a, $40
	ld hl, $4b12
	rst FarCall
	ld a, [$cd2b]
	and a
	ret z
	ld hl, $cd2a
	bit 4, [hl]
	jr nz, .asm_3e1c5
	ld hl, $5863
	call StdBattleTextBox
	ld c, $3c
	call DelayFrames

.asm_3e1c5
	scf
	ret
; 3e1c7

Function3e1c7: ; 3e1c7
	ld a, [InLinkBattle]
	and a
	jp nz, Function3e22b
	ld a, [$cfc0]
	and a
	jp nz, Function3e22b
	call Function1d6e
	ld a, [BattleType]
	cp $3
	jr z, .asm_3e1f1
	cp $6
	jr z, .asm_3e201
	ld a, $4
	ld hl, $4493
	rst FarCall
	ld a, [$d0ec]
	and a
	jr z, .asm_3e20d
	jr .asm_3e209

.asm_3e1f1
	ld a, $4
	ld hl, $47bb
	rst FarCall
	ld a, $5
	ld [CurItem], a
	call DoItemEffect
	jr .asm_3e209

.asm_3e201
	ld a, $b1
	ld [CurItem], a
	call DoItemEffect

.asm_3e209
	call Function3e234
	ret

.asm_3e20d
	call ClearPalettes
	call DelayFrame
	call Function3ed9f
	call Function3f43d
	call Function3f47c
	call Function1c07
	call WaitBGMap
	call Function3ee27
	call Function309d
	jp Function3e139
; 3e22b

Function3e22b: ; 3e22b
	ld hl, BattleText_0x80bf3
	call StdBattleTextBox
	jp Function3e139
; 3e234

Function3e234: ; 3e234
	ld a, [$c64e]
	and a
	jr nz, .asm_3e279
	callab CheckItemPocket
	ld a, [$d142]
	cp $3
	jr z, .asm_3e24a
	call WhiteBGMap

.asm_3e24a
	xor a
	ld [hBGMapMode], a
	call Function3ed9f
	call ClearSprites
	ld a, [BattleType]
	cp $3
	jr z, .asm_3e25d
	call Function3f43d

.asm_3e25d
	call Function3f47c
	ld a, $1
	ld [$cfa9], a
	call Function1c07
	call Function3df2c
	call WaitBGMap
	call Function309d
	call Function1fbf
	call Function3ee27
	and a
	ret

.asm_3e279
	xor a
	ld [$c64e], a
	ld a, [$d0ee]
	and $c0
	ld [$d0ee], a
	call Function1fbf
	call Function32f9
	scf
	ret
; 3e28d

Function3e28d: ; 3e28d
	call Function1d6e
	call Function1c07
	call Function1d6e
	call WhiteBGMap
.asm_3e299
	call $52fa
	xor a
	ld [PartyMenuActionText], a
	call Function3d313
	call Function3d329
	jr c, .asm_3e2da
.asm_3e2a8
	ld a, $23
	ld hl, $6a4a
	rst FarCall
	call Function3e2f5
	jr c, .asm_3e2c8
	call Function1bee
	ld a, [$cfa9]
	cp $1
	jp z, Function3e358
	cp $2
	jr z, .asm_3e2cf
	cp $3
	jr z, .asm_3e2da
	jr .asm_3e2a8

.asm_3e2c8
	call Function3d2e0
	jr c, .asm_3e2da
	jr .asm_3e299

.asm_3e2cf
	call Function3e308
	call Function3d2e0
	jr c, .asm_3e2da
	jp $6290

.asm_3e2da
	call ClearSprites
	call ClearPalettes
	call DelayFrame
	call Function3eda6
	call Function1c17
	call Function309d
	call ClearSGB
	call Function32f9
	jp Function3e139
; 3e2f5

Function3e2f5: ; 3e2f5
	call Function3d2f1
	jr z, .asm_3e301
	ld a, $9
	ld hl, $4e99
	rst FarCall
	ret

.asm_3e301
	ld a, $40
	ld hl, $4d22
	rst FarCall
	ret
; 3e308

Function3e308: ; 3e308
	call DisableLCD
	ld hl, $9310
	ld de, VTiles0
	ld bc, $0110
	call CopyBytes
	ld hl, VTiles2
	ld de, $8110
	ld bc, $0310
	call CopyBytes
	call EnableLCD
	call ClearSprites
	call LowVolume
	xor a
	ld [MonType], a
	ld a, $13
	ld hl, $5c7b
	rst FarCall
	call MaxVolume
	call DisableLCD
	ld hl, VTiles0
	ld de, $9310
	ld bc, $0110
	call CopyBytes
	ld hl, $8110
	ld de, VTiles2
	ld bc, $0310
	call CopyBytes
	call EnableLCD
	ret
; 3e358


Function3e358: ; 3e358
	ld a, [CurBattleMon]
	ld d, a
	ld a, [CurPartyMon]
	cp d
	jr nz, .asm_3e36b
	ld hl, BattleText_0x80c0d
	call StdBattleTextBox
	jp $6299

.asm_3e36b
	ld a, [$c730]
	and a
	jr nz, .asm_3e378
	ld a, [EnemySubStatus5]
	bit 7, a
	jr z, .asm_3e381

.asm_3e378
	ld hl, BattleText_0x80c22
	call StdBattleTextBox
	jp $6299

.asm_3e381
	call Function3d887
	jp z, $6299
	ld a, [CurBattleMon]
	ld [$c71a], a
	ld a, $2
	ld [$d0ec], a
	call ClearPalettes
	call DelayFrame
	call ClearSprites
	call Function3eda6
	call Function1c17
	call ClearSGB
	call Function32f9
	ld a, [CurPartyMon]
	ld [CurBattleMon], a
	; fallthrough
; 3e3ad

Function3e3ad: ; 3e3ad
	ld a, $1
	ld [$c710], a
	ld a, [InLinkBattle]
	and a
	jr z, .asm_3e3c1
	call Function1d6e
	call Function3e8e4
	call Function1c17

.asm_3e3c1
	call Function3e7c1
	ld a, [InLinkBattle]
	and a
	jr nz, .asm_3e3cf

.asm_3e3ca
	call Function3e40b
	and a
	ret

.asm_3e3cf
	ld a, [$d430]
	cp $e
	jp z, .asm_3e3ca
	cp $d
	jp z, .asm_3e3ca
	cp $4
	jp c, .asm_3e3ca
	cp $f
	jr nz, .asm_3e3e9
	call Function3c0e5
	ret

.asm_3e3e9
	ld a, [$ffcb]
	cp $1
	jr z, .asm_3e3f7
	call Function3e40b
	call Function3e3ff
	and a
	ret

.asm_3e3f7
	call Function3e3ff
	call Function3e40b
	and a
	ret
; 3e3ff

Function3e3ff: ; 3e3ff
	ld hl, $446c
	ld a, $e
	rst FarCall
	call SetEnemyTurn
	jp Function3dc23
; 3e40b

Function3e40b: ; 3e40b
	call Function3f2f4
	ld c, $32
	call DelayFrames
	ld hl, PlayerSubStatus4
	res 6, [hl]
	call SetEnemyTurn
	call Function3dc5b
	jr c, .asm_3e423
	call Function3dce6

.asm_3e423
	ld hl, $c535
	ld bc, $050b
	call ClearBox
	ld a, [CurBattleMon]
	ld [CurPartyMon], a
	call $5581
	call Function3da0d
	call Function3dab1
	call Function3f26d
	call Function3dbde
	call Function3dc18
	call Function3db5f
	call EmptyBattleTextBox
	call Function309d
	call SetPlayerTurn
	call Function3dc23
	ld a, $2
	ld [$cfa9], a
	ret
; 3e459

Function3e459: ; 3e459
	ld c, $32
	call DelayFrames
	ld hl, $c535
	ld bc, $050b
	call ClearBox
	ld a, [CurPartyMon]
	ld [CurBattleMon], a
	call $5581
	call Function3da0d
	xor a
	ld [$d265], a
	call Function3ecab
	call Function3db5f
	call EmptyBattleTextBox
	call Function309d
	call SetPlayerTurn
	jp Function3dc23
; 3e489



Function3e489: ; 3e489
	call Function30b4
	ld a, $3
	ld [$cfa9], a
	ld hl, BattleMonSpd
	ld de, EnemyMonSpd
	call Function3d8b3
	ld a, $0
	ld [$d266], a
	ret c
	ld a, [$d0ec]
	and a
	ret nz
	jp Function3e139
; 3e4a8



Function3e4a8: ; 3e4a8
	ld a, [BattleMonItem]
	ld b, a
	callab GetItem
	ld a, b
	cp $4c
	ret nz
	ld a, $1
	ld [$c73d], a
	ret
; 3e4bc

Function3e4bc: ; 3e4bc
	call Function3d2f1
	jr nz, .asm_3e4c8
	ld a, $40
	ld hl, $4b9f
	rst FarCall
	ret

.asm_3e4c8
	ld hl, EnemyMonMove1
	ld a, [$d235]
	dec a
	jr z, .asm_3e4e2
	dec a
	jr z, .asm_3e4dd
	call Function3e786
	ret z
	ld hl, BattleMonMove1
	jr .asm_3e4e2

.asm_3e4dd
	ld a, $2
	call GetPartyParamLocation

.asm_3e4e2
	ld de, $d25e
	ld bc, $0004
	call CopyBytes
	xor a
	ld [hBGMapMode], a
	ld hl, $c594
	ld b, $4
	ld c, $e
	ld a, [$d235]
	cp $2
	jr nz, .asm_3e503
	ld hl, $c544
	ld b, $4
	ld c, $e

.asm_3e503
	call TextBox
	ld hl, $c5aa
	ld a, [$d235]
	cp $2
	jr nz, .asm_3e513
	ld hl, $c55a

.asm_3e513
	ld a, $14
	ld [Buffer1], a
	ld a, $20
	call Predef
	ld b, $5
	ld a, [$d235]
	cp $2
	ld a, $d
	jr nz, .asm_3e52c
	ld b, $5
	ld a, $9

.asm_3e52c
	ld [$cfa1], a
	ld a, b
	ld [$cfa2], a
	ld a, [$d235]
	cp $1
	jr z, .asm_3e53e
	ld a, [CurMoveNum]
	inc a

.asm_3e53e
	ld [$cfa9], a
	ld a, $1
	ld [$cfaa], a
	ld a, [$d0eb]
	inc a
	ld [$cfa3], a
	ld a, $1
	ld [$cfa4], a
	ld c, $2c
	ld a, [$d235]
	dec a
	ld b, $c1
	jr z, .asm_3e569
	dec a
	ld b, $c3
	jr z, .asm_3e569
	ld a, [InLinkBattle]
	and a
	jr nz, .asm_3e569
	ld b, $c7

.asm_3e569
	ld a, b
	ld [$cfa8], a
	ld a, c
	ld [$cfa5], a
	xor a
	ld [$cfa6], a
	ld a, $10
	ld [$cfa7], a
	ld a, [$d235]
	and a
	jr z, .asm_3e58e
	dec a
	jr nz, .asm_3e5a3
	ld hl, $c5c3
	ld de, .string_3e61c
	call PlaceString
	jr .asm_3e5a3

.asm_3e58e
	call MoveInfoBox
	ld a, [$d0e3]
	and a
	jr z, .asm_3e5a3
	ld hl, $c5a9
	ld bc, $0014
	dec a
	call AddNTimes
	ld [hl], $ec

.asm_3e5a3
	ld a, $1
	ld [hBGMapMode], a
	call Function1bd3
	bit 6, a
	jp nz, Function3e61d
	bit 7, a
	jp nz, Function3e62e
	bit 2, a
	jp nz, Function3e643
	bit 1, a
	push af
	xor a
	ld [$d0e3], a
	ld a, [$cfa9]
	dec a
	ld [$cfa9], a
	ld b, a
	ld a, [$d235]
	dec a
	jr nz, .asm_3e5d0
	pop af
	ret

.asm_3e5d0
	dec a
	ld a, b
	ld [CurMoveNum], a
	jr nz, .asm_3e5d9
	pop af
	ret

.asm_3e5d9
	pop af
	ret nz
	ld hl, BattleMonPPMove1
	ld a, [$cfa9]
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	and $3f
	jr z, .asm_3e610
	ld a, [PlayerDisableCount]
	swap a
	and $f
	dec a
	cp c
	jr z, .asm_3e60b
	ld a, [$c6e1]
	and a
	jr nz, .asm_3e606
	ld a, [$cfa9]
	ld hl, BattleMonMove1
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]

.asm_3e606
	ld [CurPlayerMove], a
	xor a
	ret

.asm_3e60b
	ld hl, BattleText_0x80c5b
	jr .asm_3e613

.asm_3e610
	ld hl, Function3cc39

.asm_3e613
	call StdBattleTextBox
	call Function30b4
	jp Function3e4bc
; 3e61c

.string_3e61c ; 3e61c
	db "@"
; 3e61d


Function3e61d: ; 3e61d
	ld a, [$cfa9]
	and a
	jp nz, $657a
	ld a, [$d0eb]
	inc a
	ld [$cfa9], a
	jp $657a
; 3e62e

Function3e62e: ; 3e62e
	ld a, [$cfa9]
	ld b, a
	ld a, [$d0eb]
	inc a
	inc a
	cp b
	jp nz, $657a
	ld a, $1
	ld [$cfa9], a
	jp $657a
; 3e643

Function3e643: ; 3e643
	ld a, [$d0e3]
	and a
	jr z, .asm_3e6bf
	ld hl, BattleMonMoves
	call .asm_3e6a5
	ld hl, BattleMonPP
	call .asm_3e6a5
	ld hl, PlayerDisableCount
	ld a, [hl]
	swap a
	and $f
	ld b, a
	ld a, [$cfa9]
	cp b
	jr nz, .asm_3e671
	ld a, [hl]
	and $f
	ld b, a
	ld a, [$d0e3]
	swap a
	add b
	ld [hl], a
	jr .asm_3e682

.asm_3e671
	ld a, [$d0e3]
	cp b
	jr nz, .asm_3e682
	ld a, [hl]
	and $f
	ld b, a
	ld a, [$cfa9]
	swap a
	add b
	ld [hl], a

.asm_3e682
	ld a, [PlayerSubStatus5]
	bit 3, a
	jr nz, .asm_3e69e
	ld hl, PartyMon1Moves
	ld a, [CurBattleMon]
	call GetPartyLocation
	push hl
	call .asm_3e6a5
	pop hl
	ld bc, $0015
	add hl, bc
	call .asm_3e6a5

.asm_3e69e
	xor a
	ld [$d0e3], a
	jp Function3e4bc

.asm_3e6a5
	push hl
	ld a, [$d0e3]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [$cfa9]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [de]
	ld b, [hl]
	ld [hl], a
	ld a, b
	ld [de], a
	ret

.asm_3e6bf
	ld a, [$cfa9]
	ld [$d0e3], a
	jp Function3e4bc
; 3e6c8

MoveInfoBox: ; 3e6c8
	xor a
	ld [hBGMapMode], a

	hlcoord 0, 8
	ld b, 3
	ld c, 9
	call TextBox
	call MobileTextBorder

	ld a, [PlayerDisableCount]
	and a
	jr z, .asm_3e6f4

	swap a
	and $f
	ld b, a
	ld a, [$cfa9]
	cp b
	jr nz, .asm_3e6f4

	hlcoord 1, 10
	ld de, .Disabled
	call PlaceString
	jr .done

.asm_3e6f4
	ld hl, $cfa9
	dec [hl]
	call SetPlayerTurn
	ld hl, BattleMonMoves
	ld a, [$cfa9]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [CurPlayerMove], a

	ld a, [CurBattleMon]
	ld [CurPartyMon], a
	ld a, WILDMON
	ld [MonType], a
	callab Functionf8ec

	ld hl, $cfa9
	ld c, [hl]
	inc [hl]
	ld b, 0
	ld hl, BattleMonPP
	add hl, bc
	ld a, [hl]
	and $3f
	ld [StringBuffer1], a
	call Function3e75f

	hlcoord 1, 9
	ld de, .Type
	call PlaceString

	hlcoord 7, 11
	ld [hl], "/"

	callab UpdateMoveData
	ld a, [PlayerMoveAnimation]
	ld b, a
	hlcoord 2, 10
	ld a, PREDEF_PRINT_MOVE_TYPE
	call Predef

.done
	ret
; 3e74f

.Disabled
	db "Disabled!@"
.Type
	db "TYPE/@"
; 3e75f


Function3e75f: ; 3e75f
	hlcoord 5, 11
	ld a, [InLinkBattle]
	cp $4
	jr c, .asm_3e76c
	hlcoord 5, 11

.asm_3e76c
	push hl
	ld de, StringBuffer1
	ld bc, $0102
	call PrintNum
	pop hl
	inc hl
	inc hl
	ld [hl], "/"
	inc hl
	ld de, $d265
	ld bc, $0102
	call PrintNum
	ret
; 3e786

Function3e786: ; 3e786
	ld a, STRUGGLE
	ld [CurPlayerMove], a
	ld a, [PlayerDisableCount]
	and a
	ld hl, BattleMonPP
	jr nz, .asm_3e79f

	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	inc hl
	or [hl]
	and $3f
	ret nz
	jr .asm_3e7b4

.asm_3e79f
	swap a
	and $f
	ld b, a
	ld d, $5
	xor a
.asm_3e7a7
	dec d
	jr z, .asm_3e7b2
	ld c, [hl]
	inc hl
	dec b
	jr z, .asm_3e7a7
	or c
	jr .asm_3e7a7

.asm_3e7b2
	and a
	ret nz

.asm_3e7b4
	ld hl, BattleText_0x80c72
	call StdBattleTextBox
	ld c, 60
	call DelayFrames
	xor a
	ret
; 3e7c1



Function3e7c1: ; 3e7c1
	ld a, [$c711]
	and a
	ret nz
	ld a, [InLinkBattle]
	and a
	jr z, .asm_3e817
	call EmptyBattleTextBox
	call Function309d
	ld a, [$d0ec]
	and a
	call z, Function3e8e4
	call Function30b4
	ld a, [$d430]
	cp $e
	jp z, $68bd
	cp $d
	jp z, $682c
	cp $4
	jp nc, Function3e8c1
	ld [CurEnemyMoveNum], a
	ld c, a
	ld a, [EnemySubStatus1]
	bit 6, a
	jp nz, $6882
	ld a, [EnemySubStatus3]
	and $13
	jp nz, $6882
	ld hl, EnemySubStatus5
	bit 4, [hl]
	ld a, [LastEnemyMove]
	jp nz, $687f
	ld hl, EnemyMonMove1
	ld b, $0
	add hl, bc
	ld a, [hl]
	jp $687f

.asm_3e817
	ld hl, EnemySubStatus5
	bit 4, [hl]
	jr z, .asm_3e824
	ld a, [LastEnemyMove]
	jp $687f

.asm_3e824
	call Function3e8d1
	jp nz, Function3e8c1
	jr .asm_3e830

	ld a, $ff
	jr .asm_3e87f

.asm_3e830
	ld hl, EnemyMonMove1
	ld de, EnemyMonPPMove1
	ld b, $4
.asm_3e838
	ld a, [hl]
	and a
	jp z, $68bd
	ld a, [EnemyDisabledMove]
	cp [hl]
	jr z, .asm_3e848
	ld a, [de]
	and $3f
	jr nz, .asm_3e84f

.asm_3e848
	inc hl
	inc de
	dec b
	jr nz, .asm_3e838
	jr .asm_3e8bd

.asm_3e84f
	ld a, [IsInBattle]
	dec a
	jr nz, .asm_3e882
.asm_3e855
	ld hl, EnemyMonMove1
	call BattleRandom
	and $3
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [EnemyDisableCount]
	swap a
	and $f
	dec a
	cp c
	jr z, .asm_3e855
	ld a, [hl]
	and a
	jr z, .asm_3e855
	ld hl, EnemyMonPPMove1
	add hl, bc
	ld b, a
	ld a, [hl]
	and $3f
	jr z, .asm_3e855
	ld a, c
	ld [CurEnemyMoveNum], a
	ld a, b

.asm_3e87f
	ld [CurEnemyMove], a

.asm_3e882
	call SetEnemyTurn
	callab UpdateMoveData
	call Function3e8d1
	jr nz, .asm_3e894
	xor a
	ld [$c733], a

.asm_3e894
	ld a, [EnemyMoveEffect]
	cp $77
	jr z, .asm_3e89f
	xor a
	ld [EnemyFuryCutterCount], a

.asm_3e89f
	ld a, [EnemyMoveEffect]
	cp $51
	jr z, .asm_3e8af
	ld hl, EnemySubStatus4
	res 6, [hl]
	xor a
	ld [$c72c], a

.asm_3e8af
	ld a, [EnemyMoveEffect]
	cp $6f
	ret z
	cp $74
	ret z
	xor a
	ld [$c681], a
	ret

.asm_3e8bd
	ld a, $a5
	jr .asm_3e87f
; 3e8c1

Function3e8c1: ; 3e8c1
	xor a
	ld [EnemyFuryCutterCount], a
	ld [$c681], a
	ld [$c72c], a
	ld hl, EnemySubStatus4
	res 6, [hl]
	ret
; 3e8d1

Function3e8d1: ; 3e8d1
	ld a, [EnemySubStatus4]
	and $20
	ret nz
	ld hl, EnemySubStatus3
	ld a, [hl]
	and $13
	ret nz
	ld hl, EnemySubStatus1
	bit 6, [hl]
	ret
; 3e8e4

Function3e8e4: ; 3e8e4
	ld a, $40
	ld hl, $4a09
	rst FarCall
	ret
; 3e8eb


LoadEnemyMon: ; 3e8eb
; Initialize enemy monster parameters
; To do this we pull the species from TempEnemyMonSpecies

; Notes:
;   BattleRandom is used to ensure sync between Game Boys

; Clear the whole EnemyMon struct
	xor a
	ld hl, EnemyMonSpecies
	ld bc, EnemyMonEnd - EnemyMon
	call ByteFill
	
; We don't need to be here if we're in a link battle
	ld a, [InLinkBattle]
	and a
	jp nz, Function3dabd
	
	ld a, [$cfc0] ; ????
	bit 0, a
	jp nz, Function3dabd
	
; Make sure everything knows what species we're working with
	ld a, [TempEnemyMonSpecies]
	ld [EnemyMonSpecies], a
	ld [CurSpecies], a
	ld [CurPartySpecies], a
	
; Grab the BaseData for this species
	call GetBaseData
	

; Let's get the item:

; Is the item predetermined?
	ld a, [IsInBattle]
	dec a
	jr z, .WildItem
	
; If we're in a trainer battle, the item is in the party struct
	ld a, [CurPartyMon]
	ld hl, OTPartyMon1Item
	call GetPartyLocation ; bc = PartyMon[CurPartyMon] - PartyMons
	ld a, [hl]
	jr .UpdateItem
	
	
.WildItem
; In a wild battle, we pull from the item slots in BaseData

; Force Item1
; Used for Ho-Oh, Lugia and Snorlax encounters
	ld a, [BattleType]
	cp BATTLETYPE_FORCEITEM
	ld a, [BaseItems]
	jr z, .UpdateItem
	
; Failing that, it's all up to chance
;  Effective chances:
;    75% None
;    23% Item1
;     2% Item2

; 25% chance of getting an item
	call BattleRandom
	cp a, $c0
	ld a, NO_ITEM
	jr c, .UpdateItem
	
; From there, an 8% chance for Item2
	call BattleRandom
	cp a, $14 ; 8% of 25% = 2% Item2
	ld a, [BaseItems]
	jr nc, .UpdateItem
	ld a, [BaseItems+1]
	
	
.UpdateItem
	ld [EnemyMonItem], a
	
	
; Initialize DVs
	
; If we're in a trainer battle, DVs are predetermined
	ld a, [IsInBattle]
	and a
	jr z, .InitDVs
	
; ????
	ld a, [EnemySubStatus5]
	bit 3, a
	jr z, .InitDVs
	
; Unknown
	ld hl, $c6f2
	ld de, EnemyMonDVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	jp .Happiness
	
	
.InitDVs
	
; Trainer DVs
	
; All trainers have preset DVs, determined by class
; See GetTrainerDVs for more on that
	callba GetTrainerDVs
; These are the DVs we'll use if we're actually in a trainer battle
	ld a, [IsInBattle]
	dec a
	jr nz, .UpdateDVs
	
	
; Wild DVs
; Here's where the fun starts

; Roaming monsters (Entei, Raikou) work differently
; They have their own structs, which are shorter than normal
	ld a, [BattleType]
	cp a, BATTLETYPE_ROAMING
	jr nz, .NotRoaming
	
; Grab HP
	call GetRoamMonHP
	ld a, [hl]
; Check if the HP has been initialized
	and a
; We'll do something with the result in a minute
	push af
	
; Grab DVs
	call GetRoamMonDVs
	inc hl
	ld a, [hld]
	ld c, a
	ld b, [hl]

; Get back the result of our check
	pop af
; If the RoamMon struct has already been initialized, we're done
	jr nz, .UpdateDVs
	
; If it hasn't, we need to initialize the DVs
; (HP is initialized at the end of the battle)
	call GetRoamMonDVs
	inc hl
	call BattleRandom
	ld [hld], a
	ld c, a
	call BattleRandom
	ld [hl], a
	ld b, a
; We're done with DVs
	jr .UpdateDVs

	
.NotRoaming
; Register a contains BattleType

; Forced shiny battle type
; Used by Red Gyarados at Lake of Rage
	cp a, BATTLETYPE_SHINY
	jr nz, .GenerateDVs

	ld b, ATKDEFDV_SHINY ; $ea
	ld c, SPDSPCDV_SHINY ; $aa
	jr .UpdateDVs
	
.GenerateDVs
; Generate new random DVs
	call BattleRandom
	ld b, a
	call BattleRandom
	ld c, a
	
.UpdateDVs
; Input DVs in register bc
	ld hl, EnemyMonDVs
	ld a, b
	ld [hli], a
	ld [hl], c
	
	
; We've still got more to do if we're dealing with a wild monster
	ld a, [IsInBattle]
	dec a
	jr nz, .Happiness
	
	
; Species-specfic:
	
	
; Unown
	ld a, [TempEnemyMonSpecies]
	cp a, UNOWN
	jr nz, .Magikarp
	
; Get letter based on DVs
	ld hl, EnemyMonDVs
	ld a, PREDEF_GET_UNOWN_LETTER
	call Predef
; Can't use any letters that haven't been unlocked
; If combined with forced shiny battletype, causes an infinite loop
	call CheckUnownLetter
	jr c, .GenerateDVs ; try again
	
	
.Magikarp
; Skimming this part recommended
	
	ld a, [TempEnemyMonSpecies]
	cp a, MAGIKARP
	jr nz, .Happiness
	
; Get Magikarp's length
	ld de, EnemyMonDVs
	ld bc, PlayerID
	callab CalcMagikarpLength
	
; We're clear if the length is < 1536
	ld a, [MagikarpLength]
	cp a, $06 ; $600 = 1536
	jr nz, .CheckMagikarpArea
	
; 5% chance of skipping size checks
	call Random
	cp a, $0c ; / $100
	jr c, .CheckMagikarpArea
; Try again if > 1614
	ld a, [MagikarpLength + 1]
	cp a, $50
	jr nc, .GenerateDVs
	
; 20% chance of skipping this check
	call Random
	cp a, $32 ; / $100
	jr c, .CheckMagikarpArea
; Try again if > 1598
	ld a, [MagikarpLength + 1]
	cp a, $40
	jr nc, .GenerateDVs
	
.CheckMagikarpArea
; The z checks are supposed to be nz
; Instead, all maps in GROUP_LAKE_OF_RAGE (mahogany area)
; and routes 20 and 44 are treated as Lake of Rage
	
; This also means Lake of Rage Magikarp can be smaller than ones
; caught elsewhere rather than the other way around
	
; Intended behavior enforces a minimum size at Lake of Rage
; The real behavior prevents size flooring in the Lake of Rage area
	ld a, [MapGroup]
	cp a, GROUP_LAKE_OF_RAGE
	jr z, .Happiness
	ld a, [MapNumber]
	cp a, MAP_LAKE_OF_RAGE
	jr z, .Happiness
; 40% chance of not flooring
	call Random
	cp a, $64 ; / $100
	jr c, .Happiness
; Floor at length 1024
	ld a, [MagikarpLength]
	cp a, 1024 >> 8
	jr c, .GenerateDVs ; try again
	
	
; Finally done with DVs
	
.Happiness
; Set happiness
	ld a, BASE_HAPPINESS
	ld [EnemyMonHappiness], a
; Set level
	ld a, [CurPartyLevel]
	ld [EnemyMonLevel], a
; Fill stats
	ld de, EnemyMonMaxHP
	ld b, $00
	ld hl, $d201 ; ?
	ld a, PREDEF_FILLSTATS
	call Predef
	
; If we're in a trainer battle,
; get the rest of the parameters from the party struct
	ld a, [IsInBattle]
	cp a, TRAINER_BATTLE
	jr z, .OpponentParty
	
; If we're in a wild battle, check wild-specific stuff
	and a
	jr z, .TreeMon
	
; ????
	ld a, [EnemySubStatus5]
	bit 3, a
	jp nz, .Moves
	
.TreeMon
; If we're headbutting trees, some monsters enter battle asleep
	call CheckSleepingTreeMon
	ld a, 7 ; Asleep for 7 turns
	jr c, .UpdateStatus
; Otherwise, no status
	xor a
	
.UpdateStatus
	ld hl, EnemyMonStatus
	ld [hli], a
	
; Unused byte
	xor a
	ld [hli], a
	
; Full HP...
	ld a, [EnemyMonMaxHPHi]
	ld [hli], a
	ld a, [EnemyMonMaxHPLo]
	ld [hl], a
	
; ...unless it's a RoamMon
	ld a, [BattleType]
	cp a, BATTLETYPE_ROAMING
	jr nz, .Moves
	
; Grab HP
	call GetRoamMonHP
	ld a, [hl]
; Check if it's been initialized again
	and a
	jr z, .InitRoamHP
; Update from the struct if it has
	ld a, [hl]
	ld [EnemyMonHPLo], a
	jr .Moves
	
.InitRoamHP
; HP only uses the lo byte in the RoamMon struct since
; Raikou/Entei/Suicune will have < 256 hp at level 40
	ld a, [EnemyMonHPLo]
	ld [hl], a
	jr .Moves
	
	
.OpponentParty
; Get HP from the party struct
	ld hl, (PartyMon1CurHP + 1) - PartyMon1 + OTPartyMon1
	ld a, [CurPartyMon]
	call GetPartyLocation
	ld a, [hld]
	ld [EnemyMonHPLo], a
	ld a, [hld]
	ld [EnemyMonHPHi], a
	
; Make sure everything knows which monster the opponent is using
	ld a, [CurPartyMon]
	ld [CurOTMon], a
	
; Get status from the party struct
	dec hl
	ld a, [hl] ; OTPartyMonStatus
	ld [EnemyMonStatus], a
	
	
.Moves
; ????
	ld hl, BaseType1
	ld de, EnemyMonType1
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	
; Get moves
	ld de, EnemyMonMoves
; Are we in a trainer battle?
	ld a, [IsInBattle]
	cp a, TRAINER_BATTLE
	jr nz, .WildMoves
; Then copy moves from the party struct
	ld hl, OTPartyMon1Moves
	ld a, [CurPartyMon]
	call GetPartyLocation
	ld bc, NUM_MOVES
	call CopyBytes
	jr .PP
	
.WildMoves
; Clear EnemyMonMoves
	xor a
	ld h, d
	ld l, e
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
; Make sure the predef knows this isn't a partymon
	ld [MagikarpLength], a
; Fill moves based on level
	ld a, PREDEF_FILLMOVES
	call Predef
	
.PP
; Trainer battle?
	ld a, [IsInBattle]
	cp a, TRAINER_BATTLE
	jr z, .TrainerPP
	
; Fill wild PP
	ld hl, EnemyMonMoves
	ld de, EnemyMonPP
	ld a, PREDEF_FILLPP
	call Predef
	jr .Finish
	
.TrainerPP
; Copy PP from the party struct
	ld hl, OTPartyMon1PP
	ld a, [CurPartyMon]
	call GetPartyLocation
	ld de, EnemyMonPP
	ld bc, NUM_MOVES
	call CopyBytes
	
.Finish
; Only the first five base stats are copied...
	ld hl, BaseStats
	ld de, EnemyMonBaseStats
	ld b, BaseSpecialDefense - BaseStats
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop

	ld a, [BaseCatchRate]
	ld [de], a
	inc de

	ld a, [BaseExp]
	ld [de], a

	ld a, [TempEnemyMonSpecies]
	ld [$d265], a

	call GetPokemonName

; Did we catch it?
	ld a, [IsInBattle]
	and a
	ret z

; Update enemy nick
	ld hl, StringBuffer1
	ld de, EnemyMonNick
	ld bc, PKMN_NAME_LENGTH
	call CopyBytes

; Caught this mon
	ld a, [TempEnemyMonSpecies]
	dec a
	ld c, a
	ld b, 1 ; set
	ld hl, PokedexCaught
	ld a, PREDEF_FLAG
	call Predef

	ld hl, EnemyMonStats
	ld de, EnemyStats
	ld bc, EnemyMonStatsEnd - EnemyMonStats
	call CopyBytes

	ret
; 3eb38


CheckSleepingTreeMon: ; 3eb38
; Return carry if species is in the list
; for the current time of day

; Don't do anything if this isn't a tree encounter
	ld a, [BattleType]
	cp a, BATTLETYPE_TREE
	jr nz, .NotSleeping
	
; Get list for the time of day
	ld hl, .Morn
	ld a, [TimeOfDay]
	cp a, DAY
	jr c, .Check
	ld hl, .Day
	jr z, .Check
	ld hl, .Nite
	
.Check
	ld a, [TempEnemyMonSpecies]
	ld de, 1 ; length of species id
	call IsInArray
; If it's a match, the opponent is asleep
	ret c
	
.NotSleeping
	and a
	ret

.Nite
	db CATERPIE
	db METAPOD
	db BUTTERFREE
	db WEEDLE
	db KAKUNA
	db BEEDRILL
	db SPEAROW
	db EKANS
	db EXEGGCUTE
	db LEDYBA
	db AIPOM
	db $ff ; end

.Day
	db VENONAT
	db HOOTHOOT
	db NOCTOWL
	db SPINARAK
	db HERACROSS
	db $ff ; end

.Morn
	db VENONAT
	db HOOTHOOT
	db NOCTOWL
	db SPINARAK
	db HERACROSS
	db $ff ; end
; 3eb75


CheckUnownLetter: ; 3eb75
; Return carry if the Unown letter hasn't been unlocked yet
	
	ld a, [UnlockedUnowns]
	ld c, a
	ld de, 0
	
.loop
	
; Don't check this set unless it's been unlocked
	srl c
	jr nc, .next
	
; Is our letter in the set?
	ld hl, .LetterSets
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	
	push de
	ld a, [UnownLetter]
	ld de, 1
	push bc
	call IsInArray
	pop bc
	pop de
	
	jr c, .match
	
.next
; Make sure we haven't gone past the end of the table
	inc e
	inc e
	ld a, e
	cp a, .Set1 - .LetterSets
	jr c, .loop
	
; Hasn't been unlocked, or the letter is invalid
	scf
	ret
	
.match
; Valid letter
	and a
	ret
	
.LetterSets
	dw .Set1
	dw .Set2
	dw .Set3
	dw .Set4
	
.Set1
	;  A   B   C   D   E   F   G   H   I   J   K
	db 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, $ff
.Set2
	;  L   M   N   O   P   Q   R
	db 12, 13, 14, 15, 16, 17, 18, $ff
.Set3
	;  S   T   U   V   W
	db 19, 20, 21, 22, 23, $ff
.Set4
	;  X   Y   Z
	db 24, 25, 26, $ff
	
; 3ebc7


Function3ebc7: ; 3ebc7
	push bc
	ld a, [BattleMonLevel]
	ld b, a
	ld a, [EnemyMonLevel]
	ld [BattleMonLevel], a
	ld a, b
	ld [EnemyMonLevel], a
	pop bc
	ret
; 3ebd8

Function3ebd8: ; 3ebd8
	xor a
	ld [TempEnemyMonSpecies], a
	call Function3ee27
	ld a, [OtherTrainerClass]
	ld [TrainerClass], a
	ld de, VTiles2
	ld hl, $520d
	ld a, $14
	rst FarCall
	ld hl, $c4b3
	ld c, $0
.asm_3ebf3
	inc c
	ld a, c
	cp $7
	ret z
	xor a
	ld [hBGMapMode], a
	ld [hBGMapThird], a
	ld d, $0
	push bc
	push hl
.asm_3ec01
	call Function3ec1a
	inc hl
	ld a, $7
	add d
	ld d, a
	dec c
	jr nz, .asm_3ec01
	ld a, $1
	ld [hBGMapMode], a
	ld c, $4
	call DelayFrames
	pop hl
	pop bc
	dec hl
	jr .asm_3ebf3
; 3ec1a

Function3ec1a: ; 3ec1a
	push hl
	push de
	push bc
	ld e, $7
.asm_3ec1f
	ld [hl], d
	ld bc, $0014
	add hl, bc
	inc d
	dec e
	jr nz, .asm_3ec1f
	pop bc
	pop de
	pop hl
	ret
; 3ec2c


Function3ec2c: ; 3ec2c
	ld a, 1
	jr Function3ec31
; 3ec30

Function3ec30: ; 3ec30
	xor a
; 3ec31

Function3ec31: ; 3ec31
	ld [hBattleTurn], a
	call Function3ec39
	jp Function3ec76
; 3ec39

Function3ec39: ; 3ec39
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3ec5a
	ld a, [BattleMonStatus]
	and $40
	ret z
	ld hl, $c645
	ld a, [hld]
	ld b, a
	ld a, [hl]
	srl a
	rr b
	srl a
	rr b
	ld [hli], a
	or b
	jr nz, .asm_3ec58
	ld b, $1

.asm_3ec58
	ld [hl], b
	ret

.asm_3ec5a
	ld a, [EnemyMonStatus]
	and $40
	ret z
	ld hl, $d21f
	ld a, [hld]
	ld b, a
	ld a, [hl]
	srl a
	rr b
	srl a
	rr b
	ld [hli], a
	or b
	jr nz, .asm_3ec74
	ld b, $1

.asm_3ec74
	ld [hl], b
	ret
; 3ec76

Function3ec76: ; 3ec76
	ld a, [hBattleTurn]
	and a
	jr z, .asm_3ec93
	ld a, [BattleMonStatus]
	and $10
	ret z
	ld hl, $c641
	ld a, [hld]
	ld b, a
	ld a, [hl]
	srl a
	rr b
	ld [hli], a
	or b
	jr nz, .asm_3ec91
	ld b, $1

.asm_3ec91
	ld [hl], b
	ret

.asm_3ec93
	ld a, [EnemyMonStatus]
	and $10
	ret z
	ld hl, $d21b
	ld a, [hld]
	ld b, a
	ld a, [hl]
	srl a
	rr b
	ld [hli], a
	or b
	jr nz, .asm_3eca9
	ld b, $1

.asm_3eca9
	ld [hl], b
	ret
; 3ecab

Function3ecab: ; 3ecab
	ld c, 0
.asm_3ecad
	call Function3ecb7
	inc c
	ld a, c
	cp 5
	jr nz, .asm_3ecad
	ret
; 3ecb7

Function3ecb7: ; 3ecb7
	push bc
	push bc
	ld a, [$d265]
	and a
	ld a, c
	ld hl, BattleMonAtk
	ld de, PlayerStats
	ld bc, PlayerAtkLevel
	jr z, .asm_3ecd2
	ld hl, EnemyMonAtk
	ld de, EnemyStats
	ld bc, EnemyAtkLevel

.asm_3ecd2
	add c
	ld c, a
	jr nc, .asm_3ecd7
	inc b
.asm_3ecd7
	ld a, [bc]
	pop bc
	ld b, a
	push bc
	sla c
	ld b, 0
	add hl, bc
	ld a, c
	add e
	ld e, a
	jr nc, .asm_3ece6
	inc d
.asm_3ece6
	pop bc
	push hl
	ld hl, .StatLevelMultipliers
	dec b
	sla b
	ld c, b
	ld b, 0
	add hl, bc
	xor a
	ld [hMultiplicand], a
	ld a, [de]
	ld [$ffb5], a
	inc de
	ld a, [de]
	ld [$ffb6], a
	ld a, [hli]
	ld [hMultiplier], a
	call Multiply
	ld a, [hl]
	ld [hMultiplier], a
	ld b, $4
	call Divide
	pop hl

; Cap at 999.
	ld a, [$ffb6]
	sub 999 % $100
	ld a, [$ffb5]
	sbc 999 / $100
	jp c, .asm_3ed1e

	ld a, 999 / $100
	ld [$ffb5], a
	ld a, 999 % $100
	ld [$ffb6], a

.asm_3ed1e
	ld a, [$ffb5]
	ld [hli], a
	ld b, a
	ld a, [$ffb6]
	ld [hl], a
	or b
	jr nz, .asm_3ed29
	inc [hl]

.asm_3ed29
	pop bc
	ret
; 3ed2b

.StatLevelMultipliers
;	      /
	db 25, 100 ; 25%
	db 28, 100 ; 28%
	db 33, 100 ; 33%
	db 40, 100 ; 40%
	db 50, 100 ; 50%
	db 66, 100 ; 66%

	db  1,  1 ; 100%

	db 15, 10 ; 150%
	db  2,  1 ; 200%
	db 25, 10 ; 250%
	db  3,  1 ; 300%
	db 35, 10 ; 350%
	db  4,  1 ; 400%
; 3ed45


BadgeStatBoosts: ; 3ed45
; Raise BattleMon stats depending on which badges have been obtained.

; Every other badge boosts a stat, starting from the first.

; 	ZephyrBadge:  Attack
; 	PlainBadge:   Speed
; 	MineralBadge: Defense
; 	GlacierBadge: Special Attack
; 	RisingBadge:  Special Defense

; The boosted stats are in order, except PlainBadge and MineralBadge's boosts are swapped.

	ld a, [InLinkBattle]
	and a
	ret nz

	ld a, [$cfc0]
	and a
	ret nz

	ld a, [JohtoBadges]

; Swap badges 3 (PlainBadge) and 5 (MineralBadge).
	ld d, a
	and %00000100
	add a
	add a
	ld b, a
	ld a, d
	and %00010000
	rrca
	rrca
	ld c, a
	ld a, d
	and %11101011
	or b
	or c
	ld b, a

	ld hl, BattleMonAtk
	ld c, 4
.CheckBadge
	ld a, b
	srl b
	call c, BoostStat
	inc hl
	inc hl
; Check every other badge.
	srl b
	dec c
	jr nz, .CheckBadge
; And the last one (RisingBadge) too.
	srl a
	call c, BoostStat
	ret
; 3ed7c


BoostStat: ; 3ed7c
; Raise stat at hl by 1/8.

	ld a, [hli]
	ld d, a
	ld e, [hl]
	srl d
	rr e
	srl d
	rr e
	srl d
	rr e
	ld a, [hl]
	add e
	ld [hld], a
	ld a, [hl]
	adc d
	ld [hli], a

; Cap at 999.
	ld a, [hld]
	sub 999 % $100
	ld a, [hl]
	sbc 999 / $100
	ret c
	ld a, 999 / $100
	ld [hli], a
	ld a, 999 % $100
	ld [hld], a
	ret
; 3ed9f


Function3ed9f: ; 3ed9f
	ld hl, $74f2
	ld a, $3e
	rst FarCall
	ret
; 3eda6

Function3eda6: ; 3eda6
	ld hl, $750d
	ld a, $3e
	rst FarCall
	ret
; 3edad


Function3edad: ; 3edad
	ld de, $4ac0
	ld hl, $96c0
	ld bc, $3e04
	call Get1bpp
	ld de, $4ae0
	ld hl, $9730
	ld bc, $3e06
	call Get1bpp
	ld de, $4b10
	ld hl, $9550
	ld bc, $3e08
	jp Get2bpp
; 3edd1


EmptyBattleTextBox: ; 3edd1
	ld hl, .empty
	jp BattleTextBox
.empty
	db "@"
; 3edd8


_BattleRandom: ; 3edd8
; If the normal RNG is used in a link battle it'll desync.
; To circumvent this a shared PRNG is used instead.

; But if we're in a non-link battle we're safe to use it
	ld a, [InLinkBattle]
	and a
	jp z, Random

; The PRNG operates in streams of 10 values.

; Which value are we trying to pull?
	push hl
	push bc
	ld a, [LinkBattleRNCount]
	ld c, a
	ld b, 0
	ld hl, LinkBattleRNs
	add hl, bc
	inc a
	ld [LinkBattleRNCount], a

; If we haven't hit the end yet, we're good
	cp 10 - 1 ; Exclude last value. See the closing comment
	ld a, [hl]
	pop bc
	pop hl
	ret c

; If we have, we have to generate new pseudorandom data
; Instead of having multiple PRNGs, ten seeds are used
	push hl
	push bc
	push af

; Reset count to 0
	xor a
	ld [LinkBattleRNCount], a
	ld hl, LinkBattleRNs
	ld b, 10 ; number of seeds

; Generate next number in the sequence for each seed
; The algorithm takes the form *5 + 1 % 256
.loop
	; get last #
	ld a, [hl]

	; a * 5 + 1
	ld c, a
	add a
	add a
	add c
	inc a

	; update #
	ld [hli], a
	dec b
	jr nz, .loop

; This has the side effect of pulling the last value first,
; then wrapping around. As a result, when we check to see if
; we've reached the end, we check the one before it.

	pop af
	pop bc
	pop hl
	ret
; 3ee0f


Function3ee0f: ; 3ee0f
	ld a, BATTLE_VARS_SUBSTATUS3
	call CleanGetBattleVarPair
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	ret nz
; 3ee17

Function3ee17: ; 3ee17
	ld a, e
	ld [FXAnimIDLo], a
	ld a, d
	ld [FXAnimIDHi], a
	call WaitBGMap
	ld a, $37
	jp Predef
; 3ee27

Function3ee27: ; 3ee27
	push af
	push bc
	push de
	push hl
	ld b, $1
	call GetSGBLayout
	call Function32f9
	call DelayFrame
	pop hl
	pop de
	pop bc
	pop af
	ret
; 3ee3b


Function3ee3b: ; 3ee3b
	ld a, [InLinkBattle]
	and a
	ret nz
	ld a, [$cfc0]
	bit 0, a
	ret nz
	call Function3f0d4
	xor a
	ld [CurPartyMon], a
	ld bc, PartyMon1Species

.asm_3ee50
	ld hl, $0022
	add hl, bc
	ld a, [hli]
	or [hl]
	jp z, .asm_3f0b9
	push bc
	ld hl, $c664
	ld a, [CurPartyMon]
	ld c, a
	ld b, $2
	ld d, $0
	ld a, $3
	call Predef
	ld a, c
	and a
	pop bc
	jp z, .asm_3f0b9
	ld hl, $000c
	add hl, bc
	ld d, h
	ld e, l
	ld hl, EnemyMonType2
	push bc
	ld c, $5
.asm_3ee7c
	inc hl
	ld a, [de]
	add [hl]
	ld [de], a
	jr nc, .asm_3ee89
	dec de
	ld a, [de]
	inc a
	jr z, .asm_3eea4
	ld [de], a
	inc de

.asm_3ee89
	push hl
	push bc
	ld a, $1c
	call GetPartyParamLocation
	ld a, [hl]
	and a
	pop bc
	pop hl
	jr z, .asm_3eea9
	ld a, [de]
	add [hl]
	ld [de], a
	jr nc, .asm_3eea9
	dec de
	ld a, [de]
	inc a
	jr z, .asm_3eea4
	ld [de], a
	inc de
	jr .asm_3eea9

.asm_3eea4
	ld a, $ff
	ld [de], a
	inc de
	ld [de], a

.asm_3eea9
	inc de
	inc de
	dec c
	jr nz, .asm_3ee7c
	xor a
	ld [hMultiplicand], a
	ld [$ffb5], a
	ld a, [EnemyMonBaseExp]
	ld [$ffb6], a
	ld a, [EnemyMonLevel]
	ld [hMultiplier], a
	call Multiply
	ld a, $7
	ld [hMultiplier], a
	ld b, $4
	call Divide
	pop bc
	ld hl, $0006
	add hl, bc
	ld a, [PlayerID]
	cp [hl]
	jr nz, .asm_3eedd
	inc hl
	ld a, [$d47c]
	cp [hl]
	ld a, $0
	jr z, .asm_3eee2

.asm_3eedd
	call Function3f106
	ld a, $1

.asm_3eee2
	ld [$d088], a
	ld a, [IsInBattle]
	dec a
	call nz, Function3f106
	push bc
	ld a, $1
	call GetPartyParamLocation
	ld a, [hl]
	cp $7e
	call z, Function3f106
	ld a, [$ffb6]
	ld [$d087], a
	ld a, [$ffb5]
	ld [StringBuffer2], a
	ld a, [CurPartyMon]
	ld hl, PartyMon1Nickname
	call GetNick
	ld hl, UnknownText_0x3f11b
	call BattleTextBox
	ld a, [$d087]
	ld [$ffb6], a
	ld a, [StringBuffer2]
	ld [$ffb5], a
	pop bc
	call Function3f136
	push bc
	call Function309d
	pop bc
	ld hl, $000a
	add hl, bc
	ld d, [hl]
	ld a, [$ffb6]
	add d
	ld [hld], a
	ld d, [hl]
	ld a, [$ffb5]
	adc d
	ld [hl], a
	jr nc, .asm_3ef3d
	dec hl
	inc [hl]
	jr nz, .asm_3ef3d
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hl], a

.asm_3ef3d
	ld a, [CurPartyMon]
	ld e, a
	ld d, $0
	ld hl, PartySpecies
	add hl, de
	ld a, [hl]
	ld [CurSpecies], a
	call GetBaseData
	push bc
	ld d, $64
	ld hl, $4e47
	ld a, $14
	rst FarCall
	pop bc
	ld hl, $000a
	add hl, bc
	push bc
	ld a, [hMultiplicand]
	ld b, a
	ld a, [$ffb5]
	ld c, a
	ld a, [$ffb6]
	ld d, a
	ld a, [hld]
	sub d
	ld a, [hld]
	sbc c
	ld a, [hl]
	sbc b
	jr c, .asm_3ef74
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hld], a

.asm_3ef74
	xor a
	ld [MonType], a
	ld a, $1f
	call Predef
	ld hl, $4e1b
	ld a, $14
	rst FarCall
	pop bc
	ld hl, $001f
	add hl, bc
	ld a, [hl]
	cp $64
	jp nc, .asm_3f0b9
	cp d
	jp z, .asm_3f0b9
	ld [$c719], a
	ld a, [CurPartyLevel]
	push af
	ld a, d
	ld [CurPartyLevel], a
	ld [hl], a
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	ld [CurSpecies], a
	ld [$d265], a
	call GetBaseData
	ld hl, $0025
	add hl, bc
	ld a, [hld]
	ld e, a
	ld d, [hl]
	push de
	ld hl, $0024
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $000a
	add hl, bc
	push bc
	ld b, $1
	ld a, $c
	call Predef
	pop bc
	pop de
	ld hl, $0025
	add hl, bc
	ld a, [hld]
	sub e
	ld e, a
	ld a, [hl]
	sbc d
	ld d, a
	dec hl
	ld a, [hl]
	add e
	ld [hld], a
	ld a, [hl]
	adc d
	ld [hl], a
	ld a, [CurBattleMon]
	ld d, a
	ld a, [CurPartyMon]
	cp d
	jr nz, .asm_3f035
	ld de, BattleMonHP
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld de, BattleMonMaxHP
	push bc
	ld bc, $000c
	call CopyBytes
	pop bc
	ld hl, $001f
	add hl, bc
	ld a, [hl]
	ld [BattleMonLevel], a
	ld a, [PlayerSubStatus5]
	bit 3, a
	jr nz, .asm_3f012
	ld hl, $0026
	add hl, bc
	ld de, PlayerStats
	ld bc, $000a
	call CopyBytes

.asm_3f012
	xor a
	ld [$d265], a
	call Function3ecab
	ld hl, Function3ec2c
	ld a, $f
	rst FarCall
	ld hl, $6d45
	ld a, $f
	rst FarCall
	ld hl, Function3df48
	ld a, $f
	rst FarCall
	call EmptyBattleTextBox
	call Function309d
	ld a, $1
	ld [hBGMapMode], a

.asm_3f035
	ld a, $9
	ld hl, $709e
	rst FarCall
	ld a, [CurBattleMon]
	ld b, a
	ld a, [CurPartyMon]
	cp b
	jr z, .asm_3f057
	ld de, SFX_HIT_END_OF_EXP_BAR
	call StartSFX
	call WaitSFX
	ld hl, BattleText_0x80c9c
	call StdBattleTextBox
	call Function309d

.asm_3f057
	xor a
	ld [MonType], a
	ld a, $1f
	call Predef
	ld hl, $c4a9
	ld b, $a
	ld c, $9
	call TextBox
	ld hl, $c4bf
	ld bc, $0004
	ld a, $28
	call Predef
	ld c, $1e
	call DelayFrames
	call Functiona80
	call Function30b4
	xor a
	ld [MonType], a
	ld a, [CurSpecies]
	ld [$d265], a
	ld a, [CurPartyLevel]
	push af
	ld c, a
	ld a, [$c719]
	ld b, a

.asm_3f093
	inc b
	ld a, b
	ld [CurPartyLevel], a
	push bc
	ld a, $1a
	call Predef
	pop bc
	ld a, b
	cp c
	jr nz, .asm_3f093
	pop af
	ld [CurPartyLevel], a
	ld hl, EvolvableFlags
	ld a, [CurPartyMon]
	ld c, a
	ld b, $1
	ld a, $3
	call Predef
	pop af
	ld [CurPartyLevel], a

.asm_3f0b9
	ld a, [PartyCount]
	ld b, a
	ld a, [CurPartyMon]
	inc a
	cp b
	jr z, .asm_3f0d1
	ld [CurPartyMon], a
	ld a, $0
	call GetPartyParamLocation
	ld b, h
	ld c, l
	jp .asm_3ee50

.asm_3f0d1
	jp Function3d57a
; 3f0d4

Function3f0d4: ; 3f0d4
	ld a, [$c664]
	ld b, a
	ld c, $6
	ld d, $0
.asm_3f0dc
	xor a
	srl b
	adc d
	ld d, a
	dec c
	jr nz, .asm_3f0dc
	cp $2
	ret c
	ld [$d265], a
	ld hl, EnemyMonBaseStats
	ld c, $7
.asm_3f0ef
	xor a
	ld [hProduct], a
	ld a, [hl]
	ld [hMultiplicand], a
	ld a, [$d265]
	ld [hMultiplier], a
	ld b, $2
	call Divide
	ld a, [$ffb6]
	ld [hli], a
	dec c
	jr nz, .asm_3f0ef
	ret
; 3f106

Function3f106: ; 3f106
	push bc
	ld a, [$ffb5]
	ld b, a
	ld a, [$ffb6]
	ld c, a
	srl b
	rr c
	add c
	ld [$ffb6], a
	ld a, [$ffb5]
	adc b
	ld [$ffb5], a
	pop bc
	ret
; 3f11b

UnknownText_0x3f11b: ; 3f11b
	text_jump UnknownText_0x1c029c, BANK(UnknownText_0x1c029c)
	start_asm
	ld hl, UnknownText_0x3f131
	ld a, [$d088] ; IsTradedMon
	and a
	ret z
	ld hl, UnknownText_0x3f12c
	ret
; 3f12c

UnknownText_0x3f12c: ; 3f12c
	text_jump UnknownText_0x1c02a9, BANK(UnknownText_0x1c02a9)
	db "@"
; 3f131

UnknownText_0x3f131: ; 3f131
	text_jump UnknownText_0x1c02c9, BANK(UnknownText_0x1c02c9)
	db "@"
; 3f136


Function3f136: ; 3f136

	push bc

	ld hl, CurPartyMon
	ld a, [CurBattleMon]
	cp [hl]
	jp nz, .asm_3f219

	ld a, [BattleMonLevel]
	cp MAX_LEVEL
	jp nc, .asm_3f219

	ld a, [$ffb6]
	ld [$d004], a
	push af
	ld a, [$ffb5]
	ld [$d003], a
	push af
	xor a
	ld [DefaultFlypoint], a
	xor a
	ld [MonType], a
	ld a, $1f
	call Predef
	ld a, [TempMonLevel]
	ld b, a
	ld e, a
	push de
	ld de, $d118
	call Function3f39c
	push bc
	ld hl, $d118
	ld a, [$d004]
	add [hl]
	ld [hld], a
	ld a, [$d003]
	adc [hl]
	ld [hld], a
	jr nc, .asm_3f186
	inc [hl]
	jr nz, .asm_3f186
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hl], a

.asm_3f186
	ld d, $64
	callab Function50e47
	ld a, [hMultiplicand]
	ld b, a
	ld a, [$ffb5]
	ld c, a
	ld a, [$ffb6]
	ld d, a
	ld hl, $d118
	ld a, [hld]
	sub d
	ld a, [hld]
	sbc c
	ld a, [hl]
	sbc b
	jr c, .asm_3f1a8
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hld], a

.asm_3f1a8
	ld hl, $4e1b
	ld a, $14
	rst FarCall
	ld a, d
	pop bc
	pop de
	ld d, a
	cp e
	jr nc, .asm_3f1b7
	ld a, e
	ld d, a

.asm_3f1b7
	ld a, e
	cp $64
	jr nc, .asm_3f1ff
	cp d
	jr z, .asm_3f1ff
	inc a
	ld [TempMonLevel], a
	ld [CurPartyLevel], a
	ld [BattleMonLevel], a
	push de
	call Function3f21b
	ld c, $40
	call Function3f22c
	call PrintPlayerHUD
	ld hl, BattleMonNick
	ld de, StringBuffer1
	ld bc, $000b
	call CopyBytes
	call Function3dfe
	ld de, SFX_HIT_END_OF_EXP_BAR
	call StartSFX
	ld a, $23
	ld hl, $679d
	rst FarCall
	call WaitSFX
	ld hl, BattleText_0x80c9c
	call StdBattleTextBox
	pop de
	inc e
	ld b, $0
	jr .asm_3f1b7

.asm_3f1ff
	push bc
	ld b, d
	ld de, $d118
	call Function3f39c
	ld a, b
	pop bc
	ld c, a
	call Function3f21b
	call Function3f22c
	call Function3dfe
	pop af
	ld [$ffb5], a
	pop af
	ld [$ffb6], a

.asm_3f219
	pop bc
	ret
; 3f21b

Function3f21b: ; 3f21b
	push bc
	call WaitSFX
	ld de, SFX_EXP_BAR
	call StartSFX
	ld c, 10
	call DelayFrames
	pop bc
	ret
; 3f22c

Function3f22c: ; 3f22c
	ld d, $3
	dec b
.asm_3f22f
	inc b
	push bc
	push de
	ld hl, $c58d
	call Function3f41c
	pop de
	ld a, $1
	ld [hBGMapMode], a
	ld c, d
	call DelayFrames
	xor a
	ld [hBGMapMode], a
	pop bc
	ld a, c
	cp b
	jr z, .asm_3f268
	inc b
	push bc
	push de
	ld hl, $c58d
	call Function3f41c
	pop de
	ld a, $1
	ld [hBGMapMode], a
	ld c, d
	call DelayFrames
	xor a
	ld [hBGMapMode], a
	dec d
	jr nz, .asm_3f263
	ld d, $1

.asm_3f263
	pop bc
	ld a, c
	cp b
	jr nz, .asm_3f22f

.asm_3f268
	ld a, $1
	ld [hBGMapMode], a
	ret
; 3f26d



Function3f26d: ; 3f26d
; SendOutMonText?

	ld a, [InLinkBattle]
	and a
	jr z, .asm_3f27c
	ld hl, UnknownText_0x3f2d1
	ld a, [$d264]
	and a
	jr nz, .asm_3f2ce

.asm_3f27c
	ld hl, EnemyMonHPHi
	ld a, [hli]
	or [hl]
	ld hl, UnknownText_0x3f2d1
	jr z, .asm_3f2ce
	xor a
	ld [hMultiplicand], a
	ld hl, EnemyMonHPHi
	ld a, [hli]
	ld [$c6ea], a
	ld [$ffb5], a
	ld a, [hl]
	ld [$c6eb], a
	ld [$ffb6], a
	ld a, $19
	ld [hMultiplier], a
	call Multiply
	ld hl, EnemyMonMaxHPHi
	ld a, [hli]
	ld b, [hl]
	srl a
	rr b
	srl a
	rr b
	ld a, b
	ld b, $4
	ld [hMultiplier], a
	call Divide
	ld a, [$ffb6]
	ld hl, UnknownText_0x3f2d1
	cp $46
	jr nc, .asm_3f2ce
	ld hl, UnknownText_0x3f2d8
	cp $28
	jr nc, .asm_3f2ce
	ld hl, UnknownText_0x3f2df
	cp $a
	jr nc, .asm_3f2ce
	ld hl, UnknownText_0x3f2e6

.asm_3f2ce
	jp BattleTextBox
; 3f2d1


UnknownText_0x3f2d1: ; 3f2d1
	text_jump UnknownText_0x1c02df, BANK(UnknownText_0x1c02df)
	start_asm
	jr Function3f2eb
; 3f2d6

UnknownText_0x3f2d8: ; 3f2d8
	text_jump UnknownText_0x1c02e6, BANK(UnknownText_0x1c02e6)
	start_asm
	jr Function3f2eb
; 3f2dd

UnknownText_0x3f2df: ; 3f2df
	text_jump UnknownText_0x1c02f0, BANK(UnknownText_0x1c02f0)
	start_asm
	jr Function3f2eb
; 3f2e4

UnknownText_0x3f2e6: ; 3f2e6
	text_jump UnknownText_0x1c02fe, BANK(UnknownText_0x1c02fe)
	start_asm
; 3f2eb

Function3f2eb: ; 3f2eb
	ld hl, UnknownText_0x3f2ef
	ret
; 3f2ef

UnknownText_0x3f2ef: ; 3f2ef
	text_jump UnknownText_0x1c0317, BANK(UnknownText_0x1c0317)
	db "@"
; 3f2f4


Function3f2f4: ; 3f2f4
	ld hl, UnknownText_0x3f2fa
	jp BattleTextBox
; 3f2fa

UnknownText_0x3f2fa: ; 3f2fa
	text_jump UnknownText_0x1c031d, BANK(UnknownText_0x1c031d)
	start_asm
; 3f2ff

Function3f2ff: ; 3f2ff
	push de
	push bc
	ld hl, EnemyMonHPLo
	ld de, $c6eb
	ld b, [hl]
	dec hl
	ld a, [de]
	sub b
	ld [$ffb6], a
	dec de
	ld b, [hl]
	ld a, [de]
	sbc b
	ld [$ffb5], a
	ld a, $19
	ld [hMultiplier], a
	call Multiply
	ld hl, EnemyMonMaxHPHi
	ld a, [hli]
	ld b, [hl]
	srl a
	rr b
	srl a
	rr b
	ld a, b
	ld b, $4
	ld [hMultiplier], a
	call Divide
	pop bc
	pop de
	ld a, [$ffb6]
	ld hl, UnknownText_0x3f348
	and a
	ret z
	ld hl, UnknownText_0x3f35b
	cp $1e
	ret c
	ld hl, UnknownText_0x3f34d
	cp $46
	ret c
	ld hl, UnknownText_0x3f352
	ret
; 3f348

UnknownText_0x3f348: ; 3f348
	text_jump UnknownText_0x1c0324, BANK(UnknownText_0x1c0324)
	db "@"
; 3f34d

UnknownText_0x3f34d: ; 3f34d
	text_jump UnknownText_0x1c0340, BANK(UnknownText_0x1c0340)
	db "@"
; 3f352

UnknownText_0x3f352: ; 3f352
	text_jump UnknownText_0x1c0352, BANK(UnknownText_0x1c0352)
	db "@"
; 3f357

Function3f357: ; 3f357
	ld hl, UnknownText_0x3f35b
	ret
; 3f35b

UnknownText_0x3f35b: ; 3f35b
	text_jump UnknownText_0x1c0366, BANK(UnknownText_0x1c0366)
	db "@"
; 3f360


Function3f360: ; 3f360
	ld hl, $c6f0
	ld a, [hl]
	and a
	jr z, .asm_3f36d
	dec [hl]
	ld hl, BattleText_0x80cba
	jr .asm_3f388

.asm_3f36d
	dec hl
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ld hl, BattleText_0x80cd1
	jr nz, .asm_3f388
	push hl
	ld a, [EnemyMonSpecies]
	ld [CurSpecies], a
	call GetBaseData
	ld a, [BaseCatchRate]
	ld [EnemyMonCatchRate], a
	pop hl

.asm_3f388
	push hl
	call Function30b4
	pop hl
	jp StdBattleTextBox
; 3f390


FillInExpBar: ; 3f390
	push hl
	call Function3f39c
	pop hl
	ld de, $0007
	add hl, de
	jp Function3f41c
; 3f39c

Function3f39c: ; 3f39c
	push de
	ld d, b
	push de
	callab Function50e47
	pop de
	ld hl, hMultiplicand
	ld a, [hli]
	push af
	ld a, [hli]
	push af
	ld a, [hl]
	push af
	inc d
	callab Function50e47
	ld hl, $ffb6
	ld a, [hl]
	ld [$ffba], a
	pop bc
	sub b
	ld [hld], a
	ld a, [hl]
	ld [$ffb9], a
	pop bc
	sbc b
	ld [hld], a
	ld a, [hl]
	ld [hMathBuffer], a
	pop bc
	sbc b
	ld [hl], a
	pop de
	ld hl, $ffb5
	ld a, [hli]
	push af
	ld a, [hl]
	push af
	ld a, [de]
	dec de
	ld c, a
	ld a, [$ffba]
	sub c
	ld [hld], a
	ld a, [de]
	dec de
	ld b, a
	ld a, [$ffb9]
	sbc b
	ld [hld], a
	ld a, [de]
	ld c, a
	ld a, [hMathBuffer]
	sbc c
	ld [hld], a
	xor a
	ld [hl], a
	ld a, $40
	ld [hMultiplier], a
	call Multiply
	pop af
	ld c, a
	pop af
	ld b, a
.asm_3f3f4
	ld a, b
	and a
	jr z, .asm_3f40c
	srl b
	rr c
	ld hl, hProduct
	srl [hl]
	inc hl
	rr [hl]
	inc hl
	rr [hl]
	inc hl
	rr [hl]
	jr .asm_3f3f4

.asm_3f40c
	ld a, c
	ld [hMultiplier], a
	ld b, $4
	call Divide
	ld a, [$ffb6]
	ld b, a
	ld a, $40
	sub b
	ld b, a
	ret
; 3f41c

Function3f41c: ; 3f41c
	ld c, $8
.asm_3f41e
	ld a, b
	sub $8
	jr c, .asm_3f42c
	ld b, a
	ld a, $6a
	ld [hld], a
	dec c
	jr z, .asm_3f43c
	jr .asm_3f41e

.asm_3f42c
	add $8
	jr z, .asm_3f434
	add $54
	jr .asm_3f436

.asm_3f434
	ld a, $62

.asm_3f436
	ld [hld], a
	ld a, $62
	dec c
	jr nz, .asm_3f434

.asm_3f43c
	ret
; 3f43d

Function3f43d: ; 3f43d
	ld a, [PlayerSubStatus4]
	bit 4, a
	ld hl, $4640
	jr nz, .asm_3f46f
	ld a, [$c6fe]
	and a
	ld hl, Function3c6cf
	jr nz, .asm_3f46f
	ld a, [CurPartySpecies]
	push af
	ld a, [BattleMonSpecies]
	ld [CurPartySpecies], a
	ld hl, BattleMonAtkDefDV
	ld a, $2d
	call Predef
	ld de, $9310
	ld a, $3d
	call Predef
	pop af
	ld [CurPartySpecies], a
	ret

.asm_3f46f
	ld a, [hBattleTurn]
	push af
	xor a
	ld [hBattleTurn], a
	ld a, $33
	rst FarCall
	pop af
	ld [hBattleTurn], a
	ret
; 3f47c

Function3f47c: ; 3f47c
	ld a, [EnemySubStatus4]
	bit 4, a
	ld hl, $4640
	jr nz, .asm_3f4b4
	ld a, [$c6fa]
	and a
	ld hl, Function3c6cf
	jr nz, .asm_3f4b4
	ld a, [CurPartySpecies]
	push af
	ld a, [EnemyMonSpecies]
	ld [CurSpecies], a
	ld [CurPartySpecies], a
	call GetBaseData
	ld hl, EnemyMonAtkDefDV
	ld a, $2d
	call Predef
	ld de, VTiles2
	ld a, $3e
	call Predef
	pop af
	ld [CurPartySpecies], a
	ret

.asm_3f4b4
	ld a, [hBattleTurn]
	push af
	call SetEnemyTurn
	ld a, $33
	rst FarCall
	pop af
	ld [hBattleTurn], a
	ret
; 3f4c1


StartBattle: ; 3f4c1
	ld a, [PartyCount]
	and a
	ret z
	ld a, [TimeOfDayPal]
	push af
	call Function3f4dd
	call Function3c000
	call Function3f69e
	pop af
	ld [TimeOfDayPal], a
	scf
	ret
; 3f4d9


Function3f4d9: ; 3f4d9
	call Function3c000
	ret
; 3f4dd


Function3f4dd: ; 3f4dd
	ld a, $41
	ld hl, $6050
	rst FarCall
	call Function3f54e
	xor a
	ld [TempBattleMonSpecies], a
	ld [$d0d2], a
	xor a
	ld [$ffde], a
	callba PlayBattleMusic
	callba Function2ee18
	callba Function2ee2f
	call Function2ed3
	callba ClearBattleRAM
	call Function3f55e
	call Function3f568
	ld b, $0
	call GetSGBLayout
	ld hl, rLCDC
	res 6, [hl]
	call Function3fb6c
	call BattleStartMessage
	ld hl, rLCDC
	set 6, [hl]
	xor a
	ld [hBGMapMode], a
	call EmptyBattleTextBox
	hlcoord 9, 7
	ld bc, 5 << 8 + 11
	call ClearBox
	hlcoord 1, 0
	ld bc, 4 << 8 + 10
	call ClearBox
	call ClearSprites
	ld a, [IsInBattle]
	cp $1
	call z, Function3e036
	ld a, $1
	ld [hBGMapMode], a
	ret
; 3f54e

Function3f54e: ; 3f54e
	ld a, [OtherTrainerClass]
	and a
	jr nz, .asm_3f55a
	ld a, [$d22e]
	ld [CurPartySpecies], a

.asm_3f55a
	ld [TempEnemyMonSpecies], a
	ret
; 3f55e

Function3f55e: ; 3f55e
	ld a, [OtherTrainerClass]
	and a
	jp nz, Function3f594
	jp Function3f607
; 3f568

Function3f568: ; 3f568
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	ld hl, $d000
	ld bc, VBlank5
	ld a, $2
	call ByteFill
	ld a, [rVBK]
	push af
	ld a, $1
	ld [rVBK], a
	ld de, $d000
	ld hl, VBGMap0
	ld bc, $0f40
	call Request2bpp
	pop af
	ld [rVBK], a
	pop af
	ld [rSVBK], a
	ret
; 3f594

Function3f594: ; 3f594
	ld [TrainerClass], a
	ld a, $41
	ld hl, $606a
	rst FarCall
	xor a
	ld [TempEnemyMonSpecies], a
	ld hl, $557b
	ld a, $e
	rst FarCall
	ld hl, $5771
	ld a, $e
	rst FarCall
	ld a, [TrainerClass]
	cp $9
	jr nz, .asm_3f5b8
	xor a
	ld [OTPartyMon1Item], a

.asm_3f5b8
	ld de, VTiles2
	ld hl, $520d
	ld a, $14
	rst FarCall
	xor a
	ld [$ffad], a
	dec a
	ld [$c6e6], a
	ld hl, $c4ac
	ld bc, $0707
	ld a, $13
	call Predef
	ld a, $ff
	ld [CurOTMon], a
	ld a, $2
	ld [IsInBattle], a
	call IsJohtoGymLeader
	jr nc, .asm_3f606
	xor a
	ld [CurPartyMon], a
	ld a, [PartyCount]
	ld b, a
.asm_3f5ea
	push bc
	ld a, $22
	call GetPartyParamLocation
	ld a, [hli]
	or [hl]
	jr z, .asm_3f5fc
	ld c, $4
	callab ChangeHappiness

.asm_3f5fc
	pop bc
	dec b
	jr z, .asm_3f606
	ld hl, CurPartyMon
	inc [hl]
	jr .asm_3f5ea

.asm_3f606
	ret
; 3f607

Function3f607: ; 3f607
	ld a, $1
	ld [IsInBattle], a
	ld a, $41
	ld hl, $605d
	rst FarCall
	call LoadEnemyMon
	ld hl, EnemyMonMove1
	ld de, $c735
	ld bc, $0004
	call CopyBytes
	ld hl, EnemyMonPPMove1
	ld de, $c739
	ld bc, $0004
	call CopyBytes
	ld hl, EnemyMonAtkDefDV
	ld a, $2d
	call Predef
	ld a, [CurPartySpecies]
	cp $c9
	jr nz, .asm_3f648
	ld a, [$def4]
	and a
	jr nz, .asm_3f648
	ld a, [UnownLetter]
	ld [$def4], a

.asm_3f648
	ld de, VTiles2
	ld a, $3e
	call Predef
	xor a
	ld [TrainerClass], a
	ld [$ffad], a
	ld hl, $c4ac
	ld bc, $0707
	ld a, $13
	call Predef
	ret
; 3f662

Function3f662: ; 3f662
	ld hl, EnemyMonMove1
	ld de, $d25e
	ld b, $4
.asm_3f66a
	ld a, [de]
	inc de
	ld [hli], a
	and a
	jr z, .asm_3f690
	push bc
	push hl
	push hl
	dec a
	ld hl, $5b00
	ld bc, $0007
	call AddNTimes
	ld a, $10
	call GetFarByte
	pop hl
	ld bc, $0005
	add hl, bc
	ld [hl], a
	pop hl
	pop bc
	dec b
	jr nz, .asm_3f66a
	ret

.asm_3f68e
	xor a
	ld [hli], a

.asm_3f690
	push bc
	push hl
	ld bc, $0005
	add hl, bc
	xor a
	ld [hl], a
	pop hl
	pop bc
	dec b
	jr nz, .asm_3f68e
	ret
; 3f69e


Function3f69e: ; 3f69e
	call Function3f6a5
	call Function3f6d0
	ret
; 3f6a5

Function3f6a5: ; 3f6a5
	ld a, [InLinkBattle]
	and a
	jr z, .asm_3f6b7
	call Function3f759
	ld c, $96
	call DelayFrames
	call Function3f77c
	ret

.asm_3f6b7
	ld a, [$d0ee]
	and $f
	ret nz
	call Function3f71d
	xor a
	ld [$d1e9], a
	ld a, $1c
	call Predef
	callba Function2ed44
	ret
; 3f6d0

Function3f6d0: ; 3f6d0
	call Function3f998
	xor a
	ld [Danger], a
	ld [IsInBattle], a
	ld [BattleType], a
	ld [AttackMissed], a
	ld [$d22e], a
	ld [OtherTrainerClass], a
	ld [$d266], a
	ld [$d267], a
	ld [$d232], a
	ld [$d0d8], a
	ld [$d0da], a
	ld [$d0d9], a
	ld [$d0d2], a
	ld [CurMoveNum], a
	ld [$d0db], a
	ld [$d0d6], a
	ld [$d0e4], a
	ld [$d0e0], a
	ld [$d0df], a
	ld [$d0e1], a
	ld hl, PlayerSubStatus1
	ld b, $18
.asm_3f715
	ld [hli], a
	dec b
	jr nz, .asm_3f715
	call WaitSFX
	ret
; 3f71d

Function3f71d: ; 3f71d
	ld hl, $c6ec
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	ret z
	ld a, [$c73d]
	and a
	jr z, .asm_3f73d
	ld hl, $c6ee
	sla [hl]
	dec hl
	rl [hl]
	dec hl
	rl [hl]
	jr nc, .asm_3f73d
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hl], a

.asm_3f73d
	ld hl, $c6ee
	ld de, $d850
	call Function3d0be
	ld hl, BattleText_0x80730
	call StdBattleTextBox
	ld a, [$cfc0]
	bit 0, a
	ret z
	call ClearTileMap
	call WhiteBGMap
	ret
; 3f759

Function3f759: ; 3f759
	ld a, $41
	ld hl, $60df
	rst FarCall
	callba Function106187
	ld a, [CurOTMon]
	ld hl, OTPartyMon1Status
	call GetPartyLocation
	ld a, [EnemyMonStatus]
	ld [hl], a
	call ClearTileMap
	callba Function2c1b2
	ret
; 3f77c

Function3f77c: ; 3f77c
	callba Function3d2e0
	jp c, Function3f80f
	call Function3f830
	jr nz, .asm_3f797
	ld hl, $cd2a
	bit 4, [hl]
	jr z, .asm_3f797
	ld a, $a
	ld hl, $7930
	rst FarCall

.asm_3f797
	ld a, [$d0ee]
	and $f
	cp $1
	jr c, .asm_3f7ad
	jr z, .asm_3f7b8
	ld a, $41
	ld hl, $6107
	rst FarCall
	ld de, .Draw
	jr .asm_3f7c3

.asm_3f7ad
	ld a, $41
	ld hl, $60fb
	rst FarCall
	ld de, .Win
	jr .asm_3f7c3

.asm_3f7b8
	ld a, $41
	ld hl, $6101
	rst FarCall
	ld de, .Lose
	jr .asm_3f7c3

.asm_3f7c3
	ld hl, $c546
	call PlaceString
	callba Function106187
	ld c, $c8
	call DelayFrames
	ld a, $1
	call GetSRAMBank
	call Function3fa42
	call Function3f85f
	call CloseSRAM
	call Function3f830
	jr z, .asm_3f7ee
	call Functiona80
	call ClearTileMap
	ret

.asm_3f7ee
	ld c, $c8
	call DelayFrames
	call ClearTileMap
	ret
; 3f7f7

.Win
	db "YOU WIN@"
.Lose
	db "YOU LOSE@"
.Draw
	db "  DRAW@"
; 3f80f


Function3f80f: ; 3f80f
	ld hl, $c546
	ld de, .Invalid
	call PlaceString
	ld c, $c8
	call DelayFrames
	call ClearTileMap
	ret
; 3f821

.Invalid
	db "INVALID BATTLE@"
; 3f830


Function3f830: ; 3f830
	ld a, [InLinkBattle]
	cp $4
	ret
; 3f836


Function3f836: ; 3f836
	ld a, $1
	call GetSRAMBank
	call Function3f85f
	call CloseSRAM
	ld hl, AttrMap
	xor a
	ld bc, $0168
	call ByteFill
	call Function3200
	ld b, $8
	call GetSGBLayout
	call Function32f9
	ld c, $8
	call DelayFrames
	call Functiona80
	ret
; 3f85f


Function3f85f: ; 3f85f
	call ClearTileMap
	call ClearSprites
	call .asm_3f8e0
	ld hl, $c540
	ld b, $5
	ld de, $b268
.asm_3f870
	push bc
	push hl
	push de
	ld a, [de]
	and a
	jr z, .asm_3f8c9
	ld a, [$d4b4]
	and a
	jr z, .asm_3f8c9
	push hl
	push hl
	ld h, d
	ld l, e
	ld de, DefaultFlypoint
	ld bc, $000a
	call CopyBytes
	ld a, $50
	ld [de], a
	inc de
	ld bc, $0006
	call CopyBytes
	ld de, DefaultFlypoint
	pop hl
	call PlaceString
	pop hl
	ld de, $001a
	add hl, de
	push hl
	ld de, $d00d
	ld bc, $0204
	call PrintNum
	pop hl
	ld de, $0005
	add hl, de
	push hl
	ld de, $d00f
	ld bc, $0204
	call PrintNum
	pop hl
	ld de, $0005
	add hl, de
	ld de, $d011
	ld bc, $0204
	call PrintNum
	jr .asm_3f8cf

.asm_3f8c9
	ld de, .Format
	call PlaceString

.asm_3f8cf
	pop hl
	ld bc, $0012
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld bc, $0028
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_3f870
	ret

.asm_3f8e0
	ld hl, $c4a1
	ld de, .Record
	call PlaceString

	ld hl, $c518
	ld de, .Result
	call PlaceString

	ld hl, $c4c8
	ld de, .Total
	call PlaceString

	ld hl, $c4f6
	ld de, $b260
	call .asm_3f92b
	jr c, .asm_3f92a

	ld bc, $0204
	call PrintNum

	ld hl, $c4fb
	ld de, $b262
	call .asm_3f92b

	ld bc, $0204
	call PrintNum

	ld hl, $c500
	ld de, $b264
	call .asm_3f92b

	ld bc, $0204
	call PrintNum

.asm_3f92a
	ret

.asm_3f92b
	ld a, [$d4b4]
	and a
	ret nz
	ld de, .Scores
	call PlaceString
	scf
	ret
; 3f938

.Scores
	db "   0    0    0@"
; 3f947

.Format ; 3f947
	db "  ---  ", $22, "         -    -    -@"
.Record ; 3f964
	db $52, "'s RECORD@"
.Result ; 3f96e
	db "RESULT WIN LOSE DRAW@"
.Total ; 3f983
	db "TOTAL  WIN LOSE DRAW@"
; 3f998


Function3f998: ; 3f998
	ld a, [BattleType]
	cp BATTLETYPE_ROAMING
	jr nz, .asm_3f9c4
	ld a, [$d0ee]
	and $f
	jr z, .asm_3f9af
	call GetRoamMonHP
	ld a, [EnemyMonHPLo]
	ld [hl], a
	jr .asm_3f9ca

.asm_3f9af
	call GetRoamMonHP
	ld [hl], $0
	call GetRoamMonMapGroup
	ld [hl], $ff
	call GetRoamMonMapNumber
	ld [hl], $ff
	call GetRoamMonSpecies
	ld [hl], $0
	ret

.asm_3f9c4
	call BattleRandom
	and $f
	ret nz

.asm_3f9ca
	callab Function2a30d
	ret
; 3f9d1

GetRoamMonMapGroup: ; 3f9d1
	ld a, [TempEnemyMonSpecies]
	ld b, a
	ld a, [RoamMon1Species]
	cp b
	ld hl, RoamMon1MapGroup
	ret z
	ld a, [RoamMon2Species]
	cp b
	ld hl, RoamMon2MapGroup
	ret z
	ld hl, RoamMon3MapGroup
	ret
; 3f9e9

GetRoamMonMapNumber: ; 3f9e9
	ld a, [TempEnemyMonSpecies]
	ld b, a
	ld a, [RoamMon1Species]
	cp b
	ld hl, RoamMon1MapNumber
	ret z
	ld a, [RoamMon2Species]
	cp b
	ld hl, RoamMon2MapNumber
	ret z
	ld hl, RoamMon3MapNumber
	ret
; 3fa01

GetRoamMonHP: ; 3fa01
; output: hl = RoamMonCurHP
	ld a, [TempEnemyMonSpecies]
	ld b, a
	ld a, [RoamMon1Species]
	cp b
	ld hl, RoamMon1CurHP
	ret z
	ld a, [RoamMon2Species]
	cp b
	ld hl, RoamMon2CurHP
	ret z
	ld hl, RoamMon3CurHP
	ret
; 3fa19

GetRoamMonDVs: ; 3fa19
; output: hl = RoamMonDVs
	ld a, [TempEnemyMonSpecies]
	ld b, a
	ld a, [RoamMon1Species]
	cp b
	ld hl, RoamMon1DVs
	ret z
	ld a, [RoamMon2Species]
	cp b
	ld hl, RoamMon2DVs
	ret z
	ld hl, RoamMon3DVs
	ret
; 3fa31

GetRoamMonSpecies: ; 3fa31
	ld a, [TempEnemyMonSpecies]
	ld hl, RoamMon1Species
	cp [hl]
	ret z
	ld hl, RoamMon2Species
	cp [hl]
	ret z
	ld hl, RoamMon3Species
	ret
; 3fa42


Function3fa42: ; 3fa42
	ld hl, $d276
	ld de, StringBuffer1
	ld bc, $0002
	call CopyBytes
	ld hl, $d26b
	ld bc, $000a
	call CopyBytes
	ld hl, $b254
	call Function3faa0
	ld hl, $b266
	ld d, $5
.asm_3fa62
	push hl
	inc hl
	inc hl
	ld a, [hl]
	dec hl
	dec hl
	and a
	jr z, .asm_3fa85
	push de
	ld bc, $000c
	ld de, StringBuffer1
	call CompareLong
	pop de
	pop hl
	jr c, .asm_3fa99
	ld bc, $0012
	add hl, bc
	dec d
	jr nz, .asm_3fa62
	ld bc, $ffee
	add hl, bc
	push hl

.asm_3fa85
	ld d, h
	ld e, l
	ld hl, StringBuffer1
	ld bc, $000c
	call CopyBytes
	ld b, $6
	xor a
.asm_3fa93
	ld [de], a
	inc de
	dec b
	jr nz, .asm_3fa93
	pop hl

.asm_3fa99
	call Function3faa0
	call Function3fac8
	ret
; 3faa0

Function3faa0: ; 3faa0
	ld a, [$d0ee]
	and $f
	cp $1
	ld bc, $000d
	jr c, .asm_3fab4
	ld bc, $000f
	jr z, .asm_3fab4
	ld bc, $0011

.asm_3fab4
	add hl, bc
	call Function3fabe
	ret nc
	inc [hl]
	ret nz
	dec hl
	inc [hl]
	ret
; 3fabe

Function3fabe: ; 3fabe
	dec hl
	ld a, [hl]
	inc hl
	cp $27
	ret c
	ld a, [hl]
	cp $f
	ret
; 3fac8

Function3fac8: ; 3fac8
	ld b, $5
	ld hl, $b277
	ld de, DefaultFlypoint
.asm_3fad0
	push bc
	push de
	push hl
	call Function3fb54
	pop hl
	ld a, e
	pop de
	ld [de], a
	inc de
	ld a, b
	ld [de], a
	inc de
	ld a, c
	ld [de], a
	inc de
	ld bc, $0012
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_3fad0
	ld b, $0
	ld c, $1
.asm_3faed
	ld a, b
	add b
	add b
	ld e, a
	ld d, $0
	ld hl, DefaultFlypoint
	add hl, de
	push hl
	ld a, c
	add c
	add c
	ld e, a
	ld d, $0
	ld hl, DefaultFlypoint
	add hl, de
	ld d, h
	ld e, l
	pop hl
	push bc
	ld c, $3
	call StringCmp
	pop bc
	jr z, .asm_3fb10
	jr nc, .asm_3fb1f

.asm_3fb10
	inc c
	ld a, c
	cp $5
	jr nz, .asm_3faed
	inc b
	ld c, b
	inc c
	ld a, b
	cp $4
	jr nz, .asm_3faed
	ret

.asm_3fb1f
	push bc
	ld a, b
	ld bc, $0012
	ld hl, $b266
	call AddNTimes
	push hl
	ld de, DefaultFlypoint
	ld bc, $0012
	call CopyBytes
	pop hl
	pop bc
	push hl
	ld a, c
	ld bc, $0012
	ld hl, $b266
	call AddNTimes
	pop de
	push hl
	ld bc, $0012
	call CopyBytes
	ld hl, DefaultFlypoint
	ld bc, $0012
	pop de
	call CopyBytes
	ret
; 3fb54

Function3fb54: ; 3fb54
	ld e, $0
	ld a, [hld]
	ld c, a
	ld a, [hld]
	ld b, a
	ld a, [hld]
	add c
	ld c, a
	ld a, [hld]
	adc b
	ld b, a
	jr nc, .asm_3fb63
	inc e

.asm_3fb63
	ld a, [hld]
	add c
	ld c, a
	ld a, [hl]
	adc b
	ld b, a
	ret nc
	inc e
	ret
; 3fb6c

Function3fb6c: ; 3fb6c
	call Function3fbf8
	ld hl, $c590
	ld b, $4
	ld c, $12
	call TextBox
	callba MobileTextBorder
	ld hl, $c505
	ld bc, $0307
	call ClearBox
	call Functione51
	call Function3ed9f
	call Function3fbd6
	xor a
	ld [$ffde], a
	ld [hSCY], a
	ld a, $90
	ld [hWY], a
	ld [rWY], a
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ld a, $13
	ld hl, $6980
	rst FarCall
	ld a, $1
	ld [hBGMapMode], a
	ld a, $31
	ld [$ffad], a
	ld hl, $c51a
	ld bc, $0606
	ld a, $13
	call Predef
	xor a
	ld [hWY], a
	ld [rWY], a
	call WaitBGMap
	call HideSprites
	ld b, $1
	call GetSGBLayout
	call Function32f9
	ld a, $90
	ld [hWY], a
	xor a
	ld [hSCX], a
	ret
; 3fbd6

Function3fbd6: ; 3fbd6
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	ld hl, $d000
	ld bc, VBlank5
	ld a, $7f
	call ByteFill
	ld de, $d000
	ld hl, VBGMap0
	ld bc, $0f40
	call Request2bpp
	pop af
	ld [rSVBK], a
	ret
; 3fbf8

Function3fbf8: ; 3fbf8
	call GetBattleBackpic
	call Function3fc30
	ret
; 3fbff


GetBattleBackpic: ; 3fbff
; Load the player character's backpic (6x6) into VRAM starting from $9310.

; Special exception for Dude.
	ld b, BANK(DudeBackpic)
	ld hl, DudeBackpic
	ld a, [BattleType]
	cp BATTLETYPE_TUTORIAL
	jr z, .Decompress

; What gender are we?
	ld a, [$d45b]
	bit 2, a
	jr nz, .Chris
	ld a, [PlayerGender]
	bit 0, a
	jr z, .Chris

; It's a girl.
	callba GetKrisBackpic
	ret

.Chris
; It's a boy.
	ld b, BANK(ChrisBackpic)
	ld hl, ChrisBackpic

.Decompress
	ld de, $9310
	ld c, $31
	ld a, PREDEF_DECOMPRESS
	call Predef
	ret
; 3fc30


Function3fc30: ; 3fc30
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	ld hl, VTiles0
	ld de, $9310
	ld a, [hROMBank]
	ld b, a
	ld c, $31
	call Get2bpp
	pop af
	ld [rSVBK], a
	call Function3fc5b
	ld a, $31
	ld [$ffad], a
	ld hl, $c51a
	ld bc, $0606
	ld a, $13
	call Predef
	ret
; 3fc5b

Function3fc5b: ; 3fc5b
	ld hl, Sprites
	xor a
	ld [hConnectionStripLength], a
	ld b, $6
	ld e, $a8
.asm_3fc65
	ld c, $3
	ld d, $40
.asm_3fc69
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl
	ld a, [hConnectionStripLength]
	ld [hli], a
	inc a
	ld [hConnectionStripLength], a
	ld a, $1
	ld [hli], a
	ld a, d
	add $8
	ld d, a
	dec c
	jr nz, .asm_3fc69
	ld a, [hConnectionStripLength]
	add $3
	ld [hConnectionStripLength], a
	ld a, e
	add $8
	ld e, a
	dec b
	jr nz, .asm_3fc65
	ret
; 3fc8b


BattleStartMessage: ; 3fc8b
	ld a, [IsInBattle]
	dec a
	jr z, .asm_3fcaa

	ld de, SFX_SHINE
	call StartSFX
	call WaitSFX

	ld c, 20
	call DelayFrames

	ld a, $e
	ld hl, $5939
	rst FarCall

	ld hl, WantsToBattleText
	jr .asm_3fd0e

.asm_3fcaa
	call $5a79
	jr nc, .asm_3fcc2

	xor a
	ld [$cfca], a
	ld a, 1
	ld [hBattleTurn], a
	ld a, 1
	ld [$c689], a
	ld de, $0101
	call Function3ee17

.asm_3fcc2
	callba CheckSleepingTreeMon
	jr c, .asm_3fceb

	ld a, $13
	ld hl, $6a44
	rst FarCall
	jr c, .asm_3fce0

	hlcoord 12, 0
	ld d, $0
	ld e, $1
	ld a, $47
	call Predef
	jr .asm_3fceb

.asm_3fce0
	ld a, $0f
	ld [CryTracks], a
	ld a, [TempEnemyMonSpecies]
	call Function37b6

.asm_3fceb
	ld a, [BattleType]
	cp BATTLETYPE_FISH
	jr nz, .asm_3fcfd

	ld a, $41
	ld hl, $6086
	rst FarCall

	ld hl, HookedPokemonAttackedText
	jr .asm_3fd0e

.asm_3fcfd
	ld hl, PokemonFellFromTreeText
	cp BATTLETYPE_TREE
	jr z, .asm_3fd0e
	ld hl, WildPokemonAppearedText2
	cp $b
	jr z, .asm_3fd0e
	ld hl, WildPokemonAppearedText

.asm_3fd0e
	push hl
	ld a, $b
	ld hl, $4000
	rst FarCall
	pop hl
	call StdBattleTextBox

	call Function3f830
	ret nz

	ld c, $2
	ld a, $13
	ld hl, $6a0a
	rst FarCall

	ret
; 3fd26


	dw $0000 ; padding


BattleCommandPointers: ; 3fd28

INCLUDE "battle/effect_command_pointers.asm"



SECTION "bank10",ROMX,BANK[$10]

Function40000: ; 40000
	ld a, [hWX]
	ld l, a
	ld a, [hWY]
	ld h, a
	push hl
	ld a, [hSCX]
	push af
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	ld a, [VramState]
	push af
	xor a
	ld [VramState], a
	ld a, [$ffaa]
	push af
	ld a, $1
	ld [$ffaa], a
	xor a
	ld [$ffde], a
	call Function40063
	call DelayFrame
.asm_40029
	call Functiona57
	ld a, [$cf63]
	bit 7, a
	jr nz, .asm_4003b
	call Function4010b
	call DelayFrame
	jr .asm_40029

.asm_4003b
	ld de, SFX_READ_TEXT_2
	call StartSFX
	call WaitSFX
	call ClearSprites
	ld a, [$c7d4]
	ld [$d959], a
	pop af
	ld [$ffaa], a
	pop af
	ld [VramState], a
	pop af
	ld [Options], a
	pop af
	ld [hSCX], a
	pop hl
	ld a, l
	ld [hWX], a
	ld a, h
	ld [hWY], a
	ret
; 40063

Function40063: ; 40063
	call WhiteBGMap
	call ClearSprites
	call ClearTileMap
	call Function414b7
	ld hl, PlayerSDefLevel
	ld bc, $0115
	xor a
	call ByteFill
	xor a
	ld [$cf63], a
	ld [$cf64], a
	ld [$cf65], a
	ld [$cf66], a
	call Function400a2
	ld a, [$d959]
	ld [$c7d4], a
	call Function40bdc
	call Function400b4
	call Function400ed
	ld a, $77
	ld hl, $6247
	rst FarCall
	call Function41af7
	ret
; 400a2

Function400a2: ; 400a2
	ld a, [StatusFlags]
	bit 1, a
	jr nz, .asm_400ae
	xor a
	ld [$c7dc], a
	ret

.asm_400ae
	ld a, $1
	ld [$c7dc], a
	ret
; 400b4

Function400b4: ; 400b4
	ld hl, PlayerSDefLevel
	ld a, [$c2d6]
	and a
	jr z, .asm_400ec
	cp $fc
	jr nc, .asm_400ec
	ld b, a
	ld a, [$c7d2]
	cp $8
	jr c, .asm_400db
	sub $7
	ld c, a
.asm_400cc
	ld a, b
	cp [hl]
	jr z, .asm_400ec
	inc hl
	ld a, [$c7d0]
	inc a
	ld [$c7d0], a
	dec c
	jr nz, .asm_400cc

.asm_400db
	ld c, $7
.asm_400dd
	ld a, b
	cp [hl]
	jr z, .asm_400ec
	inc hl
	ld a, [$c7d1]
	inc a
	ld [$c7d1], a
	dec c
	jr nz, .asm_400dd

.asm_400ec
	ret
; 400ed

Function400ed: ; 400ed
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call GetWorldMapLocation
	cp $0
	jr nz, .asm_40107
	ld a, [BackupMapGroup]
	ld b, a
	ld a, [BackupMapNumber]
	ld c, a
	call GetWorldMapLocation

.asm_40107
	ld [$c7e4], a
	ret
; 4010b

Function4010b: ; 4010b
	ld a, [$cf63]
	ld hl, $4115
	call Function41432
	jp [hl]
; 40115

INCBIN "baserom.gbc", $40115, $40ad5 - $40115


Function40ad5: ; 40ad5
	push hl
	ld a, $33
	ld [hli], a
	ld d, $34
	call Function40b06
	ld a, $35
	ld [hl], a
	pop hl
	ld de, $0014
	add hl, de
.asm_40ae6
	push hl
	ld a, $36
	ld [hli], a
	ld d, $7f
	call Function40b06
	ld a, $37
	ld [hl], a
	pop hl
	ld de, $0014
	add hl, de
	dec b
	jr nz, .asm_40ae6
	ld a, $38
	ld [hli], a
	ld d, $39
	call Function40b06
	ld a, $3a
	ld [hl], a
	ret
; 40b06

Function40b06: ; 40b06
	ld e, c
.asm_40b07
	ld a, e
	and a
	ret z
	ld a, d
	ld [hli], a
	dec e
	jr .asm_40b07
; 40b0f

INCBIN "baserom.gbc", $40b0f, $40bb1 - $40b0f


Function40bb1: ; 40bb1
	ld a, [$c7d1]
	ld hl, $c7d0
	add [hl]
	ld e, a
	ld d, $0
	ld hl, PlayerSDefLevel
	add hl, de
	ld a, [hl]
	ld [$d265], a
	ret
; 40bc4

INCBIN "baserom.gbc", $40bc4, $40bd0 - $40bc4


Function40bd0: ; 40bd0
	push de
	push hl
	ld a, [$d265]
	dec a
	call CheckCaughtMon
	pop hl
	pop de
	ret
; 40bdc



Function40bdc: ; 40bdc
	ld hl, PlayerSDefLevel
	ld bc, Start
	xor a
	call ByteFill
	ld a, [$c7d4]
	ld hl, $4bf0
	call Function41432
	jp [hl]
; 40bf0

INCBIN "baserom.gbc", $40bf0, $40c65 - $40bf0

AlphabeticalPokedexOrder: ; 0x40c65
INCLUDE "stats/pokedex/order_alpha.asm"

NewPokedexOrder: ; 0x40d60
INCLUDE "stats/pokedex/order_new.asm"

Function40e5b: ; 40e5b
	xor a
	ld [hBGMapMode], a
	ld hl, $c590
	ld bc, $0412
	call Function40ad5
	ld a, [$c7d8]
	ld hl, $4e7d
	call Function41432
	ld e, l
	ld d, h
	ld hl, $c5b9
	call PlaceString
	ld a, $1
	ld [hBGMapMode], a
	ret
; 40e7d

INCBIN "baserom.gbc", $40e7d, $41432 - $40e7d


Function41432: ; 41432
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret
; 4143b

Function4143b: ; 4143b
	call Function40bb1
	call Function40bd0
	jr z, .asm_4145b
	ld a, [$def4]
	ld [UnownLetter], a
	ld a, [$d265]
	ld [CurPartySpecies], a
	call GetBaseData
	ld de, VTiles2
	ld a, $3c
	call Predef
	ret

.asm_4145b
	ld a, $0
	call GetSRAMBank
	ld a, $77
	ld hl, $60d7
	rst FarCall
	ld hl, VTiles2
	ld de, $a000
	ld c, $31
	ld a, [hROMBank]
	ld b, a
	call Get2bpp
	call CloseSRAM
	ret
; 41478

INCBIN "baserom.gbc", $41478, $414b7 - $41478


Function414b7: ; 414b7
	call DisableLCD
	ld hl, VTiles2
	ld bc, $0310
	xor a
	call ByteFill
	call Function414fb
	call Functione5f
	ld hl, $9600
	ld bc, $0200
	call $5504
	call Function41a24
	jr nz, .asm_414e0
	ld a, $77
	ld hl, $5f1c
	rst FarCall
	jr .asm_414e9

.asm_414e0
	ld hl, $550e
	ld de, $9310
	call Decompress

.asm_414e9
	ld hl, $56b0
	ld de, VTiles0
	call Decompress
	ld a, $6
	call Function3cb4
	call EnableLCD
	ret
; 414fb

Function414fb: ; 414fb
	call Functione51
	ld hl, VTiles1
	ld bc, $0800
.asm_41504
	ld a, [hl]
	xor $ff
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .asm_41504
	ret
; 4150e

INCBIN "baserom.gbc", $4150e, $41a24 - $4150e


Function41a24: ; 41a24
	ld a, [hCGB]
	or a
	ret nz
	ld a, [hSGB]
	dec a
	ret
; 41a2c

Function41a2c: ; 41a2c
	ld a, $0
	call GetSRAMBank
	ld hl, Function40000
	ld de, $a188
	ld bc, Function270
	ld a, $77
	call FarCopyBytes
	ld hl, $a188
	ld bc, $01b0
	call $5504
	ld de, $a188
	ld hl, $9400
	ld bc, $101b
	call Request2bpp
	call CloseSRAM
	ret
; 41a58

INCBIN "baserom.gbc", $41a58, $41af7 - $41a58


Function41af7: ; 41af7
	xor a
	ld [hBGMapMode], a
	ret
; 41afb


Moves: ; 0x41afb
INCLUDE "battle/moves/moves.asm"


Function421d8: ; 421d8
	ld hl, EvolvableFlags
	xor a
	ld [hl], a
	ld a, [CurPartyMon]
	ld c, a
	ld b, $1
	call Function42577
	xor a
	ld [$d268], a
	dec a
	ld [CurPartyMon], a
	push hl
	push bc
	push de
	ld hl, PartyCount
	push hl
.asm_421f5
	ld hl, CurPartyMon
	inc [hl]
	pop hl
	inc hl
	ld a, [hl]
	cp $ff
	jp z, Function423ff
	ld [MagikarpLength], a
	push hl
	ld a, [CurPartyMon]
	ld c, a
	ld hl, EvolvableFlags
	ld b, $2
	call Function42577
	ld a, c
	and a
	jp z, $61f5
	ld a, [MagikarpLength]
	dec a
	ld b, $0
	ld c, a
	ld hl, EvosAttacksPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	xor a
	ld [MonType], a
	ld a, $1f
	call Predef
	pop hl
	ld a, [hli]
	and a
	jr z, .asm_421f5
	ld b, a
	cp $3
	jr z, .asm_422ae
	ld a, [InLinkBattle]
	and a
	jp nz, $63f9
	ld a, b
	cp $2
	jp z, $62d5
	ld a, [$d1e9]
	and a
	jp nz, $63f9
	ld a, b
	cp $1
	jp z, $62ee
	cp $4
	jr z, .asm_42283
	ld a, [TempMonLevel]
	cp [hl]
	jp c, Function423f8
	call Function42461
	jp z, Function423f8
	push hl
	ld de, TempMonAtk
	ld hl, TempMonDef
	ld c, $2
	call StringCmp
	ld a, $3
	jr z, .asm_4227a
	ld a, $2
	jr c, .asm_4227a
	ld a, $1

.asm_4227a
	pop hl
	inc hl
	cp [hl]
	jp nz, $63f9
	inc hl
	jr .asm_422fd

.asm_42283
	ld a, [TempMonHappiness]
	cp $dc
	jp c, $63f9
	call Function42461
	jp z, $63f9
	ld a, [hli]
	cp $1
	jr z, .asm_422fd
	cp $2
	jr z, .asm_422a4
	ld a, [TimeOfDay]
	cp $2
	jp nz, $63fa
	jr .asm_422fd

.asm_422a4
	ld a, [TimeOfDay]
	cp $2
	jp z, $63fa
	jr .asm_422fd

.asm_422ae
	ld a, [InLinkBattle]
	and a
	jp z, $63f9
	call Function42461
	jp z, $63f9
	ld a, [hli]
	ld b, a
	inc a
	jr z, .asm_422fd
	ld a, [InLinkBattle]
	cp $1
	jp z, $63fa
	ld a, [TempMonItem]
	cp b
	jp nz, $63fa
	xor a
	ld [TempMonItem], a
	jr .asm_422fd

	ld a, [hli]
	ld b, a
	ld a, [CurItem]
	cp b
	jp nz, $63fa
	ld a, [$d1e9]
	and a
	jp z, $63fa
	ld a, [InLinkBattle]
	and a
	jp nz, $63fa
	jr .asm_422fd

	ld a, [hli]
	ld b, a
	ld a, [TempMonLevel]
	cp b
	jp c, $63fa
	call Function42461
	jp z, $63fa

.asm_422fd
	ld a, [TempMonLevel]
	ld [CurPartyLevel], a
	ld a, $1
	ld [$d268], a
	push hl
	ld a, [hl]
	ld [Buffer2], a
	ld a, [CurPartyMon]
	ld hl, PartyMon1Nickname
	call GetNick
	call CopyName1
	ld hl, $6482
	call PrintText
	ld c, $32
	call DelayFrames
	xor a
	ld [hBGMapMode], a
	ld hl, TileMap
	ld bc, $0c14
	call ClearBox
	ld a, $1
	ld [hBGMapMode], a
	call ClearSprites
	ld a, $13
	ld hl, $65e1
	rst FarCall
	push af
	call ClearSprites
	pop af
	jp c, Function42454
	ld hl, $6473
	call PrintText
	pop hl
	ld a, [hl]
	ld [CurSpecies], a
	ld [TempMonSpecies], a
	ld [Buffer2], a
	ld [$d265], a
	call GetPokemonName
	push hl
	ld hl, $6478
	call PrintTextBoxText
	ld a, $41
	ld hl, $6094
	rst FarCall
	ld de, MUSIC_NONE
	call StartMusic
	ld de, SFX_CAUGHT_MON
	call StartSFX
	call WaitSFX
	ld c, $28
	call DelayFrames
	call ClearTileMap
	call Function42414
	call GetBaseData
	ld hl, $d118
	ld de, TempMonMaxHP
	ld b, $1
	ld a, $c
	call Predef
	ld a, [CurPartyMon]
	ld hl, PartyMon1Species
	ld bc, $0030
	call AddNTimes
	ld e, l
	ld d, h
	ld bc, $0024
	add hl, bc
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, $d133
	ld a, [hld]
	sub c
	ld c, a
	ld a, [hl]
	sbc b
	ld b, a
	ld hl, $d131
	ld a, [hl]
	add c
	ld [hld], a
	ld a, [hl]
	adc b
	ld [hl], a
	ld hl, TempMonSpecies
	ld bc, $0030
	call CopyBytes
	ld a, [CurSpecies]
	ld [$d265], a
	xor a
	ld [MonType], a
	call Function42487
	ld a, [$d265]
	dec a
	call SetSeenAndCaughtMon
	ld a, [$d265]
	cp $c9
	jr nz, .asm_423ec
	ld hl, TempMonDVs
	ld a, $2d
	call Predef
	ld hl, $7a18
	ld a, $3e
	rst FarCall

.asm_423ec
	pop de
	pop hl
	ld a, [TempMonSpecies]
	ld [hl], a
	push hl
	ld l, e
	ld h, d
	jp $61f5
; 423f8

Function423f8: ; 423f8
	inc hl
	inc hl
	inc hl
	jp $6230
; 423fe

INCBIN "baserom.gbc", $423fe, $423ff - $423fe


Function423ff: ; 423ff
	pop de
	pop bc
	pop hl
	ld a, [InLinkBattle]
	and a
	ret nz
	ld a, [IsInBattle]
	and a
	ret nz
	ld a, [$d268]
	and a
	call nz, Function3d47
	ret
; 42414

Function42414: ; 42414
	ld a, [CurSpecies]
	push af
	ld a, [BaseDexNo]
	ld [$d265], a
	call GetPokemonName
	pop af
	ld [CurSpecies], a
	ld hl, StringBuffer1
	ld de, StringBuffer2
.asm_4242b
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	ret nz
	cp $50
	jr nz, .asm_4242b
	ld a, [CurPartyMon]
	ld bc, $000b
	ld hl, PartyMon1Nickname
	call AddNTimes
	push hl
	ld a, [CurSpecies]
	ld [$d265], a
	call GetPokemonName
	ld hl, StringBuffer1
	pop de
	ld bc, $000b
	jp CopyBytes
; 42454

Function42454: ; 42454
	ld hl, $647d
	call PrintText
	call ClearTileMap
	pop hl
	jp $61f5
; 42461

Function42461: ; 42461
	push hl
	ld a, [CurPartyMon]
	ld hl, PartyMon1Item
	ld bc, $0030
	call AddNTimes
	ld a, [hl]
	cp $70
	pop hl
	ret
; 42473

INCBIN "baserom.gbc", $42473, $42487 - $42473


Function42487: ; 42487
	ld a, [$d265]
	ld [CurPartySpecies], a
	dec a
	ld b, $0
	ld c, a
	ld hl, EvosAttacksPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.asm_42499
	ld a, [hli]
	and a
	jr nz, .asm_42499
.asm_4249d
	ld a, [hli]
	and a
	jr z, .asm_424da
	ld b, a
	ld a, [CurPartyLevel]
	cp b
	ld a, [hli]
	jr nz, .asm_4249d
	push hl
	ld d, a
	ld hl, PartyMon1Move1
	ld a, [CurPartyMon]
	ld bc, $0030
	call AddNTimes
	ld b, $4
.asm_424b9
	ld a, [hli]
	cp d
	jr z, .asm_424c2
	dec b
	jr nz, .asm_424b9
	jr .asm_424c5

.asm_424c2
	pop hl
	jr .asm_4249d

.asm_424c5
	ld a, d
	ld [$d262], a
	ld [$d265], a
	call GetMoveName
	call CopyName1
	ld a, $0
	call Predef
	pop hl
	jr .asm_4249d

.asm_424da
	ld a, [CurPartySpecies]
	ld [$d265], a
	ret
; 424e1


FillMoves: ; 424e1
; Fill in moves at de for CurPartySpecies at CurPartyLevle

	push hl
	push de
	push bc
	ld hl, EvosAttacksPointers
	ld b, 0
	ld a, [CurPartySpecies]
	dec a
	add a
	rl b
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.GoToAttacks
	ld a, [hli]
	and a
	jr nz, .GoToAttacks
	jr .GetLevel

.NextMove
	pop de
.GetMove
	inc hl
.GetLevel
	ld a, [hli]
	and a
	jp z, .done
	ld b, a
	ld a, [CurPartyLevel]
	cp b
	jp c, .done
	ld a, [Buffer1]
	and a
	jr z, .CheckMove
	ld a, [DefaultFlypoint]
	cp b
	jr nc, .GetMove

.CheckMove
	push de
	ld c, NUM_MOVES
.CheckRepeat
	ld a, [de]
	inc de
	cp [hl]
	jr z, .NextMove
	dec c
	jr nz, .CheckRepeat
	pop de
	push de
	ld c, NUM_MOVES
.CheckSlot
	ld a, [de]
	and a
	jr z, .LearnMove
	inc de
	dec c
	jr nz, .CheckSlot
	pop de
	push de
	push hl
	ld h, d
	ld l, e
	call ShiftMoves
	ld a, [Buffer1]
	and a
	jr z, .ShiftedMove
	push de
	ld bc, PartyMon1PP - PartyMon1Move4
	add hl, bc
	ld d, h
	ld e, l
	call ShiftMoves
	pop de

.ShiftedMove
	pop hl

.LearnMove
	ld a, [hl]
	ld [de], a
	ld a, [Buffer1]
	and a
	jr z, .NextMove
	push hl
	ld a, [hl]
	ld hl, PartyMon1PP - PartyMon1Moves
	add hl, de
	push hl
	dec a
	ld hl, Moves + MOVE_PP
	ld bc, Move2 - Move1
	call AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	pop hl
	ld [hl], a
	pop hl
	jr .NextMove

.done
	pop bc
	pop de
	pop hl
	ret
; 4256e

ShiftMoves: ; 4256e
	ld c, $3
.asm_42570
	inc de
	ld a, [de]
	ld [hli], a
	dec c
	jr nz, .asm_42570
	ret
; 42577


Function42577: ; 42577
	push de
	ld d, $0
	ld a, $3
	call Predef
	pop de
	ret
; 42581

GetPreEvolution: ; 42581
; Find the first mon to evolve into CurPartySpecies.

; Return carry and the new species in CurPartySpecies
; if a pre-evolution is found.

	ld c, BULBASAUR - 1
.asm_42583
	ld hl, EvosAttacksPointers
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.asm_4258d
	ld a, [hli]
	and a
	jr z, .asm_425a2
	cp EVOLVE_STAT
	jr nz, .asm_42596
	inc hl

.asm_42596
	inc hl
	ld a, [CurPartySpecies]
	cp [hl]
	jr z, .asm_425aa
	inc hl
	ld a, [hl]
	and a
	jr nz, .asm_4258d

.asm_425a2
	inc c
	ld a, c
	cp NUM_POKEMON
	jr c, .asm_42583
	and a
	ret

.asm_425aa
	inc c
	ld a, c
	ld [CurPartySpecies], a
	scf
	ret
; 425b1


EvosAttacksPointers: ; 0x425b1
INCLUDE "stats/evos_attacks_pointers.asm"

INCLUDE "stats/evos_attacks.asm"


SECTION "bank11",ROMX,BANK[$11]

FruitTreeScript: ; 44000
	3callasm BANK(GetCurTreeFruit), GetCurTreeFruit
	loadfont
	copybytetovar CurFruit
	itemtotext $0, $0
	2writetext FruitBearingTreeText
	keeptextopen
	3callasm BANK(TryResetFruitTrees), TryResetFruitTrees
	3callasm BANK(CheckFruitTree), CheckFruitTree
	iffalse .fruit
	2writetext NothingHereText
	closetext
	2jump .end

.fruit
	2writetext HeyItsFruitText
	copybytetovar CurFruit
	giveitem $ff, 1
	iffalse .packisfull
	keeptextopen
	2writetext ObtainedFruitText
	3callasm BANK(PickedFruitTree), PickedFruitTree
	specialsound
	itemnotify
	2jump .end

.packisfull
	keeptextopen
	2writetext FruitPackIsFullText
	closetext

.end
	loadmovesprites
	end
; 44041

GetCurTreeFruit: ; 44041
	ld a, [CurFruitTree]
	dec a
	call GetFruitTreeItem
	ld [CurFruit], a
	ret
; 4404c

TryResetFruitTrees: ; 4404c
	ld hl, $dc1e
	bit 4, [hl]
	ret nz
	jp ResetFruitTrees
; 44055

CheckFruitTree: ; 44055
	ld b, 2
	call GetFruitTreeFlag
	ld a, c
	ld [ScriptVar], a
	ret
; 4405f

PickedFruitTree: ; 4405f
	ld a, $41
	ld hl, $609b
	rst FarCall ; empty function

	ld b, 1
	jp GetFruitTreeFlag
; 4406a

ResetFruitTrees: ; 4406a
	xor a
	ld hl, FruitTreeFlags
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $dc1e
	set 4, [hl]
	ret
; 44078

GetFruitTreeFlag: ; 44078
	push hl
	push de
	ld a, [CurFruitTree]
	dec a
	ld e, a
	ld d, 0
	ld hl, FruitTreeFlags
	call FlagAction
	pop de
	pop hl
	ret
; 4408a

GetFruitTreeItem: ; 4408a
	push hl
	push de
	ld e, a
	ld d, 0
	ld hl, FruitTreeItems
	add hl, de
	ld a, [hl]
	pop de
	pop hl
	ret
; 44097

FruitTreeItems: ; 44097
	db BERRY
	db BERRY
	db BERRY
	db BERRY
	db PSNCUREBERRY
	db PSNCUREBERRY
	db BITTER_BERRY
	db BITTER_BERRY
	db PRZCUREBERRY
	db PRZCUREBERRY
	db MYSTERYBERRY
	db MYSTERYBERRY
	db ICE_BERRY
	db ICE_BERRY
	db MINT_BERRY
	db BURNT_BERRY
	db RED_APRICORN
	db BLU_APRICORN
	db BLK_APRICORN
	db WHT_APRICORN
	db PNK_APRICORN
	db GRN_APRICORN
	db YLW_APRICORN
	db BERRY
	db PSNCUREBERRY
	db BITTER_BERRY
	db PRZCUREBERRY
	db ICE_BERRY
	db MINT_BERRY
	db BURNT_BERRY
; 440b5

FruitBearingTreeText: ; 440b5
	text_jump _FruitBearingTreeText, BANK(_FruitBearingTreeText)
	db "@"
; 440ba

HeyItsFruitText: ; 440ba
	text_jump _HeyItsFruitText, BANK(_HeyItsFruitText)
	db "@"
; 440bf

ObtainedFruitText: ; 440bf
	text_jump _ObtainedFruitText, BANK(_ObtainedFruitText)
	db "@"
; 440c4

FruitPackIsFullText: ; 440c4
	text_jump _FruitPackIsFullText, BANK(_FruitPackIsFullText)
	db "@"
; 440c9

NothingHereText: ; 440c9
	text_jump _NothingHereText, BANK(_NothingHereText)
	db "@"
; 440ce



AIChooseMove: ; 440ce
; Score each move in EnemyMonMoves starting from Buffer1. Lower is better.
; Pick the move with the lowest score.

; Wildmons attack at random.
	ld a, [IsInBattle]
	dec a
	ret z

	ld a, [InLinkBattle]
	and a
	ret nz

; No use picking a move if there's no choice.
	ld a, $f
	ld hl, $68d1
	rst FarCall ; CheckLockedEnemyMove
	ret nz


; The default score is 20. Unusable moves are given a score of 80.
	ld a, 20
	ld hl, Buffer1
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a

; Don't pick disabled moves.
	ld a, [EnemyDisabledMove]
	and a
	jr z, .CheckPP

	ld hl, EnemyMonMove1
	ld c, 0
.CheckDisabledMove
	cp [hl]
	jr z, .ScoreDisabledMove
	inc c
	inc hl
	jr .CheckDisabledMove
.ScoreDisabledMove
	ld hl, Buffer1
	ld b, 0
	add hl, bc
	ld [hl], 80

; Don't pick moves with 0 PP.
.CheckPP
	ld hl, Buffer1 - 1
	ld de, EnemyMonPP
	ld b, 0
.CheckMovePP
	inc b
	ld a, b
	cp EnemyMonMovesEnd - EnemyMonMoves + 1
	jr z, .ApplyLayers
	inc hl
	ld a, [de]
	inc de
	and $3f
	jr nz, .CheckMovePP
	ld [hl], 80
	jr .CheckMovePP


; Apply AI scoring layers depending on the trainer class.
.ApplyLayers
	ld hl, $559f ; TrainerAI + 3 ; e:559c-5771

	ld a, [$cfc0]
	bit 0, a
	jr nz, .asm_4412f

	ld a, [TrainerClass]
	dec a
	ld bc, 7 ; Trainer2AI - Trainer1AI
	call AddNTimes

.asm_4412f
	ld bc, (CHECK_FLAG << 8) | 0
	push bc
	push hl

.CheckLayer
	pop hl
	pop bc

	ld a, c
	cp 16 ; up to 16 scoring layers
	jr z, .asm_4415e

	push bc
	ld d, $e ; BANK(TrainerAI)
	ld a, PREDEF_FLAG
	call Predef
	ld d, c
	pop bc

	inc c
	push bc
	push hl

	ld a, d
	and a
	jr z, .CheckLayer

	ld hl, AIScoringPointers
	dec c
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, BANK(AIScoring)
	call FarCall_hl

	jr .CheckLayer

.asm_4415e
	ld hl, Buffer1
	ld de, EnemyMonMoves
	ld c, EnemyMonMovesEnd - EnemyMonMoves
.asm_44166
	ld a, [de]
	inc de
	and a
	jr z, .asm_4415e

	dec [hl]
	jr z, .asm_44174

	inc hl
	dec c
	jr z, .asm_4415e

	jr .asm_44166

.asm_44174
	ld a, c
.asm_44175
	inc [hl]
	dec hl
	inc a
	cp EnemyMonMovesEnd - EnemyMonMoves + 1
	jr nz, .asm_44175

	ld hl, Buffer1
	ld de, EnemyMonMoves
	ld c, EnemyMonMovesEnd - EnemyMonMoves
.asm_44184
	ld a, [de]
	and a
	jr nz, .asm_44189
	ld [hl], a
.asm_44189
	ld a, [hl]
	dec a
	jr z, .asm_44191
	xor a
	ld [hli], a
	jr .asm_44193
.asm_44191
	ld a, [de]
	ld [hli], a
.asm_44193
	inc de
	dec c
	jr nz, .asm_44184

.asm_44197
	ld hl, Buffer1
	call Random
	and 3
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_44197

	ld [CurEnemyMove], a
	ld a, c
	ld [CurEnemyMoveNum], a
	ret
; 441af


AIScoringPointers: ; 441af
	dw AIScoring_RedStatus
	dw AIScoring_RedStatMods
	dw AIScoring_RedSuperEffective
	dw AIScoring_Offensive
	dw AIScoring_Smart
	dw AIScoring_Opportunist
	dw AIScoring_Aggressive
	dw AIScoring_Cautious
	dw AIScoring_StatusImmunity
	dw AIScoring_Risky
	dw AIScoring_None
	dw AIScoring_None
	dw AIScoring_None
	dw AIScoring_None
	dw AIScoring_None
	dw AIScoring_None
; 441cf


Function441cf: ; 441cf
	ld hl, $41fc
	ld b, $19
.asm_441d4
	ld a, [hli]
	cp $fe
	jr nz, .asm_441dd
	ld hl, $41fc
	ld a, [hli]

.asm_441dd
	ld [$c7db], a
	ld a, [hli]
	ld c, a
	push bc
	push hl
	call Function44207
	pop hl
	pop bc
	call DelayFrames
	dec b
	jr nz, .asm_441d4
	xor a
	ld [$c7db], a
	call Function44207
	ld c, $20
	call DelayFrames
	ret
; 441fc

INCBIN "baserom.gbc", $441fc, $44207 - $441fc


Function44207: ; 44207
	ld a, [$c7db]
	ld hl, $4228
	ld de, Sprites
.asm_44210
	ld a, [hli]
	cp $ff
	ret z
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [$c7db]
	ld b, a
	add a
	add b
	add [hl]
	inc hl
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	jr .asm_44210
; 44228

INCBIN "baserom.gbc", $44228, $44378 - $44228


PokedexDataPointerTable: ; 0x44378
INCLUDE "stats/pokedex/entry_pointers.asm"


Function4456e: ; 4456e
	ld a, $1
	call GetPartyParamLocation
	ld d, [hl]
	ld a, $2e
	ld hl, $5e76
	rst FarCall
	jr nc, .asm_445be
	call Function44648
	cp $a
	jr nc, .asm_445be
	ld bc, $002f
	ld hl, $a835
	call AddNTimes
	ld d, h
	ld e, l
	ld a, [CurPartyMon]
	ld bc, $002f
	ld hl, $a600
	call AddNTimes
	push hl
	ld a, $0
	call GetSRAMBank
	ld bc, $002f
	call CopyBytes
	pop hl
	xor a
	ld bc, $002f
	call ByteFill
	ld a, $1
	call GetPartyParamLocation
	ld [hl], $0
	ld hl, $a834
	inc [hl]
	call CloseSRAM
	xor a
	ret

.asm_445be
	scf
	ret
; 445c0

INCBIN "baserom.gbc", $445c0, $44648 - $445c0


Function44648: ; 44648
	ld a, $0
	call GetSRAMBank
	ld a, [$a834]
	ld c, a
	jp CloseSRAM
; 44654

Function44654: ; 44654
	push bc
	push de
	ld a, $14
	ld hl, $4000
	rst FarCall
	ld a, $2
	jr c, .asm_446c6
	ld a, [CurPartyMon]
	ld hl, PartyMon1Item
	ld bc, $0030
	call AddNTimes
	ld d, [hl]
	ld a, $2e
	ld hl, $5e76
	rst FarCall
	ld a, $3
	jr nc, .asm_446c6
	ld a, $0
	call GetSRAMBank
	ld a, [CurPartyMon]
	ld hl, $a600
	ld bc, $002f
	call AddNTimes
	ld d, h
	ld e, l
	pop hl
	pop bc
	ld a, $20
	ld [$d265], a
.asm_44691
	ld a, [de]
	ld c, a
	ld a, b
	call GetFarByte
	cp $50
	jr z, .asm_446ab
	cp c
	ld a, $0
	jr nz, .asm_446c1
	inc hl
	inc de
	ld a, [$d265]
	dec a
	ld [$d265], a
	jr nz, .asm_44691

.asm_446ab
	ld a, $3
	ld hl, $6538
	rst FarCall
	ld a, $4
	jr c, .asm_446c1
	xor a
	ld [$d10b], a
	ld a, $3
	ld hl, $6039
	rst FarCall
	ld a, $1

.asm_446c1
	call CloseSRAM
	jr .asm_446c8

.asm_446c6
	pop de
	pop bc

.asm_446c8
	ld [ScriptVar], a
	ret
; 446cc

Function446cc: ; 446cc
	ld a, [PartyCount]
	dec a
	push af
	push bc
	ld hl, PartyMon1Item
	ld bc, $0030
	call AddNTimes
	pop bc
	ld [hl], b
	pop af
	push bc
	push af
	ld hl, $a600
	ld bc, $002f
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, DefaultFlypoint
	ld bc, $0021
	ld a, $0
	call GetSRAMBank
	call CopyBytes
	pop af
	push af
	ld hl, PartyMon1OT
	ld bc, $000b
	call AddNTimes
	ld bc, $000a
	call CopyBytes
	pop af
	ld hl, PartyMon1ID
	ld bc, $0030
	call AddNTimes
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld a, [CurPartySpecies]
	ld [de], a
	inc de
	pop bc
	ld a, b
	ld [de], a
	jp CloseSRAM
; 44725

Function44725: ; 44725
	ld a, $0
	call GetSRAMBank
	ld hl, $a600
	ld de, $a71a
	ld bc, $011a
	call CopyBytes
	ld hl, $a834
	ld de, $aa0b
	ld bc, $01d7
	call CopyBytes
	jp CloseSRAM
; 44745

INCBIN "baserom.gbc", $44745, $447a0 - $44745

_KrisMailBoxMenu: ; 0x447a0
	call InitMail
	jr z, .nomail
	call Function1d6e
	call Function44806
	jp Function1c17

.nomail
	ld hl, .EmptyMailboxText
	jp Function1d67
; 0x447b4

.EmptyMailboxText ; 0x447b4
	TX_FAR _EmptyMailboxText
	db "@"

InitMail: ; 0x447b9
; initialize $d0f2 and beyond with incrementing values, one per mail
; set z if no mail
	ld a, $0
	call GetSRAMBank
	ld a, [$a834]
	call CloseSRAM
	ld hl, $d0f2
	ld [hli], a
	and a

	jr z, .done ; if no mail, we're done

	; load values in memory with incrementing values starting at $d0f2
	ld b, a
	ld a, $1
.loop
	ld [hli], a
	inc a
	dec b
	jr nz, .loop
.done
	ld [hl], $ff ; terminate

	ld a, [$d0f2]
	and a
	ret
; 0x447da

Function447da: ; 0x447da
	dec a
	ld hl, $a856
	ld bc, $002f
	call AddNTimes
	ld a, $0
	call GetSRAMBank
	ld de, StringBuffer2
	push de
	ld bc, $a
	call CopyBytes
	ld a, $50
	ld [de], a
	call CloseSRAM
	pop de
	ret
; 0x447fb

Function447fb: ; 0x447fb
	push de
	ld a, [MenuSelection]
	call Function447da
	pop hl
	jp PlaceString
; 0x44806

Function44806: ; 0x44806
	xor a
	ld [CurMart], a
	ld a, $1
	ld [$d0f1], a
.asm_4480f
	call InitMail
	ld hl, MenuData4494c
	call Function1d3c
	xor a
	ld [hBGMapMode], a
	call Function352f
	call Function1ad2
	ld a, [$d0f1]
	ld [$cf88], a
	ld a, [CurMart]
	ld [$d0e4], a
	call Function350c
	ld a, [$d0e4]
	ld [CurMart], a
	ld a, [$cfa9]
	ld [$d0f1], a
	ld a, [$cf73]
	cp $2
	jr z, .asm_44848
	call Function4484a
	jr .asm_4480f

.asm_44848
	xor a
	ret
; 0x4484a

Function4484a: ; 0x4484a
	ld hl, MenuData44964
	call LoadMenuDataHeader
	call Function1d81
	call Function1c07
	jr c, .asm_44860
	ld a, [$cfa9]
	dec a
	ld hl, $4861
	rst JumpTable

.asm_44860
	ret
; 0x44861

.JumpTable
	dw .ReadMail
	dw .PutInPack
	dw .AttachMail
	dw .Cancel

.ReadMail ; 0x44869
	call FadeToMenu
	ld a, [MenuSelection]
	dec a
	ld b, a
	call $45f4
	jp Function2b3c
; 0x44877

.PutInPack ; 0x44877
	ld hl, .MessageLostText
	call Function1d4f
	call Function1dcf
	call Function1c07
	ret c
	ld a, [MenuSelection]
	dec a
	call .Function448bb
	ld a, $1
	ld [$d10c], a
	ld hl, NumItems
	call Function2f66
	jr c, .asm_4489e
	ld hl, .PackFullText
	jp Function1d67

.asm_4489e
	ld a, [MenuSelection]
	dec a
	ld b, a
	call $45c0
	ld hl, .PutAwayText
	jp Function1d67
; 0x448ac

.PutAwayText ; 0x448ac
	TX_FAR ClearedMailPutAwayText
	db "@"

.PackFullText ; 0x448b1
	TX_FAR MailPackFullText
	db "@"

.MessageLostText ; 0x448b6
	TX_FAR MailMessageLostText
	db "@"

.Function448bb: ; 0x448bb
	push af
	ld a, $0
	call GetSRAMBank
	pop af
	ld hl, $a863
	ld bc, $002f
	call AddNTimes
	ld a, [hl]
	ld [CurItem], a
	jp CloseSRAM
; 0x448d2

.AttachMail ; 0x448d2
	call FadeToMenu
	xor a
	ld [PartyMenuActionText], a
	call WhiteBGMap
.asm_448dc
	callba Function5004f
	callba Function50405
	callba Function503e0
	callba WritePartyMenuTilemap
	callba PrintPartyMenuText
	call WaitBGMap
	call Function32f9
	call DelayFrame
	callba PartyMenuSelect
	jr c, .asm_44939
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_44923
	ld a, PartyMon1Item - PartyMon1
	call GetPartyParamLocation
	ld a, [hl]
	and a
	jr z, .asm_4492b
	ld hl, .HoldingMailText
	call PrintText
	jr .asm_448dc

.asm_44923
	ld hl, .EggText
	call PrintText
	jr .asm_448dc

.asm_4492b
	ld a, [MenuSelection]
	dec a
	ld b, a
	call $4607
	ld hl, .MailMovedText
	call PrintText

.asm_44939
	jp Function2b3c
; 0x4493c

.HoldingMailText ; 0x4493c
	TX_FAR MailAlreadyHoldingItemText
	db "@"

.EggText ; 0x44941
	TX_FAR MailEggText
	db "@"

.MailMovedText ; 0x44946
	TX_FAR MailMovedFromBoxText
	db "@"

.Cancel
	ret

MenuData4494c: ; 0x4494c
	db %01000000 ; flags
	db 1, 8 ; start coords
	db $a, $12 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2
	db %00010000 ; flags
	db 4, 0 ; rows/columns?
	db 1 ; horizontal spacing?
	dbw 0,$d0f2 ; text pointer
	dbw BANK(Function447fb), Function447fb
	dbw 0,0
	dbw 0,0

MenuData44964: ; 0x44964
	db %01000000 ; flags
	db 0, 0 ; start coords
	db 9, $d ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2
	db %10000000 ; flags
	db 4 ; items
	db "READ MAIL@"
	db "PUT IN PACK@"
	db "ATTACH MAIL@"
	db "CANCEL@"

SECTION "bank12",ROMX,BANK[$12]

Function48000: ; 48000
	ld a, $1
	ld [$d474], a
	xor a
	ld [$d473], a
	ld [PlayerGender], a
	ld [$d475], a
	ld [$d476], a
	ld [$d477], a
	ld [$d478], a
	ld [DefaultFlypoint], a
	ld [$d003], a
	ld a, [$d479]
	res 0, a
	ld [$d479], a
	ld a, [$d479]
	res 1, a
	ld [$d479], a
	ret
; 4802f

INCBIN "baserom.gbc", $4802f, $48c63 - $4802f

Function48c63: ; 48c63
	ld a, $50
	ld [de], a
	ld a, c
	cp $30
	jr nc, .asm_48c8c
	and a
	jr z, .asm_48c8c
	dec c
	push de
	ld h, d
	ld l, e
	ld a, $50
	ld b, $7
.asm_48c76
	ld [hli], a
	dec b
	jr nz, .asm_48c76
	ld hl, $455b
	ld a, c
	call GetNthString
.asm_48c81
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	cp $50
	jr nz, .asm_48c81
	and a
	pop de
	ret

.asm_48c8c
	scf
	ret
; 48c8e

INCBIN "baserom.gbc", $48c8e, $48e81 - $48c8e


Function48e81: ; 48e81
	ld hl, $4e93
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, $9500
	ld bc, $120f
	call Request2bpp
	ret
; 48e93

INCBIN "baserom.gbc", $48e93, $48e9b - $48e93

PackFGFX:
INCBIN "gfx/misc/pack_f.2bpp"

Function4925b: ; 4925b
	call FadeToMenu
	call WhiteBGMap
	call Functionfdb
	call DelayFrame
	ld b, $14
	call GetSGBLayout
	xor a
	ld [$d142], a
	call Function492a5
	ld [$d265], a
	ld [$d262], a
	call GetMoveName
	call CopyName1
	ld a, $b
	ld hl, $47fb
	rst FarCall
	jr c, .asm_4929c
	jr .asm_49291

.asm_49289
	ld a, $b
	ld hl, $480a
	rst FarCall
	jr c, .asm_4929c

.asm_49291
	call Function492b9
	jr nc, .asm_49289
	xor a
	ld [ScriptVar], a
	jr .asm_492a1

.asm_4929c
	ld a, $ff
	ld [ScriptVar], a

.asm_492a1
	call Function2b3c
	ret
; 492a5

Function492a5: ; 492a5
	ld a, [ScriptVar]
	cp $1
	jr z, .asm_492b3
	cp $2
	jr z, .asm_492b6
	ld a, $3a
	ret

.asm_492b3
	ld a, $35
	ret

.asm_492b6
	ld a, $55
	ret
; 492b9

Function492b9: ; 492b9
	ld hl, $530a
	call LoadMenuDataHeader
	ld a, $e
	call Predef
	push bc
	ld a, [CurPartyMon]
	ld hl, PartyMon1Nickname
	call GetNick
	pop bc
	ld a, c
	and a
	jr nz, .asm_492e5
	push de
	ld de, SFX_WRONG
	call StartSFX
	pop de
	ld a, $b
	ld hl, $48ce
	call Function31b0
	jr .asm_49300

.asm_492e5
	ld hl, $79ea
	ld a, $3
	rst FarCall
	jr c, .asm_49300
	ld a, $0
	call Predef
	ld a, b
	and a
	jr z, .asm_49300
	ld c, $5
	callab ChangeHappiness
	jr .asm_49305

.asm_49300
	call Function1c07
	and a
	ret

.asm_49305
	call Function1c07
	scf
	ret
; 4930a

INCBIN "baserom.gbc", $4930a, $49409 - $4930a


Function49409: ; 49409
	ld hl, $5418
	ld de, $d038
	ld bc, $0008
	ld a, $5
	call Function306b
	ret
; 49418

INCBIN "baserom.gbc", $49418, $49962 - $49418

SpecialCelebiGFX:
INCBIN "gfx/special/celebi/leaf.2bpp"
INCBIN "gfx/special/celebi/1.2bpp"
INCBIN "gfx/special/celebi/2.2bpp"
INCBIN "gfx/special/celebi/3.2bpp"
INCBIN "gfx/special/celebi/4.2bpp"

INCBIN "baserom.gbc", $49aa2, $49cdc - $49aa2

MainMenu: ; 49cdc
	xor a
	ld [$c2d7], a
	call Function49ed0
	ld b, $8
	call GetSGBLayout
	call Function32f9
	ld hl, GameTimerPause
	res 0, [hl]
	call Function49da4
	ld [$cf76], a
	call Function49e09
	ld hl, MenuDataHeader_0x49d14
	call LoadMenuDataHeader
	call Function49de4
	call Function1c17
	jr c, .quit
	call ClearTileMap
	ld a, [MenuSelection]
	ld hl, Label49d60
	rst JumpTable
	jr MainMenu

.quit
	ret
; 49d14

MenuDataHeader_0x49d14: ; 49d14
	db $40 ; flags
	db 00, 00 ; start coords
	db 07, 16 ; end coords
	dw MenuData2_0x49d1c
	db 1 ; default option
; 49d1c

MenuData2_0x49d1c: ; 49d1c
	db $80 ; flags
	db 0 ; items
	dw MainMenuItems
	dw Function1f79
	dw MainMenuText
; 49d20

MainMenuText: ; 49d24
	db "CONTINUE@"
	db "NEW GAME@"
	db "OPTION@"
	db "MYSTERY GIFT@"
	db "MOBILE@"
	db "MOBILE STUDIUM@"

Label49d60: ; 0x49d60
	dw MainMenu_Continue
	dw MainMenu_NewGame
	dw MainMenu_Options
	dw MainMenu_MysteryGift
	dw MainMenu_Mobile
	dw MainMenu_MobileStudium
; 0x49d6c

CONTINUE       EQU 0
NEW_GAME       EQU 1
OPTION         EQU 2
MYSTERY_GIFT   EQU 3
MOBILE         EQU 4
MOBILE_STUDIUM EQU 5

MainMenuItems:

NewGameMenu: ; 0x49d6c
	db 2
	db NEW_GAME
	db OPTION
	db $ff

ContinueMenu: ; 0x49d70
	db 3
	db CONTINUE
	db NEW_GAME
	db OPTION
	db $ff

MobileMysteryMenu: ; 0x49d75
	db 5
	db CONTINUE
	db NEW_GAME
	db OPTION
	db MYSTERY_GIFT
	db MOBILE
	db $ff

MobileMenu: ; 0x49d7c
	db 4
	db CONTINUE
	db NEW_GAME
	db OPTION
	db MOBILE
	db $ff

MobileStudiumMenu: ; 0x49d82
	db 5
	db CONTINUE
	db NEW_GAME
	db OPTION
	db MOBILE
	db MOBILE_STUDIUM
	db $ff

MysteryMobileStudiumMenu: ; 0x49d89
	db 6
	db CONTINUE
	db NEW_GAME
	db OPTION
	db MYSTERY_GIFT
	db MOBILE
	db MOBILE_STUDIUM
	db $ff

MysteryMenu: ; 0x49d91
	db 4
	db CONTINUE
	db NEW_GAME
	db OPTION
	db MYSTERY_GIFT
	db $ff

MysteryStudiumMenu: ; 0x49d97
	db 5
	db CONTINUE
	db NEW_GAME
	db OPTION
	db MYSTERY_GIFT
	db MOBILE_STUDIUM
	db $ff

StudiumMenu: ; 0x49d9e
	db 4
	db CONTINUE
	db NEW_GAME
	db OPTION
	db MOBILE_STUDIUM
	db $ff


Function49da4: ; 49da4
	nop
	nop
	nop
	ld a, [$cfcd]
	and a
	jr nz, .asm_49db0
	ld a, $0
	ret

.asm_49db0
	ld a, [hCGB]
	cp $1
	ld a, $1
	ret nz
	ld a, $0
	call GetSRAMBank
	ld a, [$abe5]
	cp $ff
	call CloseSRAM
	jr nz, .asm_49dd6
	ld a, [StatusFlags]
	bit 7, a
	ld a, $1
	jr z, .asm_49dd1
	jr .asm_49dd1

.asm_49dd1
	jr .asm_49dd3

.asm_49dd3
	ld a, $1
	ret

.asm_49dd6
	ld a, [StatusFlags]
	bit 7, a
	jr z, .asm_49ddf
	jr .asm_49ddf

.asm_49ddf
	jr .asm_49de1

.asm_49de1
	ld a, $6
	ret
; 49de4

Function49de4: ; 49de4
	call SetUpMenu
.asm_49de7
	call Function49e09
	ld a, [$cfa5]
	set 5, a
	ld [$cfa5], a
	call Function1f1a
	ld a, [$cf73]
	cp $2
	jr z, .asm_49e07
	cp $1
	jr z, .asm_49e02
	jr .asm_49de7

.asm_49e02
	call PlayClickSFX
	and a
	ret

.asm_49e07
	scf
	ret
; 49e09

Function49e09: ; 49e09
	ld a, [$cfcd]
	and a
	ret z
	xor a
	ld [hBGMapMode], a
	call Function49e27
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	call Function49e3d
	pop af
	ld [Options], a
	ld a, $1
	ld [hBGMapMode], a
	ret
; 49e27


Function49e27: ; 49e27
	call Function6e3
	and $80
	jr nz, .asm_49e39
	ld hl, $c5b8
	ld b, $2
	ld c, $12
	call TextBox
	ret

.asm_49e39
	call SpeechTextBox
	ret
; 49e3d


Function49e3d: ; 49e3d
	ld a, [$cfcd]
	and a
	ret z
	call Function6e3
	and $80
	jp nz, Function49e75
	call UpdateTime
	call GetWeekday
	ld b, a
	decoord 1, 15
	call Function49e91
	decoord 4, 16
	ld a, [hHours]
	ld c, a
	ld a, $24
	ld hl, $4b3e
	rst FarCall
	ld [hl], ":"
	inc hl
	ld de, hMinutes
	ld bc, $8102
	call PrintNum
	ret
; 49e70

; 49e70
	db "min.@"
; 49e75

Function49e75: ; 49e75
	hlcoord 1, 14
	ld de, .TimeNotSet
	call PlaceString
	ret
; 49e7f

.TimeNotSet ; 49e7f
	db "TIME NOT SET@"
; 49e8c

UnknownText_0x49e8c: ; 49e8c
	text_jump UnknownText_0x1c5182, BANK(UnknownText_0x1c5182)
	db "@"
; 49e91

Function49e91: ; 49e91
	push de
	ld hl, .Days
	ld a, b
	call GetNthString
	ld d, h
	ld e, l
	pop hl
	call PlaceString
	ld h, b
	ld l, c
	ld de, .Day
	call PlaceString
	ret
; 49ea8

.Days
	db "SUN@"
	db "MON@"
	db "TUES@"
	db "WEDNES@"
	db "THURS@"
	db "FRI@"
	db "SATUR@"
.Day
	db "DAY@"
; 49ed0

Function49ed0: ; 49ed0
	xor a
	ld [$ffde], a
	call ClearTileMap
	call Functione5f
	call Functione51
	call Function1fbf
	ret
; 49ee0


MainMenu_NewGame: ; 49ee0
	callba NewGame
	ret
; 49ee7

MainMenu_Options: ; 49ee7
	callba OptionsMenu
	ret
; 49eee

MainMenu_Continue: ; 49eee
	callba Continue
	ret
; 49ef5

MainMenu_MysteryGift: ; 49ef5
	callba MysteryGift
	ret
; 49efc

MainMenu_Mobile: ; 49efc
	call WhiteBGMap
	ld a, MUSIC_MOBILE_ADAPTER_MENU
	ld [CurMusic], a
	ld de, MUSIC_MOBILE_ADAPTER_MENU
	call $66c5
	call WhiteBGMap
	call $63a7
	call $6492
	call WhiteBGMap
	call $6071
	ld c, $c
	call DelayFrames
	ld hl, $c4a4
	ld b, $a
	ld c, $a
	call $4cdc
	ld hl, $c4ce
	ld de, MobileString1
	call PlaceString
	ld hl, $c590
	ld b, $4
	ld c, $12
	call TextBox
	xor a
	ld de, String_0x49fe9
	ld hl, $c5b9
	call PlaceString
	call Function3200
	call Function32f9
	call Function1bc9
	ld hl, $cfa9
	ld b, [hl]
	push bc
	jr .asm_49f5d

.asm_49f55
	call Function1bd3
	ld hl, $cfa9
	ld b, [hl]
	push bc

.asm_49f5d
	bit 0, a
	jr nz, .asm_49f67
	bit 1, a
	jr nz, .asm_49f84
	jr .asm_49f97

.asm_49f67
	ld hl, $cfa9
	ld a, [hl]
	cp $1
	jp z, $6098
	cp $2
	jp z, $60b9
	cp $3
	jp z, $60c2
	cp $4
	jp z, $6100
	ld a, $1
	call Function1ff8

.asm_49f84
	pop bc
	call WhiteBGMap
	call ClearTileMap
	ld a, MUSIC_MAIN_MENU
	ld [CurMusic], a
	ld de, MUSIC_MAIN_MENU
	call $66c5
	ret

.asm_49f97
	ld hl, $cfa9
	ld a, [hl]
	dec a
	ld hl, MobileStrings2
	call GetNthString
	ld d, h
	ld e, l
	ld hl, $c5a5
	ld b, $4
	ld c, $12
	call ClearBox
	ld hl, $c5b9
	call PlaceString
	jp .asm_49fb7

.asm_49fb7
	call $6071
	pop bc
	ld hl, $cfa9
	ld [hl], b
	ld b, $a
	ld c, $1
	ld hl, $c4b9
	call ClearBox
	jp .asm_49f55
; 49fcc


MobileString1: ; 49fcc
	db "めいしフ,ルダー", $4e
	db "あいさつ", $4e
	db "プロフィール", $4e
	db "せ", $1e, "い", $4e
	db "もどる@"
; 49fe9


MobileStrings2:

String_0x49fe9: ; 49fe9
	db "めいし", $1f, "つくったり", $4e
	db "ほぞんしておける フ,ルダーです@"
; 4a004

String_0x4a004: ; 4a004
	db "モバイルたいせんや じぶんのめいしで", $4e
	db "つかう あいさつ", $1f, "つくります@"
; 4a026

String_0x4a026: ; 4a026
	db "あなた", $25, "じゅうしょや ねんれいの", $4e
	db "せ", $1e, "い", $1f, "かえられます@"
; 4a042

String_0x4a042: ; 4a042
	db "モバイルセンター", $1d, "せつぞくするとき", $4e
	db "ひつような こと", $1f, "きめます@"
; 4a062

String_0x4a062: ; 4a062
	db "まえ", $25, "がめん ", $1d, "もどります", $4e
	db "@"
; 4a071


INCBIN "baserom.gbc", $4a071, $4a496 - $4a071


MainMenu_MobileStudium: ; 4a496
	ld a, [StartDay]
	ld b, a
	ld a, [StartHour]
	ld c, a
	ld a, [StartMinute]
	ld d, a
	ld a, [StartSecond]
	ld e, a
	push bc
	push de
	callba MobileStudium
	call WhiteBGMap
	pop de
	pop bc
	ld a, b
	ld [StartDay], a
	ld a, c
	ld [StartHour], a
	ld a, d
	ld [StartMinute], a
	ld a, e
	ld [StartSecond], a
	ret
; 4a4c4


INCBIN "baserom.gbc", $4a4c4, $4a6e8 - $4a4c4


SpecialBeastsCheck: ; 0x4a6e8
; Check if the player owns all three legendary beasts.
; They must exist in either party or PC, and have the player's OT and ID.

; outputs:
; ScriptVar is 1 if the Pokémon exist, otherwise 0.

	ld a, RAIKOU
	ld [ScriptVar], a
	call CheckOwnMonAnywhere
	jr nc, .notexist

	ld a, ENTEI
	ld [ScriptVar], a
	call CheckOwnMonAnywhere
	jr nc, .notexist

	ld a, SUICUNE
	ld [ScriptVar], a
	call CheckOwnMonAnywhere
	jr nc, .notexist

	; they exist
	ld a, $1
	ld [ScriptVar], a
	ret

.notexist
	xor a
	ld [ScriptVar], a
	ret

SpecialMonCheck: ; 0x4a711
; Check if a Pokémon exists in PC or party.
; It must exist in either party or PC, and have the player's OT and ID.

; inputs:
; ScriptVar contains species to search for
	call CheckOwnMonAnywhere
	jr c, .exists

	; doesn't exist
	xor a
	ld [ScriptVar], a
	ret

.exists
	ld a, $1
	ld [ScriptVar], a
	ret

CheckOwnMonAnywhere: ; 0x4a721
	ld a, [PartyCount]
	and a
	ret z ; no pokémon in party

	ld d, a
	ld e, $0
	ld hl, PartyMon1Species
	ld bc, PartyMon1OT

; run CheckOwnMon on each Pokémon in the party
.loop
	call CheckOwnMon
	ret c ; found!

	push bc
	ld bc, PartyMon2 - PartyMon1
	add hl, bc
	pop bc
	call UpdateOTPointer
	dec d
	jr nz, .loop ; 0x4a73d $f0

; XXX the below could use some cleanup
; run CheckOwnMon on each Pokémon in the PC
	ld a, $1
	call GetSRAMBank
	ld a, [$ad10]
	and a
	jr z, .asm_4a766 ; 0x4a748 $1c
	ld d, a
	ld hl, $ad26
	ld bc, $afa6
.asm_4a751
	call CheckOwnMon
	jr nc, .asm_4a75a ; 0x4a754 $4
	call CloseSRAM
	ret
.asm_4a75a
	push bc
	ld bc, $0020
	add hl, bc
	pop bc
	call UpdateOTPointer
	dec d
	jr nz, .asm_4a751 ; 0x4a764 $eb
.asm_4a766
	call CloseSRAM
	ld c, $0
.asm_4a76b
	ld a, [$db72]
	and $f
	cp c
	jr z, .asm_4a7af ; 0x4a771 $3c
	ld hl, $6810
	ld b, $0
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	call GetSRAMBank
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	and a
	jr z, .asm_4a7af ; 0x4a784 $29
	push bc
	push hl
	ld de, $0016
	add hl, de
	ld d, h
	ld e, l
	pop hl
	push de
	ld de, $0296
	add hl, de
	ld b, h
	ld c, l
	pop hl
	ld d, a
.asm_4a798
	call CheckOwnMon
	jr nc, .asm_4a7a2 ; 0x4a79b $5
	pop bc
	call CloseSRAM
	ret
.asm_4a7a2
	push bc
	ld bc, $0020
	add hl, bc
	pop bc
	call UpdateOTPointer
	dec d
	jr nz, .asm_4a798 ; 0x4a7ac $ea
	pop bc
.asm_4a7af
	inc c
	ld a, c
	cp $e
	jr c, .asm_4a76b ; 0x4a7b3 $b6
	call CloseSRAM
	and a ; clear carry
	ret

CheckOwnMon: ; 0x4a7ba
; Check if a Pokémon belongs to the player and is of a specific species.

; inputs:
; hl, pointer to PartyMonNSpecies
; bc, pointer to PartyMonNOT
; ScriptVar should contain the species we're looking for

; outputs:
; sets carry if monster matches species, ID, and OT name.

	push bc
	push hl
	push de
	ld d, b
	ld e, c

; check species
	ld a, [ScriptVar] ; species we're looking for
	ld b, [hl] ; species we have
	cp b
	jr nz, .notfound ; species doesn't match

; check ID number
	ld bc, PartyMon1ID - PartyMon1Species
	add hl, bc ; now hl points to ID number
	ld a, [PlayerID]
	cp [hl]
	jr nz, .notfound ; ID doesn't match
	inc hl
	ld a, [PlayerID + 1]
	cp [hl]
	jr nz, .notfound ; ID doesn't match

; check OT
; This only checks five characters, which is fine for the Japanese version,
; but in the English version the player name is 7 characters, so this is wrong.

	ld hl, PlayerName

	ld a, [de]
	cp [hl]
	jr nz, .notfound
	cp "@"
	jr z, .found ; reached end of string
	inc hl
	inc de

	ld a, [de]
	cp [hl]
	jr nz, .notfound
	cp $50
	jr z, .found
	inc hl
	inc de

	ld a, [de]
	cp [hl]
	jr nz, .notfound
	cp $50
	jr z, .found
	inc hl
	inc de

	ld a, [de]
	cp [hl]
	jr nz, .notfound
	cp $50
	jr z, .found
	inc hl
	inc de

	ld a, [de]
	cp [hl]
	jr z, .found

.notfound
	pop de
	pop hl
	pop bc
	and a ; clear carry
	ret
.found
	pop de
	pop hl
	pop bc
	scf
	ret

; 0x4a810
INCBIN "baserom.gbc", $4a810, $4a83a - $4a810

UpdateOTPointer: ; 0x4a83a
	push hl
	ld hl, PartyMon2OT - PartyMon1OT
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	ret
; 0x4a843

INCBIN "baserom.gbc", $4a843, $4ae78 - $4a843


SECTION "bank13",ROMX,BANK[$13]

Function4c000: ; 4c000
	ld hl, TileMap
	ld de, AttrMap
	ld b, $12
.asm_4c008
	push bc
	ld c, $14
.asm_4c00b
	ld a, [hl]
	push hl
	srl a
	jr c, .asm_4c021
	ld hl, TilesetPalettes
	add [hl]
	ld l, a
	ld a, [$d1e7]
	adc $0
	ld h, a
	ld a, [hl]
	and $f
	jr .asm_4c031

.asm_4c021
	ld hl, TilesetPalettes
	add [hl]
	ld l, a
	ld a, [$d1e7]
	adc $0
	ld h, a
	ld a, [hl]
	swap a
	and $f

.asm_4c031
	pop hl
	ld [de], a
	res 7, [hl]
	inc hl
	inc de
	dec c
	jr nz, .asm_4c00b
	pop bc
	dec b
	jr nz, .asm_4c008
	ret
; 4c03f

Function4c03f: ; 4c03f
	ld hl, BGMapBuffer
	ld de, BGMapPalBuffer
.asm_4c045
	ld a, [hl]
	push hl
	srl a
	jr c, .asm_4c05b
	ld hl, TilesetPalettes
	add [hl]
	ld l, a
	ld a, [$d1e7]
	adc $0
	ld h, a
	ld a, [hl]
	and $f
	jr .asm_4c06b

.asm_4c05b
	ld hl, TilesetPalettes
	add [hl]
	ld l, a
	ld a, [$d1e7]
	adc $0
	ld h, a
	ld a, [hl]
	swap a
	and $f

.asm_4c06b
	pop hl
	ld [de], a
	res 7, [hl]
	inc hl
	inc de
	dec c
	jr nz, .asm_4c045
	ret
; 4c075


INCLUDE "tilesets/palette_maps.asm"


INCBIN "baserom.gbc", $4ce05, $4ce1f - $4ce05

TileCollisionTable: ; 4ce1f
; 00 land
; 01 water
; 0f wall
; 11 talkable water
; 1f talkable wall

	db $00, $00, $00, $00, $00, $00, $00, $0f
	db $00, $00, $00, $00, $00, $00, $00, $0f
	db $00, $00, $1f, $00, $00, $1f, $00, $00
	db $00, $00, $1f, $00, $00, $1f, $00, $00
	db $01, $01, $11, $00, $11, $01, $01, $0f
	db $01, $01, $11, $00, $11, $01, $01, $0f
	db $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01

	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $0f, $00, $00, $00, $00, $00
	db $00, $00, $0f, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00

	db $0f, $0f, $0f, $0f, $0f, $00, $00, $00
	db $0f, $0f, $0f, $0f, $0f, $00, $00, $00
	db $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
	db $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00

	db $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $0f
; 4cf1f

Function4cf1f: ; 4cf1f
	ld a, $0
	call Function4cf34
	ld a, $1
	call Function4cf34
	ld a, $2
	call Function4cf34
	ld a, $3
	call Function4cf34
	ret
; 4cf34

Function4cf34: ; 4cf34
	call GetSRAMBank
	ld hl, $a000
	ld bc, $2000
	xor a
	call ByteFill
	call CloseSRAM
	ret
; 4cf45

INCBIN "baserom.gbc", $4cf45, $4cffe - $4cf45


Function4cffe: ; 4cffe
	ld a, $1
	call GetSRAMBank
	ld a, [$a008]
	ld b, a
	ld a, [$ad0f]
	ld c, a
	call CloseSRAM
	ld a, b
	cp $63
	jr nz, .asm_4d01b
	ld a, c
	cp $7f
	jr nz, .asm_4d01b
	ld c, $1
	ret

.asm_4d01b
	ld c, $0
	ret
; 4d01e

INCBIN "baserom.gbc", $4d01e, $4d15b - $4d01e


Function4d15b: ; 4d15b
	ld hl, EnemyMoveAnimation
	ld a, [$d196]
	and a
	jr z, .asm_4d168
	ld bc, $0030
	add hl, bc

.asm_4d168
	ld a, [$d197]
	and a
	jr z, .asm_4d170
	inc hl
	inc hl

.asm_4d170
	ld de, TileMap
	ld b, $12
.asm_4d175
	ld c, $14
.asm_4d177
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_4d177
	ld a, l
	add $4
	ld l, a
	jr nc, .asm_4d184
	inc h

.asm_4d184
	dec b
	jr nz, .asm_4d175
	ret
; 4d188

Function4d188: ; 4d188
	ld a, [hCGB]
	and a
	jp z, WaitBGMap
	ld a, [$c2ce]
	cp $0
	jp z, WaitBGMap
	ld a, [hBGMapMode]
	push af
	xor a
	ld [hBGMapMode], a
	ld a, [$ffde]
	push af
	xor a
	ld [$ffde], a
.asm_4d1a2
	ld a, [rLY]
	cp $8f
	jr c, .asm_4d1a2
	di
	ld a, $1
	ld [rVBK], a
	ld hl, AttrMap
	call Function4d1cb
	ld a, $0
	ld [rVBK], a
	ld hl, TileMap
	call Function4d1cb
.asm_4d1bd
	ld a, [rLY]
	cp $8f
	jr c, .asm_4d1bd
	ei
	pop af
	ld [$ffde], a
	pop af
	ld [hBGMapMode], a
	ret
; 4d1cb

Function4d1cb: ; 4d1cb
	ld [hSPBuffer], sp
	ld sp, hl
	ld a, [$ffd7]
	ld h, a
	ld l, $0
	ld a, $12
	ld [$ffd3], a
	ld b, $2
	ld c, $41
.asm_4d1dc
	pop de
.asm_4d1dd
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d1dd
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d1e6
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d1e6
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d1ef
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d1ef
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d1f8
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d1f8
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d201
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d201
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d20a
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d20a
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d213
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d213
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d21c
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d21c
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d225
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d225
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d22e
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d22e
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	ld de, $000c
	add hl, de
	ld a, [$ffd3]
	dec a
	ld [$ffd3], a
	jr nz, .asm_4d1dc
	ld a, [hSPBuffer]
	ld l, a
	ld a, [$ffda]
	ld h, a
	ld sp, hl
	ret
; 4d249

INCBIN "baserom.gbc", $4d249, $4d35b - $4d249


Function4d35b: ; 4d35b
	ld h, d
	ld l, e
	push bc
	push hl
	call Function4d37e
	pop hl
	pop bc
	ld de, $0939
	add hl, de
	inc b
	inc b
	inc c
	inc c
	ld a, $7
.asm_4d36e
	push bc
	push hl
.asm_4d370
	ld [hli], a
	dec c
	jr nz, .asm_4d370
	pop hl
	ld de, $0014
	add hl, de
	pop bc
	dec b
	jr nz, .asm_4d36e
	ret
; 4d37e

Function4d37e: ; 4d37e
	push hl
	ld a, $76
	ld [hli], a
	inc a
	call Function4d3ab
	inc a
	ld [hl], a
	pop hl
	ld de, $0014
	add hl, de
.asm_4d38d
	push hl
	ld a, $79
	ld [hli], a
	ld a, $7f
	call Function4d3ab
	ld [hl], $7a
	pop hl
	ld de, $0014
	add hl, de
	dec b
	jr nz, .asm_4d38d
	ld a, $7b
	ld [hli], a
	ld a, $7c
	call Function4d3ab
	ld [hl], $7d
	ret
; 4d3ab

Function4d3ab: ; 4d3ab
	ld d, c
.asm_4d3ac
	ld [hli], a
	dec d
	jr nz, .asm_4d3ac
	ret
; 4d3b1

Function4d3b1: ; 4d3b1
	ld a, $2
	ld hl, $4000
	rst FarCall
	ld b, $8
	call GetSGBLayout
	call Functione51
	call Functione5f
	ld de, $0054
	call StartMusic
	ld hl, $5408
	call PrintText
	ld hl, $540d
	call Function1d3c
	call Function1d81
	ret c
	ld a, [$cfa9]
	cp $1
	ret z
	call Function4d41e
	jr c, .asm_4d3f7
	ld a, $0
	call GetSRAMBank
	ld a, $80
	ld [$ac60], a
	call CloseSRAM
	ld hl, $53fe
	call PrintText
	ret

.asm_4d3f7
	ld hl, $5403
	call PrintText
	ret
; 4d3fe

INCBIN "baserom.gbc", $4d3fe, $4d41e - $4d3fe

Function4d41e: ; 4d41e
	call Function4d50f
	push de
	ld hl, StringBuffer2
	ld bc, $0005
	xor a
	call ByteFill
	ld a, $4
	ld [$d08b], a
	ld hl, $5463
	call PrintText
.asm_4d437
	call Function4d468
.asm_4d43a
	call Functiona57
	ld a, [$ffa9]
	ld b, a
	and $1
	jr nz, .asm_4d453
	ld a, b
	and $f0
	jr z, .asm_4d43a
	call Function4d490
	ld c, $3
	call DelayFrames
	jr .asm_4d437

.asm_4d453
	call Function4d4e0
	pop de
	ld a, e
	cp l
	jr nz, .asm_4d461
	ld a, d
	cp h
	jr nz, .asm_4d461
	and a
	ret

.asm_4d461
	scf
	ret
; 4d463

INCBIN "baserom.gbc", $4d463, $4d468 - $4d463

Function4d468: ; 4d468
	ld hl, $c5da
	ld de, StringBuffer2
	ld c, $5
.asm_4d470
	ld a, [de]
	add $f6
	ld [hli], a
	inc de
	dec c
	jr nz, .asm_4d470
	ld hl, $c5ee
	ld bc, $0005
	ld a, $7f
	call ByteFill
	ld hl, $c5ee
	ld a, [$d08b]
	ld e, a
	ld d, $0
	add hl, de
	ld [hl], $61
	ret
; 4d490

Function4d490: ; 4d490
	ld a, b
	and $20
	jr nz, .asm_4d4a5
	ld a, b
	and $10
	jr nz, .asm_4d4af
	ld a, b
	and $40
	jr nz, .asm_4d4ba
	ld a, b
	and $80
	jr nz, .asm_4d4c8
	ret

.asm_4d4a5
	ld a, [$d08b]
	and a
	ret z
	dec a
	ld [$d08b], a
	ret

.asm_4d4af
	ld a, [$d08b]
	cp $4
	ret z
	inc a
	ld [$d08b], a
	ret

.asm_4d4ba
	call Function4d4d5
	ld a, [hl]
	cp $9
	jr z, .asm_4d4c5
	inc a
	ld [hl], a
	ret

.asm_4d4c5
	ld [hl], $0
	ret

.asm_4d4c8
	call Function4d4d5
	ld a, [hl]
	and a
	jr z, .asm_4d4d2
	dec a
	ld [hl], a
	ret

.asm_4d4d2
	ld [hl], $9
	ret
; 4d4d5

Function4d4d5: ; 4d4d5
	ld a, [$d08b]
	ld e, a
	ld d, $0
	ld hl, StringBuffer2
	add hl, de
	ret
; 4d4e0

Function4d4e0: ; 4d4e0
	ld hl, $0000
	ld de, $d08a
	ld bc, $0001
	call $5501
	ld bc, $000a
	call $5501
	ld bc, $0064
	call $5501
	ld bc, $03e8
	call $5501
	ld bc, $2710
	ld a, [de]
	dec de
	push hl
	ld hl, $0000
	call AddNTimes
	ld c, l
	ld b, h
	pop hl
	add hl, bc
	ret
; 4d50f

Function4d50f: ; 4d50f
	ld a, $1
	call GetSRAMBank
	ld de, $0000
	ld hl, $a009
	ld c, $2
	call Function4d533
	ld hl, $a00b
	ld c, $5
	call Function4d53e
	ld hl, $a3dc
	ld c, $3
	call Function4d533
	call CloseSRAM
	ret
; 4d533

Function4d533: ; 4d533
.asm_4d533
	ld a, [hli]
	add e
	ld e, a
	ld a, $0
	adc d
	ld d, a
	dec c
	jr nz, .asm_4d533
	ret
; 4d53e

Function4d53e: ; 4d53e
.asm_4d53e
	ld a, [hli]
	cp $50
	ret z
	add e
	ld e, a
	ld a, $0
	adc d
	ld d, a
	dec c
	jr nz, .asm_4d53e
	ret
; 4d54c

Function4d54c: ; 4d54c
	ld a, $2
	ld hl, $4000
	rst FarCall
	ld b, $8
	call GetSGBLayout
	call Functione51
	call Functione5f
	ld de, $0054
	call StartMusic
	ld hl, $5580
	call PrintText
	ld hl, $5585
	call Function1d3c
	call Function1d81
	ret c
	ld a, [$cfa9]
	cp $1
	ret z
	ld a, $13
	ld hl, $4f1f
	rst FarCall
	ret
; 4d580

INCBIN "baserom.gbc", $4d580, $4d596 - $4d580

Tilesets:
INCLUDE "tilesets/tileset_headers.asm"

INCBIN "baserom.gbc", $4d7c1, $4d860 - $4d7c1

CheckPokerus: ; 4d860
; Return carry if a monster in your party has Pokerus

; Get number of monsters to iterate over
	ld a, [PartyCount]
	and a
	jr z, .NoPokerus
	ld b, a
; Check each monster in the party for Pokerus
	ld hl, PartyMon1PokerusStatus
	ld de, PartyMon2 - PartyMon1
.Check
	ld a, [hl]
	and $0f ; only the bottom nybble is used
	jr nz, .HasPokerus
; Next PartyMon
	add hl, de
	dec b
	jr nz, .Check
.NoPokerus
	and a
	ret
.HasPokerus
	scf
	ret
; 4d87a

INCBIN "baserom.gbc", $4d87a, $4db3b - $4d87a


Function4db3b: ; 4db3b
	ld hl, $5b44
	call PrintText
	jp Function1dcf
; 4db44

INCBIN "baserom.gbc", $4db44, $4db49 - $4db44


Function4db49: ; 4db49
	ld a, [PartyCount]
	dec a
	ld hl, PartyMon1CaughtLevel
	call GetPartyLocation
	ld a, [TimeOfDay]
	inc a
	rrca
	rrca
	ld b, a
	ld a, [CurPartyLevel]
	or b
	ld [hli], a
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	cp $1
	jr nz, .asm_4db78
	ld a, b
	cp $14
	jr nz, .asm_4db78
	ld a, [BackupMapGroup]
	ld b, a
	ld a, [BackupMapNumber]
	ld c, a

.asm_4db78
	call GetWorldMapLocation
	ld b, a
	ld a, [PlayerGender]
	rrca
	or b
	ld [hl], a
	ret
; 4db83

Function4db83: ; 4db83
	ld a, $1
	call GetSRAMBank
	ld hl, $ad43
	call $5b53
	call CloseSRAM
	ret
; 4db92

Function4db92: ; 4db92
	push bc
	ld a, $1
	call GetSRAMBank
	ld hl, $ad43
	pop bc
	call $5baf
	call CloseSRAM
	ret
; 4dba3

Function4dba3: ; 4dba3
	ld a, [PartyCount]
	dec a
	ld hl, PartyMon1CaughtLevel
	push bc
	call GetPartyLocation
	pop bc
	xor a
	ld [hli], a
	ld a, $7e
	rrc b
	or b
	ld [hl], a
	ret
; 4dbb8

INCBIN "baserom.gbc", $4dbb8, $4dc8a - $4dbb8

StatsScreenInit: ; 4dc8a
	ld hl, StatsScreenMain
	jr .gotaddress
	ld hl, $5cf7
	jr .gotaddress
.gotaddress
	ld a, [$ffde]
	push af
	xor a
	ld [$ffde], a ; disable overworld tile animations
	ld a, [$c2c6] ; whether sprite is to be mirrorred
	push af
	ld a, [$cf63]
	ld b, a
	ld a, [$cf64]
	ld c, a
	push bc
	push hl
	call WhiteBGMap
	call ClearTileMap
	call Function1ad2
	ld a, $3e
	ld hl, $753e
	rst FarCall ; this loads graphics
	pop hl
	call _hl_
	call WhiteBGMap
	call ClearTileMap
	pop bc
	; restore old values
	ld a, b
	ld [$cf63], a
	ld a, c
	ld [$cf64], a
	pop af
	ld [$c2c6], a
	pop af
	ld [$ffde], a
	ret
; 0x4dcd2

StatsScreenMain: ; 0x4dcd2
	xor a
	ld [$cf63], a
	ld [$cf64], a
	ld a, [$cf64]
	and $fc
	or $1
	ld [$cf64], a
.loop ; 4dce3
	ld a, [$cf63]
	and $7f
	ld hl, StatsScreenPointerTable
	rst JumpTable
	call $5d3a ; check for keys?
	ld a, [$cf63]
	bit 7, a
	jr z, .loop
	ret
; 0x4dcf7

INCBIN "baserom.gbc", $4dcf7, $4dd2a - $4dcf7

StatsScreenPointerTable: ; 4dd2a
    dw $5d72 ; regular pokémon
    dw EggStatsInit ; egg
    dw $5de6
    dw $5dac
    dw $5dc6
    dw $5de6
    dw $5dd6
    dw $5d6c

; 4dd3a

INCBIN "baserom.gbc", $4dd3a, $4dda1 - $4dd3a

EggStatsInit: ; 4dda1
	call EggStatsScreen
	ld a, [$cf63]
	inc a
	ld [$cf63], a
	ret
; 0x4ddac

INCBIN "baserom.gbc", $4ddac, $4e21e - $4ddac

IDNoString: ; 4e21e
    db $73, "№.@"

OTString: ; 4e222
    db "OT/@"
; 4e226

INCBIN "baserom.gbc", $4e226, $4e33a - $4e226

EggStatsScreen: ; 4e33a
	xor a
	ld [hBGMapMode], a
	ld hl, $cda1
	call SetHPPal
	ld b, $3
	call GetSGBLayout
	call $5f8f
	ld de, EggString
	hlcoord 8, 1 ; $c4bc
	call PlaceString
	ld de, IDNoString
	hlcoord 8, 3 ; $c4e4
	call PlaceString
	ld de, OTString
	hlcoord 8, 5 ; $c50c
	call PlaceString
	ld de, FiveQMarkString
	hlcoord 11, 3 ; $c4e7
	call PlaceString
	ld de, FiveQMarkString
	hlcoord 11, 5 ; $c50f
	call PlaceString
	ld a, [TempMonHappiness] ; egg status
	ld de, EggSoonString
	cp $6
	jr c, .picked
	ld de, EggCloseString
	cp $b
	jr c, .picked
	ld de, EggMoreTimeString
	cp $29
	jr c, .picked
	ld de, EggALotMoreTimeString
.picked
	hlcoord 1, 9 ; $c555
	call PlaceString
	ld hl, $cf64
	set 5, [hl]
	call Function32f9 ; pals
	call DelayFrame
	ld hl, TileMap
	call Function3786
	ld a, $41
	ld hl, $402d
	rst FarCall
	call $6497

	ld a, [TempMonHappiness]
	cp 6
	ret nc
	ld de, SFX_2_BOOPS
	call StartSFX
	ret
; 0x4e3c0

EggString: ; 4e3c0
    db "EGG@"

FiveQMarkString: ; 4e3c4
    db "?????@"

EggSoonString: ; 0x4e3ca
    db "It's making sounds", $4e, "inside. It's going", $4e, "to hatch soon!@"

EggCloseString: ; 0x4e3fd
    db "It moves around", $4e, "inside sometimes.", $4e, "It must be close", $4e, "to hatching.@"

EggMoreTimeString: ; 0x4e43d
    db "Wonder what's", $4e, "inside? It needs", $4e, "more time, though.@"

EggALotMoreTimeString: ; 0x4e46e
    db "This EGG needs a", $4e, "lot more time to", $4e, "hatch.@"

; 0x4e497

INCBIN "baserom.gbc", $4e497, $4e53f - $4e497


Function4e53f: ; 4e53f
	ld hl, $0022
	add hl, bc
	ld a, [hli]
	or [hl]
	jr z, .asm_4e552
	ld hl, $0020
	add hl, bc
	ld a, [hl]
	and $27
	jr nz, .asm_4e552
	and a
	ret

.asm_4e552
	scf
	ret
; 4e554

Function4e554: ; 4e554
	ld a, [BattleType]
	dec a
	ld c, a
	ld hl, $6564
	ld b, $0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 4e564

INCBIN "baserom.gbc", $4e564, $4e5e1 - $4e564


Function4e5e1: ; 4e5e1
	push hl
	push de
	push bc
	ld a, [CurSpecies]
	push af
	ld a, [rOBP0]
	push af
	ld a, [BaseDexNo]
	push af
	call Function4e607
	pop af
	ld [BaseDexNo], a
	pop af
	ld [rOBP0], a
	pop af
	ld [CurSpecies], a
	pop bc
	pop de
	pop hl
	ld a, [$d1ed]
	and a
	ret z
	scf
	ret
; 4e607

Function4e607: ; 4e607
	ld a, $e4
	ld [rOBP0], a
	ld de, $0000
	call StartMusic
	callba Function8cf53
	ld de, $6831
	ld hl, VTiles0
	ld bc, $1308
	call Request2bpp
	xor a
	ld [Danger], a
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ld a, [MagikarpLength]
	ld [PlayerHPPal], a
	ld c, $0
	call Function4e703
	ld a, [MagikarpLength]
	ld [CurPartySpecies], a
	ld [CurSpecies], a
	call Function4e708
	ld de, VTiles2
	ld hl, $9310
	ld bc, $0031
	call Request2bpp
	ld a, $31
	ld [$d1ec], a
	call Function4e755
	ld a, [Buffer2]
	ld [CurPartySpecies], a
	ld [CurSpecies], a
	call Function4e711
	ld a, [MagikarpLength]
	ld [CurPartySpecies], a
	ld [CurSpecies], a
	ld a, $1
	ld [hBGMapMode], a
	call Function4e794
	jr c, .asm_4e67c
	ld a, [MagikarpLength]
	call Function37ce

.asm_4e67c
	ld de, $0022
	call StartMusic
	ld c, $50
	call DelayFrames
	ld c, $1
	call Function4e703
	call Function4e726
	jr c, .asm_4e6df
	ld a, $cf
	ld [$d1ec], a
	call Function4e755
	xor a
	ld [$d1ed], a
	ld a, [Buffer2]
	ld [PlayerHPPal], a
	ld c, $0
	call Function4e703
	call Function4e7a6
	callba Function8cf53
	call Function4e794
	jr c, .asm_4e6de
	ld a, [$c2c6]
	push af
	ld a, $1
	ld [$c2c6], a
	ld a, [CurPartySpecies]
	push af
	ld a, [PlayerHPPal]
	ld [CurPartySpecies], a
	ld hl, $c4cf
	ld d, $0
	ld e, $4
	ld a, $47
	call Predef
	pop af
	ld [CurPartySpecies], a
	pop af
	ld [$c2c6], a
	ret

.asm_4e6de
	ret

.asm_4e6df
	ld a, $1
	ld [$d1ed], a
	ld a, [MagikarpLength]
	ld [PlayerHPPal], a
	ld c, $0
	call Function4e703
	call Function4e7a6
	callba Function8cf53
	call Function4e794
	ret c
	ld a, [PlayerHPPal]
	call Function37ce
	ret
; 4e703

Function4e703: ; 4e703
	ld b, $b
	jp GetSGBLayout
; 4e708

Function4e708: ; 4e708
	call GetBaseData
	ld hl, $c4cf
	jp Function3786
; 4e711

Function4e711: ; 4e711
	call GetBaseData
	ld a, $1
	ld [$c2c6], a
	ld de, VTiles2
	ld a, $3e
	call Predef
	xor a
	ld [$c2c6], a
	ret
; 4e726

Function4e726: ; 4e726
	call ClearJoypadPublic
	ld bc, $010e
.asm_4e72c
	push bc
	call Function4e779
	pop bc
	jr c, .asm_4e73f
	push bc
	call Function4e741
	pop bc
	inc b
	dec c
	dec c
	jr nz, .asm_4e72c
	and a
	ret

.asm_4e73f
	scf
	ret
; 4e741

Function4e741: ; 4e741
.asm_4e741
	ld a, $cf
	ld [$d1ec], a
	call Function4e755
	ld a, $31
	ld [$d1ec], a
	call Function4e755
	dec b
	jr nz, .asm_4e741
	ret
; 4e755

Function4e755: ; 4e755
	push bc
	xor a
	ld [hBGMapMode], a
	ld hl, $c4cf
	ld bc, $0707
	ld de, $000d
.asm_4e762
	push bc
.asm_4e763
	ld a, [$d1ec]
	add [hl]
	ld [hli], a
	dec c
	jr nz, .asm_4e763
	pop bc
	add hl, de
	dec b
	jr nz, .asm_4e762
	ld a, $1
	ld [hBGMapMode], a
	call WaitBGMap
	pop bc
	ret
; 4e779

Function4e779: ; 4e779
.asm_4e779
	call DelayFrame
	push bc
	call Functiona57
	ld a, [hJoyDown]
	pop bc
	and $2
	jr nz, .asm_4e78c
.asm_4e787
	dec c
	jr nz, .asm_4e779
	and a
	ret

.asm_4e78c
	ld a, [$d1e9]
	and a
	jr nz, .asm_4e787
	scf
	ret
; 4e794

Function4e794: ; 4e794
	ld a, [CurPartyMon]
	ld hl, PartyMon1Species
	call GetPartyLocation
	ld b, h
	ld c, l
	ld a, $13
	ld hl, $653f
	rst FarCall
	ret
; 4e7a6

Function4e7a6: ; 4e7a6
	ld a, [$d1ed]
	and a
	ret nz
	ld de, SFX_EVOLVED
	call StartSFX
	ld hl, $cf63
	ld a, [hl]
	push af
	ld [hl], $0
.asm_4e7b8
	call Function4e7cf
	jr nc, .asm_4e7c2
	call Function4e80c
	jr .asm_4e7b8

.asm_4e7c2
	ld c, $20
.asm_4e7c4
	call Function4e80c
	dec c
	jr nz, .asm_4e7c4
	pop af
	ld [$cf63], a
	ret
; 4e7cf

Function4e7cf: ; 4e7cf
	ld hl, $cf63
	ld a, [hl]
	cp $20
	ret nc
	ld d, a
	inc [hl]
	and $1
	jr nz, .asm_4e7e6
	ld e, $0
	call Function4e7e8
	ld e, $10
	call Function4e7e8

.asm_4e7e6
	scf
	ret
; 4e7e8

Function4e7e8: ; 4e7e8
	push de
	ld de, $4858
	ld a, $13
	call Function3b2a
	ld hl, $000b
	add hl, bc
	ld a, [$cf63]
	and $e
	sla a
	pop de
	add e
	ld [hl], a
	ld hl, $0003
	add hl, bc
	ld [hl], $0
	ld hl, $000c
	add hl, bc
	ld [hl], $10
	ret
; 4e80c

Function4e80c: ; 4e80c
	push bc
	callab Function8cf69
	ld a, [$ff9b]
	and $e
	srl a
	inc a
	inc a
	and $7
	ld b, a
	ld hl, $c403
	ld c, $28
.asm_4e823
	ld a, [hl]
	or b
	ld [hli], a
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .asm_4e823
	pop bc
	call DelayFrame
	ret
; 4e831


EvolutionGFX:
INCBIN "gfx/evo/bubble_large.2bpp"
INCBIN "gfx/evo/bubble.2bpp"

Function4e881: ; 4e881
	call WhiteBGMap
	call ClearTileMap
	call ClearSprites
	call DisableLCD
	call Functione51
	call Functione58
	ld hl, VBGMap0
	ld bc, VBlank5
	ld a, $7f
	call ByteFill
	ld hl, AttrMap
	ld bc, $0168
	xor a
	call ByteFill
	xor a
	ld [hSCY], a
	ld [hSCX], a
	call EnableLCD
	ld hl, $68bd
	call PrintText
	call Function3200
	call Function32f9
	ret
; 4e8bd

INCBIN "baserom.gbc", $4e8bd, $4e8c2 - $4e8bd


Function4e8c2: ; 4e8c2
	call WhiteBGMap
	call ClearTileMap
	call ClearSprites
	call DisableLCD
	call Functione51
	call Functione58
	ld hl, VBGMap0
	ld bc, VBlank5
	ld a, $7f
	call ByteFill
	ld hl, AttrMap
	ld bc, $0168
	xor a
	call ByteFill
	ld hl, $d000
	ld c, $40
.asm_4e8ee
	ld a, $ff
	ld [hli], a
	ld a, $7f
	ld [hli], a
	dec c
	jr nz, .asm_4e8ee
	xor a
	ld [hSCY], a
	ld [hSCX], a
	call EnableLCD
	call Function3200
	call Function32f9
	ret
; 4e906

Function4e906: ; 4e906
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	ld hl, $d000
	ld bc, VBlank5
	ld a, $7f
	call ByteFill
	ld hl, VBGMap0
	ld de, $d000
	ld b, $0
	ld c, $40
	call Request2bpp
	pop af
	ld [rSVBK], a
	ret
; 4e929

Function4e929: ; 4e929
	ld h, b
	ld l, c
	call Function4e930
	ld c, a
	ret
; 4e930

Function4e930: ; 4e930
	ld a, [hli]
	xor [hl]
	ld c, a
	jr z, .asm_4e941
	srl c
	srl c
.asm_4e939
	srl c
	ld a, c
	cp $18
	jr nc, .asm_4e939
	inc c

.asm_4e941
	ld a, [de]
	cp $1
	ld hl, $695d
	jr nz, .asm_4e958
	ld hl, $6976
	ld a, c
	and a
	jr z, .asm_4e958
.asm_4e950
	srl c
	ld a, c
	cp $9
	jr nc, .asm_4e950
	inc c

.asm_4e958
	ld b, $0
	add hl, bc
	ld a, [hl]
	ret
; 4e95d

INCBIN "baserom.gbc", $4e95d, $4e980 - $4e95d


Function4e980: ; 4e980
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	call Function4e998
	ld a, $43
	ld [hLCDStatCustom], a
	call Function4e9ab
	xor a
	ld [hLCDStatCustom], a
	pop af
	ld [rSVBK], a
	ret
; 4e998

Function4e998: ; 4e998
	call Function4e9e5
	ld a, $90
	ld [hSCX], a
	ld a, $e4
	call DmgToCgbBGPals
	ld de, $e4e4
	call DmgToCgbObjPals
	ret
; 4e9ab

Function4e9ab: ; 4e9ab
	ld d, $90
	ld e, $72
	ld a, $48
	inc a
.asm_4e9b2
	push af
.asm_4e9b3
	ld a, [rLY]
	cp $60
	jr c, .asm_4e9b3
	ld a, d
	ld [hSCX], a
	call Function4e9f1
	inc e
	inc e
	dec d
	dec d
	pop af
	push af
	cp $1
	jr z, .asm_4e9ce
	push de
	call Function4e9d6
	pop de

.asm_4e9ce
	call DelayFrame
	pop af
	dec a
	jr nz, .asm_4e9b2
	ret
; 4e9d6

Function4e9d6: ; 4e9d6
	ld hl, $c401
	ld c, $12
	ld de, $0004
.asm_4e9de
	dec [hl]
	dec [hl]
	add hl, de
	dec c
	jr nz, .asm_4e9de
	ret
; 4e9e5

Function4e9e5: ; 4e9e5
	ld hl, $d100
	ld a, $90
	ld bc, $0090
	call ByteFill
	ret
; 4e9f1

Function4e9f1: ; 4e9f1
	ld hl, $d100
	ld a, d
	ld c, $3e
.asm_4e9f7
	ld [hli], a
	dec c
	jr nz, .asm_4e9f7
	ld a, e
	ld c, $22
.asm_4e9fe
	ld [hli], a
	dec c
	jr nz, .asm_4e9fe
	xor a
	ld c, $30
.asm_4ea05
	ld [hli], a
	dec c
	jr nz, .asm_4ea05
	ret
; 4ea0a



Function4ea0a: ; 4ea0a
	ld a, c
	push af
	call SpeechTextBox
	call MobileTextBorder
	pop af
	dec a
	ld bc, $000c
	ld hl, $dc1a
	call AddNTimes
	ld de, $cd53
	ld bc, $000c
	ld a, $5
	call Function306b
	ld a, [rSVBK]
	push af
	ld a, $1
	ld [rSVBK], a
	ld bc, $cd53
	ld de, $c5b9
	ld a, $47
	ld hl, $40c6
	rst FarCall
	pop af
	ld [rSVBK], a
	ld c, $b4
	call DelayFrames
	ret
; 4ea44



Function4ea44: ; 4ea44
	ld a, $0
	ld hl, InLinkBattle
	call Function307b
	cp $4
	jr z, .asm_4ea59
	ld a, [Options]
	bit 7, a
	jr nz, .asm_4ea80
	and a
	ret

.asm_4ea59
	ld a, [$cd2f]
	and a
	jr nz, .asm_4ea72
	ld a, $4
	call GetSRAMBank
	ld a, [$a60c]
	ld c, a
	call CloseSRAM
	ld a, c
	bit 0, c
	jr z, .asm_4ea80
	and a
	ret

.asm_4ea72
	ld a, $5
	ld hl, $dc00
	call Function307b
	bit 0, a
	jr z, .asm_4ea80
	and a
	ret

.asm_4ea80
	scf
	ret
; 4ea82



Function4ea82: ; 4ea82
	ld a, [hCGB]
	and a
	ret nz
	ld de, $0000
	call StartMusic
	call ClearTileMap
	ld hl, $6b76
	ld de, $d000
	ld a, [rSVBK]
	push af
	ld a, $0
	ld [rSVBK], a
	call Decompress
	pop af
	ld [rSVBK], a
	ld de, $d000
	ld hl, VTiles2
	ld bc, Text_1354
	call Get2bpp
	ld de, $4200
	ld hl, VTiles1
	ld bc, Function3e80
	call Get1bpp
	call Function4eac5
	call WaitBGMap
.asm_4eac0
	call DelayFrame
	jr .asm_4eac0
; 4eac5

Function4eac5: ; 4eac5
	call Function4eaea
	ld hl, $c4cb
	ld b, $e
	ld c, $4
	ld a, $8
	call Function4eb27
	ld hl, $c51d
	ld b, $a
	ld c, $2
	ld a, $40
	call Function4eb27
	ld de, $6b38
	ld hl, $c569
	call PlaceString
	ret
; 4eaea

Function4eaea: ; 4eaea
	ld hl, TileMap
	ld [hl], $0
	inc hl
	ld a, $1
	call Function4eb15
	ld [hl], $2
	ld hl, $c4b4
	ld a, $3
	call Function4eb1c
	ld hl, $c4c7
	ld a, $4
	call Function4eb1c
	ld hl, $c5f4
	ld [hl], $5
	inc hl
	ld a, $6
	call Function4eb15
	ld [hl], $7
	ret
; 4eb15

Function4eb15: ; 4eb15
	ld c, $12
.asm_4eb17
	ld [hli], a
	dec c
	jr nz, .asm_4eb17
	ret
; 4eb1c

Function4eb1c: ; 4eb1c
	ld de, $0014
	ld c, $10
.asm_4eb21
	ld [hl], a
	add hl, de
	dec c
	jr nz, .asm_4eb21
	ret
; 4eb27

Function4eb27: ; 4eb27
	ld de, $0014
.asm_4eb2a
	push bc
	push hl
.asm_4eb2c
	ld [hli], a
	inc a
	dec b
	jr nz, .asm_4eb2c
	pop hl
	add hl, de
	pop bc
	dec c
	jr nz, .asm_4eb2a
	ret
; 4eb38

INCBIN "baserom.gbc", $4eb38, $4f301 - $4eb38


Function4f301: ; 4f301
	ld hl, $001e
	add hl, bc
	ld a, [hl]
	and $7f
	jr z, .asm_4f319
	cp $7f
	jr z, .asm_4f319
	ld a, [hl]
	and $80
	jr nz, .asm_4f316
	ld c, $1
	ret

.asm_4f316
	ld c, $2
	ret

.asm_4f319
	ld c, $0
	ret
; 4f31c



SECTION "bank14",ROMX,BANK[$14]

Function50000: ; 50000
	call Function2ed3
	xor a
	ld [PartyMenuActionText], a
	call WhiteBGMap
	call Function5003f
	call WaitBGMap
	call Function32f9
	call DelayFrame
	call PartyMenuSelect
	call Function2b74
	ret
; 5001d


Function5001d: ; 5001d
	ld a, b
	ld [PartyMenuActionText], a
	call Function2ed3
	call WhiteBGMap
	call Function5003f
	call WaitBGMap
	ld b, $a
	call GetSGBLayout
	call Function32f9
	call DelayFrame
	call PartyMenuSelect
	call Function2b74
	ret
; 5003f

Function5003f: ; 5003f
	call Function5004f
	call Function50405
	call Function503e0
	call WritePartyMenuTilemap
	call PrintPartyMenuText
	ret
; 5004f

Function5004f: ; 5004f
	call Functione58
	ld hl, $4ad1
	ld a, $2
	rst FarCall
	ld hl, $6814
	ld a, $23
	rst FarCall
	ret
; 5005f


WritePartyMenuTilemap: ; 0x5005f
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl] ; Disable text delay
	xor a
	ld [hBGMapMode], a
	ld hl, TileMap
	ld bc, $0168
	ld a, " "
	call ByteFill ; blank the tilemap
	call Function50396 ; This reads from a pointer table???
.asm_50077
	ld a, [hli]
	cp $ff
	jr z, .asm_50084 ; 0x5007a $8
	push hl
	ld hl, $4089
	rst JumpTable
	pop hl
	jr .asm_50077 ; 0x50082 $f3
.asm_50084
	pop af
	ld [Options], a
	ret
; 0x50089

Table50089: ; 50089
	dw Function5009b
	dw Function500cf
	dw Function50138
	dw Function50176
	dw Function501b2
	dw Function501e0
	dw Function5022f
	dw Function502b1
	dw Function50307
; 5009b

Function5009b: ; 5009b
	ld hl, $c4b7
	ld a, [PartyCount]
	and a
	jr z, .asm_500bf
	ld c, a
	ld b, $0
.asm_500a7
	push bc
	push hl
	push hl
	ld hl, PartyMon1Nickname
	ld a, b
	call GetNick
	pop hl
	call PlaceString
	pop hl
	ld de, $0028
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_500a7

.asm_500bf
	dec hl
	dec hl
	ld de, $40c8
	call PlaceString
	ret
; 500c8

INCBIN "baserom.gbc", $500c8, $500cf - $500c8


Function500cf: ; 500cf
	xor a
	ld [$cda9], a
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
	ld b, $0
	ld hl, $c4d3
.asm_500de
	push bc
	push hl
	call Function50389
	jr z, .asm_50103
	push hl
	call Function50117
	pop hl
	ld d, $6
	ld b, $0
	call DrawHPBar
	ld hl, $cd9b
	ld a, [$cda9]
	ld c, a
	ld b, $0
	add hl, bc
	call SetHPPal
	ld b, $fc
	call GetSGBLayout

.asm_50103
	ld hl, $cda9
	inc [hl]
	pop hl
	ld de, $0028
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_500de
	ld b, $a
	call GetSGBLayout
	ret
; 50117

Function50117: ; 50117
	ld a, b
	ld bc, $0030
	ld hl, PartyMon1CurHP
	call AddNTimes
	ld a, [hli]
	or [hl]
	jr nz, .asm_50129
	xor a
	ld e, a
	ld c, a
	ret

.asm_50129
	dec hl
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	ld a, $4
	call Predef
	ret
; 50138

Function50138: ; 50138
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
	ld b, $0
	ld hl, $c4c1
.asm_50143
	push bc
	push hl
	call Function50389
	jr z, .asm_5016b
	push hl
	ld a, b
	ld bc, $0030
	ld hl, PartyMon1CurHP
	call AddNTimes
	ld e, l
	ld d, h
	pop hl
	push de
	ld bc, $0203
	call PrintNum
	pop de
	ld a, $f3
	ld [hli], a
	inc de
	inc de
	ld bc, $0203
	call PrintNum

.asm_5016b
	pop hl
	ld de, $0028
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_50143
	ret
; 50176

Function50176: ; 50176
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
	ld b, $0
	ld hl, $c4d0
.asm_50181
	push bc
	push hl
	call Function50389
	jr z, .asm_501a7
	push hl
	ld a, b
	ld bc, $0030
	ld hl, PartyMon1Level
	call AddNTimes
	ld e, l
	ld d, h
	pop hl
	ld a, [de]
	cp $64
	jr nc, .asm_501a1
	ld a, $6e
	ld [hli], a
	ld bc, $4102

.asm_501a1
	ld bc, $4103
	call PrintNum

.asm_501a7
	pop hl
	ld de, $0028
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_50181
	ret
; 501b2

Function501b2: ; 501b2
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
	ld b, $0
	ld hl, $c4cd
.asm_501bd
	push bc
	push hl
	call Function50389
	jr z, .asm_501d5
	push hl
	ld a, b
	ld bc, $0030
	ld hl, PartyMon1Status
	call AddNTimes
	ld e, l
	ld d, h
	pop hl
	call Function50d0a

.asm_501d5
	pop hl
	ld de, $0028
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_501bd
	ret
; 501e0

Function501e0: ; 501e0
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
	ld b, $0
	ld hl, $c4d4
.asm_501eb
	push bc
	push hl
	call Function50389
	jr z, .asm_5020a
	push hl
	ld hl, PartySpecies
	ld e, b
	ld d, $0
	add hl, de
	ld a, [hl]
	ld [CurPartySpecies], a
	ld a, $e
	call Predef
	pop hl
	call Function50215
	call PlaceString

.asm_5020a
	pop hl
	ld de, $0028
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_501eb
	ret
; 50215

Function50215: ; 50215
	ld a, c
	and a
	jr nz, .asm_5021d
	ld de, $4226
	ret

.asm_5021d
	ld de, $4221
	ret
; 50221

INCBIN "baserom.gbc", $50221, $5022f - $50221


Function5022f: ; 5022f
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
	ld b, $0
	ld hl, $c4d4
.asm_5023a
	push bc
	push hl
	call Function50389
	jr z, .asm_5025d
	push hl
	ld a, b
	ld bc, $0030
	ld hl, PartyMon1Species
	call AddNTimes
	ld a, [hl]
	dec a
	ld e, a
	ld d, $0
	ld hl, $65b1
	add hl, de
	add hl, de
	call Function50268
	pop hl
	call PlaceString

.asm_5025d
	pop hl
	ld de, $0028
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_5023a
	ret
; 50268

Function50268: ; 50268
	ld de, StringBuffer1
	ld a, $10
	ld bc, $0002
	call FarCopyBytes
	ld hl, StringBuffer1
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, StringBuffer1
	ld a, $10
	ld bc, $000a
	call FarCopyBytes
	ld hl, StringBuffer1
.asm_50287
	ld a, [hli]
	and a
	jr z, .asm_5029f
	inc hl
	inc hl
	cp $2
	jr nz, .asm_50287
	dec hl
	dec hl
	ld a, [CurItem]
	cp [hl]
	inc hl
	inc hl
	jr nz, .asm_50287
	ld de, $42a3
	ret

.asm_5029f
	ld de, $42a8
	ret
; 502a3

INCBIN "baserom.gbc", $502a3, $502b1 - $502a3


Function502b1: ; 502b1
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
	ld b, $0
	ld hl, $c4d4
.asm_502bc
	push bc
	push hl
	call Function50389
	jr z, .asm_502e3
	ld [CurPartySpecies], a
	push hl
	ld a, b
	ld [CurPartyMon], a
	xor a
	ld [MonType], a
	call GetGender
	ld de, $42fe
	jr c, .asm_502df
	ld de, $42ee
	jr nz, .asm_502df
	ld de, $42f5

.asm_502df
	pop hl
	call PlaceString

.asm_502e3
	pop hl
	ld de, $0028
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_502bc
	ret
; 502ee

INCBIN "baserom.gbc", $502ee, $50307 - $502ee


Function50307: ; 50307
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
	ld b, $0
	ld hl, $c4c0
.asm_50312
	push bc
	push hl
	ld de, $4372
	call PlaceString
	pop hl
	ld de, $0028
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_50312
	ld a, l
	ld e, $b
	sub e
	ld l, a
	ld a, h
	sbc $0
	ld h, a
	ld de, $4379
	call PlaceString
	ld b, $3
	ld c, $0
	ld hl, DefaultFlypoint
	ld a, [hl]
.asm_5033b
	push hl
	push bc
	ld hl, $c4c0
.asm_50340
	and a
	jr z, .asm_5034a
	ld de, $0028
	add hl, de
	dec a
	jr .asm_50340

.asm_5034a
	ld de, $436b
	push hl
	call PlaceString
	pop hl
	pop bc
	push bc
	push hl
	ld a, c
	ld hl, $4383
	call GetNthString
	ld d, h
	ld e, l
	pop hl
	call PlaceString
	pop bc
	pop hl
	inc hl
	ld a, [hl]
	inc c
	dec b
	ret z
	jr .asm_5033b
; 5036b

INCBIN "baserom.gbc", $5036b, $50389 - $5036b


Function50389: ; 50389
	ld a, PartySpecies & $ff
	add b
	ld e, a
	ld a, PartySpecies >> 8
	adc 0
	ld d, a
	ld a, [de]
	cp EGG
	ret
; 50396

Function50396: ; 50396
	ld a, [PartyMenuActionText]
	and $f0
	jr nz, .asm_503ae
	ld a, [PartyMenuActionText]
	and $f
	ld e, a
	ld d, 0
	ld hl, $43b2
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

.asm_503ae
	ld hl, $43c6
	ret
; 503b2

INCBIN "baserom.gbc", $503b2, $503e0 - $503b2


Function503e0: ; 503e0
	ld hl, PartyCount
	ld a, [hli]
	and a
	ret z
	ld c, a
	xor a
	ld [hConnectedMapWidth], a
.asm_503ea
	push bc
	push hl
	ld hl, $683f
	ld a, $23
	ld e, $0
	rst FarCall
	ld a, [hConnectedMapWidth]
	inc a
	ld [hConnectedMapWidth], a
	pop hl
	pop bc
	dec c
	jr nz, .asm_503ea
	callab Function8cf69
	ret
; 50405

Function50405: ; 50405
	xor a
	ld [$d0e3], a
	ld de, $444f
	call Function1bb1
	ld a, [PartyCount]
	inc a
	ld [$cfa3], a
	dec a
	ld b, a
	ld a, [$d0d8]
	and a
	jr z, .asm_50422
	inc b
	cp b
	jr c, .asm_50424

.asm_50422
	ld a, $1

.asm_50424
	ld [$cfa9], a
	ld a, $3
	ld [$cfa8], a
	ret
; 5042d

INCBIN "baserom.gbc", $5042d, $50457 - $5042d

PartyMenuSelect: ; 0x50457
; sets carry if exitted menu.
	call Function1bc9
	call Function1bee
	ld a, [PartyCount]
	inc a
	ld b, a
	ld a, [$cfa9] ; menu selection?
	cp b
	jr z, .exitmenu ; CANCEL
	ld [$d0d8], a
	ld a, [$ffa9]
	ld b, a
	bit 1, b
	jr nz, .exitmenu ; B button?
	ld a, [$cfa9]
	dec a
	ld [CurPartyMon], a
	ld c, a
	ld b, $0
	ld hl, PartySpecies
	add hl, bc
	ld a, [hl]
	ld [CurPartySpecies], a

	ld de, SFX_READ_TEXT_2
	call StartSFX
	call WaitSFX
	and a
	ret

.exitmenu
	ld de, SFX_READ_TEXT_2
	call StartSFX
	call WaitSFX
	scf
	ret
; 0x5049a


PrintPartyMenuText: ; 5049a
	ld hl, $c5b8
	ld bc, $0212
	call TextBox
	ld a, [PartyCount]
	and a
	jr nz, .haspokemon
	ld de, YouHaveNoPKMNString
	jr .gotstring
.haspokemon ; 504ae
	ld a, [PartyMenuActionText]
	and $f ; drop high nibble
	ld hl, PartyMenuStrings
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
.gotstring ; 504be
	ld a, [Options]
	push af
	set 4, a ; disable text delay
	ld [Options], a
	ld hl, $c5e1 ; Coord
	call PlaceString
	pop af
	ld [Options], a
	ret
; 0x504d2

PartyMenuStrings: ; 0x504d2
    dw ChooseAMonString
    dw UseOnWhichPKMNString
    dw WhichPKMNString
    dw TeachWhichPKMNString
    dw MoveToWhereString
    dw UseOnWhichPKMNString
    dw ChooseAMonString ; Probably used to be ChooseAFemalePKMNString
    dw ChooseAMonString ; Probably used to be ChooseAMalePKMNString
    dw ToWhichPKMNString

ChooseAMonString: ; 0x504e4
    db "Choose a #MON.@"
UseOnWhichPKMNString: ; 0x504f3
    db "Use on which ", $e1, $e2, "?@"
WhichPKMNString: ; 0x50504
    db "Which ", $e1, $e2, "?@"
TeachWhichPKMNString: ; 0x5050e
    db "Teach which ", $e1, $e2, "?@"
MoveToWhereString: ; 0x5051e
    db "Move to where?@"
ChooseAFemalePKMNString: ; 0x5052d  ; UNUSED
    db "Choose a ♀", $e1, $e2, ".@"
ChooseAMalePKMNString: ; 0x5053b    ; UNUSED
    db "Choose a ♂", $e1, $e2, ".@"
ToWhichPKMNString: ; 0x50549
    db "To which ", $e1, $e2, "?@"

YouHaveNoPKMNString: ; 0x50556
    db "You have no ", $e1, $e2, "!@"


Function50566: ; 50566
	ld a, [CurPartyMon]
	ld hl, PartyMon1Nickname
	call GetNick
	ld a, [PartyMenuActionText]
	and $f
	ld hl, $457b
	call Function505c1
	ret
; 5057b

INCBIN "baserom.gbc", $5057b, $505c1 - $5057b


Function505c1: ; 505c1
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [Options]
	push af
	set 4, a
	ld [Options], a
	call PrintText
	pop af
	ld [Options], a
	ret
; 505da

Function505da: ; 505da
	ld a, [PartyCount]
	and a
	jr z, .asm_5062c
	xor a
	ld c, 7
	ld hl, EngineBuffer1
.asm_505e6
	ld [hli], a
	dec c
	jr nz, .asm_505e6
	xor a
	ld [CurPartyMon], a
.asm_505ee
	call Function5062e
	jr nc, .asm_50605
	ld a, [CurPartyMon]
	ld e, a
	ld d, 0
	ld hl, CurFruit
	add hl, de
	ld [hl], c
	ld a, [EngineBuffer1]
	or c
	ld [EngineBuffer1], a

.asm_50605
	ld a, [PartyCount]
	ld hl, CurPartyMon
	inc [hl]
	cp [hl]
	jr nz, .asm_505ee
	ld a, [EngineBuffer1]
	and $2
	jr nz, .asm_50622
	ld a, [EngineBuffer1]
	and $1
	jr z, .asm_5062c
	call Function50658
	xor a
	ret

.asm_50622
	ld a, $14
	ld hl, UnknownScript_0x50669
	call CallScript
	scf
	ret

.asm_5062c
	xor a
	ret
; 5062e

Function5062e: ; 5062e
	ld a, $20
	call GetPartyParamLocation
	ld a, [hl]
	and $8
	ret z
	ld a, $22
	call GetPartyParamLocation
	ld a, [hli]
	ld b, a
	ld c, [hl]
	or c
	ret z
	dec bc
	ld [hl], c
	dec hl
	ld [hl], b
	ld a, b
	or c
	jr nz, .asm_50654
	ld a, $20
	call GetPartyParamLocation
	ld [hl], $0
	ld c, $2
	scf
	ret

.asm_50654
	ld c, $1
	scf
	ret
; 50658

Function50658: ; 50658
	ld de, SFX_POISON
	call StartSFX
	ld b, $2
	ld a, $2e
	call Predef
	call DelayFrame
	ret
; 50669

UnknownScript_0x50669: ; 50669
	3callasm BANK(Function50658), Function50658
	loadfont
	3callasm BANK(Function5067b), Function5067b
	iffalse UnknownScript_0x50677
	loadmovesprites
	end
; 50677

UnknownScript_0x50677: ; 50677
	3jump BANK(UnknownScript_0x124c8), UnknownScript_0x124c8
; 5067b

Function5067b: ; 5067b
	xor a
	ld [CurPartyMon], a
	ld de, CurFruit
.asm_50682
	push de
	ld a, [de]
	and 2
	jr z, .asm_5069c
	ld c, 7
	callba ChangeHappiness
	callba GetPartyNick
	ld hl, PoisonFaintText
	call PrintText

.asm_5069c
	pop de
	inc de
	ld hl, CurPartyMon
	inc [hl]
	ld a, [PartyCount]
	cp [hl]
	jr nz, .asm_50682
	ld a, $14
	call Predef
	ld a, d
	ld [ScriptVar], a
	ret
; 506b2

PoisonFaintText: ; 506b2
	text_jump UnknownText_0x1c0acc, BANK(UnknownText_0x1c0acc)
	db "@"
; 506b7

PoisonWhiteOutText: ; 506b7
	text_jump UnknownText_0x1c0ada, BANK(UnknownText_0x1c0ada)
	db "@"
; 506bc


Function506bc: ; 506bc
	ld hl, UnknownScript_0x506c8
	call Function31cd
	ld a, $1
	ld [$d0ec], a
	ret
; 506c8

UnknownScript_0x506c8: ; 0x506c8
	reloadmappart
	special $0035
	3callasm BANK(GetPartyNick), GetPartyNick
	2writetext UnknownText_0x50726
	closetext
	3callasm BANK(Function506ef), Function506ef
	iffalse UnknownScript_0x506e9
	checkbit2 $0011
	iftrue UnknownScript_0x506e5
	battlecheck
	startbattle
	returnafterbattle
	end
; 0x506e5

UnknownScript_0x506e5: ; 0x506e5
	3jump BANK(UnknownScript_0x135eb), UnknownScript_0x135eb
; 0x506e9

UnknownScript_0x506e9: ; 0x506e9
	2writetext UnknownText_0x5072b
	closetext
	loadmovesprites
	end
; 0x506ef

Function506ef: ; 506ef
	callba Function97cfd
	jr nc, .asm_5071e
	ld hl, StatusFlags2
	bit 2, [hl]
	jr nz, .asm_50712
	ld a, $a
	ld hl, $6111
	rst FarCall
	ld a, b
	and a
	jr z, .asm_5071e
	ld a, $a
	ld hl, $614f
	rst FarCall
	jr nz, .asm_5071e
	jr .asm_50718

.asm_50712
	callba Function97d31

.asm_50718
	ld a, $1
	ld [ScriptVar], a
	ret

.asm_5071e
	xor a
	ld [ScriptVar], a
	ld [BattleType], a
	ret
; 50726

UnknownText_0x50726: ; 0x50726
	text_jump UnknownText_0x1c0b03, BANK(UnknownText_0x1c0b03)
	db $50
; 0x5072b

UnknownText_0x5072b: ; 0x5072b
	text_jump UnknownText_0x1c0b1a, BANK(UnknownText_0x1c0b1a)
	db $50
; 0x50730


_Squirtbottle: ; 50730
	ld hl, UnknownScript_0x5073c
	call Function31cd
	ld a, $1
	ld [$d0ec], a
	ret
; 5073c

UnknownScript_0x5073c: ; 0x5073c
	reloadmappart
	special $0035
	3callasm BANK(Function50753), Function50753
	iffalse UnknownScript_0x5074b
	3jump BANK(WateredWeirdTreeScript), WateredWeirdTreeScript
; 0x5074b

UnknownScript_0x5074b: ; 0x5074b
	jumptext UnknownText_0x5074e
; 0x5074e

UnknownText_0x5074e: ; 0x5074e
	text_jump UnknownText_0x1c0b3b, BANK(UnknownText_0x1c0b3b)
	db $50
; 0x50753

Function50753: ; 50753
	ld a, [MapGroup]
	cp GROUP_ROUTE_36
	jr nz, .asm_50774

	ld a, [MapNumber]
	cp MAP_ROUTE_36
	jr nz, .asm_50774

	callba Functioncf0d
	jr c, .asm_50774

	ld a, d
	cp 23
	jr nz, .asm_50774

	ld a, $1
	ld [ScriptVar], a
	ret

.asm_50774
	xor a
	ld [ScriptVar], a
	ret
; 50779


_CardKey: ; 50779
	ld a, [MapGroup]
	cp GROUP_RADIO_TOWER_3F
	jr nz, .asm_507a9

	ld a, [MapNumber]
	cp MAP_RADIO_TOWER_3F
	jr nz, .asm_507a9

	ld a, [PlayerDirection]
	and $c
	cp UP << 2
	jr nz, .asm_507a9

	call GetFacingTileCoord
	ld a, d
	cp 18
	jr nz, .asm_507a9
	ld a, e
	cp 6
	jr nz, .asm_507a9

	ld hl, UnknownScript_0x507af
	call Function31cd
	ld a, $1
	ld [$d0ec], a
	ret

.asm_507a9
	ld a, $0
	ld [$d0ec], a
	ret
; 507af

UnknownScript_0x507af: ; 0x507af
	loadmovesprites
	3jump BANK(MapRadioTower3FSignpost2Script), MapRadioTower3FSignpost2Script
; 0x507b4


_BasementKey: ; 507b4
	ld a, [MapGroup]
	cp GROUP_WAREHOUSE_ENTRANCE
	jr nz, .asm_507db

	ld a, [MapNumber]
	cp MAP_WAREHOUSE_ENTRANCE
	jr nz, .asm_507db

	call GetFacingTileCoord
	ld a, d
	cp 22
	jr nz, .asm_507db
	ld a, e
	cp 10
	jr nz, .asm_507db

	ld hl, UnknownScript_0x507e1
	call Function31cd
	ld a, $1
	ld [$d0ec], a
	ret

.asm_507db
	ld a, $0
	ld [$d0ec], a
	ret
; 507e1

UnknownScript_0x507e1: ; 0x507e1
	loadmovesprites
	3jump BANK(MapWarehouseEntranceSignpost0Script), MapWarehouseEntranceSignpost0Script
; 0x507e6


_SacredAsh: ; 507e6
	ld a, $0
	ld [$d0ec], a
	call CheckAnyFaintedMon
	ret nc

	ld hl, UnknownScript_0x50821
	call Function31cd
	ld a, $1
	ld [$d0ec], a
	ret
; 507fb

CheckAnyFaintedMon: ; 507fb
	ld de, PartyMon2 - PartyMon1
	ld bc, PartySpecies
	ld hl, PartyMon1CurHP
	ld a, [PartyCount]
	and a
	ret z

.loop
	push af
	push hl
	ld a, [bc]
	inc bc
	cp EGG
	jr z, .next

	ld a, [hli]
	or [hl]
	jr z, .asm_5081d

.next
	pop hl
	add hl, de
	pop af
	dec a
	jr nz, .loop
	xor a
	ret

.asm_5081d
	pop hl
	pop af
	scf
	ret
; 50821

UnknownScript_0x50821: ; 0x50821
	special $001b
	reloadmappart
	playsound SFX_WARP_TO
	special $002e
	special $0031
	special $002e
	special $0031
	special $002e
	special $0031
	waitbutton
	2writetext UnknownText_0x50845
	playsound SFX_CAUGHT_MON
	waitbutton
	closetext
	loadmovesprites
	end
; 0x50845

UnknownText_0x50845: ; 0x50845
	text_jump UnknownText_0x1c0b65, BANK(UnknownText_0x1c0b65)
	db $50
; 0x5084a

Function5084a: ; 5084a
	ld a, [CurPartyMon]
	ld e, a
	call Function508d5
	ld a, [CurPartySpecies]
	ld [CurSpecies], a
	call GetBaseData

	ld a, [MonType]
	ld hl, PartyMon1Species
	ld bc, PartyMon2 - PartyMon1
	and a
	jr z, .asm_5087b
	ld hl, OTPartyMon1Species
	ld bc, OTPartyMon2 - OTPartyMon1
	cp $1
	jr z, .asm_5087b
	ld bc, $0020
	ld hl, $65bb
	ld a, $3
	rst FarCall
	jr .asm_5088a

.asm_5087b
	ld a, [CurPartyMon]
	call AddNTimes
	ld de, TempMonSpecies
	ld bc, $0030
	call CopyBytes

.asm_5088a
	ret
; 5088b


Function5088b: ; 5088b
	ld bc, $d018
	jr Function50893
; 50890

Function50890: ; 50890
	ld bc, TempMon
	; fallthrough
; 50893

Function50893: ; 50893
	ld hl, TempMonLevel - TempMon
	add hl, bc
	ld a, [hl]
	ld [CurPartyLevel], a
	ld hl, TempMonMaxHP - TempMon
	add hl, bc
	ld d, h
	ld e, l
	ld hl, TempMonExp + 2 - TempMon
	add hl, bc
	push bc
	ld b, $1
	ld a, $c
	call Predef
	pop bc
	ld hl, TempMonCurHP - TempMon
	add hl, bc
	ld d, h
	ld e, l
	ld a, [CurPartySpecies]
	cp EGG
	jr nz, .asm_508c1
	xor a
	ld [de], a
	inc de
	ld [de], a
	jr .asm_508cd

.asm_508c1
	push bc
	ld hl, TempMonMaxHP - TempMon
	add hl, bc
	ld bc, 2
	call CopyBytes
	pop bc

.asm_508cd
	ld hl, TempMonStatus - TempMon
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], a
	ret
; 508d5

Function508d5: ; 508d5
	ld a, [MonType]
	and a ; PARTYMON
	jr z, .asm_508e7
	cp OTPARTYMON
	jr z, .asm_508ec
	cp BOXMON
	jr z, .asm_508f1
	cp $3
	jr z, .asm_50900
	; WILDMON

.asm_508e7
	ld hl, PartySpecies
	jr .asm_50905

.asm_508ec
	ld hl, OTPartySpecies
	jr .asm_50905

.asm_508f1
	ld a, 1 ; BANK(BoxSpecies)
	call GetSRAMBank
	ld hl, BoxSpecies
	call .asm_50905
	call CloseSRAM
	ret

.asm_50900
	ld a, [BreedMon1Species]
	jr .asm_50909

.asm_50905
	ld d, 0
	add hl, de
	ld a, [hl]

.asm_50909
	ld [CurPartySpecies], a
	ret
; 5090d


PrintMonTypes: ; 5090d
	push hl
	call GetBaseData
	pop hl
	push hl
	ld a, [BaseType1]
	call .asm_50928
	ld a, [BaseType1]
	ld b, a
	ld a, [BaseType2]
	cp b
	pop hl
	jr z, .asm_5092b
	ld bc, 20
	add hl, bc

.asm_50928
	ld b, a
	jr PrintType

.asm_5092b
	ld a, " "
	ld bc, 20 - 3
	add hl, bc
	ld [hl], a
	inc bc
	add hl, bc
	ld bc, 5
	jp ByteFill
; 5093a

PrintMoveType: ; 5093a
; Print the type of move b at hl.

	push hl
	ld a, b
	dec a
	ld bc, Move2 - Move1
	ld hl, Moves
	call AddNTimes
	ld de, StringBuffer1
	ld a, BANK(Moves)
	call FarCopyBytes
	ld a, [StringBuffer1 + PlayerMoveType - PlayerMoveStruct]
	pop hl

	ld b, a
; 50953

PrintType: ; 50953
; Print type b at hl.
	ld a, b

	push hl
	add a
	ld hl, TypeNames
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop hl

	jp PlaceString
; 50964


GetTypeName: ; 50964
; Copy the name of type $d265 to StringBuffer1.
	ld a, [$d265]
	ld hl, TypeNames
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, StringBuffer1
	ld bc, $000d
	jp CopyBytes
; 5097b


TypeNames: ; 5097b
	dw Normal
	dw Fighting
	dw Flying
	dw Poison
	dw Ground
	dw Rock
	dw Bird
	dw Bug
	dw Ghost
	dw Steel
	dw Normal
	dw Normal
	dw Normal
	dw Normal
	dw Normal
	dw Normal
	dw Normal
	dw Normal
	dw Normal
	dw UnknownType
	dw Fire
	dw Water
	dw Grass
	dw Electric
	dw Psychic
	dw Ice
	dw Dragon
	dw Dark

Normal:
	db "NORMAL@"
Fighting:
	db "FIGHTING@"
Flying:
	db "FLYING@"
Poison:
	db "POISON@"
UnknownType:
	db "???@"
Fire:
	db "FIRE@"
Water:
	db "WATER@"
Grass:
	db "GRASS@"
Electric:
	db "ELECTRIC@"
Psychic:
	db "PSYCHIC@"
Ice:
	db "ICE@"
Ground:
	db "GROUND@"
Rock:
	db "ROCK@"
Bird:
	db "BIRD@"
Bug:
	db "BUG@"
Ghost:
	db "GHOST@"
Steel:
	db "STEEL@"
Dragon:
	db "DRAGON@"
Dark:
	db "DARK@"
; 50a28


INCBIN "baserom.gbc", $50a28, $50b0a - $50a28


DrawPlayerHP: ; 50b0a
	ld a, $1
	jr DrawHP

DrawEnemyHP: ; 50b0e
	ld a, $2

DrawHP: ; 50b10
	ld [$d10a], a
	push hl
	push bc
	ld a, [MonType]
	cp BOXMON
	jr z, .asm_50b30

	ld a, [TempMonCurHP]
	ld b, a
	ld a, [TempMonCurHP + 1]
	ld c, a

; Any HP?
	or b
	jr nz, .asm_50b30

	xor a
	ld c, a
	ld e, a
	ld a, 6
	ld d, a
	jp .asm_50b4a

.asm_50b30
	ld a, [TempMonMaxHP]
	ld d, a
	ld a, [TempMonMaxHP + 1]
	ld e, a
	ld a, [MonType]
	cp BOXMON
	jr nz, .asm_50b41

	ld b, d
	ld c, e

.asm_50b41
	ld a, $4
	call Predef
	ld a, 6
	ld d, a
	ld c, a

.asm_50b4a
	ld a, c
	pop bc
	ld c, a
	pop hl
	push de
	push hl
	push hl
	call DrawHPBar
	pop hl

; Print HP 
	ld bc, $0015 ; move (1,1)
	add hl, bc
	ld de, TempMonCurHP
	ld a, [MonType]
	cp BOXMON
	jr nz, .asm_50b66
	ld de, TempMonMaxHP
.asm_50b66
	ld bc, $0203
	call PrintNum

	ld a, "/"
	ld [hli], a

; Print max HP
	ld de, TempMonMaxHP
	ld bc, $0203
	call PrintNum
	pop hl
	pop de
	ret
; 50b7b


INCBIN "baserom.gbc", $50b7b, $50bdd - $50b7b


GetGender: ; 50bdd
; Return the gender of a given monster in a.

; 1: male
; 0: female
; c: genderless

; This is determined by comparing the Attack and Speed DVs
; with the species' gender ratio.


; Figure out what type of monster struct we're looking at.

; 0: PartyMon
	ld hl, PartyMon1DVs
	ld bc, PartyMon2 - PartyMon1
	ld a, [MonType]
	and a
	jr z, .PartyMon
	
; 1: OTPartyMon
	ld hl, OTPartyMon1DVs
	dec a
	jr z, .PartyMon
	
; 2: BoxMon
	ld hl, BoxMon1DVs
	ld bc, BoxMon2 - BoxMon1
	dec a
	jr z, .BoxMon
	
; 3: Unknown
	ld hl, TempMonDVs
	dec a
	jr z, .DVs
	
; else: WildMon
	ld hl, EnemyMonDVs
	jr .DVs
	
	
; Get our place in the party/box.
	
.PartyMon
.BoxMon
	ld a, [CurPartyMon]
	call AddNTimes
	
	
.DVs
	
; BoxMon data is read directly from SRAM.
	ld a, [MonType]
	cp BOXMON
	ld a, 1
	call z, GetSRAMBank
	
; Attack DV
	ld a, [hli]
	and $f0
	ld b, a
; Speed DV
	ld a, [hl]
	and $f0
	swap a
	
; Put our DVs together.
	or b
	ld b, a

; Close SRAM if we were dealing with a BoxMon.
	ld a, [MonType]
	cp BOXMON
	call z, CloseSRAM
	
	
; We need the gender ratio to do anything with this.
	push bc
	ld a, [CurPartySpecies]
	dec a
	ld hl, BaseData + BaseGender - CurBaseData
	ld bc, BaseData1 - BaseData
	call AddNTimes
	pop bc
	
	ld a, BANK(BaseData)
	call GetFarByte
	
	
; The higher the ratio, the more likely the monster is to be female.
	
	cp $ff
	jr z, .Genderless
	
	and a
	jr z, .Male
	
	cp $fe
	jr z, .Female
	
; Values below the ratio are male, and vice versa.
	cp b
	jr c, .Male
	
.Female
	xor a
	ret
	
.Male
	ld a, 1
	and a
	ret
	
.Genderless
	scf
	ret
; 50c50

INCBIN "baserom.gbc", $50c50, $50d0a - $50c50


Function50d0a: ; 50d0a
	push de
	inc de
	inc de
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	or b
	pop de
	jr nz, .asm_50d2e
	push de
	ld de, .data_50d21
	call $4d25
	pop de
	ld a, $1
	and a
	ret

.data_50d21
	db $85
	db $8d
	db $93
	db $50
	db $1a
	db $13
	db $22
	db $1a
	db $13
	db $22
	db $1a
	db $77
	db $c9

.asm_50d2e
	push de
	ld a, [de]
	ld de, $4d5f
	bit 3, a
	jr nz, .asm_50d53
	ld de, $4d63
	bit 4, a
	jr nz, .asm_50d53
	ld de, $4d67
	bit 5, a
	jr nz, .asm_50d53
	ld de, $4d6b
	bit 6, a
	jr nz, .asm_50d53
	ld de, $4d5b
	and $7
	jr z, .asm_50d59

.asm_50d53
	call $4d25
	ld a, $1
	and a

.asm_50d59
	pop de
	ret
; 50d5b

INCBIN "baserom.gbc", $50d5b, $50e1b - $50d5b


Function50e1b: ; 50e1b
	ld a, [TempMonSpecies]
	ld [CurSpecies], a
	call GetBaseData
	ld d, $1
.asm_50e26
	inc d
	ld a, d
	cp $65
	jr z, .asm_50e45
	call Function50e47
	push hl
	ld hl, $d118
	ld a, [$ffb6]
	ld c, a
	ld a, [hld]
	sub c
	ld a, [$ffb5]
	ld c, a
	ld a, [hld]
	sbc c
	ld a, [hMultiplicand]
	ld c, a
	ld a, [hl]
	sbc c
	pop hl
	jr nc, .asm_50e26

.asm_50e45
	dec d
	ret
; 50e47



Function50e47: ; 50e47
	ld a, [BaseGrowthRate]
	add a
	add a
	ld c, a
	ld b, $0
	ld hl, $4efa
	add hl, bc
	call Function50eed
	ld a, d
	ld [hMultiplier], a
	call Multiply
	ld a, [hl]
	and $f0
	swap a
	ld [hMultiplier], a
	call Multiply
	ld a, [hli]
	and $f
	ld [hMultiplier], a
	ld b, $4
	call Divide
	ld a, [hMultiplicand]
	push af
	ld a, [$ffb5]
	push af
	ld a, [$ffb6]
	push af
	call Function50eed
	ld a, [hl]
	and $7f
	ld [hMultiplier], a
	call Multiply
	ld a, [hMultiplicand]
	push af
	ld a, [$ffb5]
	push af
	ld a, [$ffb6]
	push af
	ld a, [hli]
	push af
	xor a
	ld [hMultiplicand], a
	ld [$ffb5], a
	ld a, d
	ld [$ffb6], a
	ld a, [hli]
	ld [hMultiplier], a
	call Multiply
	ld b, [hl]
	ld a, [$ffb6]
	sub b
	ld [$ffb6], a
	ld b, $0
	ld a, [$ffb5]
	sbc b
	ld [$ffb5], a
	ld a, [hMultiplicand]
	sbc b
	ld [hMultiplicand], a
	pop af
	and $80
	jr nz, .asm_50ec8
	pop bc
	ld a, [$ffb6]
	add b
	ld [$ffb6], a
	pop bc
	ld a, [$ffb5]
	adc b
	ld [$ffb5], a
	pop bc
	ld a, [hMultiplicand]
	adc b
	ld [hMultiplicand], a
	jr .asm_50eda

.asm_50ec8
	pop bc
	ld a, [$ffb6]
	sub b
	ld [$ffb6], a
	pop bc
	ld a, [$ffb5]
	sbc b
	ld [$ffb5], a
	pop bc
	ld a, [hMultiplicand]
	sbc b
	ld [hMultiplicand], a

.asm_50eda
	pop bc
	ld a, [$ffb6]
	add b
	ld [$ffb6], a
	pop bc
	ld a, [$ffb5]
	adc b
	ld [$ffb5], a
	pop bc
	ld a, [hMultiplicand]
	adc b
	ld [hMultiplicand], a
	ret
; 50eed

Function50eed: ; 50eed
	xor a
	ld [hMultiplicand], a
	ld [$ffb5], a
	ld a, d
	ld [$ffb6], a
	ld [hMultiplier], a
	jp Multiply
; 50efa


INCBIN "baserom.gbc", $50efa, $51040 - $50efa


GetUnownLetter: ; 51040
; Return Unown letter in UnownLetter based on DVs at hl

; Take the middle 2 bits of each DV and place them in order:
;	AtkDefDV | SpdSpcDV
;	.ww..xx.   .yy..zz.

	; atk
	ld a, [hl]
	and %01100000
	sla a
	ld b, a
	; def
	ld a, [hli]
	and %00000110
	swap a
	srl a
	or b
	ld b, a
	
	; spd
	ld a, [hl]
	and %01100000
	swap a
	sla a
	or b
	ld b, a
	; spc
	ld a, [hl]
	and %00000110
	srl a
	or b

; Divide by 10 to get 0-25
	ld [hDividend + 3], a
	xor a
	ld [hDividend], a
	ld [hDividend + 1], a
	ld [hDividend + 2], a
	ld a, 10
	ld [hDivisor], a
	ld b, $4
	call Divide

; Increment to get 1-26
	ld a, [hQuotient + 2]
	inc a
	ld [UnownLetter], a
	ret
; 51077


INCBIN "baserom.gbc", $51077, $511c5 - $51077


Function511c5: ; 511c5
	push hl
	push bc
	sub $12
	ld c, a
	ld b, 0
	ld hl, $51d4
	add hl, bc
	ld a, [hl]
	pop bc
	pop hl
	ret
; 511d4

INCBIN "baserom.gbc", $511d4, $5120d - $511d4


Function5120d: ; 5120d
	ld a, [TrainerClass]
	and a
	ret z
	cp $44
	ret nc
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ld hl, Function50000
	ld a, [TrainerClass]
	dec a
	ld bc, $0003
	call AddNTimes
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	push de
	ld a, $4a
	call GetFarByte
	call Function511c5
	push af
	inc hl
	ld a, $4a
	call GetFarHalfword
	pop af
	ld de, $d000
	call FarDecompress
	pop hl
	ld de, $d000
	ld c, $31
	ld a, [hROMBank]
	ld b, a
	call Get2bpp
	pop af
	ld [rSVBK], a
	call WaitBGMap
	ld a, $1
	ld [hBGMapMode], a
	ret
; 5125d



DecompressPredef: ; 5125d
; Decompress lz data from b:hl to scratch space at 6:d000, then copy it to address de.

	ld a, [rSVBK]
	push af
	ld a, 6
	ld [rSVBK], a

	push de
	push bc
	ld a, b
	ld de, $d000
	call FarDecompress
	pop bc
	ld de, $d000
	pop hl
	ld a, [hROMBank]
	ld b, a
	call Get2bpp

	pop af
	ld [rSVBK], a
	ret
; 5127c


INCBIN "baserom.gbc", $5127c, $51424 - $5127c

BaseData:
INCLUDE "stats/base_stats.asm"

PokemonNames:
INCLUDE "stats/pokemon_names.asm"

INCBIN "baserom.gbc", $53D84, $53e2e - $53D84


SECTION "bank15",ROMX,BANK[$15]

;                          Map Scripts I

INCLUDE "maps/GoldenrodGym.asm"
INCLUDE "maps/GoldenrodBikeShop.asm"
INCLUDE "maps/GoldenrodHappinessRater.asm"
INCLUDE "maps/GoldenrodBillsHouse.asm"
INCLUDE "maps/GoldenrodMagnetTrainStation.asm"
INCLUDE "maps/GoldenrodFlowerShop.asm"
INCLUDE "maps/GoldenrodPPSpeechHouse.asm"
INCLUDE "maps/GoldenrodNameRatersHouse.asm"
INCLUDE "maps/GoldenrodDeptStore1F.asm"
INCLUDE "maps/GoldenrodDeptStore2F.asm"
INCLUDE "maps/GoldenrodDeptStore3F.asm"
INCLUDE "maps/GoldenrodDeptStore4F.asm"
INCLUDE "maps/GoldenrodDeptStore5F.asm"
INCLUDE "maps/GoldenrodDeptStore6F.asm"
INCLUDE "maps/GoldenrodDeptStoreElevator.asm"
INCLUDE "maps/GoldenrodDeptStoreRoof.asm"
INCLUDE "maps/GoldenrodGameCorner.asm"


SECTION "bank16",ROMX,BANK[$16]

;                          Map Scripts II

INCLUDE "maps/RuinsofAlphOutside.asm"
INCLUDE "maps/RuinsofAlphHoOhChamber.asm"
INCLUDE "maps/RuinsofAlphKabutoChamber.asm"
INCLUDE "maps/RuinsofAlphOmanyteChamber.asm"
INCLUDE "maps/RuinsofAlphAerodactylChamber.asm"
INCLUDE "maps/RuinsofAlphInnerChamber.asm"
INCLUDE "maps/RuinsofAlphResearchCenter.asm"
INCLUDE "maps/RuinsofAlphHoOhItemRoom.asm"
INCLUDE "maps/RuinsofAlphKabutoItemRoom.asm"
INCLUDE "maps/RuinsofAlphOmanyteItemRoom.asm"
INCLUDE "maps/RuinsofAlphAerodactylItemRoom.asm"
INCLUDE "maps/RuinsofAlphHoOhWordRoom.asm"
INCLUDE "maps/RuinsofAlphKabutoWordRoom.asm"
INCLUDE "maps/RuinsofAlphOmanyteWordRoom.asm"
INCLUDE "maps/RuinsofAlphAerodactylWordRoom.asm"
INCLUDE "maps/UnionCave1F.asm"
INCLUDE "maps/UnionCaveB1F.asm"
INCLUDE "maps/UnionCaveB2F.asm"
INCLUDE "maps/SlowpokeWellB1F.asm"
INCLUDE "maps/SlowpokeWellB2F.asm"
INCLUDE "maps/OlivineLighthouse1F.asm"
INCLUDE "maps/OlivineLighthouse2F.asm"
INCLUDE "maps/OlivineLighthouse3F.asm"
INCLUDE "maps/OlivineLighthouse4F.asm"


SECTION "bank17",ROMX,BANK[$17]

;                         Map Scripts III

INCLUDE "maps/NationalPark.asm"
INCLUDE "maps/NationalParkBugContest.asm"
INCLUDE "maps/RadioTower1F.asm"
INCLUDE "maps/RadioTower2F.asm"
INCLUDE "maps/RadioTower3F.asm"
INCLUDE "maps/RadioTower4F.asm"


SECTION "bank18",ROMX,BANK[$18]

;                          Map Scripts IV

INCLUDE "maps/RadioTower5F.asm"
INCLUDE "maps/OlivineLighthouse5F.asm"
INCLUDE "maps/OlivineLighthouse6F.asm"
INCLUDE "maps/GoldenrodPokeCenter1F.asm"
INCLUDE "maps/GoldenrodPokeComCenter2FMobile.asm"
INCLUDE "maps/IlexForestAzaleaGate.asm"
INCLUDE "maps/Route34IlexForestGate.asm"
INCLUDE "maps/DayCare.asm"


SECTION "bank19",ROMX,BANK[$19]

INCLUDE "text/phone/extra.asm"


SECTION "bank1A",ROMX,BANK[$1A]

;                          Map Scripts V

INCLUDE "maps/Route11.asm"
INCLUDE "maps/VioletMart.asm"
INCLUDE "maps/VioletGym.asm"
INCLUDE "maps/EarlsPokemonAcademy.asm"
INCLUDE "maps/VioletNicknameSpeechHouse.asm"
INCLUDE "maps/VioletPokeCenter1F.asm"
INCLUDE "maps/VioletOnixTradeHouse.asm"
INCLUDE "maps/Route32RuinsofAlphGate.asm"
INCLUDE "maps/Route32PokeCenter1F.asm"
INCLUDE "maps/Route35Goldenrodgate.asm"
INCLUDE "maps/Route35NationalParkgate.asm"
INCLUDE "maps/Route36RuinsofAlphgate.asm"
INCLUDE "maps/Route36NationalParkgate.asm"


SECTION "bank1B",ROMX,BANK[$1B]

;                          Map Scripts VI

INCLUDE "maps/Route8.asm"
INCLUDE "maps/MahoganyMart1F.asm"
INCLUDE "maps/TeamRocketBaseB1F.asm"
INCLUDE "maps/TeamRocketBaseB2F.asm"
INCLUDE "maps/TeamRocketBaseB3F.asm"
INCLUDE "maps/IlexForest.asm"


SECTION "bank1C",ROMX,BANK[$1C]

;                         Map Scripts VII

INCLUDE "maps/LakeofRage.asm"
INCLUDE "maps/CeladonDeptStore1F.asm"
INCLUDE "maps/CeladonDeptStore2F.asm"
INCLUDE "maps/CeladonDeptStore3F.asm"
INCLUDE "maps/CeladonDeptStore4F.asm"
INCLUDE "maps/CeladonDeptStore5F.asm"
INCLUDE "maps/CeladonDeptStore6F.asm"
INCLUDE "maps/CeladonDeptStoreElevator.asm"
INCLUDE "maps/CeladonMansion1F.asm"
INCLUDE "maps/CeladonMansion2F.asm"
INCLUDE "maps/CeladonMansion3F.asm"
INCLUDE "maps/CeladonMansionRoof.asm"
INCLUDE "maps/CeladonMansionRoofHouse.asm"
INCLUDE "maps/CeladonPokeCenter1F.asm"
INCLUDE "maps/CeladonPokeCenter2FBeta.asm"
INCLUDE "maps/CeladonGameCorner.asm"
INCLUDE "maps/CeladonGameCornerPrizeRoom.asm"
INCLUDE "maps/CeladonGym.asm"
INCLUDE "maps/CeladonCafe.asm"
INCLUDE "maps/Route16FuchsiaSpeechHouse.asm"
INCLUDE "maps/Route16Gate.asm"
INCLUDE "maps/Route7SaffronGate.asm"
INCLUDE "maps/Route1718Gate.asm"


SECTION "bank1D",ROMX,BANK[$1D]

;                         Map Scripts VIII

INCLUDE "maps/DiglettsCave.asm"
INCLUDE "maps/MountMoon.asm"
INCLUDE "maps/Underground.asm"
INCLUDE "maps/RockTunnel1F.asm"
INCLUDE "maps/RockTunnelB1F.asm"
INCLUDE "maps/SafariZoneFuchsiaGateBeta.asm"
INCLUDE "maps/SafariZoneBeta.asm"
INCLUDE "maps/VictoryRoad.asm"
INCLUDE "maps/OlivinePort.asm"
INCLUDE "maps/VermilionPort.asm"
INCLUDE "maps/FastShip1F.asm"
INCLUDE "maps/FastShipCabins_NNW_NNE_NE.asm"
INCLUDE "maps/FastShipCabins_SW_SSW_NW.asm"
INCLUDE "maps/FastShipCabins_SE_SSE_CaptainsCabin.asm"
INCLUDE "maps/FastShipB1F.asm"
INCLUDE "maps/OlivinePortPassage.asm"
INCLUDE "maps/VermilionPortPassage.asm"
INCLUDE "maps/MountMoonSquare.asm"
INCLUDE "maps/MountMoonGiftShop.asm"
INCLUDE "maps/TinTowerRoof.asm"


SECTION "bank1E",ROMX,BANK[$1E]

;                          Map Scripts IX

INCLUDE "maps/Route34.asm"
INCLUDE "maps/ElmsLab.asm"
INCLUDE "maps/KrissHouse1F.asm"
INCLUDE "maps/KrissHouse2F.asm"
INCLUDE "maps/KrissNeighborsHouse.asm"
INCLUDE "maps/ElmsHouse.asm"
INCLUDE "maps/Route26HealSpeechHouse.asm"
INCLUDE "maps/Route26DayofWeekSiblingsHouse.asm"
INCLUDE "maps/Route27SandstormHouse.asm"
INCLUDE "maps/Route2946Gate.asm"


SECTION "bank1F",ROMX,BANK[$1F]

;                          Map Scripts X

INCLUDE "maps/Route22.asm"
INCLUDE "maps/WarehouseEntrance.asm"
INCLUDE "maps/UndergroundPathSwitchRoomEntrances.asm"
INCLUDE "maps/GoldenrodDeptStoreB1F.asm"
INCLUDE "maps/UndergroundWarehouse.asm"
INCLUDE "maps/MountMortar1FOutside.asm"
INCLUDE "maps/MountMortar1FInside.asm"
INCLUDE "maps/MountMortar2FInside.asm"
INCLUDE "maps/MountMortarB1F.asm"
INCLUDE "maps/IcePath1F.asm"
INCLUDE "maps/IcePathB1F.asm"
INCLUDE "maps/IcePathB2FMahoganySide.asm"
INCLUDE "maps/IcePathB2FBlackthornSide.asm"
INCLUDE "maps/IcePathB3F.asm"
INCLUDE "maps/LavenderPokeCenter1F.asm"
INCLUDE "maps/LavenderPokeCenter2FBeta.asm"
INCLUDE "maps/MrFujisHouse.asm"
INCLUDE "maps/LavenderTownSpeechHouse.asm"
INCLUDE "maps/LavenderNameRater.asm"
INCLUDE "maps/LavenderMart.asm"
INCLUDE "maps/SoulHouse.asm"
INCLUDE "maps/LavRadioTower1F.asm"
INCLUDE "maps/Route8SaffronGate.asm"
INCLUDE "maps/Route12SuperRodHouse.asm"


SECTION "bank20",ROMX,BANK[$20]


DoPlayerMovement: ; 80000

	call GetMovementInput
	ld a, $3e ; standing
	ld [MovementAnimation], a
	xor a
	ld [$d041], a
	call GetPlayerMovement
	ld c, a
	ld a, [MovementAnimation]
	ld [$c2de], a
	ret
; 80017


GetMovementInput: ; 80017

	ld a, [hJoyDown]
	ld [CurInput], a

; Standing downhill instead moves down.

	ld hl, BikeFlags
	bit 2, [hl] ; downhill
	ret z

	ld c, a
	and $f0
	ret nz

	ld a, c
	or D_DOWN
	ld [CurInput], a
	ret
; 8002d


GetPlayerMovement: ; 8002d

	ld a, [PlayerState]
	cp PLAYER_NORMAL
	jr z, .Normal
	cp PLAYER_SURF
	jr z, .Surf
	cp PLAYER_SURF_PIKA
	jr z, .Surf
	cp PLAYER_BIKE
	jr z, .Normal
	cp PLAYER_SLIP
	jr z, .Board

.Normal
	call CheckForcedMovementInput
	call GetMovementAction
	call CheckTileMovement
	ret c
	call CheckTurning
	ret c
	call TryStep
	ret c
	call TryJumpLedge
	ret c
	call CheckEdgeWarp
	ret c
	jr .NotMoving

.Surf
	call CheckForcedMovementInput
	call GetMovementAction
	call CheckTileMovement
	ret c
	call CheckTurning
	ret c
	call TrySurfStep
	ret c
	jr .NotMoving

.Board
	call CheckForcedMovementInput
	call GetMovementAction
	call CheckTileMovement
	ret c
	call CheckTurning
	ret c
	call TryStep
	ret c
	call TryJumpLedge
	ret c
	call CheckEdgeWarp
	ret c
	ld a, [WalkingDirection]
	cp STANDING
	jr z, .HitWall
	call PlayBump
.HitWall
	call StandInPlace
	xor a
	ret

.NotMoving
	ld a, [WalkingDirection]
	cp STANDING
	jr z, .Standing

; Walking into an edge warp won't bump.
	ld a, [$d041]
	and a
	jr nz, .CantMove
	call PlayBump
.CantMove
	call WalkInPlace
	xor a
	ret

.Standing
	call StandInPlace
	xor a
	ret
; 800b7


CheckTileMovement: ; 800b7
; Tiles such as waterfalls and warps move the player
; in a given direction, overriding input.

	ld a, [StandingTile]
	ld c, a
	call CheckWhirlpoolTile
	jr c, .asm_800c4
	ld a, 3
	scf
	ret

.asm_800c4
	and $f0
	cp $30 ; moving water
	jr z, .water
	cp $40 ; moving land 1
	jr z, .land1
	cp $50 ; moving land 2
	jr z, .land2
	cp $70 ; warps
	jr z, .warps
	jr .asm_8013c

.water
	ld a, c
	and 3
	ld c, a
	ld b, 0
	ld hl, .water_table
	add hl, bc
	ld a, [hl]
	ld [WalkingDirection], a
	jr .asm_8013e

.water_table
	db RIGHT
	db LEFT
	db UP
	db DOWN

.land1
	ld a, c
	and 7
	ld c, a
	ld b, 0
	ld hl, .land1_table
	add hl, bc
	ld a, [hl]
	cp STANDING
	jr z, .asm_8013c
	ld [WalkingDirection], a
	jr .asm_8013e

.land1_table
	db STANDING
	db RIGHT
	db LEFT
	db UP
	db DOWN
	db STANDING
	db STANDING
	db STANDING

.land2
	ld a, c
	and 7
	ld c, a
	ld b, 0
	ld hl, .land2_table
	add hl, bc
	ld a, [hl]
	cp STANDING
	jr z, .asm_8013c
	ld [WalkingDirection], a
	jr .asm_8013e

.land2_table
	db RIGHT
	db LEFT
	db UP
	db DOWN
	db STANDING
	db STANDING
	db STANDING
	db STANDING

.warps
	ld a, c
	cp $71 ; door
	jr z, .down
	cp $79
	jr z, .down
	cp $7a ; stairs
	jr z, .down
	cp $7b ; cave
	jr nz, .asm_8013c

.down
	ld a, DOWN
	ld [WalkingDirection], a
	jr .asm_8013e

.asm_8013c
	xor a
	ret

.asm_8013e
	ld a, STEP_WALK
	call DoStep
	ld a, 5
	scf
	ret
; 80147


CheckTurning: ; 80147
; If the player is turning, change direction first. This also lets
; the player change facing without moving by tapping a direction.

	ld a, [$d04e]
	cp 0
	jr nz, .asm_80169
	ld a, [WalkingDirection]
	cp STANDING
	jr z, .asm_80169

	ld e, a
	ld a, [PlayerDirection]
	rrca
	rrca
	and 3
	cp e
	jr z, .asm_80169

	ld a, STEP_TURN
	call DoStep
	ld a, 2
	scf
	ret

.asm_80169
	xor a
	ret
; 8016b


TryStep: ; 8016b

; Surfing actually calls TrySurfStep directly instead of passing through here.
	ld a, [PlayerState]
	cp PLAYER_SURF
	jr z, TrySurfStep
	cp PLAYER_SURF_PIKA
	jr z, TrySurfStep

	call CheckLandPermissions
	jr c, .asm_801be

	call Function80341
	and a
	jr z, .asm_801be
	cp 2
	jr z, .asm_801be

	ld a, [StandingTile]
	call CheckIceTile
	jr nc, .ice

; Downhill riding is slower when not moving down.
	call CheckRiding
	jr nz, .asm_801ae

	ld hl, BikeFlags
	bit 2, [hl] ; downhill
	jr z, .fast

	ld a, [WalkingDirection]
	cp DOWN
	jr z, .fast

	ld a, STEP_WALK
	call DoStep
	scf
	ret

.fast
	ld a, STEP_BIKE
	call DoStep
	scf
	ret

.asm_801ae
	ld a, STEP_WALK
	call DoStep
	scf
	ret

.ice
	ld a, STEP_ICE
	call DoStep
	scf
	ret

; unused?
	xor a
	ret

.asm_801be
	xor a
	ret
; 801c0


TrySurfStep: ; 801c0

	call CheckWaterPermissions
	ld [MartPointer], a
	jr c, .asm_801f1

	call Function80341
	ld [CurFruit], a
	and a
	jr z, .asm_801f1
	cp 2
	jr z, .asm_801f1

	ld a, [MartPointer]
	and a
	jr nz, .ExitWater

	ld a, STEP_WALK
	call DoStep
	scf
	ret

.ExitWater
	call WaterToLandSprite
	call Function3cdf ; PlayMapMusic
	ld a, STEP_WALK
	call DoStep
	ld a, 6
	scf
	ret

.asm_801f1
	xor a
	ret
; 801f3


TryJumpLedge: ; 801f3
	ld a, [StandingTile]
	ld e, a
	and $f0
	cp $a0 ; ledge
	jr nz, .DontJump

	ld a, e
	and 7
	ld e, a
	ld d, 0
	ld hl, .data_8021e
	add hl, de
	ld a, [FacingDirection]
	and [hl]
	jr z, .DontJump

	ld de, SFX_JUMP_OVER_LEDGE
	call StartSFX
	ld a, STEP_LEDGE
	call DoStep
	ld a, 7
	scf
	ret

.DontJump
	xor a
	ret

.data_8021e
	db FACE_RIGHT
	db FACE_LEFT
	db FACE_UP
	db FACE_DOWN
	db FACE_RIGHT | FACE_DOWN
	db FACE_DOWN | FACE_LEFT
	db FACE_UP | FACE_RIGHT
	db FACE_UP | FACE_LEFT
; 80226


CheckEdgeWarp: ; 80226

; Bug: Since no case is made for STANDING here, it will check
; [.edgewarps + $ff]. This resolves to $3e at $8035a.
; This causes $d041 to be nonzero when standing on tile $3e,
; making bumps silent.

	ld a, [WalkingDirection]
	ld e, a
	ld d, 0
	ld hl, .EdgeWarps
	add hl, de
	ld a, [StandingTile]
	cp [hl]
	jr nz, .asm_80259

	ld a, 1
	ld [$d041], a
	ld a, [WalkingDirection]
	cp STANDING
	jr z, .asm_80259

	ld e, a
	ld a, [PlayerDirection]
	rrca
	rrca
	and 3
	cp e
	jr nz, .asm_80259
	call Function224a ; CheckFallPit?
	jr nc, .asm_80259

	call StandInPlace
	scf
	ld a, 1
	ret

.asm_80259
	xor a
	ret

.EdgeWarps
	db $70, $78, $76, $7e
; 8025f


DoStep: ; 8025f
	ld e, a
	ld d, 0
	ld hl, .Steps
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [WalkingDirection]
	ld e, a
	cp STANDING
	jp z, StandInPlace

	add hl, de
	ld a, [hl]
	ld [MovementAnimation], a

	ld hl, .WalkInPlace
	add hl, de
	ld a, [hl]
	ld [$d04e], a

	ld a, 4
	ret

.Steps
	dw .Slow
	dw .Walk
	dw .Bike
	dw .Ledge
	dw .Ice
	dw .Turn
	dw .BackwardsLedge
	dw .WalkInPlace

.Slow
	db $08, $09, $0a, $0b
.Walk
	db $0c, $0d, $0e, $0f
.Bike
	db $10, $11, $12, $13
.Ledge
	db $30, $31, $32, $33
.Ice
	db $1c, $1d, $1e, $1f
.BackwardsLedge
	db $31, $30, $33, $32
.Turn
	db $04, $05, $06, $07
.WalkInPlace
	db $80, $81, $82, $83
; 802b3


StandInPlace: ; 802b3
	ld a, 0
	ld [$d04e], a
	ld a, $3e ; standing
	ld [MovementAnimation], a
	xor a
	ret
; 802bf


WalkInPlace: ; 802bf
	ld a, 0
	ld [$d04e], a
	ld a, $50 ; walking
	ld [MovementAnimation], a
	xor a
	ret
; 802cb


CheckForcedMovementInput: ; 802cb
; When sliding on ice, input is forced to remain in the same direction.

	call Function80404
	ret nc

	ld a, [$d04e]
	cp 0
	ret z

	and 3
	ld e, a
	ld d, 0
	ld hl, .data_802e8
	add hl, de
	ld a, [CurInput]
	and BUTTON_A | BUTTON_B | SELECT | START
	or [hl]
	ld [CurInput], a
	ret

.data_802e8
	db D_DOWN, D_UP, D_LEFT, D_RIGHT
; 802ec


GetMovementAction: ; 802ec
; Poll player input and update movement info.

	ld hl, .table
	ld de, .table2 - .table1
	ld a, [CurInput]
	bit 7, a
	jr nz, .down
	bit 6, a
	jr nz, .up
	bit 5, a
	jr nz, .left
	bit 4, a
	jr nz, .right
; Standing
	jr .update

.down 	add hl, de
.up   	add hl, de
.left 	add hl, de
.right	add hl, de

.update
	ld a, [hli]
	ld [WalkingDirection], a
	ld a, [hli]
	ld [FacingDirection], a
	ld a, [hli]
	ld [WalkingX], a
	ld a, [hli]
	ld [WalkingY], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	ld [WalkingTile], a
	ret

.table
; struct:
;	walk direction
;	facing
;	x movement
;	y movement
;	tile collision pointer
.table1
	db STANDING, FACE_CURRENT, 0, 0
	dw StandingTile
.table2
	db RIGHT, FACE_RIGHT,  1,  0
	dw TileRight
	db LEFT,  FACE_LEFT,  -1,  0
	dw TileLeft
	db UP,    FACE_UP,     0, -1
	dw TileUp
	db DOWN,  FACE_DOWN,   0,  1
	dw TileDown
; 80341


Function80341: ; 80341

	ld a, 0
	ld [hConnectionStripLength], a
	ld a, [MapX]
	ld d, a
	ld a, [WalkingX]
	add d
	ld d, a
	ld a, [MapY]
	ld e, a
	ld a, [WalkingY]
	add e
	ld e, a
	ld bc, $d4d6
	callba Function7041
	jr nc, .asm_80369
	call Function8036f
	jr c, .asm_8036c

	xor a
	ret

.asm_80369
	ld a, 1
	ret

.asm_8036c
	ld a, 2
	ret
; 8036f


Function8036f: ; 8036f

	ld hl, BikeFlags
	bit 0, [hl]
	jr z, .asm_8039c

	ld hl, $0007
	add hl, bc
	ld a, [hl]
	cp $ff
	jr nz, .asm_8039c

	ld hl, $0006
	add hl, bc
	bit 6, [hl]
	jr z, .asm_8039c

	ld hl, $0005
	add hl, bc
	set 2, [hl]

	ld a, [WalkingDirection]
	ld d, a
	ld hl, $0020
	add hl, bc
	ld a, [hl]
	and $fc
	or d
	ld [hl], a

	scf
	ret

.asm_8039c
	xor a
	ret
; 8039e


CheckLandPermissions: ; 8039e
; Return 0 if walking onto land and tile permissions allow it.
; Otherwise, return carry.

	ld a, [TilePermissions]
	ld d, a
	ld a, [FacingDirection]
	and d
	jr nz, .NotWalkable

	ld a, [WalkingTile]
	call CheckWalkable
	jr c, .NotWalkable

	xor a
	ret

.NotWalkable
	scf
	ret
; 803b4

CheckWaterPermissions: ; 803b4
; Return 0 if moving in water, or 1 if moving onto land.
; Otherwise, return carry.

	ld a, [TilePermissions]
	ld d, a
	ld a, [FacingDirection]
	and d
	jr nz, .NotSurfable

	ld a, [WalkingTile]
	call CheckSurfable
	jr c, .NotSurfable

	and a
	ret

.NotSurfable
	scf
	ret
; 803ca


CheckRiding: ; 803ca

	ld a, [PlayerState]
	cp PLAYER_BIKE
	ret z
	cp PLAYER_SLIP
	ret
; 803d3


CheckWalkable: ; 803d3
; Return 0 if tile a is land. Otherwise, return carry.

	call GetTileCollision
	and a ; land
	ret z
	scf
	ret
; 803da


CheckSurfable: ; 803da
; Return 0 if tile a is water, or 1 if land.
; Otherwise, return carry.

	call GetTileCollision
	cp 1
	jr z, .Water

; Can walk back onto land from water.
	and a
	jr z, .Land

	jr .Neither

.Water
	xor a
	ret

.Land
	ld a, 1
	and a
	ret

.Neither
	scf
	ret
; 803ee


PlayBump: ; 803ee

	call CheckSFX
	ret c
	ld de, SFX_BUMP
	call StartSFX
	ret
; 803f9


WaterToLandSprite: ; 803f9
	push bc
	ld a, PLAYER_NORMAL
	ld [PlayerState], a
	call Functione4a ; UpdateSprites
	pop bc
	ret
; 80404


Function80404: ; 80404
	ld a, [$d04e]
	cp 0
	jr z, .asm_80420
	cp $f0
	jr z, .asm_80420
	ld a, [StandingTile]
	call CheckIceTile
	jr nc, .asm_8041e
	ld a, [PlayerState]
	cp PLAYER_SLIP
	jr nz, .asm_80420

.asm_8041e
	scf
	ret

.asm_80420
	and a
	ret
; 80422


Function80422: ; 80422
	ld hl, $c2de
	ld a, $3e ; standing
	cp [hl]
	ret z
	ld [hl], a
	ld a, 0
	ld [$d04e], a
	ret
; 80430



EngineFlagAction: ; 80430
; Do action b on engine flag de
;
;   b = 0: reset flag
;     = 1: set flag
;     > 1: check flag, result in c
;
; Setting/resetting does not return a result.


; 16-bit flag ids are considered invalid, but it's nice
; to know that the infrastructure is there.

	ld a, d
	cp 0
	jr z, .ceiling
	jr c, .read ; cp 0 can't set carry!
	jr .invalid
	
; There are only $a2 engine flags, so
; anything beyond that is invalid too.
	
.ceiling
	ld a, e
	cp $a2
	jr c, .read
	
; Invalid flags are treated as flag $00.
	
.invalid
	xor a
	ld e, a
	ld d, a
	
; Get this flag's location.
	
.read
	ld hl, EngineFlags
; location
	add hl, de
	add hl, de
; bit
	add hl, de
	
; location
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
; bit
	ld c, [hl]
	
; What are we doing with this flag?
	
	ld a, b
	cp 1
	jr c, .reset ; b = 0
	jr z, .set   ; b = 1
	
; Return the given flag in c.
.check
	ld a, [de]
	and c
	ld c, a
	ret
	
; Set the given flag.
.set
	ld a, [de]
	or c
	ld [de], a
	ret
	
; Reset the given flag.
.reset
	ld a, c
	cpl ; AND all bits except the one in question
	ld c, a
	ld a, [de]
	and c
	ld [de], a
	ret
; 80462


EngineFlags: ; 80462
INCLUDE "engine/engine_flags.asm"
; 80648


INCBIN "baserom.gbc", $80648, $80730-$80648

BattleText:
INCLUDE "text/battle.asm"

INCBIN "baserom.gbc", $818ac, $81fe3-$818ac

DebugColorTestGFX:
INCBIN "gfx/debug/color_test.2bpp"

INCBIN "baserom.gbc", $82153, $823c8-$82153


SECTION "bank21",ROMX,BANK[$21]

Function84000: ; 84000
	ld hl, OverworldMap
	ld bc, $040c
	xor a
	call Function842ab
	xor a
	ld [rSB], a
	ld [rSC], a
	ld [$c2d5], a
	ld hl, $c2d4
	set 0, [hl]
	ld a, [GBPrinter]
	ld [$cbfb], a
	xor a
	ld [$cf63], a
	ret
; 84022

Function84022: ; 84022
	ld a, [$cf63]
	ld e, a
	ld d, $0
	ld hl, $4031
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 84031

INCBIN "baserom.gbc", $84031, $842ab - $84031

Function842ab: ; 842ab
	push de
	ld e, a
.asm_842ad
	ld [hl], e
	inc hl
	dec bc
	ld a, c
	or b
	jr nz, .asm_842ad
	ld a, e
	pop de
	ret
; 842b7

INCBIN "baserom.gbc", $842b7, $842db - $842b7


Function842db: ; 842db
	ld a, [$c2d5]
	add a
	ld e, a
	ld d, $0
	ld hl, $42ea
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 842ea

INCBIN "baserom.gbc", $842ea, $843f0 - $842ea

Function843f0: ; 843f0
.asm_843f0
	call Functiona57
	call Function846f6
	jr c, .asm_8440f
	ld a, [$cf63]
	bit 7, a
	jr nz, .asm_8440d
	call Function84022
	call Function84757
	call Function84785
	call DelayFrame
	jr .asm_843f0

.asm_8440d
	and a
	ret

.asm_8440f
	scf
	ret
; 84411

Function84411: ; 84411
	xor a
	ld [$c2d4], a
	ld [$c2d5], a
	ret
; 84419

Function84419: ; 84419
	push af
	call Function84000
	pop af
	ld [$cbfa], a
	call Function84728
	ret
; 84425

Function84425: ; 84425
	call Function222a
	call Function84753
	ret
; 8442c

INCBIN "baserom.gbc", $8442c, $845d4 - $8442c

Function845d4: ; 845d4
	call Function845db
	call Function84425
	ret
; 845db

Function845db: ; 845db
	ld a, [$cf65]
	push af
	xor a
	ld [$ffac], a
	call Function8474c
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $9
	ld [rIE], a
	xor a
	ld [hBGMapMode], a
	ld a, $13
	call Function84419
	ld hl, $ff9e
	ld a, [hl]
	push af
	ld [hl], $4
	ld a, $9
	ld [$cf65], a
	call Function843f0
	pop af
	ld [$ff9e], a
	call Function84411
	call Function84735
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	pop af
	ld [$cf65], a
	ret
; 8461a

INCBIN "baserom.gbc", $8461a, $846f6 - $8461a

Function846f6: ; 846f6
	ld a, [hJoyDown]
	and $2
	jr nz, .asm_846fe
	and a
	ret

.asm_846fe
	ld a, [$ca80]
	cp $c
	jr nz, .asm_84722
.asm_84705
	ld a, [$c2d5]
	and a
	jr nz, .asm_84705
	ld a, $16
	ld [$c2d5], a
	ld a, $88
	ld [rSB], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
.asm_8471c
	ld a, [$c2d5]
	and a
	jr nz, .asm_8471c

.asm_84722
	ld a, $1
	ld [$ffac], a
	scf
	ret
; 84728

Function84728: ; 84728
	ld hl, TileMap
	ld de, $ca90
	ld bc, $0168
	call CopyBytes
	ret
; 84735

Function84735: ; 84735
	ld hl, $ca90
	ld de, TileMap
	ld bc, $0168
	call CopyBytes
	ret
; 84742

INCBIN "baserom.gbc", $84742, $8474c - $84742

Function8474c: ; 8474c
	ld de, $005b
	call StartMusic2
	ret
; 84753

Function84753: ; 84753
	call Function3d47
	ret
; 84757

Function84757: ; 84757
	ld a, [$ca88]
	cp $ff
	jr nz, .asm_84765
	ld a, [$ca89]
	cp $ff
	jr z, .asm_8477f

.asm_84765
	ld a, [$ca89]
	and $e0
	ret z
	bit 7, a
	jr nz, .asm_8477b
	bit 6, a
	jr nz, .asm_84777
	ld a, $6
	jr .asm_84781

.asm_84777
	ld a, $7
	jr .asm_84781

.asm_8477b
	ld a, $4
	jr .asm_84781

.asm_8477f
	ld a, $5

.asm_84781
	ld [$cbf8], a
	ret
; 84785

Function84785: ; 84785
	ld a, [$cbf8]
	and a
	ret z
	push af
	xor a
	ld [hBGMapMode], a
	ld hl, $c504
	ld bc, $0a12
	call TextBox
	pop af
	ld e, a
	ld d, $0
	ld hl, $4807
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $c52d
	ld a, $77
	call Function13d4
	ld hl, $c5ce
	ld de, $47f5
	call PlaceString
	ld a, $1
	ld [hBGMapMode], a
	xor a
	ld [$cbf8], a
	ret
; 847bd

INCBIN "baserom.gbc", $847bd, $84a2e - $847bd

FX00GFX:
FX01GFX: ; 84a2e
INCBIN "gfx/fx/001.lz"
; 84b15

INCBIN "baserom.gbc", $84b15, $84b1e - $84b15

FX02GFX: ; 84b1e
INCBIN "gfx/fx/002.lz"
; 84b7a

INCBIN "baserom.gbc", $84b7a, $84b7e - $84b7a

FX03GFX: ; 84b7e
INCBIN "gfx/fx/003.lz"
; 84bd0

INCBIN "baserom.gbc", $84bd0, $84bde - $84bd0

FX04GFX: ; 84bde
INCBIN "gfx/fx/004.lz"
; 84ca5

INCBIN "baserom.gbc", $84ca5, $84cae - $84ca5

FX05GFX: ; 84cae
INCBIN "gfx/fx/005.lz"
; 84de2

INCBIN "baserom.gbc", $84de2, $84dee - $84de2

FX07GFX: ; 84dee
INCBIN "gfx/fx/007.lz"
; 84e70

INCBIN "baserom.gbc", $84e70, $84e7e - $84e70

FX08GFX: ; 84e7e
INCBIN "gfx/fx/008.lz"
; 84ed4

INCBIN "baserom.gbc", $84ed4, $84ede - $84ed4

FX10GFX: ; 84ede
INCBIN "gfx/fx/010.lz"
; 84f13

INCBIN "baserom.gbc", $84f13, $84f1e - $84f13

FX09GFX: ; 84f1e
INCBIN "gfx/fx/009.lz"
; 85009

INCBIN "baserom.gbc", $85009, $8500e - $85009

FX12GFX: ; 8500e
INCBIN "gfx/fx/012.lz"
; 8506f

INCBIN "baserom.gbc", $8506f, $8507e - $8506f

FX06GFX: ; 8507e
INCBIN "gfx/fx/006.lz"
; 8515c

INCBIN "baserom.gbc", $8515c, $8515e - $8515c

FX11GFX: ; 8515e
INCBIN "gfx/fx/011.lz"
; 851ad

INCBIN "baserom.gbc", $851ad, $851ae - $851ad

FX13GFX: ; 851ae
INCBIN "gfx/fx/013.lz"
; 85243

INCBIN "baserom.gbc", $85243, $8524e - $85243

FX14GFX: ; 8524e
INCBIN "gfx/fx/014.lz"
; 852ff

INCBIN "baserom.gbc", $852ff, $8530e - $852ff

FX24GFX: ; 8530e
INCBIN "gfx/fx/024.lz"
; 8537c

INCBIN "baserom.gbc", $8537c, $8537e - $8537c

FX15GFX: ; 8537e
INCBIN "gfx/fx/015.lz"
; 8539a

INCBIN "baserom.gbc", $8539a, $8539e - $8539a

FX16GFX: ; 8539e
INCBIN "gfx/fx/016.lz"
; 8542d

INCBIN "baserom.gbc", $8542d, $8542e - $8542d

FX17GFX: ; 8542e
INCBIN "gfx/fx/017.lz"
; 85477

INCBIN "baserom.gbc", $85477, $8547e - $85477

FX18GFX: ; 8547e
INCBIN "gfx/fx/018.lz"
; 854eb

INCBIN "baserom.gbc", $854eb, $854ee - $854eb

FX19GFX: ; 854ee
INCBIN "gfx/fx/019.lz"
; 855a9

INCBIN "baserom.gbc", $855a9, $855ae - $855a9

FX20GFX: ; 855ae
INCBIN "gfx/fx/020.lz"
; 85627

INCBIN "baserom.gbc", $85627, $8562e - $85627

FX22GFX: ; 8562e
INCBIN "gfx/fx/022.lz"
; 856ec

INCBIN "baserom.gbc", $856ec, $856ee - $856ec

FX21GFX: ; 856ee
INCBIN "gfx/fx/021.lz"
; 85767

INCBIN "baserom.gbc", $85767, $8576e - $85767

FX23GFX: ; 8576e
INCBIN "gfx/fx/023.lz"
; 857d0

INCBIN "baserom.gbc", $857d0, $857de - $857d0

FX26GFX: ; 857de
INCBIN "gfx/fx/026.lz"
; 85838

INCBIN "baserom.gbc", $85838, $8583e - $85838

FX27GFX: ; 8583e
INCBIN "gfx/fx/027.lz"
; 858b0

INCBIN "baserom.gbc", $858b0, $858be - $858b0

FX28GFX: ; 858be
INCBIN "gfx/fx/028.lz"
; 85948

INCBIN "baserom.gbc", $85948, $8594e - $85948

FX29GFX: ; 8594e
INCBIN "gfx/fx/029.lz"
; 859a8

INCBIN "baserom.gbc", $859a8, $859ae - $859a8

FX30GFX: ; 859ae
INCBIN "gfx/fx/030.lz"
; 859ff

INCBIN "baserom.gbc", $859ff, $85a0e - $859ff

FX31GFX: ; 85a0e
INCBIN "gfx/fx/031.lz"
; 85ba1

INCBIN "baserom.gbc", $85ba1, $85bae - $85ba1

FX32GFX: ; 85bae
INCBIN "gfx/fx/032.lz"
; 85d09

INCBIN "baserom.gbc", $85d09, $85d0e - $85d09

FX33GFX: ; 85d0e
INCBIN "gfx/fx/033.lz"
; 85def

INCBIN "baserom.gbc", $85def, $85dfe - $85def

FX34GFX: ; 85dfe
INCBIN "gfx/fx/034.lz"
; 85e96

INCBIN "baserom.gbc", $85e96, $85e9e - $85e96

FX25GFX: ; 85e9e
INCBIN "gfx/fx/025.lz"
; 85fb8

INCBIN "baserom.gbc", $85fb8, $85fbe - $85fb8

FX35GFX: ; 85fbe
INCBIN "gfx/fx/035.lz"
; 86099

INCBIN "baserom.gbc", $86099, $8609e - $86099

FX36GFX: ; 8609e
INCBIN "gfx/fx/036.lz"
; 86174

INCBIN "baserom.gbc", $86174, $8617e - $86174

FX37GFX: ; 8617e
INCBIN "gfx/fx/037.lz"
; 862eb

INCBIN "baserom.gbc", $862eb, $862ee - $862eb

FX38GFX: ; 862ee
INCBIN "gfx/fx/038.lz"
; 8637f

INCBIN "baserom.gbc", $8637f, $8638e - $8637f

FX39GFX: ; 8638e
INCBIN "gfx/fx/039.lz"
; 8640b

INCBIN "baserom.gbc", $8640b, $8640e - $8640b

HallOfFame3: ; 0x8640e
	call Function8648e
	ld a, [StatusFlags]
	push af
	ld a, $1
	ld [$c2cd], a
	call Function2ed3
	ld a, $1
	ld [$d4b5], a

	; Enable the Pokégear map to cycle through all of Kanto
	ld hl, StatusFlags
	set 6, [hl]

	ld a, $5
	ld hl, $4da0
	rst FarCall
	ld hl, $d95e
	ld a, [hl]
	cp $c8
	jr nc, .asm_86436 ; 0x86433 $1
	inc [hl]
.asm_86436
	ld a, $5
	ld hl, $4b85
	rst FarCall
	call Function8653f
	ld a, $5
	ld hl, $4b5f
	rst FarCall
	xor a
	ld [$c2cd], a
	call Function864c3
	pop af
	ld b, a
	ld a, $42
	ld hl, $5847
	rst FarCall
	ret
; 0x86455

Function86455: ; 86455
	ld a, $0
	ld [MusicFadeIDLo], a
	ld a, $0
	ld [MusicFadeIDHi], a
	ld a, $a
	ld [MusicFade], a
	ld a, $23
	ld hl, $4084
	rst FarCall
	xor a
	ld [VramState], a
	ld [$ffde], a
	ld a, $13
	ld hl, $68c2
	rst FarCall
	ld c, $8
	call DelayFrames
	call Function2ed3
	ld a, $2
	ld [$d4b5], a
	ld a, [StatusFlags]
	ld b, a
	ld a, $42
	ld hl, $5847
	rst FarCall
	ret
; 8648e

Function8648e: ; 8648e
	ld a, $0
	ld [MusicFadeIDLo], a
	ld a, $0
	ld [MusicFadeIDHi], a
	ld a, $a
	ld [MusicFade], a
	ld a, $23
	ld hl, $4084
	rst FarCall
	xor a
	ld [VramState], a
	ld [$ffde], a
	ld a, $13
	ld hl, $6881
	rst FarCall
	ld c, $64
	jp DelayFrames
; 864b4

Function864b4: ; 864b4
	push de
	ld de, $0000
	call StartMusic
	call DelayFrame
	pop de
	call StartMusic
	ret
; 864c3

Function864c3: ; 864c3
	xor a
	ld [$cf63], a
	call Function8671c
	jr c, .asm_864fb
	ld de, $0014
	call Function864b4
	xor a
	ld [$cf64], a
.asm_864d6
	ld a, [$cf64]
	cp $6
	jr nc, .asm_864fb
	ld hl, EnemyMoveEffect
	ld bc, $0010
	call AddNTimes
	ld a, [hl]
	cp $ff
	jr z, .asm_864fb
	push hl
	call Function865b5
	pop hl
	call Function8650c
	jr c, .asm_864fb
	ld hl, $cf64
	inc [hl]
	jr .asm_864d6

.asm_864fb
	call Function86810
	ld a, $4
	ld [MusicFade], a
	call Function4b6
	ld c, $8
	call DelayFrames
	ret
; 8650c

Function8650c: ; 8650c
	call Function86748
	ld de, $652c
	ld hl, $c4c9
	call PlaceString
	call WaitBGMap
	ld de, $c50a
	ld c, $6
	ld a, $49
	call Predef
	ld c, $3c
	call DelayFrames
	and a
	ret
; 8652c

INCBIN "baserom.gbc", $8652c, $8653f - $8652c


Function8653f: ; 8653f
	ld hl, OverworldMap
	ld bc, $0062
	xor a
	call ByteFill
	ld a, [$d95e]
	ld de, OverworldMap
	ld [de], a
	inc de
	ld hl, PartySpecies
	ld c, 0
.asm_86556
	ld a, [hli]
	cp $ff
	jr z, .asm_865b1
	cp EGG
	jr nz, .asm_86562
	inc c
	jr .asm_86556

.asm_86562
	push hl
	push de
	push bc
	ld a, c
	ld hl, PartyMon1Species
	ld bc, $0030
	call AddNTimes
	ld c, l
	ld b, h
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	ld hl, $0006
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld hl, $0015
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld hl, $001f
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	pop bc
	push bc
	ld a, c
	ld hl, PartyMon1Nickname
	ld bc, $000b
	call AddNTimes
	ld bc, $000a
	call CopyBytes
	pop bc
	inc c
	pop de
	ld hl, $0010
	add hl, de
	ld e, l
	ld d, h
	pop hl
	jr .asm_86556

.asm_865b1
	ld a, $ff
	ld [de], a
	ret
; 865b5

Function865b5: ; 865b5
	push hl
	call WhiteBGMap
	ld a, $13
	ld hl, $6906
	rst FarCall
	pop hl
	ld a, [hli]
	ld [TempMonSpecies], a
	ld [CurPartySpecies], a
	inc hl
	inc hl
	ld a, [hli]
	ld [TempMonDVs], a
	ld a, [hli]
	ld [$d124], a
	ld hl, TempMonDVs
	ld a, $2d
	call Predef
	ld hl, TileMap
	ld bc, $0168
	ld a, $7f
	call ByteFill
	ld de, $9310
	ld a, $3d
	call Predef
	ld a, $31
	ld [$ffad], a
	ld hl, $c51e
	ld bc, $0606
	ld a, $13
	call Predef
	ld a, $d0
	ld [hSCY], a
	ld a, $90
	ld [hSCX], a
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ld b, $1a
	call GetSGBLayout
	call Function32f9
	call Function86635
	xor a
	ld [$c2c6], a
	ld hl, TileMap
	ld bc, $0168
	ld a, $7f
	call ByteFill
	ld hl, $c50a
	call Function378b
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ld [hSCY], a
	call Function86643
	ret
; 86635

Function86635: ; 86635
.asm_86635
	ld a, [hSCX]
	cp $70
	ret z
	add $4
	ld [hSCX], a
	call DelayFrame
	jr .asm_86635
; 86643

Function86643: ; 86643
.asm_86643
	ld a, [hSCX]
	and a
	ret z
	dec a
	dec a
	ld [hSCX], a
	call DelayFrame
	jr .asm_86643
; 86650

INCBIN "baserom.gbc", $86650, $8671c - $86650


Function8671c: ; 8671c
	ld a, [$cf63]
	cp $1e
	jr nc, .asm_86746
	ld hl, $b2c0
	ld bc, $0062
	call AddNTimes
	ld a, $1
	call GetSRAMBank
	ld a, [hl]
	and a
	jr z, .asm_86743
	ld de, EnemyMoveAnimation
	ld bc, $0062
	call CopyBytes
	call CloseSRAM
	and a
	ret

.asm_86743
	call CloseSRAM

.asm_86746
	scf
	ret
; 86748

Function86748: ; 86748
	xor a
	ld [hBGMapMode], a
	ld a, [hli]
	ld [TempMonSpecies], a
	ld a, [hli]
	ld [TempMonID], a
	ld a, [hli]
	ld [$d115], a
	ld a, [hli]
	ld [TempMonDVs], a
	ld a, [hli]
	ld [$d124], a
	ld a, [hli]
	ld [TempMonLevel], a
	ld de, StringBuffer2
	ld bc, $000a
	call CopyBytes
	ld a, $50
	ld [$d090], a
	ld hl, TileMap
	ld bc, $0168
	ld a, $7f
	call ByteFill
	ld hl, TileMap
	ld bc, $0312
	call TextBox
	ld hl, $c590
	ld bc, $0412
	call TextBox
	ld a, [TempMonSpecies]
	ld [CurPartySpecies], a
	ld [$d265], a
	ld hl, TempMonDVs
	ld a, $2d
	call Predef
	xor a
	ld [$c2c6], a
	ld hl, $c50a
	call Function378b
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_867f8
	ld hl, $c5a5
	ld a, $74
	ld [hli], a
	ld [hl], $f2
	ld hl, $c5a7
	ld de, $d265
	ld bc, $8103
	call PrintNum
	call GetBasePokemonName
	ld hl, $c5ab
	call PlaceString
	ld a, $3
	ld [MonType], a
	callba GetGender
	ld a, $7f
	jr c, .asm_867e2
	ld a, $ef
	jr nz, .asm_867e2
	ld a, $f5

.asm_867e2
	ld hl, $c5b6
	ld [hli], a
	ld hl, $c5c0
	ld a, $f3
	ld [hli], a
	ld de, StringBuffer2
	call PlaceString
	ld hl, $c5e1
	call PrintLevel

.asm_867f8
	ld hl, $c5e7
	ld a, $73
	ld [hli], a
	ld a, $74
	ld [hli], a
	ld [hl], $f3
	ld hl, $c5ea
	ld de, TempMonID
	ld bc, $8205
	call PrintNum
	ret
; 86810

Function86810: ; 86810
	call WhiteBGMap
	ld hl, $9630
	ld de, $40d0
	ld bc, $3e01
	call Request2bpp
	ld hl, TileMap
	ld bc, $0168
	ld a, $7f
	call ByteFill
	callba GetPlayerBackpic
	ld a, $31
	ld [$ffad], a
	hlcoord 6, 6
	ld bc, $0606
	ld a, $13
	call Predef
	ld a, $d0
	ld [hSCY], a
	ld a, $90
	ld [hSCX], a
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ld [CurPartySpecies], a
	ld b, $1a
	call GetSGBLayout
	call Function32f9
	call Function86635
	xor a
	ld [$c2c6], a
	ld hl, TileMap
	ld bc, $0168
	ld a, $7f
	call ByteFill
	ld a, $22
	ld hl, $4840
	rst FarCall
	xor a
	ld [$ffad], a
	hlcoord 12, 5
	ld bc, $0707
	ld a, $13
	call Predef
	ld a, $c0
	ld [hSCX], a
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ld [hSCY], a
	call Function86643
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 2
	ld bc, $0809
	call TextBox
	hlcoord 0, 12
	ld bc, $0412
	call TextBox
	hlcoord 2, 4
	ld de, PlayerName
	call PlaceString
	hlcoord 1, 6
	ld a, $73
	ld [hli], a
	ld a, $74
	ld [hli], a
	ld [hl], $f3
	hlcoord 4, 6
	ld de, PlayerID
	ld bc, $8205
	call PrintNum
	hlcoord 1, 8
	ld de, .PlayTime
	call PlaceString
	hlcoord 3, 9
	ld de, GameTimeHours
	ld bc, $0203
	call PrintNum
	ld [hl], $63
	inc hl
	ld de, GameTimeMinutes
	ld bc, $8102
	call PrintNum
	call WaitBGMap
	callba Function26601
	ret
; 868ed

.PlayTime
	db "PLAY TIME@"
; 868f7


SECTION "bank22",ROMX,BANK[$22]

INCBIN "baserom.gbc", $88000, $88258 - $88000

MovePlayerPicRight: ; 88258
	hlcoord 6, 4
	ld de, 1
	jr MovePlayerPic

MovePlayerPicLeft: ; 88260
	hlcoord 13, 4
	ld de, -1
	; fallthrough

MovePlayerPic: ; 88266
; Move player pic at hl by de * 7 tiles.
	ld c, $8
.loop
	push bc
	push hl
	push de
	xor a
	ld [hBGMapMode], a
	ld bc, $0707
	ld a, $13
	call Predef
	xor a
	ld [hBGMapThird], a
	call WaitBGMap
	call DelayFrame
	pop de
	pop hl
	add hl, de
	pop bc
	dec c
	ret z
	push hl
	push bc
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	ld bc, $0707
	call ClearBox
	pop bc
	pop hl
	jr .loop
; 88297

ShowPlayerNamingChoices: ; 88297
	ld hl, ChrisNameMenuHeader
	ld a, [PlayerGender]
	bit 0, a
	jr z, .GotGender
	ld hl, KrisNameMenuHeader
.GotGender
	call LoadMenuDataHeader
	call Function1d81
	ld a, [$cfa9]
	dec a
	call Function1db8
	call Function1c17
	ret
; 882b5

ChrisNameMenuHeader: ; 882b5
	db $40 ; flags
	db 00, 00 ; start coords
	db 11, 10 ; end coords
	dw MenuData2_0x882be
	db 1 ; ????
	db 0 ; default option
; 882be

MenuData2_0x882be: ; 882be
	db $91 ; flags
	db 5 ; items
	db "NEW NAME@"
	db "CHRIS@"
	db "MAT@"
	db "ALLAN@"
	db "JON@"
	db 2 ; displacement
	db " NAME @" ; title
; 882e5

KrisNameMenuHeader: ; 882e5
	db $40 ; flags
	db 00, 00 ; start coords
	db 11, 10 ; end coords
	dw MenuData2_0x882ee
	db 1 ; ????
	db 0 ; default option
; 882ee

MenuData2_0x882ee: ; 882ee
	db $91 ; flags
	db 5 ; items
	db "NEW NAME@"
	db "KRIS@"
	db "AMANDA@"
	db "JUANA@"
	db "JODI@"
	db 2 ; displacement
	db " NAME @" ; title
; 88318

INCBIN "baserom.gbc", $88318, $8832c - $88318

GetPlayerIcon: ; 8832c
; Get the player icon corresponding to gender

; Male
	ld de, ChrisSpriteGFX
	ld b, BANK(ChrisSpriteGFX)
	
	ld a, [PlayerGender]
	bit 0, a
	jr z, .done
	
; Female
	ld de, KrisSpriteGFX
	ld b, BANK(KrisSpriteGFX)
	
.done
	ret
; 8833e


INCBIN "baserom.gbc", $8833e, $88825 - $8833e


GetPlayerBackpic: ; 88825
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_88830
	call GetKrisBackpic
	ret

.asm_88830
	ld hl, ChrisBackpic
	ld b, BANK(ChrisBackpic)
	ld de, $9310
	ld c, $31
	ld a, $40
	call Predef
	ret
; 88840

Function88840: ; 88840
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ld e, $0
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_88851
	ld e, $1

.asm_88851
	ld a, e
	ld [TrainerClass], a
	ld de, ChrisPic
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_88862
	ld de, KrisPic

.asm_88862
	ld hl, VTiles2
	ld b, $22
	ld c, $31
	call Get2bpp
	call WaitBGMap
	ld a, $1
	ld [hBGMapMode], a
	ret
; 88874



DrawIntroPlayerPic: ; 88874
; Draw the player pic at (6,4).

; Get class
	ld e, 0
	ld a, [PlayerGender]
	bit 0, a
	jr z, .GotClass
	ld e, 1
.GotClass
	ld a, e
	ld [TrainerClass], a

; Load pic
	ld de, ChrisPic
	ld a, [PlayerGender]
	bit 0, a
	jr z, .GotPic
	ld de, KrisPic
.GotPic
	ld hl, VTiles2
	ld b, BANK(ChrisPic)
	ld c, $31
	call Get2bpp

; Draw
	xor a
	ld [$ffad], a
	hlcoord 6, 4
	ld bc, $0707
	ld a, $13
	call Predef
	ret
; 888a9


ChrisPic: ; 888a9
INCBIN "baserom.gbc", $888a9, $88bb9 - $888a9
; 88bb9

KrisPic: ; 88bb9
INCBIN "baserom.gbc", $88bb9, $88ec9 - $88bb9
; 88ec9


GetKrisBackpic: ; 88ec9
; Kris's backpic is uncompressed.
	ld de, KrisBackpic
	ld hl, $9310
	ld bc, $2231
	call Get2bpp
	ret
; 88ed6

KrisBackpic: ; 88ed6


INCBIN "baserom.gbc", $88ed6, $89160 - $88ed6

Function89160: ; 89160
	push af
	ld a, $4
	call GetSRAMBank
	pop af
	ret
; 89168

INCBIN "baserom.gbc", $89168, $89193 - $89168

Function89193: ; 89193
	push de
	push hl
.asm_89195
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_89195
	pop hl
	pop de
	ret
; 8919e

INCBIN "baserom.gbc", $8919e, $891ab - $8919e

Function891ab: ; 891ab
	call Function89240
	callba Function104061
	call Function8923c
	ret
; 891b8

Function891b8: ; 891b8
	call Function8923c
	ld hl, TileMap
	ld a, $7f
	ld bc, $0168
	call ByteFill
	call DelayFrame
	ret
; 891ca

INCBIN "baserom.gbc", $891ca, $891de - $891ca

Function891de: ; 891de
	call Function8923c
	call ClearPalettes
	ld hl, AttrMap
	ld a, $7
	ld bc, $0168
	call ByteFill
	ld hl, TileMap
	ld a, $7f
	ld bc, $0168
	call ByteFill
	call Function891ab
	ret
; 891fe

Function891fe: ; 891fe
	push bc
	call Function891de
	ld c, $10
	call DelayFrames
	pop bc
	ret
; 89209

Function89209: ; 89209
	ld a, $1
	ld [$c2ce], a
	ret
; 8920f

Function8920f: ; 8920f
	ld a, $0
	ld [$c2ce], a
	ret
; 89215

Function89215: ; 89215
	push hl
	push bc
	ld bc, $0939
	add hl, bc
	ld [hl], a
	pop bc
	pop hl
	ret
; 8921f

INCBIN "baserom.gbc", $8921f, $8923c - $8921f

Function8923c: ; 8923c
	xor a
	ld [hBGMapMode], a
	ret
; 89240

Function89240: ; 89240
	ld a, $1
	ld [hBGMapMode], a
	ret
; 89245

INCBIN "baserom.gbc", $89245, $89259 - $89245

Function89259: ; 89259
	ld bc, $0e07
	jr Function89261

Function8925e: ; 8925e
	ld bc, $0e0c

Function89261: ; 89261
	push af
	push bc
	ld hl, $52a3
	call Function1d3c
	pop bc
	ld hl, $cf82
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, c
	add $4
	ld [hli], a
	ld a, b
	add $5
	ld [hl], a
	pop af
	ld [$cf88], a
	call Function1c00
	call Function8923c
	call Function89209
	call Function1d81
	push af
	ld c, $a
	call DelayFrames
	call Function1c17
	call Function8920f
	pop af
	jr c, .asm_892a1
	ld a, [$cfa9]
	cp $2
	jr z, .asm_892a1
	and a
	ret

.asm_892a1
	scf
	ret
; 892a3

INCBIN "baserom.gbc", $892a3, $892b7 - $892a3

Function892b7: ; 892b7
	ld d, b
	ld e, c
	ld hl, $0000
	add hl, bc
	ld a, $50
	ld bc, $0006
	call ByteFill
	ld b, d
	ld c, e
	ld hl, $0006
	add hl, bc
	ld a, $50
	ld bc, $0006
	call ByteFill
	ld b, d
	ld c, e
	ld hl, $000c
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, $000e
	add hl, bc
	ld [hli], a
	ld [hl], a
	ld hl, $0010
	add hl, bc
	ld [hl], a
	ld hl, $0011
	add hl, bc
	ld a, $ff
	ld bc, $0008
	call ByteFill
	ld b, d
	ld c, e
	ld e, $6
	ld hl, $0019
	add hl, bc
.asm_892fb
	ld a, $ff
	ld [hli], a
	ld a, $ff
	ld [hli], a
	dec e
	jr nz, .asm_892fb
	ret
; 89305

INCBIN "baserom.gbc", $89305, $8931b - $89305

Function8931b: ; 8931b
	push hl
	ld hl, $a03b
	ld a, [MenuSelection]
	dec a
	ld bc, $0025
	call AddNTimes
	ld b, h
	ld c, l
	pop hl
	ret
; 8932d

Function8932d: ; 8932d
	ld hl, $0000
	add hl, bc

Function89331: ; 89331
	push bc
	ld c, $5
.asm_89334
	ld a, [hli]
	cp $50
	jr z, .asm_89340
	cp $7f
	jr nz, .asm_89343
	dec c
	jr nz, .asm_89334

.asm_89340
	scf
	jr .asm_89344

.asm_89343
	and a

.asm_89344
	pop bc
	ret
; 89346

INCBIN "baserom.gbc", $89346, $8934a - $89346

Function8934a: ; 8934a
	ld hl, $0006
	add hl, bc
	push bc
	ld c, $5
.asm_89351
	ld a, [hli]
	cp $50
	jr z, .asm_8935d
	cp $7f
	jr nz, .asm_89360
	dec c
	jr nz, .asm_89351

.asm_8935d
	scf
	jr .asm_89361

.asm_89360
	and a

.asm_89361
	pop bc
	ret
; 89363

Function89363: ; 89363
	ld h, b
	ld l, c
	jr .asm_8936b

	ld hl, $0019
	add hl, bc

.asm_8936b
	push de
	ld e, $6
.asm_8936e
	ld a, [hli]
	cp $ff
	jr nz, .asm_8937e
	ld a, [hli]
	cp $ff
	jr nz, .asm_8937e
	dec e
	jr nz, .asm_8936e
	scf
	jr .asm_8937f

.asm_8937e
	and a

.asm_8937f
	pop de
	ret
; 89381

Function89381: ; 89381
	push bc
	push de
	call Function89b45
	jr c, .asm_89392
	push hl
	ld a, $ff
	ld bc, $0008
	call ByteFill
	pop hl

.asm_89392
	pop de
	ld c, $8
	call Function89193
	pop bc
	ret
; 8939a

Function8939a: ; 8939a
	push bc
	ld hl, $0000
	add hl, bc
	ld de, DefaultFlypoint
	ld c, $6
	call Function89193
	pop bc
	ld hl, $0011
	add hl, bc
	ld de, $d008
	call Function89381
	ret
; 893b3

INCBIN "baserom.gbc", $893b3, $893cc - $893b3

Function893cc: ; 893cc
	call DisableLCD
	call ClearSprites
	call Functione51
	call Functione5f
	call Function893ef
	call Function89464
	call EnableLCD
	ret
; 893e2

INCBIN "baserom.gbc", $893e2, $893ef - $893e2

Function893ef: ; 893ef
	ld de, VTiles0
	ld hl, $540b
	ld bc, $0020
	ld a, $22
	call FarCopyBytes
	ret
; 893fe

INCBIN "baserom.gbc", $893fe, $89464 - $893fe

Function89464: ; 89464
	ld hl, $59ef
	ld de, VTiles2
	ld bc, $0200
	ld a, $5e
	call FarCopyBytes
	ld hl, $604f
	ld de, $9200
	ld bc, $0170
	ld a, $5e
	call FarCopyBytes
	ret
; 89481

Function89481: ; 89481
	ld d, $2
	call Function8934a
	ret c
	ld d, $0
	ld hl, $0010
	add hl, bc
	bit 0, [hl]
	ret z
	inc d
	ret
; 89492

INCBIN "baserom.gbc", $89492, $8949c - $89492

Function8949c: ; 8949c
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, $54b3
	ld de, $d038
	ld bc, $0008
	call CopyBytes
	pop af
	ld [rSVBK], a
	ret
; 894b3

INCBIN "baserom.gbc", $894b3, $894bb - $894b3

Function894bb: ; 894bb
	call Function894dc
	push bc
	call Function8956f
	call Function8949c
	call Function8a60d
	pop bc
	ret
; 894ca

INCBIN "baserom.gbc", $894ca, $894dc - $894ca

Function894dc: ; 894dc
	push bc
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld c, d
	ld b, $0
	ld hl, $5509
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, Unkn1Pals
	ld bc, $0018
	call CopyBytes
	ld hl, $5557
	ld de, $d018
	ld bc, $0018
	call CopyBytes
	pop af
	ld [rSVBK], a
	pop bc
	ret
; 89509

INCBIN "baserom.gbc", $89509, $8956f - $89509

Function8956f: ; 8956f
	push bc
	ld hl, $0010
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $000c
	add hl, bc
	ld b, h
	ld c, l
	callba Function4e929
	ld a, c
	ld [TrainerClass], a
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, $d030
	ld a, $ff
	ld [hli], a
	ld a, $7f
	ld [hl], a
	pop af
	ld [rSVBK], a
	ld a, [TrainerClass]
	ld h, $0
	ld l, a
	add hl, hl
	add hl, hl
	ld de, $70ce
	add hl, de
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld de, $d032
	ld c, $4
.asm_895b1
	ld a, $2
	call GetFarByte
	ld [de], a
	inc de
	inc hl
	dec c
	jr nz, .asm_895b1
	ld hl, $d036
	xor a
	ld [hli], a
	ld [hl], a
	pop af
	ld [rSVBK], a
	pop bc
	ret
; 895c7

INCBIN "baserom.gbc", $895c7, $895f2 - $895c7

Function895f2: ; 895f2
	push bc
	xor a
	ld hl, AttrMap
	ld bc, $0168
	call ByteFill
	call Function89605
	call Function89655
	pop bc
	ret
; 89605

Function89605: ; 89605
	ld hl, $ce14
	ld a, $1
	ld de, $0014
	ld c, $e
.asm_8960f
	ld [hl], a
	dec c
	jr z, .asm_8961b
	add hl, de
	inc a
	ld [hl], a
	dec a
	add hl, de
	dec c
	jr nz, .asm_8960f

.asm_8961b
	ld hl, $cf19
	ld c, $a
	ld a, $2
.asm_89622
	ld [hli], a
	dec a
	ld [hli], a
	inc a
	dec c
	jr nz, .asm_89622
	ld hl, $ceb6
	ld a, $4
	ld bc, $0004
	call ByteFill
	ld a, $5
	ld bc, $000e
	call ByteFill
	ret
; 8963d

Function8963d: ; 8963d
	ld hl, $ce21
	ld a, $6
	ld de, $0014
	ld bc, $0707
.asm_89648
	push hl
	ld c, $7
.asm_8964b
	ld [hli], a
	dec c
	jr nz, .asm_8964b
	pop hl
	add hl, de
	dec b
	jr nz, .asm_89648
	ret
; 89655

Function89655: ; 89655
	ld hl, $ceca
	ld de, $0014
	ld a, $5
	ld b, $4
.asm_8965f
	ld c, $12
	push hl
.asm_89662
	ld [hli], a
	dec c
	jr nz, .asm_89662
	pop hl
	add hl, de
	dec b
	jr nz, .asm_8965f
	ret
; 8966c

Function8966c: ; 8966c
	push bc
	call Function89688
	ld hl, $c4a4
	ld c, $8
	call Function896f5
	pop bc
	ret
; 8967a

INCBIN "baserom.gbc", $8967a, $89688 - $8967a

Function89688: ; 89688
	ld hl, TileMap
	ld a, $1
	ld e, $14
	call Function896e1
	ld a, $2
	ld e, $14
	call Function896eb
	ld a, $3
	ld [hli], a
	ld a, $4
	ld e, $12
	call Function896e1
	ld a, $6
	ld [hli], a
	push bc
	ld c, $d
.asm_896a9
	call Function896cb
	dec c
	jr z, .asm_896b5
	call Function896d6
	dec c
	jr nz, .asm_896a9

.asm_896b5
	pop bc
	ld a, $19
	ld [hli], a
	ld a, $1a
	ld e, $12
	call Function896e1
	ld a, $1c
	ld [hli], a
	ld a, $2
	ld e, $14
	call Function896eb
	ret
; 896cb

Function896cb: ; 896cb
	ld de, $0013
	ld a, $7
	ld [hl], a
	add hl, de
	ld a, $9
	ld [hli], a
	ret
; 896d6

Function896d6: ; 896d6
	ld de, $0013
	ld a, $a
	ld [hl], a
	add hl, de
	ld a, $b
	ld [hli], a
	ret
; 896e1

Function896e1: ; 896e1
.asm_896e1
	ld [hli], a
	inc a
	dec e
	ret z
	ld [hli], a
	dec a
	dec e
	jr nz, .asm_896e1
	ret
; 896eb

Function896eb: ; 896eb
.asm_896eb
	ld [hli], a
	dec a
	dec e
	ret z
	ld [hli], a
	inc a
	dec e
	jr nz, .asm_896eb
	ret
; 896f5

Function896f5: ; 896f5
	call Function8971f
	call Function89736
	inc hl
	inc hl
	ld b, 2

ClearScreenArea: ; 0x896ff
; clears an area of the screen
; INPUT:
; hl = address of upper left corner of the area
; b = height
; c = width

	ld a, " " ; blank tile
	ld de, 20 ; screen width
.loop
	push bc
	push hl
.innerLoop
	ld [hli], a
	dec c
	jr nz, .innerLoop
	pop hl
	pop bc
	add hl, de
	dec b
	jr nz, .loop

	dec hl
	inc c
	inc c
.asm_89713
	ld a, $36
	ld [hli], a
	dec c
	ret z
	ld a, $18
	ld [hli], a
	dec c
	jr nz, .asm_89713 ; 0x8971c $f5
	ret
; 0x8971f

Function8971f: ; 8971f
	ld a, $2c
	ld [hli], a
	ld a, $2d
	ld [hld], a
	push hl
	ld de, $0014
	add hl, de
	ld a, $31
	ld [hli], a
	ld a, $32
	ld [hld], a
	add hl, de
	ld a, $35
	ld [hl], a
	pop hl
	ret
; 89736

Function89736: ; 89736
	push hl
	inc hl
	inc hl
	ld e, c
	ld d, $0
	add hl, de
	ld a, $2f
	ld [hli], a
	ld a, $30
	ld [hld], a
	ld de, $0014
	add hl, de
	ld a, $33
	ld [hli], a
	ld a, $34
	ld [hl], a
	add hl, de
	ld a, $1f
	ld [hl], a
	pop hl
	ret
; 89753

Function89753: ; 89753
	ld a, $c
	ld [hl], a
	xor a
	call Function89215
	ret
; 8975b

Function8975b: ; 8975b
	ld a, $1d
	ld [hli], a
	inc a
	ld [hli], a
	ld a, $d
	ld [hl], a
	dec hl
	dec hl
	ld a, $4
	ld e, $3
.asm_89769
	call Function89215
	inc hl
	dec e
	jr nz, .asm_89769
	ret
; 89771

Function89771: ; 89771
	ld a, $12
	ld [hl], a
	ld a, $3
	call Function89215
	ret
; 8977a

Function8977a: ; 8977a
	ld e, $4
	ld d, $13
.asm_8977e
	ld a, d
	ld [hl], a
	ld a, $4
	call Function89215
	inc hl
	inc d
	dec e
	jr nz, .asm_8977e
	ld e, $e
.asm_8978c
	ld a, d
	ld [hl], a
	xor a
	call Function89215
	inc hl
	dec e
	jr nz, .asm_8978c
	ret
; 89797

Function89797: ; 89797
	push bc
	ld a, $e
	ld [hl], a
	ld bc, $0014
	add hl, bc
	ld a, $11
	ld [hli], a
	ld a, $10
	ld c, $8
.asm_897a6
	ld [hli], a
	dec c
	jr nz, .asm_897a6
	ld a, $f
	ld [hl], a
	pop bc
	ret
; 897af

Function897af: ; 897af
	push bc
	ld hl, $0010
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $000c
	add hl, bc
	ld b, h
	ld c, l
	callba Function4e929
	ld a, c
	ld [TrainerClass], a
	xor a
	ld [CurPartySpecies], a
	ld de, $9370
	callba Function5120d
	pop bc
	ret
; 897d5

Function897d5: ; 897d5
	push bc
	call Function8934a
	jr nc, .asm_897f3
	ld hl, $ce21
	xor a
	ld de, $0014
	ld bc, $0707
.asm_897e5
	push hl
	ld c, $7
.asm_897e8
	ld [hli], a
	dec c
	jr nz, .asm_897e8
	pop hl
	add hl, de
	dec b
	jr nz, .asm_897e5
	pop bc
	ret

.asm_897f3
	ld a, $37
	ld [$ffad], a
	ld hl, $c4e8
	ld bc, $0707
	ld a, $13
	call Predef
	call Function8963d
	pop bc
	ret
; 89807

INCBIN "baserom.gbc", $89807, $89844 - $89807

Function89844: ; 89844
	call Function89481
	call Function894bb
	call Function897af
	push bc
	call Function3200
	call Function32f9
	pop bc
	ret
; 89856

Function89856: ; 89856
	push bc
	call Function891b8
	pop bc
	call Function895f2
	call Function8966c
	call Function899d3
	call Function898aa
	call Function898be
	call Function898dc
	call Function898f3
	push bc
	ld bc, $d008
	ld hl, $c56a
	call Function89975
	pop bc
	call Function897d5
	ret
; 8987f

INCBIN "baserom.gbc", $8987f, $898aa - $8987f

Function898aa: ; 898aa
	ld a, [MenuSelection]
	and a
	ret z
	push bc
	ld hl, $c4ba
	ld de, MenuSelection
	ld bc, $8102
	call PrintNum
	pop bc
	ret
; 898be

Function898be: ; 898be
	push bc
	ld de, DefaultFlypoint
	ld hl, DefaultFlypoint
	call Function89331
	jr nc, .asm_898cd
	ld de, $5116

.asm_898cd
	ld hl, $c4bd
	ld a, [MenuSelection]
	and a
	jr nz, .asm_898d7
	dec hl

.asm_898d7
	call PlaceString
	pop bc
	ret
; 898dc

Function898dc: ; 898dc
	ld hl, $0006
	add hl, bc
	push bc
	ld d, h
	ld e, l
	call Function8934a
	jr nc, .asm_898eb
	ld de, $5116

.asm_898eb
	ld hl, $c4f6
	call PlaceString
	pop bc
	ret
; 898f3

Function898f3: ; 898f3
	push bc
	ld hl, $000c
	add hl, bc
	ld d, h
	ld e, l
	call Function8934a
	jr c, .asm_8990a
	ld hl, $c509
	ld bc, $8205
	call PrintNum
	jr .asm_89913

.asm_8990a
	ld hl, $c509
	ld de, $5116
	call PlaceString

.asm_89913
	pop bc
	ret
; 89915

Function89915: ; 89915
	push bc
	push hl
	ld de, $5942
	ld c, $8
.asm_8991c
	ld a, [de]
	ld [hl], a
	ld a, $4
	call Function89215
	inc hl
	inc de
	dec c
	jr nz, .asm_8991c
	pop hl
	ld b, $4
	ld c, $2b
	ld a, $8
	ld de, $594a
.asm_89932
	push af
	ld a, [de]
	cp [hl]
	jr nz, .asm_8993b
	call Function8994e
	inc de

.asm_8993b
	inc hl
	pop af
	dec a
	jr nz, .asm_89932
	pop bc
	ret
; 89942

INCBIN "baserom.gbc", $89942, $8994e - $89942

Function8994e: ; 8994e
	push hl
	push de
	ld de, $0014
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	ld a, c
	ld [hl], a
	ld a, b
	call Function89215
	pop de
	pop hl
	ret
; 89962

Function89962: ; 89962
	push bc
	ld c, $4
	ld b, $20
.asm_89967
	ld a, b
	ld [hl], a
	ld a, $4
	call Function89215
	inc hl
	inc b
	dec c
	jr nz, .asm_89967
	pop bc
	ret
; 89975

Function89975: ; 89975
	push bc
	ld e, $8
.asm_89978
	ld a, [bc]
	ld d, a
	call Function8998b
	swap d
	inc hl
	ld a, d
	call Function8998b
	inc bc
	inc hl
	dec e
	jr nz, .asm_89978
	pop bc
	ret
; 8998b

Function8998b: ; 8998b
	push bc
	and $f
	cp $a
	jr nc, .asm_89997
	ld c, $f6
	add c
	jr .asm_89999

.asm_89997
	ld a, $7f

.asm_89999
	ld [hl], a
	pop bc
	ret
; 8999c

INCBIN "baserom.gbc", $8999c, $899d3 - $8999c

Function899d3: ; 899d3
	ld hl, $c4f1
	call Function89753
	ld hl, $c506
	call Function8975b
	ld hl, $c555
	call Function89771
	ld hl, $c57d
	call Function8977a
	ld hl, $c505
	call Function89797
	ld hl, $c4f2
	call Function89962
	ld hl, $c556
	call Function89915
	ret
; 899fe

Function899fe: ; 899fe
	push bc
	push hl
	ld hl, $0019
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	call Function89a0c
	pop bc
	ret
; 89a0c

Function89a0c: ; 89a0c
	push hl
	call Function89363
	pop hl
	jr c, .asm_89a1c
	ld d, h
	ld e, l
	callba Function11c08f
	ret

.asm_89a1c
	ld de, $5153
	call PlaceString
	ret
; 89a23

INCBIN "baserom.gbc", $89a23, $89a57 - $89a23

Function89a57: ; 89a57
	call Function354b
	bit 6, c
	jr nz, .asm_89a78
	bit 7, c
	jr nz, .asm_89a81
	bit 0, c
	jr nz, .asm_89a70
	bit 1, c
	jr nz, .asm_89a70
	bit 3, c
	jr nz, .asm_89a74
	scf
	ret

.asm_89a70
	ld a, $1
	and a
	ret

.asm_89a74
	ld a, $2
	and a
	ret

.asm_89a78
	call Function89a9b
	call nc, Function89a8a
	ld a, $0
	ret

.asm_89a81
	call Function89a93
	call nc, Function89a8a
	ld a, $0
	ret
; 89a8a

Function89a8a: ; 89a8a
	push af
	ld de, $0062
	call StartSFX
	pop af
	ret
; 89a93

Function89a93: ; 89a93
	ld d, $28
	ld e, $1
	call Function89aa3
	ret
; 89a9b

Function89a9b: ; 89a9b
	ld d, $1
	ld e, $ff
	call Function89aa3
	ret
; 89aa3

Function89aa3: ; 89aa3
	ld a, [MenuSelection]
	ld c, a
	push bc
.asm_89aa8
	ld a, [MenuSelection]
	cp d
	jr z, .asm_89ac0
	add e
	jr nz, .asm_89ab2
	inc a

.asm_89ab2
	ld [MenuSelection], a
	call Function89ac7
	jr nc, .asm_89aa8
	call Function89ae6
	pop bc
	and a
	ret

.asm_89ac0
	pop bc
	ld a, c
	ld [MenuSelection], a
	scf
	ret
; 89ac7

Function89ac7: ; 89ac7
	call Function89160
	call Function8931b
	call Function89ad4
	call CloseSRAM
	ret
; 89ad4

Function89ad4: ; 89ad4
	push de
	call Function8932d
	jr c, .asm_89ae3
	ld hl, $0011
	add hl, bc
	call Function89b45
	jr c, .asm_89ae4

.asm_89ae3
	and a

.asm_89ae4
	pop de
	ret
; 89ae6

Function89ae6: ; 89ae6
	ld hl, $d031
	xor a
	ld [hl], a
	ld a, [MenuSelection]
.asm_89aee
	cp $6
	jr c, .asm_89afc
	sub $5
	ld c, a
	ld a, [hl]
	add $5
	ld [hl], a
	ld a, c
	jr .asm_89aee

.asm_89afc
	ld [$d030], a
	ret
; 89b00

INCBIN "baserom.gbc", $89b00, $89b45 - $89b00

Function89b45: ; 89b45
	push hl
	push bc
	ld c, $10
	ld e, $0
.asm_89b4b
	ld a, [hli]
	ld b, a
	and $f
	cp $a
	jr c, .asm_89b5a
	ld a, c
	cp $b
	jr nc, .asm_89b74
	jr .asm_89b71

.asm_89b5a
	dec c
	swap b
	inc e
	ld a, b
	and $f
	cp $a
	jr c, .asm_89b6c
	ld a, c
	cp $b
	jr nc, .asm_89b74
	jr .asm_89b71

.asm_89b6c
	inc e
	dec c
	jr nz, .asm_89b4b
	dec e

.asm_89b71
	scf
	jr .asm_89b75

.asm_89b74
	and a

.asm_89b75
	pop bc
	pop hl
	ret
; 89b78

INCBIN "baserom.gbc", $89b78, $8a60d - $89b78

Function8a60d: ; 8a60d
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, $6624
	ld de, Unkn2Pals
	ld bc, $0008
	call CopyBytes
	pop af
	ld [rSVBK], a
	ret
; 8a624

INCBIN "baserom.gbc", $8a624, $8ac4e - $8a624

Function8ac4e: ; 8ac4e
	xor a
	ld [MenuSelection], a
	push de
	call Function891de
	call WhiteBGMap
	call Function893cc
	pop bc
	call Function89844
	call Function8939a
	call Function89856
	ld hl, $c5a5
	call Function899fe
	call Function891ab
	ret
; 8ac70

Function8ac70: ; 8ac70
	push de
	ld a, $3
	call Function8b94a

Function8ac76: ; 8ac76
	call Function891fe
	call Function8b677

Function8ac7c: ; 8ac7c
	call Function8b7bd
	jr z, .asm_8acf0
	ld a, c
	ld [$d02f], a
	ld [MenuSelection], a
	call Function89160
	call Function8931b
	call Function8932d
	call CloseSRAM
	jr nc, .asm_8acb0
	call Function89160
	ld hl, $0011
	add hl, bc
	call Function89b45
	call CloseSRAM
	jr nc, .asm_8accc
	call Function89160
	call Function892b7
	call CloseSRAM
	jr .asm_8accc

.asm_8acb0
	call Function8ad0b
	jr c, Function8ac76
	and a
	jr nz, .asm_8accc
	call Function89160
	ld h, b
	ld l, c
	ld d, $0
	ld e, $6
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld c, $1f
	call Function89193
	jr .asm_8ace4

.asm_8accc
	pop hl
	call Function89160
	ld d, b
	ld e, c
	ld c, $6
	call Function89193
	ld a, $6
	add e
	ld e, a
	ld a, $0
	adc d
	ld d, a
	ld c, $1f
	call Function89193

.asm_8ace4
	call CloseSRAM
	call Functione51
	ld a, [$d02f]
	ld c, a
	and a
	ret

.asm_8acf0
	ld hl, $6d06
	call PrintText
	ld a, $2
	call Function89259
	jp c, Function8ac7c
	call Functione51
	pop de
	ld c, $0
	scf
	ret
; 8ad06

INCBIN "baserom.gbc", $8ad06, $8ad0b - $8ad06

Function8ad0b: ; 8ad0b
.asm_8ad0b
	ld a, [MenuSelection]
	ld [$d02f], a
	call Function891de
	call WhiteBGMap
	call Function893cc
	call Function89160
	call Function8931b
	push bc
	call Function89844
	call Function8939a
	call Function89856
	ld hl, $c5a5
	call Function899fe
	call CloseSRAM
	call Function891ab
	pop bc
.asm_8ad37
	push bc
	call Function89a57
	pop bc
	jr c, .asm_8ad37
	and a
	jr z, .asm_8ad0b
	cp $2
	jr z, .asm_8ad37
	call Function8923c
	push bc
	ld hl, $c590
	ld b, $4
	ld c, $12
	call TextBox
	ld de, $6d89
	ld hl, $c5b9
	call PlaceString
	ld a, $2
	call Function8925e
	jr c, .asm_8ad87
	call Function8923c
	ld hl, $c590
	ld b, $4
	ld c, $12
	call TextBox
	ld de, $6d9c
	ld hl, $c5b9
	call PlaceString
	ld a, $1
	call Function8925e
	jr c, .asm_8ad84
	ld a, $0
	jr .asm_8ad86

.asm_8ad84
	ld a, $1

.asm_8ad86
	and a

.asm_8ad87
	pop bc
	ret
; 8ad89

INCBIN "baserom.gbc", $8ad89, $8addb - $8ad89

SpecialHoOhChamber: ; 0x8addb
	ld hl, PartySpecies
	ld a, [hl]
	cp HO_OH ; is Ho-oh the first Pokémon in the party?
	jr nz, .done ; if not, we're done
	call GetSecondaryMapHeaderPointer
	ld de, $0326
	ld b, SET_FLAG
	call EventFlagAction
.done
	ret
; 0x8adef

Function8adef: ; 8adef
	call GetSecondaryMapHeaderPointer
	ld de, $0328
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	jr nz, .asm_8ae2f

	ld a, WATER_STONE
	ld [CurItem], a
	ld hl, NumItems
	call PickUpItem
	jr c, .asm_8ae24

	ld a, [PartyCount]
	ld b, a
	inc b
.asm_8ae10
	dec b
	jr z, .asm_8ae2f
	ld a, b
	dec a
	ld [CurPartyMon], a
	push bc
	ld a, $1
	call GetPartyParamLocation
	pop bc
	ld a, [hl]
	cp $18
	jr nz, .asm_8ae10

.asm_8ae24
	call GetSecondaryMapHeaderPointer
	ld de, $0328
	ld b, SET_FLAG
	call EventFlagAction

.asm_8ae2f
	ret
; 8ae30

Function8ae30: ; 8ae30
	push de
	push bc

	call GetSecondaryMapHeaderPointer
	ld a, h
	cp RuinsofAlphAerodactylChamber_SecondMapHeader >> 8
	jr nz, .asm_8ae4a
	ld a, l
	cp RuinsofAlphAerodactylChamber_SecondMapHeader & $ff
	jr nz, .asm_8ae4a

	ld de, $0329
	ld b, SET_FLAG
	call EventFlagAction

	scf
	jr .done

.asm_8ae4a
	and a

.done
	pop bc
	pop de
	ret
; 8ae4e

Function8ae4e: ; 8ae4e
	push hl
	push de

	call GetSecondaryMapHeaderPointer
	ld a, h
	cp RuinsofAlphKabutoChamber_SecondMapHeader >> 8
	jr nz, .done
	ld a, l
	cp RuinsofAlphKabutoChamber_SecondMapHeader & $ff
	jr nz, .done

	ld de, $0327
	ld b, SET_FLAG
	call EventFlagAction

.done
	pop de
	pop hl
	ret
; 8ae68

INCBIN "baserom.gbc", $8ae68, $8b170 - $8ae68

SpecialDratini: ; 0x8b170
; if ScriptVar is 0 or 1, change the moveset of the last Dratini in the party.
;  0: give it a special moveset with Extremespeed.
;  1: give it the normal moveset of a level 15 Dratini.

	ld a, [ScriptVar]
	cp $2
	ret nc
	ld bc, PartyCount
	ld a, [bc]
	ld hl, 0
	call GetNthPartyMon
	ld a, [bc]
	ld c, a
	ld de, PartyMon2 - PartyMon1
.CheckForDratini
; start at the end of the party and search backwards for a Dratini
	ld a, [hl]
	cp DRATINI
	jr z, .GiveMoveset
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	dec c
	jr nz, .CheckForDratini
	ret

.GiveMoveset
	push hl
	ld a, [ScriptVar]
	ld hl, .Movesets
	ld bc, .Moveset1 - .Moveset0
	call AddNTimes

	; get address of mon's first move
	pop de
	inc de
	inc de

.GiveMoves
	ld a, [hl]
	and a ; is the move 00?
	ret z ; if so, we're done here

	push hl
	push de
	ld [de], a ; give the Pokémon the new move

	; get the PP of the new move
	dec a
	ld hl, Moves + PlayerMovePP - PlayerMoveStruct
	ld bc, Move2 - Move1
	call AddNTimes
	ld a, BANK(Moves)
	call GetFarByte

	; get the address of the move's PP and update the PP
	ld hl, PartyMon1PP - PartyMon1Moves
	add hl, de
	ld [hl], a

	pop de
	pop hl
	inc de
	inc hl
	jr .GiveMoves

.Movesets
.Moveset0
; Dratini does not normally learn Extremespeed. This is a special gift.
	db WRAP
	db THUNDER_WAVE
	db TWISTER
	db EXTREMESPEED
	db 0
.Moveset1
; This is the normal moveset of a level 15 Dratini
	db WRAP
	db LEER
	db THUNDER_WAVE
	db TWISTER
	db 0

GetNthPartyMon: ; 0x8b1ce
; inputs:
; hl must be set to 0 before calling this function.
; a must be set to the number of Pokémon in the party.

; outputs:
; returns the address of the last Pokémon in the party in hl.
; sets carry if a is 0.

	ld de, PartyMon1
	add hl, de
	and a
	jr z, .EmptyParty
	dec a
	ret z
	ld de, PartyMon2 - PartyMon1
.loop
	add hl, de
	dec a
	jr nz, .loop
	ret
.EmptyParty
	scf
	ret

INCBIN "baserom.gbc", $8b1e1, $8b342 - $8b1e1


Function8b342: ; 8b342
	call GetSecondaryMapHeaderPointer
	ld d, h
	ld e, l
	xor a
.asm_8b348
	push af
	ld hl, $7354
	rst JumpTable
	pop af
	inc a
	cp $3
	jr nz, .asm_8b348
	ret
; 8b354

Table8b354: ; 8b354
	dw Function8b35a
	dw Function8b35b
	dw Function8b35c
; 8b35a

Function8b35a: ; 8b35a
	ret
; 8b35b


Function8b35b: ; 8b35b
	ret
; 8b35c

Function8b35c: ; 8b35c
	ret
; 8b35d

INCBIN "baserom.gbc", $8b35d, $8b677 - $8b35d

Function8b677: ; 8b677
	call WhiteBGMap
	call DisableLCD
	call Function8b690
	call Function8b6bb
	call Function8b6ed
	call EnableLCD
	call Function891ab
	call Function32f9
	ret
; 8b690

Function8b690: ; 8b690
	ld hl, $74b9
	ld de, VTiles2
	ld bc, $0160
	ld a, $5e
	call FarCopyBytes
	ld hl, $7609
	ld de, $9610
	ld bc, $0010
	ld a, $5e
	call FarCopyBytes
	ld hl, $7619
	ld de, $8ee0
	ld bc, $0010
	ld a, $5e
	call FarCopyBytes
	ret
; 8b6bb

Function8b6bb: ; 8b6bb
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, $76d5
	ld de, Unkn1Pals
	ld bc, $0018
	call CopyBytes
	pop af
	ld [rSVBK], a
	call Function8949c
	ret
; 8b6d5

INCBIN "baserom.gbc", $8b6d5, $8b6ed - $8b6d5

Function8b6ed: ; 8b6ed
	ld hl, AttrMap
	ld bc, $012c
	xor a
	call ByteFill
	ld hl, $cef1
	ld bc, $0050
	ld a, $7
	call ByteFill
	ret
; 8b703

Function8b703: ; 8b703
	call Function8923c
	push hl
	ld a, $c
	ld [hli], a
	inc a
	call Function8b73e
	inc a
	ld [hl], a
	pop hl
	push hl
	push bc
	ld de, $0014
	add hl, de
.asm_8b717
	push hl
	ld a, $f
	ld [hli], a
	ld a, $7f
	call Function8b73e
	ld a, $11
	ld [hl], a
	pop hl
	ld de, $0014
	add hl, de
	dec b
	jr nz, .asm_8b717
	call Function8b732
	pop bc
	pop hl
	jr Function8b744
; 8b732

Function8b732: ; 8b732
	ld a, $12
	ld [hli], a
	ld a, $13
	call Function8b73e
	ld a, $14
	ld [hl], a
	ret
; 8b73e

Function8b73e: ; 8b73e
	ld d, c
.asm_8b73f
	ld [hli], a
	dec d
	jr nz, .asm_8b73f
	ret
; 8b744

Function8b744: ; 8b744
	ld de, $0939
	add hl, de
	inc b
	inc b
	inc c
	inc c
	xor a
.asm_8b74d
	push bc
	push hl
.asm_8b74f
	ld [hli], a
	dec c
	jr nz, .asm_8b74f
	pop hl
	ld de, $0014
	add hl, de
	pop bc
	dec b
	jr nz, .asm_8b74d
	ret
; 8b75d

Function8b75d: ; 8b75d
	call Function8923c
	ld hl, TileMap
	ld a, $1
	ld bc, $0014
	call ByteFill
	ld hl, $c4b4
	ld a, $2
	ld [hl], a
	ld hl, $c4bd
	ld c, $b
	call Function8b788
	ld hl, $c4b5
	ld a, $4
	ld e, $8
.asm_8b780
	ld [hli], a
	inc a
	dec e
	jr nz, .asm_8b780
	jr Function8b79e
; 8b787

Function8b787: ; 8b787
	ret
; 8b788

Function8b788: ; 8b788
.asm_8b788
	ld a, $2
	ld [hli], a
	dec c
	ret z
	ld a, $1
	ld [hli], a
	dec c
	ret z
	ld a, $3
	ld [hli], a
	dec c
	ret z
	ld a, $1
	ld [hli], a
	dec c
	jr nz, .asm_8b788
	ret
; 8b79e

Function8b79e: ; 8b79e
	ld hl, $cded
	ld a, $1
	ld [hli], a
	ld hl, $cdf6
	ld e, $b
.asm_8b7a9
	ld a, $2
	ld [hli], a
	dec e
	ret z
	xor a
	ld [hli], a
	dec e
	ret z
	ld a, $1
	ld [hli], a
	dec e
	ret z
	xor a
	ld [hli], a
	dec e
	jr nz, .asm_8b7a9
	ret
; 8b7bd

Function8b7bd: ; 8b7bd
	call Function8b855
	ld hl, $7867
	call Function1d3c
	ld a, [$d030]
	ld [$cf88], a
	ld a, [$d031]
	ld [$d0e4], a
	ld a, [$d032]
	and a
	jr z, .asm_8b7e0
	ld a, [$cf81]
	set 3, a
	ld [$cf81], a

.asm_8b7e0
	ld a, [$d0e3]
	and a
	jr z, .asm_8b7ea
	dec a
	ld [$cf77], a

.asm_8b7ea
	ld hl, $c4c8
	ld b, $b
	ld c, $12
	call Function8b703
	call Function8b75d
	call Function1ad2
	call Function89209
	call Function350c
	call Function8920f
	ld a, [$cf73]
	cp $2
	jr z, .asm_8b823
	cp $20
	jr nz, .asm_8b813
	call Function8b832
	jr .asm_8b7ea

.asm_8b813
	cp $10
	jr nz, .asm_8b81c
	call Function8b83e
	jr .asm_8b7ea

.asm_8b81c
	ld a, [MenuSelection]
	cp $ff
	jr nz, .asm_8b824

.asm_8b823
	xor a

.asm_8b824
	ld c, a
	ld a, [$cfa9]
	ld [$d030], a
	ld a, [$d0e4]
	ld [$d031], a
	ret
; 8b832

Function8b832: ; 8b832
	ld a, [$d0e4]
	ld hl, $cf92
	sub [hl]
	jr nc, Function8b84b
	xor a
	jr Function8b84b
; 8b83e

Function8b83e: ; 8b83e
	ld a, [$d0e4]
	ld hl, $cf92
	add [hl]
	cp $24
	jr c, Function8b84b
	ld a, $24

Function8b84b: ; 8b84b
	ld [$d0e4], a
	ld a, [$cfa9]
	ld [$cf88], a
	ret
; 8b855

Function8b855: ; 8b855
	ld a, $28
	ld hl, DefaultFlypoint
	ld [hli], a
	ld c, $28
	xor a
.asm_8b85e
	inc a
	ld [hli], a
	dec c
	jr nz, .asm_8b85e
	ld a, $ff
	ld [hl], a
	ret
; 8b867

INCBIN "baserom.gbc", $8b867, $8b94a - $8b867

Function8b94a: ; 8b94a
	ld [$d033], a
	xor a
	ld [$d0e4], a
	ld [$d032], a
	ld [$d0e3], a
	ld [$d031], a
	ld a, $1
	ld [$d030], a
	ret
; 8b960

INCBIN "baserom.gbc", $8b960, $8ba24 - $8b960


SECTION "bank23",ROMX,BANK[$23]

INCBIN "baserom.gbc", $8c000, $8c001 - $8c000


Function8c001: ; 8c001
	call UpdateTime
	ld a, [TimeOfDay]
	ld [CurTimeOfDay], a
	call GetTimePalette
	ld [TimeOfDayPal], a
	ret
; 8c011


_TimeOfDayPals: ; 8c011
; return carry if pals are changed

; forced pals?
	ld hl, $d846
	bit 7, [hl]
	jr nz, .dontchange
	
; do we need to bother updating?
	ld a, [TimeOfDay]
	ld hl, CurTimeOfDay
	cp [hl]
	jr z, .dontchange
	
; if so, the time of day has changed
	ld a, [TimeOfDay]
	ld [CurTimeOfDay], a
	
; get palette id
	call GetTimePalette
	
; same palette as before?
	ld hl, TimeOfDayPal
	cp [hl]
	jr z, .dontchange
	
; update palette id
	ld [TimeOfDayPal], a
	
	
; save bg palette 8
	ld hl, $d038 ; Unkn1Pals + 7 pals
	
; save wram bank
	ld a, [rSVBK]
	ld b, a
; wram bank 5
	ld a, 5
	ld [rSVBK], a
	
; push palette
	ld c, 4 ; NUM_PAL_COLORS
.push
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl
	push de
	dec c
	jr nz, .push
	
; restore wram bank
	ld a, b
	ld [rSVBK], a
	
	
; update sgb pals
	ld b, $9
	call GetSGBLayout
	
	
; restore bg palette 8
	ld hl, CurFruit ; last byte in Unkn1Pals
	
; save wram bank
	ld a, [rSVBK]
	ld d, a
; wram bank 5
	ld a, 5
	ld [rSVBK], a
	
; pop palette
	ld e, 4 ; NUM_PAL_COLORS
.pop
	pop bc
	ld [hl], c
	dec hl
	ld [hl], b
	dec hl
	dec e
	jr nz, .pop
	
; restore wram bank
	ld a, d
	ld [rSVBK], a
	
; update palettes
	call _UpdateTimePals
	call DelayFrame
	
; successful change
	scf
	ret
	
.dontchange
; no change occurred
	and a
	ret
; 8c070


_UpdateTimePals: ; 8c070
	ld c, $9 ; normal
	call GetTimePalFade
	call DmgToCgbTimePals
	ret
; 8c079

Function8c079: ; 8c079
	ld c, $12
	call GetTimePalFade
	ld b, $4
	call Function8c16d
	ret
; 8c084

Function8c084: ; 8c084
	call Function8c0c1
	ld c, $9
	call GetTimePalFade
	ld b, $4
	call Function8c15e
	ret
; 8c092

INCBIN "baserom.gbc", $8c092, $8c0c1 - $8c092


Function8c0c1: ; 8c0c1
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, $d000
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld hl, $d008
	ld c, $6
.asm_8c0d4
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .asm_8c0d4
	pop af
	ld [rSVBK], a
	ret
; 8c0e5

INCBIN "baserom.gbc", $8c0e5, $8c117 - $8c0e5

GetTimePalette: ; 8c117
; get time of day
	ld a, [TimeOfDay]
	ld e, a
	ld d, $0
; get fn ptr
	ld hl, .TimePalettes
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
; go
	jp [hl]
; 8c126

.TimePalettes
	dw .MorningPalette
	dw .DayPalette
	dw .NitePalette
	dw .DarknessPalette

.MorningPalette ; 8c12e
	ld a, [$d847]
	and %00000011 ; 0
	ret
; 8c134

.DayPalette ; 8c134
	ld a, [$d847]
	and %00001100 ; 1
	srl a
	srl a
	ret
; 8c13e

.NitePalette ; 8c13e
	ld a, [$d847]
	and %00110000 ; 2
	swap a
	ret
; 8c146

.DarknessPalette ; 8c146
	ld a, [$d847]
	and %11000000 ; 3
	rlca
	rlca
	ret
; 8c14e


DmgToCgbTimePals: ; 8c14e
	push hl
	push de
	ld a, [hli]
	call DmgToCgbBGPals
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	call DmgToCgbObjPals
	pop de
	pop hl
	ret
; 8c15e

Function8c15e: ; 8c15e
.asm_8c15e
	call DmgToCgbTimePals
	inc hl
	inc hl
	inc hl
	ld c, $2
	call DelayFrames
	dec b
	jr nz, .asm_8c15e
	ret
; 8c16d

Function8c16d: ; 8c16d
.asm_8c16d
	call DmgToCgbTimePals
	dec hl
	dec hl
	dec hl
	ld c, $2
	call DelayFrames
	dec b
	jr nz, .asm_8c16d
	ret
; 8c17c


GetTimePalFade: ; 8c17c
; check cgb
	ld a, [hCGB]
	and a
	jr nz, .cgb
	
; else: dmg

; index
	ld a, [TimeOfDayPal]
	and %11
	
; get fade table
	push bc
	ld c, a
	ld b, $0
	ld hl, .dmgfades
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc
	
; get place in fade table
	ld b, $0
	add hl, bc
	ret
	
.cgb
	ld hl, .cgbfade
	ld b, $0
	add hl, bc
	ret
; 8c19e

.dmgfades ; 8c19e
	dw .morn
	dw .day
	dw .nite
	dw .darkness
; 8c1a6

.morn ; 8c1a6
	db %11111111
	db %11111111
	db %11111111
	
	db %11111110
	db %11111110
	db %11111110
	
	db %11111001
	db %11100100
	db %11100100
	
	db %11100100
	db %11010000
	db %11010000
	
	db %10010000
	db %10000000
	db %10000000
	
	db %01000000
	db %01000000
	db %01000000
	
	db %00000000
	db %00000000
	db %00000000
; 8c1bb

.day ; 8c1bb
	db %11111111
	db %11111111
	db %11111111
	
	db %11111110
	db %11111110
	db %11111110
	
	db %11111001
	db %11100100
	db %11100100
	
	db %11100100
	db %11010000
	db %11010000
	
	db %10010000
	db %10000000
	db %10000000
	
	db %01000000
	db %01000000
	db %01000000
	
	db %00000000
	db %00000000
	db %00000000
; 8c1d0

.nite ; 8c1d0
	db %11111111
	db %11111111
	db %11111111
	
	db %11111110
	db %11111110
	db %11111110
	
	db %11111001
	db %11100100
	db %11100100
	
	db %11101001
	db %11010000
	db %11010000
	
	db %10010000
	db %10000000
	db %10000000
	
	db %01000000
	db %01000000
	db %01000000
	
	db %00000000
	db %00000000
	db %00000000
; 8c1e5

.darkness ; 8c1e5
	db %11111111
	db %11111111
	db %11111111
	
	db %11111110
	db %11111110
	db %11111111
	
	db %11111110
	db %11100100
	db %11111111
	
	db %11111101
	db %11010000
	db %11111111
	
	db %11111101
	db %10000000
	db %11111111
	
	db %00000000
	db %01000000
	db %00000000
	
	db %00000000
	db %00000000
	db %00000000
; 8c1fa

.cgbfade ; 8c1fa
	db %11111111
	db %11111111
	db %11111111
	
	db %11111110
	db %11111110
	db %11111110
	
	db %11111001
	db %11111001
	db %11111001
	
	db %11100100
	db %11100100
	db %11100100
	
	db %10010000
	db %10010000
	db %10010000
	
	db %01000000
	db %01000000
	db %01000000
	
	db %00000000
	db %00000000
	db %00000000
; 8c20f


Function8c20f: ; 8c20f
	call Function8c26d
	ld a, [rBGP]
	ld [$cfc7], a
	ld a, [rOBP0]
	ld [$cfc8], a
	ld a, [rOBP1]
	ld [$cfc9], a
	call DelayFrame
	ld hl, $ff9e
	ld a, [hl]
	push af
	ld [hl], $1
.asm_8c22b
	ld a, [$cf63]
	bit 7, a
	jr nz, .asm_8c23a
	call Function8c314
	call DelayFrame
	jr .asm_8c22b

.asm_8c23a
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, Unkn1Pals
	ld bc, $0040
	xor a
	call ByteFill
	pop af
	ld [rSVBK], a
	ld a, $ff
	ld [$cfc7], a
	call DmgToCgbBGPals
	call DelayFrame
	xor a
	ld [hLCDStatCustom], a
	ld [$ffc7], a
	ld [$ffc8], a
	ld [hSCY], a
	ld a, $1
	ld [rSVBK], a
	pop af
	ld [$ff9e], a
	call DelayFrame
	ret
; 8c26d

Function8c26d: ; 8c26d
	ld a, [InLinkBattle]
	cp $4
	jr z, .asm_8c288
	callba Function6454
	call Function1ad2
	call DelayFrame
	call Function8c2a0
	call Function8cf4f
	jr .asm_8c28b

.asm_8c288
	call Function8c2aa

.asm_8c28b
	ld a, $90
	ld [hWY], a
	call DelayFrame
	xor a
	ld [hBGMapMode], a
	ld hl, $cf63
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	call Function8c6d8
	ret
; 8c2a0

Function8c2a0: ; 8c2a0
	call Function8c2aa
	ld hl, VBGMap0
	call Function8c2cf
	ret
; 8c2aa

Function8c2aa: ; 8c2aa
	ld de, $42f4
	ld hl, $8fe0
	ld b, $23
	ld c, $2
	call Request2bpp
	ld a, [rVBK]
	push af
	ld a, $1
	ld [rVBK], a
	ld de, $42f4
	ld hl, $8fe0
	ld b, $23
	ld c, $2
	call Request2bpp
	pop af
	ld [rVBK], a
	ret
; 8c2cf

Function8c2cf: ; 8c2cf
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	push hl
	ld hl, Unkn1Pals
	ld bc, $0280
.asm_8c2dd
	ld [hl], $ff
	inc hl
	dec bc
	ld a, c
	or b
	jr nz, .asm_8c2dd
	pop hl
	ld de, Unkn1Pals
	ld b, $23
	ld c, $28
	call Request2bpp
	pop af
	ld [rSVBK], a
	ret
; 8c2f4

INCBIN "baserom.gbc", $8c2f4, $8c314 - $8c2f4

Function8c314: ; 8c314
	ld a, [$cf63]
	ld e, a
	ld d, $0
	ld hl, $4323
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 8c323

INCBIN "baserom.gbc", $8c323, $8c6d8 - $8c323

Function8c6d8: ; 8c6d8
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, $d100
	call Function8c6ef
	ld hl, $d200
	call Function8c6ef
	pop af
	ld [rSVBK], a
	ret
; 8c6ef

Function8c6ef: ; 8c6ef
	xor a
	ld c, $90
.asm_8c6f2
	ld [hli], a
	dec c
	jr nz, .asm_8c6f2
	ret
; 8c6f7

INCBIN "baserom.gbc", $8c6f7, $8c7d4 - $8c6f7

Function8c7d4: ; 8c7d4
	call WaitSFX
	ld de, $0053
	call StartSFX
	call WaitSFX
	ret
; 8c7e1

INCBIN "baserom.gbc", $8c7e1, $8c940 - $8c7e1

Function8c940: ; 8c940
	ld a, e
	and $1
	ld [$cf63], a
	call Function8c96d
	call WaitSFX
	ld de, $001e
	call StartSFX
.asm_8c952
	ld a, [$cf63]
	bit 7, a
	jr nz, .asm_8c96c
	ld a, $90
	ld [$c3b5], a
	ld hl, Function8cf7a
	ld a, $23
	rst FarCall
	call Function8ca0c
	call DelayFrame
	jr .asm_8c952

.asm_8c96c
	ret
; 8c96d

Function8c96d: ; 8c96d
	ld hl, Function8cf53
	ld a, $23
	rst FarCall
	ld de, $49cc
	ld hl, VTiles1
	ld bc, $2304
	call Request2bpp
	ld de, $498c
	ld hl, $8840
	ld bc, $2304
	call Request2bpp
	ret
; 8c98c

INCBIN "baserom.gbc", $8c98c, $8ca0c - $8c98c

Function8ca0c: ; 8ca0c
	ld a, [$cf63]
	ld e, a
	ld d, $0
	ld hl, $4a1b
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 8ca1b

INCBIN "baserom.gbc", $8ca1b, $8cf4f - $8ca1b

Function8cf4f: ; 8cf4f
	call Function3238
	ret
; 8cf53


Function8cf53: ; 8cf53
	ld hl, $c300
	ld bc, $00c1
.asm_8cf59
	ld [hl], $0
	inc hl
	dec bc
	ld a, c
	or b
	jr nz, .asm_8cf59
	ret
; 8cf62

Function8cf62: ; 8cf62
	call Function8cf69
	call DelayFrame
	ret
; 8cf69



Function8cf69: ; 8cf69
	push hl
	push de
	push bc
	push af
	ld a, $0
	ld [$c3b5], a
	call Function8cf7a
	pop af
	pop bc
	pop de
	pop hl
	ret
; 8cf7a

Function8cf7a: ; 8cf7a
	ld hl, $c314
	ld e, $a
.asm_8cf7f
	ld a, [hl]
	and a
	jr z, .asm_8cf91
	ld c, l
	ld b, h
	push hl
	push de
	call Function8d24b
	call Function8d04c
	pop de
	pop hl
	jr c, .asm_8cfa7

.asm_8cf91
	ld bc, $0010
	add hl, bc
	dec e
	jr nz, .asm_8cf7f
	ld a, [$c3b5]
	ld l, a
	ld h, $c4
.asm_8cf9e
	ld a, l
	cp $a0
	jr nc, .asm_8cfa7
	xor a
	ld [hli], a
	jr .asm_8cf9e

.asm_8cfa7
	ret
; 8cfa8

INCBIN "baserom.gbc", $8cfa8, $8cfd6 - $8cfa8


Function8cfd6: ; 8cfd6
	push de
	push af
	ld hl, $c314
	ld e, $a
.asm_8cfdd
	ld a, [hl]
	and a
	jr z, .asm_8cfec
	ld bc, $0010
	add hl, bc
	dec e
	jr nz, .asm_8cfdd
	pop af
	pop de
	scf
	ret

.asm_8cfec
	ld c, l
	ld b, h
	ld hl, $c3b4
	inc [hl]
	ld a, [hl]
	and a
	jr nz, .asm_8cff7
	inc [hl]

.asm_8cff7
	pop af
	ld e, a
	ld d, $0
	ld hl, $51c4
	add hl, de
	add hl, de
	add hl, de
	ld e, l
	ld d, h
	ld hl, $0000
	add hl, bc
	ld a, [$c3b4]
	ld [hli], a
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	call Function8d109
	ld [hli], a
	pop de
	ld hl, $0004
	add hl, bc
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	dec a
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, c
	ld [$c3b8], a
	ld a, b
	ld [$c3b9], a
	ret
; 8d036

Function8d036: ; 8d036
	ld hl, $0000
	add hl, bc
	ld [hl], $0
	ret
; 8d03d

INCBIN "baserom.gbc", $8d03d, $8d04c - $8d03d


Function8d04c: ; 8d04c
	call Function8d0ec
	call Function8d132
	cp EGG
	jr z, .asm_8d0b9
	cp NUM_POKEMON + 1
	jr z, .asm_8d0b6
	call Function8d1a2
	ld a, [$c3ba]
	add [hl]
	ld [$c3ba], a
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push bc
	ld a, [$c3b5]
	ld e, a
	ld d, $c4
	ld a, [hli]
	ld c, a
.asm_8d071
	ld a, [$c3bc]
	ld b, a
	ld a, [$c3be]
	add b
	ld b, a
	ld a, [$c3bf]
	add b
	ld b, a
	call Function8d0be
	add b
	ld [de], a
	inc hl
	inc de
	ld a, [$c3bb]
	ld b, a
	ld a, [$c3bd]
	add b
	ld b, a
	ld a, [$c3c0]
	add b
	ld b, a
	call Function8d0ce
	add b
	ld [de], a
	inc hl
	inc de
	ld a, [$c3ba]
	add [hl]
	ld [de], a
	inc hl
	inc de
	call Function8d0de
	ld [de], a
	inc hl
	inc de
	ld a, e
	ld [$c3b5], a
	cp $a0
	jr nc, .asm_8d0bb
	dec c
	jr nz, .asm_8d071
	pop bc
	jr .asm_8d0b9

.asm_8d0b6
	call Function8d036

.asm_8d0b9
	and a
	ret

.asm_8d0bb
	pop bc
	scf
	ret
; 8d0be

Function8d0be: ; 8d0be
	push hl
	ld a, [hl]
	ld hl, $c3b8
	bit 6, [hl]
	jr z, .asm_8d0cc
	add $8
	xor $ff
	inc a

.asm_8d0cc
	pop hl
	ret
; 8d0ce

Function8d0ce: ; 8d0ce
	push hl
	ld a, [hl]
	ld hl, $c3b8
	bit 5, [hl]
	jr z, .asm_8d0dc
	add $8
	xor $ff
	inc a

.asm_8d0dc
	pop hl
	ret
; 8d0de

Function8d0de: ; 8d0de
	ld a, [$c3b8]
	ld b, a
	ld a, [hl]
	xor b
	and $e0
	ld b, a
	ld a, [hl]
	and $1f
	or b
	ret
; 8d0ec

Function8d0ec: ; 8d0ec
	xor a
	ld [$c3b8], a
	ld hl, $0003
	add hl, bc
	ld a, [hli]
	ld [$c3ba], a
	ld a, [hli]
	ld [$c3bb], a
	ld a, [hli]
	ld [$c3bc], a
	ld a, [hli]
	ld [$c3bd], a
	ld a, [hli]
	ld [$c3be], a
	ret
; 8d109

Function8d109: ; 8d109
	push hl
	push bc
	ld hl, $c300
	ld b, a
	ld c, $a
.asm_8d111
	ld a, [hli]
	cp b
	jr z, .asm_8d11c
	inc hl
	dec c
	jr nz, .asm_8d111
	xor a
	jr .asm_8d11d

.asm_8d11c
	ld a, [hl]

.asm_8d11d
	pop bc
	pop hl
	ret
; 8d120

Function8d120: ; 8d120
	ld hl, $0001
	add hl, bc
	ld [hl], a
	ld hl, $0008
	add hl, bc
	ld [hl], $0
	ld hl, $000a
	add hl, bc
	ld [hl], $ff
	ret
; 8d132


Function8d132: ; 8d132
.asm_8d132
	ld hl, $0008
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_8d142
	dec [hl]
	call Function8d189
	ld a, [hli]
	push af
	jr .asm_8d163

.asm_8d142
	ld hl, $000a
	add hl, bc
	inc [hl]
	call Function8d189
	ld a, [hli]
	cp $fe
	jr z, .asm_8d17b
	cp $ff
	jr z, .asm_8d16d
	push af
	ld a, [hl]
	push hl
	and $3f
	ld hl, $0009
	add hl, bc
	add [hl]
	ld hl, $0008
	add hl, bc
	ld [hl], a
	pop hl

.asm_8d163
	ld a, [hl]
	and $c0
	srl a
	ld [$c3b8], a
	pop af
	ret

.asm_8d16d
	xor a
	ld hl, $0008
	add hl, bc
	ld [hl], a
	ld hl, $000a
	add hl, bc
	dec [hl]
	dec [hl]
	jr .asm_8d132

.asm_8d17b
	xor a
	ld hl, $0008
	add hl, bc
	ld [hl], a
	dec a
	ld hl, $000a
	add hl, bc
	ld [hl], a
	jr .asm_8d132
; 8d189

Function8d189: ; 8d189
	ld hl, $0001
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld hl, $56e6
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $000a
	add hl, bc
	ld l, [hl]
	ld h, $0
	add hl, hl
	add hl, de
	ret
; 8d1a2

Function8d1a2: ; 8d1a2
	ld e, a
	ld d, $0
	ld hl, $594d
	add hl, de
	add hl, de
	add hl, de
	ret
; 8d1ac

INCBIN "baserom.gbc", $8d1ac, $8d24b - $8d1ac


Function8d24b: ; 8d24b
	ld hl, $0002
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld hl, $525b
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 8d25b

INCBIN "baserom.gbc", $8d25b, $8e72a - $8d25b


Function8e72a: ; 8e72a
	add $10
	and $3f
	cp $20
	jr nc, .asm_8e737
	call Function8e741
	ld a, h
	ret

.asm_8e737
	and $1f
	call Function8e741
	ld a, h
	xor $ff
	inc a
	ret
; 8e741

Function8e741: ; 8e741
	ld e, a
	ld a, d
	ld d, $0
	ld hl, $675d
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $0000
.asm_8e750
	srl a
	jr nc, .asm_8e755
	add hl, de

.asm_8e755
	sla e
	rl d
	and a
	jr nz, .asm_8e750
	ret
; 8e75d

INCBIN "baserom.gbc", $8e75d, $8e79d - $8e75d


Function8e79d: ; 8e79d
	ld a, [hSGB]
	ld de, $67f4
	and a
	jr z, .asm_8e7a8
	ld de, $6804

.asm_8e7a8
	ld hl, VTiles0
	ld bc, $2301
	call Request2bpp
	ld c, $8
	ld d, $0
.asm_8e7b5
	push bc
	call Function8e7c6
	call DelayFrame
	pop bc
	inc d
	inc d
	dec c
	jr nz, .asm_8e7b5
	call ClearSprites
	ret
; 8e7c6

Function8e7c6: ; 8e7c6
	ld hl, Sprites
	ld c, $8
.asm_8e7cb
	ld a, c
	and a
	ret z
	dec c
	ld a, c
	sla a
	sla a
	sla a
	push af
	push de
	push hl
	call $672c
	pop hl
	pop de
	add $68
	ld [hli], a
	pop af
	push de
	push hl
	call Function8e72a
	pop hl
	pop de
	add $54
	ld [hli], a
	ld a, $0
	ld [hli], a
	ld a, $6
	ld [hli], a
	jr .asm_8e7cb
; 8e7f4

INCBIN "baserom.gbc", $8e7f4, $8e814 - $8e7f4


Function8e814: ; 8e814
	push hl
	push de
	push bc
	push af
	ld hl, $c300
	ld bc, $00c1
.asm_8e81e
	ld [hl], $0
	inc hl
	dec bc
	ld a, c
	or b
	jr nz, .asm_8e81e
	pop af
	pop bc
	pop de
	pop hl
	ret
; 8e82b

Function8e82b: ; 8e82b
	ld a, e
	call ReadMonMenuIcon
	ld l, a
	ld h, $0
	add hl, hl
	ld de, IconPointers
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld b, $23
	ld c, $8
	ret
; 8e83f

Function8e83f: ; 8e83f
	push hl
	push de
	push bc
	call Function8e849
	pop bc
	pop de
	pop hl
	ret
; 8e849

Function8e849: ; 8e849
	ld d, $0
	ld hl, $6854
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 8e854

INCBIN "baserom.gbc", $8e854, $8e9ac - $8e854

GetSpeciesIcon: ; 8e9ac
; Load species icon into VRAM at tile a
	push de
	ld a, [$d265]
	call ReadMonMenuIcon
	ld [CurIcon], a
	pop de
	ld a, e
	call GetIconGFX
	ret
; 8e9bc

INCBIN "baserom.gbc", $8e9bc, $8e9de - $8e9bc

GetIconGFX: ; 8e9de
	call GetIcon_a
	ld de, $80 ; 8 tiles
	add hl, de
	ld de, HeldItemIcons
	ld bc, $2302
	call GetGFXUnlessMobile
	ld a, [$c3b7]
	add 10
	ld [$c3b7], a
	ret
	
HeldItemIcons:
INCBIN "gfx/icon/mail.2bpp"
INCBIN "gfx/icon/item.2bpp"
; 8ea17

GetIcon_de: ; 8ea17
; Load icon graphics into VRAM starting from tile de
	ld l, e
	ld h, d
	jr GetIcon
	
GetIcon_a: ; 8ea1b
; Load icon graphics into VRAM starting from tile a
	ld l, a
	ld h, 0
	
GetIcon: ; 8ea1e
; Load icon graphics into VRAM starting from tile hl

; One tile is 16 bytes long
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	
	ld de, VTiles0
	add hl, de
	push hl
	
; Reading the icon pointer table would only make sense if they were
; scattered. However, the icons are contiguous and in-order.
	ld a, [CurIcon]
	push hl
	ld l, a
	ld h, 0
	add hl, hl
	ld de, IconPointers
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop hl
	
	ld bc, $2308
	call GetGFXUnlessMobile
	pop hl
	ret
; 8ea3f

GetGFXUnlessMobile: ; 8ea3f
	ld a, [InLinkBattle]
	cp 4 ; Mobile Link Battle
	jp nz, Request2bpp
	jp Functiondc9
; 8ea4a

Function8ea4a: ; 8ea4a
	ld hl, $c314
	ld e, $6
	ld a, [$cfa9]
	ld d, a
.asm_8ea53
	ld a, [hl]
	and a
	jr z, .asm_8ea69
	cp d
	jr z, .asm_8ea5e
	ld a, $0
	jr .asm_8ea60

.asm_8ea5e
	ld a, $2

.asm_8ea60
	push hl
	ld c, l
	ld b, h
	ld hl, $0002
	add hl, bc
	ld [hl], a
	pop hl

.asm_8ea69
	ld bc, $0010
	add hl, bc
	dec e
	jr nz, .asm_8ea53
	ret
; 8ea71

INCBIN "baserom.gbc", $8ea71, $8eab3 - $8ea71

ReadMonMenuIcon: ; 8eab3
	cp EGG
	jr z, .egg
	dec a
	ld hl, MonMenuIcons
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ret
.egg
	ld a, ICON_EGG
	ret
; 8eac4

MonMenuIcons: ; 8eac4
	db ICON_BULBASAUR    ; BULBASAUR
	db ICON_BULBASAUR    ; IVYSAUR
	db ICON_BULBASAUR    ; VENUSAUR
	db ICON_CHARMANDER   ; CHARMANDER
	db ICON_CHARMANDER   ; CHARMELEON
	db ICON_BIGMON       ; CHARIZARD
	db ICON_SQUIRTLE     ; SQUIRTLE
	db ICON_SQUIRTLE     ; WARTORTLE
	db ICON_SQUIRTLE     ; BLASTOISE
	db ICON_CATERPILLAR  ; CATERPIE
	db ICON_CATERPILLAR  ; METAPOD
	db ICON_MOTH         ; BUTTERFREE
	db ICON_CATERPILLAR  ; WEEDLE
	db ICON_CATERPILLAR  ; KAKUNA
	db ICON_BUG          ; BEEDRILL
	db ICON_BIRD         ; PIDGEY
	db ICON_BIRD         ; PIDGEOTTO
	db ICON_BIRD         ; PIDGEOT
	db ICON_FOX          ; RATTATA
	db ICON_FOX          ; RATICATE
	db ICON_BIRD         ; SPEAROW
	db ICON_BIRD         ; FEAROW
	db ICON_SERPENT      ; EKANS
	db ICON_SERPENT      ; ARBOK
	db ICON_PIKACHU      ; PIKACHU
	db ICON_PIKACHU      ; RAICHU
	db ICON_MONSTER      ; SANDSHREW
	db ICON_MONSTER      ; SANDSLASH
	db ICON_FOX          ; NIDORAN_F
	db ICON_FOX          ; NIDORINA
	db ICON_MONSTER      ; NIDOQUEEN
	db ICON_FOX          ; NIDORAN_M
	db ICON_FOX          ; NIDORINO
	db ICON_MONSTER      ; NIDOKING
	db ICON_CLEFAIRY     ; CLEFAIRY
	db ICON_CLEFAIRY     ; CLEFABLE
	db ICON_FOX          ; VULPIX
	db ICON_FOX          ; NINETALES
	db ICON_JIGGLYPUFF   ; JIGGLYPUFF
	db ICON_JIGGLYPUFF   ; WIGGLYTUFF
	db ICON_BAT          ; ZUBAT
	db ICON_BAT          ; GOLBAT
	db ICON_ODDISH       ; ODDISH
	db ICON_ODDISH       ; GLOOM
	db ICON_ODDISH       ; VILEPLUME
	db ICON_BUG          ; PARAS
	db ICON_BUG          ; PARASECT
	db ICON_CATERPILLAR  ; VENONAT
	db ICON_MOTH         ; VENOMOTH
	db ICON_DIGLETT      ; DIGLETT
	db ICON_DIGLETT      ; DUGTRIO
	db ICON_FOX          ; MEOWTH
	db ICON_FOX          ; PERSIAN
	db ICON_MONSTER      ; PSYDUCK
	db ICON_MONSTER      ; GOLDUCK
	db ICON_FIGHTER      ; MANKEY
	db ICON_FIGHTER      ; PRIMEAPE
	db ICON_FOX          ; GROWLITHE
	db ICON_FOX          ; ARCANINE
	db ICON_POLIWAG      ; POLIWAG
	db ICON_POLIWAG      ; POLIWHIRL
	db ICON_POLIWAG      ; POLIWRATH
	db ICON_HUMANSHAPE   ; ABRA
	db ICON_HUMANSHAPE   ; KADABRA
	db ICON_HUMANSHAPE   ; ALAKAZAM
	db ICON_FIGHTER      ; MACHOP
	db ICON_FIGHTER      ; MACHOKE
	db ICON_FIGHTER      ; MACHAMP
	db ICON_ODDISH       ; BELLSPROUT
	db ICON_ODDISH       ; WEEPINBELL
	db ICON_ODDISH       ; VICTREEBEL
	db ICON_JELLYFISH    ; TENTACOOL
	db ICON_JELLYFISH    ; TENTACRUEL
	db ICON_GEODUDE      ; GEODUDE
	db ICON_GEODUDE      ; GRAVELER
	db ICON_GEODUDE      ; GOLEM
	db ICON_EQUINE       ; PONYTA
	db ICON_EQUINE       ; RAPIDASH
	db ICON_SLOWPOKE     ; SLOWPOKE
	db ICON_SLOWPOKE     ; SLOWBRO
	db ICON_VOLTORB      ; MAGNEMITE
	db ICON_VOLTORB      ; MAGNETON
	db ICON_BIRD         ; FARFETCH_D
	db ICON_BIRD         ; DODUO
	db ICON_BIRD         ; DODRIO
	db ICON_LAPRAS       ; SEEL
	db ICON_LAPRAS       ; DEWGONG
	db ICON_BLOB         ; GRIMER
	db ICON_BLOB         ; MUK
	db ICON_SHELL        ; SHELLDER
	db ICON_SHELL        ; CLOYSTER
	db ICON_GHOST        ; GASTLY
	db ICON_GHOST        ; HAUNTER
	db ICON_GHOST        ; GENGAR
	db ICON_SERPENT      ; ONIX
	db ICON_HUMANSHAPE   ; DROWZEE
	db ICON_HUMANSHAPE   ; HYPNO
	db ICON_SHELL        ; KRABBY
	db ICON_SHELL        ; KINGLER
	db ICON_VOLTORB      ; VOLTORB
	db ICON_VOLTORB      ; ELECTRODE
	db ICON_ODDISH       ; EXEGGCUTE
	db ICON_ODDISH       ; EXEGGUTOR
	db ICON_MONSTER      ; CUBONE
	db ICON_MONSTER      ; MAROWAK
	db ICON_FIGHTER      ; HITMONLEE
	db ICON_FIGHTER      ; HITMONCHAN
	db ICON_MONSTER      ; LICKITUNG
	db ICON_BLOB         ; KOFFING
	db ICON_BLOB         ; WEEZING
	db ICON_EQUINE       ; RHYHORN
	db ICON_MONSTER      ; RHYDON
	db ICON_CLEFAIRY     ; CHANSEY
	db ICON_ODDISH       ; TANGELA
	db ICON_MONSTER      ; KANGASKHAN
	db ICON_FISH         ; HORSEA
	db ICON_FISH         ; SEADRA
	db ICON_FISH         ; GOLDEEN
	db ICON_FISH         ; SEAKING
	db ICON_STARYU       ; STARYU
	db ICON_STARYU       ; STARMIE
	db ICON_HUMANSHAPE   ; MR__MIME
	db ICON_BUG          ; SCYTHER
	db ICON_HUMANSHAPE   ; JYNX
	db ICON_HUMANSHAPE   ; ELECTABUZZ
	db ICON_HUMANSHAPE   ; MAGMAR
	db ICON_BUG          ; PINSIR
	db ICON_EQUINE       ; TAUROS
	db ICON_FISH         ; MAGIKARP
	db ICON_GYARADOS     ; GYARADOS
	db ICON_LAPRAS       ; LAPRAS
	db ICON_BLOB         ; DITTO
	db ICON_FOX          ; EEVEE
	db ICON_FOX          ; VAPOREON
	db ICON_FOX          ; JOLTEON
	db ICON_FOX          ; FLAREON
	db ICON_VOLTORB      ; PORYGON
	db ICON_SHELL        ; OMANYTE
	db ICON_SHELL        ; OMASTAR
	db ICON_SHELL        ; KABUTO
	db ICON_SHELL        ; KABUTOPS
	db ICON_BIRD         ; AERODACTYL
	db ICON_SNORLAX      ; SNORLAX
	db ICON_BIRD         ; ARTICUNO
	db ICON_BIRD         ; ZAPDOS
	db ICON_BIRD         ; MOLTRES
	db ICON_SERPENT      ; DRATINI
	db ICON_SERPENT      ; DRAGONAIR
	db ICON_BIGMON       ; DRAGONITE
	db ICON_HUMANSHAPE   ; MEWTWO
	db ICON_HUMANSHAPE   ; MEW
	db ICON_ODDISH       ; CHIKORITA
	db ICON_ODDISH       ; BAYLEEF
	db ICON_ODDISH       ; MEGANIUM
	db ICON_FOX          ; CYNDAQUIL
	db ICON_FOX          ; QUILAVA
	db ICON_FOX          ; TYPHLOSION
	db ICON_MONSTER      ; TOTODILE
	db ICON_MONSTER      ; CROCONAW
	db ICON_MONSTER      ; FERALIGATR
	db ICON_FOX          ; SENTRET
	db ICON_FOX          ; FURRET
	db ICON_BIRD         ; HOOTHOOT
	db ICON_BIRD         ; NOCTOWL
	db ICON_BUG          ; LEDYBA
	db ICON_BUG          ; LEDIAN
	db ICON_BUG          ; SPINARAK
	db ICON_BUG          ; ARIADOS
	db ICON_BAT          ; CROBAT
	db ICON_FISH         ; CHINCHOU
	db ICON_FISH         ; LANTURN
	db ICON_PIKACHU      ; PICHU
	db ICON_CLEFAIRY     ; CLEFFA
	db ICON_JIGGLYPUFF   ; IGGLYBUFF
	db ICON_CLEFAIRY     ; TOGEPI
	db ICON_BIRD         ; TOGETIC
	db ICON_BIRD         ; NATU
	db ICON_BIRD         ; XATU
	db ICON_FOX          ; MAREEP
	db ICON_MONSTER      ; FLAAFFY
	db ICON_MONSTER      ; AMPHAROS
	db ICON_ODDISH       ; BELLOSSOM
	db ICON_JIGGLYPUFF   ; MARILL
	db ICON_JIGGLYPUFF   ; AZUMARILL
	db ICON_SUDOWOODO    ; SUDOWOODO
	db ICON_POLIWAG      ; POLITOED
	db ICON_ODDISH       ; HOPPIP
	db ICON_ODDISH       ; SKIPLOOM
	db ICON_ODDISH       ; JUMPLUFF
	db ICON_MONSTER      ; AIPOM
	db ICON_ODDISH       ; SUNKERN
	db ICON_ODDISH       ; SUNFLORA
	db ICON_BUG          ; YANMA
	db ICON_MONSTER      ; WOOPER
	db ICON_MONSTER      ; QUAGSIRE
	db ICON_FOX          ; ESPEON
	db ICON_FOX          ; UMBREON
	db ICON_BIRD         ; MURKROW
	db ICON_SLOWPOKE     ; SLOWKING
	db ICON_GHOST        ; MISDREAVUS
	db ICON_UNOWN        ; UNOWN
	db ICON_GHOST        ; WOBBUFFET
	db ICON_EQUINE       ; GIRAFARIG
	db ICON_BUG          ; PINECO
	db ICON_BUG          ; FORRETRESS
	db ICON_SERPENT      ; DUNSPARCE
	db ICON_BUG          ; GLIGAR
	db ICON_SERPENT      ; STEELIX
	db ICON_MONSTER      ; SNUBBULL
	db ICON_MONSTER      ; GRANBULL
	db ICON_FISH         ; QWILFISH
	db ICON_BUG          ; SCIZOR
	db ICON_BUG          ; SHUCKLE
	db ICON_BUG          ; HERACROSS
	db ICON_FOX          ; SNEASEL
	db ICON_MONSTER      ; TEDDIURSA
	db ICON_MONSTER      ; URSARING
	db ICON_BLOB         ; SLUGMA
	db ICON_BLOB         ; MAGCARGO
	db ICON_EQUINE       ; SWINUB
	db ICON_EQUINE       ; PILOSWINE
	db ICON_SHELL        ; CORSOLA
	db ICON_FISH         ; REMORAID
	db ICON_FISH         ; OCTILLERY
	db ICON_MONSTER      ; DELIBIRD
	db ICON_FISH         ; MANTINE
	db ICON_BIRD         ; SKARMORY
	db ICON_FOX          ; HOUNDOUR
	db ICON_FOX          ; HOUNDOOM
	db ICON_BIGMON       ; KINGDRA
	db ICON_EQUINE       ; PHANPY
	db ICON_EQUINE       ; DONPHAN
	db ICON_VOLTORB      ; PORYGON2
	db ICON_EQUINE       ; STANTLER
	db ICON_MONSTER      ; SMEARGLE
	db ICON_FIGHTER      ; TYROGUE
	db ICON_FIGHTER      ; HITMONTOP
	db ICON_HUMANSHAPE   ; SMOOCHUM
	db ICON_HUMANSHAPE   ; ELEKID
	db ICON_HUMANSHAPE   ; MAGBY
	db ICON_EQUINE       ; MILTANK
	db ICON_CLEFAIRY     ; BLISSEY
	db ICON_FOX          ; RAIKOU
	db ICON_FOX          ; ENTEI
	db ICON_FOX          ; SUICUNE
	db ICON_MONSTER      ; LARVITAR
	db ICON_MONSTER      ; PUPITAR
	db ICON_MONSTER      ; TYRANITAR
	db ICON_LUGIA        ; LUGIA
	db ICON_HO_OH        ; HO_OH
	db ICON_HUMANSHAPE   ; CELEBI

IconPointers:
	dw NullIcon
	dw PoliwagIcon
	dw JigglypuffIcon
	dw DiglettIcon
	dw PikachuIcon
	dw StaryuIcon
	dw FishIcon
	dw BirdIcon
	dw MonsterIcon
	dw ClefairyIcon
	dw OddishIcon
	dw BugIcon
	dw GhostIcon
	dw LaprasIcon
	dw HumanshapeIcon
	dw FoxIcon
	dw EquineIcon
	dw ShellIcon
	dw BlobIcon
	dw SerpentIcon
	dw VoltorbIcon
	dw SquirtleIcon
	dw BulbasaurIcon
	dw CharmanderIcon
	dw CaterpillarIcon
	dw UnownIcon
	dw GeodudeIcon
	dw FighterIcon
	dw EggIcon
	dw JellyfishIcon
	dw MothIcon
	dw BatIcon
	dw SnorlaxIcon
	dw HoOhIcon
	dw LugiaIcon
	dw GyaradosIcon
	dw SlowpokeIcon
	dw SudowoodoIcon
	dw BigmonIcon

NullIcon:
PoliwagIcon:      INCBIN "gfx/icon/poliwag.2bpp" ; 0x8ec0d
JigglypuffIcon:   INCBIN "gfx/icon/jigglypuff.2bpp" ; 0x8ec8d
DiglettIcon:      INCBIN "gfx/icon/diglett.2bpp" ; 0x8ed0d
PikachuIcon:      INCBIN "gfx/icon/pikachu.2bpp" ; 0x8ed8d
StaryuIcon:       INCBIN "gfx/icon/staryu.2bpp" ; 0x8ee0d
FishIcon:         INCBIN "gfx/icon/fish.2bpp" ; 0x8ee8d
BirdIcon:         INCBIN "gfx/icon/bird.2bpp" ; 0x8ef0d
MonsterIcon:      INCBIN "gfx/icon/monster.2bpp" ; 0x8ef8d
ClefairyIcon:     INCBIN "gfx/icon/clefairy.2bpp" ; 0x8f00d
OddishIcon:       INCBIN "gfx/icon/oddish.2bpp" ; 0x8f08d
BugIcon:          INCBIN "gfx/icon/bug.2bpp" ; 0x8f10d
GhostIcon:        INCBIN "gfx/icon/ghost.2bpp" ; 0x8f18d
LaprasIcon:       INCBIN "gfx/icon/lapras.2bpp" ; 0x8f20d
HumanshapeIcon:   INCBIN "gfx/icon/humanshape.2bpp" ; 0x8f28d
FoxIcon:          INCBIN "gfx/icon/fox.2bpp" ; 0x8f30d
EquineIcon:       INCBIN "gfx/icon/equine.2bpp" ; 0x8f38d
ShellIcon:        INCBIN "gfx/icon/shell.2bpp" ; 0x8f40d
BlobIcon:         INCBIN "gfx/icon/blob.2bpp" ; 0x8f48d
SerpentIcon:      INCBIN "gfx/icon/serpent.2bpp" ; 0x8f50d
VoltorbIcon:      INCBIN "gfx/icon/voltorb.2bpp" ; 0x8f58d
SquirtleIcon:     INCBIN "gfx/icon/squirtle.2bpp" ; 0x8f60d
BulbasaurIcon:    INCBIN "gfx/icon/bulbasaur.2bpp" ; 0x8f68d
CharmanderIcon:   INCBIN "gfx/icon/charmander.2bpp" ; 0x8f70d
CaterpillarIcon:  INCBIN "gfx/icon/caterpillar.2bpp" ; 0x8f78d
UnownIcon:        INCBIN "gfx/icon/unown.2bpp" ; 0x8f80d
GeodudeIcon:      INCBIN "gfx/icon/geodude.2bpp" ; 0x8f88d
FighterIcon:      INCBIN "gfx/icon/fighter.2bpp" ; 0x8f90d
EggIcon:          INCBIN "gfx/icon/egg.2bpp" ; 0x8f98d
JellyfishIcon:    INCBIN "gfx/icon/jellyfish.2bpp" ; 0x8fa0d
MothIcon:         INCBIN "gfx/icon/moth.2bpp" ; 0x8fa8d
BatIcon:          INCBIN "gfx/icon/bat.2bpp" ; 0x8fb0d
SnorlaxIcon:      INCBIN "gfx/icon/snorlax.2bpp" ; 0x8fb8d
HoOhIcon:        INCBIN "gfx/icon/ho_oh.2bpp" ; 0x8fc0d
LugiaIcon:        INCBIN "gfx/icon/lugia.2bpp" ; 0x8fc8d
GyaradosIcon:     INCBIN "gfx/icon/gyarados.2bpp" ; 0x8fd0d
SlowpokeIcon:     INCBIN "gfx/icon/slowpoke.2bpp" ; 0x8fd8d
SudowoodoIcon:    INCBIN "gfx/icon/sudowoodo.2bpp" ; 0x8fe0d
BigmonIcon:       INCBIN "gfx/icon/bigmon.2bpp" ; 0x8fe8d


SECTION "bank24",ROMX,BANK[$24]

Function90000: ; 90000
	call Function9001c
	jr c, .asm_9000d
	call Function9002d
	jr nc, .asm_9000d
	ld [hl], c
	xor a
	ret

.asm_9000d
	scf
	ret
; 9000f


Function9000f: ; 9000f
	call Function9001c
	jr nc, .asm_90017
	xor a
	ld [hl], a
	ret

.asm_90017
	scf
	ret
; 90019

Function90019: ; 90019
	jp Function9001c
; 9001c

Function9001c: ; 9001c
	ld hl, $dc7c
	ld b, $a
.asm_90021
	ld a, [hli]
	cp c
	jr z, .asm_9002a
	dec b
	jr nz, .asm_90021
	xor a
	ret

.asm_9002a
	dec hl
	scf
	ret
; 9002d

Function9002d: ; 9002d
	call Function90040
	ld b, a
	ld hl, $dc7c
.asm_90034
	ld a, [hli]
	and a
	jr z, .asm_9003d
	dec b
	jr nz, .asm_90034
	xor a
	ret

.asm_9003d
	dec hl
	scf
	ret
; 90040

Function90040: ; 90040
	xor a
	ld [Buffer1], a
	ld hl, $4066
.asm_90047
	ld a, [hli]
	cp $ff
	jr z, .asm_9005f
	cp c
	jr z, .asm_9005d
	push bc
	push hl
	ld c, a
	call Function9001c
	jr c, .asm_9005b
	ld hl, Buffer1
	inc [hl]

.asm_9005b
	pop hl
	pop bc

.asm_9005d
	jr .asm_90047

.asm_9005f
	ld a, $a
	ld hl, Buffer1
	sub [hl]
	ret
; 90066

INCBIN "baserom.gbc", $90066, $90069 - $90066


Function90069: ; 90069
	ld a, [hROMBank]
	push af
	ld a, b
	rst Bankswitch

	call PlaceString
	pop af
	rst Bankswitch

	ret
; 90074

INCBIN "baserom.gbc", $90074, $9029a - $90074


Function9029a: ; 9029a
	ld a, b
	ld [DefaultFlypoint], a
	ld a, e
	ld [$d003], a
	ld a, d
	ld [$d004], a
	call Function902b3
	call Function902b3
	ld a, $41
	ld hl, $60d3
	rst FarCall
	ret
; 902b3

Function902b3: ; 902b3
	call Function9033f
	call $4357
	call Function902c9
	call $4357
	call Function90375
	call $4357
	call Function902c9
	ret
; 902c9

Function902c9: ; 902c9
	call Function90375
	ld hl, $c4c9
	ld [hl], $62
	inc hl
	inc hl
	ld a, [DefaultFlypoint]
	ld b, a
	ld a, [$d003]
	ld e, a
	ld a, [$d004]
	ld d, a
	call Function90069
	ret
; 902e3

INCBIN "baserom.gbc", $902e3, $902eb - $902e3


Function902eb: ; 902eb
	call Function9031d
	call Function90355
	call Function9032f
	call Function90355
	call Function9033b
	call Function90355
	call Function9032f
	call Function90355
	call Function9033b
	call Function90355
	call Function9032f
	call Function90355
	call Function9033b
	call Function90355
	ret
; 90316

INCBIN "baserom.gbc", $90316, $9031d - $90316


Function9031d: ; 9031d
	ld hl, UnknownText_0x9032a
	call PrintText
	ld de, SFX_HANG_UP
	call StartSFX
	ret
; 9032a

UnknownText_0x9032a: ; 9032a
	text_jump UnknownText_0x1c5580, BANK(UnknownText_0x1c5580)
	db "@"
; 9032f


Function9032f: ; 9032f
	ld hl, UnknownText_0x90336
	call PrintText
	ret
; 90336

UnknownText_0x90336: ; 0x90336
	text_jump UnknownText_0x1c5588, BANK(UnknownText_0x1c5588)
	db "@"
; 0x9033b


Function9033b: ; 9033b
	call SpeechTextBox
	ret
; 9033f

Function9033f: ; 9033f
	call WaitSFX
	ld de, SFX_CALL
	call StartSFX
	call Function90375
	call Function1ad2
	ld a, $13
	ld hl, $5188
	rst FarCall
	ret
; 90355

Function90355: ; 90355
	jr .asm_90357

.asm_90357
	ld c, $14
	call DelayFrames
	ld a, $13
	ld hl, $5188
	rst FarCall
	ret
; 90363

INCBIN "baserom.gbc", $90363, $90375 - $90363


Function90375: ; 90375
	ld hl, TileMap
	ld b, $2
	ld c, $12
	call TextBox
	ret
; 90380

INCBIN "baserom.gbc", $90380, $909f2 - $90380

dw Sunday
dw Monday
dw Tuesday
dw Wednesday
dw Thursday
dw Friday
dw Saturday
dw Sunday

Sunday:
	db " SUNDAY@"
Monday:
	db " MONDAY@"
Tuesday:
	db " TUESDAY@"
Wednesday:
	db "WEDNESDAY@"
Thursday:
	db "THURSDAY@"
Friday:
	db " FRIDAY@"
Saturday:
	db "SATURDAY@"


INCBIN "baserom.gbc", $90a3f, $914dd - $90a3f

PokegearSpritesGFX: ; 914dd
INCBIN "gfx/misc/pokegear_sprites.lz"
; 91508

INCBIN "baserom.gbc", $91508, $918bf - $91508

RadioChannels: ; 918bf
; Buena's Password is at 0x917c3
	db "OAK's ", $e1, $e2, " Talk@"
	db "#DEX Show@"
	db "#MON Music@"
	db "Lucky Channel@"
	db "?????@"
	db "Places & People@"
	db "Let's All Sing!@"
	db "# FLUTE@"
; 9191c

INCBIN "baserom.gbc", $9191c, $91ae1 - $9191c

Function91ae1: ; 91ae1
	ld a, e
	and a
	jr nz, .asm_91aec
	call Function91ff2
	call FillJohtoMap
	ret

.asm_91aec
	call Function91ff2
	call FillKantoMap
	ret
; 91af3


Function91af3: ; 91af3
	call WhiteBGMap
	call ClearTileMap
	call ClearSprites
	ld hl, $ffaa
	ld a, [hl]
	push af
	ld [hl], $1
	xor a
	ld [hBGMapMode], a
	callba Function8cf53
	call Function91ff2
	ld de, $62e1
	ld hl, $9300
	ld bc, $2406
	call Request1bpp
	call FlyMap
	call Function91c8f
	ld b, $2
	call GetSGBLayout
	call Function32f9
.asm_91b29
	call Functiona57
	ld hl, hJoyPressed
	ld a, [hl]
	and $2
	jr nz, .asm_91b4a
	ld a, [hl]
	and $1
	jr nz, .asm_91b4e
	call Function91b73
	call Function91c17
	callba Function8cf69
	call DelayFrame
	jr .asm_91b29

.asm_91b4a
	ld a, $ff
	jr .asm_91b5a

.asm_91b4e
	ld a, [DefaultFlypoint]
	ld l, a
	ld h, $0
	add hl, hl
	ld de, $5c5f
	add hl, de
	ld a, [hl]

.asm_91b5a
	ld [DefaultFlypoint], a
	pop af
	ld [$ffaa], a
	call WhiteBGMap
	ld a, $90
	ld [hWY], a
	xor a
	ld [hBGMapAddress], a
	ld a, $98
	ld [$ffd7], a
	ld a, [DefaultFlypoint]
	ld e, a
	ret
; 91b73

Function91b73: ; 91b73
	ld a, [StartFlypoint]
	ld e, a
	ld a, [EndFlypoint]
	ld d, a
	ld hl, $ffa9
	ld a, [hl]
	and $40
	jr nz, .asm_91b89
	ld a, [hl]
	and $80
	jr nz, .asm_91b9b
	ret

.asm_91b89
	ld hl, DefaultFlypoint
	ld a, [hl]
	cp d
	jr nz, .asm_91b93
	ld a, e
	dec a
	ld [hl], a

.asm_91b93
	inc [hl]
	call Function91c3c
	jr z, .asm_91b89
	jr .asm_91bab

.asm_91b9b
	ld hl, DefaultFlypoint
	ld a, [hl]
	cp e
	jr nz, .asm_91ba5
	ld a, d
	inc a
	ld [hl], a

.asm_91ba5
	dec [hl]
	call Function91c3c
	jr z, .asm_91b9b

.asm_91bab
	call TownMapBubble
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ret
; 91bb5

TownMapBubble: ; 91bb5
; Draw the bubble containing the location text in the town map HUD
	
; Top-left corner
	ld hl, TileMap + 1 ; (1,0)
	ld a, $30
	ld [hli], a
	
; Top row
	ld bc, 16
	ld a, " "
	call ByteFill
	
; Top-right corner
	ld a, $31
	ld [hl], a
	ld hl, TileMap + 1 + 20 ; (1,1)
	
	
; Middle row
	ld bc, 18
	ld a, " "
	call ByteFill
	
	
; Bottom-left corner
	ld hl, TileMap + 1 + 40 ; (1,2)
	ld a, $32
	ld [hli], a
	
; Bottom row
	ld bc, 16
	ld a, " "
	call ByteFill
	
; Bottom-right corner
	ld a, $33
	ld [hl], a
	
	
; Print "Where?"
	ld hl, TileMap + 2 ; (2,0)
	ld de, .Where
	call PlaceString
	
; Print the name of the default flypoint
	call .Name
	
; Up/down arrows
	ld hl, TileMap + 18 + 20 ; (18,1)
	ld [hl], $34	
	ret
	
.Where
	db "Where?@"

.Name
; We need the map location of the default flypoint
	ld a, [DefaultFlypoint]
	ld l, a
	ld h, 0
	add hl, hl ; two bytes per flypoint
	ld de, Flypoints
	add hl, de
	ld e, [hl]
	
	callba GetLandmarkName
	
	ld hl, TileMap + 2 + 20 ; (2,1)
	ld de, StringBuffer1
	call PlaceString
	ret
; 91c17

Function91c17: ; 91c17
	ld a, [DefaultFlypoint]
	ld l, a
	ld h, $0
	add hl, hl
	ld de, Flypoints
	add hl, de
	ld e, [hl]
	callba GetLandmarkCoords
	ld a, [$d003]
	ld c, a
	ld a, [$d004]
	ld b, a
	ld hl, $0004
	add hl, bc
	ld [hl], e
	ld hl, $0005
	add hl, bc
	ld [hl], d
	ret
; 91c3c

Function91c3c: ; 91c3c
	push bc
	push de
	push hl
	ld l, [hl]
	ld h, $0
	add hl, hl
	ld de, $5c5f
	add hl, de
	ld c, [hl]
	call GetFlyPermission
	pop hl
	pop de
	pop bc
	and a
	ret
; 91c50

GetFlyPermission: ; 91c50
; Return flypoint c permission flag in a
	ld hl, FlypointPerms
	ld b, $2
	ld d, $0
	ld a, 3 ; PREDEF_GET_FLAG_NO
	call Predef
	ld a, c
	ret
; 91c5e

Flypoints: ; 91c5e
; location id, blackout id

; Johto
	db 01, 14 ; New Bark Town
	db 03, 15 ; Cherrygrove City
	db 06, 16 ; Violet City
	db 12, 18 ; Azalea Town
	db 16, 20 ; Goldenrod City
	db 22, 22 ; Ecruteak City
	db 27, 21 ; Olivine City
	db 33, 19 ; Cianwood City
	db 36, 23 ; Mahogany Town
	db 38, 24 ; Lake of Rage
	db 41, 25 ; Blackthorn City
	db 46, 26 ; Silver Cave
	
; Kanto
	db 47, 02 ; Pallet Town
	db 49, 03 ; Viridian City
	db 51, 04 ; Pewter City
	db 55, 05 ; Cerulean City
	db 61, 07 ; Vermilion City
	db 66, 06 ; Rock Tunnel
	db 69, 08 ; Lavender Town
	db 71, 10 ; Celadon City
	db 72, 09 ; Saffron City
	db 81, 11 ; Fuchsia City
	db 85, 12 ; Cinnabar Island
	db 90, 13 ; Indigo Plateau
	
; 91c8e

INCBIN "baserom.gbc", $91c8e, $91c8f - $91c8e

Function91c8f: ; 91c8f
	ret
; 91c90

FlyMap: ; 91c90
	
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call GetWorldMapLocation
	
; If we're not in a valid location, i.e. Pokecenter floor 2F,
; the backup map information is used
	
	cp 0
	jr nz, .CheckRegion
	
	ld a, [BackupMapGroup]
	ld b, a
	ld a, [BackupMapNumber]
	ld c, a
	call GetWorldMapLocation
	
.CheckRegion
; The first 46 locations are part of Johto. The rest are in Kanto
	cp 47
	jr nc, .KantoFlyMap
	
.JohtoFlyMap
; Note that .NoKanto should be modified in tandem with this branch
	
	push af
	
; Start from New Bark Town
	ld a, 0
	ld [DefaultFlypoint], a
	
; Flypoints begin at New Bark Town...
	ld [StartFlypoint], a
; ..and end at Silver Cave
	ld a, $b
	ld [EndFlypoint], a
	
; Fill out the map
	call FillJohtoMap
	call .MapHud
	pop af
	call TownMapPlayerIcon
	ret
	
.KantoFlyMap
	
; The event that there are no flypoints enabled in a map is not
; accounted for. As a result, if you attempt to select a flypoint
; when there are none enabled, the game will crash. Additionally,
; the flypoint selection has a default starting point that
; can be flown to even if none are enabled
	
; To prevent both of these things from happening when the player
; enters Kanto, fly access is restricted until Indigo Plateau is
; visited and its flypoint enabled
	
	push af
	ld c, $d ; Indigo Plateau
	call GetFlyPermission
	and a
	jr z, .NoKanto
	
; Kanto's map is only loaded if we've visited Indigo Plateau
	
; Flypoints begin at Pallet Town...
	ld a, $c
	ld [StartFlypoint], a
; ...and end at Indigo Plateau
	ld a, $17
	ld [EndFlypoint], a
	
; Because Indigo Plateau is the first flypoint the player
; visits, it's made the default flypoint
	ld [DefaultFlypoint], a
	
; Fill out the map
	call FillKantoMap
	call .MapHud
	pop af
	call TownMapPlayerIcon
	ret
	
.NoKanto
; If Indigo Plateau hasn't been visited, we use Johto's map instead
	
; Start from New Bark Town
	ld a, 0
	ld [DefaultFlypoint], a
	
; Flypoints begin at New Bark Town...
	ld [StartFlypoint], a
; ..and end at Silver Cave
	ld a, $b
	ld [EndFlypoint], a
	
	call FillJohtoMap
	
	pop af
	
.MapHud
	call TownMapBubble
	call TownMapPals
	
	ld hl, VBGMap0 ; BG Map 0
	call TownMapBGUpdate
	
	call TownMapMon
	ld a, c
	ld [$d003], a
	ld a, b
	ld [$d004], a
	ret
; 91d11

INCBIN "baserom.gbc", $91d11, $91ee4 - $91d11

TownMapBGUpdate: ; 91ee4
; Update BG Map tiles and attributes

; BG Map address
	ld a, l
	ld [hBGMapAddress], a
	ld a, h
	ld [$ffd7], a
	
; Only update palettes on CGB
	ld a, [hCGB]
	and a
	jr z, .tiles
	
; BG Map mode 2 (palettes)
	ld a, 2
	ld [hBGMapMode], a
	
; The BG Map is updated in thirds, so we wait
; 3 frames to update the whole screen's palettes.
	ld c, 3
	call DelayFrames
	
.tiles
; Update BG Map tiles
	call WaitBGMap
	
; Turn off BG Map update
	xor a
	ld [hBGMapMode], a
	ret
; 91eff

FillJohtoMap: ; 91eff
	ld de, JohtoMap
	jr FillTownMap
	
FillKantoMap: ; 91f04
	ld de, KantoMap
	
FillTownMap: ; 91f07
	ld hl, TileMap
.loop
	ld a, [de]
	cp $ff
	ret z
	ld a, [de]
	ld [hli], a
	inc de
	jr .loop
; 91f13

TownMapPals: ; 91f13
; Assign palettes based on tile ids

	ld hl, TileMap
	ld de, AttrMap
	ld bc, 360
.loop
; Current tile
	ld a, [hli]
	push hl
	
; HP/borders use palette 0
	cp $60
	jr nc, .pal0
	
; The palette data is condensed to nybbles,
; least-significant first.
	ld hl, .Pals
	srl a
	jr c, .odd
	
; Even-numbered tile ids take the bottom nybble...
	add l
	ld l, a
	ld a, h
	adc 0
	ld h, a
	ld a, [hl]
	and %111
	jr .update
	
.odd
; ...and odd ids take the top.
	add l
	ld l, a
	ld a, h
	adc 0
	ld h, a
	ld a, [hl]
	swap a
	and %111
	jr .update
	
.pal0
	xor a
	
.update
	pop hl
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

.Pals
	db $11, $21, $22, $00, $11, $13, $54, $54, $11, $21, $22, $00
	db $11, $10, $01, $00, $11, $21, $22, $00, $00, $00, $00, $00
	db $00, $00, $44, $04, $00, $00, $00, $00, $33, $33, $33, $33
	db $33, $33, $33, $03, $33, $33, $33, $33, $00, $00, $00, $00
; 91f7b

TownMapMon: ; 91f7b
; Draw the FlyMon icon at town map location in 

; Get FlyMon species
	ld a, [CurPartyMon]
	ld hl, PartySpecies
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	ld [$d265], a
	
; Get FlyMon icon
	ld e, 8 ; starting tile in VRAM
	callba GetSpeciesIcon
	
; Animation/palette
	ld de, $0000
	ld a, $0
	call Function3b2a
	
	ld hl, 3
	add hl, bc
	ld [hl], 8
	ld hl, 2
	add hl, bc
	ld [hl], 0
	ret
; 91fa6

TownMapPlayerIcon: ; 91fa6
; Draw the player icon at town map location in a
	push af
	
	callba GetPlayerIcon
	
; Standing icon
	ld hl, $8100
	ld c, 4 ; # tiles
	call Request2bpp
	
; Walking icon
	ld hl, $00c0
	add hl, de
	ld d, h
	ld e, l
	ld hl, $8140
	ld c, 4 ; # tiles
	ld a, $30
	call Request2bpp
	
; Animation/palette
	ld de, $0000
	ld b, $0a ; Male
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_91fd3
	ld b, $1e ; Female
	
.asm_91fd3
	ld a, b
	call Function3b2a
	
	ld hl, $0003
	add hl, bc
	ld [hl], $10
	
	pop af
	ld e, a
	push bc
	callba GetLandmarkCoords
	pop bc
	
	ld hl, 4
	add hl, bc
	ld [hl], e
	ld hl, 5
	add hl, bc
	ld [hl], d
	ret
; 0x91ff2

Function91ff2: ; 91ff2
	ld hl, TownMapGFX
	ld de, VTiles2
	ld bc, BANK(TownMapGFX) << 8 + $30
	call Functione73
	ret
; 91fff


JohtoMap: ; 91fff
INCBIN "gfx/misc/johto.bin"
; 92168

KantoMap: ; 92168
INCBIN "gfx/misc/kanto.bin"
; 922d1


INCBIN "baserom.gbc", $922d1, $92402 - $922d1


INCLUDE "stats/wild/fish.asm"


INCBIN "baserom.gbc", $926c7, $93a31 - $926c7


SECTION "bank25",ROMX,BANK[$25]

MapGroupPointers: ; 0x94000
; pointers to the first map header of each map group
	dw MapGroup1
	dw MapGroup2
	dw MapGroup3
	dw MapGroup4
	dw MapGroup5
	dw MapGroup6
	dw MapGroup7
	dw MapGroup8
	dw MapGroup9
	dw MapGroup10
	dw MapGroup11
	dw MapGroup12
	dw MapGroup13
	dw MapGroup14
	dw MapGroup15
	dw MapGroup16
	dw MapGroup17
	dw MapGroup18
	dw MapGroup19
	dw MapGroup20
	dw MapGroup21
	dw MapGroup22
	dw MapGroup23
	dw MapGroup24
	dw MapGroup25
	dw MapGroup26


INCLUDE "maps/map_headers.asm"

INCLUDE "maps/second_map_headers.asm"


Function966b0: ; 966b0
	xor a
	ld [$d432], a
.asm_966b4
	ld a, [$d432]
	ld hl, .pointers
	rst JumpTable
	ld a, [$d432]
	cp 3 ; done
	jr nz, .asm_966b4
.done
	ret

.pointers
	dw Function96724
	dw Function9673e
	dw Function96773
	dw .done
; 966cb


Function966cb: ; 966cb
	xor a
	ld [ScriptFlags3], a
	ret
; 966d0

Function966d0: ; 966d0
	ld a, $ff
	ld [ScriptFlags3], a
	ret
; 966d6

Function966d6: ; 966d6
	ld hl, ScriptFlags3
	bit 5, [hl]
	ret
; 966dc

Function966dc: ; 966dc
	ld hl, ScriptFlags3
	res 2, [hl]
	ret
; 966e2

Function966e2: ; 966e2
	ld hl, ScriptFlags3
	res 1, [hl]
	ret
; 966e8

Function966e8: ; 966e8
	ld hl, ScriptFlags3
	res 0, [hl]
	ret
; 966ee

Function966ee: ; 966ee
	ld hl, ScriptFlags3
	res 4, [hl]
	ret
; 966f4

Function966f4: ; 966f4
	ld hl, ScriptFlags3
	set 2, [hl]
	ret
; 966fa

Function966fa: ; 966fa
	ld hl, ScriptFlags3
	set 1, [hl]
	ret
; 96700

Function96700: ; 96700
	ld hl, ScriptFlags3
	set 0, [hl]
	ret
; 96706

Function96706: ; 96706
	ld hl, ScriptFlags3
	set 4, [hl]
	ret
; 9670c

Function9670c: ; 9670c
	ld hl, ScriptFlags3
	bit 2, [hl]
	ret
; 96712

Function96712: ; 96712
	ld hl, ScriptFlags3
	bit 1, [hl]
	ret
; 96718

Function96718: ; 96718
	ld hl, ScriptFlags3
	bit 0, [hl]
	ret
; 9671e

Function9671e: ; 9671e
	ld hl, ScriptFlags3
	bit 4, [hl]
	ret
; 96724


Function96724: ; 96724
	xor a
	ld [ScriptVar], a
	xor a
	ld [ScriptRunning], a
	ld hl, $d432
	ld bc, $3e
	call ByteFill
	ld a, $4
	ld hl, $53e5
	rst FarCall
	call ClearJoypadPublic
	; fallthrough
; 9673e


Function9673e: ; 9673e
	xor a
	ld [$d453], a
	ld [$d454], a
	call Function968d1
	callba Function15363
	call Function966cb
	ld a, [$ff9f]
	cp $f7
	jr nz, .asm_9675a
	call Function966d0
.asm_9675a
	ld a, [$ff9f]
	cp $f3
	jr nz, .asm_96764
	xor a
	ld [PoisonStepCount], a
.asm_96764
	xor a
	ld [$ff9f], a
	ld a, $2
	ld [$d432], a
	ret
; 9676d


Function9676d: ; 9676d
	ld c, 30
	call DelayFrames
	ret
; 96773


Function96773: ; 96773
	call ResetOverworldDelay
	call Function967c1
	callba Function97e08
	call DoEvents
	ld a, [$d432]
	cp 2
	ret nz
	call Function967d1
	call NextOverworldFrame
	call Function967e1
	call Function967f4
	ret
; 96795


DoEvents: ; 96795
	ld a, [$d433]
	ld hl, .pointers
	rst JumpTable
	ret

.pointers
	dw Function967a1
	dw Function967ae
; 967a1

Function967a1: ; 967a1
	call PlayerEvents
	call Function966cb
	callba ScriptEvents
	ret
; 967ae

Function967ae: ; 967ae
	ret
; 967af


MaxOverworldDelay: ; 967af
	db 2
; 967b0

ResetOverworldDelay: ; 967b0
	ld a, [MaxOverworldDelay]
	ld [OverworldDelay], a
	ret
; 967b7

NextOverworldFrame: ; 967b7
	ld a, [OverworldDelay]
	and a
	ret z
	ld c, a
	call DelayFrames
	ret
; 967c1


Function967c1: ; 967c1
	ld a, [$d433]
	cp 1
	ret z
	call UpdateTime
	call GetJoypadPublic
	call TimeOfDayPals
	ret
; 967d1

Function967d1: ; 967d1
	callba Function576a
	ld a, $3
	ld hl, $5497
	rst FarCall
	call Function96812
	ret
; 967e1

Function967e1: ; 967e1
	callba Function5920
	ld a, $3
	ld hl, $54d2
	rst FarCall
	ld a, $2e
	ld hl, $4098
	rst FarCall
	ret
; 967f4

Function967f4: ; 967f4
	ld a, [$d150]
	bit 5, a
	jr z, .asm_96806
	bit 6, a
	jr z, .asm_9680c
	bit 4, a
	jr nz, .asm_9680c
	call Function966d0

.asm_96806
	ld a, $0
	ld [$d433], a
	ret

.asm_9680c
	ld a, $1
	ld [$d433], a
	ret
; 96812

Function96812: ; 96812
	ld hl, $d150
	bit 6, [hl]
	ret z
	ld a, $2
	ld hl, $41ca
	rst FarCall

	ret
; 9681f


PlayerEvents: ; 9681f

	xor a

	ld a, [ScriptRunning]
	and a
	ret nz

	call Function968e4

	call CheckTrainerBattle3
	jr c, .asm_96848

	call CheckTileEvent
	jr c, .asm_96848

	call Function97c30
	jr c, .asm_96848

	call Function968ec
	jr c, .asm_96848

	call Function9693a
	jr c, .asm_96848

	call OWPlayerInput
	jr c, .asm_96848

	xor a
	ret


.asm_96848
	push af
	callba Function96c56
	pop af

	ld [ScriptRunning], a
	call Function96beb
	ld a, [ScriptRunning]
	cp 4
	jr z, .asm_96865
	cp 9
	jr z, .asm_96865

	xor a
	ld [$c2da], a

.asm_96865
	scf
	ret
; 96867


CheckTrainerBattle3: ; 96867
	nop
	nop
	call CheckTrainerBattle2
	jr nc, .asm_96872
	ld a, 1
	scf
	ret

.asm_96872
	xor a
	ret
; 96874


CheckTileEvent: ; 96874
; Check for warps, tile triggers or wild battles.

	call Function9670c
	jr z, .asm_96886

	ld a, $41
	ld hl, $4820
	rst FarCall
	jr c, .asm_968a6

	call Function2238
	jr c, .asm_968aa

.asm_96886
	call Function96712
	jr z, .asm_96890

	call Function2ad4
	jr c, .asm_968ba

.asm_96890
	call Function96718
	jr z, .asm_96899

	call CountStep
	ret c

.asm_96899
	call Function9671e
	jr z, .asm_968a4

	call Function97cc0
	ret c
	jr .asm_968a4

.asm_968a4
	xor a
	ret

.asm_968a6
	ld a, 4
	scf
	ret

.asm_968aa
	ld a, [StandingTile]
	call CheckPitTile
	jr nz, .asm_968b6
	ld a, 6
	scf
	ret

.asm_968b6
	ld a, 5
	scf
	ret

.asm_968ba
	ld hl, MovementAnimation
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetMapEventBank
	call CallScript
	ret
; 968c7


Function968c7: ; 968c7
	ld hl, $d452
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret z
	scf
	ret
; 968d1

Function968d1: ; 968d1
	ld a, 5
	ld [$d452], a
	ret
; 968d7

Function968d7: ; 968d7
	ret
; 968d8

Function968d8: ; 968d8
	ld a, [$d452]
	cp 2
	ret nc
	ld a, 2
	ld [$d452], a
	ret
; 968e4

Function968e4: ; 968e4
	call Function966d6
	ret z
	call Function2f3e
	ret
; 968ec

Function968ec: ; 968ec
	ld a, [$dc07]
	and a
	jr z, .asm_96938

	ld c, a
	call Function211b
	cp c
	jr nc, .asm_96938

	ld e, a
	ld d, 0
	ld hl, $dc08
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	add hl, de
	add hl, de
	add hl, de

	call GetMapEventBank
	call GetFarHalfword
	call GetMapEventBank
	call CallScript

	ld hl, ScriptFlags
	res 3, [hl]

	callba Function96c56
	callba ScriptEvents

	ld hl, ScriptFlags
	bit 3, [hl]
	jr z, .asm_96938

	ld hl, $d44f
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [$d44e]
	call CallScript
	scf
	ret

.asm_96938
	xor a
	ret
; 9693a

Function9693a: ; 9693a
	ld a, [InLinkBattle]
	and a
	jr nz, .asm_96964
	ld hl, StatusFlags2
	bit 2, [hl]
	jr z, .asm_96951
	ld a, $4
	ld hl, Route7_SecondMapHeader
	rst FarCall
	jr c, .asm_96966
	xor a
	ret

.asm_96951
	ld a, $4
	ld hl, $5452
	rst FarCall
	ld a, $4
	ld hl, $54e7
	rst FarCall
	ld a, $24
	ld hl, $4074
	rst FarCall
	ret c

.asm_96964
	xor a
	ret

.asm_96966
	ld a, $4
	ld hl, $75f8
	call CallScript
	scf
	ret
; 96970

Function96970: ; 96970
	ld a, 8
	scf
	ret
; 96974


OWPlayerInput: ; 96974

	call PlayerMovement
	ret c
	and a
	jr nz, .NoAction

; Can't perform button actions while sliding on ice.
	callba Function80404
	jr c, .NoAction

	call CheckAPressOW
	jr c, .Action

	call CheckMenuOW
	jr c, .Action

.NoAction
	xor a
	ret

.Action
	push af
	callba Function80422
	pop af
	scf
	ret
; 96999


CheckAPressOW: ; 96999
	ld a, [hJoyPressed]
	and BUTTON_A
	ret z
	call TryObjectEvent
	ret c
	call TryReadSign
	ret c
	call Function97c5f
	ret c
	xor a
	ret
; 969ac


PlayTalkObject: ; 969ac
	push de
	ld de, SFX_READ_TEXT_2
	call StartSFX
	pop de
	ret
; 969b5


TryObjectEvent: ; 969b5
	callba CheckFacingObject
	jr c, .IsObject
	xor a
	ret

.IsObject
	call PlayTalkObject
	ld a, [hConnectedMapWidth]
	call Function1ae5
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	ld [$ffe0], a

	ld a, [$ffe0]
	call GetMapObject
	ld hl, $0008
	add hl, bc
	ld a, [hl]
	and $f

; Bug: If IsInArray returns nc, data at bc will be executed as code.
	push bc
	ld de, 3
	ld hl, .data_969ee
	call IsInArray
	jr nc, .asm_969ec
	pop bc

	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

.asm_969ec
	xor a
	ret

.data_969ee
	dbw 0, .zero
	dbw 1, .one
	dbw 2, .two
	dbw 3, .three
	dbw 4, .four
	dbw 5, .five
	dbw 6, .six
	db $ff
; 96a04

.zero ; 96a04
	ld hl, $000a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetMapEventBank
	call CallScript
;	ld a, -1
	ret
; 96a12

.one ; 96a12
	ld hl, $000a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetMapEventBank
	ld de, EngineBuffer1
	ld bc, 2
	call FarCopyBytes
	ld a, 3
	scf
	ret
; 96a29

.two ; 96a29
	call Function3674
	ld a, 2
	scf
	ret
; 96a30

.three ; 96a30
	xor a
	ret
; 96a32

.four ; 96a32
	xor a
	ret
; 96a34

.five ; 96a34
	xor a
	ret
; 96a36

.six ; 96a36
	xor a
	ret
; 96a38


TryReadSign: ; 96a38
	call CheckFacingSign
	jr c, .IsSign
	xor a
	ret

.IsSign
	ld a, [MartPointer]
	ld hl, .signs
	rst JumpTable
	ret

.signs
	dw .read
	dw .up
	dw .down
	dw .right
	dw .left
	dw .ifset
	dw .ifnotset
	dw .itemifset
	dw .asm_96aa2
; 96a59

.up
	ld b, UP << 2
	jr .checkdir
.down
	ld b, DOWN << 2
	jr .checkdir
.right
	ld b, RIGHT << 2
	jr .checkdir
.left
	ld b, LEFT << 2
	jr .checkdir

.checkdir
	ld a, [PlayerDirection]
	and %1100
	cp b
	jp nz, .dontread

.read
	call PlayTalkObject
	ld hl, $d041
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetMapEventBank
	call CallScript
	scf
	ret

.itemifset
	call CheckSignFlag
	jp nz, .dontread
	call PlayTalkObject
	call GetMapEventBank
	ld de, EngineBuffer1
	ld bc, 3
	call FarCopyBytes
	ld a, $4
	ld hl, $7625
	call CallScript
	scf
	ret

.asm_96aa2
	call CheckSignFlag
	jr nz, .dontread
	call GetMapEventBank
	ld de, EngineBuffer1
	ld bc, 3
	call FarCopyBytes
	jr .dontread

.ifset
	call CheckSignFlag
	jr z, .dontread
	jr .asm_96ac1

.ifnotset
	call CheckSignFlag
	jr nz, .dontread

.asm_96ac1
	push hl
	call PlayTalkObject
	pop hl
	inc hl
	inc hl
	call GetMapEventBank
	call GetFarHalfword
	call GetMapEventBank
	call CallScript
	scf
	ret

.dontread
	xor a
	ret
; 96ad8


CheckSignFlag: ; 96ad8
	ld hl, $d041
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	call GetMapEventBank
	call GetFarHalfword
	ld e, l
	ld d, h
	ld b, $2
	call EventFlagAction
	ld a, c
	and a
	pop hl
	ret
; 96af0


PlayerMovement: ; 96af0
	callba DoPlayerMovement
	ld a, c
	ld hl, .pointers
	rst JumpTable
	ld a, c
	ret
; 96afd

.pointers
	dw .zero
	dw .one
	dw .two
	dw .three
	dw .four
	dw .five
	dw .six
	dw .seven

.zero
.four ; 96b0d
	xor a
	ld c, a
	ret
; 96b10

.seven ; 96b10
	call Function968d7 ; empty
	xor a
	ld c, a
	ret
; 96b16

.one ; 96b16
	ld a, 5
	ld c, a
	scf
	ret
; 96b1b

.two ; 96b1b
	ld a, 9
	ld c, a
	scf
	ret
; 96b20

.three ; 96b20
; force the player to move in some direction
	ld a, $4
	ld hl, $653d
	call CallScript
;	ld a, -1
	ld c, a
	scf
	ret
; 96b2b

.five
.six ; 96b2b
	ld a, -1
	ld c, a
	and a
	ret
; 96b30


CheckMenuOW: ; 96b30
	xor a
	ld [$ffa0], a
	ld [$ffa1], a
	ld a, [hJoyPressed]

	bit 2, a ; SELECT
	jr nz, .Select

	bit 3, a ; START
	jr z, .NoMenu

	ld a, BANK(StartMenuScript)
	ld hl, StartMenuScript
	call CallScript
	scf
	ret

.NoMenu
	xor a
	ret

.Select
	call PlayTalkObject
	ld a, BANK(SelectMenuScript)
	ld hl, SelectMenuScript
	call CallScript
	scf
	ret
; 96b58


StartMenuScript: ; 96b58
	3callasm BANK(StartMenu), StartMenu
	2jump StartMenuCallback
; 96b5f

SelectMenuScript: ; 96b5f
	3callasm BANK(SelectMenu), SelectMenu
	2jump SelectMenuCallback
; 96b66

StartMenuCallback:
SelectMenuCallback: ; 96b66
	copybytetovar $ffa0
	if_equal $80, .Script
	if_equal $ff, .Asm
	end
; 96b72

.Script ; 96b72
	2ptjump $d0e8
; 96b75

.Asm ; 96b75
	2ptcallasm $d0e8
	end
; 96b79


CountStep: ; 96b79
	ld a, [InLinkBattle]
	and a
	jr nz, .asm_96bc9

	ld a, $24
	ld hl, $4136
	rst FarCall
	jr c, .asm_96bcb

	call Function96bd7
	jr c, .asm_96bcb

	ld hl, PoisonStepCount
	inc [hl]
	ld hl, StepCount
	inc [hl]
	jr nz, .asm_96b9c

	callba StepHappiness

.asm_96b9c
	ld a, [StepCount]
	cp $80
	jr nz, .asm_96bab

	callba Function16f3e
	jr nz, .asm_96bcf

.asm_96bab
	callba DaycareStep

	ld hl, PoisonStepCount
	ld a, [hl]
	cp 4
	jr c, .asm_96bc3
	ld [hl], 0

	ld a, $14
	ld hl, $45da
	rst FarCall
	jr c, .asm_96bcb

.asm_96bc3
	callba Function97db3

.asm_96bc9
	xor a
	ret

.asm_96bcb
	ld a, -1
	scf
	ret

.asm_96bcf
	ld a, 8
	scf
	ret
; 96bd3


Function96bd3: ; 96bd3
	ld a, $7
	scf
	ret
; 96bd7

Function96bd7: ; 96bd7
	ld a, [$dca1]
	and a
	ret z
	dec a
	ld [$dca1], a
	ret nz
	ld a, $4
	ld hl, $7619
	call CallScript
	scf
	ret
; 96beb

Function96beb: ; 96beb
	ld a, [ScriptRunning]
	and a
	ret z
	cp $ff
	ret z
	cp $a
	ret nc

	ld c, a
	ld b, 0
	ld hl, ScriptPointers96c0c
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [ScriptBank], a
	ld a, [hli]
	ld [ScriptPos], a
	ld a, [hl]
	ld [ScriptPos + 1], a
	ret
; 96c0c

ScriptPointers96c0c: ; 96c0c
	dbw BANK(UnknownScript_0x96c2d), UnknownScript_0x96c2d
	dbw $2f, $6675 ; BANK(UnknownScript_0xbe675), UnknownScript_0xbe675
	dbw $2f, $666a ; BANK(UnknownScript_0xbe66a), UnknownScript_0xbe66a
	dbw $04, $62ce ; BANK(UnknownScript_0x122ce), UnknownScript_0x122ce
	dbw BANK(UnknownScript_0x96c4d), UnknownScript_0x96c4d
	dbw BANK(UnknownScript_0x96c34), UnknownScript_0x96c34
	dbw BANK(FallIntoMapScript), FallIntoMapScript
	dbw BANK(UnknownScript_0x124c8), UnknownScript_0x124c8
	dbw BANK(UnknownScript_0x96c2f), UnknownScript_0x96c2f
	dbw BANK(UnknownScript_0x96c4f), UnknownScript_0x96c4f
	dbw BANK(UnknownScript_0x96c2d), UnknownScript_0x96c2d
; 96c2d

UnknownScript_0x96c2d: ; 96c2d
	end
; 96c2e

UnknownScript_0x96c2e: ; 96c2e
	end
; 96c2f

UnknownScript_0x96c2f: ; 96c2f
	3callasm $05, $6f5e
	end
; 96c34

UnknownScript_0x96c34: ; 96c34
	warpsound
	newloadmap $f5
	end
; 96c38

FallIntoMapScript: ; 96c38
	newloadmap $f6
	playsound SFX_KINESIS
	applymovement $0, MovementData_0x96c48
	playsound SFX_STRENGTH
	2call UnknownScript_0x96c4a
	end
; 96c48

MovementData_0x96c48: ; 96c48
	skyfall
	step_end
; 96c4a

UnknownScript_0x96c4a: ; 96c4a
	earthquake 16
	end
; 96c4d

UnknownScript_0x96c4d: ; 96c4d
	reloadandreturn $f7
; 96c4f

UnknownScript_0x96c4f: ; 96c4f
	deactivatefacing $3
	3callasm BANK(Function96706), Function96706
	end
; 96c56


Function96c56: ; 96c56
	push af
	ld a, 1
	ld [ScriptMode], a
	pop af
	ret
; 96c5e


ScriptEvents: ; 96c5e
	call StartScript
.loop
	ld a, [ScriptMode]
	ld hl, .modes
	rst JumpTable
	call CheckScript
	jr nz, .loop
	ret
; 96c6e

.modes ; 96c6e
	dw EndScript
	dw RunScriptCommand
	dw WaitScriptMovement
	dw WaitScript

EndScript: ; 96c76
	call StopScript
	ret
; 96c7a

WaitScript: ; 96c7a
	call StopScript

	ld hl, ScriptDelay
	dec [hl]
	ret nz

	callba Function58b9

	ld a, SCRIPT_READ
	ld [ScriptMode], a
	call StartScript
	ret
; 96c91

WaitScriptMovement: ; 96c91
	call StopScript

	ld hl, VramState
	bit 7, [hl]
	ret nz

	callba Function58b9

	ld a, SCRIPT_READ
	ld [ScriptMode], a
	call StartScript
	ret
; 96ca9

RunScriptCommand: ; 96ca9
	call GetScriptByte
	ld hl, ScriptCommandTable
	rst JumpTable
	ret
; 96cb1


INCLUDE "engine/scripting.asm"


Function97c20: ; 97c20
	ld a, [.byte]
	ld [ScriptVar], a
	ret

.byte
	db 0
; 97c28

Function97c28: ; 97c28
	ld hl, StatusFlags2
	res 1, [hl]
	res 2, [hl]
	ret
; 97c30

Function97c30: ; 97c30
	ld a, [$d45c]
	and a
	ret z
	ld hl, $d45e
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [$d45d]
	call CallScript
	scf
	push af
	xor a
	ld hl, $d45c
	ld bc, 8
	call ByteFill
	pop af
	ret
; 97c4f

Function97c4f: ; 97c4f
	ld hl, $d45c
	ld a, [hl]
	and a
	ret nz
	ld [hl], 1
	inc hl
	ld [hl], b
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	scf
	ret
; 97c5f

Function97c5f: ; 97c5f
	call GetFacingTileCoord
	ld [EngineBuffer1], a
	ld c, a
	callba Function1365b
	jr c, .asm_97cb9

	call CheckCutTreeTile
	jr nz, .whirlpool
	callba TryCutOW
	jr .asm_97cb9

.whirlpool
	ld a, [EngineBuffer1]
	call CheckWhirlpoolTile
	jr nz, .waterfall
	callba TryWhirlpoolOW
	jr .asm_97cb9

.waterfall
	ld a, [EngineBuffer1]
	call CheckWaterfallTile
	jr nz, .headbutt
	callba TryWaterfallOW
	jr .asm_97cb9

.headbutt
	ld a, [EngineBuffer1]
	call CheckHeadbuttTreeTile
	jr nz, .surf
	callba TryHeadbuttOW
	jr c, .asm_97cb9
	jr .asm_97cb7

.surf
	callba TrySurfOW
	jr nc, .asm_97cb7
	jr .asm_97cb9

.asm_97cb7
	xor a
	ret

.asm_97cb9
	call PlayClickSFX
	ld a, $ff
	scf
	ret
; 97cc0


Function97cc0: ; 97cc0
; Rock Smash encounter

	call Function968c7
	jr c, .asm_97ce2
	call Function97cfd
	jr nc, .asm_97ce2
	ld hl, StatusFlags2
	bit 2, [hl]
	jr nz, .asm_97cdb
	callba Function2a0e7
	jr nz, .asm_97ce2
	jr .asm_97ce6

.asm_97cdb
	call Function97d23
	jr nc, .asm_97ce2
	jr .asm_97ced

.asm_97ce2
	ld a, 1
	and a
	ret

.asm_97ce6
	ld a, BANK(RockSmashBattleScript)
	ld hl, RockSmashBattleScript
	jr .asm_97cf4

.asm_97ced
	ld a, BANK(UnknownScript_0x135eb)
	ld hl, UnknownScript_0x135eb
	jr .asm_97cf4

.asm_97cf4
	call CallScript
	scf
	ret
; 97cf9

RockSmashBattleScript: ; 97cf9
	battlecheck
	startbattle
	returnafterbattle
	end
; 97cfd

Function97cfd: ; 97cfd
	ld hl, StatusFlags
	bit 5, [hl]
	jr nz, .asm_97d21
	ld a, [$d19a]
	cp $4
	jr z, .asm_97d17
	cp $7
	jr z, .asm_97d17
	ld a, $5
	ld hl, $49dd
	rst FarCall
	jr nc, .asm_97d21

.asm_97d17
	ld a, [StandingTile]
	call CheckIceTile
	jr z, .asm_97d21
	scf
	ret

.asm_97d21
	and a
	ret
; 97d23

Function97d23: ; 97d23
	call Function97d64
	ret nc
	call Function97d31
	ld a, $a
	ld hl, $61df
	rst FarCall
	ret
; 97d31

Function97d31: ; 97d31
.asm_97d31
	call Random
	cp 100 << 1
	jr nc, .asm_97d31
	srl a
	ld hl, Table97d87
	ld de, 4
.asm_97d40
	sub [hl]
	jr c, .asm_97d46
	add hl, de
	jr .asm_97d40

.asm_97d46
	inc hl
	ld a, [hli]
	ld [$d22e], a
	ld a, [hli]
	ld d, a
	ld a, [hl]
	sub d
	jr nz, .asm_97d54
	ld a, d
	jr .asm_97d5f

.asm_97d54
	ld c, a
	inc c
	call Random
	ld a, [hRandomAdd]
	call SimpleDivide
	add d

.asm_97d5f
	ld [CurPartyLevel], a
	xor a
	ret
; 97d64

Function97d64: ; 97d64
	ld a, [StandingTile]
	call Function188e
	ld b, $66
	jr z, .asm_97d70
	ld b, $33

.asm_97d70
	ld a, $a
	ld hl, $6124
	rst FarCall
	ld a, $a
	ld hl, $6138
	rst FarCall
	call Random
	ld a, [hRandomAdd]
	cp b
	ret c
	ld a, 1
	and a
	ret
; 97d87

Table97d87: ; 97d87
	db 20, $0a, $07, $12
	db 20, $0d, $07, $12
	db 10, $0b, $09, $12
	db 10, $0e, $09, $12
	db  5, $0c, $0c, $0f
	db  5, $0f, $0c, $0f
	db 10, $30, $0a, $10
	db 10, $2e, $0a, $11
	db  5, $7b, $0d, $0e
	db  5, $7f, $0d, $0e
	db -1, $31, $1e, $28
; 97db3

Function97db3: ; 97db3
	nop
	nop
	; fallthrough
; 97db5

Function97db5: ; 97db5
	ld hl, StatusFlags2
	bit 4, [hl]
	jr z, .asm_97df7
	ld a, [PlayerState]
	cp $1
	jr nz, .asm_97df7
	call Function2d05
	and a
	jr nz, .asm_97df7
	ld hl, $dca2
	ld a, [hli]
	ld d, a
	ld e, [hl]
	cp $ff
	jr nz, .asm_97dd8
	ld a, e
	cp $ff
	jr z, .asm_97ddc

.asm_97dd8
	inc de
	ld [hl], e
	dec hl
	ld [hl], d

.asm_97ddc
	ld a, d
	cp $4
	jr c, .asm_97df7
	ld a, [$dc31]
	and a
	jr nz, .asm_97df7
	ld a, $6
	ld [$dc31], a
	xor a
	ld [$dc32], a
	ld hl, StatusFlags2
	res 4, [hl]
	scf
	ret

.asm_97df7
	xor a
	ret
; 97df9

Function97df9: ; 97df9
	ld hl, $d6de
	ld de, $0006
	ld c, $4
	xor a
.asm_97e02
	ld [hl], a
	add hl, de
	dec c
	jr nz, .asm_97e02
	ret
; 97e08

Function97e08: ; 97e08
	ld hl, $d6de
	xor a
.asm_97e0c
	ld [hConnectionStripLength], a
	ld a, [hl]
	and a
	jr z, .asm_97e19
	push hl
	ld b, h
	ld c, l
	call Function97e79
	pop hl

.asm_97e19
	ld de, $0006
	add hl, de
	ld a, [hConnectionStripLength]
	inc a
	cp $4
	jr nz, .asm_97e0c
	ret
; 97e25

Function97e25: ; 97e25
	ld hl, $d6de
	ld bc, 6
	call AddNTimes
	ld b, h
	ld c, l
	ret
; 97e31

Function97e31: ; 97e31
	push bc
	push de
	call Function97e45
	ld d, h
	ld e, l
	pop hl
	pop bc
	ret c
	ld a, b
	ld bc, $0005
	call FarCopyBytes
	xor a
	ld [hl], a
	ret
; 97e45

Function97e45: ; 97e45
	ld hl, $d6de
	ld de, $0006
	ld c, $4
.asm_97e4d
	ld a, [hl]
	and a
	jr z, .asm_97e57
	add hl, de
	dec c
	jr nz, .asm_97e4d
	scf
	ret

.asm_97e57
	ld a, $4
	sub c
	and a
	ret
; 97e5c

Function97e5c: ; 97e5c
	ld hl, $d6de
	ld de, $0006
	ld c, $4
.asm_97e64
	ld a, [hl]
	cp b
	jr z, .asm_97e6e
	add hl, de
	dec c
	jr nz, .asm_97e64
	and a
	ret

.asm_97e6e
	xor a
	ld [hl], a
	scf
	ret
; 97e72

Function97e72: ; 97e72
	ld hl, $0000
	add hl, bc
	ld [hl], 0
	ret
; 97e79

Function97e79: ; 97e79
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	cp 5
	jr c, .asm_97e83
	xor a

.asm_97e83
	ld e, a
	ld d, 0
	ld hl, Table97e94
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	push af
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	rst FarCall
	ret
; 97e94

Table97e94: ; 97e94
	dbw BANK(Function97eb7), Function97eb7
	dbw BANK(Function97eb8), Function97eb8
	dbw BANK(Function97f42), Function97f42
	dbw BANK(Function97ef9), Function97ef9
	dbw BANK(Function97ebc), Function97ebc
; 97ea3

Function97ea3: ; 97ea3
	ld hl, $0005
	add hl, bc
	ld a, [hl]
	pop hl
	rst JumpTable
	ret
; 97eab

Function97eab: ; 97eab
	ld hl, $0005
	add hl, bc
	inc [hl]
	ret
; 97eb1

Function97eb1: ; 97eb1
	ld hl, $0005
	add hl, bc
	dec [hl]
	ret
; 97eb7

Function97eb7: ; 97eb7
	ret
; 97eb8

Function97eb8: ; 97eb8
	call Function2f3e
	ret
; 97ebc

Function97ebc: ; 97ebc
	call Function97ea3
	dw Function97ec3
	dw Function97ecd
; 97ec3

Function97ec3: ; 97ec3
	ld a, [hSCY]
	ld hl, $0004
	add hl, bc
	ld [hl], a
	call Function97eab
; 97ecd

Function97ecd: ; 97ecd
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	dec a
	ld [hl], a
	jr z, .asm_97eee
	and $1
	jr z, .asm_97ee4
	ld hl, $0002
	add hl, bc
	ld a, [hSCY]
	sub [hl]
	ld [hSCY], a
	ret

.asm_97ee4
	ld hl, $0002
	add hl, bc
	ld a, [hSCY]
	add [hl]
	ld [hSCY], a
	ret

.asm_97eee
	ld hl, $0004
	add hl, bc
	ld a, [hl]
	ld [hSCY], a
	call Function97e72
	ret
; 97ef9

Function97ef9: ; 97ef9
	call Function97ea3
	dw Function97f02
	dw Function97f0a
	dw Function97f1b
; 97f02

Function97f02: ; 97f02
	call Function97f38
	jr z, Function97f2c
	call Function97eab
; 97f0a

Function97f0a: ; 97f0a
	call Function97f38
	jr z, Function97f2c
	call Function97eab

	ld hl, $0002
	add hl, bc
	ld a, [hl]
	ld [$d173], a
	ret
; 97f1b

Function97f1b: ; 97f1b
	call Function97f38
	jr z, Function97f2c
	call Function97eb1

	ld hl, $0003
	add hl, bc
	ld a, [hl]
	ld [$d173], a
	ret
; 97f2c

Function97f2c: ; 97f2c
	ld a, $7f
	ld [$d173], a
	ld hl, $0005
	add hl, bc
	ld [hl], 0
	ret
; 97f38

Function97f38: ; 97f38
	push bc
	ld bc, $d4d6
	call GetSpriteDirection
	and a
	pop bc
	ret
; 97f42

Function97f42: ; 97f42
	ld de, $d4d6
	ld a, $d
.asm_97f47
	push af

	ld hl, $0000
	add hl, de
	ld a, [hl]
	and a
	jr z, .asm_97f71

	ld hl, $0003
	add hl, de
	ld a, [hl]
	cp $19
	jr nz, .asm_97f71

	ld hl, $000e
	add hl, de
	ld a, [hl]
	call CheckPitTile
	jr nz, .asm_97f71

	ld hl, $0007
	add hl, de
	ld a, [hl]
	cp $ff
	jr nz, .asm_97f71
	call Function3567
	jr c, .asm_97f7c

.asm_97f71
	ld hl, $0028
	add hl, de
	ld d, h
	ld e, l

	pop af
	dec a
	jr nz, .asm_97f47
	ret

.asm_97f7c
	pop af
	ret
; 97f7e



SECTION "bank26",ROMX,BANK[$26]

;                          Map Scripts XI

INCLUDE "maps/EcruteakHouse.asm"
INCLUDE "maps/WiseTriosRoom.asm"
INCLUDE "maps/EcruteakPokeCenter1F.asm"
INCLUDE "maps/EcruteakLugiaSpeechHouse.asm"
INCLUDE "maps/DanceTheatre.asm"
INCLUDE "maps/EcruteakMart.asm"
INCLUDE "maps/EcruteakGym.asm"
INCLUDE "maps/EcruteakItemfinderHouse.asm"
INCLUDE "maps/ViridianGym.asm"
INCLUDE "maps/ViridianNicknameSpeechHouse.asm"
INCLUDE "maps/TrainerHouse1F.asm"
INCLUDE "maps/TrainerHouseB1F.asm"
INCLUDE "maps/ViridianMart.asm"
INCLUDE "maps/ViridianPokeCenter1F.asm"
INCLUDE "maps/ViridianPokeCenter2FBeta.asm"
INCLUDE "maps/Route2NuggetSpeechHouse.asm"
INCLUDE "maps/Route2Gate.asm"
INCLUDE "maps/VictoryRoadGate.asm"


SECTION "bank27",ROMX,BANK[$27]

;                         Map Scripts XII

INCLUDE "maps/OlivinePokeCenter1F.asm"
INCLUDE "maps/OlivineGym.asm"
INCLUDE "maps/OlivineVoltorbHouse.asm"
INCLUDE "maps/OlivineHouseBeta.asm"
INCLUDE "maps/OlivinePunishmentSpeechHouse.asm"
INCLUDE "maps/OlivineGoodRodHouse.asm"
INCLUDE "maps/OlivineCafe.asm"
INCLUDE "maps/OlivineMart.asm"
INCLUDE "maps/Route38EcruteakGate.asm"
INCLUDE "maps/Route39Barn.asm"
INCLUDE "maps/Route39Farmhouse.asm"
INCLUDE "maps/ManiasHouse.asm"
INCLUDE "maps/CianwoodGym.asm"
INCLUDE "maps/CianwoodPokeCenter1F.asm"
INCLUDE "maps/CianwoodPharmacy.asm"
INCLUDE "maps/CianwoodCityPhotoStudio.asm"
INCLUDE "maps/CianwoodLugiaSpeechHouse.asm"
INCLUDE "maps/PokeSeersHouse.asm"
INCLUDE "maps/BattleTower1F.asm"
INCLUDE "maps/BattleTowerBattleRoom.asm"
INCLUDE "maps/BattleTowerElevator.asm"
INCLUDE "maps/BattleTowerHallway.asm"
INCLUDE "maps/Route40BattleTowerGate.asm"
INCLUDE "maps/BattleTowerOutside.asm"


SECTION "bank28",ROMX,BANK[$28]

INCBIN "baserom.gbc", $a0000, $a1eca - $a0000


SECTION "bank29",ROMX,BANK[$29]

INCLUDE "text/phone/extra2.asm"


SECTION "bank2A",ROMX,BANK[$2A]

INCLUDE "maps/blockdata_1.asm"


SECTION "bank2B",ROMX,BANK[$2B]

INCLUDE "maps/blockdata_2.asm"


SECTION "bank2C",ROMX,BANK[$2C]

INCLUDE "maps/blockdata_3.asm"


SECTION "bank2D",ROMX,BANK[$2D]

INCLUDE "tilesets/data_5.asm"


SECTION "bank2E",ROMX,BANK[$2E]

Functionb8000: ; b8000
	xor a
	ld [hBGMapMode], a
	ld a, $2e
	ld hl, $400a
	rst FarCall
	ret
; b800a

Functionb800a: ; b800a
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call GetWorldMapLocation
	ld [$c2d9], a
	call Functionb8089
	jr z, .asm_b8024
	call GetMapPermission
	cp $6
	jr nz, .asm_b8029

.asm_b8024
	ld a, $ff
	ld [$c2d9], a

.asm_b8029
	ld hl, $d83e
	bit 1, [hl]
	res 1, [hl]
	jr nz, .asm_b8054
	call Functionb8064
	jr z, .asm_b8054
	ld a, [$c2d9]
	ld [$c2d8], a
	call Functionb8070
	jr z, .asm_b8054
	ld a, $3c
	ld [$c2da], a
	call Functionb80c6
	call Functionb80d3
	ld a, $41
	ld hl, $4303
	rst FarCall
	ret

.asm_b8054
	ld a, [$c2d9]
	ld [$c2d8], a
	ld a, $90
	ld [rWY], a
	ld [hWY], a
	xor a
	ld [hLCDStatCustom], a
	ret
; b8064

Functionb8064: ; b8064
	ld a, [$c2d9]
	ld c, a
	ld a, [$c2d8]
	cp c
	ret z
	cp $0
	ret
; b8070

Functionb8070: ; b8070
	cp $ff
	ret z
	cp $0
	ret z
	cp $11
	ret z
	cp $46
	ret z
	cp $3b
	ret z
	cp $5a
	ret z
	cp $44
	ret z
	ld a, $1
	and a
	ret
; b8089

Functionb8089: ; b8089
	ld a, [MapGroup]
	cp $a
	ret nz
	ld a, [MapNumber]
	cp $f
	ret z
	cp $11
	ret
; b8098

INCBIN "baserom.gbc", $b8098, $b80c6 - $b8098


Functionb80c6: ; b80c6
	ld de, $5344
	ld hl, $9600
	ld bc, $3e0e
	call Get2bpp
	ret
; b80d3

Functionb80d3: ; b80d3
	ld hl, TileMap
	ld b, $2
	ld c, $12
	call Functionb8115
	call Functionb812f
	ret
; b80e1

INCBIN "baserom.gbc", $b80e1, $b8115 - $b80e1


Functionb8115: ; b8115
	ld de, $0939
	add hl, de
	inc b
	inc b
	inc c
	inc c
	ld a, $87
.asm_b811f
	push bc
	push hl
.asm_b8121
	ld [hli], a
	dec c
	jr nz, .asm_b8121
	pop hl
	ld de, $0014
	add hl, de
	pop bc
	dec b
	jr nz, .asm_b811f
	ret
; b812f

Functionb812f: ; b812f
	ld hl, TileMap
	ld a, $61
	ld [hli], a
	ld a, $62
	call Functionb8164
	ld a, $64
	ld [hli], a
	ld a, $65
	ld [hli], a
	call Functionb815b
	ld a, $6b
	ld [hli], a
	ld a, $66
	ld [hli], a
	call Functionb815b
	ld a, $6c
	ld [hli], a
	ld a, $67
	ld [hli], a
	ld a, $68
	call Functionb8164
	ld a, $6a
	ld [hl], a
	ret
; b815b

Functionb815b: ; b815b
	ld c, $12
	ld a, $6d
.asm_b815f
	ld [hli], a
	dec c
	jr nz, .asm_b815f
	ret
; b8164

Functionb8164: ; b8164
	ld c, $5
	jr .asm_b816a

.asm_b8168
	ld [hli], a
	ld [hli], a

.asm_b816a
	inc a
	ld [hli], a
	ld [hli], a
	dec a
	dec c
	jr nz, .asm_b8168
	ret
; b8172

Functionb8172: ; b8172
	call GetMapEventBank
	ld [MagikarpLength], a
	ld a, [XCoord]
	add $5
	ld [$d1ed], a
	ld a, [YCoord]
	add $4
	ld [$d1ec], a
	ld hl, $dc02
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [$dc01]
	and a
	jr z, .asm_b81dd
.asm_b8194
	ld [Buffer2], a
	push hl
	call Functionb81e2
	ld e, a
	ld a, [$d1ec]
	sub e
	jr c, .asm_b81d2
	cp $9
	jr nc, .asm_b81d2
	call Functionb81e2
	ld d, a
	ld a, [$d1ed]
	sub d
	jr c, .asm_b81d2
	cp $a
	jr nc, .asm_b81d2
	call Functionb81e2
	cp $7
	jr nz, .asm_b81d2
	ld a, [MagikarpLength]
	call GetFarHalfword
	ld a, [MagikarpLength]
	call GetFarHalfword
	ld d, h
	ld e, l
	ld b, $2
	call EventFlagAction
	ld a, c
	and a
	jr z, .asm_b81df

.asm_b81d2
	pop hl
	ld bc, $0005
	add hl, bc
	ld a, [Buffer2]
	dec a
	jr nz, .asm_b8194

.asm_b81dd
	xor a
	ret

.asm_b81df
	pop hl
	scf
	ret
; b81e2

Functionb81e2: ; b81e2
	ld a, [MagikarpLength]
	call GetFarByte
	inc hl
	ret
; b81ea

INCBIN "baserom.gbc", $b81ea, $b8219 - $b81ea

Functionb8219: ; b8219
; deals strictly with rockmon encounter
	xor a
	ld [$d22e], a
	ld [CurPartyLevel], a
	ld hl, WildRockMonMapTable
	call GetTreeMonEncounterTable
	jr nc, .quit
	call LoadWildTreeMonData
	jr nc, .quit
	ld a, $0a
	call Function2fb1
	cp a, $04
	jr nc, .quit
	call $441f
	jr nc, .quit
	ret
.quit
	xor a
	ret
; b823e

db $05 ; ????

GetTreeMonEncounterTable: ; b823f
; reads a map-sensitive encounter table
; compares current map with maps in the table
; if there is a match, encounter table # is loaded into a
	ld a, [MapNumber]
	ld e, a
	ld a, [MapGroup]
	ld d, a
.loop
	ld a, [hli]
	cp a, $ff
	jr z, .quit
	cp d
	jr nz, .skip2
	ld a, [hli]
	cp e
	jr nz, .skip1
	jr .end
.skip2
	inc hl
.skip1
	inc hl
	jr .loop
.quit
	xor a
	ret
.end
	ld a, [hl]
	scf
	ret
; b825e

INCBIN "baserom.gbc", $B825E, $b82c5 - $b825e

WildRockMonMapTable: ; b82c5
	db GROUP_CIANWOOD_CITY, MAP_CIANWOOD_CITY, $07
	db GROUP_ROUTE_40, MAP_ROUTE_40, $07
	db GROUP_DARK_CAVE_VIOLET_ENTRANCE, MAP_DARK_CAVE_VIOLET_ENTRANCE, $07
	db GROUP_SLOWPOKE_WELL_B1F, MAP_SLOWPOKE_WELL_B1F, $07
	db $ff ; end
; b82d2

LoadWildTreeMonData: ; b82d2
; input: a = table number
; returns wildtreemontable pointer in hl
; sets carry if successful
	cp a, $08 ; which table?
	jr nc, .quit ; only 8 tables
	and a
	jr z, .quit ; 0 is invalid
	ld e, a
	ld d, $00
	ld hl, WildTreeMonPointerTable
	add hl, de
	add hl, de
	ld a, [hli] ; store pointer in hl
	ld h, [hl]
	ld l, a
	scf
	ret
.quit
	xor a
	ret
; b82e8

WildTreeMonPointerTable: ; b82e8
; seems to point to "normal" tree encounter data
; as such only odd-numbered tables are used
; rockmon is 13th
	dw WildTreeMonTable1  ; filler
	dw WildTreeMonTable1  ; 1
	dw WildTreeMonTable3  ; 2
	dw WildTreeMonTable5  ; 3
	dw WildTreeMonTable7  ; 4
	dw WildTreeMonTable9  ; 5
	dw WildTreeMonTable11 ; 6
	dw WildRockMonTable   ; 7
	dw WildTreeMonTable1  ; 8
; b82fa

; structure: % species level

WildTreeMonTable1: ; b82fa
	db 50, SPEAROW, 10
	db 15, SPEAROW, 10
	db 15, SPEAROW, 10
	db 10, AIPOM, 10
	db 5, AIPOM, 10
	db 5, AIPOM, 10
	db $ff ; end
; b830d

WildTreeMonTable2 ; b830d
; unused
	db 50, SPEAROW, 10
	db 15, HERACROSS, 10
	db 15, HERACROSS, 10
	db 10, AIPOM, 10
	db 5, AIPOM, 10
	db 5, AIPOM, 10
	db $ff ; end
; b8320

WildTreeMonTable3: ; b8320
	db 50, SPEAROW, 10
	db 15, EKANS, 10
	db 15, SPEAROW, 10
	db 10, AIPOM, 10
	db 5, AIPOM, 10
	db 5, AIPOM, 10
	db $ff ; end
; b8333

WildTreeMonTable4: ; b8333
; unused
	db 50, SPEAROW, 10
	db 15, HERACROSS, 10
	db 15, HERACROSS, 10
	db 10, AIPOM, 10
	db 5, AIPOM, 10
	db 5, AIPOM, 10
	db $ff ; end
; b8346

WildTreeMonTable5: ; b8346
	db 50, HOOTHOOT, 10
	db 15, SPINARAK, 10
	db 15, LEDYBA, 10
	db 10, EXEGGCUTE, 10
	db 5, EXEGGCUTE, 10
	db 5, EXEGGCUTE, 10
	db $ff ; end
; b8359

WildTreeMonTable6: ; b8359
; unused
	db 50, HOOTHOOT, 10
	db 15, PINECO, 10
	db 15, PINECO, 10
	db 10, EXEGGCUTE, 10
	db 5, EXEGGCUTE, 10
	db 5, EXEGGCUTE, 10
	db $ff ; end
; b836c

WildTreeMonTable7: ; b836c
	db 50, HOOTHOOT, 10
	db 15, EKANS, 10
	db 15, HOOTHOOT, 10
	db 10, EXEGGCUTE, 10
	db 5, EXEGGCUTE, 10
	db 5, EXEGGCUTE, 10
	db $ff ; end
; b837f

WildTreeMonTable8: ; b837f
; unused
	db 50, HOOTHOOT, 10
	db 15, PINECO, 10
	db 15, PINECO, 10
	db 10, EXEGGCUTE, 10
	db 5, EXEGGCUTE, 10
	db 5, EXEGGCUTE, 10
	db $ff ; end
; b8392

WildTreeMonTable9: ; b8392
	db 50, HOOTHOOT, 10
	db 15, VENONAT, 10
	db 15, HOOTHOOT, 10
	db 10, EXEGGCUTE, 10
	db 5, EXEGGCUTE, 10
	db 5, EXEGGCUTE, 10
	db $ff ; end
; b83a5

WildTreeMonTable10: ; b83a5
; unused
	db 50, HOOTHOOT, 10
	db 15, PINECO, 10
	db 15, PINECO, 10
	db 10, EXEGGCUTE, 10
	db 5, EXEGGCUTE, 10
	db 5, EXEGGCUTE, 10
	db $ff ; end
; b83b8

WildTreeMonTable11: ; b83b8
	db 50, HOOTHOOT, 10
	db 15, PINECO, 10
	db 15, PINECO, 10
	db 10, NOCTOWL, 10
	db 5, BUTTERFREE, 10
	db 5, BEEDRILL, 10
	db $ff ; end
; b83cb

WildTreeMonTable12; b83cb
; unused
	db 50, HOOTHOOT, 10
	db 15, CATERPIE, 10
	db 15, WEEDLE, 10
	db 10, HOOTHOOT, 10
	db 5, METAPOD, 10
	db 5, KAKUNA, 10
	db $ff ; end
; b83de

WildRockMonTable: ; b83de
	db 90, KRABBY, 15
	db 10, SHUCKLE, 15
	db $ff ; end
; b83e5

INCBIN "baserom.gbc", $b83e5, $b9229 - $b83e5

Functionb9229: ; b9229
	ld a, [CurPartyMon]
	ld hl, $a600
	ld bc, $002f
	call AddNTimes
	ld d, h
	ld e, l
	push de
	call WhiteBGMap
	call ClearSprites
	call ClearTileMap
	call DisableLCD
	call Functione5f
	pop de
	push de
	ld a, $0
	call GetSRAMBank
	ld a, $77
	ld hl, $65c8
	rst FarCall
	call CloseSRAM
	ld a, c
	ld de, $65e6
	or a
	jr z, .asm_b9268
	ld de, $69e6
	sub $3
	jr c, .asm_b9268
	ld de, $6de6

.asm_b9268
	ld hl, VTiles1
	ld bc, $7780
	call Get1bpp
	pop de
	call Functionb92b8
	call EnableLCD
	call WaitBGMap
	ld a, [$d1ec]
	ld e, a
	ld a, $2
	ld hl, $4cb4
	rst FarCall
	call Function32f9
	xor a
	ld [hJoyPressed], a
	call Functionb929a
	call WhiteBGMap
	call DisableLCD
	call Functione51
	jp EnableLCD
; b929a

Functionb929a: ; b929a
.asm_b929a
	call GetJoypadPublic
	ld a, [hJoyPressed]
	and $b
	jr z, .asm_b929a
	and $8
	jr nz, .asm_b92a8
	ret

.asm_b92a8
	ld a, [$cf63]
	push af
	ld hl, $45d4
	ld a, $21
	rst FarCall
	pop af
	ld [$cf63], a
	jr .asm_b929a
; b92b8

Functionb92b8: ; b92b8
	ld h, d
	ld l, e
	push hl
	ld a, $0
	call GetSRAMBank
	ld de, $002b
	add hl, de
	ld a, [hli]
	ld [Buffer1], a
	ld a, [hli]
	ld [Buffer2], a
	ld a, [hli]
	ld [CurPartySpecies], a
	ld b, [hl]
	call CloseSRAM
	ld hl, $52f8
	ld c, $0
.asm_b92d9
	ld a, [hli]
	cp b
	jr z, .asm_b92ea
	cp $ff
	jr z, .asm_b92e6
	inc c
	inc hl
	inc hl
	jr .asm_b92d9

.asm_b92e6
	ld hl, $52f8
	inc hl

.asm_b92ea
	ld a, c
	ld [$d1ec], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $52f7
	pop bc
	push de
	jp [hl]
; b92f7

INCBIN "baserom.gbc", $b92f7, $b9e76 - $b92f7


Functionb9e76: ; b9e76
	ld a, d
	ld hl, $5e80
	ld de, $0001
	jp IsInArray
; b9e80

INCBIN "baserom.gbc", $b9e80, $b9e8b - $b9e80


SECTION "bank2F",ROMX,BANK[$2F]

INCBIN "baserom.gbc", $bc000, $bc09c - $bc000

PokeCenterNurseScript: ; bc09c
; Talking to a nurse in a Pokemon Center

	loadfont
; The nurse has different text for:
; Morn
	checktime $1
	iftrue .morn
; Day
	checktime $2
	iftrue .day
; Nite
	checktime $4
	iftrue .nite
; If somehow it's not a time of day at all, we skip the introduction
	2jump .heal

.morn
; Different text if we're in the com center
	checkbit1 $032a
	iftrue .morn_comcenter
; Good morning! Welcome to ...
	3writetext BANK(UnknownText_0x1b0000), UnknownText_0x1b0000
	keeptextopen
	2jump .heal
.morn_comcenter
; Good morning! This is the ...
	3writetext BANK(UnknownText_0x1b008a), UnknownText_0x1b008a
	keeptextopen
	2jump .heal

.day
; Different text if we're in the com center
	checkbit1 $032a
	iftrue .day_comcenter
; Hello! Welcome to ...
	3writetext BANK(UnknownText_0x1b002b), UnknownText_0x1b002b
	keeptextopen
	2jump .heal
.day_comcenter
; Hello! This is the ...
	3writetext BANK(UnknownText_0x1b00d6), UnknownText_0x1b00d6
	keeptextopen
	2jump .heal

.nite
; Different text if we're in the com center
	checkbit1 $032a
	iftrue .nite_comcenter
; Good evening! You're out late. ...
	3writetext BANK(UnknownText_0x1b004f), UnknownText_0x1b004f
	keeptextopen
	2jump .heal
.nite_comcenter
; Good to see you working so late. ...
	3writetext BANK(UnknownText_0x1b011b), UnknownText_0x1b011b
	keeptextopen
	2jump .heal

.heal
; If we come back, don't welcome us to the com center again
	clearbit1 $032a
; Ask if you want to heal
	3writetext BANK(UnknownText_0x1b017a), UnknownText_0x1b017a
	yesorno
	iffalse .end
; Go ahead and heal
	3writetext BANK(UnknownText_0x1b01bd), UnknownText_0x1b01bd
	pause 20
	special $009d
; Turn to the machine
	spriteface $fe, $2
	pause 10
	special $001b
	playmusic $0000
	writebyte $0
	special $003e
	pause 30
	special $003d
	spriteface $fe, $0
	pause 10
; Has Elm already phoned you about Pokerus?
	checkphonecall
	iftrue .done
; Has Pokerus already been found in the Pokecenter?
	checkbit2 $000d
	iftrue .done
; Check for Pokerus
	special $004e ; SPECIAL_CHECKPOKERUS
	iftrue .pokerus
.done
; Thank you for waiting. ...
	3writetext BANK(UnknownText_0x1b01d7), UnknownText_0x1b01d7
	pause 20
.end
; We hope to see you again.
	3writetext BANK(UnknownText_0x1b020b), UnknownText_0x1b020b
; Curtsy
	spriteface $fe, $1
	pause 10
	spriteface $fe, $0
	pause 10
; And we're out
	closetext
	loadmovesprites
	end

.pokerus
; Different text for com center (excludes 'in a Pokemon Center')
; Since flag $32a is cleared when healing,
; this text is never actually seen
	checkbit1 $032a
	iftrue .pokerus_comcenter
; Your Pokemon appear to be infected ...
	3writetext BANK(UnknownText_0x1b0241), UnknownText_0x1b0241
	closetext
	loadmovesprites
	2jump .endpokerus
.pokerus_comcenter
; Your Pokemon appear to be infected ...
	3writetext BANK(UnknownText_0x1b02d6), UnknownText_0x1b02d6
	closetext
	loadmovesprites
.endpokerus
; Don't tell us about Pokerus again
	setbit2 $000d
; Trigger Elm's Pokerus phone call
	specialphonecall $0001
	end
; bc162

INCBIN "baserom.gbc", $bc162, $bcea5-$bc162

UnusedPhoneScript: ; 0xbcea5
	3writetext BANK(UnusedPhoneText), UnusedPhoneText
	end

MomPhoneScript: ; 0xbceaa
	checkbit1 $0040
	iftrue .bcec5
	checkbit1 $0041 ; if dude talked to you, then you left home without talking to mom
	iftrue MomPhoneLectureScript
	checkbit1 $001f
	iftrue MomPhoneNoGymQuestScript
	checkbit1 $001a
	iftrue MomPhoneNoPokedexScript
	2jump MomPhoneNoPokemonScript

.bcec5 ; 0xbcec5
	checkbit1 $0007
	iftrue MomPhoneHangUpScript
	3writetext BANK(MomPhoneGreetingText), MomPhoneGreetingText
	keeptextopen
	mapnametotext $0
	checkcode $f
	if_equal $1, UnknownScript_0xbcee7
	if_equal $2, $4f27
	2jump UnknownScript_0xbcf2f

UnknownScript_0xbcedf: ; 0xbcedf
	3writetext $6d, $4021
	keeptextopen
	2jump UnknownScript_0xbcf37

UnknownScript_0xbcee7: ; 0xbcee7
	checkcode $c
	if_equal GROUP_NEW_BARK_TOWN, .newbark
	if_equal GROUP_CHERRYGROVE_CITY, .cherrygrove
	if_equal GROUP_VIOLET_CITY, .violet
	if_equal GROUP_AZALEA_TOWN, .azalea
	if_equal GROUP_GOLDENROD_CITY, .goldenrod
	3writetext BANK(MomPhoneGenericAreaText), MomPhoneGenericAreaText
	keeptextopen
	2jump UnknownScript_0xbcf37

.newbark ; 0xbcf05
	3writetext BANK(MomPhoneNewBarkText), MomPhoneNewBarkText
	keeptextopen
	2jump UnknownScript_0xbcf37

.cherrygrove ; 0xbcf0d
	3writetext BANK(MomPhoneCherrygroveText), MomPhoneCherrygroveText
	keeptextopen
	2jump UnknownScript_0xbcf37

.violet ; 0xbcf15
	displaylocation $7 ; sprout tower
	3call $3, UnknownScript_0xbcedf
.azalea ; 0xbcf1b
	displaylocation $d ; slowpoke well
	3call $3, UnknownScript_0xbcedf
.goldenrod ; 0xbcf21
	displaylocation $11 ; radio tower
	3call $3, UnknownScript_0xbcedf
	3writetext $6d, $411c
	keeptextopen
	2jump UnknownScript_0xbcf37

UnknownScript_0xbcf2f: ; 0xbcf2f
	3writetext $6d, $4150
	keeptextopen
	2jump UnknownScript_0xbcf37

UnknownScript_0xbcf37: ; 0xbcf37
	checkbit2 $0008
	iffalse UnknownScript_0xbcf49
	checkmoney $1, 0
	if_equal $0, UnknownScript_0xbcf55
	2jump UnknownScript_0xbcf63

UnknownScript_0xbcf49: ; 0xbcf49
	checkmoney $1, 0
	if_equal $0, UnknownScript_0xbcf79
	2jump UnknownScript_0xbcf6e

UnknownScript_0xbcf55: ; 0xbcf55
	readmoney $1, $0
	3writetext $6d, $41a7
	yesorno
	iftrue MomPhoneSaveMoneyScript
	2jump MomPhoneWontSaveMoneyScript

UnknownScript_0xbcf63: ; 0xbcf63
	3writetext $6d, $41ea
	yesorno
	iftrue MomPhoneSaveMoneyScript
	2jump MomPhoneWontSaveMoneyScript

UnknownScript_0xbcf6e: ; 0xbcf6e
	3writetext $6d, $420d
	yesorno
	iftrue MomPhoneSaveMoneyScript
	2jump MomPhoneWontSaveMoneyScript

UnknownScript_0xbcf79: ; 0xbcf79
	readmoney $1, $0
	3writetext $6d, $4249
	yesorno
	iftrue MomPhoneSaveMoneyScript
	2jump MomPhoneWontSaveMoneyScript

MomPhoneSaveMoneyScript: ; 0xbcf87
	setbit2 $0008
	3writetext $6d, $4289
	keeptextopen
	2jump MomPhoneHangUpScript

MomPhoneWontSaveMoneyScript: ; 0xbcf92
	clearbit2 $0008
	3writetext BANK(MomPhoneWontSaveMoneyText), MomPhoneWontSaveMoneyText
	keeptextopen
	2jump MomPhoneHangUpScript

MomPhoneHangUpScript: ; 0xbcf9d
	3writetext BANK(MomPhoneHangUpText), MomPhoneHangUpText
	end

MomPhoneNoPokemonScript: ; 0xbcfa2
	3writetext BANK(MomPhoneNoPokemonText), MomPhoneNoPokemonText
	end

MomPhoneNoPokedexScript: ; 0xbcfa7
	3writetext BANK(MomPhoneNoPokedexText), MomPhoneNoPokedexText
	end

MomPhoneNoGymQuestScript: ; 0xbcfac
	3writetext BANK(MomPhoneNoGymQuestText), MomPhoneNoGymQuestText
	end

MomPhoneLectureScript: ; 0xbcfb1
	setbit1 $0040
	setbit2 $0009
	specialphonecall $0000
	3writetext BANK(MomPhoneLectureText), MomPhoneLectureText
	yesorno
	iftrue MomPhoneSaveMoneyScript
	2jump MomPhoneWontSaveMoneyScript

BillPhoneScript1: ; 0xbcfc5
	checktime $2
	iftrue .daygreet
	checktime $4
	iftrue .nitegreet
	3writetext BANK(BillPhoneMornGreetingText), BillPhoneMornGreetingText
	keeptextopen
	2jump .main

.daygreet ; 0xbcfd7
	3writetext BANK(BillPhoneDayGreetingText), BillPhoneDayGreetingText
	keeptextopen
	2jump .main

.nitegreet ; 0xbcfdf
	3writetext BANK(BillPhoneNiteGreetingText), BillPhoneNiteGreetingText
	keeptextopen
	2jump .main

.main ; 0xbcfe7
	3writetext BANK(BillPhoneGeneriText), BillPhoneGeneriText
	keeptextopen
	checkcode $10
	RAM2MEM $0
	if_equal $0, .full
	if_greater_than $6, .nearlyfull
	3writetext BANK(BillPhoneNotFullText), BillPhoneNotFullText
	end

.nearlyfull ; 0xbcffd
	3writetext BANK(BillPhoneNearlyFullText), BillPhoneNearlyFullText
	end

.full ; 0xbd002
	3writetext BANK(BillPhoneFullText), BillPhoneFullText
	end

BillPhoneScript2: ; 0xbd007
	3writetext BANK(BillPhoneNewlyFullText), BillPhoneNewlyFullText
	closetext
	end

ElmPhoneScript1: ; 0xbd00d
	checkcode $14
	if_equal $1, .pokerus
	checkbit1 $0055
	iftrue .discovery
	checkbit1 $002d
	iffalse .next
	checkbit1 $0054
	iftrue .egghatched
.next
	checkbit1 $002d
	iftrue .eggunhatched
	checkbit1 $0701
	iftrue .assistant
	checkbit1 $001f
	iftrue .checkingegg
	checkbit1 $0043
	iftrue .stolen
	checkbit1 $001e
	iftrue .sawmrpokemon
	3writetext BANK(ElmPhoneStartText), ElmPhoneStartText
	end

.sawmrpokemon ; 0xbd048
	3writetext BANK(ElmPhoneSawMrPokemonText), ElmPhoneSawMrPokemonText
	end

.stolen ; 0xbd04d
	3writetext BANK(ElmPhonePokemonStolenText), ElmPhonePokemonStolenText
	end

.checkingegg ; 0xbd052
	3writetext BANK(ElmPhoneCheckingEggText), ElmPhoneCheckingEggText
	end

.assistant ; 0xbd057
	3writetext BANK(ElmPhoneAssistantText), ElmPhoneAssistantText
	end

.eggunhatched ; 0xbd05c
	3writetext BANK(ElmPhoneEggUnhatchedText), ElmPhoneEggUnhatchedText
	end

.egghatched ; 0xbd061
	3writetext BANK(ElmPhoneEggHatchedText), ElmPhoneEggHatchedText
	setbit1 $0077
	end

.discovery ; 0xbd069
	random $2
	if_equal $0, .nextdiscovery
	3writetext BANK(ElmPhoneDiscovery1Text), ElmPhoneDiscovery1Text
	end

.nextdiscovery ; 0xbd074
	3writetext BANK(ElmPhoneDiscovery2Text), ElmPhoneDiscovery2Text
	end

.pokerus ; 0xbd079
	3writetext BANK(ElmPhonePokerusText), ElmPhonePokerusText
	specialphonecall $0000
	end

ElmPhoneScript2: ; 0xbd081
	checkcode $14
	if_equal $2, .disaster
	if_equal $3, .assistant
	if_equal $4, .rocket
	if_equal $5, .gift
	if_equal $8, .gift
	3writetext BANK(ElmPhonePokerusText), ElmPhonePokerusText
	specialphonecall $0000
	end

.disaster ; 0xbd09f
	3writetext BANK(ElmPhoneDisasterText), ElmPhoneDisasterText
	specialphonecall $0000
	setbit1 $0043
	end

.assistant ; 0xbd0aa
	3writetext BANK(ElmPhoneEggAssistantText), ElmPhoneEggAssistantText
	specialphonecall $0000
	clearbit1 $0700
	setbit1 $0701
	end

.rocket ; 0xbd0b8
	3writetext BANK(ElmPhoneRocketText), ElmPhoneRocketText
	specialphonecall $0000
	end

.gift ; 0xbd0c0
	3writetext BANK(ElmPhoneGiftText), ElmPhoneGiftText
	specialphonecall $0000
	end

.unused ; 0xbd0c8
	3writetext BANK(ElmPhoneUnusedText), ElmPhoneUnusedText
	specialphonecall $0000
	end

INCBIN "baserom.gbc", $bd0d0, $be699-$bd0d0


SECTION "bank30",ROMX,BANK[$30]

INCLUDE "gfx/overworld/sprites_1.asm"

SECTION "bank31",ROMX,BANK[$31]

INCLUDE "gfx/overworld/sprites_2.asm"

SECTION "bank32",ROMX,BANK[$32]

INCBIN "baserom.gbc", $c8000, $cbe2b - $c8000


SECTION "bank33",ROMX,BANK[$33]

Functioncc000: ; cc000
	call WhiteBGMap
	call ClearTileMap
	call ClearSprites
	call Functione58
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	ld hl, TileMap
	ld b, $4
	ld c, $d
	call TextBox
	ld hl, $c518
	ld b, $4
	ld c, $d
	call TextBox
	ld hl, $c4a2
	ld de, $40ae
	call PlaceString
	ld hl, $c51a
	ld de, $40b8
	call PlaceString
	ld hl, $c4f5
	ld de, $40a7
	call PlaceString
	ld hl, $c56d
	ld de, $40a7
	call PlaceString
	ld a, [$df9c]
	ld [$d265], a
	call GetPokemonName
	ld de, StringBuffer1
	ld hl, $c4c9
	call PlaceString
	ld h, b
	ld l, c
	ld a, [$dfbb]
	ld [TempMonLevel], a
	call PrintLevel
	ld de, EnemyMonNick
	ld hl, $c541
	call PlaceString
	ld h, b
	ld l, c
	ld a, [EnemyMonLevel]
	ld [TempMonLevel], a
	call PrintLevel
	ld hl, $c4fb
	ld de, $dfc0
	ld bc, $0203
	call PrintNum
	ld hl, $c573
	ld de, EnemyMonMaxHPHi
	call PrintNum
	ld hl, $40c2
	call PrintText
	pop af
	ld [Options], a
	call WaitBGMap
	ld b, $8
	call GetSGBLayout
	call Function32f9
	ret
; cc0a7

INCBIN "baserom.gbc", $cc0a7, $cc0c7 - $cc0a7


Functioncc0c7: ; cc0c7
	call GetPokemonName
	ld hl, $40d0
	jp PrintText
; cc0d0

INCBIN "baserom.gbc", $cc0d0, $cc0d6 - $cc0d0


Functioncc0d6: ; cc0d6
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	call Functioncc0e4
	pop af
	ld [rSVBK], a
	ret
; cc0e4

Functioncc0e4: ; cc0e4
	ld c, $6
.asm_cc0e6
	call Functioncc1fb
	dec c
	jr nz, .asm_cc0e6
	call Functioncc8a4
	call Functioncc1e2
	call Functioncc1fb
	ld c, $1
	ld a, [rKEY1]
	bit 7, a
	jr nz, .asm_cc0ff
	ld c, $3

.asm_cc0ff
	ld hl, $ff9e
	ld a, [hl]
	push af
	ld [hl], c
	call Functioncc11c
	pop af
	ld [$ff9e], a
	ld a, $1
	ld [hBGMapMode], a
	call Functioncc1fb
	call Functioncc1fb
	call Functioncc1fb
	call WaitSFX
	ret
; cc11c

Functioncc11c: ; cc11c
	ld a, [FXAnimIDHi]
	and a
	jr nz, .asm_cc156
	callba Function4ea44
	jr c, .asm_cc141
	call Functioncc1a1
	call Functioncc163
	call Functioncc8a4
	call Functioncc1e2
	xor a
	ld [hSCX], a
	ld [hSCY], a
	call Functioncc1fb
	call Functioncc1bb

.asm_cc141
	ld a, [$cfca]
	and a
	jr z, .asm_cc15f
	ld l, a
	ld h, $0
	ld de, $010e
	add hl, de
	ld a, l
	ld [FXAnimIDLo], a
	ld a, h
	ld [FXAnimIDHi], a

.asm_cc156
	call WaitSFX
	call Functioncc881
	call Functioncc163

.asm_cc15f
	call Functioncc8f6
	ret
; cc163

Functioncc163: ; cc163
	call Functioncc8d3
.asm_cc166
	call Functioncc25f
	call Functionccb48
	call Functioncc96e
	call Function3b0c
	call Functioncc1e2
	ld a, [FXAnimIDHi]
	or a
	jr nz, .asm_cc193
	ld a, [FXAnimIDLo]
	cp $cd
	jr nz, .asm_cc193
	ld a, $2e
	ld b, $5
	ld de, $0004
	ld hl, $d3fa
.asm_cc18c
	cp [hl]
	jr z, .asm_cc196
	add hl, de
	dec b
	jr nz, .asm_cc18c

.asm_cc193
	call Functioncc1fb

.asm_cc196
	ld a, [$d40f]
	bit 0, a
	jr z, .asm_cc166
	call Functioncc23d
	ret
; cc1a1

Functioncc1a1: ; cc1a1
	call Functioncc1fb
	call WaitTop
	call Functioncc207
	ld a, $1
	ld [hBGMapMode], a
	call Functioncc1fb
	call Functioncc1fb
	call Functioncc1fb
	call WaitTop
	ret
; cc1bb

Functioncc1bb: ; cc1bb
	call Functioncc1fb
	call WaitTop
	ld a, [rSVBK]
	push af
	ld a, $1
	ld [rSVBK], a
	ld hl, UpdateBattleHuds
	ld a, $f
	rst FarCall
	pop af
	ld [rSVBK], a
	ld a, $1
	ld [hBGMapMode], a
	call Functioncc1fb
	call Functioncc1fb
	call Functioncc1fb
	call WaitTop
	ret
; cc1e2

Functioncc1e2: ; cc1e2
	ld a, [hCGB]
	and a
	ret z
	ld a, [rBGP]
	ld b, a
	ld a, [$cfc7]
	cp b
	call nz, Functioncc91a
	ld a, [rOBP0]
	ld b, a
	ld a, [$cfc8]
	cp b
	call nz, Functioncc94b
	ret
; cc1fb

Functioncc1fb: ; cc1fb
	ld a, $1
	ld [VBlankOccurred], a
.asm_cc200
	ld a, [VBlankOccurred]
	and a
	jr nz, .asm_cc200
	ret
; cc207

Functioncc207: ; cc207
	ld a, [hBattleTurn]
	and a
	jr z, .asm_cc216
	ld hl, $c4a1
	ld bc, $040a
	call ClearBox
	ret

.asm_cc216
	ld hl, $c535
	ld bc, $050b
	call ClearBox
	ret
; cc220

INCBIN "baserom.gbc", $cc220, $cc23d - $cc220


Functioncc23d: ; cc23d
	ld a, [$d40f]
	bit 3, a
	jr z, .asm_cc254
	ld hl, $c403
	ld c, $28
.asm_cc249
	ld a, [hl]
	and $f0
	ld [hli], a
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .asm_cc249
	ret

.asm_cc254
	ld hl, Sprites
	ld c, $a0
	xor a
.asm_cc25a
	ld [hli], a
	dec c
	jr nz, .asm_cc25a
	ret
; cc25f

Functioncc25f: ; cc25f
	call Functioncc267
	ret nc
	call Functioncc275
	ret
; cc267

Functioncc267: ; cc267
	ld a, [$d412]
	and a
	jr z, .asm_cc273
	dec a
	ld [$d412], a
	and a
	ret

.asm_cc273
	scf
	ret
; cc275

Functioncc275: ; cc275
.asm_cc275
	call Function3af0
	cp $ff
	jr nz, .asm_cc286
	ld hl, $d40f
	bit 1, [hl]
	jr nz, .asm_cc28e
	set 0, [hl]
	ret

.asm_cc286
	cp $d0
	jr nc, .asm_cc28e
	ld [$d412], a
	ret

.asm_cc28e
	call Functioncc293
	jr .asm_cc275
; cc293

Functioncc293: ; cc293
	ld a, [$d417]
	sub $d0
	ld e, a
	ld d, $0
	ld hl, $42a4
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; cc2a4

INCBIN "baserom.gbc", $cc2a4, $cc881 - $cc2a4


Functioncc881: ; cc881
	ld a, [$cfca]
	cp $1
	jr z, .asm_cc88b
	cp $4
	ret nz

.asm_cc88b
	ld a, [TypeModifier]
	and $7f
	ret z
	cp $a
	ld de, $00ac
	jr z, .asm_cc8a0
	ld de, $00ad
	jr nc, .asm_cc8a0
	ld de, $00ab

.asm_cc8a0
	call StartSFX
	ret
; cc8a4

Functioncc8a4: ; cc8a4
	ld a, [hCGB]
	and a
	jr nz, .asm_cc8be
	ld a, [hSGB]
	and a
	ld a, $e0
	jr z, .asm_cc8b2
	ld a, $f0

.asm_cc8b2
	ld [$cfc8], a
	ld a, $e4
	ld [$cfc7], a
	ld [$cfc9], a
	ret

.asm_cc8be
	ld a, $e4
	ld [$cfc7], a
	ld [$cfc8], a
	ld [$cfc9], a
	call DmgToCgbBGPals
	ld de, $e4e4
	call DmgToCgbObjPals
	ret
; cc8d3

Functioncc8d3: ; cc8d3
	ld hl, $d100
	ld bc, $0354
.asm_cc8d9
	ld [hl], $0
	inc hl
	dec bc
	ld a, c
	or b
	jr nz, .asm_cc8d9
	ld hl, FXAnimIDLo
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $506f
	add hl, de
	add hl, de
	call Function3ae1
	call Functioncc8a4
	call Functioncc1fb
	ret
; cc8f6

Functioncc8f6: ; cc8f6
	call WaitTop
	ld a, $e4
	ld [$cfc7], a
	ld [$cfc8], a
	ld [$cfc9], a
	call DmgToCgbBGPals
	ld de, $e4e4
	call DmgToCgbObjPals
	xor a
	ld [hSCX], a
	ld [hSCY], a
	call Functioncc1fb
	ld a, $1
	ld [hBGMapMode], a
	ret
; cc91a

Functioncc91a: ; cc91a
	ld [rBGP], a
	ld a, [hCGB]
	and a
	ret z
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, $d080
	ld de, $d000
	ld a, [rBGP]
	ld b, a
	ld c, $7
	call CopyPals
	ld hl, $d0c0
	ld de, MartPointer
	ld a, [rBGP]
	ld b, a
	ld c, $2
	call CopyPals
	pop af
	ld [rSVBK], a
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; cc94b

Functioncc94b: ; cc94b
	ld [rOBP0], a
	ld a, [hCGB]
	and a
	ret z
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, $d0d0
	ld de, $d050
	ld a, [rOBP0]
	ld b, a
	ld c, $2
	call CopyPals
	pop af
	ld [rSVBK], a
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; cc96e

Functioncc96e: ; cc96e
	ld a, $0
	ld [$d418], a
	ld hl, $d30a
	ld e, $a
.asm_cc978
	ld a, [hl]
	and a
	jr z, .asm_cc98a
	ld c, l
	ld b, h
	push hl
	push de
	call Functionccfbe
	call Functioncca09
	pop de
	pop hl
	jr c, .asm_cc9a0

.asm_cc98a
	ld bc, $0018
	add hl, bc
	dec e
	jr nz, .asm_cc978
	ld a, [$d418]
	ld l, a
	ld h, $c4
.asm_cc997
	ld a, l
	cp $a0
	jr nc, .asm_cc9a0
	xor a
	ld [hli], a
	jr .asm_cc997

.asm_cc9a0
	ret
; cc9a1

INCBIN "baserom.gbc", $cc9a1, $cc9bd - $cc9a1


Functioncc9bd: ; cc9bd
	ld hl, $0000
	add hl, bc
	ld [hl], $0
	ret
; cc9c4

INCBIN "baserom.gbc", $cc9c4, $cca09 - $cc9c4


Functioncca09: ; cca09
	call Functionccaaa
	call Functionce7d1
	cp EGG
	jp z, $4aa5
	cp NUM_POKEMON + 1
	jp z, $4aa2
	push af
	ld hl, $d419
	ld a, [$d420]
	xor [hl]
	and $e0
	ld [hl], a
	pop af
	push bc
	call Functionce83c
	ld a, [$d41b]
	add [hl]
	ld [$d41b], a
	inc hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [$d418]
	ld e, a
	ld d, $c4
.asm_cca3c
	ld a, [$d41d]
	ld b, a
	ld a, [$d41f]
	add b
	ld b, a
	push hl
	ld a, [hl]
	ld hl, $d419
	bit 6, [hl]
	jr z, .asm_cca53
	add $8
	xor $ff
	inc a

.asm_cca53
	pop hl
	add b
	ld [de], a
	inc hl
	inc de
	ld a, [$d41c]
	ld b, a
	ld a, [$d41e]
	add b
	ld b, a
	push hl
	ld a, [hl]
	ld hl, $d419
	bit 5, [hl]
	jr z, .asm_cca6f
	add $8
	xor $ff
	inc a

.asm_cca6f
	pop hl
	add b
	ld [de], a
	inc hl
	inc de
	ld a, [$d41b]
	add $31
	add [hl]
	ld [de], a
	inc hl
	inc de
	ld a, [$d419]
	ld b, a
	ld a, [hl]
	xor b
	and $e0
	ld b, a
	ld a, [hl]
	and $10
	or b
	ld b, a
	ld a, [OTPartyMon6Nickname]
	and $f
	or b
	ld [de], a
	inc hl
	inc de
	ld a, e
	ld [$d418], a
	cp $a0
	jr nc, .asm_ccaa7
	dec c
	jr nz, .asm_cca3c
	pop bc
	jr .asm_ccaa5

	call Functioncc9bd

.asm_ccaa5
	and a
	ret

.asm_ccaa7
	pop bc
	scf
	ret
; ccaaa

Functionccaaa: ; ccaaa
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	and $80
	ld [$d419], a
	xor a
	ld [$d420], a
	ld hl, $0005
	add hl, bc
	ld a, [hl]
	ld [OTPartyMon6Nickname], a
	ld hl, $0002
	add hl, bc
	ld a, [hl]
	ld [$d41a], a
	ld hl, $0006
	add hl, bc
	ld a, [hli]
	ld [$d41b], a
	ld a, [hli]
	ld [$d41c], a
	ld a, [hli]
	ld [$d41d], a
	ld a, [hli]
	ld [$d41e], a
	ld a, [hli]
	ld [$d41f], a
	ld a, [hBattleTurn]
	and a
	ret z
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	ld [$d419], a
	bit 0, [hl]
	ret z
	ld hl, $0007
	add hl, bc
	ld a, [hli]
	ld d, a
	ld a, $b4
	sub d
	ld [$d41c], a
	ld a, [hli]
	ld d, a
	ld a, [$d41a]
	cp $ff
	jr nz, .asm_ccb09
	ld a, $28
	add d
	jr .asm_ccb26

.asm_ccb09
	sub d
	push af
	ld a, [FXAnimIDHi]
	or a
	jr nz, .asm_ccb25
	ld a, [FXAnimIDLo]
	cp $86
	jr z, .asm_ccb20
	cp $87
	jr z, .asm_ccb20
	cp $d0
	jr nz, .asm_ccb25

.asm_ccb20
	pop af
	sub $8
	jr .asm_ccb26

.asm_ccb25
	pop af

.asm_ccb26
	ld [$d41d], a
	ld a, [hli]
	xor $ff
	inc a
	ld [$d41e], a
	ret
; ccb31

INCBIN "baserom.gbc", $ccb31, $ccb48 - $ccb31


Functionccb48: ; ccb48
	ld hl, Functioncc000
	ld a, $32
	rst FarCall
	ret
; ccb4f

INCBIN "baserom.gbc", $ccb4f, $ccfbe - $ccb4f


Functionccfbe: ; ccfbe
	ld hl, $0004
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld hl, $4fce
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; ccfce

INCBIN "baserom.gbc", $ccfce, $ce7d1 - $ccfce


Functionce7d1: ; ce7d1
.asm_ce7d1
	ld hl, $000c
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_ce7e1
	dec [hl]
	call Functionce823
	ld a, [hli]
	push af
	jr .asm_ce7fd

.asm_ce7e1
	ld hl, $000d
	add hl, bc
	inc [hl]
	call Functionce823
	ld a, [hli]
	cp $fe
	jr z, .asm_ce815
	cp $ff
	jr z, .asm_ce807
	push af
	ld a, [hl]
	push hl
	and $3f
	ld hl, $000c
	add hl, bc
	ld [hl], a
	pop hl

.asm_ce7fd
	ld a, [hl]
	and $c0
	srl a
	ld [$d420], a
	pop af
	ret

.asm_ce807
	xor a
	ld hl, $000c
	add hl, bc
	ld [hl], a
	ld hl, $000d
	add hl, bc
	dec [hl]
	dec [hl]
	jr .asm_ce7d1

.asm_ce815
	xor a
	ld hl, $000c
	add hl, bc
	ld [hl], a
	dec a
	ld hl, $000d
	add hl, bc
	ld [hl], a
	jr .asm_ce7d1
; ce823

Functionce823: ; ce823
	ld hl, $0003
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld hl, $685e
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $000d
	add hl, bc
	ld l, [hl]
	ld h, $0
	add hl, hl
	add hl, de
	ret
; ce83c

Functionce83c: ; ce83c
	ld l, a
	ld h, $0
	ld de, $6eae
	add hl, hl
	add hl, hl
	add hl, de
	ret
; ce846

INCBIN "baserom.gbc", $ce846, $cfd9e - $ce846

;                          Songs iii

Music_PostCredits: INCLUDE "audio/music/postcredits.asm"



;                       Pic animations I

SECTION "bank34",ROMX,BANK[$34]

; Pic animations asm
INCBIN "baserom.gbc", $d0000, $d0695 - $d0000

; Pic animations are assembled in 3 parts:

; Top-level animations:
; 	frame #, duration: Frame 0 is the original pic (no change)
;	setrepeat #:       Sets the number of times to repeat
; 	dorepeat #:        Repeats from command # (starting from 0)
; 	end

; Bitmasks:
;	Layered over the pic to designate affected tiles

; Frame definitions:
;	first byte is the bitmask used for this frame
;	following bytes are tile ids mapped to each bit in the mask

; Main animations (played everywhere)
AnimationPointers: INCLUDE "gfx/pics/anim_pointers.asm"
INCLUDE "gfx/pics/anims.asm"

; Extra animations, appended to the main animation
; Used in the status screen (blinking, tail wags etc.)
AnimationExtraPointers: INCLUDE "gfx/pics/extra_pointers.asm"
INCLUDE "gfx/pics/extras.asm"

; Unown has its own animation data despite having an entry in the main tables
UnownAnimationPointers: INCLUDE "gfx/pics/unown_anim_pointers.asm"
INCLUDE "gfx/pics/unown_anims.asm"
UnownAnimationExtraPointers: INCLUDE "gfx/pics/unown_extra_pointers.asm"
INCLUDE "gfx/pics/unown_extras.asm"

; Bitmasks
BitmasksPointers: INCLUDE "gfx/pics/bitmask_pointers.asm"
INCLUDE "gfx/pics/bitmasks.asm"
UnownBitmasksPointers: INCLUDE "gfx/pics/unown_bitmask_pointers.asm"
INCLUDE "gfx/pics/unown_bitmasks.asm"


;                       Pic animations II

SECTION "bank35",ROMX,BANK[$35]

; Frame definitions
FramesPointers: INCLUDE "gfx/pics/frame_pointers.asm"
; Inexplicably, Kanto frames are split off from Johto
INCLUDE "gfx/pics/kanto_frames.asm"


;                       Pic animations III

SECTION "bank36",ROMX,BANK[$36]

FontInversed: INCBIN "gfx/misc/font_inversed.1bpp"

; Johto frame definitions
INCLUDE "gfx/pics/johto_frames.asm"

; Unown frame definitions
UnownFramesPointers: INCLUDE "gfx/pics/unown_frame_pointers.asm"
INCLUDE "gfx/pics/unown_frames.asm"


SECTION "bank37",ROMX,BANK[$37]

INCLUDE "tilesets/data_6.asm"


SECTION "bank38",ROMX,BANK[$38]

INCBIN "baserom.gbc", $e0000, $e37f9 - $e0000


SECTION "bank39",ROMX,BANK[$39]

CopyrightGFX: ; e4000
INCBIN "gfx/misc/copyright.2bpp"
; e41d0

_OptionsMenu: ; e41d0
	ld hl, $ffaa
	ld a, [hl]
	push af
	ld [hl], $1
	call WhiteBGMap
	ld hl, TileMap
	ld b, $10
	ld c, $12
	call TextBox
	ld hl, $c4ca
	ld de, Stringe4241
	call PlaceString
	xor a
	ld [$cf63], a
	ld c, $6
.asm_e41f3
	push bc
	xor a
	ld [$ffa9], a
	call Functione42d6
	pop bc
	ld hl, $cf63
	inc [hl]
	dec c
	jr nz, .asm_e41f3
	call Functione4512
	xor a
	ld [$cf63], a
	inc a
	ld [hBGMapMode], a
	call WaitBGMap
	ld b, $8
	call GetSGBLayout
	call Function32f9
.asm_e4217
	call Functiona57
	ld a, [hJoyPressed]
	and $a
	jr nz, .asm_e4234
	call Functione452a
	jr c, .asm_e422a
	call Functione42d6
	jr c, .asm_e4234

.asm_e422a
	call Functione455c
	ld c, $3
	call DelayFrames
	jr .asm_e4217

.asm_e4234
	ld de, SFX_TRANSACTION
	call StartSFX
	call WaitSFX
	pop af
	ld [$ffaa], a
	ret
; e4241

Stringe4241: ; e4241
	db "TEXT SPEED", $22
	db "        :", $22
	db "BATTLE SCENE", $22
	db "        :", $22
	db "BATTLE STYLE", $22
	db "        :", $22
	db "SOUND", $22
	db "        :", $22
	db "PRINT", $22
	db "        :", $22
	db "MENU ACCOUNT", $22
	db "        :", $22
	db "FRAME", $22
	db "        :TYPE", $22
	db "CANCEL@"
; e42d6


Functione42d6: ; e42d6
	ld a, [$cf63]
	ld e, a
	ld d, 0
	ld hl, .Pointers
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; e42e5

.Pointers
	dw Options_TextSpeed
	dw Options_BattleScene
	dw Options_BattleStyle
	dw Options_Sound
	dw Options_Print
	dw Options_MenuAccount
	dw Options_Frame
	dw Options_Cancel
; e42f5


Options_TextSpeed: ; e42f5
	call Functione4346
	ld a, [hJoyPressed]
	bit 5, a
	jr nz, .asm_e430d
	bit 4, a
	jr z, .asm_e431f
	ld a, c
	cp $2
	jr c, .asm_e4309
	ld c, $ff

.asm_e4309
	inc c
	ld a, e
	jr .asm_e4315

.asm_e430d
	ld a, c
	and a
	jr nz, .asm_e4313
	ld c, $3

.asm_e4313
	dec c
	ld a, d

.asm_e4315
	ld b, a
	ld a, [Options]
	and $f0
	or b
	ld [Options], a

.asm_e431f
	ld b, 0
	ld hl, .Strings
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 11, 3
	call PlaceString
	and a
	ret
; e4331

.Strings
	dw .Fast
	dw .Mid
	dw .Slow

.Fast
	db "FAST@"
.Mid
	db "MID @"
.Slow
	db "SLOW@"
; e4346


Functione4346: ; e4346
	ld a, [Options]
	and $7
	cp $5
	jr z, .asm_e4359
	cp $1
	jr z, .asm_e435f
	ld c, $1
	ld de, $0105
	ret

.asm_e4359
	ld c, $2
	ld de, $0301
	ret

.asm_e435f
	ld c, $0
	ld de, $0503
	ret
; e4365


Options_BattleScene: ; e4365
	ld hl, Options
	ld a, [hJoyPressed]
	bit 5, a
	jr nz, .asm_e4378
	bit 4, a
	jr z, .asm_e437e
	bit 7, [hl]
	jr nz, .asm_e4384
	jr .asm_e438b

.asm_e4378
	bit 7, [hl]
	jr z, .asm_e438b
	jr .asm_e4384

.asm_e437e
	bit 7, [hl]
	jr z, .asm_e4384
	jr .asm_e438b

.asm_e4384
	res 7, [hl]
	ld de, .On
	jr .asm_e4390

.asm_e438b
	set 7, [hl]
	ld de, .Off

.asm_e4390
	hlcoord 11, 5
	call PlaceString
	and a
	ret
; e4398

.On
	db "ON @"
.Off
	db "OFF@"
; e43a0


Options_BattleStyle: ; e43a0
	ld hl, Options
	ld a, [hJoyPressed]
	bit 5, a
	jr nz, .asm_e43b3
	bit 4, a
	jr z, .asm_e43b9
	bit 6, [hl]
	jr nz, .asm_e43bd
	jr .asm_e43c4

.asm_e43b3
	bit 6, [hl]
	jr z, .asm_e43c4
	jr .asm_e43bd

.asm_e43b9
	bit 6, [hl]
	jr nz, .asm_e43c4

.asm_e43bd
	res 6, [hl]
	ld de, .Shift
	jr .asm_e43c9

.asm_e43c4
	set 6, [hl]
	ld de, .Set

.asm_e43c9
	hlcoord 11, 7
	call PlaceString
	and a
	ret
; e43d1

.Shift
	db "SHIFT@"
.Set
	db "SET  @"
; e43dd


Options_Sound: ; e43dd
	ld hl, Options
	ld a, [hJoyPressed]
	bit 5, a
	jr nz, .asm_e43f0
	bit 4, a
	jr z, .asm_e43f6
	bit 5, [hl]
	jr nz, .asm_e43fc
	jr .asm_e4406

.asm_e43f0
	bit 5, [hl]
	jr z, .asm_e4406
	jr .asm_e43fc

.asm_e43f6
	bit 5, [hl]
	jr nz, .asm_e440b
	jr .asm_e4401

.asm_e43fc
	res 5, [hl]
	call Function3d47

.asm_e4401
	ld de, .Mono
	jr .asm_e440e

.asm_e4406
	set 5, [hl]
	call Function3d47

.asm_e440b
	ld de, .Stereo

.asm_e440e
	hlcoord 11, 9
	call PlaceString
	and a
	ret
; e4416

.Mono
	db "MONO  @"
.Stereo
	db "STEREO@"
; e4424


Options_Print: ; e4424
	call Functione4491
	ld a, [hJoyPressed]
	bit 5, a
	jr nz, .asm_e443c
	bit 4, a
	jr z, .asm_e4448
	ld a, c
	cp $4
	jr c, .asm_e4438
	ld c, $ff

.asm_e4438
	inc c
	ld a, e
	jr .asm_e4444

.asm_e443c
	ld a, c
	and a
	jr nz, .asm_e4442
	ld c, $5

.asm_e4442
	dec c
	ld a, d

.asm_e4444
	ld b, a
	ld [GBPrinter], a

.asm_e4448
	ld b, $0
	ld hl, $445a
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 11, 11
	call PlaceString
	and a
	ret
; e445a

.Strings
	dw .Lightest
	dw .Lighter
	dw .Normal
	dw .Darker
	dw .Darkest

.Lightest
	db "LIGHTEST@"
.Lighter
	db "LIGHTER @"
.Normal
	db "NORMAL  @"
.Darker
	db "DARKER  @"
.Darkest
	db "DARKEST @"
; e4491


Functione4491: ; e4491
	ld a, [GBPrinter]
	and a
	jr z, .asm_e44a9
	cp $20
	jr z, .asm_e44af
	cp $60
	jr z, .asm_e44b5
	cp $7f
	jr z, .asm_e44bb
	ld c, $2
	ld de, $2060
	ret

.asm_e44a9
	ld c, $0
	ld de, $7f20
	ret

.asm_e44af
	ld c, $1
	ld de, $0040
	ret

.asm_e44b5
	ld c, $3
	ld de, $407f
	ret

.asm_e44bb
	ld c, $4
	ld de, $6000
	ret
; e44c1

Options_MenuAccount: ; e44c1
	ld hl, Options2
	ld a, [hJoyPressed]
	bit 5, a
	jr nz, .asm_e44d4
	bit 4, a
	jr z, .asm_e44da
	bit 0, [hl]
	jr nz, .asm_e44de
	jr .asm_e44e5

.asm_e44d4
	bit 0, [hl]
	jr z, .asm_e44e5
	jr .asm_e44de

.asm_e44da
	bit 0, [hl]
	jr nz, .asm_e44e5

.asm_e44de
	res 0, [hl]
	ld de, .Off
	jr .asm_e44ea

.asm_e44e5
	set 0, [hl]
	ld de, .On

.asm_e44ea
	hlcoord 11, 13
	call PlaceString
	and a
	ret
; e44f2

.Off
	db "OFF@"
.On
	db "ON @"
; e44fa


Options_Frame: ; e44fa
	ld hl, TextBoxFrame
	ld a, [hJoyPressed]
	bit 5, a
	jr nz, .asm_e450d
	bit 4, a
	jr nz, .asm_e4509
	and a
	ret

.asm_e4509
	ld a, [hl]
	inc a
	jr .asm_e450f

.asm_e450d
	ld a, [hl]
	dec a

.asm_e450f
	and $7
	ld [hl], a
	; fallthrough
; e4512

Functione4512: ; e4512
	ld a, [TextBoxFrame]
	ld hl, $c5dc
	add "1"
	ld [hl], a
	call Functione5f
	and a
	ret
; e4520

Options_Cancel: ; e4520
	ld a, [hJoyPressed]
	and BUTTON_A
	jr nz, .asm_e4528
	and a
	ret

.asm_e4528
	scf
	ret
; e452a

Functione452a: ; e452a
	ld hl, $cf63
	ld a, [$ffa9]
	cp $80
	jr z, .asm_e4539
	cp $40
	jr z, .asm_e454b
	and a
	ret

.asm_e4539
	ld a, [hl]
	cp $7
	jr nz, .asm_e4542
	ld [hl], $0
	scf
	ret

.asm_e4542
	cp $5
	jr nz, .asm_e4548
	ld [hl], $5

.asm_e4548
	inc [hl]
	scf
	ret

.asm_e454b
	ld a, [hl]
	cp $6
	jr nz, .asm_e4554
	ld [hl], $5
	scf
	ret

.asm_e4554
	and a
	jr nz, .asm_e4559
	ld [hl], $8

.asm_e4559
	dec [hl]
	scf
	ret
; e455c

Functione455c: ; e455c
	hlcoord 1, 1
	ld de, $0014
	ld c, $10
.asm_e4564
	ld [hl], $7f
	add hl, de
	dec c
	jr nz, .asm_e4564
	hlcoord 1, 2
	ld bc, $0028
	ld a, [$cf63]
	call AddNTimes
	ld [hl], $ed
	ret
; e4579


Functione4579: ; e4579
	ld de, MUSIC_NONE
	call StartMusic
	call WhiteBGMap
	call ClearTileMap
	ld a, $98
	ld [$ffd7], a
	xor a
	ld [hBGMapAddress], a
	ld [hJoyDown], a
	ld [hSCX], a
	ld [hSCY], a
	ld a, $90
	ld [hWY], a
	call WaitBGMap
	ld b, $19
	call GetSGBLayout
	call Function32f9
	ld c, 10
	call DelayFrames
	callab Copyright
	call WaitBGMap
	ld c, $64
	call DelayFrames
	call ClearTileMap
	ld a, $13
	ld hl, $6a82
	rst FarCall
	call Functione45e8
.asm_e45c0
	call Functiona57
	ld a, [$ffa9]
	and $f
	jr nz, .asm_e45de
	ld a, [$cf63]
	bit 7, a
	jr nz, .asm_e45e3
	call Functione4670
	ld a, $23
	ld hl, $4f69
	rst FarCall
	call DelayFrame
	jr .asm_e45c0

.asm_e45de
	call Functione465e
	scf
	ret

.asm_e45e3
	call Functione465e
	and a
	ret
; e45e8

Functione45e8: ; e45e8
	ld de, $47cc
	ld hl, VTiles2
	ld bc, $391c
	call Get1bpp
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	ld hl, $5407
	ld de, $d000
	ld a, $42
	call FarDecompress
	ld hl, VTiles0
	ld de, $d000
	ld bc, $0180
	call Request2bpp
	ld hl, VTiles1
	ld de, $d800
	ld bc, $0180
	call Request2bpp
	pop af
	ld [rSVBK], a
	ld a, $23
	ld hl, $4f53
	rst FarCall
	ld de, $5458
	ld a, $3
	call Function3b2a
	ld hl, $0007
	add hl, bc
	ld [hl], $a0
	ld hl, $000c
	add hl, bc
	ld [hl], $60
	ld hl, $000d
	add hl, bc
	ld [hl], $30
	xor a
	ld [$cf63], a
	ld [$cf64], a
	ld [$cf65], a
	ld [hSCX], a
	ld [hSCY], a
	ld a, $1
	ld [hBGMapMode], a
	ld a, $90
	ld [hWY], a
	ld de, $e4e4
	call DmgToCgbObjPals
	ret
; e465e

Functione465e: ; e465e
	ld a, $23
	ld hl, $4f53
	rst FarCall
	call ClearTileMap
	call ClearSprites
	ld c, $10
	call DelayFrames
	ret
; e4670

Functione4670: ; e4670
	ld a, [$cf63]
	ld e, a
	ld d, 0
	ld hl, .pointers
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; e467f

.pointers
	dw Functione468c
	dw Functione468d
	dw Functione46ba
	dw Functione46dd
; e4687

Functione4687: ; e4687
	ld hl, $cf63
	inc [hl]
	ret
; e468c

Functione468c: ; e468c
	ret
; e468d

Functione468d: ; e468d
	ld hl, $cf65
	ld a, [hl]
	cp $20
	jr nc, .asm_e4697
	inc [hl]
	ret

.asm_e4697
	ld [hl], 0
	ld hl, .GAME_FREAK
	decoord 5, 10
	ld bc, .end - .GAME_FREAK
	call CopyBytes
	call Functione4687
	ld de, SFX_GAME_FREAK_PRESENTS
	call StartSFX
	ret
; e46af

.GAME_FREAK
	;  G  A  M  E   _  F  R  E  A  K
	db 0, 1, 2, 3, 13, 4, 5, 3, 1, 6
.end
	db "@"
; e46ba

Functione46ba: ; e46ba
	ld hl, $cf65
	ld a, [hl]
	cp $40
	jr nc, .asm_e46c4
	inc [hl]
	ret

.asm_e46c4
	ld [hl], 0
	ld hl, .presents
	decoord 7,11
	ld bc, .end - .presents
	call CopyBytes
	call Functione4687
	ret
; e46d6

.presents
	db 7, 8, 9, 10, 11, 12
.end
	db "@"
; e46dd

Functione46dd: ; e46dd
	ld hl, $cf65
	ld a, [hl]
	cp $80
	jr nc, .asm_e46e7
	inc [hl]
	ret

.asm_e46e7
	ld hl, $cf63
	set 7, [hl]
	ret
; e46ed


INCBIN "baserom.gbc", $e46ed, $e48ac - $e46ed


Functione48ac: ; e48ac
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld a, [$ffaa]
	push af
	ld a, [$ff9e]
	push af
	call Functione4901

Functione48bc: ; e48bc
	call Functiona57
	ld a, [$ffa9]
	and $f
	jr nz, .asm_e48db
	ld a, [$cf63]
	bit 7, a
	jr nz, .asm_e48e1
	call Functione490f
	callba Function8cf69
	call DelayFrame
	jp Functione48bc

.asm_e48db
	ld de, $0000
	call StartMusic

.asm_e48e1
	call WhiteBGMap
	call ClearSprites
	call ClearTileMap
	xor a
	ld [hSCX], a
	ld [hSCY], a
	ld a, $7
	ld [hWX], a
	ld a, $90
	ld [hWY], a
	pop af
	ld [$ff9e], a
	pop af
	ld [$ffaa], a
	pop af
	ld [rSVBK], a
	ret
; e4901

Functione4901: ; e4901
	xor a
	ld [$ff9e], a
	ld a, $1
	ld [$ffaa], a
	xor a
	ld [$ffde], a
	ld [$cf63], a
	ret
; e490f

Functione490f: ; e490f
	ld a, [$cf63]
	ld e, a
	ld d, $0
	ld hl, $491e
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; e491e

INCBIN "baserom.gbc", $e491e, $e555d - $e491e

IntroSuicuneRunGFX: ; e555d
INCBIN "gfx/intro/suicune_run.lz"
; e592b

INCBIN "baserom.gbc", $e592b, $e592d - $e592b

IntroPichuWooperGFX: ; e592d
INCBIN "gfx/intro/pichu_wooper.lz"
; e5c70

INCBIN "baserom.gbc", $e5c70, $e5c7d - $e5c70

IntroBackgroundGFX: ; e5c7d
INCBIN "gfx/intro/background.lz"
; e5e69

INCBIN "baserom.gbc", $e5e69, $e5e6d - $e5e69

IntroTilemap004: ; e5e6d
INCBIN "gfx/intro/004.lz"
; e5ec5

INCBIN "baserom.gbc", $e5ec5, $e5ecd - $e5ec5

IntroTilemap003: ; e5ecd
INCBIN "gfx/intro/003.lz"
; e5ed9

INCBIN "baserom.gbc", $e5ed9, $e5f5d - $e5ed9

IntroUnownsGFX: ; e5f5d
INCBIN "gfx/intro/unowns.lz"
; e6348

INCBIN "baserom.gbc", $e6348, $e634d - $e6348

IntroPulseGFX: ; e634d
INCBIN "gfx/intro/pulse.lz"
; e63d4

INCBIN "baserom.gbc", $e63d4, $e63dd - $e63d4

IntroTilemap002: ; e63dd
INCBIN "gfx/intro/002.lz"
; e6418

INCBIN "baserom.gbc", $e6418, $e641d - $e6418

IntroTilemap001: ; e641d
INCBIN "gfx/intro/001.lz"
; e6429

INCBIN "baserom.gbc", $e6429, $e642d - $e6429

IntroTilemap006: ; e642d
INCBIN "gfx/intro/006.lz"
; e6472

INCBIN "baserom.gbc", $e6472, $e647d - $e6472

IntroTilemap005: ; e647d
INCBIN "gfx/intro/005.lz"
; e6498

INCBIN "baserom.gbc", $e6498, $e649d - $e6498

IntroTilemap008: ; e649d
INCBIN "gfx/intro/008.lz"
; e6550

INCBIN "baserom.gbc", $e6550, $e655d - $e6550

IntroTilemap007: ; e655d
INCBIN "gfx/intro/007.lz"
; e65a4

INCBIN "baserom.gbc", $e65a4, $e662d - $e65a4

IntroCrystalUnownsGFX: ; e662d
INCBIN "gfx/intro/crystal_unowns.lz"
; e6720

INCBIN "baserom.gbc", $e6720, $e672d - $e6720

IntroTilemap017: ; e672d
INCBIN "gfx/intro/017.lz"
; e6761

INCBIN "baserom.gbc", $e6761, $e676d - $e6761

IntroTilemap015: ; e676d
INCBIN "gfx/intro/015.lz"
; e6794

INCBIN "baserom.gbc", $e6794, $e681d - $e6794

IntroSuicuneCloseGFX: ; e681d
INCBIN "gfx/intro/suicune_close.lz"
; e6c37

INCBIN "baserom.gbc", $e6c37, $e6c3d - $e6c37

IntroTilemap012: ; e6c3d
INCBIN "gfx/intro/012.lz"
; e6d0a

INCBIN "baserom.gbc", $e6d0a, $e6d0d - $e6d0a

IntroTilemap011: ; e6d0d
INCBIN "gfx/intro/011.lz"
; e6d65

INCBIN "baserom.gbc", $e6d65, $e6ded - $e6d65

IntroSuicuneJumpGFX: ; e6ded
INCBIN "gfx/intro/suicune_jump.lz"
; e72a7

INCBIN "baserom.gbc", $e72a7, $e72ad - $e72a7

IntroSuicuneBackGFX: ; e72ad
INCBIN "gfx/intro/suicune_back.lz"
; e7648

INCBIN "baserom.gbc", $e7648, $e764d - $e7648

IntroTilemap010: ; e764d
INCBIN "gfx/intro/010.lz"
; e76a0

INCBIN "baserom.gbc", $e76a0, $e76ad - $e76a0

IntroTilemap009: ; e76ad
INCBIN "gfx/intro/009.lz"
; e76bb

INCBIN "baserom.gbc", $e76bb, $e76bd - $e76bb

IntroTilemap014: ; e76bd
INCBIN "gfx/intro/014.lz"
; e778b

INCBIN "baserom.gbc", $e778b, $e778d - $e778b

IntroTilemap013: ; e778d
INCBIN "gfx/intro/013.lz"
; e77d9

INCBIN "baserom.gbc", $e77d9, $e785d - $e77d9

IntroUnownBackGFX: ; e785d
INCBIN "gfx/intro/unown_back.lz"
; e799a

INCBIN "baserom.gbc", $e799a, $e7a70 - $e799a


; ================================================================
;           Sound engine and music/sound effect pointers
SECTION "bank3A",ROMX,BANK[$3A]


; The sound engine. Interfaces are in bank 0
INCLUDE "audio/engine.asm"

; What music plays when a trainer notices you
INCLUDE "audio/trainer_encounters.asm"

; Pointer table for all 103 songs
Music: INCLUDE "audio/music_pointers.asm"

; Empty song
Music_Nothing: INCLUDE "audio/music/nothing.asm"

; Pointer table for all 68 base cries
Cries: INCLUDE "audio/cry_pointers.asm"

; Pointer table for all 207 sfx
SFX: INCLUDE "audio/sfx_pointers.asm"


;                            Songs I

Music_Route36:              INCLUDE "audio/music/route36.asm"
Music_RivalBattle:          INCLUDE "audio/music/rivalbattle.asm"
Music_RocketBattle:         INCLUDE "audio/music/rocketbattle.asm"
Music_ElmsLab:              INCLUDE "audio/music/elmslab.asm"
Music_DarkCave:             INCLUDE "audio/music/darkcave.asm"
Music_JohtoGymBattle:       INCLUDE "audio/music/johtogymbattle.asm"
Music_ChampionBattle:       INCLUDE "audio/music/championbattle.asm"
Music_SSAqua:               INCLUDE "audio/music/ssaqua.asm"
Music_NewBarkTown:          INCLUDE "audio/music/newbarktown.asm"
Music_GoldenrodCity:        INCLUDE "audio/music/goldenrodcity.asm"
Music_VermilionCity:        INCLUDE "audio/music/vermilioncity.asm"
Music_TitleScreen:          INCLUDE "audio/music/titlescreen.asm"
Music_RuinsOfAlphInterior:  INCLUDE "audio/music/ruinsofalphinterior.asm"
Music_LookPokemaniac:       INCLUDE "audio/music/lookpokemaniac.asm"
Music_TrainerVictory:       INCLUDE "audio/music/trainervictory.asm"


SECTION "bank3B",ROMX,BANK[$3B]

;                           Songs II

Music_Route1:               INCLUDE "audio/music/route1.asm"
Music_Route3:               INCLUDE "audio/music/route3.asm"
Music_Route12:              INCLUDE "audio/music/route12.asm"
Music_KantoGymBattle:       INCLUDE "audio/music/kantogymbattle.asm"
Music_KantoTrainerBattle:   INCLUDE "audio/music/kantotrainerbattle.asm"
Music_KantoWildBattle:      INCLUDE "audio/music/kantowildbattle.asm"
Music_PokemonCenter:        INCLUDE "audio/music/pokemoncenter.asm"
Music_LookLass:             INCLUDE "audio/music/looklass.asm"
Music_LookOfficer:          INCLUDE "audio/music/lookofficer.asm"
Music_Route2:               INCLUDE "audio/music/route2.asm"
Music_MtMoon:               INCLUDE "audio/music/mtmoon.asm"
Music_ShowMeAround:         INCLUDE "audio/music/showmearound.asm"
Music_GameCorner:           INCLUDE "audio/music/gamecorner.asm"
Music_Bicycle:              INCLUDE "audio/music/bicycle.asm"
Music_LookSage:             INCLUDE "audio/music/looksage.asm"
Music_PokemonChannel:       INCLUDE "audio/music/pokemonchannel.asm"
Music_Lighthouse:           INCLUDE "audio/music/lighthouse.asm"
Music_LakeOfRage:           INCLUDE "audio/music/lakeofrage.asm"
Music_IndigoPlateau:        INCLUDE "audio/music/indigoplateau.asm"
Music_Route37:              INCLUDE "audio/music/route37.asm"
Music_RocketHideout:        INCLUDE "audio/music/rockethideout.asm"
Music_DragonsDen:           INCLUDE "audio/music/dragonsden.asm"
Music_RuinsOfAlphRadio:     INCLUDE "audio/music/ruinsofalphradio.asm"
Music_LookBeauty:           INCLUDE "audio/music/lookbeauty.asm"
Music_Route26:              INCLUDE "audio/music/route26.asm"
Music_EcruteakCity:         INCLUDE "audio/music/ecruteakcity.asm"
Music_LakeOfRageRocketRadio:INCLUDE "audio/music/lakeofragerocketradio.asm"
Music_MagnetTrain:          INCLUDE "audio/music/magnettrain.asm"
Music_LavenderTown:         INCLUDE "audio/music/lavendertown.asm"
Music_DancingHall:          INCLUDE "audio/music/dancinghall.asm"
Music_ContestResults:       INCLUDE "audio/music/contestresults.asm"
Music_Route30:              INCLUDE "audio/music/route30.asm"

SECTION "bank3C",ROMX,BANK[$3C]

;                          Songs III

Music_VioletCity:           INCLUDE "audio/music/violetcity.asm"
Music_Route29:              INCLUDE "audio/music/route29.asm"
Music_HallOfFame:           INCLUDE "audio/music/halloffame.asm"
Music_HealPokemon:          INCLUDE "audio/music/healpokemon.asm"
Music_Evolution:            INCLUDE "audio/music/evolution.asm"
Music_Printer:              INCLUDE "audio/music/printer.asm"

INCBIN "baserom.gbc", $f0941, $f2787 - $f0941

CryHeaders:
INCLUDE "audio/cry_headers.asm"

INCBIN "baserom.gbc", $f2d69, $f3fb6 - $f2d69


SECTION "bank3D",ROMX,BANK[$3D]

;                           Songs IV

Music_ViridianCity:         INCLUDE "audio/music/viridiancity.asm"
Music_CeladonCity:          INCLUDE "audio/music/celadoncity.asm"
Music_WildPokemonVictory:   INCLUDE "audio/music/wildpokemonvictory.asm"
Music_SuccessfulCapture:    INCLUDE "audio/music/successfulcapture.asm"
Music_GymLeaderVictory:     INCLUDE "audio/music/gymleadervictory.asm"
Music_MtMoonSquare:         INCLUDE "audio/music/mtmoonsquare.asm"
Music_Gym:                  INCLUDE "audio/music/gym.asm"
Music_PalletTown:           INCLUDE "audio/music/pallettown.asm"
Music_ProfOaksPokemonTalk:  INCLUDE "audio/music/profoakspokemontalk.asm"
Music_ProfOak:              INCLUDE "audio/music/profoak.asm"
Music_LookRival:            INCLUDE "audio/music/lookrival.asm"
Music_AfterTheRivalFight:   INCLUDE "audio/music/aftertherivalfight.asm"
Music_Surf:                 INCLUDE "audio/music/surf.asm"
Music_NationalPark:         INCLUDE "audio/music/nationalpark.asm"
Music_AzaleaTown:           INCLUDE "audio/music/azaleatown.asm"
Music_CherrygroveCity:      INCLUDE "audio/music/cherrygrovecity.asm"
Music_UnionCave:            INCLUDE "audio/music/unioncave.asm"
Music_JohtoWildBattle:      INCLUDE "audio/music/johtowildbattle.asm"
Music_JohtoWildBattleNight: INCLUDE "audio/music/johtowildbattlenight.asm"
Music_JohtoTrainerBattle:   INCLUDE "audio/music/johtotrainerbattle.asm"
Music_LookYoungster:        INCLUDE "audio/music/lookyoungster.asm"
Music_TinTower:             INCLUDE "audio/music/tintower.asm"
Music_SproutTower:          INCLUDE "audio/music/sprouttower.asm"
Music_BurnedTower:          INCLUDE "audio/music/burnedtower.asm"
Music_Mom:                  INCLUDE "audio/music/mom.asm"
Music_VictoryRoad:          INCLUDE "audio/music/victoryroad.asm"
Music_PokemonLullaby:       INCLUDE "audio/music/pokemonlullaby.asm"
Music_PokemonMarch:         INCLUDE "audio/music/pokemonmarch.asm"
Music_GoldSilverOpening:    INCLUDE "audio/music/goldsilveropening.asm"
Music_GoldSilverOpening2:   INCLUDE "audio/music/goldsilveropening2.asm"
Music_LookHiker:            INCLUDE "audio/music/lookhiker.asm"
Music_LookRocket:           INCLUDE "audio/music/lookrocket.asm"
Music_RocketTheme:          INCLUDE "audio/music/rockettheme.asm"
Music_MainMenu:             INCLUDE "audio/music/mainmenu.asm"
Music_LookKimonoGirl:       INCLUDE "audio/music/lookkimonogirl.asm"
Music_PokeFluteChannel:     INCLUDE "audio/music/pokeflutechannel.asm"
Music_BugCatchingContest:   INCLUDE "audio/music/bugcatchingcontest.asm"

SECTION "bank3E",ROMX,BANK[$3E]

FontExtra:
INCBIN "gfx/misc/font_extra.2bpp"

Font:
INCBIN "gfx/misc/font.1bpp"

FontBattleExtra:
INCBIN "gfx/misc/font_battle_extra.2bpp"

Frames: ; f8800
INCBIN "gfx/frames/1.1bpp"
INCBIN "gfx/frames/2.1bpp"
INCBIN "gfx/frames/3.1bpp"
INCBIN "gfx/frames/4.1bpp"
INCBIN "gfx/frames/5.1bpp"
INCBIN "gfx/frames/6.1bpp"
INCBIN "gfx/frames/7.1bpp"
INCBIN "gfx/frames/8.1bpp"
INCBIN "gfx/frames/9.1bpp"
; f89b0

INCBIN "baserom.gbc", $f89b0, $f8ba0 - $f89b0

TownMapGFX: ; f8ba0
INCBIN "gfx/misc/town_map.lz"
; f8ea3

INCBIN "baserom.gbc", $f8ea3, $fb449 - $f8ea3


Functionfb449: ; fb449
	ld de, $4200
	ld hl, VTiles1
	ld bc, Function3e80
	ld a, [rLCDC]
	bit 7, a
	jp z, Copy1bpp
	ld de, $4200
	ld hl, VTiles1
	ld bc, $3e20
	call Functionddc
	ld de, $4300
	ld hl, $8a00
	ld bc, $3e20
	call Functionddc
	ld de, $4400
	ld hl, $8c00
	ld bc, $3e20
	call Functionddc
	ld de, $4500
	ld hl, $8e00
	ld bc, $3e20
	call Functionddc
	ret
; fb48a



Functionfb48a: ; fb48a
	ld de, $5214
	ld hl, $9600
	ld bc, $3e01
	call Functionddc
	ld de, $4f24
	ld hl, $9620
	ld bc, $3e01
	call Functiondc9
	ld de, $4030
	ld hl, $9630
	ld bc, $3e16
	call Functiondc9
	jr Functionfb4cc
; fb4b0

Functionfb4b0: ; fb4b0
	ld de, $5424
	ld hl, $9610
	ld b, $3e
	ld c, $1
	call Functiondc9
	ret
; fb4be

Functionfb4be: ; fb4be
	ld de, $4600
	ld hl, $9600
	ld bc, $3e19
	call Functiondc9
	jr Functionfb4cc
; fb4cc

Functionfb4cc: ; fb4cc
	ld a, [TextBoxFrame]
	and 7
	ld bc, $0030
	ld hl, Frames
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, $9790
	ld bc, $3e06
	call Functionddc
	ld hl, $97f0
	ld de, $5204
	ld bc, $3e01
	call Functionddc
	ret
; fb4f2

Functionfb4f2: ; fb4f2
	ld de, $4600
	ld hl, $9600
	ld bc, $3e0c
	call Functiondc9
	ld hl, $9700
	ld de, $4700
	ld bc, $3e03
	call Functiondc9
	call $74cc
	ld de, $4ac0
	ld hl, $96c0
	ld bc, $3e04
	call Functionddc
	ld de, $4ae0
	ld hl, $9730
	ld bc, $3e06
	call Functionddc
	ld de, $4b10
	ld hl, $9550
	ld bc, $3e09
	call Functiondc9
	ld de, $52a4
	ld hl, $95e0
	ld bc, $3e02
	call Functiondc9
	ret
; fb53e

Functionfb53e: ; fb53e
	call $74be
	ld de, $4ac0
	ld hl, $96c0
	ld bc, $3e04
	call Functionddc
	ld de, $4ae0
	ld hl, $9780
	ld bc, $3e01
	call Functionddc
	ld de, $4af8
	ld hl, $9760
	ld bc, $3e02
	call Functionddc
	ld de, $4b10
	ld hl, $9550
	ld bc, $3e08
	call Functiondc9
	ld de, $49b0
	ld hl, $9310
	ld bc, $3e11
	call Functiondc9
	ret
; fb57e

INCBIN "baserom.gbc", $fb57e, $fba18 - $fb57e


Functionfba18: ; fba18
	ld a, [UnownLetter]
	ld c, a
	ld b, $1a
	ld hl, UnownDex
.asm_fba21
	ld a, [hli]
	and a
	jr z, .asm_fba2b
	cp c
	ret z
	dec b
	jr nz, .asm_fba21
	ret

.asm_fba2b
	dec hl
	ld [hl], c
	ret
; fba2e

INCBIN "baserom.gbc", $fba2e, $fbbfc - $fba2e

INCLUDE "battle/magikarp_length.asm"

INCBIN "baserom.gbc", $fbccf, $fbced - $fbccf

INCLUDE "battle/hidden_power.asm"

INCBIN "baserom.gbc", $fbd54, $fbda4 - $fbd54


DoWeatherModifiers: ; fbda4

	ld de, .WeatherTypeModifiers
	ld a, [Weather]
	ld b, a
	ld a, [$d265] ; move type
	ld c, a

.CheckWeatherType
	ld a, [de]
	inc de
	cp $ff
	jr z, .asm_fbdc0

	cp b
	jr nz, .NextWeatherType

	ld a, [de]
	cp c
	jr z, .ApplyModifier

.NextWeatherType
	inc de
	inc de
	jr .CheckWeatherType


.asm_fbdc0
	ld de, .WeatherMoveModifiers

	ld a, BATTLE_VARS_MOVE_EFFECT
	call CleanGetBattleVarPair
	ld c, a

.CheckWeatherMove
	ld a, [de]
	inc de
	cp $ff
	jr z, .done

	cp b
	jr nz, .NextWeatherMove

	ld a, [de]
	cp c
	jr z, .ApplyModifier

.NextWeatherMove
	inc de
	inc de
	jr .CheckWeatherMove

.ApplyModifier
	xor a
	ld [hMultiplicand], a
	ld hl, CurDamage
	ld a, [hli]
	ld [$ffb5], a
	ld a, [hl]
	ld [$ffb6], a

	inc de
	ld a, [de]
	ld [hMultiplier], a

	call Multiply

	ld a, 10
	ld [hMultiplier], a
	ld b, $4
	call Divide

	ld a, [hMultiplicand]
	and a
	ld bc, $ffff
	jr nz, .Update

	ld a, [$ffb5]
	ld b, a
	ld a, [$ffb6]
	ld c, a
	or b
	jr nz, .Update

	ld bc, 1

.Update
	ld a, b
	ld [CurDamage], a
	ld a, c
	ld [CurDamage + 1], a

.done
	ret

.WeatherTypeModifiers
	db WEATHER_RAIN, WATER, 15
	db WEATHER_RAIN, FIRE,  05
	db WEATHER_SUN,  FIRE,  15
	db WEATHER_SUN,  WATER, 05
	db $ff

.WeatherMoveModifiers
	db WEATHER_RAIN, EFFECT_SOLARBEAM, 05
	db $ff
; fbe24


DoBadgeTypeBoosts: ; fbe24
	ld a, [InLinkBattle]
	and a
	ret nz

	ld a, [$cfc0]
	and a
	ret nz

	ld a, [hBattleTurn]
	and a
	ret nz

	push de
	push bc

	ld hl, .BadgeTypes

	ld a, [KantoBadges]
	ld b, a
	ld a, [JohtoBadges]
	ld c, a

.CheckBadge
	ld a, [hl]
	cp $ff
	jr z, .done

	srl b
	rr c
	jr nc, .NextBadge

	ld a, [$d265] ; move type
	cp [hl]
	jr z, .ApplyBoost

.NextBadge
	inc hl
	jr .CheckBadge

.ApplyBoost
	ld a, [CurDamage]
	ld h, a
	ld d, a
	ld a, [CurDamage + 1]
	ld l, a
	ld e, a

	srl d
	rr e
	srl d
	rr e
	srl d
	rr e

	ld a, e
	or d
	jr nz, .asm_fbe6f
	ld e, 1

.asm_fbe6f
	add hl, de
	jr nc, .Update

	ld hl, $ffff

.Update
	ld a, h
	ld [CurDamage], a
	ld a, l
	ld [$d257], a

.done
	pop bc
	pop de
	ret

.BadgeTypes
	db FLYING   ; zephyrbadge
	db BUG      ; hivebadge
	db NORMAL   ; plainbadge
	db GHOST    ; fogbadge
	db STEEL    ; mineralbadge
	db FIGHTING ; stormbadge
	db ICE      ; glacierbadge
	db DRAGON   ; risingbadge

	db ROCK     ; boulderbadge
	db WATER    ; cascadebadge
	db ELECTRIC ; thunderbadge
	db GRASS    ; rainbowbadge
	db POISON   ; soulbadge
	db PSYCHIC  ; marshbadge
	db FIRE     ; volcanobadge
	db GROUND   ; earthbadge
	db $ff
; fbe91


SECTION "bank3F",ROMX,BANK[$3F]

_AnimateTileset: ; fc000
; Iterate over a given pointer array of
; animation functions (one per frame).

; Typically in wra1, vra0

	ld a, [TilesetAnim]
	ld e, a
	ld a, [TilesetAnim + 1]
	ld d, a

	ld a, [hTileAnimFrame]
	ld l, a
	inc a
	ld [hTileAnimFrame], a

	ld h, 0
	add hl, hl
	add hl, hl
	add hl, de

; 2-byte parameter
; All functions take input de.
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl

; Function address
	ld a, [hli]
	ld h, [hl]
	ld l, a

	jp [hl]
; fc01b


Tileset00Anim: ; 0xfc01b
Tileset02Anim: ; 0xfc01b
Tileset03Anim: ; 0xfc01b
;	   param, function
	dw $9140, AnimateWaterTile
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, TileAnimationPalette
	dw $0000, WaitTileAnimation
	dw $0000, AnimateFlowerTile
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, NextTileFrame8
	dw $0000, DoneTileAnimation
; 0xfc047

Tileset25Anim: ; 0xfc047
;	   param, function
	dw $9140, AnimateWaterTile
	dw $0000, WaitTileAnimation
	dw $95f0, AnimateFountain
	dw $0000, WaitTileAnimation
	dw $0000, TileAnimationPalette
	dw $0000, WaitTileAnimation
	dw $0000, AnimateFlowerTile
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, NextTileFrame8
	dw $0000, DoneTileAnimation
; 0xfc073

Tileset31Anim: ; 0xfc073
;	   param, function
	dw $0000, ForestTreeLeftAnimation
	dw $0000, ForestTreeRightAnimation
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, ForestTreeLeftAnimation2
	dw $0000, ForestTreeRightAnimation2
	dw $0000, AnimateFlowerTile
	dw $9140, AnimateWaterTile
	dw $0000, TileAnimationPalette
	dw $0000, NextTileFrame8
	dw $0000, DoneTileAnimation
; 0xfc0a3

Tileset01Anim: ; 0xfc0a3
;	   param, function
	dw $9140, AnimateWaterTile
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, TileAnimationPalette
	dw $0000, WaitTileAnimation
	dw $0000, AnimateFlowerTile
	dw $4a98, AnimateWhirlpoolTile
	dw $4a9c, AnimateWhirlpoolTile
	dw $4aa0, AnimateWhirlpoolTile
	dw $4aa4, AnimateWhirlpoolTile
	dw $0000, WaitTileAnimation
	dw $0000, NextTileFrame8
	dw $0000, DoneTileAnimation
; 0xfc0d7

INCBIN "baserom.gbc", $fc0d7, $fc12f-$fc0d7

Tileset09Anim: ; 0xfc12f
;	   param, function
	dw $9140, AnimateWaterTile
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, TileAnimationPalette
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, NextTileFrame8
	dw $0000, DoneTileAnimation
; 0xfc15f

Tileset15Anim: ; 0xfc15f
;	   param, function
	dw $0000, SafariFountainAnim2
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, SafariFountainAnim1
	dw $0000, WaitTileAnimation
	dw $0000, NextTileFrame8
	dw $0000, DoneTileAnimation
; 0xfc17f

INCBIN "baserom.gbc", $fc17f, $fc1e7-$fc17f

Tileset24Anim: ; 0xfc1e7
Tileset30Anim: ; 0xfc1e7
;	   param, function
	dw $9140, WriteTileToBuffer
	dw $0000, Functionfc71e
	dw $cf41, ScrollTileRightLeft
	dw $0000, Functionfc71e
	dw $9140, WriteTileFromBuffer
	dw $0000, Functionfc71e
	dw $0000, TileAnimationPalette
	dw $0000, Functionfc71e
	dw $9400, WriteTileToBuffer
	dw $0000, Functionfc71e
	dw $cf41, ScrollTileDown
	dw $0000, Functionfc71e
	dw $cf41, ScrollTileDown
	dw $0000, Functionfc71e
	dw $cf41, ScrollTileDown
	dw $0000, Functionfc71e
	dw $9400, WriteTileFromBuffer
	dw $0000, Functionfc71e
	dw $0000, DoneTileAnimation
; 0xfc233

Tileset29Anim: ; 0xfc233
;	   param, function
	dw $9350, WriteTileToBuffer
	dw $0000, Functionfc71e
	dw $cf41, ScrollTileRightLeft
	dw $0000, Functionfc71e
	dw $9350, WriteTileFromBuffer
	dw $0000, Functionfc71e
	dw $0000, TileAnimationPalette
	dw $0000, Functionfc71e
	dw $9310, WriteTileToBuffer
	dw $0000, Functionfc71e
	dw $cf41, ScrollTileDown
	dw $0000, Functionfc71e
	dw $cf41, ScrollTileDown
	dw $0000, Functionfc71e
	dw $cf41, ScrollTileDown
	dw $0000, Functionfc71e
	dw $9310, WriteTileFromBuffer
	dw $0000, Functionfc71e
	dw $0000, DoneTileAnimation
; 0xfc27f

Tileset23Anim: ; 0xfc27f
;	   param, function
	dw SproutPillarTilePointer9,  AnimateSproutPillarTile
	dw SproutPillarTilePointer10, AnimateSproutPillarTile
	dw SproutPillarTilePointer7,  AnimateSproutPillarTile
	dw SproutPillarTilePointer8,  AnimateSproutPillarTile
	dw SproutPillarTilePointer5,  AnimateSproutPillarTile
	dw SproutPillarTilePointer6,  AnimateSproutPillarTile
	dw SproutPillarTilePointer3,  AnimateSproutPillarTile
	dw SproutPillarTilePointer4,  AnimateSproutPillarTile
	dw SproutPillarTilePointer1,  AnimateSproutPillarTile
	dw SproutPillarTilePointer2,  AnimateSproutPillarTile
	dw $0000, NextTileFrame
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, DoneTileAnimation
; 0xfc2bf

INCBIN "baserom.gbc", $fc2bf, $fc2e7-$fc2bf

Tileset04Anim: ; 0xfc2e7
Tileset05Anim: ; 0xfc2e7
Tileset06Anim: ; 0xfc2e7
Tileset07Anim: ; 0xfc2e7
Tileset08Anim: ; 0xfc2e7
Tileset10Anim: ; 0xfc2e7
Tileset11Anim: ; 0xfc2e7
Tileset12Anim: ; 0xfc2e7
Tileset13Anim: ; 0xfc2e7
Tileset14Anim: ; 0xfc2e7
Tileset16Anim: ; 0xfc2e7
Tileset17Anim: ; 0xfc2e7
Tileset18Anim: ; 0xfc2e7
Tileset19Anim: ; 0xfc2e7
Tileset20Anim: ; 0xfc2e7
Tileset21Anim: ; 0xfc2e7
Tileset22Anim: ; 0xfc2e7
Tileset26Anim: ; 0xfc2e7
Tileset27Anim: ; 0xfc2e7
Tileset28Anim: ; 0xfc2e7
Tileset32Anim: ; 0xfc2e7
Tileset33Anim: ; 0xfc2e7
Tileset34Anim: ; 0xfc2e7
Tileset35Anim: ; 0xfc2e7
Tileset36Anim: ; 0xfc2e7
;	   param, function
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, WaitTileAnimation
	dw $0000, DoneTileAnimation
; 0xfc2fb

DoneTileAnimation: ; fc2fb
; Reset the animation command loop.
	xor a
	ld [hTileAnimFrame], a
	
WaitTileAnimation: ; fc2fe
; Do nothing this frame.
	ret
; fc2ff

NextTileFrame8: ; fc2ff
	ld a, [TileAnimationTimer]
	inc a
	and a, 7
	ld [TileAnimationTimer], a
	ret
; fc309


ScrollTileRightLeft: ; fc309
; Scroll right for 4 ticks, then left for 4 ticks.
	ld a, [TileAnimationTimer]
	inc a
	and 7
	ld [TileAnimationTimer], a
	and 4
	jr nz, ScrollTileLeft
	jr ScrollTileRight
; fc318

ScrollTileUpDown: ; fc318
; Scroll up for 4 ticks, then down for 4 ticks.
	ld a, [TileAnimationTimer]
	inc a
	and 7
	ld [TileAnimationTimer], a
	and 4
	jr nz, ScrollTileDown
	jr ScrollTileUp
; fc327

ScrollTileLeft: ; fc327
	ld h, d
	ld l, e
	ld c, 4
.loop
	rept 4
	ld a, [hl]
	rlca
	ld [hli], a
	endr
	dec c
	jr nz, .loop
	ret
; fc33b

ScrollTileRight: ; fc33b
	ld h, d
	ld l, e
	ld c, 4
.loop
	rept 4
	ld a, [hl]
	rrca
	ld [hli], a
	endr
	dec c
	jr nz, .loop
	ret
; fc34f

ScrollTileUp: ; fc34f
	ld h, d
	ld l, e
	ld d, [hl]
	inc hl
	ld e, [hl]
	ld bc, $e
	add hl, bc
	ld a, 4
.loop
	ld c, [hl]
	ld [hl], e
	dec hl
	ld b, [hl]
	ld [hl], d
	dec hl
	ld e, [hl]
	ld [hl], c
	dec hl
	ld d, [hl]
	ld [hl], b
	dec hl
	dec a
	jr nz, .loop
	ret
; fc36a

ScrollTileDown: ; fc36a
	ld h, d
	ld l, e
	ld de, $e
	push hl
	add hl, de
	ld d, [hl]
	inc hl
	ld e, [hl]
	pop hl
	ld a, 4
.loop
	ld b, [hl]
	ld [hl], d
	inc hl
	ld c, [hl]
	ld [hl], e
	inc hl
	ld d, [hl]
	ld [hl], b
	inc hl
	ld e, [hl]
	ld [hl], c
	inc hl
	dec a
	jr nz, .loop
	ret
; fc387


AnimateFountain: ; fc387
	ld hl, [sp+0]
	ld b, h
	ld c, l
	ld hl, .frames
	ld a, [TileAnimationTimer]
	and 7
	add a
	add l
	ld l, a
	jr nc, .asm_fc399
	inc h

.asm_fc399
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld sp, hl
	ld l, e
	ld h, d
	jp WriteTile

.frames
	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame1

.frame1
	INCBIN "gfx/tilesets/fountain/1.2bpp"
.frame2
	INCBIN "gfx/tilesets/fountain/2.2bpp"
.frame3
	INCBIN "gfx/tilesets/fountain/3.2bpp"
.frame4
	INCBIN "gfx/tilesets/fountain/4.2bpp"
.frame5
	INCBIN "gfx/tilesets/fountain/5.2bpp"
; fc402


AnimateWaterTile: ; fc402
; Draw a water tile for the current frame in VRAM tile at de.

; Save sp in bc (see WriteTile).
	ld hl, [sp+0]
	ld b, h
	ld c, l
	
	ld a, [TileAnimationTimer]
	
; 4 tile graphics, updated every other frame.
	and 3 << 1
	
; 2 x 8 = 16 bytes per tile
	add a
	add a
	add a
	
	add WaterTileFrames % $100
	ld l, a
	ld a, 0
	adc WaterTileFrames / $100
	ld h, a
	
; Stack now points to the start of the tile for this frame.
	ld sp, hl
	
	ld l, e
	ld h, d
	
	jp WriteTile
; fc41c

WaterTileFrames: ; fc41c
; Frames 0-3
; INCBIN "gfx/tilesets/water.2bpp"
INCBIN "baserom.gbc", $fc41c, $fc45c - $fc41c
; fc45c


ForestTreeLeftAnimation: ; fc45c
	ld hl, [sp+0]
	ld b, h
	ld c, l

; Only during the Celebi event.
	ld a, [$dbf3]
	bit 2, a
	jr nz, .asm_fc46c
	ld hl, ForestTreeLeftFrames
	jr .asm_fc47d

.asm_fc46c
	ld a, [TileAnimationTimer]
	call GetForestTreeFrame
	add a
	add a
	add a
	add ForestTreeLeftFrames % $100
	ld l, a
	ld a, 0
	adc ForestTreeLeftFrames / $100
	ld h, a

.asm_fc47d
	ld sp, hl
	ld hl, $90c0
	jp WriteTile
; fc484


ForestTreeLeftFrames: ; fc484
	INCBIN "gfx/tilesets/forest-tree/1.2bpp"
	INCBIN "gfx/tilesets/forest-tree/2.2bpp"
; fc4a4

ForestTreeRightFrames: ; fc4a4
	INCBIN "gfx/tilesets/forest-tree/3.2bpp"
	INCBIN "gfx/tilesets/forest-tree/4.2bpp"
; fc4c4


ForestTreeRightAnimation: ; fc4c4
	ld hl, [sp+0]
	ld b, h
	ld c, l

; Only during the Celebi event.
	ld a, [$dbf3]
	bit 2, a
	jr nz, .asm_fc4d4
	ld hl, ForestTreeRightFrames
	jr .asm_fc4eb

.asm_fc4d4
	ld a, [TileAnimationTimer]
	call GetForestTreeFrame
	add a
	add a
	add a
	add ForestTreeLeftFrames % $100
	ld l, a
	ld a, 0
	adc ForestTreeLeftFrames / $100
	ld h, a
	push bc
	ld bc, ForestTreeRightFrames - ForestTreeLeftFrames
	add hl, bc
	pop bc

.asm_fc4eb
	ld sp, hl
	ld hl, $90f0
	jp WriteTile
; fc4f2


ForestTreeLeftAnimation2: ; fc4f2
	ld hl, [sp+0]
	ld b, h
	ld c, l

; Only during the Celebi event.
	ld a, [$dbf3]
	bit 2, a
	jr nz, .asm_fc502
	ld hl, ForestTreeLeftFrames
	jr .asm_fc515

.asm_fc502
	ld a, [TileAnimationTimer]
	call GetForestTreeFrame
	xor 2
	add a
	add a
	add a
	add ForestTreeLeftFrames % $100
	ld l, a
	ld a, 0
	adc ForestTreeLeftFrames / $100
	ld h, a

.asm_fc515
	ld sp, hl
	ld hl, $90c0
	jp WriteTile
; fc51c


ForestTreeRightAnimation2: ; fc51c
	ld hl, [sp+0]
	ld b, h
	ld c, l

; Only during the Celebi event.
	ld a, [$dbf3]
	bit 2, a
	jr nz, .asm_fc52c
	ld hl, ForestTreeRightFrames
	jr .asm_fc545

.asm_fc52c
	ld a, [TileAnimationTimer]
	call GetForestTreeFrame
	xor 2
	add a
	add a
	add a
	add ForestTreeLeftFrames % $100
	ld l, a
	ld a, 0
	adc ForestTreeLeftFrames / $100
	ld h, a
	push bc
	ld bc, ForestTreeRightFrames - ForestTreeLeftFrames
	add hl, bc
	pop bc

.asm_fc545
	ld sp, hl
	ld hl, $90f0
	jp WriteTile
; fc54c


GetForestTreeFrame: ; fc54c
; Return 0 if a is even, or 2 if odd.
	and a
	jr z, .even
	cp 1
	jr z, .odd
	cp 2
	jr z, .even
	cp 3
	jr z, .odd
	cp 4
	jr z, .even
	cp 5
	jr z, .odd
	cp 6
	jr z, .even
.odd
	ld a, 2
	scf
	ret
.even
	xor a
	ret
; fc56d


AnimateFlowerTile: ; fc56d
; No parameters.

; Save sp in bc (see WriteTile).
	ld hl, [sp+0]
	ld b, h
	ld c, l
	
; Alternate tile graphc every other frame
	ld a, [TileAnimationTimer]
	and 1 << 1
	ld e, a
	
; CGB has different color mappings for flowers.
	ld a, [hCGB]
	and 1
	
	add e
	swap a ; << 4 (16 bytes)
	ld e, a
	ld d, 0
	ld hl, FlowerTileFrames
	add hl, de
	ld sp, hl
	
	ld hl, VTiles2 + $30 ; tile 4
	
	jp WriteTile
; fc58c

FlowerTileFrames: ; fc58c
; frame 0 dmg
; frame 0 cgb
; frame 1 dmg
; frame 1 sgb
; INCBIN "gfx/tilesets/flower.2bpp"
INCBIN "baserom.gbc", $fc58c, $fc5cc - $fc58c
; fc5cc


SafariFountainAnim1: ; fc5cc
; Splash in the bottom-right corner of the fountain.
	ld hl, [sp+0]
	ld b, h
	ld c, l
	ld a, [TileAnimationTimer]
	and 6
	srl a
	inc a
	inc a
	and 3
	swap a
	ld e, a
	ld d, 0
	ld hl, SafariFountainFrames
	add hl, de
	ld sp, hl
	ld hl, $95b0
	jp WriteTile
; fc5eb


SafariFountainAnim2: ; fc5eb
; Splash in the top-left corner of the fountain.
	ld hl, [sp+0]
	ld b, h
	ld c, l
	ld a, [TileAnimationTimer]
	and 6
	add a
	add a
	add a
	ld e, a
	ld d, 0
	ld hl, SafariFountainFrames
	add hl, de
	ld sp, hl
	ld hl, $9380
	jp WriteTile
; fc605


SafariFountainFrames: ; fc605
	INCBIN "gfx/tilesets/safari/1.2bpp"
	INCBIN "gfx/tilesets/safari/2.2bpp"
	INCBIN "gfx/tilesets/safari/3.2bpp"
	INCBIN "gfx/tilesets/safari/4.2bpp"
; fc645


AnimateSproutPillarTile: ; fc645
; Read from struct at de:
; 	Destination (VRAM)
;	Address of the first tile in the frame array

	ld hl, [sp+0]
	ld b, h
	ld c, l

	ld a, [TileAnimationTimer]
	and 7

; Get frame index a
	ld hl, .frames
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
	ld a, [hl]

; Destination
	ld l, e
	ld h, d
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl

; Add the frame index to the starting address
	add [hl]
	inc hl
	ld h, [hl]
	ld l, a
	ld a, 0
	adc h
	ld h, a

	ld sp, hl
	ld l, e
	ld h, d
	jr WriteTile

.frames
	db $00, $10, $20, $30, $40, $30, $20, $10
; fc673


NextTileFrame: ; fc673
	ld hl, TileAnimationTimer
	inc [hl]
	ret
; fc678


AnimateWhirlpoolTile: ; fc678
; Update whirlpool tile using struct at de.

; Struct:
; 	VRAM address
;	Address of the first tile

; Only does one of 4 tiles at a time.

; Save sp in bc (see WriteTile).
	ld hl, [sp+0]
	ld b, h
	ld c, l
	
; de = VRAM address
	ld l, e
	ld h, d
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
; Tile address is now at hl.
	
; Get the tile for this frame.
	ld a, [TileAnimationTimer]
	and %11 ; 4 frames x2
	swap a  ; * 16 bytes per tile
	
	add [hl]
	inc hl
	ld h, [hl]
	ld l, a
	ld a, 0
	adc h
	ld h, a
	
; Stack now points to the desired frame.
	ld sp, hl
	
	ld l, e
	ld h, d
	
	jr WriteTile
; fc696
	
	
WriteTileFromBuffer: ; fc696
; Write tiledata at $cf41 to de.
; $cf41 is loaded to sp for WriteTile.

	ld hl, [sp+0]
	ld b, h
	ld c, l
	
	ld hl, $cf41
	ld sp, hl
	
	ld h, d
	ld l, e
	jr WriteTile
; fc6a2
	
	
WriteTileToBuffer: ; fc6a2
; Write tiledata de to $cf41.
; de is loaded to sp for WriteTile.

	ld hl, [sp+0]
	ld b, h
	ld c, l
	
	ld h, d
	ld l, e
	ld sp, hl
	
	ld hl, $cf41
	
	; fallthrough

WriteTile: ; fc6ac
; Write one 8x8 tile ($10 bytes) from sp to hl.

; Warning: sp is saved in bc so we can abuse pop.
; sp is restored to address bc. Save sp in bc before calling.

	pop de
	ld [hl], e
	inc hl
	ld [hl], d
	
rept 7
	pop de
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
endr
	
; restore sp
	ld h, b
	ld l, c
	ld sp, hl
	ret
; fc6d7


TileAnimationPalette: ; fc6d7
; Transition between color values 0-2 for color 0 in palette 3.

; No palette changes on DMG.
	ld a, [hCGB]
	and a
	ret z
	
; We don't want to mess with non-standard palettes.
	ld a, [rBGP] ; BGP
	cp %11100100
	ret nz
	
; Only update on even frames.
	ld a, [TileAnimationTimer]
	ld l, a
	and 1 ; odd
	ret nz
	
; Ready for BGPD input...
	ld a, %10011000 ; auto increment, index $18 (pal 3 color 0)
	ld [rBGPI], a
	
	ld a, [rSVBK]
	push af
	ld a, 5 ; wra5: gfx
	ld [rSVBK], a
	
; Update color 0 in order 0 1 2 1
	
	ld a, l
	and %110 ; frames 0 2 4 6
	
	jr z, .color0
	
	cp 4
	jr z, .color2
	
.color1
	ld hl, $d01a ; pal 3 color 1
	ld a, [hli]
	ld [rBGPD], a
	ld a, [hli]
	ld [rBGPD], a
	jr .end
	
.color0
	ld hl, $d018 ; pal 3 color 0
	ld a, [hli]
	ld [rBGPD], a
	ld a, [hli]
	ld [rBGPD], a
	jr .end
	
.color2
	ld hl, $d01c ; pal 3 color 2
	ld a, [hli]
	ld [rBGPD], a
	ld a, [hli]
	ld [rBGPD], a
	
.end
	pop af
	ld [rSVBK], a
	ret
; fc71e


Functionfc71e: ; fc71e
	ld a, [hCGB]
	and a
	ret z

	ld a, [rBGP]
	cp $e4
	ret nz

	ld a, [$d847]
	cp $ff
	ret nz

	ld a, [rSVBK]
	push af

	ld a, 5
	ld [rSVBK], a
	ld a, $a0
	ld [rBGPI], a
	ld a, [$ff9b]
	and 2
	jr nz, .asm_fc743
	ld hl, $d020
	jr .asm_fc746

.asm_fc743
	ld hl, $d022

.asm_fc746
	ld a, [hli]
	ld [rBGPD], a
	ld a, [hli]
	ld [rBGPD], a

	pop af
	ld [rSVBK], a
	ret
; fc750


SproutPillarTilePointers: ; fc750
SproutPillarTilePointer1:
	dw $92d0, SproutPillarTile1
SproutPillarTilePointer2:
	dw $92f0, SproutPillarTile2
SproutPillarTilePointer3:
	dw $93d0, SproutPillarTile3
SproutPillarTilePointer4:
	dw $93f0, SproutPillarTile4
SproutPillarTilePointer5:
	dw $93c0, SproutPillarTile5
SproutPillarTilePointer6:
	dw $92c0, SproutPillarTile6
SproutPillarTilePointer7:
	dw $94d0, SproutPillarTile7
SproutPillarTilePointer8:
	dw $94f0, SproutPillarTile8
SproutPillarTilePointer9:
	dw $95d0, SproutPillarTile9
SproutPillarTilePointer10:
	dw $95f0, SproutPillarTile10

SproutPillarTile1:
	INCBIN "gfx/tilesets/sprout-pillar/1.2bpp"
SproutPillarTile2:
	INCBIN "gfx/tilesets/sprout-pillar/2.2bpp"
SproutPillarTile3:
	INCBIN "gfx/tilesets/sprout-pillar/3.2bpp"
SproutPillarTile4:
	INCBIN "gfx/tilesets/sprout-pillar/4.2bpp"
SproutPillarTile5:
	INCBIN "gfx/tilesets/sprout-pillar/5.2bpp"
SproutPillarTile6:
	INCBIN "gfx/tilesets/sprout-pillar/6.2bpp"
SproutPillarTile7:
	INCBIN "gfx/tilesets/sprout-pillar/7.2bpp"
SproutPillarTile8:
	INCBIN "gfx/tilesets/sprout-pillar/8.2bpp"
SproutPillarTile9:
	INCBIN "gfx/tilesets/sprout-pillar/9.2bpp"
SproutPillarTile10:
	INCBIN "gfx/tilesets/sprout-pillar/10.2bpp"
; fca98


INCBIN "baserom.gbc", $fca98, $fcba8 - $fca98


Functionfcba8: ; fcba8
	ld a, e
	ld [$cf63], a
	call Functionfcc59
	ld b, $2
	call Functionfcc4a
	ld a, $4
	jr nz, .asm_fcc03
	ld a, $0
	call Functionfcf38
	call Function1dcf
	ld a, $1
	jr c, .asm_fcc03
	ld b, $6
	ld a, $14
	ld hl, $401d
	rst FarCall
	ld a, $1
	jr c, .asm_fcc03
	ld e, $1
	call LoadTradesPointer
	ld a, [CurPartySpecies]
	cp [hl]
	ld a, $2
	jr nz, .asm_fcc03
	call Functionfcc23
	ld a, $2
	jr c, .asm_fcc03
	ld b, $1
	call Functionfcc4a
	ld hl, $4f7b
	call PrintText
	call Functionfcc63
	call Functionfcc07
	call Functionfce1b
	ld hl, $4f80
	call PrintText
	call Function3d47
	ld a, $3

.asm_fcc03
	call Functionfcf38
	ret
; fcc07

Functionfcc07: ; fcc07
	call Function2ed3
	ld a, [$cf63]
	push af
	ld a, [$cf64]
	push af
	ld a, $1e
	call Predef
	pop af
	ld [$cf64], a
	pop af
	ld [$cf63], a
	call Function2b74
	ret
; fcc23

Functionfcc23: ; fcc23
	xor a
	ld [MonType], a
	ld e, $1e
	call LoadTradesPointer
	ld a, [hl]
	and a
	jr z, .asm_fcc46
	cp $1
	jr z, .asm_fcc3e
	callba GetGender
	jr nz, .asm_fcc48
	jr .asm_fcc46

.asm_fcc3e
	callba GetGender
	jr z, .asm_fcc48

.asm_fcc46
	and a
	ret

.asm_fcc48
	scf
	ret
; fcc4a

Functionfcc4a: ; fcc4a
	ld hl, $d960
	ld a, [$cf63]
	ld c, a
	ld a, $3
	call Predef
	ld a, c
	and a
	ret
; fcc59

Functionfcc59: ; fcc59
	ld e, $0
	call LoadTradesPointer
	ld a, [hl]
	ld [$cf64], a
	ret
; fcc63

Functionfcc63: ; fcc63
	ld e, $1
	call LoadTradesPointer
	ld a, [hl]
	ld [PlayerSDefLevel], a
	ld e, $2
	call LoadTradesPointer
	ld a, [hl]
	ld [PlayerLightScreenCount], a
	ld a, [PlayerSDefLevel]
	ld de, PlayerAccLevel
	call Functionfcde8
	call Functionfcdf4
	ld a, [PlayerLightScreenCount]
	ld de, PlayerReflectCount
	call Functionfcde8
	call Functionfcdf4
	ld hl, PartyMon1OT
	ld bc, $000b
	call Functionfcdd7
	ld de, $c6f2
	call Functionfcdf4
	ld hl, PlayerName
	ld de, $c6e7
	call Functionfcdf4
	ld hl, PartyMon1ID
	ld bc, $0030
	call Functionfcdd7
	ld de, PlayerScreens
	call Functionfce0f
	ld hl, PartyMon1DVs
	ld bc, $0030
	call Functionfcdd7
	ld de, $c6fd
	call Functionfce0f
	ld hl, PartyMon1Species
	ld bc, $0030
	call Functionfcdd7
	ld b, h
	ld c, l
	ld a, $13
	ld hl, $7301
	rst FarCall
	ld a, c
	ld [$c701], a
	ld e, $0
	call LoadTradesPointer
	ld a, [hl]
	cp $3
	ld a, $1
	jr c, .asm_fcce6
	ld a, $2

.asm_fcce6
	ld [$c733], a
	ld hl, PartyMon1Level
	ld bc, $0030
	call Functionfcdd7
	ld a, [hl]
	ld [CurPartyLevel], a
	ld a, [PlayerLightScreenCount]
	ld [CurPartySpecies], a
	xor a
	ld [MonType], a
	ld [$d10b], a
	ld hl, $6039
	ld a, $3
	rst FarCall
	ld a, $6
	call Predef
	ld e, $0
	call LoadTradesPointer
	ld a, [hl]
	cp $3
	ld b, $0
	jr c, .asm_fcd1c
	ld b, $1

.asm_fcd1c
	ld a, $13
	ld hl, $5ba3
	rst FarCall
	ld e, $3
	call LoadTradesPointer
	ld de, FailedMessage
	call Functionfcdf4
	ld hl, PartyMon1Nickname
	ld bc, $000b
	call Functionfcdde
	ld hl, FailedMessage
	call Functionfcdf4
	ld e, $13
	call LoadTradesPointer
	push hl
	ld de, $c724
	call Functionfcdf4
	pop hl
	ld de, $c719
	call Functionfcdf4
	ld hl, PartyMon1OT
	ld bc, $000b
	call Functionfcdde
	ld hl, $c724
	call Functionfcdf4
	ld e, $e
	call LoadTradesPointer
	ld de, $c72f
	call Functionfce0f
	ld hl, PartyMon1DVs
	ld bc, $0030
	call Functionfcdde
	ld hl, $c72f
	call Functionfce0f
	ld e, $11
	call LoadTradesPointer
	ld de, $c732
	call Functionfce15
	ld hl, PartyMon1ID
	ld bc, $0030
	call Functionfcdde
	ld hl, $c731
	call Functionfce0f
	ld e, $10
	call LoadTradesPointer
	push hl
	ld hl, PartyMon1Item
	ld bc, $0030
	call Functionfcdde
	pop hl
	ld a, [hl]
	ld [de], a
	push af
	push bc
	push de
	push hl
	ld a, [CurPartyMon]
	push af
	ld a, [PartyCount]
	dec a
	ld [CurPartyMon], a
	ld a, $3
	ld hl, $6134
	rst FarCall
	pop af
	ld [CurPartyMon], a
	pop hl
	pop de
	pop bc
	pop af
	ret
; fcdc2



LoadTradesPointer: ; 0xfcdc2
	ld d, 0
	push de
	ld a, [$cf63]
	and $f
	swap a
	ld e, a
	ld d, $0
	ld hl, Trades
	add hl, de
	add hl, de
	pop de
	add hl, de
	ret
; 0xfcdd7

Functionfcdd7: ; fcdd7
	ld a, [CurPartyMon]
	call AddNTimes
	ret
; fcdde

Functionfcdde: ; fcdde
	ld a, [PartyCount]
	dec a
	call AddNTimes
	ld e, l
	ld d, h
	ret
; fcde8

Functionfcde8: ; fcde8
	push de
	ld [$d265], a
	call GetBasePokemonName
	ld hl, StringBuffer1
	pop de
	ret
; fcdf4

Functionfcdf4: ; fcdf4
	ld bc, $000b
	call CopyBytes
	ret
; fcdfb

INCBIN "baserom.gbc", $fcdfb, $fce0f - $fcdfb


Functionfce0f: ; fce0f
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ret
; fce15

Functionfce15: ; fce15
	ld a, [hli]
	ld [de], a
	dec de
	ld a, [hl]
	ld [de], a
	ret
; fce1b

Functionfce1b: ; fce1b
	ld e, $2
	call LoadTradesPointer
	ld a, [hl]
	call Functionfcde8
	ld de, StringBuffer2
	call Functionfcdf4
	ld e, $1
	call LoadTradesPointer
	ld a, [hl]
	call Functionfcde8
	ld de, $d050
	call Functionfcdf4
	ld hl, StringBuffer1
.asm_fce3c
	ld a, [hli]
	cp $50
	jr nz, .asm_fce3c
	dec hl
	push hl
	ld e, $1e
	call LoadTradesPointer
	ld a, [hl]
	pop hl
	and a
	ret z
	cp $1
	ld a, $ef
	jr z, .asm_fce54
	ld a, $f5

.asm_fce54
	ld [hli], a
	ld [hl], $50
	ret
; fce58


Trades: ; 0xfce58
; byte 1: dialog
; byte 2: givemon
; byte 3: getmon
; bytes 4-14 nickname
; bytes 15-16 DVs
; byte 17 held item
; bytes 18-19 ID
; bytes 20-30 OT name
; byte 31 gender
; byte 32 XXX always zero?

	db 0,ABRA,MACHOP,"MUSCLE@@@@@", $37, $66,GOLD_BERRY, $54, $92,"MIKE@@@@@@@",0,0
	db 0,BELLSPROUT,ONIX,"ROCKY@@@@@@", $96, $66,BITTER_BERRY, $1e, $bf,"KYLE@@@@@@@",0,0
	db 1,KRABBY,VOLTORB,"VOLTY@@@@@@", $98, $88,PRZCUREBERRY, $05, $72,"TIM@@@@@@@@",0,0
	db 3,DRAGONAIR,DODRIO,"DORIS@@@@@@", $77, $66,SMOKE_BALL, $1b, $01,"EMY@@@@@@@@",2,0
	db 2,HAUNTER,XATU,"PAUL@@@@@@@", $96, $86,MYSTERYBERRY, $00, $3d,"CHRIS@@@@@@",0,0
	db 3,CHANSEY,AERODACTYL,"AEROY@@@@@@", $96, $66,GOLD_BERRY, $7b, $67,"KIM@@@@@@@@",0,0
	db 0,DUGTRIO,MAGNETON,"MAGGIE@@@@@", $96, $66,METAL_COAT, $a2, $c3,"FOREST@@@@@",0,0

Functionfcf38: ; fcf38
	push af
	call Functionfce1b
	pop af
	ld bc, $0008
	ld hl, $4f53
	call AddNTimes
	ld a, [$cf64]
	ld c, a
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	ret
; fcf53

INCBIN "baserom.gbc", $fcf53, $fcfec - $fcf53


Functionfcfec: ; fcfec
	ld a, [$d45c]
	and a
	ret nz
	call Function2d05
	and a
	ret nz
	xor a
	ld [$dc18], a
	call Functionfd044
	ret nc
	call Functionfd0c3
	ret nc
	ld b, $3f
	ld de, $500f
	callba Function97c4f
	scf
	ret
; fd00f

INCBIN "baserom.gbc", $fd00f, $fd044 - $fd00f


Functionfd044: ; fd044
	ld a, [$dc17]
	cp $a
	jr nc, .asm_fd065
	call Functionfd117
	ld a, [hli]
	ld [$ffc3], a
	ld a, [hli]
	ld [$ffc4], a
	ld a, [hli]
	ld [$ffc5], a
	ld de, $d851
	ld bc, $ffc3
	ld a, $5
	ld hl, $600b
	rst FarCall
	jr nc, .asm_fd067

.asm_fd065
	jr .asm_fd069

.asm_fd067
	scf
	ret

.asm_fd069
	ld hl, $ffc3
	ld [hl], $0
	inc hl
	ld [hl], $8
	inc hl
	ld [hl], $fc
.asm_fd074
	ld de, $dc19
	ld bc, $d851
	ld a, $5
	ld hl, $600b
	rst FarCall
	jr z, .asm_fd08b
	jr nc, .asm_fd089
	call Functionfd099
	jr .asm_fd074

.asm_fd089
	xor a
	ret

.asm_fd08b
	call Functionfd099
	ld a, $5
	call Function2fb1
	inc a
	ld [$dc18], a
	scf
	ret
; fd099

Functionfd099: ; fd099
	ld de, $dc19
	ld bc, $ffc3
	ld a, $5
	ld hl, $6053
	rst FarCall
	ret
; fd0a6

INCBIN "baserom.gbc", $fd0a6, $fd0c3 - $fd0a6


Functionfd0c3: ; fd0c3
	call Functionfd117
	ld de, $0006
	add hl, de
	ld a, [hli]
	cp $1
	jr z, .asm_fd0db
	ld a, [hl]
	ld c, a
	ld b, $1
	ld a, $9
	ld hl, $6ef1
	rst FarCall
	scf
	ret

.asm_fd0db
	ld a, [hl]
	ld [CurItem], a
	ld a, $1
	ld [$d10c], a
	ld hl, PCItems
	call Function2f66
	ret
; fd0eb

INCBIN "baserom.gbc", $fd0eb, $fd117 - $fd0eb


Functionfd117: ; fd117
	ld a, [$dc18]
	and a
	jr z, .asm_fd123
	dec a
	ld de, $5136
	jr .asm_fd12e

.asm_fd123
	ld a, [$dc17]
	cp $a
	jr c, .asm_fd12b
	xor a

.asm_fd12b
	ld de, $515e

.asm_fd12e
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ret
; fd136

INCBIN "baserom.gbc", $fd136, $fd1d2 - $fd136


SECTION "bank40",ROMX,BANK[$40]

Function100000: ; 100000
	ld a, [rSVBK]
	push af
	ld a, $1
	ld [rSVBK], a
	call Function100022
	call Function1000ba
	call Function100675
	call Function100057
	call Function10016f
	call Function100276
	push bc
	call Function100301
	pop bc
	pop af
	ld [rSVBK], a
	ret
; 100022

Function100022: ; 100022
	push de
	push bc
	call Function100063
	pop bc
	pop de
	ld a, d
	ld [$cd21], a
	ld a, e
	ld [CreditsTimer], a
	ld a, c
	ld [$cd23], a
	ld a, b
	ld [$cd24], a
	callba Function10127e
	callba Function106462
	callba Function106464
	callba Function11615a
	ld hl, VramState
	set 1, [hl]
	ret
; 100057

Function100057: ; 100057
	call Function1000a4
	call Function222a
	ld hl, VramState
	res 1, [hl]
	ret
; 100063

Function100063: ; 100063
	xor a
	ld hl, BGMapBuffer
	ld bc, $0065
	call ByteFill
	xor a
	ld hl, $c300
	ld bc, Start
	call ByteFill
	ld a, [rIE]
	ld [BGMapBuffer], a
	xor a
	ld [$ffde], a
	ld [hLCDStatCustom], a
	ret
; 100082

INCBIN "baserom.gbc", $100082, $1000a4 - $100082

Function1000a4: ; 1000a4
	di
	xor a
	ld [$ffc9], a
	ld [$ffe9], a
	xor a
	ld [$ff9e], a
	call Function2ff7
	xor a
	ld [rIF], a
	ld a, [BGMapBuffer]
	ld [rIE], a
	ei
	ret
; 1000ba

Function1000ba: ; 1000ba
.asm_1000ba
	ld hl, $cd23
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [$cd25]
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	ld a, [CreditsTimer]
	call GetFarHalfword
	ld a, [CreditsTimer]
	rst FarCall
	call Function1000e8
	call Function1000fa
	call Function100144
	call Function100163
	ld a, [$cd2b]
	and a
	jr z, .asm_1000ba
	call DelayFrame
	ret
; 1000e8

Function1000e8: ; 1000e8
	ld hl, $cd29
	bit 7, [hl]
	ret z
	callba Function115dd3
	ld hl, $cd29
	set 6, [hl]
	ret
; 1000fa

Function1000fa: ; 1000fa
	ld a, [$c30d]
	and a
	ret z
	ld hl, $cd29
	bit 4, [hl]
	ret z
	ld a, [$cd2b]
	and a
	jr nz, .asm_100117
	callba Function11619d
	ld hl, $cd29
	set 6, [hl]
	ret

.asm_100117
	di
	xor a
	ld [rIF], a
	ld a, [rIE]
	and $13
	ld [rIE], a
	xor a
	ld [$ffc9], a
	ld [$ffe9], a
	ei
	ld a, [InLinkBattle]
	push af
	xor a
	ld [InLinkBattle], a
	ld a, $4
	ld [$c319], a
	callba Function11619d
	ld hl, $cd29
	set 6, [hl]
	pop af
	ld [InLinkBattle], a
	ret
; 100144

Function100144: ; 100144
	ld hl, $cd29
	bit 5, [hl]
	jr z, .asm_100155
	res 5, [hl]
	res 2, [hl]
	res 6, [hl]
	call Function100320
	ret

.asm_100155
	bit 2, [hl]
	ret z
	res 2, [hl]
	res 6, [hl]
	callba Function10402d
	ret
; 100163

Function100163: ; 100163
	ld hl, $cd29
	bit 6, [hl]
	ret z
	res 6, [hl]
	call DelayFrame
	ret
; 10016f

Function10016f: ; 10016f
	ld a, [$cd2b]
	cp $1
	ret z
	cp $2
	ret z
	cp $ff
	jp z, .asm_1001f5
	cp $fe
	jr z, .asm_1001c4
	cp $f5
	jr z, .asm_1001e7
	cp $f6
	jr z, .asm_1001b6
	cp $fa
	jp z, .asm_1001bd
	cp $f7
	jp z, .asm_1001ee
	cp $f4
	jr z, .asm_1001d2
	cp $f3
	jr z, .asm_1001cb
	cp $f1
	jr z, .asm_1001c4
	cp $f2
	jr z, .asm_1001c4
	cp $fc
	jr z, .asm_1001e6
	cp $fb
	jr z, .asm_1001af
	cp $f8
	ret z
	ret

.asm_1001af
	ld a, $d7
	ld de, $0000
	jr .asm_1001d7

.asm_1001b6
	ld a, $d5
	ld de, $0000
	jr .asm_1001d7

.asm_1001bd
	ld a, $d6
	ld de, $0000
	jr .asm_1001d7

.asm_1001c4
	ld a, $d2
	ld de, $0002
	jr .asm_1001d7

.asm_1001cb
	ld a, $d1
	ld de, $0001
	jr .asm_1001d7

.asm_1001d2
	ld a, $d0
	ld de, $0000

.asm_1001d7
	ld [$c300], a
	ld a, d
	ld [$c302], a
	ld a, e
	ld [$c301], a
	call Function10020b
	ret

.asm_1001e6
	ret

.asm_1001e7
	ld de, String10025e
	call Function100232
	ret

.asm_1001ee
	ld de, String10024d
	call Function100232
	ret

.asm_1001f5
	ld a, [$cd2c]
	ld [$c300], a
	ld a, [$cd2d]
	ld [$c302], a
	ld a, [$cd2d]
	ld [$c301], a
	call Function10020b
	ret
; 10020b

Function10020b: ; 10020b
	xor a
	ld [$c303], a
	callba Function8c084
	callba Function106464
	call HideSprites
	call DelayFrame
	ld a, [rSVBK]
	push af
	ld a, $1
	ld [rSVBK], a
	callba Function17f555
	pop af
	ld [rSVBK], a
	ret
; 100232

Function100232: ; 100232
	push de
	callba Function106464
	call Function3f20
	call Function1ad2
	hlcoord 1, 2
	pop de
	call PlaceString
	call Function100320
	call Functiona36
	ret
; 10024d

String10024d: ; 10024d
	db "つうしんを キャンセル しました@"
; 10025e

String10025e: ; 10025e
	db "おともだちと えらんだ へやが", $4e
	db "ちがうようです@"
; 100276

Function100276: ; 100276
	ld a, [$cd2b]
	cp $1
	jr z, .asm_10029f
	cp $2
	jr z, .asm_100296
	cp $f5
	jr z, .asm_1002a5
	cp $f6
	jr z, .asm_1002a5
	cp $f7
	jr z, .asm_100293
	cp $f8
	jr z, .asm_1002b1
	jr .asm_1002c0

.asm_100293
	ld c, $2
	ret

.asm_100296
	callba Script_reloadmappart
	ld c, $4
	ret

.asm_10029f
	call Function1002dc
	ld c, $0
	ret

.asm_1002a5
	callba Script_reloadmappart
	call Function1002ed
	ld c, $3
	ret

.asm_1002b1
	call Function1002c9
	call Function1002dc
	ld de, $424d
	call Function100232
	ld c, $2
	ret

.asm_1002c0
	call Function1002c9
	call Function1002dc
	ld c, $1
	ret
; 1002c9

Function1002c9: ; 1002c9
	ld hl, $cd2a
	bit 0, [hl]
	ret z
	callba Function3f6d0
	callba Function1500c
	ret
; 1002dc

Function1002dc: ; 1002dc
	ld a, $f8
	ld [$ff9f], a
	callba Function15363
	xor a
	ld [$ff9f], a
	call Functione51
	ret
; 1002ed

Function1002ed: ; 1002ed
	callba Function49409
	callba Function96a4
	ld a, $1
	ld [hCGBPalUpdate], a
	call DelayFrame
	ret
; 100301

Function100301: ; 100301
	ld hl, $cd2a
	bit 1, [hl]
	ret z
	callba Function106464
	callba Function10202c
	callba Function115dd3
	call Function100320
	call Functiona36
	ret
; 100320

Function100320: ; 100320
	callba Function104099
	ret
; 100327

INCBIN "baserom.gbc", $100327, $10032e - $100327


Function10032e: ; 10032e
	call Function10034d
	ld e, a
	ret nc
	ld [$cd2b], a
	ret
; 100337

Function100337: ; 100337
	call Function10032e
	ret c
	ld a, [$c821]
	bit 4, a
	jr z, .asm_100345
	ld a, e
	and a
	ret

.asm_100345
	ld a, $f9
	ld e, a
	ld [$cd2b], a
	scf
	ret
; 10034d



Function10034d: ; 10034d
	ld a, [$c821]
	bit 1, a
	jr nz, .asm_10036a
	bit 2, a
	jr nz, .asm_10037e
	bit 3, a
	jr nz, .asm_100366
	bit 0, a
	jr nz, .asm_100364
	ld a, $1
	and a
	ret

.asm_100364
	xor a
	ret

.asm_100366
	ld a, $2
	and a
	ret

.asm_10036a
	ld a, $0
	call Function3e32
	ld [$cd2c], a
	ld a, h
	ld [$cd2d], a
	ld a, l
	ld [$cd2e], a
	ld a, $ff
	scf
	ret

.asm_10037e
	ld a, $fe
	scf
	ret
; 100382

Function100382: ; 100382
	ld a, [$cd27]
	ld hl, $444e
	rst JumpTable
	ret
; 10038a

Function10038a: ; 10038a
	ld hl, $ccb4
	ld a, $2e
	call Function3e32
	ret
; 100393

Function100393: ; 100393
	ld hl, $cc60
	ld a, $3a
	call Function3e32
	ret
; 10039c

Function10039c: ; 10039c
	ld hl, $cc60
	ld de, $d000
	ld bc, $0054
	ld a, $3
	call Function306b
	ret
; 1003ab

INCBIN "baserom.gbc", $1003ab, $1003ba - $1003ab


Function1003ba: ; 1003ba
	ld hl, $ccb4
	ld de, $d080
	ld bc, $0054
	ld a, $3
	call Function306b
	ret
; 1003c9

Function1003c9: ; 1003c9
	ld hl, $d080
	ld de, $ccb4
	ld bc, $0054
	ld a, $3
	call Function306b
	ret
; 1003d8

Function1003d8: ; 1003d8
	ld hl, $ccb4
	ld a, [hli]
	ld c, a
	ld b, $0
	push hl
	add hl, bc
	ld a, [BGMapPalBuffer]
	ld [hl], a
	pop hl
	inc bc
	call Function10043a
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, c
	add $2
	ld [$ccb4], a
	ret
; 1003f5

Function1003f5: ; 1003f5
	ld a, [$cc60]
	sub $3
	ld [$cc60], a
	ld a, [$ccb4]
	sub $3
	ld [$ccb4], a
	ret
; 100406

Function100406: ; 100406
	ld a, [$cc60]
	sub $2
	ld c, a
	ld b, $0
	ld hl, $cc61
	call Function10043a
	add hl, bc
	ld a, [hli]
	cp e
	jr nz, .asm_100426
	ld a, [hld]
	cp d
	jr nz, .asm_100426
	dec hl
	ld a, [BGMapPalBuffer]
	cp [hl]
	jr nz, .asm_10042d
	xor a
	ret

.asm_100426
	ld a, $f4
	ld [$cd2b], a
	jr .asm_100432

.asm_10042d
	ld a, $f3
	ld [$cd2b], a

.asm_100432
	push hl
	ld hl, $cd7c
	inc [hl]
	pop hl
	scf
	ret
; 10043a

Function10043a: ; 10043a
	push hl
	push bc
	ld de, $0000
.asm_10043f
	ld a, [hli]
	add e
	ld e, a
	ld a, d
	adc $0
	ld d, a
	dec bc
	ld a, b
	or c
	jr nz, .asm_10043f
	pop bc
	pop hl
	ret
; 10044e

INCBIN "baserom.gbc", $10044e, $10046a - $10044e


Function10046a: ; 10046a
	ld hl, BGMapPalBuffer
	inc [hl]
	call Function1003d8
	call Function1003ba
	ld a, [$cd27]
	inc a
	ld [$cd27], a
	ret
; 10047c

Function10047c: ; 10047c
	call Function100337
	ret c
	ret z
	cp $2
	jr z, .asm_100487
	jr .asm_10048d

.asm_100487
	ld a, $8
	ld [$cd27], a
	ret

.asm_10048d
	ld a, $2
	ld [$cd27], a
	ret
; 100493

Function100493: ; 100493
	jr .asm_100497

	jr .asm_100497

.asm_100497
	call Function100337
	ret c
	ret z
	ld a, [$cd27]
	inc a
	ld [$cd27], a
	ret
; 1004a4

Function1004a4: ; 1004a4
	call Function100406
	jr c, .asm_1004b8
	call Function1003c9
	call Function1003f5
	ld a, [$cd27]
	set 7, a
	ld [$cd27], a
	ret

.asm_1004b8
	scf
	ret
; 1004ba

Function1004ba: ; 1004ba
	call Function10038a
	and a
	jr nz, .asm_1004c8
	ld a, [$cd27]
	inc a
	ld [$cd27], a
	ret

.asm_1004c8
	ld a, $8
	ld [$cd27], a
	ret
; 1004ce

Function1004ce: ; 1004ce
	call Function100337
	ret c
	ret z
	cp $2
	ret nz
	ld a, [$cd27]
	inc a
	ld [$cd27], a
	ret
; 1004de

Function1004de: ; 1004de
	call Function100393
	ld a, [$cd27]
	inc a
	ld [$cd27], a
	ret
; 1004e9

Function1004e9: ; 1004e9
	call Function10038a
	ld a, [$cd27]
	inc a
	ld [$cd27], a
	ret
; 1004f4

Function1004f4: ; 1004f4
	call Function100337
	ret c
	ret z
	ld a, [$cd27]
	inc a
	ld [$cd27], a
	call Function10039c
	ret
; 100504

Function100504: ; 100504
	push de
	call Function3f20
	call Function1ad2
	pop de
	ld hl, $c4cc
	call PlaceString
	ret
; 100513

INCBIN "baserom.gbc", $100513, $10062d - $100513


Function10062d: ; 10062d
	push bc
	call Function10064e
	pop bc
	ld a, [$cd44]
	cp b
	jr nc, .asm_10063a
	and a
	ret

.asm_10063a
	ld a, $fa
	ld [$cd2b], a
	scf
	ret
; 100641

Function100641: ; 100641
	xor a
	ld [$cd44], a
	ld [$cd45], a
	ld [$cd46], a
	ret
; 10064c

INCBIN "baserom.gbc", $10064c, $10064e - $10064c


Function10064e: ; 10064e
	ld hl, $cd46
	ld a, [hl]
	add c
	cp $3c
	jr c, .asm_100658
	xor a

.asm_100658
	ld [hld], a
	ret c
	ld a, [hl]
	inc a
	cp $3c
	jr c, .asm_100661
	xor a

.asm_100661
	ld [hld], a
	ret c
	inc [hl]
	ret
; 100665

INCBIN "baserom.gbc", $100665, $100675 - $100665

Function100675: ; 100675
	ld hl, $cd2a
	bit 2, [hl]
	set 2, [hl]
	ret nz
	call Function1006d3
	ret
; 100681

Function100681: ; 100681
	push hl
	ld hl, $cd2a
	bit 2, [hl]
	ld hl, $cd2a
	set 2, [hl]
	pop hl
	jr nz, .asm_100694
	push hl
	call Function1006d3
	pop hl

.asm_100694
	ld de, $cd32
	ld a, [de]
	and a
	jr nz, .asm_1006bb
	inc de
	push de
	call .asm_1006b4
	ld de, String1006c2
	call PlaceString
	ld h, b
	ld l, c
	pop de
	inc de
	call .asm_1006b4
	ld de, String1006c6
	call PlaceString
	ret

.asm_1006b4
	ld bc, $8102
	call PrintNum
	ret

.asm_1006bb
	ld de, String1006ca
	call PlaceString
	ret
; 1006c2

String1006c2: ; 1006c2
	db "ふん @"
String1006c6: ; 1006c6
	db "びょう@"
String1006ca: ; 1006ca
	db "1じかんいじょう@"
; 1006d3

Function1006d3: ; 1006d3
	call UpdateTime
	ld de, $cd34
	ld hl, $cd38

Function1006dc: ; 1006dc
	ld a, [hld]
	ld c, a
	ld a, [hSeconds]
	sub c
	jr nc, .asm_1006e5
	add $3c

.asm_1006e5
	ld [de], a
	dec de
	ld a, [hld]
	ld c, a
	ld a, [hMinutes]
	sbc c
	jr nc, .asm_1006f0
	add $3c

.asm_1006f0
	ld [de], a
	dec de
	ld a, [hl]
	ld c, a
	ld a, [hHours]
	sbc c
	jr nc, .asm_1006fb
	add $18

.asm_1006fb
	ld [de], a
	ret
; 1006fd

INCBIN "baserom.gbc", $1006fd, $10079c - $1006fd


Function10079c: ; 10079c
	ld a, [$cd21]
	cp $1
	jr nz, .asm_1007f4
	ld hl, $cd2a
	bit 5, [hl]
	jr nz, .asm_1007f4
	ld hl, $cd2a
	bit 6, [hl]
	jr nz, .asm_1007f4
	ld a, [$cd6a]
	add c
	cp $3c
	jr nc, .asm_1007be
	ld [$cd6a], a
	and a
	ret

.asm_1007be
	sub $3c
	ld [$cd6a], a
	ld d, b
	push de
	call Function1007f6
	pop de
	jr c, .asm_1007e5
	ld a, c
	and a
	jr nz, .asm_1007e5
	ld a, b
	cp $a
	jr nc, .asm_1007e5
	ld a, d
	and a
	ret z
	ld a, [$cd6b]
	cp b
	ret z
	ld a, b
	ld [$cd6b], a
	call Function1008e0
	and a
	ret

.asm_1007e5
	call Function1008e0
	ld hl, $cd2a
	set 4, [hl]
	ld a, $fc
	ld [$cd2b], a
	scf
	ret

.asm_1007f4
	and a
	ret
; 1007f6

Function1007f6: ; 1007f6
	call UpdateTime
	ld hl, $cd74
	ld de, $cd71
	call Function1006dc
	ld a, $4
	call GetSRAMBank
	ld hl, $a802
	call Function100826
	call CloseSRAM
	ld hl, $cd6e
	call Function100826
	ld a, [hHours]
	ld [$cd72], a
	ld a, [hMinutes]
	ld [$cd73], a
	ld a, [hSeconds]
	ld [$cd74], a
	ret
; 100826

Function100826: ; 100826
	ld a, [$cd71]
	add [hl]
	sub $3c
	jr nc, .asm_100830
	add $3c

.asm_100830
	ld [hld], a
	ccf
	ld a, [BGMapBufferPtrs]
	adc [hl]
	sub $3c
	jr nc, .asm_10083c
	add $3c

.asm_10083c
	ld [hld], a
	ld b, a
	ccf
	ld a, [$cd6f]
	adc [hl]
	ld [hl], a
	ld c, a
	ret
; 100846

INCBIN "baserom.gbc", $100846, $1008e0 - $100846


Function1008e0: ; 1008e0
	ld a, [hBGMapMode]
	ld b, a
	ld a, [$ff9e]
	ld c, a
	push bc
	xor a
	ld [hBGMapMode], a
	ld a, $3
	ld [$ff9e], a
	call Function100970
	call Function100902
	call Function100989
	call DelayFrame
	pop bc
	ld a, c
	ld [$ff9e], a
	ld a, b
	ld [hBGMapMode], a
	ret
; 100902

Function100902: ; 100902
	ld hl, $c56b
	ld b, $1
	ld c, $b
	call TextBox
	ld a, [$cd6d]
	ld c, a
	ld a, $a
	sub c
	ld [StringBuffer2], a
	jr z, .asm_10093f
	ld de, .string_100966
	ld hl, $c580
	call PlaceString
	ld hl, $c584
	ld bc, $0102
	ld de, StringBuffer2
	call PrintNum
	ld de, SFX_TWO_PC_BEEPS
	call StartSFX
	callba Function104061
	ld c, $3c
	call DelayFrames
	ret

.asm_10093f
	ld de, .string_10095a
	ld hl, $c580
	call PlaceString
	ld de, SFX_4_NOTE_DITTY
	call StartSFX
	callba Function104061
	ld c, $78
	call DelayFrames
	ret
; 10095a

.string_10095a ; 10095a
	db "たいせん しゅうりょう@"
.string_100966 ; 100966
	db "のこり   ふん", $e7, "@"
; 100970


Function100970: ; 100970
	ld hl, TileMap
	ld de, $dc00
	call Function1009a5
	ld hl, AttrMap
	ld de, $dd68
	call Function1009a5
	call Function1009d2
	call Function1009ae
	ret
; 100989

Function100989: ; 100989
	ld hl, $dc00
	ld de, TileMap
	call Function1009a5
	call Function1009ae
	callba Function104061
	ld hl, $dd68
	ld de, AttrMap
	call Function1009a5
	ret
; 1009a5

Function1009a5: ; 1009a5
	ld bc, $0168
	ld a, $3
	call Function306b
	ret
; 1009ae

Function1009ae: ; 1009ae
	ld a, [rSVBK]
	push af
	ld a, $3
	ld [rSVBK], a
	ld hl, $d800
	ld de, AttrMap
	ld c, $14
	ld b, $12
.asm_1009bf
	push bc
.asm_1009c0
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_1009c0
	ld bc, $000c
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_1009bf
	pop af
	ld [rSVBK], a
	ret
; 1009d2

Function1009d2: ; 1009d2
	ld a, [rSVBK]
	push af
	ld a, $3
	ld [rSVBK], a
	ld a, [rVBK]
	push af
	ld a, $1
	ld [rVBK], a
	ld hl, $d800
	ld de, VBGMap0
	ld bc, $0324
	call Get2bpp
	pop af
	ld [rVBK], a
	pop af
	ld [rSVBK], a
	ret
; 1009f3

Function1009f3: ; 1009f3
	ld a, [hJoyDown]
	and $5
	cp $5
	jr nz, .asm_100a07
	ld hl, $cd2a
	set 4, [hl]
	ld a, $f8
	ld [$cd2b], a
	scf
	ret

.asm_100a07
	xor a
	ret
; 100a09

Function100a09: ; 100a09
	call Function100a2e
	ld [$d431], a
	callba Function4000
	ld a, [InLinkBattle]
	cp $4
	jr nz, .asm_100a2a
	call Function100a87
	call Function100da5
	ld a, $f
	ld hl, $6e27
	rst FarCall
	jr .asm_100a2d

.asm_100a2a
	call Function100a53

.asm_100a2d
	ret
; 100a2e

Function100a2e: ; 100a2e
	ld a, [$d0ec]
	and a
	jr nz, .asm_100a48
	ld a, [CurPlayerMove]
	ld b, $e
	cp $a5
	jr z, .asm_100a4f
	ld b, $d
	cp $ff
	jr z, .asm_100a4f
	ld a, [CurMoveNum]
	jr .asm_100a50

.asm_100a48
	ld a, [CurPartyMon]
	add $4
	jr .asm_100a50

.asm_100a4f
	ld a, b

.asm_100a50
	and $f
	ret
; 100a53

Function100a53: ; 100a53
	ld a, [$d431]
	ld [$cf56], a
	ld a, $ff
	ld [$cf52], a
.asm_100a5e
	call Function8c1
	call DelayFrame
	ld a, [$cf52]
	inc a
	jr z, .asm_100a5e
	ld b, $a
.asm_100a6c
	call DelayFrame
	call Function8c1
	dec b
	jr nz, .asm_100a6c
	ld b, $a
.asm_100a77
	call DelayFrame
	call Function908
	dec b
	jr nz, .asm_100a77
	ld a, [$cf52]
	ld [$d430], a
	ret
; 100a87

Function100a87: ; 100a87
	call Function100acf
	call Function100641
	ld a, $0
	ld [$cd27], a
.asm_100a92
	call DelayFrame
	call GetJoypadPublic
	ld a, $40
	ld hl, $4382
	rst FarCall
	ld c, $1
	ld b, $3
	push bc
	call Function10062d
	pop bc
	jr c, .asm_100ac7
	ld b, $1
	call Function10079c
	jr c, .asm_100ac7
	call Function1009f3
	jr c, .asm_100ac7
	ld a, [$cd2b]
	and a
	jr nz, .asm_100ac7
	ld a, [$cd27]
	bit 7, a
	jr z, .asm_100a92
	call Function100ae7
	jr .asm_100ace

.asm_100ac7
	ld a, $f
	ld [$d430], a
	jr .asm_100ace

.asm_100ace
	ret
; 100acf

Function100acf: ; 100acf
	ld de, $4b0a
	ld hl, $ccb5
	ld a, [$d431]
	ld [hli], a
	ld c, $1
.asm_100adb
	ld a, [de]
	inc de
	ld [hli], a
	inc c
	and a
	jr nz, .asm_100adb
	ld a, c
	ld [$ccb4], a
	ret
; 100ae7

Function100ae7: ; 100ae7
	ld de, $4b0a
	ld hl, $cc62
.asm_100aed
	ld a, [de]
	inc de
	and a
	jr z, .asm_100af8
	cp [hl]
	jr nz, .asm_100aff
	inc hl
	jr .asm_100aed

.asm_100af8
	ld a, [$cc61]
	ld [$d430], a
	ret

.asm_100aff
	ld a, $f
	ld [$d430], a
	ld a, $f1
	ld [$cd2b], a
	ret
; 100b0a

INCBIN "baserom.gbc", $100b0a, $100b12 - $100b0a


Function100b12: ; 100b12
	call Function100dd8
	ret c
	ld hl, $4f2c
	ld a, $9
	ld de, LoadMenuDataHeader
	call FarCall_de
	ld a, $9
	ld [$cf94], a
	ld a, [$d0d2]
	ld [$cf88], a
	call Function100e72
	call Function100b45
	callba Function8e85
	call Function100ed4
	ld a, [$cf88]
	ld [$d0d2], a
	call Function1c07
	ret
; 100b45

Function100b45: ; 100b45
	call Function100b7a
.asm_100b48
	call Function100dd2
	callba Function241ba
	push bc
	callba Function10402d
	call Function100e2d
	pop bc
	jr c, .asm_100b6b
	ld a, [$cfa8]
	and c
	jr z, .asm_100b48
	ld a, $9
	ld hl, $4098
	rst FarCall
	ret

.asm_100b6b
	ld a, [$cfa4]
	ld c, a
	ld a, [$cfa3]
	call SimpleMultiply
	ld [$cf88], a
	and a
	ret
; 100b7a

Function100b7a: ; 100b7a
	ld hl, Function1c66
	ld a, [$cf94]
	rst FarCall
	callba Function24085
	callba MobileTextBorder
	call Function1ad2
	call Function321c
	ld a, $9
	ld hl, $411a
	rst FarCall
	ld hl, $cfa5
	set 7, [hl]
	ret
; 100b9f

Function100b9f: ; 100b9f
	xor a
	ld [$d0e3], a
	ld a, $f
	ld hl, $6786
	rst FarCall
	ret z
	call Function100dd8
	jp c, Function2ec8
	call Function100e72
	call Function100bc2
	push af
	callba Function8e85
	call Function100ed4
	pop af
	ret
; 100bc2

Function100bc2: ; 100bc2
	xor a
	ld [hBGMapMode], a
	call Function100c74
	call Function100c98
	callba MoveInfoBox
.asm_100bd1
	call Function100dd2
	callba Function241ba
	push bc
	callba Function10402d
	call Function100e2d
	pop bc
	jr c, .asm_100c25
	ld a, [$cfa8]
	and c
	bit 6, a
	jp nz, $4bff
	bit 7, a
	jp nz, $4c10
	bit 0, a
	jr nz, .asm_100c30
	bit 1, a
	jr nz, .asm_100c25
	jr .asm_100bd1

	ld a, [$cfa9]
	and a
	jp nz, $4bcb
	ld a, [$d0eb]
	inc a
	ld [$cfa9], a
	jp $4bcb

	ld a, [$cfa9]
	ld b, a
	ld a, [$d0eb]
	inc a
	inc a
	cp b
	jp nz, $4bcb
	ld a, $1
	ld [$cfa9], a
	jp $4bcb

.asm_100c25
	ld a, [$cfa9]
	dec a
	ld [CurMoveNum], a
	ld a, $1
	and a
	ret

.asm_100c30
	ld a, [$cfa9]
	dec a
	ld [CurMoveNum], a
	ld a, [$cfa9]
	dec a
	ld c, a
	ld b, $0
	ld hl, BattleMonPPMove1
	add hl, bc
	ld a, [hl]
	and $3f
	jr z, .asm_100c68
	ld a, [PlayerDisableCount]
	swap a
	and $f
	dec a
	cp c
	jr z, .asm_100c63
	ld a, [$cfa9]
	dec a
	ld c, a
	ld b, $0
	ld hl, BattleMonMove1
	add hl, bc
	ld a, [hl]
	ld [CurPlayerMove], a
	xor a
	ret

.asm_100c63
	ld hl, $4c5b
	jr .asm_100c6b

.asm_100c68
	ld hl, $4c39

.asm_100c6b
	call StdBattleTextBox
	call Function30b4
	jp Function100bc2
; 100c74

Function100c74: ; 100c74
	ld hl, $c540
	ld b, $8
	ld c, $8
	call TextBox
	ld hl, BattleMonMove1
	ld de, $d25e
	ld bc, $0004
	call CopyBytes
	ld a, $28
	ld [MagikarpLength], a
	ld hl, $c56a
	ld a, $20
	call Predef
	ret
; 100c98

Function100c98: ; 100c98
	ld de, $4cad
	call Function1bb1
	ld a, [$d0eb]
	inc a
	ld [$cfa3], a
	ld a, [CurMoveNum]
	inc a
	ld [$cfa9], a
	ret
; 100cad

INCBIN "baserom.gbc", $100cad, $100cb5 - $100cad


Function100cb5: ; 100cb5
	call Function100dd8
	ret c
	ld hl, $cfa5
	set 7, [hl]
	res 6, [hl]
.asm_100cc0
	call Function100dd2
	ld a, $9
	ld hl, $41ba
	rst FarCall
	push bc
	callba Function8cf69
	ld a, $41
	ld hl, $402d
	rst FarCall
	call Function100dfd
	pop bc
	jr c, .asm_100d17
	ld a, [$cfa8]
	and c
	jr z, .asm_100cc0
	call Function1bee
	ld a, [PartyCount]
	inc a
	ld b, a
	ld a, [$cfa9]
	cp b
	jr z, .asm_100d17
	ld [$d0d8], a
	ld a, [$ffa9]
	ld b, a
	bit 1, b
	jr nz, .asm_100d17
	ld a, [$cfa9]
	dec a
	ld [CurPartyMon], a
	ld c, a
	ld b, $0
	ld hl, PartySpecies
	add hl, bc
	ld a, [hl]
	ld [CurPartySpecies], a
	ld de, SFX_READ_TEXT_2
	call StartSFX
	call WaitSFX
	and a
	ret

.asm_100d17
	ld de, SFX_READ_TEXT_2
	call StartSFX
	call WaitSFX
	scf
	ret
; 100d22

Function100d22: ; 100d22
	call Function100dd8
	ret c
	call Function100d67
	ld hl, $cfa5
	set 7, [hl]
	res 6, [hl]
.asm_100d30
	call Function100dd2
	callba Function241ba
	push bc
	callba Function8cf69
	callba Function10402d
	call Function100dfd
	pop bc
	jr c, .asm_100d54
	ld a, [$cfa8]
	and c
	jr nz, .asm_100d56
	jr .asm_100d30

.asm_100d54
	scf
	ret

.asm_100d56
	push af
	ld de, SFX_READ_TEXT_2
	call StartSFX
	pop af
	bit 1, a
	jr z, .asm_100d65
	ret z
	scf
	ret

.asm_100d65
	and a
	ret
; 100d67

Function100d67: ; 100d67
	ld hl, $4d88
	call Function1d3c
	xor a
	ld [hBGMapMode], a
	call Function1cbb
	call Function1ad2
	call Function1c89
	call WaitBGMap
	call Function1c66
	call Function1c10
	ld hl, $cfa5
	set 6, [hl]
	ret
; 100d88

INCBIN "baserom.gbc", $100d88, $100da5 - $100d88


Function100da5: ; 100da5
	ld hl, $cd2a
	res 3, [hl]
	ld hl, $cd29
	res 0, [hl]
	ret
; 100db0

Function100db0: ; 100db0
	ld hl, $cd2a
	bit 3, [hl]
	jr nz, .asm_100dbe
	ld hl, $cd2a
	set 3, [hl]
	scf
	ret

.asm_100dbe
	xor a
	ret
; 100dc0



Function100dc0: ; 100dc0
	ld a, [InLinkBattle]
	cp $4
	jr nz, .asm_100dd0
	ld hl, $cd2a
	bit 3, [hl]
	jr z, .asm_100dd0
	scf
	ret

.asm_100dd0
	xor a
	ret
; 100dd2

Function100dd2: ; 100dd2
	ld a, $1e
	ld [OverworldDelay], a
	ret
; 100dd8

Function100dd8: ; 100dd8
	ld c, $1
	ld b, $3
	ld a, $40
	ld hl, $462d
	rst FarCall
	jr c, .asm_100dfb
	ld c, $3c
	ld b, $1
	call Function10079c
	jr c, .asm_100dfb
	ld a, $40
	ld hl, $432e
	rst FarCall
	ld a, [$cd2b]
	and a
	jr nz, .asm_100dfb
	xor a
	ret

.asm_100dfb
	scf
	ret
; 100dfd

Function100dfd: ; 100dfd
	ld a, [OverworldDelay]
	ld c, a
	ld a, $1e
	sub c
	ld c, a
	ld b, $3
	push bc
	ld a, $40
	ld hl, $462d
	rst FarCall
	pop bc
	jr c, .asm_100e2b
	ld b, $1
	call Function10079c
	jr c, .asm_100e2b
	call Function1009f3
	jr c, .asm_100e2b
	ld a, $40
	ld hl, $432e
	rst FarCall
	ld a, [$cd2b]
	and a
	jr nz, .asm_100e2b
	xor a
	ret

.asm_100e2b
	scf
	ret
; 100e2d

Function100e2d: ; 100e2d
	ld a, [OverworldDelay]
	ld c, a
	ld a, $1e
	sub c
	ld c, a
	ld b, $3
	push bc
	callba Function10062d
	pop bc
	jr c, .asm_100e61
	ld b, $1
	call Function10079c
	jr c, .asm_100e61
	call Function1009f3
	jr c, .asm_100e61
	callba Function10032e
	ld a, [$cd2b]
	and a
	jr nz, .asm_100e61
	call Function100e63
	call Function100e84
	xor a
	ret

.asm_100e61
	scf
	ret
; 100e63

Function100e63: ; 100e63
	ld a, e
	cp $2
	ret nz
	call Function100db0
	ret nc
	ld de, SFX_ELEVATOR_END
	call StartSFX
	ret
; 100e72

Function100e72: ; 100e72
	xor a
	ld hl, $cd29
	bit 0, [hl]
	jr z, .asm_100e7c
	ld a, $a

.asm_100e7c
	ld [$cd67], a
	xor a
	ld [$cd68], a
	ret
; 100e84

Function100e84: ; 100e84
	ld a, [$cd67]
	ld hl, $4e8c
	rst JumpTable
	ret
; 100e8c

INCBIN "baserom.gbc", $100e8c, $100eae - $100e8c


Function100eae: ; 100eae
	scf
	call Function100eca
	jr .asm_100eb8

	and a
	call Function100eca

.asm_100eb8
	ld hl, $cd68
	inc [hl]
	ld a, [hl]
	cp $2
	ret c
	ld [hl], $0
	jr .asm_100ec5

	ret

.asm_100ec5
	ld hl, $cd67
	inc [hl]
	ret
; 100eca

Function100eca: ; 100eca
	ld a, $2
	ld hl, $4e8b
	rst FarCall
	call Function100ed4
	ret
; 100ed4

Function100ed4: ; 100ed4
	callba Function96a4
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 100edf

INCBIN "baserom.gbc", $100edf, $101231 - $100edf

Function101231: ; 101231
	ld d, $2
	ld e, $40
	ld bc, $5297
	call Function100000
	jr .asm_10123d

.asm_10123d
	xor a
	ld [ScriptVar], a
	ld a, c
	ld hl, Table101247
	rst JumpTable
	ret
; 101247

Table101247: ; 101247
	dw Function101251
	dw Function10127d
	dw Function10127c
	dw Function10126c
	dw Function101265
; 101251

Function101251: ; 101251
	call Function1ad2
	call ResetWindow
	ld hl, $61f4
	call Function1021e0
	call Function1020ea
	ret c
	call Function102142
	ret
; 101265

Function101265: ; 101265
	ld hl, $61ef
	call Function1021e0
	ret
; 10126c

Function10126c: ; 10126c
	call Function1ad2
	callba Script_reloadmappart
	ld hl, $61f4
	call Function1021e0
	ret
; 10127c

Function10127c: ; 10127c
	ret
; 10127d

Function10127d: ; 10127d
	ret
; 10127e

Function10127e: ; 10127e
	ld a, [$dc5f]
	and a
	jr z, .asm_101290
	cp $1
	ld c, $27
	jr z, .asm_101292
	cp $2
	ld c, $37
	jr z, .asm_101292

.asm_101290
	ld c, $0

.asm_101292
	ld a, c
	ld [$cd25], a
	ret
; 101297

INCBIN "baserom.gbc", $101297, $1013aa - $101297

Function1013aa: ; 1013aa
	call WhiteBGMap
	call Function1d7d
	call Function2bae
	callba Function106464
	call Function1ad2
	call Function2b5c
	ret
; 1013c0

INCBIN "baserom.gbc", $1013c0, $1013d6 - $1013c0

Function1013d6: ; 1013d6
	callba Function104000
	ret
; 1013dd

INCBIN "baserom.gbc", $1013dd, $10142c - $1013dd

Function10142c: ; 10142c
	ld a, $1
	ld [$c305], a
	callba Function115e18
	ret
; 101438

INCBIN "baserom.gbc", $101438, $101ee4 - $101438

Function101ee4: ; 101ee4
	ld d, $0
	ld hl, $5ef5
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	callba Function100504
	ret
; 101ef5

INCBIN "baserom.gbc", $101ef5, $10202c - $101ef5

Function10202c: ; 10202c
	callba Function115d99
	ld hl, $cd29
	set 7, [hl]
	ld c, $2
	call Function10142c
	ld e, $d
	call Function101ee4
	ld hl, $c4f4
	call Function100681
	ret
; 102048

INCBIN "baserom.gbc", $102048, $1020ea - $102048

Function1020ea: ; 1020ea
	ld hl, $dc41
	bit 4, [hl]
	jr z, .asm_102110
	ld hl, $dc41
	bit 2, [hl]
	jr nz, .asm_102110
	call Function10218d
	ld hl, EnemyMoveAnimation
	bit 4, [hl]
	jr z, .asm_102110
	ld hl, EnemyMoveAnimation
	bit 2, [hl]
	jr nz, .asm_102110
	call Function102112
	jr z, .asm_102110
	and a
	ret

.asm_102110
	scf
	ret
; 102112

Function102112: ; 102112
	ld a, $4
	call GetSRAMBank
	ld hl, $a041
	ld c, $28
.asm_10211c
	push hl
	ld de, PlayerMoveAnimation
	ld b, $1f
.asm_102122
	ld a, [de]
	cp [hl]
	jr nz, .asm_10212f
	inc de
	inc hl
	dec b
	jr nz, .asm_102122
	pop hl
	xor a
	jr .asm_10213c

.asm_10212f
	pop hl
	ld de, $0025
	add hl, de
	dec c
	jr nz, .asm_10211c
	ld a, $1
	and a
	jr .asm_10213c

.asm_10213c
	push af
	call CloseSRAM
	pop af
	ret
; 102142

Function102142: ; 102142
	call Function10218d
	call Function102180
	ld hl, $61d1
	call Function1d4f
	ld de, $0090
	call StartSFX
	call Functiona36
	call Function1c07
	call Function10219f
	ld hl, $61d6
	call Function1d4f
	call Function1dcf
	call Function1c07
	jr c, .asm_10217c
	call Function1021b8
	jr c, .asm_10217c
	call Function10218d
	call Function102180
	ld hl, $61db
	call PrintText

.asm_10217c
	call Function1013d6
	ret
; 102180

Function102180: ; 102180
	ld hl, EnemyMoveEffect
	ld de, StringBuffer2
	ld bc, $000b
	call CopyBytes
	ret
; 10218d

Function10218d: ; 10218d
	ld hl, $dc00
	ld de, EnemyMoveAnimation
	ld bc, $0026
	ld a, $5
	call Function306b
	ld de, EnemyMoveEffect
	ret
; 10219f

Function10219f: ; 10219f
	call FadeToMenu
	call Function10218d
	ld de, EnemyMoveEffect
	callba Function8ac4e
	call Functiona36
	call PlayClickSFX
	call Function1013aa
	ret
; 1021b8

Function1021b8: ; 1021b8
	call FadeToMenu
	call Function10218d
	ld de, PlayerMoveAnimation
	callba Function8ac70
	ld a, c
	ld [StringBuffer1], a
	push af
	call Function1013aa
	pop af
	ret
; 1021d1

INCBIN "baserom.gbc", $1021d1, $1021e0 - $1021d1

Function1021e0: ; 1021e0
	call Function1d4f
	call Functiona36
	call Function1c07
	ret
; 1021ea

INCBIN "baserom.gbc", $1021ea, $10389d - $1021ea


SECTION "bank41",ROMX,BANK[$41]

Function104000: ; 104000
	ld hl, $4006
	jp Function104177
; 104006

INCBIN "baserom.gbc", $104006, $10402d - $104006


Function10402d: ; 10402d
	ld hl, $4033
	jp Function104177
; 104033

INCBIN "baserom.gbc", $104033, $104061 - $104033


Function104061: ; 104061
	ld hl, $4067
	jp Function104177
; 104067

INCBIN "baserom.gbc", $104067, $104099 - $104067

Function104099: ; 104099
	ld hl, Function104061
	ld hl, $40a2
	jp Function104177
; 1040a2

INCBIN "baserom.gbc", $1040a2, $104110 - $1040a2


Function104110: ; 104110
	ld hl, $4116
	jp Function104177
; 104116

INCBIN "baserom.gbc", $104116, $104177 - $104116


Function104177: ; 104177
	ld a, [hBGMapMode]
	push af
	ld a, [$ffde]
	push af
	xor a
	ld [hBGMapMode], a
	ld [$ffde], a
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	ld a, [rVBK]
	push af
	call Function10419c
	pop af
	ld [rVBK], a
	pop af
	ld [rSVBK], a
	pop af
	ld [$ffde], a
	pop af
	ld [hBGMapMode], a
	ret
; 10419c

Function10419c: ; 10419c
	jp [hl]
; 10419d

INCBIN "baserom.gbc", $10419d, $104209 - $10419d


Function104209: ; 104209
	ld b, $7f
	ld a, h
	ld [rHDMA1], a
	ld a, l
	and $f0
	ld [rHDMA2], a
	ld a, d
	and $1f
	ld [rHDMA3], a
	ld a, e
	and $f0
	ld [rHDMA4], a
	ld a, c
	dec c
	or $80
	ld e, a
	ld a, b
	sub c
	ld d, a
.asm_104225
	ld a, [rLY]
	cp d
	jr nc, .asm_104225
	di
.asm_10422b
	ld a, [rSTAT]
	and $3
	jr nz, .asm_10422b
.asm_104231
	ld a, [rSTAT]
	and $3
	jr z, .asm_104231
	ld a, e
	ld [rHDMA5], a
	ld a, [rLY]
	inc c
	ld hl, rLY
.asm_104240
	cp [hl]
	jr z, .asm_104240
	ld a, [hl]
	dec c
	jr nz, .asm_104240
	ld hl, rHDMA5
	res 7, [hl]
	ei
	ret
; 10424e

INCBIN "baserom.gbc", $10424e, $104284 - $10424e


Function104284: ; 104284
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	push bc
	push hl
	ld a, b
	ld l, c
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld b, h
	ld c, l
	ld h, d
	ld l, e
	ld de, $d000
	call FarCopyBytes
	pop hl
	pop bc
	push bc
	call DelayFrame
	pop bc
	ld d, h
	ld e, l
	ld hl, $d000
	call Function104209
	pop af
	ld [rSVBK], a
	ret
; 1042b2

Function1042b2: ; 1042b2
.asm_1042b2
	ld a, c
	cp $10
	jp c, Function1042d6
	jp z, Function1042d6
	push bc
	push hl
	push de
	ld c, $10
	call Function1042d6
	pop de
	ld hl, $0080
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld bc, Start
	add hl, bc
	pop bc
	ld a, c
	sub $10
	ld c, a
	jr .asm_1042b2
; 1042d6

Function1042d6: ; 1042d6
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	push bc
	push hl
	ld a, b
	ld l, c
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	ld c, l
	ld b, h
	ld h, d
	ld l, e
	ld de, $d000
	call Functiondef
	pop hl
	pop bc
	push bc
	call DelayFrame
	pop bc
	ld d, h
	ld e, l
	ld hl, $d000
	call Function104209
	pop af
	ld [rSVBK], a
	ret
; 104303

Function104303: ; 104303
	ld hl, $4309
	jp Function104177
; 104309

INCBIN "baserom.gbc", $104309, $104350 - $104309

INCBIN "gfx/ow/misc.2bpp"


INCBIN "baserom.gbc", $1045b0, $1045d6 - $1045b0


EnterMapConnection: ; 1045d6
; Return carry if a connection has been entered.
	ld a, [$d151]
	and a
	jp z, EnterSouthConnection
	cp 1
	jp z, EnterNorthConnection
	cp 2
	jp z, EnterWestConnection
	cp 3
	jp z, EnterEastConnection
	ret
; 1045ed


EnterWestConnection: ; 1045ed
	ld a, [WestConnectedMapGroup]
	ld [MapGroup], a
	ld a, [WestConnectedMapNumber]
	ld [MapNumber], a
	ld a, [WestConnectionStripXOffset]
	ld [XCoord], a
	ld a, [WestConnectionStripYOffset]
	ld hl, YCoord
	add [hl]
	ld [hl], a
	ld c, a
	ld hl, WestConnectionWindow
	ld a, [hli]
	ld h, [hl]
	ld l, a
	srl c
	jr z, .asm_10461e
	ld a, [WestConnectedMapWidth]
	add 6
	ld e, a
	ld d, 0

.asm_10461a
	add hl, de
	dec c
	jr nz, .asm_10461a

.asm_10461e
	ld a, l
	ld [$d194], a
	ld a, h
	ld [$d195], a
	jp EnteredConnection
; 104629


EnterEastConnection: ; 104629
	ld a, [EastConnectedMapGroup]
	ld [MapGroup], a
	ld a, [EastConnectedMapNumber]
	ld [MapNumber], a
	ld a, [EastConnectionStripXOffset]
	ld [XCoord], a
	ld a, [EastConnectionStripYOffset]
	ld hl, YCoord
	add [hl]
	ld [hl], a
	ld c, a
	ld hl, EastConnectionWindow
	ld a, [hli]
	ld h, [hl]
	ld l, a
	srl c
	jr z, .asm_10465a
	ld a, [EastConnectedMapWidth]
	add 6
	ld e, a
	ld d, 0

.asm_104656
	add hl, de
	dec c
	jr nz, .asm_104656

.asm_10465a
	ld a, l
	ld [$d194], a
	ld a, h
	ld [$d195], a
	jp EnteredConnection
; 104665


EnterNorthConnection: ; 104665
	ld a, [NorthConnectedMapGroup]
	ld [MapGroup], a
	ld a, [NorthConnectedMapNumber]
	ld [MapNumber], a
	ld a, [NorthConnectionStripYOffset]
	ld [YCoord], a
	ld a, [NorthConnectionStripXOffset]
	ld hl, XCoord
	add [hl]
	ld [hl], a
	ld c, a
	ld hl, NorthConnectionWindow
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld b, 0
	srl c
	add hl, bc
	ld a, l
	ld [$d194], a
	ld a, h
	ld [$d195], a
	jp EnteredConnection
; 104696


EnterSouthConnection: ; 104696
	ld a, [SouthConnectedMapGroup]
	ld [MapGroup], a
	ld a, [SouthConnectedMapNumber]
	ld [MapNumber], a
	ld a, [SouthConnectionStripYOffset]
	ld [YCoord], a
	ld a, [SouthConnectionStripXOffset]
	ld hl, XCoord
	add [hl]
	ld [hl], a
	ld c, a
	ld hl, SouthConnectionWindow
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld b, 0
	srl c
	add hl, bc
	ld a, l
	ld [$d194], a
	ld a, h
	ld [$d195], a
	; fallthrough
; 1046c4

EnteredConnection: ; 1046c4
	scf
	ret
; 1046c6


INCBIN "baserom.gbc", $1046c6, $10486d - $1046c6


Function10486d: ; 10486d
	ld hl, OverworldMap
	ld a, [XCoord]
	bit 0, a
	jr nz, .asm_10487d
	srl a
	add $1
	jr .asm_104881

.asm_10487d
	add $1
	srl a

.asm_104881
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [$d19f]
	add $6
	ld c, a
	ld b, $0
	ld a, [YCoord]
	bit 0, a
	jr nz, .asm_10489a
	srl a
	add $1
	jr .asm_10489e

.asm_10489a
	add $1
	srl a

.asm_10489e
	call AddNTimes
	ld a, l
	ld [$d194], a
	ld a, h
	ld [$d195], a
	ld a, [YCoord]
	and $1
	ld [$d196], a
	ld a, [XCoord]
	and $1
	ld [$d197], a
	ret
; 1048ba

INCBIN "baserom.gbc", $1048ba, $1050c8 - $1048ba

Function1050c8: ; 1050c8
	call Function105106
	ld a, [$abe5]
	cp $ff
	jr z, .asm_1050d6
	xor a
	ld [$abe5], a

.asm_1050d6
	jp CloseSRAM
; 1050d9


Function1050d9: ; 1050d9
	call Function105106
	ld hl, $abe2
	ld de, $abe4
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	jp CloseSRAM
; 1050ea

INCBIN "baserom.gbc", $1050ea, $105106 - $1050ea


Function105106: ; 105106
	ld a, $0
	jp GetSRAMBank
; 10510b

INCBIN "baserom.gbc", $10510b, $105258 - $10510b

MysteryGiftGFX:
INCBIN "gfx/misc/mystery_gift.2bpp"

INCBIN "baserom.gbc", $105688, $105930 - $105688

; japanese mystery gift gfx
INCBIN "gfx/misc/mystery_gift_jp.2bpp"


DisplayUsedMoveText: ; 105db0
; battle command 03
	ld hl, UsedMoveText
	call BattleTextBox
	jp WaitBGMap
; 105db9


UsedMoveText: ; 105db9

; this is a stream of text and asm from 105db9 to 105ef6

; print actor name
	text_jump _ActorNameText, BANK(_ActorNameText)
	start_asm

; ????
	ld a, [hBattleTurn]
	and a
	jr nz, .start
	
; append used move list
	ld a, [PlayerMoveAnimation]
	call UpdateUsedMoves
	
.start
; get address for last move
	ld a, $13 ; last move
	call GetBattleVarPair
	ld d, h
	ld e, l
	
; get address for last counter move
	ld a, $11
	call GetBattleVarPair
	
; get move animation (id)
	ld a, $c ; move animation
	call CleanGetBattleVarPair
	ld [$d265], a
	
; check actor ????
	push hl
	callba Function0x34548
	pop hl
	jr nz, .grammar
	
; update last move
	ld a, [$d265]
	ld [hl], a
	ld [de], a
	
.grammar
	call GetMoveGrammar
; $d265 now contains MoveGrammar
	
	
; everything except 'instead' made redundant in localization

; check obedience
	ld a, [AlreadyDisobeyed]
	and a
	ld hl, UsedMove2Text
	ret nz
	
; check move grammar
	ld a, [$d265]
	cp $3
	ld hl, UsedMove2Text
	ret c
	ld hl, UsedMove1Text
	ret
; 105e04

UsedMove1Text: ; 105e04
	text_jump _UsedMove1Text, BANK(_UsedMove1Text)
	start_asm
	jr Function105e10
; 105e0b

UsedMove2Text: ; 105e0b
	text_jump _UsedMove2Text, BANK(_UsedMove2Text)
	start_asm
; 105e10

Function105e10: ; 105e10
; check obedience
	ld a, [AlreadyDisobeyed]
	and a
	jr z, GetMoveNameText
; print "instead,"
	ld hl, UsedInsteadText
	ret
; 105e1a

UsedInsteadText: ; 105e1a
	text_jump _UsedInsteadText, BANK(_UsedInsteadText)
	start_asm
; 105e1f

GetMoveNameText: ; 105e1f
	ld hl, MoveNameText
	ret
; 105e23

MoveNameText: ; 105e23
	text_jump _MoveNameText, BANK(_MoveNameText)
	start_asm
; 105e28

GetUsedMoveTextEnder: ; 105e28
; get start address
	ld hl, .endusedmovetexts
	
; get move id
	ld a, [$d265]
	
; 2-byte pointer
	add a
	
; seek
	push bc
	ld b, $0
	ld c, a
	add hl, bc
	pop bc
	
; get pointer to usedmovetext ender
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret
; 105e39

.endusedmovetexts ; 105e39
	dw EndUsedMove1Text
	dw EndUsedMove2Text
	dw EndUsedMove3Text
	dw EndUsedMove4Text
	dw EndUsedMove5Text
; 105e43

EndUsedMove1Text: ; 105e43
	text_jump _EndUsedMove1Text, BANK(_EndUsedMove1Text)
	db "@"
; 105e48
EndUsedMove2Text: ; 105e48
	text_jump _EndUsedMove2Text, BANK(_EndUsedMove2Text)
	db "@"
; 105e4d
EndUsedMove3Text: ; 105e4d
	text_jump _EndUsedMove3Text, BANK(_EndUsedMove3Text)
	db "@"
; 105e52
EndUsedMove4Text: ; 105e52
	text_jump _EndUsedMove4Text, BANK(_EndUsedMove4Text)
	db "@"
; 105e57
EndUsedMove5Text: ; 105e57
	text_jump _EndUsedMove5Text, BANK(_EndUsedMove5Text)
	db "@"
; 105e5c


GetMoveGrammar: ; 105e5c
; store move grammar type in $d265

	push bc
; c = move id
	ld a, [$d265]
	ld c, a
	ld b, $0
	
; read grammar table
	ld hl, MoveGrammar
.loop
	ld a, [hli]
; end of table?
	cp $ff
	jr z, .end
; match?
	cp c
	jr z, .end
; advance grammar type at $00
	and a
	jr nz, .loop
; next grammar type
	inc b
	jr .loop
	
.end
; $d265 now contains move grammar
	ld a, b
	ld [$d265], a
	
; we're done
	pop bc
	ret
; 105e7a

MoveGrammar: ; 105e7a
; made redundant in localization
; each move is given an identifier for what usedmovetext to use (0-4):

; 0
	db SWORDS_DANCE
	db GROWTH
	db STRENGTH
	db HARDEN
	db MINIMIZE
	db SMOKESCREEN
	db WITHDRAW
	db DEFENSE_CURL
	db EGG_BOMB
	db SMOG
	db BONE_CLUB
	db FLASH
	db SPLASH
	db ACID_ARMOR
	db BONEMERANG
	db REST
	db SHARPEN
	db SUBSTITUTE
	db MIND_READER
	db SNORE
	db PROTECT
	db SPIKES
	db ENDURE
	db ROLLOUT
	db SWAGGER
	db SLEEP_TALK
	db HIDDEN_POWER
	db PSYCH_UP
	db EXTREMESPEED
	db 0 ; end set
	
; 1
	db RECOVER
	db TELEPORT
	db BIDE
	db SELFDESTRUCT
	db AMNESIA
	db FLAIL
	db 0 ; end set
	
; 2
	db MEDITATE
	db AGILITY
	db MIMIC
	db DOUBLE_TEAM
	db BARRAGE
	db TRANSFORM
	db STRUGGLE
	db SCARY_FACE
	db 0 ; end set
	
; 3
	db POUND
	db SCRATCH
	db VICEGRIP
	db WING_ATTACK
	db FLY
	db BIND
	db SLAM
	db HORN_ATTACK
	db WRAP
	db THRASH
	db TAIL_WHIP
	db LEER
	db BITE
	db GROWL
	db ROAR
	db SING
	db PECK
	db ABSORB
	db STRING_SHOT
	db EARTHQUAKE
	db FISSURE
	db DIG
	db TOXIC
	db SCREECH
	db METRONOME
	db LICK
	db CLAMP
	db CONSTRICT
	db POISON_GAS
	db BUBBLE
	db SLASH
	db SPIDER_WEB
	db NIGHTMARE
	db CURSE
	db FORESIGHT
	db CHARM
	db ATTRACT
	db ROCK_SMASH
	db 0 ; end set
	
; all other moves = 4
	db $ff ; end
; 105ed0


UpdateUsedMoves: ; 105ed0
; append move a to PlayerUsedMoves unless it has already been used

	push bc
; start of list
	ld hl, PlayerUsedMoves
; get move id
	ld b, a
; loop count
	ld c, NUM_MOVES
	
.loop
; get move from the list
	ld a, [hli]
; not used yet?
	and a
	jr z, .add
; already used?
	cp b
	jr z, .quit
; next byte
	dec c
	jr nz, .loop
	
; if the list is full and the move hasn't already been used
; shift the list back one byte, deleting the first move used
; this can occur with struggle or a new learned move
	ld hl, PlayerUsedMoves + 1
; 1 = 2
	ld a, [hld]
	ld [hli], a
; 2 = 3
	inc hl
	ld a, [hld]
	ld [hli], a
; 3 = 4
	inc hl
	ld a, [hld]
	ld [hl], a
; 4 = new move
	ld a, b
	ld [PlayerUsedMoves + 3], a
	jr .quit
	
.add
; go back to the byte we just inced from
	dec hl
; add the new move
	ld [hl], b
	
.quit
; list updated
	pop bc
	ret
; 105ef6



HallOfFame2: ; 0x105ef6
	ret

INCBIN "baserom.gbc", $105ef7, $106008 - $105ef7


Function106008: ; 106008
	ret
; 106009

INCBIN "baserom.gbc", $106009, $106050 - $106009


Function106050: ; 106050
	ret
; 106051

INCBIN "baserom.gbc", $106051, $10605d - $106051


Function10605d: ; 10605d
	ret
; 10605e

INCBIN "baserom.gbc", $10605e, $10606a - $10605e


Function10606a: ; 10606a
	ret
; 10606b

INCBIN "baserom.gbc", $10606b, $106078 - $10606b

HallOfFame1: ; 0x106078
	ret

INCBIN "baserom.gbc", $106079, $106086 - $106079


Function106086: ; 106086
	ret
; 106087

INCBIN "baserom.gbc", $106087, $106094 - $106087


Function106094: ; 106094
	ret
; 106095

INCBIN "baserom.gbc", $106095, $1060b5 - $106095

Function1060b5: ; 1060b5
	ret
; 1060b6

INCBIN "baserom.gbc", $1060b6, $1060bb - $1060b6

Function1060bb: ; 1060bb
; commented out
	ret
; 1060bc

INCBIN "baserom.gbc", $1060bc, $1060c1 - $1060bc

Function1060c1: ; 1060c1
	ret
; 1060c2

INCBIN "baserom.gbc", $1060c2, $1060d3 - $1060c2


Function1060d3: ; 1060d3
	ret
; 1060d4

INCBIN "baserom.gbc", $1060d4, $1060df - $1060d4


Function1060df: ; 1060df
	ret
; 1060e0

INCBIN "baserom.gbc", $1060e0, $1060fb - $1060e0


Function1060fb: ; 1060fb
	ret
; 1060fc

INCBIN "baserom.gbc", $1060fc, $106101 - $1060fc


Function106101: ; 106101
	ret
; 106102

INCBIN "baserom.gbc", $106102, $106107 - $106102


Function106107: ; 106107
	ret
; 106108

INCBIN "baserom.gbc", $106108, $106187 - $106108


Function106187: ; 106187
	ld a, $1
	call GetSRAMBank
	ld a, [$be3c]
	push af
	ld a, $1
	call GetSRAMBank
	pop af
	ld [$be44], a
	call CloseSRAM
	ret
; 10619d

INCBIN "baserom.gbc", $10619d, $1061ef - $10619d


Function1061ef: ; 1061ef
	push bc
	xor a
	ld [hProduct], a
	ld [hMultiplicand], a
	ld [$ffb5], a
	ld a, b
	and $f
	cp $1
	jr z, .asm_106212
	cp $2
	jr z, .asm_10620e
	cp $3
	jr z, .asm_10620a
	ld a, [de]
	ld [hProduct], a
	inc de

.asm_10620a
	ld a, [de]
	ld [hMultiplicand], a
	inc de

.asm_10620e
	ld a, [de]
	ld [$ffb5], a
	inc de

.asm_106212
	ld a, [de]
	ld [$ffb6], a
	inc de
	push de
	xor a
	ld [$ffbb], a
	ld a, b
	ld [$ffbc], a
	ld a, c
	cp $2
	jr z, .asm_10626a
	ld de, $62ae
	cp $3
	jr z, .asm_106256
	ld de, $62aa
	cp $4
	jr z, .asm_106256
	ld de, $62a6
	cp $5
	jr z, .asm_106256
	ld de, $62a2
	cp $6
	jr z, .asm_106256
	ld de, $629e
	cp $7
	jr z, .asm_106256
	ld de, $629a
	cp $8
	jr z, .asm_106256
	ld de, $6296
	cp $9
	jr z, .asm_106256
	ld de, $6292

.asm_106256
	inc de
	inc de
	inc de
	dec a
	dec a
.asm_10625b
	push af
	call Function1062b2
	call Function1062ff
	inc de
	inc de
	inc de
	inc de
	pop af
	dec a
	jr nz, .asm_10625b

.asm_10626a
	ld c, $0
	ld a, [$ffb6]
.asm_10626e
	cp $a
	jr c, .asm_106277
	sub $a
	inc c
	jr .asm_10626e

.asm_106277
	ld b, a
	ld a, [$ffbb]
	or c
	ld [$ffbb], a
	jr nz, .asm_106284
	call $62f7
	jr .asm_106288

.asm_106284
	ld a, $f6
	add c
	ld [hl], a

.asm_106288
	call Function1062ff
	ld a, $f6
	add b
	ld [hli], a
	pop de
	pop bc
	ret
; 106292

INCBIN "baserom.gbc", $106292, $1062b2 - $106292


Function1062b2: ; 1062b2
	ld c, $0
.asm_1062b4
	ld a, [de]
	dec de
	ld b, a
	ld a, [$ffb6]
	sub b
	ld [$ffba], a
	ld a, [de]
	dec de
	ld b, a
	ld a, [$ffb5]
	sbc b
	ld [$ffb9], a
	ld a, [de]
	dec de
	ld b, a
	ld a, [hMultiplicand]
	sbc b
	ld [hMathBuffer], a
	ld a, [de]
	inc de
	inc de
	inc de
	ld b, a
	ld a, [hProduct]
	sbc b
	ld [hMultiplier], a
	jr c, .asm_1062eb
	ld a, [hMultiplier]
	ld [hProduct], a
	ld a, [hMathBuffer]
	ld [hMultiplicand], a
	ld a, [$ffb9]
	ld [$ffb5], a
	ld a, [$ffba]
	ld [$ffb6], a
	inc c
	jr .asm_1062b4

.asm_1062eb
	ld a, [$ffbb]
	or c
	jr z, .asm_1062f7
	ld a, $f6
	add c
	ld [hl], a
	ld [$ffbb], a
	ret

.asm_1062f7
	ld a, [$ffbc]
	bit 7, a
	ret z
	ld [hl], $f6
	ret
; 1062ff

Function1062ff: ; 1062ff
	ld a, [$ffbc]
	bit 7, a
	jr nz, .asm_10630d
	bit 6, a
	jr z, .asm_10630d
	ld a, [$ffbb]
	and a
	ret z

.asm_10630d
	inc hl
	ret
; 10630f

INCBIN "baserom.gbc", $10630f, $106462 - $10630f

Function106462: ; 106462
	ret
; 106463

INCBIN "baserom.gbc", $106463, $106464 - $106463

Function106464: ; 106464
	ld de, $5214
	ld hl, $9600
	ld bc, $3e01
	call Get2bpp
	ld de, $5424
	ld hl, $9610
	ld bc, $3e01
	call Get2bpp
	ld de, $6514
	ld hl, $9620
	ld c, $9
	ld b, $41
	call Get2bpp
	ld de, $40b0
	ld hl, $96b0
	ld b, $f
	call Get2bpp
	callba Functionfb4cc
	ret
; 10649b

INCBIN "baserom.gbc", $10649b, $106594 - $10649b


Function106594: ; 106594
	ld de, $65ad
	ld hl, VTiles1
	ld bc, $4180
	call Get2bpp
	ld de, $6dad
	ld hl, $97f0
	ld bc, $4101
	call Get2bpp
	ret
; 1065ad

INCBIN "baserom.gbc", $1065ad, $106dbc - $1065ad


SECTION "bank42",ROMX,BANK[$42]

INCBIN "baserom.gbc", $108000, $109407 - $108000

IntroLogoGFX: ; 109407
INCBIN "gfx/intro/logo.lz"
; 10983f

INCBIN "baserom.gbc", $10983f, $109847 - $10983f


Function109847: ; 109847
	bit 6, b
	ld a, $0
	jr z, .asm_10984f
	ld a, $40

.asm_10984f
	ld [$cf63], a
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	call WhiteBGMap
	call ClearTileMap
	call ClearSprites
	ld hl, $ca00
	ld c, $80
	ld de, rJOYP
.asm_10986a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	dec c
	jr nz, .asm_10986a
	ld de, $5c24
	ld hl, $9200
	ld bc, $4209
	call Request2bpp
	ld de, $4000
	ld hl, $9600
	ld bc, $391d
	call Request2bpp
	ld de, $7d2e
	ld hl, $9400
	ld bc, $3210
	call Request2bpp
	ld a, $ff
	ld [$cf64], a
	xor a
	ld [$cf65], a
	call $5bca
	ld e, l
	ld d, h
	ld hl, VTiles2
	ld bc, $4210
	call Request2bpp
	call $5a95
	xor a
	ld [$cf66], a
	ld hl, $d100
	ld bc, Start
	xor a
	call ByteFill
	ld a, $43
	ld [hLCDStatCustom], a
	call GetCreditsPalette
	call Function32f9
	ld a, [$ff9e]
	push af
	ld a, $5
	ld [$ff9e], a
	ld a, $1
	ld [$ffaa], a
	xor a
	ld [hBGMapMode], a
	ld [CreditsPos], a
	ld [$cd21], a
	ld [CreditsTimer], a
.asm_1098de
	call Function109908
	call Function1098fd
	jr nz, .asm_1098ee
	call Function109926
	call DelayFrame
	jr .asm_1098de

.asm_1098ee
	call WhiteBGMap
	xor a
	ld [hLCDStatCustom], a
	ld [hBGMapAddress], a
	pop af
	ld [$ff9e], a
	pop af
	ld [rSVBK], a
	ret
; 1098fd

Function1098fd: ; 1098fd
	ld a, [hJoypadDown]
	and $1
	ret z
	ld a, [$cf63]
	bit 7, a
	ret
; 109908

Function109908: ; 109908
	ld a, [hJoypadDown]
	and $2
	ret z
	ld a, [$cf63]
	bit 6, a
	ret z
	ld hl, CreditsPos
	ld a, [hli]
	cp $d
	jr nc, .asm_10991e
	ld a, [hli]
	and a
	ret z

.asm_10991e
	ld hl, CreditsTimer
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret
; 109926

Function109926: ; 109926
	ld a, [$cf63]
	and $f
	ld e, a
	ld d, $0
	ld hl, $5937
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 109937

INCBIN "baserom.gbc", $109937, $1099aa - $109937

; Credits
INCLUDE "engine/credits.asm"


SECTION "bank43",ROMX,BANK[$43]

INCBIN "baserom.gbc", $10c000, $10ed67 - $10c000

_TitleScreen: ; 10ed67

	call WhiteBGMap
	call ClearSprites
	call ClearTileMap
	
; Turn BG Map update off
	xor a
	ld [hBGMapMode], a
	
; Reset timing variables
	ld hl, $cf63
	ld [hli], a ; cf63 ; Scene?
	ld [hli], a ; cf64
	ld [hli], a ; cf65 ; Timer lo
	ld [hl], a  ; cf66 ; Timer hi
	
; Turn LCD off
	call DisableLCD
	
	
; VRAM bank 1
	ld a, 1
	ld [rVBK], a
	
	
; Decompress running Suicune gfx
	ld hl, TitleSuicuneGFX
	ld de, VTiles1
	call Decompress
	
	
; Clear screen palettes
	ld hl, VBGMap0
	ld bc, $0280
	xor a
	call ByteFill
	

; Fill tile palettes:

; BG Map 1:

; line 0 (copyright)
	ld hl, VBGMap1
	ld bc, $0020 ; one row
	ld a, 7 ; palette
	call ByteFill


; BG Map 0:

; Apply logo gradient:

; lines 3-4
	ld hl, $9860 ; (0,3)
	ld bc, $0040 ; 2 rows
	ld a, 2
	call ByteFill
; line 5
	ld hl, $98a0 ; (0,5)
	ld bc, $0020 ; 1 row
	ld a, 3
	call ByteFill
; line 6
	ld hl, $98c0 ; (0,6)
	ld bc, $0020 ; 1 row
	ld a, 4
	call ByteFill
; line 7
	ld hl, $98e0 ; (0,7)
	ld bc, $0020 ; 1 row
	ld a, 5
	call ByteFill
; lines 8-9
	ld hl, $9900 ; (0,8)
	ld bc, $0040 ; 2 rows
	ld a, 6
	call ByteFill
	

; 'CRYSTAL VERSION'
	ld hl, $9925 ; (5,9)
	ld bc, $000b ; length of version text
	ld a, 1
	call ByteFill
	
; Suicune gfx
	ld hl, $9980 ; (0,12)
	ld bc, $00c0 ; the rest of the screen
	ld a, 8
	call ByteFill
	
	
; Back to VRAM bank 0
	ld a, $0
	ld [rVBK], a
	
	
; Decompress logo
	ld hl, TitleLogoGFX
	ld de, VTiles1
	call Decompress
	
; Decompress background crystal
	ld hl, TitleCrystalGFX
	ld de, VTiles0
	call Decompress
	
	
; Clear screen tiles
	ld hl, VBGMap0
	ld bc, $0800
	ld a, $7f
	call ByteFill
	
; Draw Pokemon logo
	ld hl, $c4dc ; TileMap(0,3)
	ld bc, $0714 ; 20x7
	ld d, $80
	ld e, $14
	call DrawGraphic
	
; Draw copyright text
	ld hl, $9c03 ; BGMap1(3,0)
	ld bc, $010d ; 13x1
	ld d, $c
	ld e, $10
	call DrawGraphic
	
; Initialize running Suicune?
	ld d, $0
	call Function10eed2
	
; Initialize background crystal
	call Function10ef06
	
; Save WRAM bank
	ld a, [rSVBK]
	push af
; WRAM bank 5
	ld a, 5
	ld [rSVBK], a
	
; Update palette colors
	ld hl, TitleScreenPalettes
	ld de, $d000
	ld bc, $0080
	call CopyBytes
	
	ld hl, TitleScreenPalettes
	ld de, $d080
	ld bc, $0080
	call CopyBytes
	
; Restore WRAM bank
	pop af
	ld [rSVBK], a
	
	
; LY/SCX trickery starts here
	
	ld a, [rSVBK]
	push af
	ld a, 5 ; BANK(LYOverrides)
	ld [rSVBK], a
	
; Make alternating lines come in from opposite sides

; ( This part is actually totally pointless, you can't
;   see anything until these values are overwritten!  )

	ld b, 80 / 2 ; alternate for 80 lines
	ld hl, LYOverrides
.loop
; $00 is the middle position
	ld [hl], +112 ; coming from the left
	inc hl
	ld [hl], -112 ; coming from the right
	inc hl
	dec b
	jr nz, .loop
	
; Make sure the rest of the buffer is empty
	ld hl, LYOverrides + 80
	xor a
	ld bc, LYOverridesEnd - (LYOverrides + 80)
	call ByteFill
	
; Let LCD Stat know we're messing around with SCX
	ld a, rSCX - rJOYP
	ld [hLCDStatCustom], a
	
	pop af
	ld [rSVBK], a
	
	
; Reset audio
	call ChannelsOff
	call EnableLCD
	
; Set sprite size to 8x16
	ld a, [rLCDC]
	set 2, a
	ld [rLCDC], a
	
	ld a, +112
	ld [hSCX], a
	ld a, 8
	ld [hSCY], a
	ld a, 7
	ld [hWX], a
	ld a, -112
	ld [hWY], a
	
	ld a, $1
	ld [hCGBPalUpdate], a
	
; Update BG Map 0 (bank 0)
	ld [hBGMapMode], a
	
	xor a
	ld [DefaultFlypoint], a
	
; Play starting sound effect
	call SFXChannelsOff
	ld de, SFX_TITLE_SCREEN_ENTRANCE
	call StartSFX
	
	ret
; 10eea7

Function10eea7: ; 10eea7
	ld hl, DefaultFlypoint
	ld a, [hl]
	ld c, a
	inc [hl]
	and $7
	ret nz
	ld a, c
	and $18
	sla a
	swap a
	ld e, a
	ld d, $0
	ld hl, $6ece
	add hl, de
	ld d, [hl]
	xor a
	ld [hBGMapMode], a
	call Function10eed2
	ld a, $1
	ld [hBGMapMode], a
	ld a, $3
	ld [hBGMapThird], a
	ret
; 10eece

INCBIN "baserom.gbc", $10eece, $10eed2 - $10eece


Function10eed2: ; 10eed2
	ld hl, $c596
	ld b, $6
.asm_10eed7
	ld c, $8
.asm_10eed9
	ld a, d
	ld [hli], a
	inc d
	dec c
	jr nz, .asm_10eed9
	ld a, $c
	add l
	ld l, a
	ld a, $0
	adc h
	ld h, a
	ld a, $8
	add d
	ld d, a
	dec b
	jr nz, .asm_10eed7
	ret
; 10eeef

Function10eeef: ; 10eeef
.asm_10eeef
	push de
	push bc
	push hl
.asm_10eef2
	ld a, d
	ld [hli], a
	inc d
	dec c
	jr nz, .asm_10eef2
	pop hl
	ld bc, $0014
	add hl, bc
	pop bc
	pop de
	ld a, e
	add d
	ld d, a
	dec b
	jr nz, .asm_10eeef
	ret
; 10ef06

Function10ef06: ; 10ef06
	ld hl, Sprites
	ld d, $de
	ld e, $0
	ld c, $5
.asm_10ef0f
	push bc
	call Function10ef1c
	pop bc
	ld a, $10
	add d
	ld d, a
	dec c
	jr nz, .asm_10ef0f
	ret
; 10ef1c

Function10ef1c: ; 10ef1c
	ld c, $6
	ld b, $40
.asm_10ef20
	ld a, d
	ld [hli], a
	ld a, b
	ld [hli], a
	add $8
	ld b, a
	ld a, e
	ld [hli], a
	inc e
	inc e
	ld a, $80
	ld [hli], a
	dec c
	jr nz, .asm_10ef20
	ret
; 10ef32


AnimateTitleCrystal: ; 10ef32
; Move the title screen crystal downward until it's fully visible

; Stop at y=6
; y is really from the bottom of the sprite, which is two tiles high
	ld hl, Sprites
	ld a, [hl]
	cp 6 + 16
	ret z
	
; Move all 30 parts of the crystal down by 2
	ld c, 30
.loop
	ld a, [hl]
	add 2
	ld [hli], a
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .loop
	
	ret
; 10ef46

TitleSuicuneGFX: ; 10ef46
INCBIN "gfx/title/suicune.lz"
; 10f31b

INCBIN "baserom.gbc", $10f31b, $10f326 - $10f31b

TitleLogoGFX: ; 10f326
INCBIN "gfx/title/logo.lz"
; 10fced

INCBIN "baserom.gbc", $10fced, $10fcee - $10fced

TitleCrystalGFX: ; 10fcee
INCBIN "gfx/title/crystal.lz"
; 10fed7

INCBIN "baserom.gbc", $10fed7, $10fede - $10fed7

TitleScreenPalettes:
; BG
	RGB 00, 00, 00
	RGB 19, 00, 00
	RGB 15, 08, 31
	RGB 15, 08, 31
	
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 15, 16, 31
	RGB 31, 01, 13
	
	RGB 00, 00, 00
	RGB 07, 07, 07
	RGB 31, 31, 31
	RGB 02, 03, 30
	
	RGB 00, 00, 00
	RGB 13, 13, 13
	RGB 31, 31, 18
	RGB 02, 03, 30
	
	RGB 00, 00, 00
	RGB 19, 19, 19
	RGB 29, 28, 12
	RGB 02, 03, 30
	
	RGB 00, 00, 00
	RGB 25, 25, 25
	RGB 28, 25, 06
	RGB 02, 03, 30
	
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 26, 21, 00
	RGB 02, 03, 30
	
	RGB 00, 00, 00
	RGB 11, 11, 19
	RGB 31, 31, 31
	RGB 00, 00, 00
	
; OBJ
	RGB 00, 00, 00
	RGB 10, 00, 15
	RGB 17, 05, 22
	RGB 19, 09, 31
	
	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	
	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	
	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	
	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	
	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	
	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	
	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00

SECTION "bank44",ROMX,BANK[$44]

INCBIN "baserom.gbc", $110000, $110fad - $110000

URIPrefix: ; 0x110fad
	ascii "http://"
HTTPDownloadURL: ; 0x110fb4
	ascii "gameboy.datacenter.ne.jp/cgb/download"
HTTPUploadURL: ; 0x110fd9
	ascii "gameboy.datacenter.ne.jp/cgb/upload"
HTTPUtilityURL: ; 0x110ffc
	ascii "gameboy.datacenter.ne.jp/cgb/utility"
HTTPRankingURL: ; 0x111020
	ascii "gameboy.datacenter.ne.jp/cgb/ranking"

INCBIN "baserom.gbc", $111044, $113f84 - $111044

SECTION "bank45",ROMX,BANK[$45]

INCBIN "baserom.gbc", $114000, $114243 - $114000

Function114243: ; 114243
	ld a, $a
	ld [$0000], a
	ld a, [$ff8c]
	push af
	push de
	ld a, [$dc02]
	add a
	ld e, a
	ld d, $0
	ld hl, $4165
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	jp [hl]
; 11425c

INCBIN "baserom.gbc", $11425c, $115d99 - $11425c

Function115d99: ; 115d99
	ld de, $601a
	ld hl, $8600
	ld bc, $4514
	call Get2bpp
	xor a
	ld [$c305], a
	ld [$c306], a
	ld [$c309], a
	ld [$c30a], a
	ld [$c30b], a
	ld [$c30c], a
	ld a, $10
	ld [$c307], a
	ld a, $18
	ld [$c308], a
	ret
; 115dc3

INCBIN "baserom.gbc", $115dc3, $115dd3 - $115dc3

Function115dd3: ; 115dd3
	ld a, [$c305]
	and a
	ret z
	ld a, $a0
	ld hl, $c47c
	ld bc, $0020
	call ByteFill
	call Function115e22
	ld a, [$c309]
	sla a
	ld c, a
	ld b, $0
	ld hl, $5e86
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	push de
	pop hl
	ld de, $c47c
	ld a, [$c307]
	ld c, a
	ld a, [$c308]
	ld b, a
	ld a, [hli]
.asm_115e04
	push af
	ld a, [hli]
	add b
	ld [de], a
	inc de
	ld a, [hli]
	add c
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	pop af
	dec a
	jr nz, .asm_115e04
	ret
; 115e18

Function115e18: ; 115e18
	ld a, c
	ld [$c30a], a
	xor a
	ld [$c30b], a
	jr Function115e2b
; 115e22

Function115e22: ; 115e22
	ld hl, $c30c
	dec [hl]
	ret nz
	ld hl, $c30b
	inc [hl]

Function115e2b: ; 115e2b
	ld a, [$c30a]
	sla a
	ld c, a
	ld b, $0
	ld hl, $5e59
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push de
	pop hl
	ld a, [$c30b]
	sla a
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hli]
	cp $ff
	jr nz, .asm_115e51
	xor a
	ld [$c30b], a
	jr Function115e2b

.asm_115e51
	ld [$c309], a
	ld a, [hl]
	ld [$c30c], a
	ret
; 115e59

INCBIN "baserom.gbc", $115e59, $11615a - $115e59

Function11615a: ; 11615a
	xor a
	ld [$c30d], a
	ld [$c319], a
	ld [$c310], a
	ld [$c311], a
	ld [$c312], a
	ld [$c313], a
	ld [$c314], a
	ld [$c315], a
	ld [$c318], a
	ld [$c3f6], a
	ld [$c3f8], a
	ld [$c3f2], a
	ld [$c3f4], a
	ld a, $24
	ld [$c3f5], a
	ld a, $7
	ld [$c3f7], a
	ld a, $b0
	ld [$c30e], a
	ld [$c3f1], a
	ld a, $48
	ld [$c30f], a
	ld [$c3f3], a
	ret
; 11619d

Function11619d: ; 11619d
	ld a, [$c30d]
	and a
	ret z
	ld a, [$c319]
	cp $2
	jr c, .asm_1161b4
	ld a, $a0
	ld hl, Sprites
	ld bc, $0064
	call ByteFill

.asm_1161b4
	call Function1161b8
	ret
; 1161b8

Function1161b8: ; 1161b8
	ld a, [$c319]
	ld e, a
	ld d, $0
	ld hl, $61c7
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 1161c7

INCBIN "baserom.gbc", $1161c7, $117a7f - $1161c7


; everything from here to the end of the bank is related to the
; Mobile Stadium option from the continue/newgame menu.
; XXX better function names
MobileStudium: ; 0x117a7f
	ld a, [$ffaa]
	push af
	ld a, $1
	ld [$ffaa], a
	call Function117a8d
	pop af
	ld [$ffaa], a
	ret
; 0x117a8d

Function117a8d: ; 0x117a8d
	call Function117a94
	call Function117acd
	ret
; 0x117a94

Function117a94: ; 0x117a94
	xor a
	ld [$cf63], a
	ld [$cf64], a
	ld [$cf65], a
	ld [$cf66], a
	call WhiteBGMap
	call ClearSprites
	ld a, $5c
	ld hl, $6e78
	rst FarCall
	ld a, $41
	ld hl, $4000
	rst FarCall
	ret
; 0x117ab4

Function117ab4: ; 0x117ab4
	call WhiteBGMap
	call ClearSprites
	ld a, $5c
	ld hl, $6e78
	rst FarCall
	ld a, $5c
	ld hl, $6eb9
	rst FarCall
	ld a, $41
	ld hl, $4061
	rst FarCall
	ret
; 0x117acd

Function117acd: ; 0x117acd
	call Functiona57
	ld a, [$cf63]
	bit 7, a
	jr nz, .asm_117ae2 ; 0x117ad5 $b
	call Function117ae9
	ld a, $41
	ld hl, $4000
	rst FarCall
	jr Function117acd
.asm_117ae2
	call WhiteBGMap
	call ClearSprites
	ret

Function117ae9: ; 0x117ae9
	ld a, [$cf63]
	ld e, a
	ld d, $0
	ld hl, Pointers117af8
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

Pointers117af8: ; 0x117af8
	dw Function117b06
	dw Function117b14
	dw Function117b28
	dw Function117b31
	dw Function117b4f
	dw Function117bb6
	dw Function117c4a

Function117b06:
	ld a, $5c
	ld hl, $6eb9
	rst FarCall
	ld a, $10
	ld [$cf64], a
	jp Function117cdd

Function117b14:
	ld hl, $cf64
	dec [hl]
	ret nz
	ld hl, Data117cbc
	call LoadMenuDataHeader
	call Function1cbb
	call Function1cfd
	jp Function117cdd

Function117b28:
	ld hl, MobileStadiumEntryText
	call PrintText
	jp Function117cdd

Function117b31:
	ld hl, Data117cc4
	call LoadMenuDataHeader
	call Function1cbb
	call Function1cfd
	ld hl, $c550
	ld de, YesNo117ccc
	call PlaceString
	ld hl, $c54f
	ld a, "▶"
	ld [hl], a
	jp Function117cdd

Function117b4f:
	ld a, [hJoyPressed]
	cp $2
	jr z, .asm_117ba4 ; 0x117b53 $4f
	cp $1
	jr z, .asm_117b8c ; 0x117b57 $33
	cp $80
	jr z, .asm_117b76 ; 0x117b5b $19
	cp $40
	ret nz
	ld a, [$cf64]
	and a
	ret z
	dec a
	ld [$cf64], a
	ld hl, $c54f
	ld a, "▶"
	ld [hl], a
	ld hl, $c577
	ld a, " "
	ld [hl], a
	ret
.asm_117b76
	ld a, [$cf64]
	and a
	ret nz
	inc a
	ld [$cf64], a
	ld hl, $c54f
	ld a, " "
	ld [hl], a
	ld hl, $c577
	ld a, "▶"
	ld [hl], a
	ret
.asm_117b8c
	call PlayClickSFX
	ld a, [$cf64]
	and a
	jr nz, .asm_117ba4 ; 0x117b93 $f
	call Function1c07
	call Function1c07
	ld a, $41
	ld hl, $4061
	rst FarCall
	jp Function117cdd
.asm_117ba4
	call Function1c07
	call Function1c07
	ld a, $41
	ld hl, $4061
	rst FarCall
	ld a, $80
	ld [$cf63], a
	ret

Function117bb6:
	call Function117c89
	ld a, $1
	ld [hBGMapMode], a
	ld a, $46
	ld hl, $4284
	rst FarCall
	call ClearSprites
	ld a, [$c300]
	and a
	jr z, .asm_117be7 ; 0x117bca $1b
	cp $a
	jr z, .asm_117be1 ; 0x117bce $11
.asm_117bd0
	ld a, $2
	ld [$c303], a
	ld a, $5f
	ld hl, $7555
	rst FarCall
	ld a, $80
	ld [$cf63], a
	ret
.asm_117be1
	ld a, $80
	ld [$cf63], a
	ret
.asm_117be7
	ld a, [rSVBK]
	push af
	ld a, $3
	ld [rSVBK], a
	ld a, [$cd89]
	and $1
	jr nz, .asm_117c16 ; 0x117bf3 $21
	ld a, [$d000]
	cp $fe
	jr nz, .asm_117c16 ; 0x117bfa $1a
	ld a, [$d001]
	cp $f
	jr nz, .asm_117c16 ; 0x117c01 $13
	ld hl, $dfec
	ld de, $cd69
	ld c, $10
.asm_117c0b
	ld a, [de]
	inc de
	cp [hl]
	jr nz, .asm_117c16 ; 0x117c0e $6
	inc hl
	dec c
	jr nz, .asm_117c0b ; 0x117c12 $f7
	jr .asm_117c20 ; 0x117c14 $a
.asm_117c16
	pop af
	ld [rSVBK], a
	ld a, $d3
	ld [$c300], a
	jr .asm_117bd0 ; 0x117c1e $b0
.asm_117c20
	pop af
	ld [rSVBK], a
	ld a, $5c
	ld hl, $6eb9
	rst FarCall
	ld a, [rSVBK]
	push af
	ld a, $3
	ld [rSVBK], a
	ld a, $7
	call GetSRAMBank
	ld hl, DefaultFlypoint
	ld de, $b000
	ld bc, $1000
	call CopyBytes
	call CloseSRAM
	pop af
	ld [rSVBK], a
	jp Function117cdd

Function117c4a:
	ld hl, Data117cbc
	call LoadMenuDataHeader
	call Function1cbb
	call Function1cfd
	ld a, $41
	ld hl, $4061
	rst FarCall
	ld hl, MobileStadiumSuccessText
	call PrintText
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, $d000
	ld de, $0008
	ld c, $8
.asm_117c71
	push hl
	ld a, $ff
	ld [hli], a
	ld a, " "
	ld [hl], a
	pop hl
	add hl, de
	dec c
	jr nz, .asm_117c71 ; 0x117c7b $f4
	call Function4b6
	pop af
	ld [rSVBK], a
	ld a, $80
	ld [$cf63], a
	ret

Function117c89:
	ld a, $7
	call GetSRAMBank
	ld l, $0
	ld h, l
	ld de, $b000
	ld bc, $0ffc
.asm_117c97
	push bc
	ld a, [de]
	inc de
	ld c, a
	ld b, $0
	add hl, bc
	pop bc
	dec bc
	ld a, b
	or c
	jr nz, .asm_117c97 ; 0x117ca2 $f3
	ld a, l
	ld [$cd83], a
	ld a, h
	ld [$cd84], a
	ld hl, $bfea
	ld de, $cd69
	ld bc, $0010
	call CopyBytes
	call CloseSRAM
	ret

Data117cbc: ; 0x117cbc
	db $40, $0c, $00, $11, $13, $00, $00, $00

Data117cc4: ; 0x117cc4
	db $40, $07, $0e, $0b, $13, $00, $00, $00 ; XXX what is this

YesNo117ccc: ; 0x117ccc
	db "はい", $4e ; Yes
	db "いいえ@"   ; No

MobileStadiumEntryText: ; 0x117cd3
	TX_FAR _MobileStadiumEntryText
	db "@"

MobileStadiumSuccessText: ; 0x117cd8
	TX_FAR _MobileStadiumSuccessText
	db "@"

Function117cdd: ; 0x117cdd
	ld hl, $cf63
	inc [hl]
	ret


SECTION "bank46",ROMX,BANK[$46]

INCBIN "baserom.gbc", $118000, $118ba5 - $118000

ExchangeDownloadURL: ; 0x118ba5
	ascii "http://gameboy.datacenter.ne.jp/cgb/download?name=/01/CGB-BXTJ/exchange/index.txt"

db $0

BattleDownloadURL: ; 0x118bf7
	ascii "http://gameboy.datacenter.ne.jp/cgb/download?name=/01/CGB-BXTJ/battle/index.txt"

db $0

NewsDownloadURL: ; 0x118c47
	ascii "http://gameboy.datacenter.ne.jp/cgb/download?name=/01/CGB-BXTJ/news/index.txt"

db $0

MenuDownloadURL: ; 0x118c95
	ascii "http://gameboy.datacenter.ne.jp/cgb/download?name=/01/CGB-BXTJ/POKESTA/menu.cgb"

db $0

IndexDownloadURL: ; 0x118ce4
	ascii "http://gameboy.datacenter.ne.jp/cgb/download?name=/01/CGB-BXTJ/tamago/index.txt"

db $0

INCBIN "baserom.gbc", $118d35, $11aa13 - $118d35

UnknownText_0x11aa13: ; 0x11aa13
	db $0, "SAVE FILE will be", $4f
	db "sent.", $57
; 0x11aa2c

UnknownText_0x11aa2c: ; 0x11aa2c
	db $0, "Sent SAVE FILE.", $4f
	db "Reading NEWS…", $57
; 0x11aa4b

UnknownText_0x11aa4b: ; 0x11aa4b
	db $0, "Reading NEWS…", $57
; 0x11aa5a

UnknownText_0x11aa5a: ; 0x11aa5a
	db $0, "Received NEWS!", $57
; 0x11aa6a

UnknownText_0x11aa6a: ; 0x11aa6a
	db $0, "Quit reading NEWS?", $57
; 0x11aa7e

UnknownText_0x11aa7e: ; 0x11aa7e
	db $0, "Canceled sending", $4f
	db "SAVE FILE.", $57
; 0x11aa9b

UnknownText_0x11aa9b: ; 0x11aa9b
	db $0, "ODD EGG", $4f
	db "was received!", $57
; 0x11aab2

UnknownText_0x11aab2: ; 0x11aab2
	db $0, "Registering your", $4f
	db "record…", $57
; 0x11aacc

UnknownText_0x11aacc: ; 0x11aacc
	db $0, "One visit per day", $4f
	db "per BATTLE ROOM!", $57
; 0x11aaf0

UnknownText_0x11aaf0: ; 0x11aaf0
	db $0, "A party #MON", $4f
	db "tops this level.", $57
; 0x11ab0f

UnknownText_0x11ab0f: ; 0x11ab0f
	text_from_ram $cd49
	db $0, " may go", $4f
	db "only to BATTLE", $51
	db "ROOMS that are", $4f
	db "Lv.70 or higher.", $57
; 0x11ab4a

UnknownText_0x11ab4a: ; 0x11ab4a
	db $0, "Cancel your BATTLE", $4f
	db "ROOM challenge?", $57
; 0x11ab6e

UnknownText_0x11ab6e: ; 0x11ab6e
	db $0, "Exit GYM LEADER", $4f
	db "HONOR ROLL?", $57
; 0x11ab8b

UnknownText_0x11ab8b: ; 0x11ab8b
	db $0, "Linking with the", $4f
	db "CENTER…", $57
; 0x11aba5

UnknownText_0x11aba5: ; 0x11aba5
	db $0, "What level do you", $4f
	db "want to challenge?", $57
; 0x11abcb

UnknownText_0x11abcb: ; 0x11abcb
	db $0, "Check BATTLE ROOM", $4f
	db "list by max level?", $57
; 0x11abf1

UnknownText_0x11abf1: ; 0x11abf1
	db $0, "Enter which", $4f
	db "BATTLE ROOM?", $57
; 0x11ac0b

UnknownText_0x11ac0b: ; 0x11ac0b
	db $0, "Which BATTLE ROOM?", $57
; 0x11ac1f

UnknownText_0x11ac1f: ; 0x11ac1f
	text_from_ram $d099
	db $0, "'s ROOM", $4f
	db "@"
	text_from_ram $d0ac
	db $0, "?", $55
	db "Please wait…", $57
; 0x11ac3e

INCBIN "baserom.gbc", $11ac3e, $11b98f - $11ac3e

Function11b98f: ; 11b98f
	ld hl, PartyCount
	ld a, [hl]
	ld e, a
	inc [hl]
	ld a, [BGMapBuffer]
	ld l, a
	ld a, [$cd21]
	ld h, a
	inc hl
	ld bc, PartySpecies
	ld d, e
.asm_11b9a2
	inc bc
	dec d
	jr nz, .asm_11b9a2
	ld a, e
	ld [CurPartyMon], a
	ld a, [hl]
	ld [bc], a
	inc bc
	ld a, $ff
	ld [bc], a
	ld hl, PartyMon1Species
	ld bc, $0030
	ld a, e
	ld [$cd2a], a
.asm_11b9ba
	add hl, bc
	dec a
	and a
	jr nz, .asm_11b9ba
	ld e, l
	ld d, h
	ld a, [CreditsTimer]
	ld l, a
	ld a, [$cd23]
	ld h, a
	ld bc, $0030
	call CopyBytes
	ld hl, PartyMon1OT
	ld bc, $000b
	ld a, [$cd2a]
.asm_11b9d8
	add hl, bc
	dec a
	and a
	jr nz, .asm_11b9d8
	ld e, l
	ld d, h
	ld a, [$cd24]
	ld l, a
	ld a, [$cd25]
	ld h, a
	ld bc, $000a
	call CopyBytes
	ld a, $50
	ld [de], a
	ld hl, PartyMon1Nickname
	ld bc, $000b
	ld a, [$cd2a]
.asm_11b9f9
	add hl, bc
	dec a
	and a
	jr nz, .asm_11b9f9
	ld e, l
	ld d, h
	ld a, [$cd26]
	ld l, a
	ld a, [$cd27]
	ld h, a
	ld bc, $000a
	call CopyBytes
	ld a, $50
	ld [de], a
	ld hl, $a600
	ld bc, $002f
	ld a, [$cd2a]
.asm_11ba1a
	add hl, bc
	dec a
	and a
	jr nz, .asm_11ba1a
	ld a, $0
	call GetSRAMBank
	ld e, l
	ld d, h
	ld a, [$cd28]
	ld l, a
	ld a, [$cd29]
	ld h, a
	ld bc, $002f
	call CopyBytes
	call CloseSRAM
	ret
; 11ba38

INCBIN "baserom.gbc", $11ba38, $11bc9e - $11ba38


SECTION "bank47",ROMX,BANK[$47]

Function11c000: ; 11c000
	ld a, [rSVBK]
	push af
	ld a, $3
	ld [rSVBK], a
	ld hl, $d105
	ld a, [hl]
	dec a
	ld e, a
	ld d, $0
	ld hl, $72f0
	add hl, de
	ld a, [hl]
	and a
	jr nz, .asm_11c026
	ld a, [hRandomAdd]
	and $1f
	cp $19
	jr c, .asm_11c021
	sub $19

.asm_11c021
	ld hl, $7332
	jr .asm_11c033

.asm_11c026
	ld a, [hRandomAdd]
	and $f
	cp $f
	jr c, .asm_11c030
	sub $f

.asm_11c030
	ld hl, $73ce

.asm_11c033
	ld b, $0
	dec c
	jr nz, .asm_11c03d
	ld [$d200], a
	jr .asm_11c040

.asm_11c03d
	ld a, [$d200]

.asm_11c040
	push af
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld h, a
	ld l, c
	pop af
	ld c, a
	ld b, $0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld l, c
	ld h, a
	ld bc, $c5b9
	pop af
	ld [rSVBK], a
	call Function13e5
	ret
; 11c05d

Function11c05d: ; 11c05d
	ld a, e
	or d
	jr z, .asm_11c071
	ld a, e
	and d
	cp $ff
	jr z, .asm_11c071
	push hl
	call Function11c156
	pop hl
	call PlaceString
	and a
	ret

.asm_11c071
	ld c, l
	ld b, h
	scf
	ret
; 11c075

Function11c075: ; 11c075
	push de
	ld a, c
	call Function11c254
	pop de
	ld bc, $cd36
	call Function11c08f
	ret
; 11c082

INCBIN "baserom.gbc", $11c082, $11c08f - $11c082

Function11c08f: ; 11c08f
	ld l, e
	ld h, d
	push hl
	ld a, $3
.asm_11c094
	push af
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	inc bc
	push bc
	call Function11c05d
	jr c, .asm_11c0a2
	inc bc

.asm_11c0a2
	ld l, c
	ld h, b
	pop bc
	pop af
	dec a
	jr nz, .asm_11c094
	pop hl
	ld de, $0028
	add hl, de
	ld a, $3
.asm_11c0b0
	push af
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	inc bc
	push bc
	call Function11c05d
	jr c, .asm_11c0be
	inc bc

.asm_11c0be
	ld l, c
	ld h, b
	pop bc
	pop af
	dec a
	jr nz, .asm_11c0b0
	ret
; 11c0c6


Function11c0c6: ; 11c0c6
	ld a, [$cf63]
	ld l, a
	ld a, [$cf64]
	ld h, a
	push hl
	ld hl, $c618
	ld a, $0
	ld [hli], a
	push de
	xor a
	ld [$cf63], a
	ld a, $12
	ld [$cf64], a
	ld a, $6
.asm_11c0e1
	push af
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	inc bc
	or e
	jr z, .asm_11c133
	push hl
	push bc
	call Function11c156
	call Function11c14a
	ld e, c
	pop bc
	pop hl
	ld a, e
	or a
	jr z, .asm_11c133
.asm_11c0fa
	ld a, [$cf64]
	cp $12
	jr z, .asm_11c102
	inc e

.asm_11c102
	cp e
	jr nc, .asm_11c11c
	ld a, [$cf63]
	inc a
	ld [$cf63], a
	ld [hl], $4e
	rra
	jr c, .asm_11c113
	ld [hl], $55

.asm_11c113
	inc hl
	ld a, $12
	ld [$cf64], a
	dec e
	jr .asm_11c0fa

.asm_11c11c
	cp $12
	jr z, .asm_11c123
	ld [hl], $7f
	inc hl

.asm_11c123
	sub e
	ld [$cf64], a
	ld de, EnemyMoveAnimation
.asm_11c12a
	ld a, [de]
	cp $50
	jr z, .asm_11c133
	inc de
	ld [hli], a
	jr .asm_11c12a

.asm_11c133
	pop af
	dec a
	jr nz, .asm_11c0e1
	ld [hl], $57
	pop bc
	ld hl, $c618
	call Function13e5
	pop hl
	ld a, l
	ld [$cf63], a
	ld a, h
	ld [$cf64], a
	ret
; 11c14a

Function11c14a: ; 11c14a
	ld c, $0
	ld hl, EnemyMoveAnimation
.asm_11c14f
	ld a, [hli]
	cp $50
	ret z
	inc c
	jr .asm_11c14f
; 11c156

Function11c156: ; 11c156
	ld a, [rSVBK]
	push af
	ld a, $1
	ld [rSVBK], a
	ld a, $50
	ld hl, EnemyMoveAnimation
	ld bc, $000b
	call ByteFill
	ld a, d
	and a
	jr z, .asm_11c19c
	ld hl, $5aac
	dec d
	sla d
	ld c, d
	ld b, $0
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	push bc
	pop hl
	ld c, e
	ld b, $0
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	add hl, bc
	ld bc, $0005
.asm_11c18f
	ld de, EnemyMoveAnimation
	call CopyBytes
	ld de, EnemyMoveAnimation
	pop af
	ld [rSVBK], a
	ret

.asm_11c19c
	ld a, e
	ld [$d265], a
	call GetPokemonName
	ld hl, StringBuffer1
	ld bc, $000a
	jr .asm_11c18f
; 11c1ab

INCBIN "baserom.gbc", $11c1ab, $11c254 - $11c1ab

Function11c254: ; 11c254
	push af
	ld a, $4
	call GetSRAMBank
	ld hl, $a007
	pop af
	sla a
	sla a
	ld c, a
	sla a
	add c
	ld c, a
	ld b, $0
	add hl, bc
	ld de, $cd36
	ld bc, $000c
	call CopyBytes
	call CloseSRAM
	ret
; 11c277

INCBIN "baserom.gbc", $11c277, $11f686 - $11c277


SECTION "bank48",ROMX,BANK[$48]

PicPointers:
INCLUDE "gfx/pics/pic_pointers.asm"

;                             Pics I

HoOhFrontpic:        INCBIN "gfx/pics/250/front.lz"
MachampFrontpic:     INCBIN "gfx/pics/068/front.lz"
NinetalesFrontpic:   INCBIN "gfx/pics/038/front.lz"
FeraligatrFrontpic:  INCBIN "gfx/pics/160/front.lz"
NidokingFrontpic:    INCBIN "gfx/pics/034/front.lz"
RaikouFrontpic:      INCBIN "gfx/pics/243/front.lz"
LugiaFrontpic:       INCBIN "gfx/pics/249/front.lz"
ArticunoFrontpic:    INCBIN "gfx/pics/144/front.lz"
TaurosFrontpic:      INCBIN "gfx/pics/128/front.lz"
VenusaurFrontpic:    INCBIN "gfx/pics/003/front.lz"
EnteiFrontpic:       INCBIN "gfx/pics/244/front.lz"
SuicuneFrontpic:     INCBIN "gfx/pics/245/front.lz"
TyphlosionFrontpic:  INCBIN "gfx/pics/157/front.lz"
; 123ffa


SECTION "bank49",ROMX,BANK[$49]

UnownPicPointers:
INCLUDE "gfx/pics/unown_pic_pointers.asm"

;                            Pics II

BlastoiseFrontpic:   INCBIN "gfx/pics/009/front.lz"
RapidashFrontpic:    INCBIN "gfx/pics/078/front.lz"
MeganiumFrontpic:    INCBIN "gfx/pics/154/front.lz"
NidoqueenFrontpic:   INCBIN "gfx/pics/031/front.lz"
HitmonleeFrontpic:   INCBIN "gfx/pics/106/front.lz"
ScizorFrontpic:      INCBIN "gfx/pics/212/front.lz"
BeedrillFrontpic:    INCBIN "gfx/pics/015/front.lz"
ArcanineFrontpic:    INCBIN "gfx/pics/059/front.lz"
TyranitarFrontpic:   INCBIN "gfx/pics/248/front.lz"
MoltresFrontpic:     INCBIN "gfx/pics/146/front.lz"
ZapdosFrontpic:      INCBIN "gfx/pics/145/front.lz"
ArbokFrontpic:       INCBIN "gfx/pics/024/front.lz"
MewtwoFrontpic:      INCBIN "gfx/pics/150/front.lz"
FearowFrontpic:      INCBIN "gfx/pics/022/front.lz"
CharizardFrontpic:   INCBIN "gfx/pics/006/front.lz"
QuilavaFrontpic:     INCBIN "gfx/pics/156/front.lz"
; 127ffe


SECTION "bank4a",ROMX,BANK[$4a]

TrainerPicPointers:
INCLUDE "gfx/pics/trainer_pic_pointers.asm"

;                           Pics III

SteelixFrontpic:     INCBIN "gfx/pics/208/front.lz"
AlakazamFrontpic:    INCBIN "gfx/pics/065/front.lz"
GyaradosFrontpic:    INCBIN "gfx/pics/130/front.lz"
KangaskhanFrontpic:  INCBIN "gfx/pics/115/front.lz"
RhydonFrontpic:      INCBIN "gfx/pics/112/front.lz"
GolduckFrontpic:     INCBIN "gfx/pics/055/front.lz"
RhyhornFrontpic:     INCBIN "gfx/pics/111/front.lz"
PidgeotFrontpic:     INCBIN "gfx/pics/018/front.lz"
SlowbroFrontpic:     INCBIN "gfx/pics/080/front.lz"
ButterfreeFrontpic:  INCBIN "gfx/pics/012/front.lz"
WeezingFrontpic:     INCBIN "gfx/pics/110/front.lz"
CloysterFrontpic:    INCBIN "gfx/pics/091/front.lz"
SkarmoryFrontpic:    INCBIN "gfx/pics/227/front.lz"
DewgongFrontpic:     INCBIN "gfx/pics/087/front.lz"
VictreebelFrontpic:  INCBIN "gfx/pics/071/front.lz"
RaichuFrontpic:      INCBIN "gfx/pics/026/front.lz"
PrimeapeFrontpic:    INCBIN "gfx/pics/057/front.lz"
OmastarBackpic:      INCBIN "gfx/pics/139/back.lz"
; 12bffe


SECTION "bank4b",ROMX,BANK[$4b]

;                            Pics IV

DodrioFrontpic:      INCBIN "gfx/pics/085/front.lz"
SlowkingFrontpic:    INCBIN "gfx/pics/199/front.lz"
HitmontopFrontpic:   INCBIN "gfx/pics/237/front.lz"
OnixFrontpic:        INCBIN "gfx/pics/095/front.lz"
BlisseyFrontpic:     INCBIN "gfx/pics/242/front.lz"
MachokeFrontpic:     INCBIN "gfx/pics/067/front.lz"
DragoniteFrontpic:   INCBIN "gfx/pics/149/front.lz"
PoliwrathFrontpic:   INCBIN "gfx/pics/062/front.lz"
ScytherFrontpic:     INCBIN "gfx/pics/123/front.lz"
AerodactylFrontpic:  INCBIN "gfx/pics/142/front.lz"
SeakingFrontpic:     INCBIN "gfx/pics/119/front.lz"
MukFrontpic:         INCBIN "gfx/pics/089/front.lz"
CroconawFrontpic:    INCBIN "gfx/pics/159/front.lz"
HypnoFrontpic:       INCBIN "gfx/pics/097/front.lz"
NidorinoFrontpic:    INCBIN "gfx/pics/033/front.lz"
SandslashFrontpic:   INCBIN "gfx/pics/028/front.lz"
JolteonFrontpic:     INCBIN "gfx/pics/135/front.lz"
DonphanFrontpic:     INCBIN "gfx/pics/232/front.lz"
PinsirFrontpic:      INCBIN "gfx/pics/127/front.lz"
UnownEFrontpic:      INCBIN "gfx/pics/201e/front.lz"
; 130000


SECTION "bank4C",ROMX,BANK[$4C]

;                             Pics V

GolbatFrontpic:      INCBIN "gfx/pics/042/front.lz"
KinglerFrontpic:     INCBIN "gfx/pics/099/front.lz"
ExeggcuteFrontpic:   INCBIN "gfx/pics/102/front.lz"
MagcargoFrontpic:    INCBIN "gfx/pics/219/front.lz"
PersianFrontpic:     INCBIN "gfx/pics/053/front.lz"
StantlerFrontpic:    INCBIN "gfx/pics/234/front.lz"
RaticateFrontpic:    INCBIN "gfx/pics/020/front.lz"
VenomothFrontpic:    INCBIN "gfx/pics/049/front.lz"
PolitoedFrontpic:    INCBIN "gfx/pics/186/front.lz"
ElectabuzzFrontpic:  INCBIN "gfx/pics/125/front.lz"
MantineFrontpic:     INCBIN "gfx/pics/226/front.lz"
LickitungFrontpic:   INCBIN "gfx/pics/108/front.lz"
KingdraFrontpic:     INCBIN "gfx/pics/230/front.lz"
CharmeleonFrontpic:  INCBIN "gfx/pics/005/front.lz"
KadabraFrontpic:     INCBIN "gfx/pics/064/front.lz"
ExeggutorFrontpic:   INCBIN "gfx/pics/103/front.lz"
GastlyFrontpic:      INCBIN "gfx/pics/092/front.lz"
AzumarillFrontpic:   INCBIN "gfx/pics/184/front.lz"
ParasectFrontpic:    INCBIN "gfx/pics/047/front.lz"
MrMimeFrontpic:      INCBIN "gfx/pics/122/front.lz"
HeracrossFrontpic:   INCBIN "gfx/pics/214/front.lz"
; 133fff


SECTION "bank4d",ROMX,BANK[$4d]

;                            Pics VI

AriadosFrontpic:     INCBIN "gfx/pics/168/front.lz"
NoctowlFrontpic:     INCBIN "gfx/pics/164/front.lz"
WartortleFrontpic:   INCBIN "gfx/pics/008/front.lz"
LaprasFrontpic:      INCBIN "gfx/pics/131/front.lz"
GolemFrontpic:       INCBIN "gfx/pics/076/front.lz"
PoliwhirlFrontpic:   INCBIN "gfx/pics/061/front.lz"
UrsaringFrontpic:    INCBIN "gfx/pics/217/front.lz"
HoundoomFrontpic:    INCBIN "gfx/pics/229/front.lz"
KabutopsFrontpic:    INCBIN "gfx/pics/141/front.lz"
AmpharosFrontpic:    INCBIN "gfx/pics/181/front.lz"
NidorinaFrontpic:    INCBIN "gfx/pics/030/front.lz"
FlareonFrontpic:     INCBIN "gfx/pics/136/front.lz"
FarfetchDFrontpic:   INCBIN "gfx/pics/083/front.lz"
VileplumeFrontpic:   INCBIN "gfx/pics/045/front.lz"
BayleefFrontpic:     INCBIN "gfx/pics/153/front.lz"
MagmarFrontpic:      INCBIN "gfx/pics/126/front.lz"
TentacruelFrontpic:  INCBIN "gfx/pics/073/front.lz"
ElekidFrontpic:      INCBIN "gfx/pics/239/front.lz"
JumpluffFrontpic:    INCBIN "gfx/pics/189/front.lz"
MarowakFrontpic:     INCBIN "gfx/pics/105/front.lz"
VulpixFrontpic:      INCBIN "gfx/pics/037/front.lz"
GligarFrontpic:      INCBIN "gfx/pics/207/front.lz"
DunsparceFrontpic:   INCBIN "gfx/pics/206/front.lz"
; 137fff


SECTION "bank4E",ROMX,BANK[$4E]

;                           Pics VII

VaporeonFrontpic:    INCBIN "gfx/pics/134/front.lz"
GirafarigFrontpic:   INCBIN "gfx/pics/203/front.lz"
DrowzeeFrontpic:     INCBIN "gfx/pics/096/front.lz"
SneaselFrontpic:     INCBIN "gfx/pics/215/front.lz"
BellossomFrontpic:   INCBIN "gfx/pics/182/front.lz"
SnorlaxFrontpic:     INCBIN "gfx/pics/143/front.lz"
WigglytuffFrontpic:  INCBIN "gfx/pics/040/front.lz"
YanmaFrontpic:       INCBIN "gfx/pics/193/front.lz"
SmeargleFrontpic:    INCBIN "gfx/pics/235/front.lz"
ClefableFrontpic:    INCBIN "gfx/pics/036/front.lz"
PonytaFrontpic:      INCBIN "gfx/pics/077/front.lz"
MurkrowFrontpic:     INCBIN "gfx/pics/198/front.lz"
GravelerFrontpic:    INCBIN "gfx/pics/075/front.lz"
StarmieFrontpic:     INCBIN "gfx/pics/121/front.lz"
PidgeottoFrontpic:   INCBIN "gfx/pics/017/front.lz"
LedybaFrontpic:      INCBIN "gfx/pics/165/front.lz"
GengarFrontpic:      INCBIN "gfx/pics/094/front.lz"
OmastarFrontpic:     INCBIN "gfx/pics/139/front.lz"
PiloswineFrontpic:   INCBIN "gfx/pics/221/front.lz"
DugtrioFrontpic:     INCBIN "gfx/pics/051/front.lz"
MagnetonFrontpic:    INCBIN "gfx/pics/082/front.lz"
DragonairFrontpic:   INCBIN "gfx/pics/148/front.lz"
ForretressFrontpic:  INCBIN "gfx/pics/205/front.lz"
TogeticFrontpic:     INCBIN "gfx/pics/176/front.lz"
KangaskhanBackpic:   INCBIN "gfx/pics/115/back.lz"
; 13c000


SECTION "bank4f",ROMX,BANK[$4f]

;                          Pics VIII

SeelFrontpic:        INCBIN "gfx/pics/086/front.lz"
CrobatFrontpic:      INCBIN "gfx/pics/169/front.lz"
ChanseyFrontpic:     INCBIN "gfx/pics/113/front.lz"
TangelaFrontpic:     INCBIN "gfx/pics/114/front.lz"
SnubbullFrontpic:    INCBIN "gfx/pics/209/front.lz"
GranbullFrontpic:    INCBIN "gfx/pics/210/front.lz"
MiltankFrontpic:     INCBIN "gfx/pics/241/front.lz"
HaunterFrontpic:     INCBIN "gfx/pics/093/front.lz"
SunfloraFrontpic:    INCBIN "gfx/pics/192/front.lz"
UmbreonFrontpic:     INCBIN "gfx/pics/197/front.lz"
ChikoritaFrontpic:   INCBIN "gfx/pics/152/front.lz"
GoldeenFrontpic:     INCBIN "gfx/pics/118/front.lz"
EspeonFrontpic:      INCBIN "gfx/pics/196/front.lz"
XatuFrontpic:        INCBIN "gfx/pics/178/front.lz"
MewFrontpic:         INCBIN "gfx/pics/151/front.lz"
OctilleryFrontpic:   INCBIN "gfx/pics/224/front.lz"
JynxFrontpic:        INCBIN "gfx/pics/124/front.lz"
WobbuffetFrontpic:   INCBIN "gfx/pics/202/front.lz"
DelibirdFrontpic:    INCBIN "gfx/pics/225/front.lz"
LedianFrontpic:      INCBIN "gfx/pics/166/front.lz"
GloomFrontpic:       INCBIN "gfx/pics/044/front.lz"
FlaaffyFrontpic:     INCBIN "gfx/pics/180/front.lz"
IvysaurFrontpic:     INCBIN "gfx/pics/002/front.lz"
FurretFrontpic:      INCBIN "gfx/pics/162/front.lz"
CyndaquilFrontpic:   INCBIN "gfx/pics/155/front.lz"
HitmonchanFrontpic:  INCBIN "gfx/pics/107/front.lz"
QuagsireFrontpic:    INCBIN "gfx/pics/195/front.lz"
; 13fff7


SECTION "bank50",ROMX,BANK[$50]

;                            Pics IX

EkansFrontpic:       INCBIN "gfx/pics/023/front.lz"
SudowoodoFrontpic:   INCBIN "gfx/pics/185/front.lz"
PikachuFrontpic:     INCBIN "gfx/pics/025/front.lz"
SeadraFrontpic:      INCBIN "gfx/pics/117/front.lz"
MagbyFrontpic:       INCBIN "gfx/pics/240/front.lz"
WeepinbellFrontpic:  INCBIN "gfx/pics/070/front.lz"
TotodileFrontpic:    INCBIN "gfx/pics/158/front.lz"
CorsolaFrontpic:     INCBIN "gfx/pics/222/front.lz"
FirebreatherPic:     INCBIN "gfx/trainers/047.lz"
MachopFrontpic:      INCBIN "gfx/pics/066/front.lz"
ChinchouFrontpic:    INCBIN "gfx/pics/170/front.lz"
RattataFrontpic:     INCBIN "gfx/pics/019/front.lz"
ChampionPic:         INCBIN "gfx/trainers/015.lz"
SpearowFrontpic:     INCBIN "gfx/pics/021/front.lz"
MagikarpFrontpic:    INCBIN "gfx/pics/129/front.lz"
CharmanderFrontpic:  INCBIN "gfx/pics/004/front.lz"
CuboneFrontpic:      INCBIN "gfx/pics/104/front.lz"
BlackbeltTPic:       INCBIN "gfx/trainers/049.lz"
BikerPic:            INCBIN "gfx/trainers/044.lz"
NidoranMFrontpic:    INCBIN "gfx/pics/032/front.lz"
PorygonFrontpic:     INCBIN "gfx/pics/137/front.lz"
BrunoPic:            INCBIN "gfx/trainers/012.lz"
GrimerFrontpic:      INCBIN "gfx/pics/088/front.lz"
StaryuFrontpic:      INCBIN "gfx/pics/120/front.lz"
HikerPic:            INCBIN "gfx/trainers/043.lz"
MeowthFrontpic:      INCBIN "gfx/pics/052/front.lz"
Porygon2Frontpic:    INCBIN "gfx/pics/233/front.lz"
SandshrewFrontpic:   INCBIN "gfx/pics/027/front.lz"
NidoranFFrontpic:    INCBIN "gfx/pics/029/front.lz"
PidgeyFrontpic:      INCBIN "gfx/pics/016/front.lz"
ParasectBackpic:     INCBIN "gfx/pics/047/back.lz"
; 144000


SECTION "bank51",ROMX,BANK[$51]

;                             Pics X

MisdreavusFrontpic:  INCBIN "gfx/pics/200/front.lz"
HoundourFrontpic:    INCBIN "gfx/pics/228/front.lz"
MankeyFrontpic:      INCBIN "gfx/pics/056/front.lz"
CelebiFrontpic:      INCBIN "gfx/pics/251/front.lz"
MediumPic:           INCBIN "gfx/trainers/056.lz"
PinecoFrontpic:      INCBIN "gfx/pics/204/front.lz"
KrabbyFrontpic:      INCBIN "gfx/pics/098/front.lz"
FisherPic:           INCBIN "gfx/trainers/036.lz"
JigglypuffFrontpic:  INCBIN "gfx/pics/039/front.lz"
ParasFrontpic:       INCBIN "gfx/pics/046/front.lz"
NidokingBackpic:     INCBIN "gfx/pics/034/back.lz"
PokefanmPic:         INCBIN "gfx/trainers/058.lz"
BoarderPic:          INCBIN "gfx/trainers/057.lz"
PsyduckFrontpic:     INCBIN "gfx/pics/054/front.lz"
SquirtleFrontpic:    INCBIN "gfx/pics/007/front.lz"
MachampBackpic:      INCBIN "gfx/pics/068/back.lz"
KoffingFrontpic:     INCBIN "gfx/pics/109/front.lz"
VenonatFrontpic:     INCBIN "gfx/pics/048/front.lz"
ExeggutorBackpic:    INCBIN "gfx/pics/103/back.lz"
LanturnFrontpic:     INCBIN "gfx/pics/171/front.lz"
TyrogueFrontpic:     INCBIN "gfx/pics/236/front.lz"
SkiploomFrontpic:    INCBIN "gfx/pics/188/front.lz"
MareepFrontpic:      INCBIN "gfx/pics/179/front.lz"
ChuckPic:            INCBIN "gfx/trainers/006.lz"
EeveeFrontpic:       INCBIN "gfx/pics/133/front.lz"
ButterfreeBackpic:   INCBIN "gfx/pics/012/back.lz"
ZubatFrontpic:       INCBIN "gfx/pics/041/front.lz"
KimonoGirlPic:       INCBIN "gfx/trainers/059.lz"
AlakazamBackpic:     INCBIN "gfx/pics/065/back.lz"
AipomFrontpic:       INCBIN "gfx/pics/190/front.lz"
AbraFrontpic:        INCBIN "gfx/pics/063/front.lz"
HitmontopBackpic:    INCBIN "gfx/pics/237/back.lz"
CloysterBackpic:     INCBIN "gfx/pics/091/back.lz"
HoothootFrontpic:    INCBIN "gfx/pics/163/front.lz"
UnownFBackpic:       INCBIN "gfx/pics/201f/back.lz"
; 148000


SECTION "bank52",ROMX,BANK[$52]

;                            Pics XI

DodrioBackpic:       INCBIN "gfx/pics/085/back.lz"
ClefairyFrontpic:    INCBIN "gfx/pics/035/front.lz"
SlugmaFrontpic:      INCBIN "gfx/pics/218/front.lz"
GrowlitheFrontpic:   INCBIN "gfx/pics/058/front.lz"
SlowpokeFrontpic:    INCBIN "gfx/pics/079/front.lz"
SmoochumFrontpic:    INCBIN "gfx/pics/238/front.lz"
JugglerPic:          INCBIN "gfx/trainers/048.lz"
MarillFrontpic:      INCBIN "gfx/pics/183/front.lz"
GuitaristPic:        INCBIN "gfx/trainers/042.lz"
PokefanfPic:         INCBIN "gfx/trainers/061.lz"
VenomothBackpic:     INCBIN "gfx/pics/049/back.lz"
ClairPic:            INCBIN "gfx/trainers/007.lz"
PokemaniacPic:       INCBIN "gfx/trainers/029.lz"
OmanyteFrontpic:     INCBIN "gfx/pics/138/front.lz"
SkierPic:            INCBIN "gfx/trainers/032.lz"
PupitarFrontpic:     INCBIN "gfx/pics/247/front.lz"
BellsproutFrontpic:  INCBIN "gfx/pics/069/front.lz"
ShellderFrontpic:    INCBIN "gfx/pics/090/front.lz"
TentacoolFrontpic:   INCBIN "gfx/pics/072/front.lz"
CleffaFrontpic:      INCBIN "gfx/pics/173/front.lz"
GyaradosBackpic:     INCBIN "gfx/pics/130/back.lz"
NinetalesBackpic:    INCBIN "gfx/pics/038/back.lz"
YanmaBackpic:        INCBIN "gfx/pics/193/back.lz"
PinsirBackpic:       INCBIN "gfx/pics/127/back.lz"
LassPic:             INCBIN "gfx/trainers/024.lz"
ClefableBackpic:     INCBIN "gfx/pics/036/back.lz"
DoduoFrontpic:       INCBIN "gfx/pics/084/front.lz"
FeraligatrBackpic:   INCBIN "gfx/pics/160/back.lz"
DratiniFrontpic:     INCBIN "gfx/pics/147/front.lz"
MagnetonBackpic:     INCBIN "gfx/pics/082/back.lz"
QwilfishFrontpic:    INCBIN "gfx/pics/211/front.lz"
SuicuneBackpic:      INCBIN "gfx/pics/245/back.lz"
SlowkingBackpic:     INCBIN "gfx/pics/199/back.lz"
ElekidBackpic:       INCBIN "gfx/pics/239/back.lz"
CelebiBackpic:       INCBIN "gfx/pics/251/back.lz"
KrabbyBackpic:       INCBIN "gfx/pics/098/back.lz"
BugCatcherPic:       INCBIN "gfx/trainers/035.lz"
SnorlaxBackpic:      INCBIN "gfx/pics/143/back.lz"
; 14bffb


SECTION "bank53",ROMX,BANK[$53]

;                           Pics XII

VenusaurBackpic:     INCBIN "gfx/pics/003/back.lz"
MoltresBackpic:      INCBIN "gfx/pics/146/back.lz"
SunfloraBackpic:     INCBIN "gfx/pics/192/back.lz"
PhanpyFrontpic:      INCBIN "gfx/pics/231/front.lz"
RhydonBackpic:       INCBIN "gfx/pics/112/back.lz"
LarvitarFrontpic:    INCBIN "gfx/pics/246/front.lz"
TyranitarBackpic:    INCBIN "gfx/pics/248/back.lz"
SandslashBackpic:    INCBIN "gfx/pics/028/back.lz"
SeadraBackpic:       INCBIN "gfx/pics/117/back.lz"
TwinsPic:            INCBIN "gfx/trainers/060.lz"
FarfetchDBackpic:    INCBIN "gfx/pics/083/back.lz"
NidoranMBackpic:     INCBIN "gfx/pics/032/back.lz"
LedybaBackpic:       INCBIN "gfx/pics/165/back.lz"
CyndaquilBackpic:    INCBIN "gfx/pics/155/back.lz"
BayleefBackpic:      INCBIN "gfx/pics/153/back.lz"
OddishFrontpic:      INCBIN "gfx/pics/043/front.lz"
RapidashBackpic:     INCBIN "gfx/pics/078/back.lz"
DoduoBackpic:        INCBIN "gfx/pics/084/back.lz"
HoppipFrontpic:      INCBIN "gfx/pics/187/front.lz"
MankeyBackpic:       INCBIN "gfx/pics/056/back.lz"
MagmarBackpic:       INCBIN "gfx/pics/126/back.lz"
HypnoBackpic:        INCBIN "gfx/pics/097/back.lz"
QuilavaBackpic:      INCBIN "gfx/pics/156/back.lz"
CroconawBackpic:     INCBIN "gfx/pics/159/back.lz"
SandshrewBackpic:    INCBIN "gfx/pics/027/back.lz"
SailorPic:           INCBIN "gfx/trainers/039.lz"
BeautyPic:           INCBIN "gfx/trainers/028.lz"
ShellderBackpic:     INCBIN "gfx/pics/090/back.lz"
ZubatBackpic:        INCBIN "gfx/pics/041/back.lz"
TeddiursaFrontpic:   INCBIN "gfx/pics/216/front.lz"
CuboneBackpic:       INCBIN "gfx/pics/104/back.lz"
GruntmPic:           INCBIN "gfx/trainers/030.lz"
GloomBackpic:        INCBIN "gfx/pics/044/back.lz"
MagcargoBackpic:     INCBIN "gfx/pics/219/back.lz"
KabutopsBackpic:     INCBIN "gfx/pics/141/back.lz"
BeedrillBackpic:     INCBIN "gfx/pics/015/back.lz"
ArcanineBackpic:     INCBIN "gfx/pics/059/back.lz"
FlareonBackpic:      INCBIN "gfx/pics/136/back.lz"
GoldeenBackpic:      INCBIN "gfx/pics/118/back.lz"
BulbasaurFrontpic:   INCBIN "gfx/pics/001/front.lz"
StarmieBackpic:      INCBIN "gfx/pics/121/back.lz"
; 150000


SECTION "bank54",ROMX,BANK[$54]

;                           Pics XIII

OmanyteBackpic:      INCBIN "gfx/pics/138/back.lz"
PidgeyBackpic:       INCBIN "gfx/pics/016/back.lz"
ScientistPic:        INCBIN "gfx/trainers/019.lz"
QwilfishBackpic:     INCBIN "gfx/pics/211/back.lz"
GligarBackpic:       INCBIN "gfx/pics/207/back.lz"
TyphlosionBackpic:   INCBIN "gfx/pics/157/back.lz"
CharmeleonBackpic:   INCBIN "gfx/pics/005/back.lz"
NidoqueenBackpic:    INCBIN "gfx/pics/031/back.lz"
PichuFrontpic:       INCBIN "gfx/pics/172/front.lz"
ElectabuzzBackpic:   INCBIN "gfx/pics/125/back.lz"
LedianBackpic:       INCBIN "gfx/pics/166/back.lz"
PupitarBackpic:      INCBIN "gfx/pics/247/back.lz"
HeracrossBackpic:    INCBIN "gfx/pics/214/back.lz"
UnownDFrontpic:      INCBIN "gfx/pics/201d/front.lz"
MiltankBackpic:      INCBIN "gfx/pics/241/back.lz"
SteelixBackpic:      INCBIN "gfx/pics/208/back.lz"
PersianBackpic:      INCBIN "gfx/pics/053/back.lz"
LtSurgePic:          INCBIN "gfx/trainers/018.lz"
TeacherPic:          INCBIN "gfx/trainers/033.lz"
EggPic:              INCBIN "gfx/pics/egg/front.lz"
EeveeBackpic:        INCBIN "gfx/pics/133/back.lz"
ShuckleFrontpic:     INCBIN "gfx/pics/213/front.lz"
PonytaBackpic:       INCBIN "gfx/pics/077/back.lz"
RemoraidFrontpic:    INCBIN "gfx/pics/223/front.lz"
PoliwagFrontpic:     INCBIN "gfx/pics/060/front.lz"
OnixBackpic:         INCBIN "gfx/pics/095/back.lz"
KoffingBackpic:      INCBIN "gfx/pics/109/back.lz"
BirdKeeperPic:       INCBIN "gfx/trainers/023.lz"
FalknerPic:          INCBIN "gfx/trainers/000.lz"
KarenPic:            INCBIN "gfx/trainers/013.lz"
NidorinaBackpic:     INCBIN "gfx/pics/030/back.lz"
TentacruelBackpic:   INCBIN "gfx/pics/073/back.lz"
GrowlitheBackpic:    INCBIN "gfx/pics/058/back.lz"
KogaPic:             INCBIN "gfx/trainers/014.lz"
MachokeBackpic:      INCBIN "gfx/pics/067/back.lz"
RaichuBackpic:       INCBIN "gfx/pics/026/back.lz"
PoliwrathBackpic:    INCBIN "gfx/pics/062/back.lz"
SwimmermPic:         INCBIN "gfx/trainers/037.lz"
SunkernFrontpic:     INCBIN "gfx/pics/191/front.lz"
NidorinoBackpic:     INCBIN "gfx/pics/033/back.lz"
MysticalmanPic:      INCBIN "gfx/trainers/066.lz"
CooltrainerfPic:     INCBIN "gfx/trainers/027.lz"
ElectrodeFrontpic:   INCBIN "gfx/pics/101/front.lz"
; 153fe3


SECTION "bank55",ROMX,BANK[$55]

;                           Pics XIV

SudowoodoBackpic:    INCBIN "gfx/pics/185/back.lz"
FlaaffyBackpic:      INCBIN "gfx/pics/180/back.lz"
SentretFrontpic:     INCBIN "gfx/pics/161/front.lz"
TogeticBackpic:      INCBIN "gfx/pics/176/back.lz"
BugsyPic:            INCBIN "gfx/trainers/002.lz"
MarowakBackpic:      INCBIN "gfx/pics/105/back.lz"
GeodudeBackpic:      INCBIN "gfx/pics/074/back.lz"
ScytherBackpic:      INCBIN "gfx/pics/123/back.lz"
VileplumeBackpic:    INCBIN "gfx/pics/045/back.lz"
HitmonchanBackpic:   INCBIN "gfx/pics/107/back.lz"
JumpluffBackpic:     INCBIN "gfx/pics/189/back.lz"
CooltrainermPic:     INCBIN "gfx/trainers/026.lz"
BlastoiseBackpic:    INCBIN "gfx/pics/009/back.lz"
MisdreavusBackpic:   INCBIN "gfx/pics/200/back.lz"
TyrogueBackpic:      INCBIN "gfx/pics/236/back.lz"
GeodudeFrontpic:     INCBIN "gfx/pics/074/front.lz"
ScizorBackpic:       INCBIN "gfx/pics/212/back.lz"
GirafarigBackpic:    INCBIN "gfx/pics/203/back.lz"
StantlerBackpic:     INCBIN "gfx/pics/234/back.lz"
SmeargleBackpic:     INCBIN "gfx/pics/235/back.lz"
CharizardBackpic:    INCBIN "gfx/pics/006/back.lz"
KadabraBackpic:      INCBIN "gfx/pics/064/back.lz"
PrimeapeBackpic:     INCBIN "gfx/pics/057/back.lz"
FurretBackpic:       INCBIN "gfx/pics/162/back.lz"
WartortleBackpic:    INCBIN "gfx/pics/008/back.lz"
ExeggcuteBackpic:    INCBIN "gfx/pics/102/back.lz"
IgglybuffFrontpic:   INCBIN "gfx/pics/174/front.lz"
RaticateBackpic:     INCBIN "gfx/pics/020/back.lz"
VulpixBackpic:       INCBIN "gfx/pics/037/back.lz"
EkansBackpic:        INCBIN "gfx/pics/023/back.lz"
SeakingBackpic:      INCBIN "gfx/pics/119/back.lz"
BurglarPic:          INCBIN "gfx/trainers/046.lz"
PsyduckBackpic:      INCBIN "gfx/pics/054/back.lz"
PikachuBackpic:      INCBIN "gfx/pics/025/back.lz"
KabutoFrontpic:      INCBIN "gfx/pics/140/front.lz"
MareepBackpic:       INCBIN "gfx/pics/179/back.lz"
RemoraidBackpic:     INCBIN "gfx/pics/223/back.lz"
DittoFrontpic:       INCBIN "gfx/pics/132/front.lz"
KingdraBackpic:      INCBIN "gfx/pics/230/back.lz"
CamperPic:           INCBIN "gfx/trainers/053.lz"
WooperFrontpic:      INCBIN "gfx/pics/194/front.lz"
ClefairyBackpic:     INCBIN "gfx/pics/035/back.lz"
VenonatBackpic:      INCBIN "gfx/pics/048/back.lz"
BellossomBackpic:    INCBIN "gfx/pics/182/back.lz"
Rival1Pic:           INCBIN "gfx/trainers/008.lz"
SwinubBackpic:       INCBIN "gfx/pics/220/back.lz"
; 158000


SECTION "bank56",ROMX,BANK[$56]

;                            Pics XV

MewtwoBackpic:       INCBIN "gfx/pics/150/back.lz"
PokemonProfPic:      INCBIN "gfx/trainers/009.lz"
CalPic:              INCBIN "gfx/trainers/011.lz"
SwimmerfPic:         INCBIN "gfx/trainers/038.lz"
DiglettFrontpic:     INCBIN "gfx/pics/050/front.lz"
OfficerPic:          INCBIN "gfx/trainers/064.lz"
MukBackpic:          INCBIN "gfx/pics/089/back.lz"
DelibirdBackpic:     INCBIN "gfx/pics/225/back.lz"
SabrinaPic:          INCBIN "gfx/trainers/034.lz"
MagikarpBackpic:     INCBIN "gfx/pics/129/back.lz"
AriadosBackpic:      INCBIN "gfx/pics/168/back.lz"
SneaselBackpic:      INCBIN "gfx/pics/215/back.lz"
UmbreonBackpic:      INCBIN "gfx/pics/197/back.lz"
MurkrowBackpic:      INCBIN "gfx/pics/198/back.lz"
IvysaurBackpic:      INCBIN "gfx/pics/002/back.lz"
SlowbroBackpic:      INCBIN "gfx/pics/080/back.lz"
PsychicTPic:         INCBIN "gfx/trainers/051.lz"
GolduckBackpic:      INCBIN "gfx/pics/055/back.lz"
WeezingBackpic:      INCBIN "gfx/pics/110/back.lz"
EnteiBackpic:        INCBIN "gfx/pics/244/back.lz"
GruntfPic:           INCBIN "gfx/trainers/065.lz"
HorseaFrontpic:      INCBIN "gfx/pics/116/front.lz"
PidgeotBackpic:      INCBIN "gfx/pics/018/back.lz"
HoOhBackpic:         INCBIN "gfx/pics/250/back.lz"
PoliwhirlBackpic:    INCBIN "gfx/pics/061/back.lz"
MewBackpic:          INCBIN "gfx/pics/151/back.lz"
MachopBackpic:       INCBIN "gfx/pics/066/back.lz"
AbraBackpic:         INCBIN "gfx/pics/063/back.lz"
AerodactylBackpic:   INCBIN "gfx/pics/142/back.lz"
KakunaFrontpic:      INCBIN "gfx/pics/014/front.lz"
DugtrioBackpic:      INCBIN "gfx/pics/051/back.lz"
WeepinbellBackpic:   INCBIN "gfx/pics/070/back.lz"
NidoranFBackpic:     INCBIN "gfx/pics/029/back.lz"
GravelerBackpic:     INCBIN "gfx/pics/075/back.lz"
AipomBackpic:        INCBIN "gfx/pics/190/back.lz"
EspeonBackpic:       INCBIN "gfx/pics/196/back.lz"
WeedleFrontpic:      INCBIN "gfx/pics/013/front.lz"
TotodileBackpic:     INCBIN "gfx/pics/158/back.lz"
SnubbullBackpic:     INCBIN "gfx/pics/209/back.lz"
KinglerBackpic:      INCBIN "gfx/pics/099/back.lz"
GengarBackpic:       INCBIN "gfx/pics/094/back.lz"
RattataBackpic:      INCBIN "gfx/pics/019/back.lz"
YoungsterPic:        INCBIN "gfx/trainers/021.lz"
WillPic:             INCBIN "gfx/trainers/010.lz"
SchoolboyPic:        INCBIN "gfx/trainers/022.lz"
MagnemiteFrontpic:   INCBIN "gfx/pics/081/front.lz"
ErikaPic:            INCBIN "gfx/trainers/020.lz"
JaninePic:           INCBIN "gfx/trainers/025.lz"
MagnemiteBackpic:    INCBIN "gfx/pics/081/back.lz"
; 15bffa


SECTION "bank57",ROMX,BANK[$57]

;                           Pics XVI

HoothootBackpic:     INCBIN "gfx/pics/163/back.lz"
NoctowlBackpic:      INCBIN "gfx/pics/164/back.lz"
MortyPic:            INCBIN "gfx/trainers/003.lz"
SlugmaBackpic:       INCBIN "gfx/pics/218/back.lz"
KabutoBackpic:       INCBIN "gfx/pics/140/back.lz"
VictreebelBackpic:   INCBIN "gfx/pics/071/back.lz"
MeowthBackpic:       INCBIN "gfx/pics/052/back.lz"
MeganiumBackpic:     INCBIN "gfx/pics/154/back.lz"
PicnickerPic:        INCBIN "gfx/trainers/052.lz"
LickitungBackpic:    INCBIN "gfx/pics/108/back.lz"
TogepiFrontpic:      INCBIN "gfx/pics/175/front.lz"
SuperNerdPic:        INCBIN "gfx/trainers/040.lz"
HaunterBackpic:      INCBIN "gfx/pics/093/back.lz"
XatuBackpic:         INCBIN "gfx/pics/178/back.lz"
RedPic:              INCBIN "gfx/trainers/062.lz"
Porygon2Backpic:     INCBIN "gfx/pics/233/back.lz"
JasminePic:          INCBIN "gfx/trainers/005.lz"
PinecoBackpic:       INCBIN "gfx/pics/204/back.lz"
MetapodFrontpic:     INCBIN "gfx/pics/011/front.lz"
SeelBackpic:         INCBIN "gfx/pics/086/back.lz"
QuagsireBackpic:     INCBIN "gfx/pics/195/back.lz"
WhitneyPic:          INCBIN "gfx/trainers/001.lz"
JolteonBackpic:      INCBIN "gfx/pics/135/back.lz"
CaterpieFrontpic:    INCBIN "gfx/pics/010/front.lz"
HoppipBackpic:       INCBIN "gfx/pics/187/back.lz"
BluePic:             INCBIN "gfx/trainers/063.lz"
GranbullBackpic:     INCBIN "gfx/pics/210/back.lz"
GentlemanPic:        INCBIN "gfx/trainers/031.lz"
ExecutivemPic:       INCBIN "gfx/trainers/050.lz"
SpearowBackpic:      INCBIN "gfx/pics/021/back.lz"
SunkernBackpic:      INCBIN "gfx/pics/191/back.lz"
LaprasBackpic:       INCBIN "gfx/pics/131/back.lz"
MagbyBackpic:        INCBIN "gfx/pics/240/back.lz"
DragonairBackpic:    INCBIN "gfx/pics/148/back.lz"
ZapdosBackpic:       INCBIN "gfx/pics/145/back.lz"
ChikoritaBackpic:    INCBIN "gfx/pics/152/back.lz"
CorsolaBackpic:      INCBIN "gfx/pics/222/back.lz"
ChinchouBackpic:     INCBIN "gfx/pics/170/back.lz"
ChanseyBackpic:      INCBIN "gfx/pics/113/back.lz"
SkiploomBackpic:     INCBIN "gfx/pics/188/back.lz"
SpinarakFrontpic:    INCBIN "gfx/pics/167/front.lz"
Rival2Pic:           INCBIN "gfx/trainers/041.lz"
UnownWFrontpic:      INCBIN "gfx/pics/201w/front.lz"
CharmanderBackpic:   INCBIN "gfx/pics/004/back.lz"
RhyhornBackpic:      INCBIN "gfx/pics/111/back.lz"
UnownCFrontpic:      INCBIN "gfx/pics/201c/front.lz"
MistyPic:            INCBIN "gfx/trainers/017.lz"
BlainePic:           INCBIN "gfx/trainers/045.lz"
UnownZFrontpic:      INCBIN "gfx/pics/201z/front.lz"
SwinubFrontpic:      INCBIN "gfx/pics/220/front.lz"
LarvitarBackpic:     INCBIN "gfx/pics/246/back.lz"
PorygonBackpic:      INCBIN "gfx/pics/137/back.lz"
UnownHBackpic:       INCBIN "gfx/pics/201h/back.lz"
; 15ffff


SECTION "bank58",ROMX,BANK[$58]

;                           Pics XVII

ParasBackpic:        INCBIN "gfx/pics/046/back.lz"
VaporeonBackpic:     INCBIN "gfx/pics/134/back.lz"
TentacoolBackpic:    INCBIN "gfx/pics/072/back.lz"
ExecutivefPic:       INCBIN "gfx/trainers/054.lz"
BulbasaurBackpic:    INCBIN "gfx/pics/001/back.lz"
SmoochumBackpic:     INCBIN "gfx/pics/238/back.lz"
PichuBackpic:        INCBIN "gfx/pics/172/back.lz"
HoundoomBackpic:     INCBIN "gfx/pics/229/back.lz"
BellsproutBackpic:   INCBIN "gfx/pics/069/back.lz"
GrimerBackpic:       INCBIN "gfx/pics/088/back.lz"
LanturnBackpic:      INCBIN "gfx/pics/171/back.lz"
PidgeottoBackpic:    INCBIN "gfx/pics/017/back.lz"
StaryuBackpic:       INCBIN "gfx/pics/120/back.lz"
MrMimeBackpic:       INCBIN "gfx/pics/122/back.lz"
CaterpieBackpic:     INCBIN "gfx/pics/010/back.lz"
VoltorbFrontpic:     INCBIN "gfx/pics/100/front.lz"
LugiaBackpic:        INCBIN "gfx/pics/249/back.lz"
PrycePic:            INCBIN "gfx/trainers/004.lz"
BrockPic:            INCBIN "gfx/trainers/016.lz"
UnownGFrontpic:      INCBIN "gfx/pics/201g/front.lz"
ArbokBackpic:        INCBIN "gfx/pics/024/back.lz"
PolitoedBackpic:     INCBIN "gfx/pics/186/back.lz"
DragoniteBackpic:    INCBIN "gfx/pics/149/back.lz"
HitmonleeBackpic:    INCBIN "gfx/pics/106/back.lz"
NatuFrontpic:        INCBIN "gfx/pics/177/front.lz"
UrsaringBackpic:     INCBIN "gfx/pics/217/back.lz"
SagePic:             INCBIN "gfx/trainers/055.lz"
TeddiursaBackpic:    INCBIN "gfx/pics/216/back.lz"
PhanpyBackpic:       INCBIN "gfx/pics/231/back.lz"
UnownVFrontpic:      INCBIN "gfx/pics/201v/front.lz"
KakunaBackpic:       INCBIN "gfx/pics/014/back.lz"
WobbuffetBackpic:    INCBIN "gfx/pics/202/back.lz"
TogepiBackpic:       INCBIN "gfx/pics/175/back.lz"
CrobatBackpic:       INCBIN "gfx/pics/169/back.lz"
BlisseyBackpic:      INCBIN "gfx/pics/242/back.lz"
AmpharosBackpic:     INCBIN "gfx/pics/181/back.lz"
IgglybuffBackpic:    INCBIN "gfx/pics/174/back.lz"
AzumarillBackpic:    INCBIN "gfx/pics/184/back.lz"
OctilleryBackpic:    INCBIN "gfx/pics/224/back.lz"
UnownSFrontpic:      INCBIN "gfx/pics/201s/front.lz"
HorseaBackpic:       INCBIN "gfx/pics/116/back.lz"
SentretBackpic:      INCBIN "gfx/pics/161/back.lz"
UnownOFrontpic:      INCBIN "gfx/pics/201o/front.lz"
UnownTFrontpic:      INCBIN "gfx/pics/201t/front.lz"
WigglytuffBackpic:   INCBIN "gfx/pics/040/back.lz"
ArticunoBackpic:     INCBIN "gfx/pics/144/back.lz"
DittoBackpic:        INCBIN "gfx/pics/132/back.lz"
WeedleBackpic:       INCBIN "gfx/pics/013/back.lz"
UnownHFrontpic:      INCBIN "gfx/pics/201h/front.lz"
CleffaBackpic:       INCBIN "gfx/pics/173/back.lz"
DrowzeeBackpic:      INCBIN "gfx/pics/096/back.lz"
GastlyBackpic:       INCBIN "gfx/pics/092/back.lz"
FearowBackpic:       INCBIN "gfx/pics/022/back.lz"
MarillBackpic:       INCBIN "gfx/pics/183/back.lz"
DratiniBackpic:      INCBIN "gfx/pics/147/back.lz"
ElectrodeBackpic:    INCBIN "gfx/pics/101/back.lz"
SkarmoryBackpic:     INCBIN "gfx/pics/227/back.lz"
MetapodBackpic:      INCBIN "gfx/pics/011/back.lz"
JigglypuffBackpic:   INCBIN "gfx/pics/039/back.lz"
OddishBackpic:       INCBIN "gfx/pics/043/back.lz"
UnownDBackpic:       INCBIN "gfx/pics/201d/back.lz"
; 163ffc


SECTION "bank59",ROMX,BANK[$59]

;                           Pics XVIII

SpinarakBackpic:     INCBIN "gfx/pics/167/back.lz"
RaikouBackpic:       INCBIN "gfx/pics/243/back.lz"
UnownKFrontpic:      INCBIN "gfx/pics/201k/front.lz"
HoundourBackpic:     INCBIN "gfx/pics/228/back.lz"
PoliwagBackpic:      INCBIN "gfx/pics/060/back.lz"
SquirtleBackpic:     INCBIN "gfx/pics/007/back.lz"
ShuckleBackpic:      INCBIN "gfx/pics/213/back.lz"
DewgongBackpic:      INCBIN "gfx/pics/087/back.lz"
UnownBFrontpic:      INCBIN "gfx/pics/201b/front.lz"
SlowpokeBackpic:     INCBIN "gfx/pics/079/back.lz"
DunsparceBackpic:    INCBIN "gfx/pics/206/back.lz"
DonphanBackpic:      INCBIN "gfx/pics/232/back.lz"
WooperBackpic:       INCBIN "gfx/pics/194/back.lz"
TaurosBackpic:       INCBIN "gfx/pics/128/back.lz"
UnownXFrontpic:      INCBIN "gfx/pics/201x/front.lz"
UnownNFrontpic:      INCBIN "gfx/pics/201n/front.lz"
TangelaBackpic:      INCBIN "gfx/pics/114/back.lz"
VoltorbBackpic:      INCBIN "gfx/pics/100/back.lz"
UnownJFrontpic:      INCBIN "gfx/pics/201j/front.lz"
MantineBackpic:      INCBIN "gfx/pics/226/back.lz"
UnownLFrontpic:      INCBIN "gfx/pics/201l/front.lz"
PiloswineBackpic:    INCBIN "gfx/pics/221/back.lz"
UnownMFrontpic:      INCBIN "gfx/pics/201m/front.lz"
UnownFFrontpic:      INCBIN "gfx/pics/201f/front.lz"
NatuBackpic:         INCBIN "gfx/pics/177/back.lz"
UnownAFrontpic:      INCBIN "gfx/pics/201a/front.lz"
GolemBackpic:        INCBIN "gfx/pics/076/back.lz"
UnownUFrontpic:      INCBIN "gfx/pics/201u/front.lz"
DiglettBackpic:      INCBIN "gfx/pics/050/back.lz"
UnownQFrontpic:      INCBIN "gfx/pics/201q/front.lz"
UnownPFrontpic:      INCBIN "gfx/pics/201p/front.lz"
UnownCBackpic:       INCBIN "gfx/pics/201c/back.lz"
JynxBackpic:         INCBIN "gfx/pics/124/back.lz"
GolbatBackpic:       INCBIN "gfx/pics/042/back.lz"
UnownYFrontpic:      INCBIN "gfx/pics/201y/front.lz"
UnownGBackpic:       INCBIN "gfx/pics/201g/back.lz"
UnownIFrontpic:      INCBIN "gfx/pics/201i/front.lz"
UnownVBackpic:       INCBIN "gfx/pics/201v/back.lz"
ForretressBackpic:   INCBIN "gfx/pics/205/back.lz"
UnownSBackpic:       INCBIN "gfx/pics/201s/back.lz"
UnownRFrontpic:      INCBIN "gfx/pics/201r/front.lz"
UnownEBackpic:       INCBIN "gfx/pics/201e/back.lz"
UnownJBackpic:       INCBIN "gfx/pics/201j/back.lz"
UnownBBackpic:       INCBIN "gfx/pics/201b/back.lz"
UnownOBackpic:       INCBIN "gfx/pics/201o/back.lz"
UnownZBackpic:       INCBIN "gfx/pics/201z/back.lz"
UnownWBackpic:       INCBIN "gfx/pics/201w/back.lz"
UnownNBackpic:       INCBIN "gfx/pics/201n/back.lz"
UnownABackpic:       INCBIN "gfx/pics/201a/back.lz"
UnownMBackpic:       INCBIN "gfx/pics/201m/back.lz"
UnownKBackpic:       INCBIN "gfx/pics/201k/back.lz"
UnownTBackpic:       INCBIN "gfx/pics/201t/back.lz"
UnownXBackpic:       INCBIN "gfx/pics/201x/back.lz"
UnownLBackpic:       INCBIN "gfx/pics/201l/back.lz"
UnownUBackpic:       INCBIN "gfx/pics/201u/back.lz"
UnownQBackpic:       INCBIN "gfx/pics/201q/back.lz"
UnownYBackpic:       INCBIN "gfx/pics/201y/back.lz"
UnownPBackpic:       INCBIN "gfx/pics/201p/back.lz"
UnownIBackpic:       INCBIN "gfx/pics/201i/back.lz"
UnownRBackpic:       INCBIN "gfx/pics/201r/back.lz"
; 1669d3


SECTION "bank5A",ROMX,BANK[$5A]

; This bank is identical to bank 59!
; It's also unreferenced, so it's a free bank

INCBIN "gfx/pics/167/back.lz"
INCBIN "gfx/pics/243/back.lz"
INCBIN "gfx/pics/201k/front.lz"
INCBIN "gfx/pics/228/back.lz"
INCBIN "gfx/pics/060/back.lz"
INCBIN "gfx/pics/007/back.lz"
INCBIN "gfx/pics/213/back.lz"
INCBIN "gfx/pics/087/back.lz"
INCBIN "gfx/pics/201b/front.lz"
INCBIN "gfx/pics/079/back.lz"
INCBIN "gfx/pics/206/back.lz"
INCBIN "gfx/pics/232/back.lz"
INCBIN "gfx/pics/194/back.lz"
INCBIN "gfx/pics/128/back.lz"
INCBIN "gfx/pics/201x/front.lz"
INCBIN "gfx/pics/201n/front.lz"
INCBIN "gfx/pics/114/back.lz"
INCBIN "gfx/pics/100/back.lz"
INCBIN "gfx/pics/201j/front.lz"
INCBIN "gfx/pics/226/back.lz"
INCBIN "gfx/pics/201l/front.lz"
INCBIN "gfx/pics/221/back.lz"
INCBIN "gfx/pics/201m/front.lz"
INCBIN "gfx/pics/201f/front.lz"
INCBIN "gfx/pics/177/back.lz"
INCBIN "gfx/pics/201a/front.lz"
INCBIN "gfx/pics/076/back.lz"
INCBIN "gfx/pics/201u/front.lz"
INCBIN "gfx/pics/050/back.lz"
INCBIN "gfx/pics/201q/front.lz"
INCBIN "gfx/pics/201p/front.lz"
INCBIN "gfx/pics/201c/back.lz"
INCBIN "gfx/pics/124/back.lz"
INCBIN "gfx/pics/042/back.lz"
INCBIN "gfx/pics/201y/front.lz"
INCBIN "gfx/pics/201g/back.lz"
INCBIN "gfx/pics/201i/front.lz"
INCBIN "gfx/pics/201v/back.lz"
INCBIN "gfx/pics/205/back.lz"
INCBIN "gfx/pics/201s/back.lz"
INCBIN "gfx/pics/201r/front.lz"
INCBIN "gfx/pics/201e/back.lz"
INCBIN "gfx/pics/201j/back.lz"
INCBIN "gfx/pics/201b/back.lz"
INCBIN "gfx/pics/201o/back.lz"
INCBIN "gfx/pics/201z/back.lz"
INCBIN "gfx/pics/201w/back.lz"
INCBIN "gfx/pics/201n/back.lz"
INCBIN "gfx/pics/201a/back.lz"
INCBIN "gfx/pics/201m/back.lz"
INCBIN "gfx/pics/201k/back.lz"
INCBIN "gfx/pics/201t/back.lz"
INCBIN "gfx/pics/201x/back.lz"
INCBIN "gfx/pics/201l/back.lz"
INCBIN "gfx/pics/201u/back.lz"
INCBIN "gfx/pics/201q/back.lz"
INCBIN "gfx/pics/201y/back.lz"
INCBIN "gfx/pics/201p/back.lz"
INCBIN "gfx/pics/201i/back.lz"
INCBIN "gfx/pics/201r/back.lz"


SECTION "bank5B",ROMX,BANK[$5B]

INCBIN "baserom.gbc", $16c000, $16d69a - $16c000


Function16d69a: ; 16d69a
	ld de, $52c1
	ld hl, $9760
	ld bc, $5b08
	call Get2bpp
	ret
; 16d6a7

INCBIN "baserom.gbc", $16d6a7, $16d7fe - $16d6a7


SECTION "bank5C",ROMX,BANK[$5C]

INCBIN "baserom.gbc", $170000, $170923 - $170000


Function170923: ; 170923
	ld a, $5
	call GetSRAMBank
	xor a
	ld [$aa48], a
	ld [$aa47], a
	ld hl, $aa5d
	ld bc, $0011
	call ByteFill
	call CloseSRAM
	ret
; 17093c

INCBIN "baserom.gbc", $17093c, $17367f - $17093c


SECTION "bank5D",ROMX,BANK[$5D]

INCLUDE "text/phone/extra3.asm"


SECTION "bank5E",ROMX,BANK[$5E]

INCBIN "baserom.gbc", $178000, $1f

;                          Songs V

Music_MobileAdapterMenu: INCLUDE "audio/music/mobileadaptermenu.asm"
Music_BuenasPassword:    INCLUDE "audio/music/buenaspassword.asm"
Music_LookMysticalMan:   INCLUDE "audio/music/lookmysticalman.asm"
Music_CrystalOpening:    INCLUDE "audio/music/crystalopening.asm"
Music_BattleTowerTheme:  INCLUDE "audio/music/battletowertheme.asm"
Music_SuicuneBattle:     INCLUDE "audio/music/suicunebattle.asm"
Music_BattleTowerLobby:  INCLUDE "audio/music/battletowerlobby.asm"
Music_MobileCenter:      INCLUDE "audio/music/mobilecenter.asm"

INCBIN "baserom.gbc", $17982d, $1799ef - $17982d

MobileAdapterGFX:
INCBIN "gfx/misc/mobile_adapter.2bpp"

INCBIN "baserom.gbc", $17a68f, $17b629 - $17a68f


SECTION "bank5F",ROMX,BANK[$5F]

Function17c000: ; 17c000
	call DisableLCD
	ld hl, VTiles2
	ld bc, $0310
	xor a
	call ByteFill
	call Functione51
	call Functione5f
	ld hl, $4b83
	ld de, TileMap
	ld bc, AttrMap
	ld a, $12
.asm_17c01e
	push af
	ld a, $14
	push hl
.asm_17c022
	push af
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [bc], a
	inc bc
	pop af
	dec a
	jr nz, .asm_17c022
	pop hl
	push bc
	ld bc, $0040
	add hl, bc
	pop bc
	pop af
	dec a
	jr nz, .asm_17c01e
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, $4ff3
	ld de, $d000
	ld bc, $0080
	call CopyBytes
	pop af
	ld [rSVBK], a
	ld hl, $4983
	ld de, $8300
	ld bc, $0200
	call CopyBytes
	ld a, $1
	ld [rVBK], a
	ld hl, $4083
	ld de, VTiles2
	ld bc, $0800
	call CopyBytes
	ld hl, $4883
	ld de, VTiles1
	ld bc, Start
	call CopyBytes
	xor a
	ld [rVBK], a
	call EnableLCD
	ld a, $41
	ld hl, $4061
	rst FarCall
	ret
; 17c083

INCBIN "baserom.gbc", $17c083, $17f036 - $17c083


Function17f036: ; 17f036
	ld a, $6
	call GetSRAMBank
	inc de
.asm_17f03c
	call Function17f047
	jr c, .asm_17f043
	jr .asm_17f03c

.asm_17f043
	call CloseSRAM
	ret
; 17f047

Function17f047: ; 17f047
	ld a, [de]
	inc de
	cp $50
	jr z, .asm_17f05f
	cp $10
	jr nc, .asm_17f05f
	dec a
	push de
	ld e, a
	ld d, 0
	ld hl, Table17f061
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

.asm_17f05f
	scf
	ret
; 17f061

Table17f061: ; 17f061
	dw Function17f081
	dw Function17f0f8
	dw Function17f154
	dw Function17f181
	dw Function17f1d0
	dw Function17f220
	dw Function17f27b
	dw Function17f2cb
	dw Function17f2ff
	dw Function17f334
	dw Function17f382
	dw Function17f3c9
	dw Function17f3f0
	dw Function17f41d
	dw Function17f44f
	dw Function17f44f
; 17f081

Function17f081: ; 17f081
	pop hl
	call Function17f524
	jr c, .asm_17f09f
	ld de, $0004
	add hl, de
	ld a, [hli]
	inc hl
	inc hl
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [de]
	cp $50
	jr z, .asm_17f09d
	and a
	ret

.asm_17f09d
	scf
	ret

.asm_17f09f
	push bc
	ld de, $cd54
	ld bc, $0007
	call CopyBytes
	pop bc
	push hl
	push bc
	call Function17f4f6
	pop bc
	ld a, [$cd54]
	ld e, a
	ld a, [$cd55]
	ld d, a
	add hl, de
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	push hl
	ld a, [$cd56]
	ld b, a
	ld a, [$cd57]
	ld c, a
	call Function31a4
	ld a, l
	ld [$cd52], a
	ld a, h
	ld [$cd53], a
	ld a, [$cd59]
	and a
	jr z, .asm_17f0ee
	ld c, a
	ld a, [$cd57]
	inc a
	ld b, a
	ld e, l
	ld d, h
	dec de
.asm_17f0e0
	ld a, c
	cp b
	jr z, .asm_17f0ea
	ld a, [de]
	dec de
	ld [hld], a
	dec b
	jr .asm_17f0e0

.asm_17f0ea
	ld a, [$cd5a]
	ld [hl], a

.asm_17f0ee
	pop hl
	ld a, [$cd58]
	call Function17f50f
	pop de
	and a
	ret
; 17f0f8

Function17f0f8: ; 17f0f8
	pop hl
	call Function17f524
	jr c, .asm_17f114
	ld de, $0003
	add hl, de
	ld a, [hli]
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [de]
	cp $50
	jr z, .asm_17f112
	and a
	ret

.asm_17f112
	scf
	ret

.asm_17f114
	push bc
	ld de, $cd54
	ld bc, $0004
	call CopyBytes
	pop bc
	push hl
	push bc
	call Function17f4f6
	ld a, [$cd54]
	ld e, a
	ld a, [$cd55]
	ld d, a
	add hl, de
	ld de, EnemyMoveAnimation
	ld a, [$cd56]
	ld c, a
	ld b, $0
	call CopyBytes
	ld a, $50
	ld [de], a
	pop hl
	ld de, EnemyMoveAnimation
	call PlaceString
	ld a, c
	ld [$cd52], a
	ld a, b
	ld [$cd53], a
	ld a, [$cd57]
	call Function17f50f
	pop de
	and a
	ret
; 17f154

Function17f154: ; 17f154
	pop hl
	call Function17f524
	jr c, .asm_17f167
	inc hl
	inc hl
	ld e, l
	ld d, h
	ld a, [de]
	cp $50
	jr z, .asm_17f165
	and a
	ret

.asm_17f165
	scf
	ret

.asm_17f167
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	pop bc
	push hl
	push bc
	call Function17f4f6
	add hl, de
	ld c, l
	ld b, h
	pop de
	callba Function11c08f
	ld c, l
	ld b, h
	pop de
	and a
	ret
; 17f181

Function17f181: ; 17f181
	pop hl
	call Function17f524
	jr c, .asm_17f19d
	ld de, $0002
	add hl, de
	ld a, [hli]
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [de]
	cp $50
	jr z, .asm_17f19b
	and a
	ret

.asm_17f19b
	scf
	ret

.asm_17f19d
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld [$cd54], a
	pop bc
	push hl
	push bc
	call Function17f4f6
	add hl, de
	ld a, [hl]
	ld c, a
	ld de, EnemyMoveAnimation
	callba Function48c63
	pop hl
	ld de, EnemyMoveAnimation
	call PlaceString
	ld a, c
	ld [$cd52], a
	ld a, b
	ld [$cd53], a
	ld a, [$cd54]
	call Function17f50f
	pop de
	and a
	ret
; 17f1d0

Function17f1d0: ; 17f1d0
	pop hl
	call Function17f524
	jr c, .asm_17f1ec
	ld de, $0002
	add hl, de
	ld a, [hli]
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [de]
	cp $50
	jr z, .asm_17f1ea
	and a
	ret

.asm_17f1ea
	scf
	ret

.asm_17f1ec
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld [$cd54], a
	pop bc
	push hl
	push bc
	call Function17f4f6
	add hl, de
	ld a, [hl]
	ld a, $1
	ld [rSVBK], a
	ld [$d265], a
	call GetPokemonName
	pop hl
	call PlaceString
	ld a, c
	ld [$cd52], a
	ld a, b
	ld [$cd53], a
	ld a, $4
	ld [rSVBK], a
	ld a, [$cd54]
	call Function17f50f
	pop de
	and a
	ret
; 17f220

Function17f220: ; 17f220
	pop hl
	call Function17f524
	jr c, .asm_17f23c
	ld de, $0002
	add hl, de
	ld a, [hli]
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [de]
	cp $50
	jr z, .asm_17f23a
	and a
	ret

.asm_17f23a
	scf
	ret

.asm_17f23c
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld [$cd54], a
	pop bc
	push hl
	push bc
	call Function17f4f6
	add hl, de
	ld a, [hl]
	ld e, a
	ld d, $0
	ld hl, $726e
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	pop hl
	call PlaceString
	ld a, c
	ld [$cd52], a
	ld a, b
	ld [$cd53], a
	ld a, [$cd54]
	call Function17f50f
	pop de
	and a
	ret
; 17f26e

INCBIN "baserom.gbc", $17f26e, $17f27b - $17f26e

Function17f27b: ; 17f27b
	pop hl
	call Function17f524
	jr c, .asm_17f297
	ld de, $0002
	add hl, de
	ld a, [hli]
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [de]
	cp $50
	jr z, .asm_17f295
	and a
	ret

.asm_17f295
	scf
	ret

.asm_17f297
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld [$cd54], a
	pop bc
	push hl
	push bc
	call Function17f4f6
	add hl, de
	ld a, [hl]
	ld a, $1
	ld [rSVBK], a
	ld [$d265], a
	call GetItemName
	pop hl
	call PlaceString
	ld a, c
	ld [$cd52], a
	ld a, b
	ld [$cd53], a
	ld a, $4
	ld [rSVBK], a
	ld a, [$cd54]
	call Function17f50f
	pop de
	and a
	ret
; 17f2cb

Function17f2cb: ; 17f2cb
	pop hl
	push bc
	ld a, [hli]
	ld [$cd54], a
	ld a, [hli]
	ld [$cd55], a
	ld a, [$cd2e]
	inc a
	ld [$cd56], a
	pop bc
	push hl
	ld l, c
	ld h, b
	push hl
	ld de, $cd56
	ld b, $1
	ld a, [$cd54]
	ld c, a
	call Function31a4
	ld a, l
	ld [$cd52], a
	ld a, h
	ld [$cd53], a
	pop hl
	ld a, [$cd55]
	call Function17f50f
	pop de
	and a
	ret
; 17f2ff

Function17f2ff: ; 17f2ff
	pop hl
	push bc
	ld a, [hli]
	ld [$cd54], a
	pop bc
	push hl
	push bc
	ld a, $1
	ld [rSVBK], a
	ld hl, PlayerName
	ld de, EnemyMoveAnimation
	ld bc, $0006
	call CopyBytes
	ld a, $4
	ld [rSVBK], a
	pop hl
	ld de, EnemyMoveAnimation
	call PlaceString
	ld a, c
	ld [$cd52], a
	ld a, b
	ld [$cd53], a
	ld a, [$cd54]
	call Function17f50f
	pop de
	and a
	ret
; 17f334

Function17f334: ; 17f334
	pop hl
	push bc
	ld a, [hli]
	ld [$cd55], a
	and $f
	ld [$cd54], a
	pop bc
	push hl
	ld l, c
	ld h, b
	push hl
	ld a, [$cd55]
	bit 7, a
	jr nz, .asm_17f355
	ld a, $1
	call GetSRAMBank
	ld a, [$be3f]
	jr .asm_17f35d

.asm_17f355
	ld a, $5
	call GetSRAMBank
	ld a, [$b2f3]

.asm_17f35d
	ld c, a
	call CloseSRAM
	ld de, EnemyMoveAnimation
	callba Function48c63
	pop hl
	ld de, EnemyMoveAnimation
	call PlaceString
	ld a, c
	ld [$cd52], a
	ld a, b
	ld [$cd53], a
	ld a, [$cd54]
	call Function17f50f
	pop de
	and a
	ret
; 17f382

Function17f382: ; 17f382
	pop hl
	push bc
	ld a, [hli]
	ld [$cd55], a
	and $f
	ld [$cd54], a
	pop bc
	push hl
	push bc
	ld l, c
	ld h, b
	ld a, [$cd55]
	bit 7, a
	jr nz, .asm_17f3a3
	ld a, $1
	call GetSRAMBank
	ld de, $be40
	jr .asm_17f3ab

.asm_17f3a3
	ld a, $5
	call GetSRAMBank
	ld de, $b2f4

.asm_17f3ab
	ld a, $82
	ld b, a
	ld a, $3
	ld c, a
	call PrintNum
	call CloseSRAM
	ld a, l
	ld [$cd52], a
	ld a, h
	ld [$cd53], a
	pop hl
	ld a, [$cd54]
	call Function17f50f
	pop de
	and a
	ret
; 17f3c9

Function17f3c9: ; 17f3c9
	push bc
	ld hl, $cd36
	ld de, $c708
	ld bc, $000c
	call CopyBytes
	pop de
	ld c, $0
	callba Function11c075
	push hl
	ld hl, $c708
	ld de, $cd36
	ld bc, $000c
	call CopyBytes
	pop bc
	pop de
	and a
	ret
; 17f3f0

Function17f3f0: ; 17f3f0
	pop hl
	push hl
	ld a, [hli]
	push af
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	ld c, a
	ld b, $0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld hl, Unkn1Pals
	add hl, de
	ld e, l
	ld d, h
	pop hl
	call PlaceString
	pop af
	ld e, a
	ld d, $0
	pop hl
	add hl, de
	add hl, de
	inc hl
	inc hl
	inc hl
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	scf
	ret
; 17f41d

Function17f41d: ; 17f41d
	pop hl
	ld a, [hli]
	push hl
	push af
	ld l, c
	ld h, b
	ld bc, $3b60
	add hl, bc
	ld de, $ffec
	ld c, $1
.asm_17f42c
	ld a, h
	and a
	jr nz, .asm_17f435
	ld a, l
	cp $14
	jr c, .asm_17f439

.asm_17f435
	add hl, de
	inc c
	jr .asm_17f42c

.asm_17f439
	ld hl, TileMap
	ld de, $0014
	ld a, c
.asm_17f440
	and a
	jr z, .asm_17f447
	add hl, de
	dec a
	jr .asm_17f440

.asm_17f447
	pop af
	ld e, a
	ld d, $0
	add hl, de
	pop de
	and a
	ret
; 17f44f

Function17f44f: ; 17f44f
	pop hl
	call Function17f524
	jr c, .asm_17f46d
	ld de, $0005
	add hl, de
	ld a, [hli]
	inc hl
	inc hl
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [de]
	cp $50
	jr z, .asm_17f46b
	and a
	ret

.asm_17f46b
	scf
	ret

.asm_17f46d
	push bc
	ld de, $cd54
	ld bc, $0008
	call CopyBytes
	pop bc
	push hl
	push bc
	ld a, [$cd56]
	cp $c0
	jr c, .asm_17f488
	ld a, [$cd54]
	ld [rSVBK], a
	jr .asm_17f48e

.asm_17f488
	ld a, [$cd54]
	call GetSRAMBank

.asm_17f48e
	ld a, [$cd55]
	ld l, a
	ld a, [$cd56]
	ld h, a
	ld de, EnemyMoveAnimation
	ld a, [$cd57]
	ld c, a
	ld b, $0
	call CopyBytes
	ld a, [$cd56]
	cp $c0
	jr c, .asm_17f4af
	ld a, $4
	ld [rSVBK], a
	jr .asm_17f4b7

.asm_17f4af
	call CloseSRAM
	ld a, $6
	call GetSRAMBank

.asm_17f4b7
	ld de, EnemyMoveAnimation
	pop hl
	push hl
	ld a, [$cd57]
	ld b, a
	ld a, [$cd58]
	ld c, a
	call Function31a4
	ld a, l
	ld [$cd52], a
	ld a, h
	ld [$cd53], a
	ld a, [$cd5a]
	and a
	jr z, .asm_17f4ec
	ld c, a
	ld a, [$cd58]
	inc a
	ld b, a
	ld e, l
	ld d, h
	dec de
.asm_17f4de
	ld a, c
	cp b
	jr z, .asm_17f4e8
	ld a, [de]
	dec de
	ld [hld], a
	dec b
	jr .asm_17f4de

.asm_17f4e8
	ld a, [$cd5b]
	ld [hl], a

.asm_17f4ec
	pop hl
	ld a, [$cd59]
	call Function17f50f
	pop de
	and a
	ret
; 17f4f6

Function17f4f6: ; 17f4f6
	ld a, [$cd6a]
	ld l, a
	ld a, [$cd6b]
	ld h, a
	ld a, [$cd47]
	ld c, a
	ld a, [BGMapPalBuffer]
	ld b, a
	ld a, [$cd2e]
.asm_17f509
	and a
	ret z
	dec a
	add hl, bc
	jr .asm_17f509
; 17f50f

Function17f50f: ; 17f50f
	and a
	jr z, .asm_17f519
	ld c, a
	ld b, $0
	add hl, bc
	ld c, l
	ld b, h
	ret

.asm_17f519
	ld a, [$cd52]
	ld c, a
	ld l, a
	ld a, [$cd53]
	ld b, a
	ld h, a
	ret
; 17f524

Function17f524: ; 17f524
	push hl
	push bc
	push de
	ld a, [$cd42]
	dec a
	ld b, a
	ld a, [$cd2e]
	cp b
	jr z, .asm_17f53a
	ld hl, $cd68
	cp [hl]
.asm_17f536
	pop de
	pop bc
	pop hl
	ret

.asm_17f53a
	scf
	jr .asm_17f536
; 17f53d

INCBIN "baserom.gbc", $17f53d, $17f555 - $17f53d

Function17f555: ; 17f555
.asm_17f555
	call Functiona57
	call Function17f5ae
	ld a, [$c303]
	bit 7, a
	jr nz, .asm_17f56a
	callba Function104000
	jr .asm_17f555

.asm_17f56a
	call Function17f56e
	ret
; 17f56e

Function17f56e: ; 17f56e
	ld a, [$c300]
	cp $22
	jr z, .asm_17f597
	cp $31
	jr z, .asm_17f58a
	cp $33
	ret nz
	ld a, [$c301]
	cp $1
	ret nz
	ld a, [$c302]
	cp $2
	ret nz
	jr .asm_17f5a1

.asm_17f58a
	ld a, [$c301]
	cp $3
	ret nz
	ld a, [$c302]
	and a
	ret nz
	jr .asm_17f5a1

.asm_17f597
	ld a, [$c301]
	and a
	ret nz
	ld a, [$c302]
	and a
	ret nz

.asm_17f5a1
	ld a, $5
	call GetSRAMBank
	xor a
	ld [$aa4b], a
	call CloseSRAM
	ret
; 17f5ae

Function17f5ae: ; 17f5ae
	ld a, [$c303]
	ld e, a
	ld d, 0
	ld hl, Table17f5bd
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 17f5bd

Table17f5bd: ; 17f5bd
	dw Function17f5c3
	dw Function17ff23
	dw Function17f5d2
; 17f5c3

Function17f5c3: ; 17f5c3
	call Function17f5e4
	callba Function2b5c
	ld a, $1
	ld [$c303], a
	ret
; 17f5d2

Function17f5d2: ; 17f5d2
	call Function17f5e4
	callba Function104000
	call Function32f9
	ld a, $1
	ld [$c303], a
	ret
; 17f5e4

Function17f5e4: ; 17f5e4
	ld a, $8
	ld [MusicFade], a
	ld de, MUSIC_NONE
	ld a, e
	ld [MusicFadeIDLo], a
	ld a, d
	ld [MusicFadeIDHi], a
	ld a, " "
	ld hl, TileMap
	ld bc, $0168
	call ByteFill
	ld a, $6
	ld hl, AttrMap
	ld bc, $0168
	call ByteFill
	ld hl, $c4b6
	ld b, $1
	ld c, $e
	call Function3eea
	ld hl, $c4f1
	ld b, $c
	ld c, $10
	call Function3eea
	ld hl, $c4cb
	ld de, $76dc
	call PlaceString
	call Function17ff3c
	jr nc, .asm_17f632
	ld hl, $c4d3
	call Function17f6b7

.asm_17f632
	ld a, [$c300]
	cp $d0
	jr nc, .asm_17f684
	cp $10
	jr c, .asm_17f679
	sub $10
	cp $24
	jr nc, .asm_17f679
	ld e, a
	ld d, $0
	ld hl, $7706
	add hl, de
	add hl, de
	ld a, [$c301]
	ld e, a
	ld a, [$c302]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld h, a
	ld l, c
	ld a, [hli]
	and a
	jr z, .asm_17f679
	ld c, a
.asm_17f65d
	ld a, [hli]
	ld b, a
	ld a, [hli]
	cp $ff
	jr nz, .asm_17f667
	cp b
	jr z, .asm_17f66e

.asm_17f667
	xor d
	jr nz, .asm_17f674
	ld a, b
	xor e
	jr nz, .asm_17f674

.asm_17f66e
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	jr .asm_17f67d

.asm_17f674
	inc hl
	inc hl
	dec c
	jr nz, .asm_17f65d

.asm_17f679
	ld a, $d9
	jr .asm_17f684

.asm_17f67d
	ld hl, $c51a
	call PlaceString
	ret

.asm_17f684
	sub $d0
	ld e, a
	ld d, $0
	ld hl, $7699
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, $c51a
	call PlaceString
	ret
; 17f699

INCBIN "baserom.gbc", $17f699, $17f6b7 - $17f699

Function17f6b7: ; 17f6b7
	ld a, [$c300]
	call Function17f6cd
	inc hl
	ld a, [$c302]
	and $f
	call Function17f6d8
	ld a, [$c301]
	call Function17f6cd
	ret
; 17f6cd

Function17f6cd: ; 17f6cd
	ld c, a
	and $f0
	swap a
	call Function17f6d8
	ld a, c
	and $f

Function17f6d8: ; 17f6d8
	add $f6
	ld [hli], a
	ret
; 17f6dc

INCBIN "baserom.gbc", $17f6dc, $17ff23 - $17f6dc

Function17ff23: ; 17ff23
	ld a, [hJoyPressed]
	and a
	ret z
	ld a, $8
	ld [MusicFade], a
	ld a, [CurMusic]
	ld [MusicFadeIDLo], a
	xor a
	ld [MusicFadeIDHi], a
	ld hl, $c303
	set 7, [hl]
	ret
; 17ff3c

Function17ff3c: ; 17ff3c
	nop
	ld a, [$c300]
	cp $d0
	ret c
	ld hl, $c4d2
	ld de, $7f68
	call PlaceString
	ld a, [$c300]
	push af
	sub $d0
	inc a
	ld [$c300], a
	ld hl, $c4d6
	ld de, $c300
	ld bc, $8103
	call PrintNum
	pop af
	ld [$c300], a
	and a
	ret
; 17ff68

INCBIN "baserom.gbc", $17ff68, $17ff6c - $17ff68


SECTION "bank60",ROMX,BANK[$60]

;                        Map Scripts XIII

INCLUDE "maps/IndigoPlateauPokeCenter1F.asm"
INCLUDE "maps/WillsRoom.asm"
INCLUDE "maps/KogasRoom.asm"
INCLUDE "maps/BrunosRoom.asm"
INCLUDE "maps/KarensRoom.asm"
INCLUDE "maps/LancesRoom.asm"
INCLUDE "maps/HallOfFame.asm"


;                       Pokedex entries I
;                            001-064
PokedexEntries1:
INCLUDE "stats/pokedex/entries_1.asm"


SECTION "bank61",ROMX,BANK[$61]

;                        Map Scripts XIV

INCLUDE "maps/CeruleanCity.asm"
INCLUDE "maps/SproutTower1F.asm"
INCLUDE "maps/SproutTower2F.asm"
INCLUDE "maps/SproutTower3F.asm"
INCLUDE "maps/TinTower1F.asm"
INCLUDE "maps/TinTower2F.asm"
INCLUDE "maps/TinTower3F.asm"
INCLUDE "maps/TinTower4F.asm"
INCLUDE "maps/TinTower5F.asm"
INCLUDE "maps/TinTower6F.asm"
INCLUDE "maps/TinTower7F.asm"
INCLUDE "maps/TinTower8F.asm"
INCLUDE "maps/TinTower9F.asm"
INCLUDE "maps/BurnedTower1F.asm"
INCLUDE "maps/BurnedTowerB1F.asm"


SECTION "bank62",ROMX,BANK[$62]

;                         Map Scripts XV

INCLUDE "maps/CeruleanGymBadgeSpeechHouse.asm"
INCLUDE "maps/CeruleanPoliceStation.asm"
INCLUDE "maps/CeruleanTradeSpeechHouse.asm"
INCLUDE "maps/CeruleanPokeCenter1F.asm"
INCLUDE "maps/CeruleanPokeCenter2FBeta.asm"
INCLUDE "maps/CeruleanGym.asm"
INCLUDE "maps/CeruleanMart.asm"
INCLUDE "maps/Route10PokeCenter1F.asm"
INCLUDE "maps/Route10PokeCenter2FBeta.asm"
INCLUDE "maps/PowerPlant.asm"
INCLUDE "maps/BillsHouse.asm"
INCLUDE "maps/FightingDojo.asm"
INCLUDE "maps/SaffronGym.asm"
INCLUDE "maps/SaffronMart.asm"
INCLUDE "maps/SaffronPokeCenter1F.asm"
INCLUDE "maps/SaffronPokeCenter2FBeta.asm"
INCLUDE "maps/MrPsychicsHouse.asm"
INCLUDE "maps/SaffronTrainStation.asm"
INCLUDE "maps/SilphCo1F.asm"
INCLUDE "maps/CopycatsHouse1F.asm"
INCLUDE "maps/CopycatsHouse2F.asm"
INCLUDE "maps/Route5UndergroundEntrance.asm"
INCLUDE "maps/Route5SaffronCityGate.asm"
INCLUDE "maps/Route5CleanseTagSpeechHouse.asm"


SECTION "bank63",ROMX,BANK[$63]

;                        Map Scripts XVI

INCLUDE "maps/PewterCity.asm"
INCLUDE "maps/WhirlIslandNW.asm"
INCLUDE "maps/WhirlIslandNE.asm"
INCLUDE "maps/WhirlIslandSW.asm"
INCLUDE "maps/WhirlIslandCave.asm"
INCLUDE "maps/WhirlIslandSE.asm"
INCLUDE "maps/WhirlIslandB1F.asm"
INCLUDE "maps/WhirlIslandB2F.asm"
INCLUDE "maps/WhirlIslandLugiaChamber.asm"
INCLUDE "maps/SilverCaveRoom1.asm"
INCLUDE "maps/SilverCaveRoom2.asm"
INCLUDE "maps/SilverCaveRoom3.asm"
INCLUDE "maps/SilverCaveItemRooms.asm"
INCLUDE "maps/DarkCaveVioletEntrance.asm"
INCLUDE "maps/DarkCaveBlackthornEntrance.asm"
INCLUDE "maps/DragonsDen1F.asm"
INCLUDE "maps/DragonsDenB1F.asm"
INCLUDE "maps/DragonShrine.asm"
INCLUDE "maps/TohjoFalls.asm"
INCLUDE "maps/AzaleaPokeCenter1F.asm"
INCLUDE "maps/CharcoalKiln.asm"
INCLUDE "maps/AzaleaMart.asm"
INCLUDE "maps/KurtsHouse.asm"
INCLUDE "maps/AzaleaGym.asm"


SECTION "bank64",ROMX,BANK[$64]

;                        Map Scripts XVII

INCLUDE "maps/MahoganyTown.asm"
INCLUDE "maps/Route32.asm"
INCLUDE "maps/VermilionHouseFishingSpeechHouse.asm"
INCLUDE "maps/VermilionPokeCenter1F.asm"
INCLUDE "maps/VermilionPokeCenter2FBeta.asm"
INCLUDE "maps/PokemonFanClub.asm"
INCLUDE "maps/VermilionMagnetTrainSpeechHouse.asm"
INCLUDE "maps/VermilionMart.asm"
INCLUDE "maps/VermilionHouseDiglettsCaveSpeechHouse.asm"
INCLUDE "maps/VermilionGym.asm"
INCLUDE "maps/Route6SaffronGate.asm"
INCLUDE "maps/Route6UndergroundEntrance.asm"
INCLUDE "maps/PokeCenter2F.asm"
INCLUDE "maps/TradeCenter.asm"
INCLUDE "maps/Colosseum.asm"
INCLUDE "maps/TimeCapsule.asm"
INCLUDE "maps/MobileTradeRoomMobile.asm"
INCLUDE "maps/MobileBattleRoom.asm"


SECTION "bank65",ROMX,BANK[$65]

;                       Map Scripts XVIII

INCLUDE "maps/Route36.asm"
INCLUDE "maps/FuchsiaCity.asm"
INCLUDE "maps/BlackthornGym1F.asm"
INCLUDE "maps/BlackthornGym2F.asm"
INCLUDE "maps/BlackthornDragonSpeechHouse.asm"
INCLUDE "maps/BlackthornDodrioTradeHouse.asm"
INCLUDE "maps/BlackthornMart.asm"
INCLUDE "maps/BlackthornPokeCenter1F.asm"
INCLUDE "maps/MoveDeletersHouse.asm"
INCLUDE "maps/FuchsiaMart.asm"
INCLUDE "maps/SafariZoneMainOffice.asm"
INCLUDE "maps/FuchsiaGym.asm"
INCLUDE "maps/FuchsiaBillSpeechHouse.asm"
INCLUDE "maps/FuchsiaPokeCenter1F.asm"
INCLUDE "maps/FuchsiaPokeCenter2FBeta.asm"
INCLUDE "maps/SafariZoneWardensHome.asm"
INCLUDE "maps/Route15FuchsiaGate.asm"
INCLUDE "maps/CherrygroveMart.asm"
INCLUDE "maps/CherrygrovePokeCenter1F.asm"
INCLUDE "maps/CherrygroveGymSpeechHouse.asm"
INCLUDE "maps/GuideGentsHouse.asm"
INCLUDE "maps/CherrygroveEvolutionSpeechHouse.asm"
INCLUDE "maps/Route30BerrySpeechHouse.asm"
INCLUDE "maps/MrPokemonsHouse.asm"
INCLUDE "maps/Route31VioletGate.asm"


SECTION "bank66",ROMX,BANK[$66]

;                        Map Scripts XIX

INCLUDE "maps/AzaleaTown.asm"
INCLUDE "maps/GoldenrodCity.asm"
INCLUDE "maps/SaffronCity.asm"
INCLUDE "maps/MahoganyRedGyaradosSpeechHouse.asm"
INCLUDE "maps/MahoganyGym.asm"
INCLUDE "maps/MahoganyPokeCenter1F.asm"
INCLUDE "maps/Route42EcruteakGate.asm"
INCLUDE "maps/LakeofRageHiddenPowerHouse.asm"
INCLUDE "maps/LakeofRageMagikarpHouse.asm"
INCLUDE "maps/Route43MahoganyGate.asm"
INCLUDE "maps/Route43Gate.asm"
INCLUDE "maps/RedsHouse1F.asm"
INCLUDE "maps/RedsHouse2F.asm"
INCLUDE "maps/BluesHouse.asm"
INCLUDE "maps/OaksLab.asm"


SECTION "bank67",ROMX,BANK[$67]

;                         Map Scripts XX

INCLUDE "maps/CherrygroveCity.asm"
INCLUDE "maps/Route35.asm"
INCLUDE "maps/Route43.asm"
INCLUDE "maps/Route44.asm"
INCLUDE "maps/Route45.asm"
INCLUDE "maps/Route19.asm"
INCLUDE "maps/Route25.asm"


SECTION "bank68",ROMX,BANK[$68]

;                        Map Scripts XXI

INCLUDE "maps/CianwoodCity.asm"
INCLUDE "maps/Route27.asm"
INCLUDE "maps/Route29.asm"
INCLUDE "maps/Route30.asm"
INCLUDE "maps/Route38.asm"
INCLUDE "maps/Route13.asm"
INCLUDE "maps/PewterNidoranSpeechHouse.asm"
INCLUDE "maps/PewterGym.asm"
INCLUDE "maps/PewterMart.asm"
INCLUDE "maps/PewterPokeCenter1F.asm"
INCLUDE "maps/PewterPokeCEnter2FBeta.asm"
INCLUDE "maps/PewterSnoozeSpeechHouse.asm"


SECTION "bank69",ROMX,BANK[$69]

;                        Map Scripts XXII

INCLUDE "maps/EcruteakCity.asm"
INCLUDE "maps/BlackthornCity.asm"
INCLUDE "maps/Route26.asm"
INCLUDE "maps/Route28.asm"
INCLUDE "maps/Route31.asm"
INCLUDE "maps/Route39.asm"
INCLUDE "maps/Route40.asm"
INCLUDE "maps/Route41.asm"
INCLUDE "maps/Route12.asm"


SECTION "bank6A",ROMX,BANK[$6A]

;                       Map Scripts XXIII

INCLUDE "maps/NewBarkTown.asm"
INCLUDE "maps/VioletCity.asm"
INCLUDE "maps/OlivineCity.asm"
INCLUDE "maps/Route37.asm"
INCLUDE "maps/Route42.asm"
INCLUDE "maps/Route46.asm"
INCLUDE "maps/ViridianCity.asm"
INCLUDE "maps/CeladonCity.asm"
INCLUDE "maps/Route15.asm"
INCLUDE "maps/VermilionCity.asm"
INCLUDE "maps/Route9.asm"
INCLUDE "maps/CinnabarPokeCenter1F.asm"
INCLUDE "maps/CinnabarPokeCenter2FBeta.asm"
INCLUDE "maps/Route19FuchsiaGate.asm"
INCLUDE "maps/SeafoamGym.asm"


SECTION "bank6B",ROMX,BANK[$6B]

;                        Map Scripts XXIV

INCLUDE "maps/Route33.asm"
INCLUDE "maps/Route2.asm"
INCLUDE "maps/Route1.asm"
INCLUDE "maps/PalletTown.asm"
INCLUDE "maps/Route21.asm"
INCLUDE "maps/CinnabarIsland.asm"
INCLUDE "maps/Route20.asm"
INCLUDE "maps/Route18.asm"
INCLUDE "maps/Route17.asm"
INCLUDE "maps/Route16.asm"
INCLUDE "maps/Route7.asm"
INCLUDE "maps/Route14.asm"
INCLUDE "maps/LavenderTown.asm"
INCLUDE "maps/Route6.asm"
INCLUDE "maps/Route5.asm"
INCLUDE "maps/Route24.asm"
INCLUDE "maps/Route3.asm"
INCLUDE "maps/Route4.asm"
INCLUDE "maps/Route10South.asm"
INCLUDE "maps/Route23.asm"
INCLUDE "maps/SilverCavePokeCenter1F.asm"
INCLUDE "maps/Route28FamousSpeechHouse.asm"


SECTION "bank6C",ROMX,BANK[$6C]

;                         Common text I

INCLUDE "text/common.tx"

;                        Map Scripts XXV

INCLUDE "maps/SilverCaveOutside.asm"
INCLUDE "maps/Route10North.asm"


SECTION "bank6D",ROMX,BANK[$6D]

INCLUDE "text/phone/mom.tx"
INCLUDE "text/phone/bill.tx"
INCLUDE "text/phone/elm.tx"
INCLUDE "text/phone/trainers1.tx"


SECTION "bank6E",ROMX,BANK[$6E]

;                       Pokedex entries II
;                            065-128
PokedexEntries2:
INCLUDE "stats/pokedex/entries_2.asm"


SECTION "bank6F",ROMX,BANK[$6F]

;                        Common text II

INCLUDE "text/common_2.tx"


SECTION "bank70",ROMX,BANK[$70]

;                        Common text III

INCLUDE "text/common_3.tx"


SECTION "bank71",ROMX,BANK[$71]

;                        Common text IV

INCLUDE "text/common_4.tx"


SECTION "bank72",ROMX,BANK[$72]

;                   Item names & descriptions

ItemNames:
INCLUDE "items/item_names.asm"

INCLUDE "items/item_descriptions.asm"


MoveNames:
INCLUDE "battle/move_names.asm"


INCLUDE "engine/landmarks.asm"


RegionCheck: ; 0x1caea1
; Checks if the player is in Kanto or Johto.
; If in Johto, returns 0 in e.
; If in Kanto, returns 1 in e.
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call GetWorldMapLocation
	cp $5f ; on S.S. Aqua
	jr z, .johto
	cp $0 ; special
	jr nz, .checkagain

; If in map $00, load map group / map id from backup locations
	ld a, [BackupMapGroup]
	ld b, a
	ld a, [BackupMapNumber]
	ld c, a
	call GetWorldMapLocation
.checkagain
	cp $2f ; Pallet Town
	jr c, .johto
	cp $58 ; Victory Road
	jr c, .kanto
.johto
	ld e, 0
	ret
.kanto
	ld e, 1
	ret


SECTION "bank73",ROMX,BANK[$73]

                      ; Pokedex entries III
                            ; 129-192
PokedexEntries3:
INCLUDE "stats/pokedex/entries_3.asm"


SECTION "bank74",ROMX,BANK[$74]

;                       Pokedex entries IV
                            ; 193-251
PokedexEntries4:
INCLUDE "stats/pokedex/entries_4.asm"


SECTION "bank75",ROMX,BANK[$75]


SECTION "bank76",ROMX,BANK[$76]


SECTION "bank77",ROMX,BANK[$77]

UnownFont: ; 1dc000
INCBIN "gfx/misc/unown_font.2bpp"
; 1dc1b0

INCBIN "baserom.gbc", $1dc1b0, $1dc5a1 - $1dc1b0

INCLUDE "tilesets/data_7.asm"

INCBIN "baserom.gbc", $1dd6a9, $1ddf1c - $1dd6a9


Function1ddf1c: ; 1ddf1c
	ld hl, $5f33
	ld de, $9310
	call Decompress
	ret
; 1ddf26

INCBIN "baserom.gbc", $1ddf26, $1de0d7 - $1ddf26


Function1de0d7: ; 1de0d7
	ld hl, $60e1
	ld de, $a000
	call Decompress
	ret
; 1de0e1

INCBIN "baserom.gbc", $1de0e1, $1de247 - $1de0e1


Function1de247: ; 1de247
	ld a, [hBGMapAddress]
	ld l, a
	ld a, [$ffd7]
	ld h, a
	push hl
	inc hl
	ld a, l
	ld [hBGMapAddress], a
	ld a, h
	ld [$ffd7], a
	ld hl, $c4b3
	ld [hl], $66
	ld hl, $c4c7
	ld a, $67
	ld b, $f
	call Function1de27f
	ld [hl], $68
	ld hl, $c607
	ld [hl], $3c
	xor a
	ld b, $12
	ld hl, $cdec
	call Function1de27f
	call Function3200
	pop hl
	ld a, l
	ld [hBGMapAddress], a
	ld a, h
	ld [$ffd7], a
	ret
; 1de27f

Function1de27f: ; 1de27f
	push de
	ld de, $0014
.asm_1de283
	ld [hl], a
	add hl, de
	dec b
	jr nz, .asm_1de283
	pop de
	ret
; 1de28a



Function1de28a: ; 1de28a
	ld hl, DudeAutoInput_A
	jr Function1de299
; 1de28f

Function1de28f: ; 1de28f
	ld hl, DudeAutoInput_RightA
	jr Function1de299
; 1de294

Function1de294: ; 1de294
	ld hl, DudeAutoInput_DownA
	jr Function1de299
; 1de299

Function1de299: ; 1de299
	ld a, $77
	call StartAutoInput
	ret
; 1de29f


DudeAutoInput_A: ; 1de29f
	db NO_INPUT, $50
	db BUTTON_A, $00
	db NO_INPUT, $ff ; end
; 1de2a5
	
DudeAutoInput_RightA: ; 1de2a5
	db NO_INPUT, $08
	db D_RIGHT,  $00
	db NO_INPUT, $08
	db BUTTON_A, $00
	db NO_INPUT, $ff ; end
; 1de2af
	
DudeAutoInput_DownA: ; 1de2af
	db NO_INPUT, $fe
	db NO_INPUT, $fe
	db NO_INPUT, $fe
	db NO_INPUT, $fe
	db D_DOWN,   $00
	db NO_INPUT, $fe
	db NO_INPUT, $fe
	db NO_INPUT, $fe
	db NO_INPUT, $fe
	db BUTTON_A, $00
	db NO_INPUT, $ff ; end
; 1de2c5


INCBIN "baserom.gbc", $1de2c5, $1de2e4 - $1de2c5

PokegearGFX: ; 1de2e4
INCBIN "gfx/misc/pokegear.lz"
; 1de5c7

INCBIN "baserom.gbc", $1de5c7, $1de5c8 - $1de5c7

Function1de5c8: ; 1de5c8
	ld c, $0
	ld hl, $0029
	add hl, de
	ld a, [hli]
	cp $84
	ret nz
	ld a, [hli]
	inc c
	cp $85
	ret z
	inc c
	cp $86
	ret z
	inc c
	cp $88
	ret z
	inc c
	cp $92
	ret z
	ld c, $0
	ret
; 1de5e6

INCBIN "baserom.gbc", $1de5e6, $1df238 - $1de5e6


SECTION "bank78",ROMX,BANK[$78]

INCLUDE "tilesets/data_8.asm"


SECTION "bank79",ROMX,BANK[$79]


SECTION "bank7A",ROMX,BANK[$7A]


SECTION "bank7B",ROMX,BANK[$7B]

INCLUDE "text/battle_tower.asm"


SECTION "bank7C",ROMX,BANK[$7C]

INCBIN "baserom.gbc", $1f0000, $1f09d8 - $1f0000


SECTION "bank7D",ROMX,BANK[$7D]

INCBIN "baserom.gbc", $1f4000, $1f4003 - $1f4000

Function1f4003: ; 1f4003
	ld a, $6
	call GetSRAMBank
	ld hl, $4018
	ld de, $a000
	ld bc, $1000
	call CopyBytes
	call CloseSRAM
	ret
; 1f4018

INCBIN "baserom.gbc", $1f4018, $1f636a - $1f4018


SECTION "bank7E",ROMX,BANK[$7E]

INCLUDE "stats/battle_tower.asm"
INCLUDE "stats/odd_eggs.asm"


SECTION "bank7F",ROMX,BANK[$7F]

SECTION "stadium2",ROMX[$8000-$220],BANK[$7F]
INCBIN "baserom.gbc", $1ffde0, $220

