---
name: "Obsidian app.json Config"
description: "Use when configuring Obsidian vault settings via app.json. Triggers: defaultViewMode, livePreview, attachmentFolderPath, newFileLocation, alwaysUpdateLinks, useMarkdownLinks. Skip if working with plugins or CSS, not core app settings."
user-invocable: false
---

# Obsidian app.json Config

## Domain
Core Obsidian application configuration properties defined in `.obsidian/app.json`. Controls editor behavior, file management defaults, and link update policies.

## Core Concepts
- **defaultViewMode**: `"source"` or `"live"` — initial editor mode when opening notes
- **showLineNumber**: Display line numbers in editor
- **strictLineBreaks**: Treat single newlines as `<br>` in reading view
- **readableLineLength**: Cap line width for readability in reading view
- **livePreview**: Enable WYSIWYG-style live preview editing
- **attachmentFolderPath**: Where dropped/pasted attachments are saved (vault root or specific folder)
- **newFileLocation**: `"folder"` or `"current"` — where new files are created
- **newFileFolderPath**: Target folder when `newFileLocation` is `"folder"`
- **alwaysUpdateLinks**: Auto-rename backlinks when a note is renamed
- **useMarkdownLinks**: Use `[]()` syntax instead of `[[]]` wiki-links

## Key Relationships
- livePreview → overrides → defaultViewMode behavior when enabled
- newFileLocation → determines → whether newFileFolderPath is used
- alwaysUpdateLinks ↔ useMarkdownLinks → together control link management UX
- attachmentFolderPath → affects → vault cleanliness and file organization

## Mental Models
- **Editor ergonomics**: livePreview=true + readableLineLength=true = comfortable long-session editing
- **File hygiene**: Set attachmentFolderPath to a single location to avoid scattered assets
- **Link stability**: alwaysUpdateLinks=true prevents broken links after renames

## When NOT to use
- Skip for plugin configuration (use `manifest.json` and plugin-specific settings)
- Skip for theme/CSS customization
- Skip for hotkeys or appearance settings (those live in separate config files)
