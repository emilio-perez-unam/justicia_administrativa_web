# Testing

## Required Local Checks

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build web --release --base-href /
```

## Release Artifact Smoke Test

Serve the release artifact over HTTP:

```bash
python3 -m http.server 8080 --directory build/web
```

Smoke-test:

- `/`
- `/servicios`
- `/nosotros`
- `/equipo`
- `/blog`
- `/contacto`
- `/login`
- `/reset-password`
- `/portal`
- `/asistente-ia`
- an unknown route

For protected routes, unauthenticated users should be redirected to `/login`.

## Non-Happy Paths

Automated tests cover domain failures, form validation, portal view states, auth reset flow, billing/documents/matters/message loading, blog admin operations, contact submission behavior, and legal-corpus launcher availability.

Manual/browser smoke testing must also check:

- mobile menu;
- keyboard focus visibility;
- contact form validation and failure states;
- direct route refresh;
- missing route 404;
- unauthenticated protected-route redirects;
- no console errors in the release artifact.
