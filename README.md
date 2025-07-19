
# 📚 Book Finder App

This is a Flutter app I built to search books using the Open Library API. It allows users to type any book name or keyword and see a list of matching books with cover images and author names. The goal was to keep the app simple, fast, and clean — just like something you'd actually ship in production.

---

## 🔍 Features

- **Search books** in real-time by title, author, or keyword
- **Pagination** with infinite scroll (loads more books as you scroll)
- **Pull-to-refresh** to reload the latest results
- **SharedPreferences cache** to save recent searches locally
- **Shimmer loading UI** for better user experience
- Built using **Flutter BLoC** for proper state management
- Responsive layout — tested on **mobile and web**
- Clean architecture and organized folder structure

---

## 📁 Project Structure

```
lib/
├── core/                    # Shared utilities (local cache, constants)
├── features/
│   └── book_finder/
│       ├── data/            # Models and remote data source
│       ├── domain/          # Entities and repository (if extended)
│       └── presentation/
│           ├── bloc/        # Events, States, BLoC
│           ├── pages/       # Screens like SearchScreen
│           └── widgets/     # Reusable UI components
└── main.dart
```

The architecture is easy to scale and keeps logic out of the UI.

---

## 🧠 Why I Built It This Way

I wanted to build something that reflects the kind of work I’d be doing in a real Flutter job:

- **Proper state management (Bloc)**
- **Separation of concerns** (UI, logic, API, cache)
- **Error handling** for bad network, empty results, etc.
- **Smooth user experience** (shimmer, scroll detection, auto-load)
- **Optimized for performance** and **clean, readable code**

---

## 📸 Screenshots

| Search UI | Auto Scroll & Pagination |
|-----------|---------------------------|
| ![](screenshots/search.png) | ![](screenshots/scroll.png) |

---

## 🚀 How to Run

```bash
git clone https://github.com/shiv-validus/book-finder-app.git
cd book_finder_app
flutter pub get
flutter run
```

> Works great on both mobile and web!

---

## 🛠️ Tech Used

- **Flutter** (v3.22+)
- `flutter_bloc` — State management
- `dio` — API calls
- `shared_preferences` — Local storage
- `shimmer` — Loading placeholders

---

## ✨ Things I’m Proud Of

- Auto-scroll detection and pagination
- Pull-to-refresh logic with cache reset
- Local caching tied to each search keyword
- Code that’s clean, readable, and production-ready
- Mobile + Web tested

---

## 👋 About Me

I'm **Shiv Shankar Tiwari**, a mobile developer with 6+ years of experience working on Flutter, React Native, Android, and full-stack apps.

This app is part of a coding assignment — but I treated it like a real-world project. If you’re reviewing this, I hope it gives you a clear picture of how I work and think when building apps.

Let’s connect:  
🔗 [LinkedIn](https://www.linkedin.com/in/mobile-engineer/)  

---

## 📝 License

MIT – feel free to fork, modify, and use.
