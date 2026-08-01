# 🔗 WorkLink — AI-Powered Professional Ecosystem

> **Connect Skills. Solve Problems. Build Opportunities.**

WorkLink is an AI-powered professional ecosystem that connects customers, professionals, freelancers, skilled workers, businesses, and service providers into one trusted digital platform.

Combining the strengths of **LinkedIn**, **Upwork**, **Uber**, **Airbnb**, **Fiverr**, **Google Maps**, and **ChatGPT** into a seamless ecosystem.

---

## 🚀 Vision

Build the most user-friendly and trusted professional ecosystem in Nepal first, with an architecture designed to scale globally — from a hackathon MVP into a nationwide platform serving millions of users.

---

## ✨ Core Features

### 🔐 Authentication & Guest Mode
- Phone OTP-based authentication (Nepal +977 with multi-country support)
- Guest mode for browsing professionals
- Role-based profiles (Customer, Professional, Business, Admin)
- JWT access + refresh token security

### 👷 Professional Discovery
- Browse verified professionals with ratings, reviews, and portfolios
- Category-based browsing (Plumbing, Electrical, Carpentry, Cleaning, Painting, and more)
- Search, filter, and sort by rating/price/experience
- Real-time availability status

### 📋 Smart Service Requests (Flagship Feature)
- Describe a problem, optionally upload photos
- Nearby verified professionals receive the request and submit quotations
- Compare offers and select the best one

### 🗓️ Direct Booking
- Search, compare, and book professionals directly
- Date/time scheduling with price breakdown
- Automatic chat creation after booking

### 💬 Real-Time Chat
- One-on-one messaging between customers and professionals
- Typing indicators, read receipts (Socket.IO)
- Message history and unread counts

### 📊 Booking Management
- Status tracking (PENDING → ACCEPTED → IN_PROGRESS → COMPLETED)
- Quotation accept/reject workflow
- Booking history for customers and professionals

### 🤖 AI Assistant
- AI-powered category suggestions from service descriptions
- Smart cost estimation
- Extensible provider abstraction (OpenAI / Gemini / local rule-based fallback)

### 💳 Payments (Architecture Ready)
- eSewa / Khalti / Cash payment methods
- Payment initiation and verification flow
- Payment history and invoice tracking

### 🔔 Notifications
- In-app notifications for bookings, quotations, and messages
- Unread count and mark-as-read
- FCM token registration (firebase-ready)

### 🛡️ Admin Dashboard
- Platform analytics and revenue reports
- User/booking/review management
- Professional verification workflow
- Category management

---

## 🏗️ Tech Stack

### Frontend (Flutter)
| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.44+ / Dart 3.12+ |
| State Management | Riverpod (ProviderScope, ConsumerWidget) |
| Routing | go_router (StatefulShellRoute) |
| Local Storage | shared_preferences, flutter_secure_storage |
| Networking | http (via service/repository pattern) |
| UI | Material 3, Google Fonts, Shimmer, Cached Network Images |

### Backend (Node.js)
| Layer | Technology |
|-------|-----------|
| Runtime | Node.js 18+ / TypeScript |
| Framework | Express 5 |
| Database | PostgreSQL + Prisma ORM |
| Real-time | Socket.IO |
| Auth | JWT (access + refresh tokens) |
| Validation | express-validator |
| Security | Helmet, CORS, express-rate-limit |
| File Upload | Multer + Sharp + Cloudinary |
| Logging | Winston + Morgan |
| Cache | Redis (optional) |

---

## 📁 Project Structure

```
worklink/
├── lib/                          # Flutter frontend
│   ├── app/                      # App-level (router, providers, theme)
│   ├── core/                     # Shared utilities, colors, widgets
│   ├── features/                 # Feature modules
│   │   ├── auth/                 # OTP auth, profile completion
│   │   ├── home/                 # Customer & Professional dashboards
│   │   ├── professionals/        # Listing, detail, search
│   │   ├── booking/              # Bookings, service requests, quotations
│   │   ├── chat/                 # Real-time chat
│   │   ├── profile/              # User profile
│   │   ├── notifications/        # Notifications
│   │   ├── admin/                # Admin dashboard
│   │   └── ai/                   # AI assistant
│   ├── models/                   # Domain models
│   └── services/                 # Business logic services
│
├── backend/                      # Node.js backend
│   ├── src/
│   │   ├── app.ts                # Express app
│   │   ├── server.ts             # HTTP + Socket.IO server
│   │   ├── config/               # Config (dotenv, database, logger)
│   │   ├── controllers/          # Request handlers
│   │   ├── routes/               # API route definitions
│   │   ├── middlewares/          # Auth, validation, rate limiting
│   │   ├── services/             # Business services
│   │   ├── socket/               # Socket.IO handlers
│   │   ├── ai/                   # AI service abstraction
│   │   ├── payments/             # eSewa/Khalti integrations
│   │   └── database/prisma/      # Prisma schema & seed
│   └── package.json
│
├── android/ ios/ web/            # Platform-specific config
└── assets/                       # Images & icons
```

---

## 🚦 Getting Started

### Prerequisites
- Flutter 3.44+
- Node.js 18+
- PostgreSQL (or Docker for DB)
- Optional: Redis (for cache), Cloudinary (for image hosting)

### Backend Setup

```bash
cd backend

# Install dependencies
npm install

# Configure environment
cp .env.example .env
# Edit .env with your database URL and secrets

# Generate Prisma client
npm run prisma:generate

# Push schema to database
npm run prisma:push

# Seed sample data (categories, admin, professionals)
npm run prisma:seed

# Start dev server
npm run dev
```

The API will be available at `http://localhost:5000` with health check at `http://localhost:5000/api/health`.

### Flutter Frontend

```bash
# From project root
flutter pub get

# Run on web
flutter run -d chrome

# Run on Android emulator
flutter run

# Build release
flutter build web --release
flutter build apk --release
```

---

## 🔌 API Overview

| Module | Base Path | Key Endpoints |
|--------|-----------|---------------|
| Auth | `/api/auth` | `POST /send-otp`, `POST /verify-otp`, `POST /complete-profile`, `GET /me` |
| Professionals | `/api/professionals` | `GET /`, `GET /:id`, `PATCH /profile`, `PATCH /availability` |
| Customers | `/api/customers` | `GET /dashboard`, `GET /bookings` |
| Bookings | `/api/bookings` | `POST /`, `GET /`, `GET /:id`, `PATCH /:id/status` |
| Service Requests | `/api/service-requests` | `POST /`, `GET /`, `GET /:id`, `GET /nearby`, `PATCH /:id/close` |
| Quotations | `/api/quotations` | `POST /`, `GET /request/:serviceRequestId`, `POST /:id/accept`, `POST /:id/reject` |
| Chat | `/api/chat` | `GET /`, `GET /:chatId/messages`, `POST /:chatId/messages`, `POST /:chatId/read` |
| Notifications | `/api/notifications` | `GET /`, `PATCH /:id/read`, `PATCH /read-all`, `GET /unread-count` |
| Payments | `/api/payments` | `POST /initiate`, `POST /verify`, `GET /history`, `GET /booking/:bookingId` |
| Categories | `/api/categories` | `GET /`, `GET /:slug` |
| Reviews | `/api/reviews` | `POST /`, `GET /user/:userId` |
| AI | `/api/ai` | `POST /suggest-category`, `POST /estimate-cost`, `POST /chat` |
| Admin | `/api/admin` | Dashboard stats, users, bookings, reviews, reports |

---

## 🔐 Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Server port | `5000` |
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://localhost:5432/worklink` |
| `JWT_ACCESS_TOKEN_SECRET` | JWT access token secret | dev-only default |
| `JWT_REFRESH_TOKEN_SECRET` | JWT refresh token secret | dev-only default |
| `JWT_ACCESS_TOKEN_EXPIRY` | Access token expiry | `15m` |
| `JWT_REFRESH_TOKEN_EXPIRY` | Refresh token expiry | `7d` |
| `REDIS_URL` | Redis URL (optional) | `redis://localhost:6379` |
| `CLOUDINARY_*` | Cloudinary credentials (optional) | — |
| `OPENAI_API_KEY` | OpenAI key for AI (optional) | — |
| `GEMINI_API_KEY` | Gemini key for AI (optional) | — |
| `ESEWA_MERCHANT_ID` | eSewa merchant ID | — |
| `KHALTI_MERCHANT_ID` | Khalti merchant ID | — |

---

## 🧪 Quality Assurance

```bash
# Backend type-check
cd backend && npx tsc --noEmit

# Flutter static analysis
flutter analyze

# Flutter tests
flutter test
```

---

## 🗺️ Roadmap

### MVP (Hackathon) ✅
- [x] Guest Mode
- [x] Authentication (OTP)
- [x] Professional Listing & Search
- [x] Professional Profiles
- [x] Smart Service Request + Quotation System
- [x] Direct Booking
- [x] Booking Management
- [x] Real-time Chat
- [x] Notifications
- [x] Admin Dashboard

### Post-MVP
- [ ] Real AI provider integration (OpenAI/Gemini)
- [ ] eSewa/Khalti payment gateway integration
- [ ] Google Maps integration
- [ ] Push notifications (FCM)
- [ ] Wallet & invoicing
- [ ] Business profiles & team management
- [ ] Global expansion (multi-currency, multi-language)

---

## 🏆 Hackathon Philosophy

> "Does this make the user's life easier?"

Every feature in WorkLink answers this question. We prioritize **quality over quantity** — a polished MVP with fewer features beats an unfinished app with hundreds. Every screen, API, and model is built with production-grade standards.

---

© 2025 WorkLink Team. Built for the hackathon.

