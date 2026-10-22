#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""nea_map.py — lecture de la grille de collision d'un .rsground.

La grille `obstacles` est indexee [x][y], en cases de 8 px, et chaque case
est un objet {'Bounds': {...}, 'Tags': n}. Tags == 0 = sol libre.
"""
import json


class Ground:
    def __init__(self, path):
        obj = json.load(open(path, encoding='utf-8-sig'))['Object']
        self.ob = obj['obstacles']
        self.gw = len(self.ob)
        self.gh = len(self.ob[0])
        self.w = self.gw * 8
        self.h = self.gh * 8
        self.markers = {}
        for e in obj.get('Entities', []) or []:
            pass

    def tag(self, x, y):
        gx, gy = int(x) // 8, int(y) // 8
        if gx < 0 or gy < 0 or gx >= self.gw or gy >= self.gh:
            return -1
        return self.ob[gx][gy].get('Tags', 0)

    def free(self, x, y):
        return self.tag(x, y) == 0

    def free_box(self, x, y, w=24, h=24):
        """Le personnage occupe une boite w x h centree sur (x,y)."""
        for dx in range(-w // 2, w // 2 + 1, 4):
            for dy in range(-h // 2, h // 2 + 1, 4):
                if not self.free(x + dx, y + dy):
                    return False
        return True

    def free_rect(self, x, y, w, h):
        """Rectangle dont (x,y) est le coin haut-gauche (decors)."""
        for dx in range(0, w + 1, 4):
            for dy in range(0, h + 1, 4):
                if not self.free(x + dx, y + dy):
                    return False
        return True

    def walk_line(self, a, b, step=4, w=20, h=20):
        """Le segment a->b est-il marchable de bout en bout ?"""
        (x1, y1), (x2, y2) = a, b
        n = max(abs(x2 - x1), abs(y2 - y1)) // step + 1
        for i in range(n + 1):
            x = x1 + (x2 - x1) * i / n
            y = y1 + (y2 - y1) * i / n
            if not self.free_box(x, y, w, h):
                return False, (int(x), int(y))
        return True, None
