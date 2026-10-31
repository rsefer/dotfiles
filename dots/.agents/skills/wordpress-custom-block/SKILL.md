---
name: wordpress-custom-block
description: "Create, modify, or debug custom Gutenberg/WordPress blocks, block.json registration, block variations, block supports, React editor controls, PHP dynamic rendering, ACF blocks, and block assets. Use when a custom block is requested or core blocks have a demonstrated capability gap."
---

# Custom Block Development

## Procedure

1. Inspect the closest existing block, registration path, block.json, and package/build configuration. Determine the supported WordPress version and whether the project uses native blocks, ACF blocks, or both. Preserve that convention unless the task requires a change.
2. Check whether core blocks, a pattern, a variation, block supports, or an existing project block can satisfy the requirement. Briefly state the concrete gap before introducing a new block. If the user explicitly requests a from-scratch exercise, respect that constraint and explain the tradeoff.
3. Define the editing and rendering contract: editable attributes, content/data ownership, saved versus dynamic output, allowed inner blocks, author controls, empty states, and whether old content must remain valid.
4. Use metadata-based registration through the project's existing registration mechanism. Reuse supported block supports and WordPress component/data APIs rather than recreating spacing, color, typography, alignment, or editor controls. Confirm API availability for the target WordPress version.
5. Choose static output for stable saved markup and dynamic rendering when output depends on changing server-side data. Keep editor-only, frontend-only, and shared assets separate using supported metadata fields and the existing build setup. Do not add a second bundler.
6. Preserve valid serialization. Use useBlockProps and its save counterpart where appropriate; use the project's supported InnerBlocks APIs for nested content. Keep persisted attributes serializable. For changes to an existing static block, inspect saved content compatibility and add a deprecation/migration only where needed.
7. Validate and sanitize attributes at the server boundary, escape rendered output by context, and use permission callbacks for protected REST routes. Keep public rendering independent of unnecessary authenticated requests. For ACF fields, confirm actual return formats instead of assuming IDs or strings.
8. Make a small edit and immediately run the existing focused block test, lint, typecheck, or build. Then verify inserting, editing, saving, and reloading the block in WordPress, plus frontend output. Exercise meaningful empty/data/error states, keyboard interaction, and relevant responsive layouts.
9. Report why native composition was insufficient, the implementation surface, saved-content compatibility, checks run, and anything unverified.

## Boundaries

- Do not use private Gutenberg APIs or experimental features without verifying support and stating the compatibility cost.
- Do not fetch data during rendering without considering access, caching, and failure behavior.
- Do not add bespoke controls for features already exposed by supported core block controls.
