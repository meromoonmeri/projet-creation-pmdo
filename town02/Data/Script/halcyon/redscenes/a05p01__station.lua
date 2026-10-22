-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground a05p01 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() SOUND:PlayBGM("Credits.ogg", true) end) -- 0x44 music_id 44 (ROM)
  SkySceneKit.say({english="(..................)", french="(... ... ... ... ... ...)", german="(..................)", italian="(... ... ... ... ... ...)", spanish="(...)"})
  SkySceneKit.say({english="(What is this...?)", french="(Que se passe-t-il?)", german="(Was ist das...?)", italian="(Ma cosa...?)", spanish="(¿Qué es esto?...)"})
  SkySceneKit.say({english="(I'm rising into the sky...)", french="(Je m'élève dans le ciel...)", german="(Ich schwebe Richtung Himmel...)", italian="(Mi sto sollevando verso il cielo...)", spanish="(Estoy elevándome hacia el cielo...)"})
  SkySceneKit.say({english="(I'm rising into the sky...)", french="(Je m'élève dans le ciel...)", german="(Ich schwebe zum Himmel...)", italian="(Mi sto sollevando verso il cielo...)", spanish="(Me elevo hacia el cielo...)"})
  SkySceneKit.say({english="(Is this my spirit...?)", french="(Est-ce mon esprit?)", german="(Bin ich jetzt ein Geist...?)", italian="(È il mio spirito...?)", spanish="(¿Será este mi espíritu?...)"})
  SkySceneKit.say({english="(I wonder where I'm going?)", french="(Je me demande où je vais...)", german="(Wo ich wohl hinkomme?)", italian="(Dove starò andando?)", spanish="(¿Adónde me voy?...)"})
  SkySceneKit.say({english="(I wonder where I'm going?)", french="(Je me demande où je me dirige...)", german="(Wo ich wohl hinkomme?)", italian="(Dove starò andando?)", spanish="(¿Adónde me estoy yendo?...)"})
  SkySceneKit.say({english="(......!)", french="(... ...)", german="(......!)", italian="(... ...!)", spanish="(...)"})
  SkySceneKit.say({english="(Voices... I hear voices...)", french="(Des voix... J'entends des voix...)", german="(Stimmen... Ich höre Stimmen...)", italian="(Delle voci... sento delle voci...)", spanish="(¿Y esas voces?... Estoy oyendo voces...)"})
  pcall(function() SOUND:PlayBGM("Time of Reunion.ogg", true) end) -- 0x44 music_id 45 (ROM)
  SkySceneKit.say({english="I don't want to leave...", french="Je ne veux pas partir...", german="Ich will nicht weg von hier...", italian="Non voglio andarmene...", spanish="No quiero irme..."})
  SkySceneKit.say({english="I want to stay longer...", french="Je veux rester...", german="Ich möchte noch bleiben...", italian="Voglio restare ancora...", spanish="Quiero quedarme un poco más..."})
  GAME:WaitFrames(3) -- 0xE7
  SkySceneKit.say({english="I don't want to leave...", french="Je ne veux pas partir...", german="Ich will nicht weg von hier...", italian="Non voglio andarmene...", spanish="No quiero irme..."})
  SkySceneKit.say({english="I want to stay longer...", french="Je veux rester...", german="Ich möchte noch bleiben...", italian="Voglio restare ancora...", spanish="Quiero quedarme un poco más aquí..."})
  SkySceneKit.say({english="With my invaluable...", french="... avec mon inestimable...", german="Bei meinem wundervollen...", italian="Un profondissimo legame...", spanish="Con el Pokémon..."})
  SkySceneKit.say({english="Irreplaceable friend...", french="... irremplaçable partenaire...", german="Einzigartigen Freund...", italian="Un profondissimo legame di amicizia ti lega ancora a questo luogo...", spanish="que más quiero..."})
end
