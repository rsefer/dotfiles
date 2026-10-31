---
name: wordpress-block-theme
description: "Develop or modify WordPress FSE/block themes and implement designs using theme.json, core blocks, templates, template parts, patterns, block styles, and style variations. Use for Site Editor layouts, responsive styling, and editor/frontend parity; prefer built-in capabilities before custom code."
---

# Block Theme Development

## Procedure

1. Anchor on the requested screen, template, pattern, or design. Inspect only the owning files, theme metadata, theme.json, and nearby implementation. Determine the supported WordPress version and whether this is a block, classic, or hybrid theme.
2. Identify the smallest native implementation. Briefly name the requirement, a suitable core capability, and any remaining gap. For unfamiliar capabilities, verify against matching WordPress documentation or installed source before ruling them out.
3. Choose the correct surface:
   - Global design tokens and supported block settings/styles: theme.json.
   - Page structure: templates and reusable template parts.
   - Reusable arrangements of blocks: patterns; use the project's convention for registered patterns.
   - Alternate presentation: block styles or theme style variations.
   - A preset of an existing block: block variations.
   - New behavior or data with no suitable existing block: use wordpress-custom-block.
4. For design work, translate typography, colors, spacing, alignment, and responsive behavior into existing presets and core layout controls first. Preserve the site's visual language. Use scoped CSS only for the documented gap; avoid broad selectors against generated markup.
5. Before changing a template that appears unchanged on the site, check for saved Site Editor template/style overrides. Explain file defaults versus database customizations. Do not delete or reset an author's overrides without authorization.
6. Make the smallest coherent edit. Preserve valid block serialization and existing naming/text-domain conventions. Keep editable content editable; use locking, content-only editing, or allowed-block restrictions only when the content workflow calls for them and the target version supports them.
7. Run the project's applicable JSON, PHP, lint, or build checks. Verify the rendered frontend and Site Editor for the changed slice: layout, supported controls, block validation, preset styles, and responsive behavior. Check keyboard access, focus, contrast, and semantic landmarks relevant to the change.
8. Report the native capability used, any justified custom code, checks run, and remaining verification gaps. If browser or WordPress access is unavailable, say so explicitly.

## Boundaries

- Do not replace core layout or styling mechanisms with a parallel component framework.
- Do not mistake a static mockup or a passing build for verified WordPress rendering.
- Do not use raw HTML blocks or PHP template markup to bypass an editing requirement.
- Do not turn Site Editor database customizations into source changes without checking the intended source of truth.
