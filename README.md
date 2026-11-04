# portfolio

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Hosting

The app uses path URLs (`/architecture`, not `/#/architecture`), so the host
must serve `index.html` for every path that isn't a real file. Otherwise a
refresh or a shared deep link returns a 404.

- Firebase Hosting: `"rewrites": [{ "source": "**", "destination": "/index.html" }]`
- Netlify: `/*  /index.html  200` in `_redirects`
- Vercel: `{ "rewrites": [{ "source": "/(.*)", "destination": "/index.html" }] }`
- GitHub Pages: copy `build/web/index.html` to `build/web/404.html`
