# GRAPHE DES SCÈNES — ARC DU FUTUR (reconstruction automatique depuis les IR)

Transitions, routines, flags et conditions extraits du bytecode SSB. 
Aucune transition n'est perdue : `back_SetGround` / `back_ChangeGround` / `back2_SetGround` /
`main_EnterDungeon` sont toutes listées, avec le niveau résolu.

## Chaîne principale des zones

```
P05P01A
   └ m17a0103.ssb  ─▶ back_SetGround(P05P01A)
   └ m19a0102.ssb  ─▶ back_SetGround(P05P01A)
   └ n08a2008.ssb  ─▶ back_SetGround(P05P01A)

P05P02A
   └ m17a0104.ssb  ─▶ back_SetGround(P05P02A)
   └ m17a0301.ssb  ─▶ back_SetGround(P05P02A)
   └ m17a0301.ssb  ─▶ back_ChangeGround(P05P02A2)
   └ m17a0301.ssb  ─▶ back_SetGround(S04P01A)

P05P03A
   └ m17a0302.ssb  ─▶ back_SetGround(P05P03A)
   └ m26a06d3.ssb  ─▶ back_SetGround(P05P03A)

P05P04A
   └ m17a0401.ssb  ─▶ back_SetGround(P05P04A)
   └ m17a0403.ssb  ─▶ back_SetGround(P05P04A)

P06P01A
   └ m18a0401.ssb  ─▶ back_SetGround(P06P01A)
   └ m26a0614.ssb  ·▶ back2_SetGround(S04P01A)
   └ m26a0614.ssb  ─▶ back_SetGround(P06P01A)

P07P01A
   └ m18b1401.ssb  ·▶ back2_SetGround(V09P04A)
   └ m18b1401.ssb  ─▶ back_SetGround(P07P01A)
   └ m26a06e6.ssb  ·▶ back2_SetGround(V09P04A)
   └ m26a06e6.ssb  ─▶ back_SetGround(P07P01A)

P08P01A
   └ m19a0601.ssb  ─▶ back_SetGround(P08P01A)
   └ m19d0612.ssb  ─▶ back_SetGround(P08P01A)
   └ n08a2308.ssb  ─▶ back_SetGround(P08P01A)
   └ n08a2308.ssb  ·▶ main_EnterDungeon(140)
   └ n08a2308.ssb  ·▶ main_EnterDungeon(30)
   └ n08a2308.ssb  ·▶ main_EnterDungeon(32767)
   └ n08a2308.ssb  ·▶ main_EnterDungeon(30)
   └ n08a2408.ssb  ─▶ back_SetGround(P08P01A)
   └ n08a2508.ssb  ─▶ back_SetGround(P08P01A)
   └ n08a2508.ssb  ·▶ main_EnterDungeon(140)
   └ n08a2508.ssb  ·▶ main_EnterDungeon(30)
   └ n08a2508.ssb  ·▶ main_EnterDungeon(32767)
   └ n08a2508.ssb  ·▶ main_EnterDungeon(30)
   └ n08a2608.ssb  ─▶ back_SetGround(P08P01A)

P09P01A
   └ m19b1001.ssb  ─▶ back_SetGround(P09P01A)
   └ m19b1001.ssb  ·▶ back2_SetGround(V12P01A)
   └ m19b1001.ssb  ·▶ back2_SetGround(V13P01A)
   └ m19b1007.ssb  ─▶ back_SetGround(P09P01A)
   └ m19b1007.ssb  ·▶ back2_SetGround(V14P01A)
   └ m19b1007.ssb  ·▶ back2_SetGround(V14P03A)
   └ m19b1007.ssb  ·▶ back2_SetGround(V14P04A)
   └ m19b1007.ssb  ·▶ back2_SetGround(V14P01A)
   └ m19b1009.ssb  ─▶ back_SetGround(P09P01A)
   └ m19d1072.ssb  ─▶ back_SetGround(P09P01A)

```

## Détail par scène

### P05P01A / m17a0103.ssb

**Transitions :**
- `back_SetGround` (seq 0) → niveau **P05P01A** (raw 232)
**Routines :**
- `CallCommon` (seq 16) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 31) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 36) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 38) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 42) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
**Fin de scène :** `End` aux séquences [58]

### P05P01A / m19a0102.ssb

**Transitions :**
- `back_SetGround` (seq 1) → niveau **P05P01A** (raw 232)
**Routines :**
- `CallCommon` (seq 26) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 32) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 34) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 38) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
**Fin de scène :** `End` aux séquences [55]

### P05P01A / n08a2008.ssb

**Transitions :**
- `back_SetGround` (seq 10) → niveau **P05P01A** (raw 232)
**Routines :**
- `CallCommon` (seq 3) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 6) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 29) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
- `CallCommon` (seq 76) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 89) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 100) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 111) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 120) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 130) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 137) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 140) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 150) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 157) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 166) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 172) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 179) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
**Fin de scène :** `End` aux séquences [194]

### P05P02A / m17a0104.ssb

**Transitions :**
- `back_SetGround` (seq 11) → niveau **P05P02A** (raw 233)
**Routines :**
- `CallCommon` (seq 40) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 52) → **HEAD_SHAKE_FUNC_SERIES** (raw 45)
- `CallCommon` (seq 59) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 61) → **JUMP_HAPPY_FUNC_SERIES** (raw 37)
- `CallCommon` (seq 68) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 75) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
- `CallCommon` (seq 86) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 97) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 103) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 114) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 129) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 134) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
**Conditions / embranchements :**
- `message_SwitchTalk` (seq 2) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 3) cas 0 → texte  Hey...[K][hero]...
- `CaseText` (seq 4) cas 1 → texte  Hey...[K][hero]...
- `message_SwitchTalk` (seq 6) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 7) cas 3 → texte  Wake up, [hero]!
- `CaseText` (seq 8) cas 4 → texte  Wake up, [hero]!
- `message_SwitchMonologue` (seq 37) sur **HERO_TALK_KIND**
- `CaseText` (seq 38) cas 6 → texte (Ugh...)
- `message_SwitchMonologue` (seq 56) sur **HERO_TALK_KIND**
- `CaseText` (seq 57) cas 8 → texte (Wh-where...?)
- `message_SwitchTalk` (seq 64) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 65) cas 10 → texte  You're awake!
- `CaseText` (seq 66) cas 11 → texte  You're awake!
- `message_SwitchTalk` (seq 82) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 83) cas 13 → texte  This place... I think it's a jail.
- `CaseText` (seq 84) cas 14 → texte  This place... I think it's a jail.
- `message_SwitchMonologue` (seq 94) sur **HERO_TALK_KIND**
- `CaseText` (seq 95) cas 16 → texte (J-jail?!)
- `message_SwitchTalk` (seq 99) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 100) cas 18 → texte  I just woke up a while ago, so
I'm not sure what's going on.
- `CaseText` (seq 101) cas 19 → texte  I just woke up a while ago, so
I'm not sure what's going on.
- `message_SwitchTalk` (seq 110) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 111) cas 21 → texte  I tried opening the doors, but
they're locked.
- `CaseText` (seq 112) cas 22 → texte  I tried the doors, but they're
locked.
- `message_SwitchTalk` (seq 121) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 122) cas 24 → texte  There doesn't seem to be any
other way out.
- `CaseText` (seq 123) cas 25 → texte  There seems to be no other
way out.
- `message_SwitchTalk` (seq 125) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 126) cas 27 → texte  I think that we've been locked
up...[K] Ugh...
- `CaseText` (seq 127) cas 28 → texte  I think that we've been locked
up...[K] Ugh...
- `message_SwitchMonologue` (seq 141) sur **HERO_TALK_KIND**
- `CaseText` (seq 142) cas 30 → texte (Wh-what's going on?)
- `message_SwitchMonologue` (seq 144) sur **HERO_TALK_KIND**
- `CaseText` (seq 145) cas 32 → texte (We're locked up?)
- `message_SwitchMonologue` (seq 147) sur **HERO_TALK_KIND**
- `CaseText` (seq 148) cas 34 → texte (I don't know what's going on either, but I may
as well investigate...)
**Fin de scène :** `End` aux séquences [151]

### P05P02A / m17a0201.ssb

**Routines :**
- `CallCommon` (seq 8) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 16) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
**Flags / variables :**
- `flag_SetScenario` (seq 1) → **SCENARIO_MAIN** [scenario_value=18(18), level_value=2(2)]
**Conditions / embranchements :**
- `message_SwitchMonologue` (seq 10) sur **HERO_TALK_KIND**
- `CaseText` (seq 11) cas 2 → texte (It's no good.[K] Like [partner] said, these
doors won't open.)
- `message_SwitchMonologue` (seq 13) sur **HERO_TALK_KIND**
- `CaseText` (seq 14) cas 4 → texte (It sure looks like we've been locked up!)
**Fin de scène :** `End` aux séquences [17]

### P05P02A / m17a0301.ssb

**Transitions :**
- `back_SetGround` (seq 2) → niveau **P05P02A** (raw 233)
- `back_ChangeGround` (seq 153) → niveau **P05P02A2** (raw 234)
- `back_SetGround` (seq 316) → niveau **S04P01A** (raw 275)
**Routines :**
- `CallCommon` (seq 18) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 31) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 34) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 45) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 47) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
- `ExecuteCommon` (seq 56) → **JUMP_ANGRY_FUNC_SERIES** (raw 41)
- `CallCommon` (seq 70) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 72) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
- `CallCommon` (seq 106) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 109) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `ExecuteCommon` (seq 114) → **LOOK_AROUND_FAST_FUNC_SERIES** (raw 43)
- `CallCommon` (seq 125) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 148) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 212) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 239) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 244) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 265) → **LOOK_AROUND_FAST_FUNC_SERIES** (raw 43)
- `ExecuteCommon` (seq 267) → **LOOK_AROUND_FAST_FUNC_SERIES** (raw 43)
- `CallCommon` (seq 281) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 287) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 290) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 296) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 309) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 315) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
**Conditions / embranchements :**
- `message_SwitchTalk` (seq 10) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 11) cas 0 → texte  Hmm...
- `CaseText` (seq 12) cas 1 → texte  Hmm...
- `message_SwitchTalk` (seq 14) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 15) cas 3 → texte  How did we end up this way?
- `CaseText` (seq 16) cas 4 → texte  How did we end up this way?
- `message_SwitchTalk` (seq 23) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 24) cas 6 → texte  I think what happened was...[K]
[CS:N]Dusknoir[CR] grabbed us...
- `CaseText` (seq 25) cas 7 → texte  I think what happened was...[K]
[CS:N]Dusknoir[CR] grabbed us...
- `message_SwitchTalk` (seq 27) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 28) cas 9 → texte  Then he dragged us into the
dimensional hole...
- `CaseText` (seq 29) cas 10 → texte  Then he dragged us into the
dimensional hole...
- `message_SwitchTalk` (seq 37) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 38) cas 12 → texte  Huh?![K] Wait, so is this maybe...
- `CaseText` (seq 39) cas 13 → texte  What?![K] Wait, so is this maybe...
- `message_SwitchTalk` (seq 41) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 42) cas 15 → texte  Is this...[K]the future?!
- `CaseText` (seq 43) cas 16 → texte  Is this...[K]the future?!
- `message_SwitchTalk` (seq 58) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 59) cas 18 → texte  But that's...![K] I don't
believe this!
- `CaseText` (seq 60) cas 19 → texte  But that's...![K] I can't
believe this!
- `message_SwitchTalk` (seq 62) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 63) cas 21 → texte  I mean, this is the future?!
- `CaseText` (seq 64) cas 22 → texte  I mean, this is the future?!
- `message_SwitchTalk` (seq 66) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 67) cas 24 → texte  Why are we even here?
- `CaseText` (seq 68) cas 25 → texte  Why are we even here?
- `message_SwitchTalk` (seq 86) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 87) cas 27 → texte  Ugh...but...
- `CaseText` (seq 88) cas 28 → texte  Ugh...but...
- `message_SwitchTalk` (seq 90) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 91) cas 30 → texte  This whole room is built in a
way unlike anything I've ever seen!
- `CaseText` (seq 92) cas 31 → texte  This whole room is constructed
in a way unlike anything I've ever seen!
- `message_SwitchTalk` (seq 94) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 95) cas 33 → texte  Now that I've had time to
think...[K] Maybe this actually is...
- `CaseText` (seq 96) cas 34 → texte  Now that I've had time to
digest this...[K] Maybe this actually is...
- `message_SwitchTalk` (seq 98) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 99) cas 36 → texte  The future!
- `CaseText` (seq 100) cas 37 → texte  The future!
- `message_SwitchTalk` (seq 102) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 103) cas 39 → texte  ........................
- `CaseText` (seq 104) cas 40 → texte  ........................
- `message_SwitchTalk` (seq 117) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 118) cas 42 → texte  Waah! [hero]!
- `CaseText` (seq 119) cas 43 → texte  Waah! [hero]!
- `message_SwitchTalk` (seq 121) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 122) cas 45 → texte  Did we really end up in the
future?!
- `CaseText` (seq 123) cas 46 → texte  Did we really end up in the
future?!
- `message_SwitchTalk` (seq 132) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 133) cas 48 → texte  Ugh, now what are we supposed
to do?
- `CaseText` (seq 134) cas 49 → texte  Ugh, now what should we do?
- `message_SwitchTalk` (seq 136) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 137) cas 51 → texte  So, if...
- `CaseText` (seq 138) cas 52 → texte  So, if...
- `message_SwitchTalk` (seq 140) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 141) cas 54 → texte  If this place is the future...
- `CaseText` (seq 142) cas 55 → texte  If this place is the future...
- `message_SwitchTalk` (seq 144) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 145) cas 57 → texte  How are we supposed to get
back to our world?
- `CaseText` (seq 146) cas 58 → texte  How are we supposed to get
back to our world?
- `message_SwitchTalk` (seq 246) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 247) cas 62 → texte  Do this quick? Do what?!
- `CaseText` (seq 248) cas 63 → texte  Do this quick? Do what?!
- `message_SwitchMonologue` (seq 278) sur **HERO_TALK_KIND**
- `CaseText` (seq 279) cas 65 → texte (Wh-what?!)
- `message_SwitchTalk` (seq 283) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 284) cas 67 → texte  Waah! They have me
blindfolded![K] I can't see!
- `CaseText` (seq 285) cas 68 → texte  Waah! They blindfolded me![K]
I can't see a thing!
- `message_SwitchTalk` (seq 292) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 293) cas 71 → texte  Ow! Quit shoving!
- `CaseText` (seq 294) cas 72 → texte  Ow! Don't shove me!
- `message_SwitchTalk` (seq 301) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 302) cas 74 → texte  Ugh...[K] This blindfold makes it
impossible to tell where I'm going...
- `CaseText` (seq 303) cas 75 → texte  Ugh...[K] This blindfold makes it
impossible to tell where I'm going...
- `message_SwitchTalk` (seq 305) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 306) cas 77 → texte  Where are they taking us?
- `CaseText` (seq 307) cas 78 → texte  But where are they taking us?
**Fin de scène :** `End` aux séquences [321]

### P05P03A / m17a0302.ssb

**Transitions :**
- `back_SetGround` (seq 1) → niveau **P05P03A** (raw 235)
**Routines :**
- `CallCommon` (seq 21) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 47) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 73) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 87) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 94) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 99) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 115) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 123) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 152) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 156) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 163) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 167) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 183) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 207) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 212) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 230) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 238) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 373) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 378) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 399) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 432) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 436) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 439) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 446) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 453) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 461) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 464) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 510) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 598) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 605) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 619) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 623) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 635) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 638) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 640) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 651) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 658) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 674) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 679) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 685) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 692) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 698) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 707) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 713) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 716) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 755) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 789) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 835) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 936) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 968) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 974) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 981) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 992) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1017) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1029) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1032) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1062) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1087) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1106) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1109) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1146) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1151) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1154) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1164) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1184) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1203) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1220) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1226) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1326) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1338) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1356) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1360) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 1399) → **LOOK_AROUND_LEFT_FUNC_SERIES** (raw 35)
- `ExecuteCommon` (seq 1402) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
- `ExecuteCommon` (seq 1405) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
- `ExecuteCommon` (seq 1408) → **LOOK_AROUND_RIGHT_FUNC_SERIES** (raw 33)
- `ExecuteCommon` (seq 1411) → **LOOK_AROUND_RIGHT_FUNC_SERIES** (raw 33)
- `ExecuteCommon` (seq 1414) → **LOOK_AROUND_DOWN_FUNC_SERIES** (raw 31)
- `CallCommon` (seq 1429) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1475) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 1572) → **JUMP_ANGRY_FUNC_SERIES** (raw 41)
- `CallCommon` (seq 1579) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 1581) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
- `CallCommon` (seq 1595) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1607) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 1649) → **HANYOU_SAVE_FUNC** (raw 52)
**Flags / variables :**
- `flag_CalcBit` (seq 1647) → **SCENARIO_MAIN_BIT_FLAG** [index=8(8), value=1(1)]
- `flag_Set` (seq 1648) → **COMPULSORY_SAVE_POINT** [value=14(14)]
**Conditions / embranchements :**
- `message_SwitchTalk` (seq 17) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 18) cas 0 → texte  Wh-where is this?!
- `CaseText` (seq 19) cas 1 → texte  Wh-where is this?!
- `message_SwitchTalk` (seq 39) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 40) cas 3 → texte  They have me trussed up.
I can't move...
- `CaseText` (seq 41) cas 4 → texte  They have me trussed up.
I can't move...
- `message_SwitchTalk` (seq 43) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 44) cas 6 → texte  Wh-why is this happening?
- `CaseText` (seq 45) cas 7 → texte  Wh-why is this happening?
- `message_SwitchTalk` (seq 69) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 70) cas 9 → texte  Hey!
- `CaseText` (seq 71) cas 10 → texte  Hey!
- `message_SwitchMonologue` (seq 84) sur **HERO_TALK_KIND**
- `CaseText` (seq 85) cas 12 → texte ([partner]!)
- `message_SwitchTalk` (seq 90) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 91) cas 14 → texte  Am I glad to see you![K]
You're OK, right?
- `CaseText` (seq 92) cas 15 → texte  Am I glad to see you![K]
You're OK, right?
- `message_SwitchTalk` (seq 111) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 112) cas 20 → texte  Huh?!
- `CaseText` (seq 113) cas 21 → texte  Huh?!
- `message_SwitchMonologue` (seq 120) sur **HERO_TALK_KIND**
- `CaseText` (seq 121) cas 23 → texte (That voice came from over there...)
- `message_SwitchTalk` (seq 148) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 149) cas 25 → texte  [CS:N]Grovyle[CR]!
- `CaseText` (seq 150) cas 26 → texte  [CS:N]Grovyle[CR]!
- `message_SwitchTalk` (seq 159) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 160) cas 29 → texte  N-no...
- `CaseText` (seq 161) cas 30 → texte  N-no...
- `message_SwitchTalk` (seq 179) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 180) cas 33 → texte  What?![K] G-get rid of us?!
- `CaseText` (seq 181) cas 34 → texte  What?![K] G-get rid of us?!
- `message_SwitchTalk` (seq 191) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 192) cas 36 → texte  Wait a second.
- `CaseText` (seq 193) cas 37 → texte  Wait a second.
- `message_SwitchTalk` (seq 195) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 196) cas 39 → texte  I can understand why they want
to get rid of you, [CS:N]Grovyle[CR].
- `CaseText` (seq 197) cas 40 → texte  It's easy to understand why
they'd want to get rid of you, [CS:N]Grovyle[CR].
- `message_SwitchTalk` (seq 199) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 200) cas 42 → texte  But why us?!
- `CaseText` (seq 201) cas 43 → texte  But why us?!
- `message_SwitchTalk` (seq 203) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 204) cas 45 → texte  We haven't done anything wrong!
- `CaseText` (seq 205) cas 46 → texte  We haven't done anything wrong!
- `message_SwitchTalk` (seq 218) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 219) cas 50 → texte  What?!
- `CaseText` (seq 220) cas 51 → texte  What?!
- `message_SwitchTalk` (seq 222) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 223) cas 53 → texte  We haven't done anything bad!
- `CaseText` (seq 224) cas 54 → texte  We haven't done anything bad!
- `message_SwitchTalk` (seq 226) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 227) cas 56 → texte  Don't think that we're like you!
- `CaseText` (seq 228) cas 57 → texte  Don't think that we're like you!
- `message_SwitchTalk` (seq 369) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 370) cas 62 → texte  Waah! Who are they?!
- `CaseText` (seq 371) cas 63 → texte  Waah! Who are they?!
- `message_SwitchTalk` (seq 395) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 396) cas 67 → texte  What?![K] The great [CS:N]Dusknoir[CR]'s?!
- `CaseText` (seq 397) cas 68 → texte  What?![K] The great [CS:N]Dusknoir[CR]'s?!
- `message_SwitchTalk` (seq 428) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 429) cas 70 → texte  Hey! It's [CS:N]Dusknoir[CR]!
- `CaseText` (seq 430) cas 71 → texte  Hey! It's [CS:N]Dusknoir[CR]!
- `message_SwitchTalk` (seq 442) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 443) cas 75 → texte  [CS:N]Dusknoir[CR], sir![K]
It's me, [partner]!
- `CaseText` (seq 444) cas 76 → texte  [CS:N]Dusknoir[CR], sir![K]
It's me, [partner]!
- `message_SwitchTalk` (seq 457) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 458) cas 80 → texte  What?!
- `CaseText` (seq 459) cas 81 → texte  What?!
- `message_SwitchTalk` (seq 586) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 587) cas 85 → texte  W-wait a minute! [CS:N]Dusknoir[CR], sir!
- `CaseText` (seq 588) cas 86 → texte  W-wait a minute! [CS:N]Dusknoir[CR], sir!
- `message_SwitchTalk` (seq 590) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 591) cas 88 → texte  What's wrong with you?!
- `CaseText` (seq 592) cas 89 → texte  What's wrong with you?!
- `message_SwitchTalk` (seq 594) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 595) cas 91 → texte  Why are you doing this to us?!
- `CaseText` (seq 596) cas 92 → texte  Why are you doing this to us?!
- `message_SwitchTalk` (seq 615) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 616) cas 96 → texte  Urk...! Keep...my voice down?
- `CaseText` (seq 617) cas 97 → texte  Urk...! Keep...my voice down?
- `message_SwitchTalk` (seq 631) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 632) cas 101 → texte  What...?[K] Help you, [CS:N]Grovyle[CR]...?
- `CaseText` (seq 633) cas 102 → texte  What...?[K] Help you, [CS:N]Grovyle[CR]...?
- `message_SwitchMonologue` (seq 648) sur **HERO_TALK_KIND**
- `CaseText` (seq 649) cas 106 → texte (...!)
- `message_SwitchMonologue` (seq 660) sur **HERO_TALK_KIND**
- `CaseText` (seq 661) cas 110 → texte (What?[K] What can I do?)
- `message_SwitchMonologue` (seq 663) sur **HERO_TALK_KIND**
- `CaseText` (seq 664) cas 112 → texte (You ask me that out of nowhere...![K] Umm...)
- `message_SwitchMonologue` (seq 667) sur **HERO_TALK_KIND**
- `CaseText` (seq 668) cas 114 → texte (Wh-what to do...?)
- `message_SwitchMenu` (seq 670) sur **0**
- `message_SwitchMenu` (seq 670) sur **1**
- `message_SwitchMonologue` (seq 681) sur **HERO_TALK_KIND**
- `CaseText` (seq 682) cas 122 → texte (Urk...! That's easy for you to say...[K] Ummm...)
- `message_SwitchMonologue` (seq 694) sur **HERO_TALK_KIND**
- `CaseText` (seq 695) cas 129 → texte (Urk...! You're not helping...[K] Ummm...)
- `message_SwitchTalk` (seq 709) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 710) cas 132 → texte  ...If it's just a regular attack,
I can help too...
- `CaseText` (seq 711) cas 133 → texte  ...If it's just a regular attack,
I can help too...
- `message_SwitchTalk` (seq 964) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 965) cas 143 → texte  ...! They're coming...
- `CaseText` (seq 966) cas 144 → texte  ...! They're coming...
- `message_SwitchTalk` (seq 988) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 989) cas 148 → texte  ...! Yikes...that sounds scary!
- `CaseText` (seq 990) cas 149 → texte  ...! Yikes...that sounds scary!
- `message_SwitchTalk` (seq 1025) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 1026) cas 154 → texte  ...Oh, right...![K] The ropes might
come loose!
- `CaseText` (seq 1027) cas 155 → texte  ...Oh, right...![K] The ropes might
come loose!
- `message_SwitchTalk` (seq 1054) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 1055) cas 158 → texte  ...B-b-but...
- `CaseText` (seq 1056) cas 159 → texte  ...B-b-but...
- `message_SwitchTalk` (seq 1058) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 1059) cas 161 → texte  ...What if their [CS:M]Fury Swipes[CR]
don't slash the ropes...?
- `CaseText` (seq 1060) cas 162 → texte  ...What if their [CS:M]Fury Swipes[CR]
don't slash the ropes...?
- `message_SwitchTalk` (seq 1083) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 1084) cas 164 → texte  ...And what if...[K] What if the
[CS:N]Sableye[CR] don't use [CS:M]Fury Swipes[CR] at all...?
- `CaseText` (seq 1085) cas 165 → texte  ...And what if...[K] What if the
[CS:N]Sableye[CR] don't use [CS:M]Fury Swipes[CR] at all...?
- `message_SwitchTalk` (seq 1142) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 1143) cas 169 → texte  WAAAAAAH!
- `CaseText` (seq 1144) cas 170 → texte  WAAAAAAH!
- `message_SwitchMonologue` (seq 1148) sur **HERO_TALK_KIND**
- `CaseText` (seq 1149) cas 172 → texte (Urggh!)
- `message_SwitchTalk` (seq 1156) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 1157) cas 175 → texte  But if they keep going...
- `CaseText` (seq 1158) cas 176 → texte  But if they keep going...
- `message_SwitchTalk` (seq 1160) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 1161) cas 178 → texte  We'll be down before our
chance comes!
- `CaseText` (seq 1162) cas 179 → texte  We'll be finished before our
chance comes!
- `message_SwitchTalk` (seq 1180) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 1181) cas 181 → texte  Hey!
- `CaseText` (seq 1182) cas 182 → texte  Hey!
- `message_SwitchMonologue` (seq 1200) sur **HERO_TALK_KIND**
- `CaseText` (seq 1201) cas 184 → texte (There's a break in the rope!)
- `message_SwitchTalk` (seq 1222) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 1223) cas 187 → texte  Go!
- `CaseText` (seq 1224) cas 188 → texte  Go!
- `message_SwitchTalk` (seq 1575) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 1576) cas 201 → texte  Blecch! I got dirt in my mouth...
- `CaseText` (seq 1577) cas 202 → texte  Blecch! I got dirt in my mouth...
- `message_SwitchMonologue` (seq 1586) sur **HERO_TALK_KIND**
- `CaseText` (seq 1587) cas 204 → texte (We're...[K] We're safe...)
- `message_SwitchMonologue` (seq 1589) sur **HERO_TALK_KIND**
- `CaseText` (seq 1590) cas 206 → texte (So [CS:N]Grovyle[CR] can use [CS:M]Dig[CR]?)
- `message_SwitchMonologue` (seq 1592) sur **HERO_TALK_KIND**
- `CaseText` (seq 1593) cas 208 → texte (He sure knows many moves.)
**Fin de scène :** `End` aux séquences [1650]

### P05P03A / m26a06d3.ssb

**Transitions :**
- `back_SetGround` (seq 1) → niveau **P05P03A** (raw 235)
**Routines :**
- `CallCommon` (seq 90) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 109) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 126) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 132) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 231) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
**Conditions / embranchements :**
- `message_SwitchTalk` (seq 86) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 87) cas 0 → texte  Hey!
- `CaseText` (seq 88) cas 1 → texte  Hey!
- `message_SwitchMonologue` (seq 106) sur **HERO_TALK_KIND**
- `CaseText` (seq 107) cas 3 → texte (There's a break in the rope!)
- `message_SwitchTalk` (seq 128) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 129) cas 6 → texte  Go!
- `CaseText` (seq 130) cas 7 → texte  Go!
**Fin de scène :** `End` aux séquences [235]

### P05P04A / m17a0401.ssb

**Transitions :**
- `back_SetGround` (seq 79) → niveau **P05P04A** (raw 236)
**Routines :**
- `CallCommon` (seq 6) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 9) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 19) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 26) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 29) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 35) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 38) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 48) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 52) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 58) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 61) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 67) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 107) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
**Conditions / embranchements :**
- `message_SwitchTalk` (seq 11) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 12) cas 2 → texte  This is the fastest I can go!
- `CaseText` (seq 13) cas 3 → texte  This is the fastest I can go!
- `message_SwitchTalk` (seq 15) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 16) cas 5 → texte  Quit ordering me around!
- `CaseText` (seq 17) cas 6 → texte  Quit ordering me around!
- `message_SwitchTalk` (seq 22) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 23) cas 8 → texte  Anyway, [CS:N]Grovyle[CR]...!
- `CaseText` (seq 24) cas 9 → texte  Anyway, [CS:N]Grovyle[CR]...!
- `message_SwitchTalk` (seq 31) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 32) cas 12 → texte  Is this...[K]the future?
- `CaseText` (seq 33) cas 13 → texte  Is this...[K]the future?
- `message_SwitchTalk` (seq 40) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 41) cas 16 → texte  Urk! So it is, after all...
- `CaseText` (seq 42) cas 17 → texte  Urk! So it is, after all...
- `message_SwitchTalk` (seq 44) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 45) cas 19 → texte  Are we...[K] Are we going to be
able to get back to our world?
- `CaseText` (seq 46) cas 20 → texte  Are we...[K] Are we going to be
able to get back to our world?
- `message_SwitchTalk` (seq 54) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 55) cas 24 → texte  I can't![K] I'm exhausted...[K]
Huff-huff...
- `CaseText` (seq 56) cas 25 → texte  I can't![K] I'm exhausted...[K]
Huff-huff...
- `message_SwitchTalk` (seq 63) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 64) cas 28 → texte  Huff-huff...[K] Huff-huff...
- `CaseText` (seq 65) cas 29 → texte  Huff-huff...[K] Huff-huff...
- `message_SwitchTalk` (seq 70) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 71) cas 31 → texte  We did it![K] We're...[K]outside!
- `CaseText` (seq 72) cas 32 → texte  We did it![K] We're...[K]outside!
- `message_SwitchTalk` (seq 110) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 111) cas 34 → texte  Wah! What...[K]what is this?!
- `CaseText` (seq 112) cas 35 → texte  Wah! What...[K]what is this?!
**Fin de scène :** `End` aux séquences [116]

### P05P04A / m17a0403.ssb

**Transitions :**
- `back_SetGround` (seq 1) → niveau **P05P04A** (raw 236)
**Routines :**
- `CallCommon` (seq 17) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 23) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 43) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 46) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 54) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 68) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
**Conditions / embranchements :**
- `message_SwitchTalk` (seq 9) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 10) cas 0 → texte  It's as if...[K]all movement...
- `CaseText` (seq 11) cas 1 → texte  It's as if...[K]all movement...
- `message_SwitchTalk` (seq 13) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 14) cas 3 → texte  It's as if everything's stopped.
- `CaseText` (seq 15) cas 4 → texte  It's as if everything's stopped.
- `message_SwitchTalk` (seq 39) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 40) cas 7 → texte  What?!
- `CaseText` (seq 41) cas 8 → texte  What?!
- `message_SwitchTalk` (seq 64) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 65) cas 11 → texte  Wah! I hear those [CS:N]Sableye[CR]!
- `CaseText` (seq 66) cas 12 → texte  Wah! I hear those [CS:N]Sableye[CR]!
**Fin de scène :** `End` aux séquences [83]

### P06P01A / m18a0401.ssb

**Transitions :**
- `back_SetGround` (seq 2) → niveau **P06P01A** (raw 237)
**Routines :**
- `CallCommon` (seq 19) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 32) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 41) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 68) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 74) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 109) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 114) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 134) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 153) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 174) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 188) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 216) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 247) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 250) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 263) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 266) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `ExecuteCommon` (seq 287) → **EXPLANATION_FUNC_SERIES** (raw 47)
- `CallCommon` (seq 309) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 320) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 365) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 371) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 374) → **JUMP_ANGRY_FUNC_SERIES** (raw 41)
- `CallCommon` (seq 388) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 411) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 413) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 427) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 441) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 444) → **JUMP_ANGRY_FUNC_SERIES** (raw 41)
- `CallCommon` (seq 459) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 481) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 493) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 505) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 510) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 512) → **JUMP_HAPPY_FUNC_SERIES** (raw 37)
- `CallCommon` (seq 523) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 551) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 581) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 592) → **JUMP_HAPPY_FUNC_SERIES** (raw 37)
- `CallCommon` (seq 615) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
**Flags / variables :**
- `flag_SetScenario` (seq 1) → **SCENARIO_MAIN** [scenario_value=19(19), level_value=2(2)]
**Conditions / embranchements :**
- `message_SwitchTalk` (seq 15) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 16) cas 0 → texte  Huff-huff...[K] We've climbed a
long ways up...
- `CaseText` (seq 17) cas 1 → texte  Huff-huff...[K] We've been climbing
a long time now...
- `message_SwitchTalk` (seq 37) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 38) cas 3 → texte  Whoa![K] Look at that, 
[hero]!
- `CaseText` (seq 39) cas 4 → texte  Wow![K] Look at that,
[hero]!
- `message_SwitchTalk` (seq 52) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 53) cas 6 → texte  It was true...[K] The future really
is a world of darkness...
- `CaseText` (seq 54) cas 7 → texte  It was true...[K] The future really
is a world of darkness...
- `message_SwitchTalk` (seq 56) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 57) cas 9 → texte  ...[K]That cluster of lights...
- `CaseText` (seq 58) cas 10 → texte  ...[K]That cluster of lights...
- `message_SwitchTalk` (seq 60) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 61) cas 12 → texte  It's beautiful, but...
- `CaseText` (seq 62) cas 13 → texte  It's beautiful, but...
- `message_SwitchTalk` (seq 64) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 65) cas 15 → texte  Those lights...[K] Isn't that...[K]
the stockade?
- `CaseText` (seq 66) cas 16 → texte  Those lights...[K] Isn't that...[K]
the stockade?
- `message_SwitchTalk` (seq 70) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 71) cas 18 → texte  Hey, [hero]...
- `CaseText` (seq 72) cas 19 → texte  Hey, [hero]...
- `message_SwitchTalk` (seq 81) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 82) cas 21 → texte  The great [CS:N]Dusknoir[CR] saved us
more than once.
- `CaseText` (seq 83) cas 22 → texte  The great [CS:N]Dusknoir[CR] saved us
more than once.
- `message_SwitchTalk` (seq 85) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 86) cas 24 → texte  He taught us many things too.
- `CaseText` (seq 87) cas 25 → texte  He taught us many things too.
- `message_SwitchTalk` (seq 89) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 90) cas 27 → texte  That's why I...[K]I really looked up
to [CS:N]Dusknoir[CR].
- `CaseText` (seq 91) cas 28 → texte  That's why I...[K]I came to really
respect [CS:N]Dusknoir[CR].
- `message_SwitchTalk` (seq 93) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 94) cas 30 → texte  But was [CS:N]Dusknoir[CR]...[K]deceiving us?
- `CaseText` (seq 95) cas 31 → texte  But was [CS:N]Dusknoir[CR]...[K]deceiving us?
- `message_SwitchTalk` (seq 97) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 98) cas 33 → texte  Even after all this...[K]I still can't
believe it.
- `CaseText` (seq 99) cas 34 → texte  Even after all this...[K]I still can't
believe it.
- `message_SwitchTalk` (seq 101) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 102) cas 36 → texte  I don't know what to believe
anymore...
- `CaseText` (seq 103) cas 37 → texte  I don't know what to believe
anymore...
- `message_SwitchTalk` (seq 105) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 106) cas 39 → texte  My head feels all messed up...
- `CaseText` (seq 107) cas 40 → texte  I'm feeling all jumbled up...
- `message_SwitchMonologue` (seq 111) sur **HERO_TALK_KIND**
- `CaseText` (seq 112) cas 42 → texte ([partner]...)
- `message_SwitchTalk` (seq 122) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 123) cas 44 → texte  What should we...[K] What should
we do now?
- `CaseText` (seq 124) cas 45 → texte  What should we...[K] What should
we do now?
- `message_SwitchTalk` (seq 126) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 127) cas 47 → texte  When can we stop running?
- `CaseText` (seq 128) cas 48 → texte  How far do we have to run?
- `message_SwitchTalk` (seq 130) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 131) cas 50 → texte  Can we return to our world?
- `CaseText` (seq 132) cas 51 → texte  How do we go back to our
own world?
- `message_SwitchTalk` (seq 137) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 138) cas 53 → texte  ..................
- `CaseText` (seq 139) cas 54 → texte  ..................
- `message_SwitchTalk` (seq 141) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 142) cas 56 → texte  Everyone at the guild...[K] I wonder
how they're doing?
- `CaseText` (seq 143) cas 57 → texte  Everyone at the guild...[K] I wonder
how they're doing?
- `message_SwitchTalk` (seq 145) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 146) cas 59 → texte  Are they worried about us
being gone?
- `CaseText` (seq 147) cas 60 → texte  Are they worried about us?
- `message_SwitchTalk` (seq 149) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 150) cas 62 → texte  [CS:N]Wigglytuff[CR], [CS:N]Chatot[CR], [CS:N]Bidoof[CR], and
everyone else...[K] I wonder if they're doing well?
- `CaseText` (seq 151) cas 63 → texte  [CS:N]Wigglytuff[CR], [CS:N]Chatot[CR], [CS:N]Bidoof[CR], and
everyone else...[K] I wonder if they're doing well?
- `message_SwitchTalk` (seq 170) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 171) cas 65 → texte  I m-m-miss the guild...[K] I want
to see everyone!
- `CaseText` (seq 172) cas 66 → texte  I m-m-miss the guild...[K] I want
to see everyone!
- `message_SwitchMonologue` (seq 176) sur **HERO_TALK_KIND**
- `CaseText` (seq 177) cas 68 → texte ([partner]'s feeling pretty down.)
- `message_SwitchMonologue` (seq 179) sur **HERO_TALK_KIND**
- `CaseText` (seq 180) cas 70 → texte (It's only natural.)
- `message_SwitchMonologue` (seq 182) sur **HERO_TALK_KIND**
- `CaseText` (seq 183) cas 72 → texte (What's happened so far...[K] It's all so hard
to believe.)
- `message_SwitchMonologue` (seq 185) sur **HERO_TALK_KIND**
- `CaseText` (seq 186) cas 74 → texte (I'm...[K]scared too.)
- `message_SwitchMonologue` (seq 194) sur **HERO_TALK_KIND**
- `CaseText` (seq 195) cas 76 → texte (But...[K]I can't give up now.)
- `message_SwitchMonologue` (seq 197) sur **HERO_TALK_KIND**
- `CaseText` (seq 198) cas 78 → texte (If we don't keep going, those [CS:N]Sableye[CR] will
catch us.)
- `message_SwitchMonologue` (seq 200) sur **HERO_TALK_KIND**
- `CaseText` (seq 201) cas 80 → texte (I've got to do something to cheer up
[partner].)
- `message_SwitchMonologue` (seq 204) sur **HERO_TALK_KIND**
- `CaseText` (seq 205) cas 82 → texte (But words of support will seem like false
comfort right now...)
- `message_SwitchMonologue` (seq 207) sur **HERO_TALK_KIND**
- `CaseText` (seq 208) cas 84 → texte (If there were something I could say...[K]
Something that offers a glimmer of hope...)
- `message_SwitchMonologue` (seq 210) sur **HERO_TALK_KIND**
- `CaseText` (seq 211) cas 86 → texte (If only there were some hope, we could work
toward it...)
- `message_SwitchMonologue` (seq 213) sur **HERO_TALK_KIND**
- `CaseText` (seq 214) cas 88 → texte (It could be anything.[K] I just need to think
of something!)
- `message_SwitchTalk` (seq 235) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 236) cas 90 → texte  Huh?
- `CaseText` (seq 237) cas 91 → texte  Hmm?
- `message_SwitchTalk` (seq 240) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 241) cas 93 → texte  What's up, [hero]?
- `CaseText` (seq 242) cas 94 → texte  What is it, [hero]?
- `message_SwitchMenu` (seq 244) sur **0**
- `message_SwitchMenu` (seq 244) sur **1**
- `message_SwitchTalk` (seq 253) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 254) cas 98 → texte  What?![K] You want to go after
[CS:N]Grovyle[CR]?
- `CaseText` (seq 255) cas 99 → texte  What?![K] You want to go after
[CS:N]Grovyle[CR]?
- `message_SwitchTalk` (seq 258) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 259) cas 101 → texte  Wh-why?!
- `CaseText` (seq 260) cas 102 → texte  Wh-why?!
- `message_SwitchTalk` (seq 269) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 270) cas 104 → texte  Huh?![K] Let's return to our world?
- `CaseText` (seq 271) cas 105 → texte  What?![K] Let's return to
our world?
- `message_SwitchTalk` (seq 273) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 274) cas 107 → texte  How are we supposed to return?
- `CaseText` (seq 275) cas 108 → texte  How are we supposed to return?
- `message_SwitchTalk` (seq 277) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 278) cas 110 → texte  Well, sure, it would be great if
we could go back to our world...
- `CaseText` (seq 279) cas 111 → texte  Well, sure, it would be great if
we could go back to our world...
- `message_SwitchTalk` (seq 281) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 282) cas 113 → texte  But...how?
- `CaseText` (seq 283) cas 114 → texte  But...how?
- `message_SwitchTalk` (seq 296) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 297) cas 116 → texte  Huh?[K] We're going to first find
[CS:N]Grovyle[CR]?
- `CaseText` (seq 298) cas 117 → texte  What?[K] We're going to first find
[CS:N]Grovyle[CR]?
- `message_SwitchTalk` (seq 301) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 302) cas 119 → texte  So we find [CS:N]Grovyle[CR]...[K]
Then what?
- `CaseText` (seq 303) cas 120 → texte  So if we do find [CS:N]Grovyle[CR]...[K]
Then what?
- `message_SwitchMenu` (seq 306) sur **0**
- `message_SwitchMenu` (seq 306) sur **1**
- `message_SwitchTalk` (seq 311) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 312) cas 124 → texte  Ask him something?
- `CaseText` (seq 313) cas 125 → texte  Ask him something?
- `message_SwitchTalk` (seq 315) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 316) cas 127 → texte  Oh...[K]right...
- `CaseText` (seq 317) cas 128 → texte  Oh...[K]I see...
- `message_SwitchTalk` (seq 322) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 323) cas 130 → texte  You wanted to know something?
- `CaseText` (seq 324) cas 131 → texte  You wanted to know something?
- `message_SwitchTalk` (seq 326) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 327) cas 133 → texte  Oh...[K]right...
- `CaseText` (seq 328) cas 134 → texte  Oh...[K]I see...
- `message_SwitchTalk` (seq 332) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 333) cas 136 → texte  [CS:N]Grovyle[CR] went to our world from
here the first time.
- `CaseText` (seq 334) cas 137 → texte  [CS:N]Grovyle[CR] went to our world from
here the first time.
- `message_SwitchTalk` (seq 336) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 337) cas 139 → texte  So [CS:N]Grovyle[CR] should know how
to go to our world.
- `CaseText` (seq 338) cas 140 → texte  So [CS:N]Grovyle[CR] should know how
to travel to our world.
- `message_SwitchTalk` (seq 340) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 341) cas 142 → texte  But...[K]isn't [CS:N]Grovyle[CR] a bad
Pokémon?
- `CaseText` (seq 342) cas 143 → texte  But...[K]isn't [CS:N]Grovyle[CR] a bad
Pokémon?
- `message_SwitchTalk` (seq 344) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 345) cas 145 → texte  Didn't he...[K]come to our world to
steal the Time Gears?
- `CaseText` (seq 346) cas 146 → texte  Didn't he...[K]come to our world to
steal the Time Gears?
- `message_SwitchTalk` (seq 348) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 349) cas 148 → texte  How could I trust anything that
he'd say?
- `CaseText` (seq 350) cas 149 → texte  How could I trust anything he
would say?
- `message_SwitchTalk` (seq 352) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 353) cas 151 → texte  What about you, [hero]?
- `CaseText` (seq 354) cas 152 → texte  What about you, [hero]?
- `message_SwitchTalk` (seq 357) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 358) cas 154 → texte  Do you trust [CS:N]Grovyle[CR],
[hero]?
- `CaseText` (seq 359) cas 155 → texte  Do you trust [CS:N]Grovyle[CR],
[hero]?
- `message_SwitchMenu` (seq 362) sur **0**
- `message_SwitchMenu` (seq 362) sur **1**
- `message_SwitchTalk` (seq 367) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 368) cas 159 → texte  Well...[K]I can't trust him!
- `CaseText` (seq 369) cas 160 → texte  Well...[K]I can't trust him!
- `message_SwitchTalk` (seq 376) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 377) cas 162 → texte  A Pokémon like that? Never!
- `CaseText` (seq 378) cas 163 → texte  A Pokémon like that? Never!
- `message_SwitchTalk` (seq 380) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 381) cas 165 → texte  There's no way that I can
trust him!
- `CaseText` (seq 382) cas 166 → texte  There's no way that I can
trust him!
- `message_SwitchTalk` (seq 384) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 385) cas 168 → texte  There's just no way! But...
- `CaseText` (seq 386) cas 169 → texte  There's just no way! But...
- `message_SwitchTalk` (seq 391) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 392) cas 171 → texte  But...[K]I understand, [hero].
- `CaseText` (seq 393) cas 172 → texte  But...[K]I understand, [hero].
- `message_SwitchTalk` (seq 395) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 396) cas 174 → texte  I don't know why, but [CS:N]Dusknoir[CR]
wants to get rid of us.
- `CaseText` (seq 397) cas 175 → texte  I don't know why, but [CS:N]Dusknoir[CR]
wants to get rid of us.
- `message_SwitchTalk` (seq 399) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 400) cas 177 → texte  That means the only other
Pokémon we know here in the future...
- `CaseText` (seq 401) cas 178 → texte  That means the only other
Pokémon we know here in the future...
- `message_SwitchTalk` (seq 403) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 404) cas 180 → texte  That leaves only [CS:N]Grovyle[CR]...
- `CaseText` (seq 405) cas 181 → texte  That leaves only [CS:N]Grovyle[CR]...
- `message_SwitchTalk` (seq 407) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 408) cas 183 → texte  We don't have any choice.[K]
We must rely on [CS:N]Grovyle[CR].
- `CaseText` (seq 409) cas 184 → texte  We have no choice.[K] We must pin
our hopes on [CS:N]Grovyle[CR].
- `message_SwitchTalk` (seq 415) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 416) cas 186 → texte  And you don't know either,
do you, [hero]?
- `CaseText` (seq 417) cas 187 → texte  And you don't know either,
do you, [hero]?
- `message_SwitchTalk` (seq 419) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 420) cas 189 → texte  But you still want to catch up to
[CS:N]Grovyle[CR] and talk to him?
- `CaseText` (seq 421) cas 190 → texte  But you still insist on catching
up to [CS:N]Grovyle[CR] so you can talk to him?
- `message_SwitchTalk` (seq 423) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 424) cas 192 → texte  And then trust what he says?
- `CaseText` (seq 425) cas 193 → texte  And then trust what he says?
- `message_SwitchTalk` (seq 437) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 438) cas 195 → texte  Well...[K]I hate this idea!
- `CaseText` (seq 439) cas 196 → texte  Well...[K]I hate this idea!
- `message_SwitchTalk` (seq 446) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 447) cas 198 → texte  Trust a Pokémon like that?[K]
Never!
- `CaseText` (seq 448) cas 199 → texte  Trust a Pokémon like that?[K]
Never!
- `message_SwitchTalk` (seq 450) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 451) cas 201 → texte  That bad Pokémon![K] Trust that...
- `CaseText` (seq 452) cas 202 → texte  That bad Pokémon![K] Trust that...
- `message_SwitchTalk` (seq 455) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 456) cas 204 → texte  I don't want to...[K] But...
- `CaseText` (seq 457) cas 205 → texte  I don't want to...[K] But...
- `message_SwitchTalk` (seq 461) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 462) cas 207 → texte  But...[K]maybe we don't have any
other choice...
- `CaseText` (seq 463) cas 208 → texte  But...[K]maybe we don't have any
other choice...
- `message_SwitchTalk` (seq 465) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 466) cas 210 → texte  I don't know why, but [CS:N]Dusknoir[CR]
wants to get rid of us.
- `CaseText` (seq 467) cas 211 → texte  I don't know why, but [CS:N]Dusknoir[CR]
wants to get rid of us.
- `message_SwitchTalk` (seq 469) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 470) cas 213 → texte  That means the only other
Pokémon we know here in the future...
- `CaseText` (seq 471) cas 214 → texte  That means the only other
Pokémon we know here in the future...
- `message_SwitchTalk` (seq 473) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 474) cas 216 → texte  That leaves only [CS:N]Grovyle[CR]...
- `CaseText` (seq 475) cas 217 → texte  That leaves only [CS:N]Grovyle[CR]...
- `message_SwitchTalk` (seq 477) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 478) cas 219 → texte  We don't have any choice.[K]
We must rely on [CS:N]Grovyle[CR].
- `CaseText` (seq 479) cas 220 → texte  We have no choice.[K] We must pin
our hopes on [CS:N]Grovyle[CR].
- `message_SwitchTalk` (seq 489) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 490) cas 222 → texte  Well then...[K]all right.
- `CaseText` (seq 491) cas 223 → texte  Well then...[K]OK.
- `message_SwitchTalk` (seq 497) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 498) cas 225 → texte  All right, [hero].[K]
Let's chase after [CS:N]Grovyle[CR]!
- `CaseText` (seq 499) cas 226 → texte  OK, [hero].[K] Let's track
down [CS:N]Grovyle[CR]!
- `message_SwitchTalk` (seq 501) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 502) cas 228 → texte  Let's meet with [CS:N]Grovyle[CR] and ask
him how to get back to our world!
- `CaseText` (seq 503) cas 229 → texte  Let's meet with [CS:N]Grovyle[CR] and ask
him how we can return to our world!
- `message_SwitchMonologue` (seq 507) sur **HERO_TALK_KIND**
- `CaseText` (seq 508) cas 231 → texte ([partner]!)
- `message_SwitchTalk` (seq 515) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 516) cas 233 → texte  Let's go, [hero]!
- `CaseText` (seq 517) cas 234 → texte  Let's go, [hero]!
- `message_SwitchTalk` (seq 519) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 520) cas 236 → texte  Let's go after [CS:N]Grovyle[CR]!
- `CaseText` (seq 521) cas 237 → texte  Let's go after [CS:N]Grovyle[CR]!
- `message_SwitchTalk` (seq 547) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 548) cas 239 → texte  [hero], thanks.
- `CaseText` (seq 549) cas 240 → texte  [hero], thank you.
- `message_SwitchTalk` (seq 557) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 558) cas 242 → texte  You were worried about me for
being so down.
- `CaseText` (seq 559) cas 243 → texte  You tried to pick me up because
I was feeling down.
- `message_SwitchTalk` (seq 561) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 562) cas 245 → texte  Even though you should be just 
as scared as I am, [hero]...[K] I'm sorry.
- `CaseText` (seq 563) cas 246 → texte  Even though you should be just 
as scared as I am, [hero]...[K] I'm sorry.
- `message_SwitchTalk` (seq 565) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 566) cas 248 → texte  Even though I have my closest
and most precious friend with me...
- `CaseText` (seq 567) cas 249 → texte  Even though I have my closest
and most precious friend with me...
- `message_SwitchTalk` (seq 569) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 570) cas 251 → texte  I worried all alone...
- `CaseText` (seq 571) cas 252 → texte  I worried all alone...
- `message_SwitchTalk` (seq 573) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 574) cas 254 → texte  And almost gave up alone.
- `CaseText` (seq 575) cas 255 → texte  And almost gave up alone.
- `message_SwitchTalk` (seq 577) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 578) cas 257 → texte  When, in fact, I'm not alone.
- `CaseText` (seq 579) cas 258 → texte  When, in fact, I'm not alone.
- `message_SwitchTalk` (seq 595) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 596) cas 260 → texte  I won't give up anymore.
- `CaseText` (seq 597) cas 261 → texte  I won't give up anymore.
- `message_SwitchTalk` (seq 599) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 600) cas 263 → texte  Because you're by my side, I can
be brave, [hero].
- `CaseText` (seq 601) cas 264 → texte  Because you're by my side, I can
be brave, [hero].
- `message_SwitchTalk` (seq 603) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 604) cas 266 → texte  I'm going to be fine now.
- `CaseText` (seq 605) cas 267 → texte  I'm going to be fine now.
- `message_SwitchTalk` (seq 607) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 608) cas 269 → texte  So let's keep going,
[hero].
- `CaseText` (seq 609) cas 270 → texte  So let's keep going,
[hero].
- `message_SwitchTalk` (seq 611) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 612) cas 272 → texte  Let's get back to our world...[K]
together!
- `CaseText` (seq 613) cas 273 → texte  Let's get back to our world...[K]
together!
**Fin de scène :** `End` aux séquences [641]

### P06P01A / m26a0614.ssb

**Transitions :**
- `back2_SetGround` (seq 2) → niveau **S04P01A** (raw 275)
- `back_SetGround` (seq 3) → niveau **P06P01A** (raw 237)
**Routines :**
- `CallCommon` (seq 17) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
**Conditions / embranchements :**
- `message_SwitchTalk` (seq 13) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 14) cas 0 → texte  [hero], thanks.
- `CaseText` (seq 15) cas 1 → texte  [hero], thank you.
- `message_SwitchTalk` (seq 23) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 24) cas 3 → texte  You were worried about me for
being so down.
- `CaseText` (seq 25) cas 4 → texte  You tried to pick me up because
I was feeling down.
**Fin de scène :** `End` aux séquences [31]

### P07P01A / m18b1401.ssb

**Transitions :**
- `back2_SetGround` (seq 7) → niveau **V09P04A** (raw 365)
- `back_SetGround` (seq 8) → niveau **P07P01A** (raw 238)
**Routines :**
- `CallCommon` (seq 37) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 47) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 52) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 58) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 65) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 71) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 79) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 91) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 99) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 133) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 143) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 171) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 176) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 182) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 189) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 196) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 202) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 205) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 208) → **JUMP_ANGRY_FUNC_SERIES** (raw 41)
- `CallCommon` (seq 235) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 260) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 275) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 283) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 294) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 301) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 306) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 316) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 323) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 336) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 340) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 357) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 362) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 368) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 377) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 399) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 434) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 465) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 476) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 493) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 507) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
**Flags / variables :**
- `flag_SetScenario` (seq 533) → **SCENARIO_MAIN** [scenario_value=20(20), level_value=0(0)]
**Conditions / embranchements :**
- `message_SwitchTalk` (seq 39) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 40) cas 3 → texte  Tell us, [CS:N]Grovyle[CR].
- `CaseText` (seq 41) cas 4 → texte  Tell us, [CS:N]Grovyle[CR].
- `message_SwitchTalk` (seq 43) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 44) cas 6 → texte  In the future...[K] Why did the
planet become paralyzed?
- `CaseText` (seq 45) cas 7 → texte  In the future...[K] Why did the
planet's paralysis take place?
- `message_SwitchTalk` (seq 54) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 55) cas 12 → texte  [CS:N]D-Dialga[CR]?[K] Who is that?
- `CaseText` (seq 56) cas 13 → texte  [CS:N]D-Dialga[CR]?[K] Who is that?
- `message_SwitchTalk` (seq 67) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 68) cas 20 → texte  What...[K]what happened to [CS:N]Dialga[CR]?
- `CaseText` (seq 69) cas 21 → texte  What...[K]what happened to [CS:N]Dialga[CR]?
- `message_SwitchTalk` (seq 81) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 82) cas 29 → texte  OK... Urf...
- `CaseText` (seq 83) cas 30 → texte  OK... Urf...
- `message_SwitchTalk` (seq 109) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 110) cas 38 → texte  What?!
- `CaseText` (seq 111) cas 39 → texte  What?!
- `message_SwitchTalk` (seq 113) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 114) cas 41 → texte  [CS:N]Grovyle[CR], you're saying that you
came back to our world...
- `CaseText` (seq 115) cas 42 → texte  [CS:N]Grovyle[CR], you're saying that you
came back to our world...
- `message_SwitchTalk` (seq 117) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 118) cas 44 → texte  So you could prevent the planet's
paralysis?!
- `CaseText` (seq 119) cas 45 → texte  So you could prevent the planet's
paralysis?!
- `message_SwitchTalk` (seq 121) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 122) cas 47 → texte  But that's...[K]completely the
opposite of what we were told!
- `CaseText` (seq 123) cas 48 → texte  But that's...[K]completely the
opposite of what we were told!
- `message_SwitchTalk` (seq 125) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 126) cas 50 → texte  [CS:N]Grovyle[CR], you came back to our
world to paralyze the planet...didn't you?!
- `CaseText` (seq 127) cas 51 → texte  [CS:N]Grovyle[CR], you came back to our
world to paralyze the planet...didn't you?!
- `message_SwitchTalk` (seq 129) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 130) cas 53 → texte  And, [CS:N]Grovyle[CR]...[K]weren't you the
one stealing the Time Gears?!
- `CaseText` (seq 131) cas 54 → texte  And, [CS:N]Grovyle[CR]...[K]weren't you the
one stealing the Time Gears?!
- `message_SwitchTalk` (seq 151) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 152) cas 64 → texte  Urf...[K] But then, what about all
the things [CS:N]Dusknoir[CR] said about you?
- `CaseText` (seq 153) cas 65 → texte  Urf...[K] But then, what about all
the things [CS:N]Dusknoir[CR] said about you?
- `message_SwitchTalk` (seq 155) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 156) cas 67 → texte  Like how he said you were a
wanted outlaw in the future.
- `CaseText` (seq 157) cas 68 → texte  Like how he said you were a
wanted outlaw in the future.
- `message_SwitchTalk` (seq 159) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 160) cas 70 → texte  And how you escaped from
the future...
- `CaseText` (seq 161) cas 71 → texte  And how you escaped from
the future...
- `message_SwitchTalk` (seq 163) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 164) cas 73 → texte  then fled to our world in
the past.
- `CaseText` (seq 165) cas 74 → texte  then fled to our world in
the past.
- `message_SwitchTalk` (seq 167) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 168) cas 76 → texte  So you're saying all that was
just a bunch of lies?
- `CaseText` (seq 169) cas 77 → texte  So you're claiming all that was
just a bunch of lies?
- `message_SwitchTalk` (seq 185) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 186) cas 82 → texte  What?![K] [CS:N]Dusknoir[CR] was...[K]an agent
sent to get rid of you?!
- `CaseText` (seq 187) cas 83 → texte  What?![K] [CS:N]Dusknoir[CR] was...[K]an agent
sent to get rid of you?!
- `message_SwitchTalk` (seq 198) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 199) cas 90 → texte  The great...[K][CS:N]Dusknoir[CR]...?[K]
It can't be!
- `CaseText` (seq 200) cas 91 → texte  The great...[K][CS:N]Dusknoir[CR]...?[K]
It can't be!
- `message_SwitchTalk` (seq 214) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 215) cas 94 → texte  I can't believe it at all!
- `CaseText` (seq 216) cas 95 → texte  I can't believe it at all!
- `message_SwitchTalk` (seq 218) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 219) cas 97 → texte  You're saying all this about
the great [CS:N]Dusknoir[CR]?!
- `CaseText` (seq 220) cas 98 → texte  You're saying all this about
the great [CS:N]Dusknoir[CR]?!
- `message_SwitchTalk` (seq 222) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 223) cas 100 → texte  I don't understand why [CS:N]Dusknoir[CR]
is acting this way here, but...
- `CaseText` (seq 224) cas 101 → texte  I don't understand why [CS:N]Dusknoir[CR]
is acting this way here, but...
- `message_SwitchTalk` (seq 226) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 227) cas 103 → texte  But I admired...[K][CS:N]Dusknoir[CR]...
- `CaseText` (seq 228) cas 104 → texte  But I respected...[K][CS:N]Dusknoir[CR]...
- `message_SwitchTalk` (seq 231) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 232) cas 106 → texte  I can't...[K] I can't believe you...
- `CaseText` (seq 233) cas 107 → texte  I can't...[K] I can't believe you...
- `message_SwitchMonologue` (seq 239) sur **HERO_TALK_KIND**
- `CaseText` (seq 240) cas 109 → texte (It is hard to accept, but...)
- `message_SwitchMonologue` (seq 242) sur **HERO_TALK_KIND**
- `CaseText` (seq 243) cas 111 → texte (Looking back over what we've been through in
this future world...)
- `message_SwitchMonologue` (seq 245) sur **HERO_TALK_KIND**
- `CaseText` (seq 246) cas 113 → texte (What [CS:N]Grovyle[CR] said is reasonable.[K] It makes
perfect sense.)
- `message_SwitchMonologue` (seq 248) sur **HERO_TALK_KIND**
- `CaseText` (seq 249) cas 115 → texte (And [partner] knows it.)
- `message_SwitchMonologue` (seq 251) sur **HERO_TALK_KIND**
- `CaseText` (seq 252) cas 117 → texte ([partner] knows deep down that what
[CS:N]Grovyle[CR] says is true.)
- `message_SwitchMonologue` (seq 254) sur **HERO_TALK_KIND**
- `CaseText` (seq 255) cas 119 → texte (But knowing that makes it that much harder
to accept...)
- `message_SwitchMonologue` (seq 257) sur **HERO_TALK_KIND**
- `CaseText` (seq 258) cas 121 → texte (But...)
- `message_SwitchTalk` (seq 279) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 280) cas 124 → texte  I'm going to see [CS:N]Dusknoir[CR].
- `CaseText` (seq 281) cas 125 → texte  I'm going to see [CS:N]Dusknoir[CR].
- `message_SwitchTalk` (seq 297) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 298) cas 128 → texte  I want to see [CS:N]Dusknoir[CR].[K]
I'm going to find out if what you said is true
or not.
- `CaseText` (seq 299) cas 129 → texte  I want to see [CS:N]Dusknoir[CR].[K]
I'm going to find out if what you said is true
or not.
- `message_SwitchTalk` (seq 312) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 313) cas 134 → texte  Then...[K]what am I supposed
to do?!
- `CaseText` (seq 314) cas 135 → texte  Then...[K]what am I supposed
to do?!
- `message_SwitchTalk` (seq 332) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 333) cas 142 → texte  Urk...
- `CaseText` (seq 334) cas 143 → texte  Urk...
- `message_SwitchTalk` (seq 352) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 353) cas 147 → texte  [CS:N]Grovyle[CR]...[K] What are you going
to do now?
- `CaseText` (seq 354) cas 148 → texte  [CS:N]Grovyle[CR]...[K] What are you going
to do now?
- `message_SwitchTalk` (seq 364) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 365) cas 153 → texte  [CS:N]Cel[CR]...[K][CS:N]Celebi[CR]?
- `CaseText` (seq 366) cas 154 → texte  [CS:N]Cel[CR]...[K][CS:N]Celebi[CR]?
- `message_SwitchTalk` (seq 395) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 396) cas 160 → texte  Urk...
- `CaseText` (seq 397) cas 161 → texte  Urk...
- `message_SwitchMonologue` (seq 405) sur **HERO_TALK_KIND**
- `CaseText` (seq 406) cas 163 → texte (...............)
- `message_SwitchMonologue` (seq 408) sur **HERO_TALK_KIND**
- `CaseText` (seq 409) cas 165 → texte (I don't know what I should believe either.)
- `message_SwitchMonologue` (seq 411) sur **HERO_TALK_KIND**
- `CaseText` (seq 412) cas 167 → texte (But...[K]there is one thing I can say with
certainty.)
- `message_SwitchMonologue` (seq 414) sur **HERO_TALK_KIND**
- `CaseText` (seq 415) cas 169 → texte (In this future world of darkness...)
- `message_SwitchMonologue` (seq 417) sur **HERO_TALK_KIND**
- `CaseText` (seq 418) cas 171 → texte (The planet is paralyzed.)
- `message_SwitchMonologue` (seq 420) sur **HERO_TALK_KIND**
- `CaseText` (seq 421) cas 173 → texte (And the paralysis of the planet...[K] It happened
back in our world.)
- `message_SwitchMonologue` (seq 423) sur **HERO_TALK_KIND**
- `CaseText` (seq 424) cas 175 → texte (That's why, to stop that from happening...)
- `message_SwitchMonologue` (seq 428) sur **HERO_TALK_KIND**
- `CaseText` (seq 429) cas 177 → texte (We have to get back to the past!)
- `message_SwitchMonologue` (seq 431) sur **HERO_TALK_KIND**
- `CaseText` (seq 432) cas 179 → texte (We have to get back![K] Back to our world!)
- `message_SwitchTalk` (seq 449) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 450) cas 181 → texte  [hero]...
- `CaseText` (seq 451) cas 182 → texte  [hero]...
- `message_SwitchTalk` (seq 453) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 454) cas 184 → texte  Yup...[K] I know...
- `CaseText` (seq 455) cas 185 → texte  Yes...[K] I know...
- `message_SwitchTalk` (seq 457) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 458) cas 187 → texte  What [CS:N]Grovyle[CR] said...[K] [CS:N]Grovyle[CR] is
right...
- `CaseText` (seq 459) cas 188 → texte  What [CS:N]Grovyle[CR] said...[K] [CS:N]Grovyle[CR] is
right...
- `message_SwitchTalk` (seq 461) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 462) cas 190 → texte  Things are very tough now...[K]
That's why we have to be strong.
- `CaseText` (seq 463) cas 191 → texte  Things are very tough now...[K]
That's why we have to be strong.
- `message_SwitchTalk` (seq 468) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 469) cas 193 → texte  I'm all right now...[K] Let's go.
- `CaseText` (seq 470) cas 194 → texte  I'm all right now...[K] Let's go.
- `message_SwitchTalk` (seq 472) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 473) cas 196 → texte  Let's catch up to [CS:N]Grovyle[CR].
- `CaseText` (seq 474) cas 197 → texte  Let's catch up to [CS:N]Grovyle[CR].
- `message_SwitchTalk` (seq 489) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 490) cas 199 → texte  [hero].
- `CaseText` (seq 491) cas 200 → texte  [hero].
- `message_SwitchTalk` (seq 499) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 500) cas 202 → texte  We have to...[K] We have to
get back!
- `CaseText` (seq 501) cas 203 → texte  We have to...[K] We have to
get back!
- `message_SwitchTalk` (seq 503) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 504) cas 205 → texte  Back to our own world!
- `CaseText` (seq 505) cas 206 → texte  Back to our own world!
**Fin de scène :** `End` aux séquences [534]

### P07P01A / m26a06e6.ssb

**Transitions :**
- `back2_SetGround` (seq 2) → niveau **V09P04A** (raw 365)
- `back_SetGround` (seq 3) → niveau **P07P01A** (raw 238)
**Routines :**
- `CallCommon` (seq 34) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
**Conditions / embranchements :**
- `message_SwitchTalk` (seq 30) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 31) cas 0 → texte  [hero].
- `CaseText` (seq 32) cas 1 → texte  [hero].
- `message_SwitchTalk` (seq 40) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 41) cas 3 → texte  We have to...[K] We have to
get back!
- `CaseText` (seq 42) cas 4 → texte  We have to...[K] We have to
get back!
- `message_SwitchTalk` (seq 44) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 45) cas 6 → texte  Back to our own world!
- `CaseText` (seq 46) cas 7 → texte  Back to our own world!
**Fin de scène :** `End` aux séquences [52]

### P08P01A / m19a0601.ssb

**Transitions :**
- `back_SetGround` (seq 6) → niveau **P08P01A** (raw 239)
**Routines :**
- `ExecuteCommon` (seq 21) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
- `CallCommon` (seq 34) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 44) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 53) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 57) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
- `CallCommon` (seq 69) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 91) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 95) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 102) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 109) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 115) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
- `ExecuteCommon` (seq 118) → **LOOK_AROUND_LEFT_FUNC_SERIES** (raw 35)
- `CallCommon` (seq 142) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 145) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 150) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 155) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 173) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 176) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 188) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 194) → **JUMP_ANGRY_FUNC_SERIES** (raw 41)
- `CallCommon` (seq 201) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 223) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 230) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 245) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 251) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 259) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 267) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 269) → **JUMP_HAPPY_FUNC_SERIES** (raw 37)
- `CallCommon` (seq 274) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 279) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 286) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 289) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 292) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 297) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 300) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 305) → **JUMP_HAPPY_FUNC_SERIES** (raw 37)
- `CallCommon` (seq 310) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 313) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 327) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 337) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 342) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 354) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 362) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 373) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
**Conditions / embranchements :**
- `message_SwitchTalk` (seq 30) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 31) cas 0 → texte  Is this...[K] Is this where [CS:N]Celebi[CR]'s
supposed to be?
- `CaseText` (seq 32) cas 1 → texte  Is this...[K] Is this where [CS:N]Celebi[CR] is
supposed to be?
- `message_SwitchTalk` (seq 61) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 62) cas 11 → texte  She's...[K]not coming out...
- `CaseText` (seq 63) cas 12 → texte  She's...[K]not coming out...
- `message_SwitchTalk` (seq 65) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 66) cas 14 → texte  Did Primal [CS:N]Dialga[CR] chase her off?
- `CaseText` (seq 67) cas 15 → texte  Did she get frightened off by
Primal [CS:N]Dialga[CR]?
- `message_SwitchTalk` (seq 83) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 84) cas 17 → texte  What if...
- `CaseText` (seq 85) cas 18 → texte  What if...
- `message_SwitchTalk` (seq 87) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 88) cas 20 → texte  What if she's...[K]been captured by
Primal [CS:N]Dialga[CR]?
- `CaseText` (seq 89) cas 21 → texte  What if she's...[K]been captured by
Primal [CS:N]Dialga[CR]?
- `message_SwitchTalk` (seq 105) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 106) cas 24 → texte  Whoa! Who said that?!
- `CaseText` (seq 107) cas 25 → texte  Wah! Where'd that voice
come from?!
- `message_SwitchTalk` (seq 134) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 135) cas 27 → texte  But now...[K]I don't hear anything.
- `CaseText` (seq 136) cas 28 → texte  But now...[K]I don't hear anything.
- `message_SwitchTalk` (seq 138) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 139) cas 30 → texte  That voice...[K] Did I imagine it?
- `CaseText` (seq 140) cas 31 → texte  That voice...[K] Was I just
hearing things?
- `message_SwitchTalk` (seq 184) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 185) cas 39 → texte  Huh?![K] This tiny thing is [CS:N]Celebi[CR]?
- `CaseText` (seq 186) cas 40 → texte  What?![K] This tiny thing is [CS:N]Celebi[CR]?
- `message_SwitchTalk` (seq 211) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 212) cas 44 → texte  Uh...[K]I'm sorry.
- `CaseText` (seq 213) cas 45 → texte  Uh...[K]I'm sorry.
- `message_SwitchTalk` (seq 215) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 216) cas 47 → texte  I heard you have the ability to
cross time...
- `CaseText` (seq 217) cas 48 → texte  I heard you have the ability to
cross time...
- `message_SwitchTalk` (seq 219) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 220) cas 50 → texte  So I was expecting to see some
kind of an awesome-looking Pokémon...
- `CaseText` (seq 221) cas 51 → texte  So I expected you to be some
awe-inspiring Pokémon...
- `message_SwitchTalk` (seq 241) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 242) cas 57 → texte  Uh, yeah...
- `CaseText` (seq 243) cas 58 → texte  Um, yes.
- `message_SwitchMonologue` (seq 334) sur **HERO_TALK_KIND**
- `CaseText` (seq 335) cas 83 → texte (What...?[K] What...?)
**Fin de scène :** `End` aux séquences [388]

### P08P01A / m19d0612.ssb

**Transitions :**
- `back_SetGround` (seq 0) → niveau **P08P01A** (raw 239)
**Fin de scène :** `End` aux séquences [14]

### P08P01A / n08a2308.ssb

**Transitions :**
- `back_SetGround` (seq 7) → niveau **P08P01A** (raw 239)
- `main_EnterDungeon` (seq 202) → niveau **None** (raw None)
- `main_EnterDungeon` (seq 202) → niveau **None** (raw None)
- `main_EnterDungeon` (seq 203) → niveau **None** (raw None)
- `main_EnterDungeon` (seq 203) → niveau **None** (raw None)
**Routines :**
- `ExecuteCommon` (seq 21) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
- `CallCommon` (seq 30) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 37) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 45) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 50) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 59) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 116) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 121) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 125) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 128) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 201) → **BOSS_WIPE_FUNC** (raw 691)
**Flags / variables :**
- `flag_SetScenario` (seq 1) → **SCENARIO_SIDE** [scenario_value=47(47), level_value=10(10)]
**Fin de scène :** `End` aux séquences [205]

### P08P01A / n08a2408.ssb

**Transitions :**
- `back_SetGround` (seq 3) → niveau **P08P01A** (raw 239)
**Routines :**
- `CallCommon` (seq 57) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 60) → **LOOK_AROUND_LEFT_FUNC_SERIES** (raw 35)
- `ExecuteCommon` (seq 63) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
- `ExecuteCommon` (seq 66) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
- `ExecuteCommon` (seq 69) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
- `ExecuteCommon` (seq 72) → **LOOK_AROUND_RIGHT_FUNC_SERIES** (raw 33)
- `ExecuteCommon` (seq 75) → **LOOK_AROUND_DOWN_FUNC_SERIES** (raw 31)
- `CallCommon` (seq 86) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
**Fin de scène :** `End` aux séquences [135]

### P08P01A / n08a2508.ssb

**Transitions :**
- `back_SetGround` (seq 6) → niveau **P08P01A** (raw 239)
- `main_EnterDungeon` (seq 93) → niveau **None** (raw None)
- `main_EnterDungeon` (seq 93) → niveau **None** (raw None)
- `main_EnterDungeon` (seq 94) → niveau **None** (raw None)
- `main_EnterDungeon` (seq 94) → niveau **None** (raw None)
**Routines :**
- `CallCommon` (seq 58) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 61) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 92) → **BOSS_WIPE_FUNC** (raw 691)
**Fin de scène :** `End` aux séquences [96]

### P08P01A / n08a2608.ssb

**Transitions :**
- `back_SetGround` (seq 1) → niveau **P08P01A** (raw 239)
**Routines :**
- `CallCommon` (seq 53) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 91) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 95) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 119) → **LOOK_AROUND_FAST_FUNC_SERIES** (raw 43)
- `CallCommon` (seq 137) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 158) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 170) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 174) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 177) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 181) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 184) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 209) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 223) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 244) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 246) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 250) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 269) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 272) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 275) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 278) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 285) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 291) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 319) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 325) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 337) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 351) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
**Fin de scène :** `End` aux séquences [358]

### P09P01A / m19b1001.ssb

**Transitions :**
- `back_SetGround` (seq 7) → niveau **P09P01A** (raw 240)
- `back2_SetGround` (seq 396) → niveau **V12P01A** (raw 368)
- `back2_SetGround` (seq 409) → niveau **V13P01A** (raw 369)
**Routines :**
- `CallCommon` (seq 38) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 51) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 59) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 62) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 74) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 81) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 84) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 90) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 112) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 118) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 127) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 161) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 164) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `ExecuteCommon` (seq 185) → **LOOK_AROUND_RIGHT_FUNC_SERIES** (raw 33)
- `ExecuteCommon` (seq 188) → **LOOK_AROUND_LEFT_FUNC_SERIES** (raw 35)
- `ExecuteCommon` (seq 191) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
- `ExecuteCommon` (seq 194) → **LOOK_AROUND_LEFT_FUNC_SERIES** (raw 35)
- `CallCommon` (seq 201) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 206) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 211) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 222) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 226) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 230) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 282) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 302) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 306) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 312) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 320) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 341) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 344) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 357) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 378) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 439) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 450) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 453) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 462) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 468) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 473) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 484) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 487) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 490) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 496) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 503) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 508) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 521) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 527) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 539) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 552) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 561) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 565) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 569) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 574) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 580) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 585) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 592) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 607) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 613) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 629) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 634) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 637) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 640) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 644) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 649) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 658) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 668) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 674) → **JUMP_ANGRY_FUNC_SERIES** (raw 41)
- `CallCommon` (seq 680) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 697) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 701) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 706) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 714) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 721) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 727) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 741) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 749) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 755) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 767) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
**Conditions / embranchements :**
- `message_SwitchTalk` (seq 34) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 35) cas 2 → texte  Is that...[K]the Passage of Time?
- `CaseText` (seq 36) cas 3 → texte  Is that...[K]the Passage of Time?
- `message_SwitchTalk` (seq 86) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 87) cas 12 → texte  It... It can't be...
- `CaseText` (seq 88) cas 13 → texte  It... It can't be...
- `message_SwitchTalk` (seq 114) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 115) cas 17 → texte  [CS:N]Dusknoir[CR]...
- `CaseText` (seq 116) cas 18 → texte  [CS:N]Dusknoir[CR]...
- `message_SwitchTalk` (seq 197) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 198) cas 23 → texte  The [CS:N]Sableye[CR] too...
- `CaseText` (seq 199) cas 24 → texte  The [CS:N]Sableye[CR] too...
- `message_SwitchTalk` (seq 214) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 215) cas 29 → texte  What?![K] So you mean we were...
- `CaseText` (seq 216) cas 30 → texte  What?![K] So you mean we were...
- `message_SwitchTalk` (seq 218) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 219) cas 32 → texte  followed the whole time?!
- `CaseText` (seq 220) cas 33 → texte  followed the whole time?!
- `message_SwitchTalk` (seq 293) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 294) cas 40 → texte  Huh?![K] You bet I am!
- `CaseText` (seq 295) cas 41 → texte  What?![K] Of course!
- `message_SwitchTalk` (seq 308) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 309) cas 45 → texte  G-got it!
- `CaseText` (seq 310) cas 46 → texte  G-got it!
- `message_SwitchTalk` (seq 374) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 375) cas 55 → texte  Whoa![K] It turned pitch black!
- `CaseText` (seq 376) cas 56 → texte  Waah![K] It turned pitch black!
- `message_SwitchTalk` (seq 446) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 447) cas 60 → texte  Waaah!
- `CaseText` (seq 448) cas 61 → texte  Waaah!
- `message_SwitchTalk` (seq 458) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 459) cas 64 → texte  [CS:N]Grovyle[CR]![K] What is it?! What is
that thing?!
- `CaseText` (seq 460) cas 65 → texte  [CS:N]Grovyle[CR]![K] What is it?! What is
that?!
- `message_SwitchTalk` (seq 476) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 477) cas 68 → texte  What!?![K] That is?!
- `CaseText` (seq 478) cas 69 → texte  What!?![K] That is?!
- `message_SwitchTalk` (seq 480) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 481) cas 71 → texte  That's Primal [CS:N]Dialga[CR]?!
- `CaseText` (seq 482) cas 72 → texte  That's Primal [CS:N]Dialga[CR]?!
- `message_SwitchTalk` (seq 513) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 514) cas 78 → texte  Huh?! Why?!
- `CaseText` (seq 515) cas 79 → texte  What?! Why?!
- `message_SwitchTalk` (seq 517) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 518) cas 81 → texte  Aren't we going to fight?!
- `CaseText` (seq 519) cas 82 → texte  Aren't we going to fight?!
- `message_SwitchTalk` (seq 535) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 536) cas 88 → texte  But...
- `CaseText` (seq 537) cas 89 → texte  But...
- `message_SwitchTalk` (seq 588) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 589) cas 101 → texte  What?![K] [CS:N]Grovyle[CR], you didn't come
to our world by yourself?!
- `CaseText` (seq 590) cas 102 → texte  What?![K] [CS:N]Grovyle[CR], you didn't come
to our world alone?!
- `message_SwitchMonologue` (seq 655) sur **HERO_TALK_KIND**
- `CaseText` (seq 656) cas 122 → texte (What?!)
- `message_SwitchTalk` (seq 660) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 661) cas 124 → texte  Uh...what?!
- `CaseText` (seq 662) cas 125 → texte  Wh-what?!
- `message_SwitchTalk` (seq 664) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 665) cas 127 → texte  [CS:N]Grovyle[CR]![K] You said
[hero]?!
- `CaseText` (seq 666) cas 128 → texte  [CS:N]Grovyle[CR]![K] Did you say
[hero]?!
- `message_SwitchTalk` (seq 676) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 677) cas 130 → texte  Well, this is [hero]
right here!
- `CaseText` (seq 678) cas 131 → texte  Well, this is [hero]
right here!
- `message_SwitchTalk` (seq 717) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 718) cas 138 → texte  What?!
- `CaseText` (seq 719) cas 139 → texte  What?!
**Fin de scène :** `End` aux séquences [775]

### P09P01A / m19b1007.ssb

**Transitions :**
- `back_SetGround` (seq 1) → niveau **P09P01A** (raw 240)
- `back2_SetGround` (seq 442) → niveau **V14P01A** (raw 370)
- `back2_SetGround` (seq 467) → niveau **V14P03A** (raw 371)
- `back2_SetGround` (seq 478) → niveau **V14P04A** (raw 372)
- `back2_SetGround` (seq 494) → niveau **V14P01A** (raw 370)
**Routines :**
- `CallCommon` (seq 19) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 30) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 33) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 37) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 49) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 57) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 70) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 72) → **JUMP_HAPPY_FUNC_SERIES** (raw 37)
- `CallCommon` (seq 81) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 85) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 94) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 102) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 106) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 155) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 198) → **JUMP_ANGRY_FUNC_SERIES** (raw 41)
- `CallCommon` (seq 200) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 205) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 208) → **JUMP_ANGRY_FUNC_SERIES** (raw 41)
- `CallCommon` (seq 215) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 246) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 251) → **JUMP_HAPPY_FUNC_SERIES** (raw 37)
- `CallCommon` (seq 258) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 267) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 285) → **JUMP_ANGRY_FUNC_SERIES** (raw 41)
- `CallCommon` (seq 292) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 295) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 342) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 411) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 414) → **LOOK_AROUND_LEFT_FUNC_SERIES** (raw 35)
- `ExecuteCommon` (seq 417) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
- `ExecuteCommon` (seq 420) → **LOOK_AROUND_FUNC_SERIES** (raw 29)
- `ExecuteCommon` (seq 423) → **LOOK_AROUND_RIGHT_FUNC_SERIES** (raw 33)
- `ExecuteCommon` (seq 426) → **LOOK_AROUND_RIGHT_FUNC_SERIES** (raw 33)
- `ExecuteCommon` (seq 429) → **LOOK_AROUND_DOWN_FUNC_SERIES** (raw 31)
- `CallCommon` (seq 433) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
**Conditions / embranchements :**
- `message_SwitchTalk` (seq 26) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 27) cas 7 → texte  Urk...[K] [CS:N]Dusknoir[CR] really was lying!
- `CaseText` (seq 28) cas 8 → texte  Urk...[K] [CS:N]Dusknoir[CR] really was lying!
- `message_SwitchMonologue` (seq 40) sur **HERO_TALK_KIND**
- `CaseText` (seq 41) cas 12 → texte (I was a human from the future...?)
- `message_SwitchMonologue` (seq 43) sur **HERO_TALK_KIND**
- `CaseText` (seq 44) cas 14 → texte (And I was [CS:N]Grovyle[CR]'s partner on a mission to
prevent the planet's paralysis?)
- `message_SwitchMonologue` (seq 46) sur **HERO_TALK_KIND**
- `CaseText` (seq 47) cas 16 → texte (And that's how I ended up in [partner]'s
world?)
- `message_SwitchTalk` (seq 66) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 67) cas 22 → texte  Urgh! [CS:N]Dusknoir[CR]...[K]no...
- `CaseText` (seq 68) cas 23 → texte  Urgh! [CS:N]Dusknoir[CR]...[K]no...
- `message_SwitchTalk` (seq 77) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 78) cas 25 → texte  [CS:N]Dusknoir[CR]!
- `CaseText` (seq 79) cas 26 → texte  [CS:N]Dusknoir[CR]!
- `message_SwitchTalk` (seq 90) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 91) cas 29 → texte  [CS:N]G-Grovyle[CR]!
- `CaseText` (seq 92) cas 30 → texte  [CS:N]G-Grovyle[CR]!
- `message_SwitchTalk` (seq 98) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 99) cas 32 → texte  [hero]!
- `CaseText` (seq 100) cas 33 → texte  [hero]!
- `message_SwitchTalk` (seq 189) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 190) cas 38 → texte  Urk...
- `CaseText` (seq 191) cas 39 → texte  Urk...
- `message_SwitchTalk` (seq 193) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 194) cas 41 → texte  Hey, [hero]! [CS:N]Grovyle[CR]![K]
You can't give up!
- `CaseText` (seq 195) cas 42 → texte  Hey, [hero]! [CS:N]Grovyle[CR]![K]
You can't give up!
- `message_SwitchTalk` (seq 211) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 212) cas 46 → texte  We have to think!
- `CaseText` (seq 213) cas 47 → texte  We have to think!
- `message_SwitchTalk` (seq 242) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 243) cas 49 → texte  I know!
- `CaseText` (seq 244) cas 50 → texte  I know!
- `message_SwitchTalk` (seq 254) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 255) cas 52 → texte  [CS:N]Celebi[CR]![K] Can your time travel
ability transport us just the short distance into
the Passage of Time?
- `CaseText` (seq 256) cas 53 → texte  [CS:N]Celebi[CR]![K] Can your time travel
ability transport us just the short distance into
the Passage of Time?
- `message_SwitchTalk` (seq 288) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 289) cas 58 → texte  Even a little will do![K] Please!
- `CaseText` (seq 290) cas 59 → texte  It just has to work for an
instant![K] Please!
**Fin de scène :** `End` aux séquences [544]

### P09P01A / m19b1009.ssb

**Transitions :**
- `back_SetGround` (seq 1) → niveau **P09P01A** (raw 240)
**Routines :**
- `CallCommon` (seq 50) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 77) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 90) → **JUMP_SURPRISE_FUNC_SERIES** (raw 39)
- `CallCommon` (seq 97) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 108) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 114) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 118) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 121) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 127) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 130) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
**Conditions / embranchements :**
- `message_SwitchTalk` (seq 46) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 47) cas 0 → texte  Ack! Our time-traveling path has
been shattered!
- `CaseText` (seq 48) cas 1 → texte  Ack! Our time-traveling path has
been shattered!
- `message_SwitchTalk` (seq 93) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 94) cas 4 → texte  We got so close to the Passage
of Time!
- `CaseText` (seq 95) cas 5 → texte  We almost made it to the
Passage of Time!
- `message_SwitchTalk` (seq 110) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 111) cas 9 → texte  Wh-what about you, [CS:N]Celebi[CR]?!
- `CaseText` (seq 112) cas 10 → texte  Wh-what about you, [CS:N]Celebi[CR]?!
- `message_SwitchTalk` (seq 123) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 124) cas 15 → texte  Thanks, [CS:N]Celebi[CR]!
- `CaseText` (seq 125) cas 16 → texte  Thank you, [CS:N]Celebi[CR]!
**Fin de scène :** `End` aux séquences [238]

### P09P01A / m19d1072.ssb

**Transitions :**
- `back_SetGround` (seq 0) → niveau **P09P01A** (raw 240)
**Routines :**
- `CallCommon` (seq 10) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 59) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 101) → **JUMP_ANGRY_FUNC_SERIES** (raw 41)
- `CallCommon` (seq 103) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `CallCommon` (seq 108) → **MESSAGE_CLOSE_WAIT_FUNC** (raw 686)
- `ExecuteCommon` (seq 110) → **JUMP_ANGRY_FUNC_SERIES** (raw 41)
**Conditions / embranchements :**
- `message_SwitchTalk` (seq 92) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 93) cas 3 → texte  Urk...
- `CaseText` (seq 94) cas 4 → texte  Urk...
- `message_SwitchTalk` (seq 96) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 97) cas 6 → texte  Hey, [hero]! [CS:N]Grovyle[CR]![K]
You can't give up!
- `CaseText` (seq 98) cas 7 → texte  Hey, [hero]! [CS:N]Grovyle[CR]![K]
You can't give up!
- `message_SwitchTalk` (seq 113) sur **PARTNER_TALK_KIND**
- `CaseText` (seq 114) cas 11 → texte  We have to think!
- `CaseText` (seq 115) cas 12 → texte  We have to think!
**Fin de scène :** `End` aux séquences [120]
