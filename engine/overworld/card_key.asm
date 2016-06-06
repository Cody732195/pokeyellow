PrintCardKeyText: ; 525d8 (14:65d8)
	ld hl, SilphCoMapList
	ld a, [wCurMap]
	ld b, a
.silphCoMapListLoop
	ld a, [hli]
	cp $ff
	ret z
	cp b
	jr nz, .silphCoMapListLoop
; does not check for tile in front of player. This might be buggy
	;predef GetTileAndCoordsInFrontOfPlayer
	ld a, [wTileInFrontOfPlayer]
	cp $18
	jr z, .cardKeyDoorInFrontOfPlayer
	cp $24
	jr z, .cardKeyDoorInFrontOfPlayer
	ld b, a
	ld a, [wCurMap]
	cp SILPH_CO_11F
	ret nz
	ld a, b
	cp $5e
	ret nz
.cardKeyDoorInFrontOfPlayer
	ld b, CARD_KEY
	call IsItemInBag
	jr z, .noCardKey
	xor a
	ld [wPlayerMovingDirection], a
	tx_pre_id CardKeySuccessText
	ld [hSpriteIndexOrTextID], a
	call PrintPredefTextID
	call GetCoordsInFrontOfPlayer
	srl d
	ld a, d
	ld b, a
	ld [wCardKeyDoorY], a
	srl e
	ld a, e
	ld c, a
	ld [wCardKeyDoorX], a
	ld a, [wCurMap]
	cp SILPH_CO_11F
	jr nz, .notSilphCo11F
	ld a, $3
	jr .replaceCardKeyDoorTileBlock
.notSilphCo11F
	ld a, $e
.replaceCardKeyDoorTileBlock
	ld [wNewTileBlockID], a
	predef ReplaceTileBlock
	ld hl, wd126
	set 5, [hl]
	ld a, SFX_GO_INSIDE
	jp PlaySound
.noCardKey
	tx_pre_id CardKeyFailText
	ld [hSpriteIndexOrTextID], a
	jp PrintPredefTextID

SilphCoMapList: ; 52645 (14:6645)
	db SILPH_CO_2F
	db SILPH_CO_3F
	db SILPH_CO_4F
	db SILPH_CO_5F
	db SILPH_CO_6F
	db SILPH_CO_7F
	db SILPH_CO_8F
	db SILPH_CO_9F
	db SILPH_CO_10F
	db SILPH_CO_11F
	db $FF

CardKeySuccessText: ; 52650 (14:6650)
	TX_FAR _CardKeySuccessText1
	TX_SFX_ITEM
	TX_FAR _CardKeySuccessText2
	db "@"

CardKeyFailText: ; 5265a (14:665a)
	TX_FAR _CardKeyFailText
	db "@"

; d = Y
; e = X
GetCoordsInFrontOfPlayer: ; 5265f (14:665f)
	ld a, [wYCoord]
	ld d, a
	ld a, [wXCoord]
	ld e, a
	ld a, [wPlayerFacingDirection] ; player's sprite facing direction
	and a
	jr nz, .notFacingDown
; facing down
	inc d
	ret
.notFacingDown
	cp SPRITE_FACING_UP
	jr nz, .notFacingUp
; facing up
	dec d
	ret
.notFacingUp
	cp SPRITE_FACING_LEFT
	jr nz, .notFacingLeft
; facing left
	dec e
	ret
.notFacingLeft
; facing right
	inc e
	ret
