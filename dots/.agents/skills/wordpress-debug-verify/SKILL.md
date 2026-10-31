---
name: wordpress-debug-verify
description: "Diagnose and verify WordPress theme, FSE, Gutenberg, WooCommerce, ACF, plugin integration, hook timing, cache, and editor/frontend issues. Use for reproducing bugs, testing fixes, and investigating regressions with focused checks in the actual WordPress runtime."
---

# WordPress Debugging And Verification

## Procedure

1. Start from the exact symptom, request, failing test, console error, or owning file. Identify the available local runtime and relevant versions. Use existing project commands and configuration; never print credentials or source secret-bearing files under shell tracing.
2. Establish one falsifiable local hypothesis and the cheapest discriminating check. Compare editor versus frontend, authenticated versus anonymous, or origin versus proxy only when that distinction explains the symptom.
3. Check the relevant boundary before patching:
   - FSE output: file template versus saved wp_template/wp_template_part overrides; theme.json defaults versus saved global styles.
   - Plugin integration: the lifecycle hook where the required object/API is actually initialized; reproduce normal WordPress startup, not just an isolated function call.
   - Data: real return types, unslashing/sanitization, query results, and permissions.
   - Cache: authoritative data versus cached data; identify the exact key/group and invalidation owner.
   - Assets: registration, load context, generated files, same-origin/proxy behavior, and browser errors.
   - WooCommerce: actual filters, page context, order/checkout flow, and installed extension behavior rather than assumed core defaults.
4. Prefer correcting configuration, supported API usage, lifecycle timing, or the owning implementation. Do not work around an unexplained failure by duplicating core logic.
5. Make the smallest root-cause change and immediately rerun the focused check. If the result contradicts the hypothesis, move one nearby boundary toward the controlling code rather than expanding the search indiscriminately.
6. Use existing test helpers and declared development dependencies. Tests should run in the repository's CI environment without undeclared neighboring plugins or developer-specific paths. Do not fix unrelated failures.
7. Verify the risk introduced by the change: PHP/JS errors, saved block validity, editor/frontend parity, authorization, dynamic data, and relevant plugin paths. Browser verification must run against the actual WordPress site when the behavior depends on WordPress.
8. For cache or data repairs, target only the affected records/keys. Obtain authorization before production changes, destructive resets, plugin activation/deactivation, broad cache flushes, or Site Editor override deletion.
9. Close with the root cause, changed behavior, checks actually run, and residual gaps. Distinguish a proposed check, a skipped check, and a passing check.

## Review Mode

When asked only to review, do not edit. Lead with concrete findings ordered by severity, each with a file/line reference, triggering condition, impact, and an actionable fix. Treat missing tests as a finding only when tied to a meaningful risk. A possible core replacement is a suggestion unless it creates a demonstrated correctness, compatibility, or maintenance problem.
