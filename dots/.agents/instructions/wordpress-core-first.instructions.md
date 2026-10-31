---
name: WordPress Core First
description: "Use when developing or reviewing WordPress themes, FSE, block themes, Gutenberg blocks, theme.json, patterns, WooCommerce, or ACF integrations. Prefer built-in WordPress capabilities and verify editor/frontend parity."
---

# WordPress Core First

- Before proposing custom code, identify the requirement, the relevant built-in capability, and any concrete gap. State that decision briefly; do not turn it into a lengthy architecture exercise.
- Check the project's WordPress version and existing conventions. Do not assume the latest APIs are available; consult version-appropriate WordPress documentation or installed source when uncertain.
- Prefer core blocks, block supports, theme.json, templates, template parts, patterns, style variations, and the Style Engine when they satisfy the requirement.
- Prefer a pattern for a composition of existing blocks, a style variation for presentation, and a block variation for a preset of an existing block. Create a custom block only for a demonstrated behavior, data, or editing gap.
- Prefer supported hooks and public APIs over copied core implementations, DOM manipulation, private APIs, or replacement frameworks. Do not add plugins or dependencies without a concrete need.
- Keep presentation in the theme. Follow existing ownership conventions for durable functionality; flag functionality that should survive a theme switch instead of silently introducing a plugin.
- Check existing theme.json settings before adding CSS. Keep bespoke CSS scoped and minimal; do not recreate block controls or layout systems that WordPress already provides.
- Preserve the author's editing experience: responsive layouts, meaningful controls, editor/frontend parity, accessibility, and intentional content locking. Do not assume all content should be locked.
- Keep PHP output contextually escaped and input validated. Use capability checks for protected actions; a nonce does not grant authorization. Use wp_unslash before sanitizing WordPress request text.
- Diagnose hook timing, data shape, cache behavior, and plugin interactions at their owning boundary. Avoid global cache flushes and speculative compatibility patches.
- Discover the actual local runtime and existing test/build commands. Never assume a Docker stack, Local site, WP-CLI executable, or production access.
- Verify the smallest affected behavior, including the editor when editing behavior changes. Distinguish checks actually run from proposed checks and unverified requirements.
- For specialist procedures, use the wordpress-block-theme, wordpress-custom-block, and wordpress-debug-verify skills when available.
