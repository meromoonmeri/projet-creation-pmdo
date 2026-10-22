#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Execute REELLEMENT le Lua du stand de Grodoudou dans le moteur simule.
Ce n'est pas une relecture : le code tourne, et on lit ce qu'il appelle.

Scenarios joues :
  A. Zarude pas encore vaincu  -> l'etal doit etre vide (regle des legendaires)
  B. Zarude vaincu             -> la zone est en vente
  C. achat avec assez d'argent -> flash blanc + argent debite + zone possedee
  D. achat sans assez d'argent -> refus, aucune zone debloquee
  E. voyage vers la zone       -> EnterDungeon sur le bon segment
  F. vieille sauvegarde        -> SV.LegendZones absent, ne doit pas planter
"""
import os, re, sys
sys.path.insert(0, '/home/user')
import sim

ROOT = sys.argv[1] if len(sys.argv) > 1 else '/home/user/repo'
sim.ROOT = ROOT
sim.S = os.path.join(ROOT, 'Data/Script/halcyon')
S = sim.S

FAIL = []
def expect(cond, label, detail=''):
    if not cond: FAIL.append(label)
    print('   %s %-52s %s' % ('OK  ' if cond else 'ECHEC', label, detail))


def build(money=99999, defeated=False, choices=None, purchased=None, drop_sv=False):
    L, log = sim.new_env()
    g = L.globals()

    # argent du joueur
    g.GAME.GetPlayerMoney = L.eval('function() return %d end' % money)
    spent = []
    g.GAME.RemoveFromPlayerMoney = L.eval(
        'function(self, n) PYREC("MONEY_SPENT", n) end')

    # etat d'histoire
    L.execute('if SV.Chapter6 == nil then SV.Chapter6 = {} end')
    L.execute('SV.Chapter6.DefeatedGloomyBoss = %s' % ('true' if defeated else 'false'))
    if drop_sv:
        L.execute('SV.LegendZones = nil')     # sauvegarde d'avant le systeme
    if purchased:
        L.execute('LegendZones = nil')

    # file de choix du joueur
    seq = list(choices or [])
    g.QUEUE = L.table_from(seq)
    L.execute("""
      local _i = 0
      UI.WaitForChoice = function() _i = _i + 1 end
      UI.ChoiceResult  = function() return QUEUE[_i] end
    """)

    # modules
    sim.load(L, 'LegendZones.lua', 'LegendZones')
    if purchased:
        for k in purchased:
            L.execute("LegendZones.SetPurchased('%s')" % k)
    sim.load(L, 'BossFX.lua', 'BossFX')
    mod = sim.load(L, 'ground/metano_town/metano_town_legend.lua', 'metano_town_legend')
    return L, log, mod


def run(L, log, mod):
    L.execute("metano_town_legend.Legend_Merchant_Action(CH('Legend_Merchant'), CH('PLAYER'))")
    return log


def kinds(log, *pre):
    return [ (k,a) for k,a in log if any(k.startswith(p) for p in pre) ]


print('=' * 92)
print('A. ZARUDE PAS ENCORE VAINCU  -> la zone ne doit PAS etre en vente')
print('=' * 92)
# choix : 1 = Acheter, puis on ressort (4 = quitter)
L, log, mod = build(defeated=False, choices=[1, 4])
run(L, log, mod)
keys = [a[0] for k,a in log if k == 'KEY']
expect('LZ_Shop_Nothing_001' in keys, "l'etal annonce qu'il est vide")
expect('LZ_Name_Verdant_Oath' not in keys, 'Serment Verdoyant PAS propose')
expect(not kinds(log, 'MONEY_SPENT'), 'aucun argent depense')

print()
print('=' * 92)
print('B. ZARUDE VAINCU  -> la zone devient achetable')
print('=' * 92)
L, log, mod = build(defeated=True, choices=[1, 4, 4])
run(L, log, mod)
keys = [a[0] for k,a in log if k == 'KEY']
expect('LZ_Name_Verdant_Oath' in keys, 'Serment Verdoyant est propose')
expect('LZ_Shop_Nothing_001' not in keys, "l'etal n'est plus vide")

print()
print('=' * 92)
print('C. ACHAT REUSSI  -> flash blanc, argent debite, zone possedee')
print('=' * 92)
# 1=Acheter, 1=Serment Verdoyant, True=confirmer, 4=quitter
L, log, mod = build(money=99999, defeated=True, choices=[1, 1, True, 4])
run(L, log, mod)
keys = [a[0] for k,a in log if k == 'KEY']
spent = [a[0] for k,a in log if k == 'MONEY_SPENT']
expect('LZ_Shop_Disclaimer' in keys, "le rappel 'je vends le chemin' est dit")
expect(spent == [15000], 'argent debite : 15000', str(spent))
expect('LZ_Shop_Bought_001' in keys, "confirmation de zone debloquee")
own = L.eval("LegendZones.IsPurchased('verdant_oath')")
expect(own is True, 'la zone est enregistree comme achetee', str(own))
defeated_flag = L.eval("LegendZones.IsDefeated('verdant_oath')")
expect(defeated_flag is not True,
       "acheter NE donne PAS le Pokemon (Defeated reste faux)", str(defeated_flag))
# le flash : SOUND EVT_Battle_Flash + FlashEmitter
snd = [str(a[0]) for k,a in log if k.startswith('SOUND.PlayBattleSE')]
expect('EVT_Battle_Flash' in snd, 'le flash blanc est joue', str(snd))
expect('DUN_Money' in snd, "le son d'achat est joue")

print()
print('=' * 92)
print("D. ACHAT SANS ARGENT  -> refus, rien ne se debloque")
print('=' * 92)
L, log, mod = build(money=100, defeated=True, choices=[1, 1, True, 4])
run(L, log, mod)
keys = [a[0] for k,a in log if k == 'KEY']
expect('LZ_Shop_No_Money' in keys, "Grodoudou signale le manque d'argent")
expect(not [a for k,a in log if k=='MONEY_SPENT'], 'aucun argent debite')
own = L.eval("LegendZones.IsPurchased('verdant_oath')")
expect(own is not True, 'la zone N EST PAS debloquee', str(own))
snd = [str(a[0]) for k,a in log if k.startswith('SOUND.PlayBattleSE')]
expect('EVT_Battle_Flash' not in snd, 'pas de flash sur un achat refuse')

print()
print('=' * 92)
print('E. VOYAGE VERS LA ZONE ACHETEE  -> EnterDungeon segment 3')
print('=' * 92)
# achat puis voyage : 1=Acheter,1=zone,True=ok, 2=S'y rendre,1=zone,True=ok
L, log, mod = build(money=99999, defeated=True, choices=[1, 1, True, 2, 1, True])
run(L, log, mod)
ent = [a for k,a in log if k == 'GAME.EnterDungeon']
expect(len(ent) == 1, 'EnterDungeon appele une fois', str(len(ent)))
if ent:
    args = ent[0]
    expect(args[0] == 'gloomy_forest', '  zone = gloomy_forest', str(args[0]))
    expect(args[1] == 3, '  segment = 3', str(args[1]))
fade = [k for k,a in log if k == 'GAME.FadeOut']
expect(len(fade) >= 1, 'fondu avant le depart')

print()
print('=' * 92)
print("F. VIEILLE SAUVEGARDE (SV.LegendZones absent)  -> ne doit pas planter")
print('=' * 92)
try:
    L, log, mod = build(defeated=True, choices=[1, 4, 4], drop_sv=True)
    run(L, log, mod)
    expect(True, 'le stand fonctionne sans SV.LegendZones prealable')
    sv = L.eval("SV.LegendZones ~= nil")
    expect(sv is True, 'EnsureSV a recree la table', str(sv))
except Exception as e:
    expect(False, 'le stand fonctionne sans SV.LegendZones', str(e)[:90])

print()
print('=' * 92)
print('RESULTAT : %s' % ('LES 6 SCENARIOS PASSENT' if not FAIL
                         else '%d ECHEC(S) : %s' % (len(FAIL), ', '.join(FAIL))))
print('=' * 92)
sys.exit(0 if not FAIL else 1)
