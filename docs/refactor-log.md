# Site Refactor Log

## 2026-05-12T15:09:11-06:00

- Files changed:
  - `lib/app/views/home_view.dart`
  - `lib/app/components/home/home_dual_expertise_section.dart`
  - `lib/app/components/home/home_preview_cards_section.dart`
  - `docs/uml/home-view-components.puml`
  - `docs/architecture/prompt-02-home-view-refactor.tex`
- What changed: Split the oversized homepage route file into a route-level composition widget plus two focused home-section components.
- Why it changed: `home_view.dart` was the next known live-site hand-authored source file over 500 lines and mixed page composition, section layout, local view data, route navigation, hover state, and animation details.
- Design/architecture principle applied: Presentational component extraction, composition over inheritance, Single Responsibility Principle, and private immutable view data for section-local copy.
- UI/UX notes: Preserved the live content, colors, typography, animations, route targets, hover affordances, and desktop/tablet/mobile breakpoints.
- Tests/checks run: `dart format` on touched Dart files; `flutter analyze`; `flutter test`; `flutter build web`; line-count scan for touched Dart files; live-site oversized Dart scan; LuaLaTeX compile for the prompt note; `git diff --check` for touched site files.
- Result of tests/checks: Passed. The sandboxed Flutter commands first failed on `/opt/flutter/bin/cache/engine.stamp`; escalated reruns passed. `flutter build web` completed with existing dependency Wasm dry-run warnings from `desktop_drop`, `speech_to_text`, and `image`, then produced `build/web`.
- Commit hash after committing: Pending.

## 2026-05-13T12:32:27-06:00

- Prompt 04 selected file and reason: `lib/app/components/portal/portal_sidebar.dart` was the longest clean tracked live-site Dart file at or above 430 lines after Prompt 03 was found missing. Longer candidates were pre-existing dirty or untracked site-local work and were skipped to avoid absorbing unrelated changes.
- Prompt 03 detection: Missing. `docs/architecture/prompt-03-near-threshold-refactor.tex`, `docs/uml/prompt-03-near-threshold-components.puml`, and a Prompt 03 refactor-log entry were not present.
- Files changed:
  - `lib/app/components/portal/portal_sidebar.dart`
  - `lib/app/components/portal/sidebar/portal_sidebar_profile.dart`
  - `lib/app/components/portal/sidebar/portal_sidebar_navigation.dart`
  - `lib/app/components/portal/sidebar/portal_sidebar_footer.dart`
  - `docs/uml/prompt-04-near-threshold-components.puml`
  - `docs/architecture/prompt-04-near-threshold-refactor.tex`
- What changed: Split the portal sidebar into a composition shell plus focused profile, navigation, and footer presentation widgets.
- Why it changed: The sidebar was a near-threshold presentation component with user profile rendering, menu configuration, AI conversation history, and logout UI in one file.
- Design/architecture principle applied: Composition, presentational component extraction, private immutable view data for local navigation items, and explicit callback boundaries for tab, chat, and logout actions.
- UI/UX notes: Preserved the portal colors, spacing, tab order, badges, AI history behavior, avatar behavior, and version/logout area. Added semantic labels to navigation, AI chat, conversation, and logout controls without changing visuals.
- Tests/checks run: `dart format` on touched Dart files; `flutter analyze`; `flutter test`; `flutter build web`; line-count scan for touched Dart files; live-site near-threshold Dart scan; import/usage grep for extracted components; LuaLaTeX compile for the prompt note; `git diff --check` for touched site files.
- Result of tests/checks: Passed. Sandboxed Flutter commands first failed on `/opt/flutter/bin/cache/engine.stamp`; escalated reruns passed. `flutter build web` completed with existing dependency Wasm dry-run warnings from `desktop_drop`, `speech_to_text`, and `image`, then produced `build/web`.
- Commit hash after committing: Pending.

## 2026-05-13T14:30:20-06:00

- Prompt 05 selected file/section and reason: The contact section was selected because `contact.dart`, `contact/contact_offices.dart`, and `contact/contact_form.dart` formed a coherent, site-local split of the live contact page and could be isolated as one focused slice.
- Contact-section ownership decision: Owned for Prompt 05. The modified composition file and untracked contact part files were all part of the same contact-section refactor; no unrelated contact work was detected.
- Files changed:
  - `lib/app/components/contact.dart`
  - `lib/app/components/contact/contact_offices.dart`
  - `lib/app/components/contact/contact_office_card.dart`
  - `lib/app/components/contact/contact_section_models.dart`
  - `lib/app/components/contact/contact_form.dart`
  - `lib/app/components/contact/contact_form_fields.dart`
  - `docs/uml/prompt-05-contact-or-next-safe-components.puml`
  - `docs/architecture/prompt-05-contact-or-next-safe-refactor.tex`
- What changed: Stabilized the pre-existing contact split, moved office-card rendering and local office data into focused contact-local files, and moved reusable form field rendering into a contact-local field file.
- Why it changed: `contact_offices.dart` and `contact_form.dart` were near-threshold files and mixed section composition, local view data, card rendering, contact details, form state, and field validation.
- Design/architecture principle applied: Composition, contact-local presentation boundaries, private immutable view data, and explicit form-state ownership inside the contact section.
- UI/UX notes: Preserved visible copy, office details, form layout, animations, contact CTA behavior, and brand colors. Added semantic labels for office contact details and submit/contact actions without visual changes.
- Tests/checks run: `dart format` on touched Dart files; `flutter analyze`; `flutter test`; `flutter build web`; line-count scan for touched Dart files; live-site near-threshold Dart scan; import/part usage grep; LuaLaTeX compile for the prompt note; `git diff --check` for touched site files.
- Result of tests/checks: Passed. Sandboxed Flutter commands first failed on `/opt/flutter/bin/cache/engine.stamp`; escalated reruns passed. `flutter build web` completed with existing dependency Wasm dry-run warnings from `desktop_drop`, `speech_to_text`, and `image`, then produced `build/web`.
- Commit hash after committing: Pending.

## 2026-05-13T15:04:32-06:00

- Prompt 06 selected file/section and reason: `lib/app/components/portal/messages_view.dart` was selected because it was the longest remaining near-threshold live-site Dart file and its dirty changes were coherent, message-specific, and site-local.
- Messages ownership decision: Owned for Prompt 06. No existing `portal/messages/**` files were present, and the `messages_view.dart` diff only contained coherent site-local messaging updates that could be isolated safely.
- Files changed:
  - `lib/app/components/portal/messages_view.dart`
  - `lib/app/components/portal/messages/messages_sidebar.dart`
  - `lib/app/components/portal/messages/messages_empty_state.dart`
  - `lib/app/components/portal/messages/messages_thread_panel.dart`
  - `lib/app/components/portal/messages/messages_thread_header.dart`
  - `lib/app/components/portal/messages/messages_composer.dart`
  - `lib/app/components/portal/messages/message_bubble.dart`
  - `docs/uml/prompt-06-portal-messages-or-next-safe-components.puml`
  - `docs/architecture/prompt-06-portal-messages-or-next-safe-refactor.tex`
- What changed: Split the portal messages view into a stateful page composition boundary plus focused sidebar, empty state, thread panel, thread header, composer, and message bubble components.
- Why it changed: The original file mixed async orchestration, service calls, matter selection state, conversation list rendering, thread rendering, composer UI, message bubble styling, and local accessibility behavior in one near-threshold file.
- Design/architecture principle applied: Composition, presentational component extraction, explicit callback boundaries, and side-effect isolation in the stateful page boundary.
- UI/UX notes: Preserved message ordering, matter selection, portal styling, call actions, composer behavior, responsive desktop/mobile split, animation timing, and status copy. Added focused semantic labels for selectable conversations and message bubbles without changing the visible design.
- Tests/checks run: `dart format` on touched Dart files; `flutter analyze`; `flutter test`; `flutter build web`; line-count scan for touched Dart files; live-site near-threshold Dart scan; extracted-component usage grep; LuaLaTeX compile for the prompt note; `git diff --check` for touched site files.
- Result of tests/checks: Passed. Sandboxed Flutter commands first failed on `/opt/flutter/bin/cache/engine.stamp`; escalated reruns passed. `flutter build web` completed with existing dependency Wasm dry-run warnings from `desktop_drop`, `speech_to_text`, and `image`, then produced `build/web`.
- Commit hash after committing: Pending.

## 2026-05-13T15:24:03-06:00

- Prompt 07 selected file/section and reason: `lib/app/components/portal/matters_view.dart` was selected because it was the longest remaining near-threshold live-site Dart file and its dirty changes were coherent, matter-specific, and site-local.
- Matters ownership decision: Owned for Prompt 07. No existing `portal/matters/**` files were present, and the `matters_view.dart` diff only contained coherent formatting and unused-cache cleanup that could be isolated safely.
- Files changed:
  - `lib/app/components/portal/matters_view.dart`
  - `lib/app/components/portal/matters/matters_page_header.dart`
  - `lib/app/components/portal/matters/matters_filter_bar.dart`
  - `lib/app/components/portal/matters/matters_list.dart`
  - `lib/app/components/portal/matters/matter_card.dart`
  - `docs/uml/prompt-07-portal-matters-or-next-safe-components.puml`
  - `docs/architecture/prompt-07-portal-matters-or-next-safe-refactor.tex`
- What changed: Split the portal matters view into a stateful page composition boundary plus focused page header, filter bar, sliver list, loading/empty states, and matter card components.
- Why it changed: The original file mixed async matter loading, fuzzy-search indexing, search/filter state, pinned filter UI, loading/empty list rendering, card layout, context-menu actions, and PDF preview orchestration in one near-threshold file.
- Design/architecture principle applied: Composition, presentational component extraction, explicit callback boundaries, and side-effect isolation in the stateful page boundary.
- UI/UX notes: Preserved matter ordering, fuzzy search behavior, status filters, pinned filter surface, report preview action, desktop/mobile layout, animation, and portal brand styling. Added a semantic matter-card label without adding visual clutter.
- Tests/checks run: `dart format` on touched Dart files; `flutter analyze`; `flutter test`; `flutter build web`; line-count scan for touched Dart files; live-site near-threshold Dart scan; extracted-component usage grep; LuaLaTeX compile for the prompt note; `git diff --check` for touched site files and docs.
- Result of tests/checks: Passed. Flutter commands ran with escalated access for the shared SDK cache. `flutter build web` completed with existing dependency Wasm dry-run warnings from `desktop_drop`, `speech_to_text`, and `image`, then produced `build/web`.
- Commit hash after committing: Pending.

## 2026-05-13T16:52:16-06:00

- Prompt 08 selected file/section and reason: `lib/app/components/ai_assistant/chat_area.dart` was selected because it was the longest remaining near-threshold live-site Dart file and its dirty changes were coherent, AI-chat-specific, and site-local.
- AI chat ownership decision: Owned for Prompt 08. No existing `ai_assistant/chat/**` files were present, and the `chat_area.dart` diff only contained coherent formatting, unused import cleanup, and safe mounted/error-handling improvements that could be isolated safely.
- Files changed:
  - `lib/app/components/ai_assistant/chat_area.dart`
  - `lib/app/components/ai_assistant/chat/chat_empty_state.dart`
  - `lib/app/components/ai_assistant/chat/chat_message_list.dart`
  - `lib/app/components/ai_assistant/chat/chat_composer.dart`
  - `lib/app/components/ai_assistant/chat/chat_drop_overlay.dart`
  - `docs/uml/prompt-08-ai-chat-or-next-safe-components.puml`
  - `docs/architecture/prompt-08-ai-chat-or-next-safe-refactor.tex`
- What changed: Split the AI assistant chat area into a hook-based state and side-effect boundary plus focused empty-state, transcript, composer, and drag-overlay presentation components.
- Why it changed: The original file mixed conversation loading, source restoration, file upload, drag-and-drop, voice input, send orchestration, scroll behavior, empty state, message list, typing state, composer controls, and attachment UI in one near-threshold file.
- Design/architecture principle applied: Composition, presentational component extraction, explicit callback boundaries, and side-effect isolation in the hook boundary.
- UI/UX notes: Preserved message ordering, empty state, typing copy, drag overlay, attachment chip, voice/web/search/send controls, upload progress, scroll behavior, and the Justicia Administrativa AI assistant brand treatment.
- Tests/checks run: `dart format` on touched Dart files; `flutter analyze`; `flutter test`; `flutter build web`; line-count scan for touched Dart files; live-site near-threshold Dart scan; extracted-component usage grep; LuaLaTeX compile for the prompt note; `git diff --check` for touched site files and docs.
- Result of tests/checks: Passed after one slice-local const fix in the extracted typing indicator. Flutter commands ran with escalated access for the shared SDK cache. `flutter build web` completed with existing dependency Wasm dry-run warnings from `desktop_drop`, `speech_to_text`, and `image`, then produced `build/web`; build artifacts were not staged.
- Commit hash after committing: Pending.
