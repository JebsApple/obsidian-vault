---
name: "Obsidian Plugin Manifest Structure"
description: "Use when creating or reviewing Obsidian plugin manifest.json files. Triggers: plugin manifest, manifest.json Obsidian, minAppVersion, plugin id, plugin author. Skip if unrelated to Obsidian plugin development."
user-invocable: false
---

# Obsidian Plugin Manifest Structure

## Domain
The required and optional fields in Obsidian plugin `manifest.json` files, used for plugin registration, versioning, and compatibility checking.

## Core Concepts
- **manifest.json**: Plugin metadata file required by Obsidian for plugin loading and marketplace listing
- **id**: Unique plugin identifier (kebab-case, matches folder name in `.obsidian/plugins/`)
- **name**: Human-readable plugin display name
- **version**: Semver version string for plugin releases
- **minAppVersion**: Minimum Obsidian version required for compatibility
- **description**: Short plugin description for marketplace/documentation
- **author**: Plugin author name or handle
- **isDesktopOnly**: Boolean — whether plugin requires desktop (Node.js APIs) vs works on mobile

## Key Relationships
- manifest.json → defines → id (plugin identity)
- manifest.json → enforces → minAppVersion (compatibility gate)
- manifest.json → gates → isDesktopOnly (mobile support)
- id → maps_to → `.obsidian/plugins/{id}/` directory

## Mental Models
- **Plugin lifecycle**: id + version + minAppVersion determine installability and updates
- **Desktop vs Mobile**: isDesktopOnly=true means no mobile support (uses Node.js APIs)
- **Version compatibility**: minAppVersion prevents installation on unsupported Obsidian versions

## When NOT to use
- Skip for Obsidian theme development (different manifest)
- Skip for non-Obsidian plugin systems
- Skip for plugin code review (this is manifest structure only)
