# CargoPro Frontend - Flutter (GetX + Firebase + REST API)

A production-ready Flutter cross-platform application (mobile & web) implementing Firebase Phone OTP authentication, GetX state management, and full CRUD operations against a public REST API. Built for the CargoPro Frontend Internship Assignment.

**GitHub:** https://github.com/Anikesh0001/cargopro_flutter  
**Live Web App:** https://cargopro-flutter-ee499.web.app  
**Android APK:** [Drive Link](https://drive.google.com/file/d/1HllUZeFLcAyxzH9CiTRFs0kP2Hy8qV1k/view?usp=sharing)  
**Walkthrough Video:** [Coming Soon - 5-10 min demo on Drive]

---

## 📞 Support & Questions

For questions about this project, contact:
- **Email:** anikeshkr0001@gmail.com
- **GitHub:** https://github.com/Anikesh0001

---

## 📄 License

This project is part of the CargoPro Frontend Internship Assignment and is not licensed for distribution beyond the assignment context.

---

**Built with ❤️ using Flutter & GetX**

**Last Updated:** December 5, 2025

### 2. API Integration: CRUD Operations
| Operation | HTTP Method | Implementation |
|-----------|-------------|-----------------|
| **List** | GET | `ApiService.fetchObjects(page, limit)` with pagination |
| **Detail** | GET | `ApiService.getObject(id)` |
| **Create** | POST | `ApiService.createObject(name, data)` |
| **Update** | PUT | `ApiService.updateObject(id, name, data)` |
| **Delete** | DELETE | `ApiService.deleteObject(id)` + optimistic UI |

**Files:** `lib/services/api_service.dart`, `lib/controllers/objects_controller.dart`

#### Key Features:
- **Pagination:** Scroll to load more (ScrollController listener in `ListViewPage`)
- **Optimistic Delete:** UI updates immediately; reverts on server error
- **Reserved Object Handling:** API prevents modifying seeded items (ids 1-13)
  - UI shows lock icon for reserved items
  - "Create Copy" action allows creating new editable copies
  - Server error dialogs with fallback suggestions

### 3. Data Model
Fully implemented `ApiObject` with serialization:
```dart
class ApiObject {
  final String id;
  final String name;
  final Map<String, dynamic> data;
  
  ApiObject.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}
```

**File:** `lib/models/api_object.dart`

### 4. UI/UX Requirements
- ✅ **Responsive layout:** LayoutBuilder switches between grid (wide) and list (mobile)
- ✅ **Material Design:** Custom theme with gradient backgrounds and card-based layouts
- ✅ **Loading indicators:** Visible on all API actions (fetch, create, update, delete)
- ✅ **Form validation:** 
  - Required fields (name, data)
  - JSON validation helper (`JsonUtils.isValidJson`)
  - Pretty-print JSON formatter
- ✅ **Empty/error states:** Shown for empty lists, network errors, and form failures

**Files:** `lib/views/`, `lib/utils/theme.dart`, `lib/utils/json_utils.dart`

### 5. Architecture & Code Structure

#### Folder Organization:
```
lib/
├── main.dart                    # App entry, Firebase init
├── app_bindings.dart            # GetX dependency injection
├── routes.dart                  # Route definitions & GetPages
├── models/
│   └── api_object.dart         # Data model + serialization
├── services/
│   └── api_service.dart        # HTTP calls (GET/POST/PUT/DELETE)
├── controllers/
│   ├── auth_controller.dart    # Firebase auth logic
│   └── objects_controller.dart # CRUD business logic
├── views/
│   ├── login_view.dart         # Phone input screen
│   ├── otp_view.dart           # OTP verification
│   ├── list_view.dart          # Paginated list + grid
│   ├── detail_view.dart        # Object details & actions
│   └── create_edit_view.dart   # Form for create/edit
└── utils/
    ├── theme.dart              # Material theme & styling
    └── json_utils.dart         # JSON validation & formatting
```

#### Design Patterns:
- **GetX Bindings:** `AppBindings` registers all services and controllers eagerly
- **Service Locator:** `Get.find<T>()` for dependency resolution
- **Observable State:** `Obx()` widgets observe GetX reactive values
- **Navigation:** GetX named routing with `Get.toNamed()`
- **Error Handling:** Centralized logging in `ApiService._log()`; snackbars/dialogs in controllers

### 6. Unit Tests
Two core methods are fully tested:

1. **`api_service_test.dart`** — Tests `ApiService` methods with `MockClient`
   - `fetchObjects()`, `createObject()`, `updateObject()`, `deleteObject()`
   - Verifies correct HTTP methods, headers, and response parsing

2. **`objects_controller_test.dart`** — Tests `ObjectsController` with `FakeApiService`
   - `fetchObjects()`, `createObject()`, `deleteObjectOptimistic()`
   - Validates state mutations and pagination logic

**Run tests:**
```bash
flutter test
```

---

## 📁 Project Structure

```
cargopro_flutter/
├── lib/                        # Dart source code
├── test/                       # Unit tests
├── web/                        # Web platform files (Firebase config)
├── android/                    # Android platform files
├── pubspec.yaml               # Dependencies & metadata
├── firebase.json              # Firebase hosting config
├── .firebaserc                # Firebase project config
└── README.md                  # This file
```

---

## 🛠 Tech Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| **Framework** | Flutter | 3.x |
| **Language** | Dart | ≥2.17.0 |
| **State Mgmt & DI** | GetX | ^4.6.5 |
| **Authentication** | Firebase Auth | ^4.2.5 |
| **HTTP Client** | http | ^0.13.5 |
| **Testing** | flutter_test, mockito | ^5.3.2 |
| **UI Framework** | Material Design 3 | Built-in |

**pubspec.yaml dependencies:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.5
  firebase_core: ^2.5.0
  firebase_auth: ^4.2.5
  http: ^0.13.5
```

---

## 💻 Installation & Setup

### Prerequisites
- **Flutter SDK** (3.x+) installed and in PATH
- **Dart SDK** (≥2.17.0)
- **Git** for cloning the repository
- **Firebase CLI** (for deployment): `npm install -g firebase-tools`

### Clone Repository
```bash
git clone https://github.com/Anikesh0001/cargopro_flutter.git
cd cargopro_flutter
```

### Install Dependencies
```bash
flutter pub get
```

### Enable Web Support (if not already enabled)
```bash
flutter config --enable-web
flutter channel stable
flutter upgrade
```

---

## 🔐 Firebase Configuration

### Web Setup (Required for Web Deployment)

1. **Create Firebase Project**
   - Go to https://console.firebase.google.com/
   - Click "Add Project" → enter "CargoPro Flutter"
   - Accept terms and create

2. **Enable Phone Authentication**
   - Go to Build → Authentication → Sign-in method
   - Enable "Phone"

3. **Add Web App**
   - Project settings → Add app → Select "Web"
   - Copy the Firebase config object

4. **Update `web/index.html`**
   - Replace placeholder in `web/index.html` with your Firebase config:
   ```html
   <script>
     const firebaseConfig = {
       apiKey: "YOUR_API_KEY",
       authDomain: "YOUR_AUTH_DOMAIN",
       projectId: "YOUR_PROJECT_ID",
       storageBucket: "YOUR_STORAGE_BUCKET",
       messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
       appId: "YOUR_APP_ID"
     };
   </script>
   ```
   - **Do NOT** call `firebase.initializeApp()` in JS (Dart handles it)

5. **Configure reCAPTCHA (for phone auth)**
   - Firebase Console → Authentication → Phone → Web reCAPTCHA key
   - The app will auto-trigger reCAPTCHA when user enters phone number

### Android Setup (Required for Mobile)

1. **Add Android App**
   - Firebase Console → Project settings → Add app → Select Android
   - Download `google-services.json`

2. **Place `google-services.json`**
   ```bash
   cp ~/Downloads/google-services.json android/app/
   ```

3. **Add SHA-1 (Recommended)**
   - Get your app's SHA-1: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`
   - Add to Firebase Console → Project settings → Android app

---

## 🏃 Running the App

### Web (Debug)
```bash
flutter run -d chrome
```
Then login with any phone number (Firebase emulator or real phone if configured).

### Android (Debug)
```bash
flutter run -d <device_id>
```
Find device ID: `flutter devices`

### Web (Release)
```bash
flutter build web --release
```

### Android (Release APK)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📦 Building & Deployment

### Build Android APK
```bash
flutter build apk --release
# Creates: build/app/outputs/flutter-apk/app-release.apk (21 MB)
```

Then upload to Google Drive for distribution.

### Deploy Web to Firebase Hosting

1. **Build web release**
   ```bash
   flutter build web --release
   ```

2. **Login to Firebase**
   ```bash
   firebase login
   ```

3. **Initialize hosting (one-time)**
   ```bash
   firebase init hosting
   # Choose:
   # - Public directory: build/web
   # - Single-page app (rewrite all routes to index.html): yes
   ```

4. **Deploy**
   ```bash
   firebase deploy --only hosting
   # Output: Hosting URL like https://cargopro-flutter-ee499.web.app
   ```

---

## 🔄 CRUD Operations Guide

### Create (POST)
1. **Web:** Tap "Create" FAB on list page
2. **Form:** Enter object name and JSON data
3. **Validation:** Name required, data must be valid JSON
4. **Submit:** Taps "Create" → POST to API
5. **Result:** New object appears at top of list with server-assigned ID

### Read (GET)
1. **List:** Tap list page → auto-fetches objects with pagination
2. **Detail:** Tap any item → opens detail screen showing all fields
3. **Pagination:** Scroll to bottom → auto-loads next page (20 items/page)

### Update (PUT)
1. **Detail Page:** Tap item → detail screen
2. **Edit Button:** Tap "Edit" → edit form pre-filled with current data
3. **Modify:** Change name and/or data JSON
4. **Submit:** Tap "Save" → PUT request to API
5. **Result:** List updates with new values

#### Handling Reserved Objects:
- **If reserved** (id ≤ 13): Show lock icon, disable edit/delete
- **Alternative:** Tap "Create Copy" → create new editable object
- **After copy:** Edit/delete the new object freely

### Delete (DELETE)
1. **List View:** Click delete icon (trash) on list item
2. **Detail View:** Tap red "Delete" button
3. **Confirmation:** Confirm dialog appears
4. **Optimistic Update:** UI removes item immediately
5. **Server Response:** 
   - Success: Item stays removed
   - Error (reserved): Item reverts, dialog suggests "Create Copy"
   - Error (other): Item reverts, snackbar shows error

---

## 🏗 Architecture & Design Decisions

### 1. GetX for State Management
**Why:** Minimal boilerplate, excellent for dependency injection and navigation

**Usage:**
- `AuthController.isLoading` — reactive boolean observable
- `ObjectsController.objects` — reactive list observable
- `Get.find<T>()` — service locator pattern
- `Get.toNamed(routeName)` — push-based navigation
- `Obx()` — rebuild on observable change

### 2. Service Layer Abstraction
**Why:** Decouples API from business logic; easy to mock/test

**Design:**
- `ApiService` handles all HTTP; logs requests/responses
- `ObjectsController` orchestrates state & pagination
- Controllers inject `ApiService` via GetX

### 3. Reserved Object Handling
**Challenge:** API forbids modifying seeded items (1-13)

**Solution:**
- Heuristic: UI treats numeric IDs ≤ 13 as reserved
- Show lock icon; disable edit/delete buttons
- Offer "Create Copy" action → POST new object with same data
- On API 405 error → show dialog with fallback suggestion

### 4. Optimistic Delete
**Why:** Better perceived performance; user sees instant feedback

**Flow:**
1. User clicks delete
2. UI removes item immediately
3. DELETE request sent async
4. If error: revert + show snackbar
5. If success: item stays removed

### 5. Pagination
**Implementation:**
- `ScrollController` attached to ListView/GridView
- Listener triggers `ObjectsController.fetchObjects()` when near bottom
- `hasMore` flag stops fetching when API returns empty page

---

## 🧪 Testing

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/api_service_test.dart
flutter test test/objects_controller_test.dart
```

### Test Coverage
- **ApiService:** 4 HTTP methods (GET/POST/PUT/DELETE) with MockClient
- **ObjectsController:** Pagination, create, delete logic with FakeApiService

### Example Test (ApiService)
```dart
test('fetchObjects returns list of ApiObject', () async {
  final service = ApiService(client: MockClient(...));
  final result = await service.fetchObjects(page: 1, limit: 20);
  expect(result, isA<List<ApiObject>>());
});
```

---

## ⚠️ Known Limitations & Future Work

### Current Limitations
1. **Reserved ID heuristic:** Uses numeric `id <= 13` instead of server-provided flag
2. **Error UI:** Scattered `Get.snackbar()` calls; could be centralized
3. **No offline support:** No caching or sync; requires network for all operations
4. **Mobile-only Auth:** Android uses `verifyPhoneNumber()` with auto-retrieval; iOS not tested

### Future Improvements
1. **Offline Caching:** Use Hive/Sqflite for local storage + sync logic
2. **Integration Tests:** Test full auth + CRUD flows with emulator/device
3. **Advanced Error UI:** Show network status, retry buttons, detailed error dialogs
4. **CI/CD:** GitHub Actions to run tests on every push
5. **Server-driven Reserved IDs:** Query API for metadata instead of heuristic
6. **Auto-open Edit:** After creating copy, auto-open edit screen for new object
7. **Form Builder:** Use package like `flutter_form_builder` for complex forms
8. **Accessibility:** Add semantic labels, high-contrast theme, screen reader support

---

## 📝 Submission & Contact

### What's Included
- ✅ Full source code with clean architecture
- ✅ Firebase Phone OTP auth (mobile & web)
- ✅ REST CRUD operations (GET/POST/PUT/DELETE)
- ✅ Pagination with optimistic updates
- ✅ Unit tests with mocks
- ✅ Responsive UI (grid/list)
- ✅ Android APK build
- ✅ Web deployment to Firebase Hosting

### Links
| Item | Link |
|------|------|
| **GitHub Repository** | https://github.com/Anikesh0001/cargopro_flutter |
| **Live Web App** | https://cargopro-flutter-ee499.web.app |
| **Android APK (Drive)** | [Download](https://drive.google.com/file/d/1HllUZeFLcAyxzH9CiTRFs0kP2Hy8qV1k/view?usp=sharing) |
| **Walkthrough Video** | https://drive.google.com/file/d/15l-gdcAejEdMOPqfRTvgw5MBCH9Nh2-s/view?usp=sharing |



## 📞 Support & Questions

For questions about this submission, contact:
- **Email:** anikeshkr0001@gmail.com
- **GitHub:** https://github.com/Anikesh0001

---

## 📄 License

This project is part of the CargoPro Frontend Internship Assignment and is not licensed for distribution beyond the assignment context.

---

**Built with ❤️ using Flutter & GetX**

**Last Updated:** December 5, 2025

