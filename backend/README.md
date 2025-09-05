# Gyan-Ai Backend API

A comprehensive Node.js backend API for the Gyan-Ai educational platform, built with Express.js, PostgreSQL, and AI integration.

## 🚀 Features

- **Authentication & Authorization**: JWT-based auth with bcrypt password hashing
- **Curriculum Management**: Complete educational board/class/subject/chapter hierarchy
- **AI Content Generation**: OpenRouter for quiz generation, Fal.ai for video creation
- **Progress Tracking**: User progress, quiz attempts, and gamification
- **RESTful API**: Clean, well-documented endpoints
- **Database**: PostgreSQL with Knex.js ORM and migrations
- **Security**: Rate limiting, CORS, helmet, input validation

## 🛠️ Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: PostgreSQL (Neon)
- **ORM**: Knex.js
- **Authentication**: JWT + bcryptjs
- **AI Integration**: OpenRouter + Fal.ai
- **Validation**: express-validator
- **Security**: helmet, cors, express-rate-limit

## 📋 Prerequisites

- Node.js 18+ 
- PostgreSQL database (Neon recommended)
- OpenRouter API key
- Fal.ai API key

## 🚀 Quick Start

### 1. Install Dependencies
```bash
npm install
```

### 2. Environment Setup
```bash
cp env.example .env
```

Update `.env` with your actual values:
```env
# Database
NEON_DATABASE_URL=your_neon_database_url

# JWT
JWT_SECRET=your-super-secret-jwt-key

# AI Services
OPENROUTER_API_KEY=your_openrouter_api_key
FAL_AI_API_KEY=your_fal_ai_api_key

# Server
PORT=3000
NODE_ENV=development
FRONTEND_URL=http://localhost:3000
```

### 3. Database Setup
```bash
# Run migrations
npm run migrate

# Seed initial data
npm run seed
```

### 4. Start Server
```bash
# Development
npm run dev

# Production
npm start
```

## 📚 API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/profile` - Get user profile
- `PUT /api/auth/profile` - Update user profile
- `GET /api/auth/progress` - Get user progress

### Curriculum
- `GET /api/curriculum/boards` - Get all boards
- `GET /api/curriculum/boards/:boardId/classes` - Get classes for board
- `GET /api/curriculum/classes/:classId/subjects` - Get subjects for class
- `GET /api/curriculum/subjects/:subjectId/chapters` - Get chapters for subject
- `GET /api/curriculum/chapters/:chapterId` - Get chapter details
- `GET /api/curriculum/user-curriculum` - Get user's curriculum

### Content
- `GET /api/content/video/:chapterId` - Get/generate video content
- `POST /api/content/video/:contentId/complete` - Mark video completed
- `GET /api/content/quiz/:chapterId` - Get/generate quiz content
- `POST /api/content/quiz/:contentId/submit` - Submit quiz answers
- `GET /api/content/stats` - Get content statistics

### Profile
- `GET /api/profile` - Get user profile
- `PUT /api/profile` - Update user profile
- `GET /api/profile/progress` - Get user progress

## 🗄️ Database Schema

### Core Tables
- `boards` - Educational boards (CBSE, ICSE, State)
- `classes` - Classes (5-10) for each board
- `subjects` - Subjects for each class
- `chapters` - Chapters for each subject
- `users` - User accounts and preferences
- `content` - AI-generated video/quiz content
- `user_progress` - User completion tracking
- `quiz_attempts` - Quiz attempt records

## 🤖 AI Integration

### OpenRouter (Quiz Generation)
- Generates 5 multiple-choice questions per chapter
- Tailored to grade level and educational board
- Returns structured JSON format

### Fal.ai (Video Generation)
- Creates 90-second educational videos
- Based on AI-generated scripts
- Stored in cloud storage

## 🔒 Security Features

- **JWT Authentication**: Secure token-based auth
- **Password Hashing**: bcryptjs with salt rounds
- **Rate Limiting**: 100 requests per 15 minutes
- **CORS Protection**: Configurable origins
- **Input Validation**: express-validator
- **SQL Injection Protection**: Knex.js parameterized queries
- **Helmet**: Security headers

## 📊 Error Handling

Comprehensive error handling with:
- Validation errors (400)
- Authentication errors (401)
- Not found errors (404)
- Server errors (500)
- Database constraint errors
- AI service errors

## 🧪 Testing

```bash
# Run tests
npm test

# Run with coverage
npm run test:coverage
```

## 📈 Monitoring

- **Health Check**: `GET /health`
- **Request Logging**: Morgan combined format
- **Error Logging**: Console + structured logging
- **Database Monitoring**: Connection health checks

## 🚀 Deployment

### Environment Variables
Ensure all required environment variables are set:
- `NEON_DATABASE_URL`
- `JWT_SECRET`
- `OPENROUTER_API_KEY`
- `FAL_AI_API_KEY`

### Database Migration
```bash
npm run migrate
```

### Production Start
```bash
npm start
```

## 📝 API Documentation

### Request/Response Format
All API responses follow this format:
```json
{
  "success": true|false,
  "message": "Description",
  "data": { ... },
  "errors": [ ... ] // Only on validation errors
}
```

### Authentication
Include JWT token in Authorization header:
```
Authorization: Bearer <jwt_token>
```

### Error Codes
- `400` - Bad Request (validation errors)
- `401` - Unauthorized (invalid/missing token)
- `404` - Not Found
- `409` - Conflict (duplicate resource)
- `500` - Internal Server Error

## 🔧 Development

### Project Structure
```
backend/
├── src/
│   ├── config/          # Database configuration
│   ├── controllers/     # Route controllers
│   ├── middleware/      # Custom middleware
│   ├── models/          # Data models
│   ├── routes/          # API routes
│   └── services/        # Business logic & AI integration
├── database/
│   ├── migrations/      # Database migrations
│   └── seeds/          # Initial data
├── server.js           # Main server file
└── knexfile.js         # Knex configuration
```

### Adding New Features
1. Create migration for database changes
2. Update models if needed
3. Add controller methods
4. Create/update routes
5. Add validation rules
6. Write tests

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Add tests
5. Submit pull request

## 📄 License

MIT License - see LICENSE file for details.
