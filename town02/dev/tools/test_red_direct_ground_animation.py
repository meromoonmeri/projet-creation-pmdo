"""Lupa regressions for the map-owned direct Ground CANM scheduler."""

from __future__ import annotations

import unittest
from pathlib import Path

try:
    from lupa import LuaRuntime
except ImportError:  # pragma: no cover
    LuaRuntime = None  # type: ignore[assignment]


@unittest.skipIf(LuaRuntime is None, "lupa is required for Lua lifecycle tests")
class RedDirectGroundAnimationTests(unittest.TestCase):
    def setUp(self) -> None:
        assert LuaRuntime is not None
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.lua.execute(
            """
WAIT_ARGS = {}
TILE_FRAME_CALLS = 0
RogueElements = {Loc = function(x, y) return {X=x,Y=y} end}
RogueEssence = {Dungeon = {TileFrame = function(loc, sheet)
  TILE_FRAME_CALLS = TILE_FRAME_CALLS + 1
  return {TexLoc=loc,Sheet=sheet}
end}}
GAME = {WaitFrames = function(_, frames)
  table.insert(WAIT_ARGS, frames)
  coroutine.yield()
end}
TASK = {BranchCoroutine = function(_, fn)
  LAST_BRANCH = coroutine.create(fn)
  return LAST_BRANCH
end}
function TEST_MAP()
  return {Layers={[0]={Tiles={[0]={[0]={Layers={[0]={Frames={[0]={}}}}}}}}}}
end
function TEST_DATA(asset)
  return {
    asset=asset,sheet=asset..'_DirectBase',layer=0,
    gba_master_clock=16777216,gba_cycles_per_frame=280896,
    descriptors={{cells={0,0},records={{i=1,d=1,r=0,c={1,2}}},
      states={['0']={0,0},['1']={1,0},['2']={2,0}}}}
  }
end
function RESUME_LAST(count)
  for _ = 1, count do
    local ok, message = coroutine.resume(LAST_BRANCH)
    assert(ok, message)
  end
end
"""
        )
        script = (
            Path(__file__).resolve().parent.parent
            / "Data/Script/halcyon/RedDirectGroundAnimation.lua"
        )
        self.module = self.lua.execute(script.read_text(encoding="utf-8"))

    def test_integer_remainder_uses_occasional_two_frame_wait(self) -> None:
        map_value = self.lua.eval("TEST_MAP()")
        data = self.lua.eval("TEST_DATA('timing')")
        self.module.Start(map_value, data)
        self.lua.eval("RESUME_LAST")(220)
        waits = self.lua.globals().WAIT_ARGS
        self.assertEqual([waits[index] for index in range(1, 220)], [1] * 219)
        self.assertEqual(waits[220], 2)
        # Tick zero plus 219 completed scheduler iterations. Alternating
        # states force exactly one mutation per reached tick.
        self.assertEqual(self.lua.globals().TILE_FRAME_CALLS, 220)

    def test_reentry_reapplies_tick_zero_and_stale_coroutine_exits(self) -> None:
        map1 = self.lua.eval("TEST_MAP()")
        map2 = self.lua.eval("TEST_MAP()")
        data = self.lua.eval("TEST_DATA('reentry')")
        old_token = self.module.Start(map1, data)
        self.lua.execute("OLD_BRANCH = LAST_BRANCH")
        self.lua.eval("RESUME_LAST")(2)
        self.assertEqual(old_token["tick"], 1)
        self.module.Start(map2, data)
        self.assertEqual(self.module.ActiveAsset(), "reentry")
        # Resume the invalidated old task. It must leave without touching its
        # cleared map/data references or mutating the replacement map.
        self.lua.execute(
            "local ok, message = coroutine.resume(OLD_BRANCH); assert(ok, message)"
        )
        self.assertEqual(self.lua.eval("coroutine.status(OLD_BRANCH)"), "dead")
        self.assertFalse(self.module.Cancel(map1))
        self.assertTrue(self.module.Finish(map2))
        self.assertIsNone(self.module.ActiveAsset())

    def test_update_cancels_when_ground_map_is_replaced(self) -> None:
        map1 = self.lua.eval("TEST_MAP()")
        map2 = self.lua.eval("TEST_MAP()")
        self.module.Start(map1, self.lua.eval("TEST_DATA('replace')"))
        self.module.Update(map2)
        self.assertIsNone(self.module.ActiveAsset())
        self.assertFalse(self.module.Finish(map1))


if __name__ == "__main__":
    unittest.main()
