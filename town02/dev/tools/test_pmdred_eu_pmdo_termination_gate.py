#!/usr/bin/env python3
from __future__ import annotations

import signal
import unittest

from run_pmdred_eu_pmdo_termination_gate import classify_returncode, official_gate_passes


class TerminationClassificationTests(unittest.TestCase):
    def test_normal_exit_is_distinct_and_passes(self) -> None:
        result = classify_returncode(0, signal.SIGTERM, False)
        self.assertEqual(result["kind"], "NORMAL_EXIT")
        self.assertEqual(result["result"], "PASS")
        self.assertIsNone(result["exit_signal"])

    def test_expected_term_is_recorded_as_signal_and_passes(self) -> None:
        result = classify_returncode(-signal.SIGTERM, signal.SIGTERM, False)
        self.assertEqual(result["kind"], "EXPECTED_SIGTERM_SIGNAL")
        self.assertEqual(result["result"], "PASS")
        self.assertEqual(result["wait_state"], "SIGNALED")
        self.assertEqual(result["exit_signal"], signal.SIGTERM)
        self.assertFalse(result["segmentation_fault"])

    def test_sigsegv_is_never_hidden_or_accepted(self) -> None:
        result = classify_returncode(-signal.SIGSEGV, signal.SIGTERM, False)
        self.assertEqual(result["kind"], "SIGSEGV")
        self.assertEqual(result["result"], "FAIL")
        self.assertEqual(result["returncode"], -signal.SIGSEGV)
        self.assertTrue(result["segmentation_fault"])

    def test_managed_term_exit_code_is_not_mislabeled_as_a_signal(self) -> None:
        result = classify_returncode(143, signal.SIGTERM, False)
        self.assertEqual(result["kind"], "EXPECTED_SIGTERM_EXIT_CODE")
        self.assertEqual(result["result"], "PASS")
        self.assertEqual(result["wait_state"], "EXITED")
        self.assertEqual(result["exit_code"], 143)
        self.assertIsNone(result["exit_signal"])
        self.assertFalse(result["normal_exit"])

    def test_other_signal_and_nonzero_exit_fail(self) -> None:
        self.assertEqual(
            classify_returncode(-signal.SIGINT, signal.SIGTERM, False)["result"],
            "FAIL",
        )
        result = classify_returncode(7, signal.SIGTERM, False)
        self.assertEqual(result["kind"], "NONZERO_EXIT")
        self.assertEqual(result["result"], "FAIL")
        self.assertEqual(result["exit_code"], 7)

    def test_forced_kill_fails_even_if_returncode_matches_requested_signal(self) -> None:
        result = classify_returncode(-signal.SIGTERM, signal.SIGTERM, True)
        self.assertEqual(result["kind"], "FORCED_KILL")
        self.assertEqual(result["result"], "FAIL")
        self.assertTrue(result["forced_kill"])

    def test_official_gate_requires_unsignaled_normal_unload(self) -> None:
        base = {
            "terminal_seen": True,
            "graceful_exit_observed": True,
            "returncode": 0,
            "requested_signal_sent": False,
            "residual_before": [],
            "residual_after": [],
        }
        self.assertTrue(official_gate_passes(**base))
        for change in (
            {"terminal_seen": False},
            {"graceful_exit_observed": False},
            {"returncode": 143},
            {"returncode": -signal.SIGSEGV},
            {"requested_signal_sent": True},
            {"residual_before": [10]},
            {"residual_after": [11]},
        ):
            case = {**base, **change}
            self.assertFalse(official_gate_passes(**case), change)


if __name__ == "__main__":
    unittest.main()
