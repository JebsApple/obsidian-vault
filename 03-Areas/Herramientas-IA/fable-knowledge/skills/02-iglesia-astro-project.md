---
name: "Iglesia Astro Project"
description: "Use when working with the Iglesia church website project or Scan Tracker apps. Triggers: Astro framework, Cloudinary image optimization, Decap CMS, Google Sheets API sync, Scan Tracker plugin, OAuth2 loopback flow. Skip if unrelated to church website or scan tracking."
user-invocable: false
---

# Iglesia Astro Project

## Domain
Church website project ("Jesus Reigns Under Worship") using Astro + Tailwind + Cloudinary, plus the Scan Tracker ecosystem (Obsidian plugin, web app, paused desktop) that shares a Google Sheets data contract.

## Core Concepts
- **Iglesia Stack**: Astro (SSG) + Tailwind CSS + Cloudinary (images) + Decap CMS (content) + Vercel/GitHub Pages (hosting)
- **Scan Tracker Ecosystem**: Three apps (desktop.paused, obsidian plugin, web app) sharing Google Sheets column contract
- **Google Cloud APIs**: Sheets API v4 + Drive API v3 for data sync; Google Identity Services for browser auth
- **OAuth2 Loopback Flow**: Local HTTP server captures OAuth redirect for Obsidian plugin auth (no browser extension needed)
- **Sync Baseline Hash**: Content hash of row values at pull time, compared on next pull to detect un-pushed local edits

## Key Relationships
- `Iglesia Blueprint` → defines → Astro + Tailwind + Cloudinary stack
- `Scan Tracker Obsidian` → shares data contract with → `Scan Tracker Web`
- `Google Sheets API v4` → powers → bidirectional sync in both Scan Tracker apps
- `OAuth2 loopback` → enables → plugin auth without external dependencies
- `GitHub Pages` → deploys → Scan Tracker Web as static app

## Mental Models
- **Pivot pattern**: Desktop app (Java/JavaFX) paused → Obsidian plugin (personal use) + Web app (team use) emerged from same requirements
- **Shared contract, different clients**: One Google Sheets schema serves three different UIs — schema changes must be coordinated
- **Sync conflict detection without timestamps**: When APIs lack per-row modification time, content hashing at read-time is a pragmatic alternative

## When NOT to use
- Skip for MiNegocio or other e-commerce projects
- Skip for general Astro/Tailwind questions (use framework docs instead)
