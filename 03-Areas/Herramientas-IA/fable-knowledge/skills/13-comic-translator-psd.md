---
name: "Comic Translator PSD"
description: "Use when working with the comic-to-PSD translation tool: multi-provider AI translation, OCR, PSD generation, or canvas-based text box drawing. Triggers: traductor comics, ag-psd, Tesseract OCR, Gemini translation, DeepL provider, LibreTranslate, canvas drawing, magic bytes. Skip for general translation or non-PSD image work."
user-invocable: false
---

# Comic Translator PSD

## Domain
A tool for translating comics to PSD files with AI-powered text extraction and translation. Architecture: Blueprint defines providers, sprints implement them. OCR → translation → PSD generation pipeline.

## Core Concepts
- **Multi-Provider Translation**: Gemini, OpenRouter, DeepL, LibreTranslate — interchangeable via adapter pattern. Gemini/OpenRouter are semantically similar (both LLM-based). DeepL/LibreTranslate are semantically similar (both neural MT).
- **OCR Layer**: Tesseract.js for local, offline text extraction from comic panels.
- **PSD Generation**: ag-psd library generates layered PSD files from translated content.
- **Canvas Drawing**: Visual text box placement — draw bounding boxes on comic panels for precise text positioning.
- **Safety Nets**: Magic Bytes Verification (validate file integrity), Auto-Compressor (handle large images), Modo Manual (full manual override without AI).
- **Export**: DOCX export for TypeR workflow integration.

## Key Relationships
- Blueprint → references → all providers (hub node defines the adapter interface)
- Sprint 0 → implements → all providers + Modo Manual (foundations layer)
- Sprint 1 → implements → Canvas Drawing + Magic Bytes + Auto-Compresor (core interaction)
- Sprint 2 → implements → DOCX Export (polish phase)
- Divergence note → rationale_for → Sprint 1 (filmstrip horizontal + 2 columns replaced 3-panel layout)

## Mental Models
- **Provider Abstraction**: Translation providers are interchangeable. Design the interface once, swap implementations freely. Start with the cheapest/fastest (LibreTranslate local), escalate to best quality (Gemini) when needed.
- **Sprint = Feature Layer**: Sprint 0 = all providers work, Sprint 1 = visual interaction works, Sprint 2 = export works. Each sprint is independently usable.
- **Manual Mode is Not a Fallback, It's a Feature**: Users who want full control get it. The tool serves power users, not just automation seekers.

## When NOT to use
- Skip for general translation tasks (not comic-specific)
- Skip for PSD editing without translation context
- Skip for other project blueprints (this is project-specific)
