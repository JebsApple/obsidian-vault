---
name: "Obsidian Plugin Source"
description: "Use when working with Obsidian plugin source code, minified JS bundles, or diff-match-patch library internals. Triggers: automatic-linker plugin, diff_main, patch_make, Obsidian plugin debugging, minified bundle analysis. Skip if unrelated to Obsidian plugin internals."
user-invocable: false
---

# Obsidian Plugin Source

## Domain
Analysis and understanding of minified Obsidian plugin JavaScript bundles, specifically the automatic-linker plugin which embeds the diff-match-patch library for text diffing and linking.

## Core Concepts
- **diff-match-patch**: Google's library for text diffing, matching, and patching embedded in the plugin bundle
- **Text Diffing Pipeline**: `diff_main()` → `diff_compute_()` → `diff_lineMode_()` → `diff_bisect_()` for computing text deltas
- **Patch Application**: `patch_make()` → `patch_apply()` transforms documents using diff output
- **Fuzzy Matching**: `match_main()` + `match_bitap_()` for approximate string matching in link generation
- **Semantic Cleanup**: `diff_cleanupSemantic()` and `diff_cleanupMerge()` normalize diff output for readability

## Key Relationships
- `main.js` → bundles → `diff-match-patch` (entire library in single file)
- `createLinkGenerator()` → uses → `diff_main()` + `match_main()` for link detection
- `modifyLinks()` → applies → patch operations to vault files
- `refreshFileDataAndTrie()` → rebuilds → link index on file changes
- `formatThenRunPrettierAndLinter()` → post-processes → modified files

## Mental Models
- **Bundle archaeology**: When dealing with minified Obsidian plugins, the function names (te, at, rt, etc.) are obfuscated — map them to the diff-match-patch API by matching parameter patterns and call sites
- **Plugin lifecycle**: `onload()` → `initializePlugin()` → `buildUrlTitleMap()` → ready for `modifyLinks()`
- **Link generation flow**: Source text → diff against vault titles → match candidates → patch with wiki-links

## When NOT to use
- Skip for writing new Obsidian plugins from scratch (use Obsidian API docs instead)
- Skip for general text diffing needs (use diff-match-patch directly, not via plugin analysis)
