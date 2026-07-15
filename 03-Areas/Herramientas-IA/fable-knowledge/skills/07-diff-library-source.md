---
name: "Diff Library Source"
description: "Use when debugging or understanding the diff/patch/match library bundled in automatic-linker or similar Obsidian plugins. Triggers: diff_main, diff_compute, patch_make, match_bitap, diff_cleanupSemantic, Levenshtein. Skip if working with application logic, not diff algorithms."
user-invocable: false
---

# Diff Library Source

## Domain
JavaScript diff/patch/match library (Google's diff-match-patch) bundled inside the automatic-linker Obsidian plugin's minified `main.js`. Used for text comparison, fuzzy matching, and patch application.

## Core Concepts
- **Diff Layer**: `diff_main()` → `diff_compute_()` → `diff_lineMode_()` → `diff_bisect_()` — progressive refinement from character to line-level diffs
- **Match Layer**: `match_main()` → `match_bitap_()` — fuzzy string matching using Bitap (shift-OR) algorithm
- **Patch Layer**: `patch_make()` → `patch_apply()` — unified patch generation and application
- **Cleanup Passes**: `diff_cleanupSemantic()` (human-readable), `diff_cleanupEfficiency()` (minimal edits), `diff_cleanupMerge()` (boundary cleanup)

## Key Relationships
- `diff_linesToChars_()` → compresses → line-level input for `diff_lineMode_()` (O(n) vs O(n²))
- `diff_commonPrefix()` + `diff_commonSuffix()` → used by → `diff_compute_()` to find shared boundaries
- `diff_halfMatch_()` → optimization for → long common substrings (reduces bisect depth)
- `match_bitap_()` → uses → `diff_commonPrefix()`/`diff_commonSuffix()` for search boundaries

## Mental Models
- **Progressive refinement**: start cheap (common prefix/suffix), escalate to expensive (bisect) only for remaining middle
- **Lines-as-chars optimization**: `linesToChars` maps unique lines to single chars, making expensive char-diff fast on line granularity
- **Post-diff cleanup**: raw diffs are machine-optimal; cleanup passes reshape for human readability or minimal edit count

## When NOT to use
- Skip for Obsidian plugin configuration or UI behavior (that's the plugin wrapper, not this library)
- Skip for git diffs or version control diffs (different toolchain)
