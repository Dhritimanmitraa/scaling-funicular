# Gyan-Ai Backend API Documentation

## Base URL
```
http://localhost:3000/api
```

## Authentication
All protected endpoints require a JWT token in the Authorization header:
```
Authorization: Bearer <jwt_token>
```

## Response Format
All API responses follow this structure:
```json
{
  "success": true|false,
  "message": "Description",
  "data": { ... },
  "errors": [ ... ] // Only present on validation errors
}
```

---

## Authentication Endpoints

### Register User
**POST** `/api/auth/register`

Register a new user account.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "SecurePassword123",
  "selectedBoardId": "uuid", // Optional
  "selectedClassId": "uuid"  // Optional
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "selectedBoardId": "uuid",
      "selectedClassId": "uuid",
      "points": 0,
      "currentStreak": 0,
      "lastActiveDate": "2024-01-01",
      "createdAt": "2024-01-01T00:00:00.000Z",
      "updatedAt": "2024-01-01T00:00:00.000Z"
    },
    "token": "jwt_token"
  }
}
```

### Login User
**POST** `/api/auth/login`

Authenticate user and return JWT token.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "SecurePassword123"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": { ... },
    "token": "jwt_token"
  }
}
```

### Get User Profile
**GET** `/api/auth/profile`

Get current user's profile information.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "user": { ... }
  }
}
```

### Update User Profile
**PUT** `/api/auth/profile`

Update user's profile information.

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "selectedBoardId": "uuid",
  "selectedClassId": "uuid"
}
```

### Get User Progress
**GET** `/api/auth/progress`

Get user's learning progress and statistics.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "progress": [
      {
        "id": "uuid",
        "content_id": "uuid",
        "status": "completed",
        "completed_at": "2024-01-01T00:00:00.000Z",
        "chapter_name": "Motion",
        "subject_name": "Physics",
        "content_type": "video"
      }
    ],
    "quizAttempts": [
      {
        "id": "uuid",
        "score": 4,
        "total_questions": 5,
        "attempted_at": "2024-01-01T00:00:00.000Z",
        "chapter_name": "Motion",
        "subject_name": "Physics"
      }
    ],
    "stats": {
      "totalVideosWatched": 10,
      "totalQuizzesAttempted": 8,
      "averageQuizScore": 85,
      "currentStreak": 5,
      "totalPoints": 1250
    }
  }
}
```

---

## Curriculum Endpoints

### Get All Boards
**GET** `/api/curriculum/boards`

Get list of all educational boards.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "boards": [
      {
        "id": "uuid",
        "name": "CBSE"
      },
      {
        "id": "uuid",
        "name": "ICSE"
      }
    ]
  }
}
```

### Get Classes for Board
**GET** `/api/curriculum/boards/:boardId/classes`

Get classes available for a specific board.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "board": {
      "id": "uuid",
      "name": "CBSE"
    },
    "classes": [
      {
        "id": "uuid",
        "class_number": 9
      }
    ]
  }
}
```

### Get Subjects for Class
**GET** `/api/curriculum/classes/:classId/subjects`

Get subjects available for a specific class.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "class": {
      "id": "uuid",
      "classNumber": 9,
      "boardName": "CBSE"
    },
    "subjects": [
      {
        "id": "uuid",
        "name": "Physics"
      }
    ]
  }
}
```

### Get Chapters for Subject
**GET** `/api/curriculum/subjects/:subjectId/chapters`

Get chapters available for a specific subject.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "subject": {
      "id": "uuid",
      "name": "Physics",
      "classNumber": 9,
      "boardName": "CBSE"
    },
    "chapters": [
      {
        "id": "uuid",
        "name": "Motion",
        "chapter_number": 1
      }
    ]
  }
}
```

### Get Chapter Details
**GET** `/api/curriculum/chapters/:chapterId`

Get detailed information about a specific chapter.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "chapter": {
      "id": "uuid",
      "name": "Motion",
      "chapterNumber": 1,
      "subjectName": "Physics",
      "classNumber": 9,
      "boardName": "CBSE"
    },
    "content": {
      "video": {
        "id": "uuid",
        "data": {
          "video_url": "https://example.com/video.mp4",
          "duration": 90
        },
        "createdAt": "2024-01-01T00:00:00.000Z"
      },
      "quiz": {
        "id": "uuid",
        "data": {
          "questions": [
            {
              "q": "What is velocity?",
              "options": ["Speed", "Speed with direction", "Distance", "Time"],
              "answer": "Speed with direction"
            }
          ]
        },
        "createdAt": "2024-01-01T00:00:00.000Z"
      }
    }
  }
}
```

### Get User Curriculum
**GET** `/api/curriculum/user-curriculum`

Get curriculum based on user's selected board and class.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "curriculum": {
      "boardName": "CBSE",
      "classNumber": 9,
      "subjects": [
        {
          "id": "uuid",
          "name": "Physics"
        }
      ]
    }
  }
}
```

---

## Content Endpoints

### Get Video Content
**GET** `/api/content/video/:chapterId`

Get or generate video content for a chapter.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "content": {
      "id": "uuid",
      "type": "video",
      "data": {
        "video_url": "https://example.com/video.mp4",
        "duration": 90
      },
      "createdAt": "2024-01-01T00:00:00.000Z"
    },
    "chapter": {
      "id": "uuid",
      "name": "Motion",
      "subjectName": "Physics",
      "classNumber": 9,
      "boardName": "CBSE"
    }
  }
}
```

### Mark Video Completed
**POST** `/api/content/video/:contentId/complete`

Mark a video as completed by the user.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "message": "Video marked as completed",
  "data": {
    "pointsAwarded": 50,
    "totalPoints": 150
  }
}
```

### Get Quiz Content
**GET** `/api/content/quiz/:chapterId`

Get or generate quiz content for a chapter.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "content": {
      "id": "uuid",
      "type": "quiz",
      "data": {
        "questions": [
          {
            "q": "What is velocity?",
            "options": ["Speed", "Speed with direction", "Distance", "Time"],
            "answer": "Speed with direction"
          }
        ]
      },
      "createdAt": "2024-01-01T00:00:00.000Z"
    },
    "chapter": { ... }
  }
}
```

### Submit Quiz Answers
**POST** `/api/content/quiz/:contentId/submit`

Submit quiz answers and get results.

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "answers": ["Speed with direction", "Force", "Mass", "Energy", "Gravity"]
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Quiz submitted successfully",
  "data": {
    "score": 4,
    "totalQuestions": 5,
    "percentage": 80,
    "pointsAwarded": 40,
    "totalPoints": 190,
    "results": [
      {
        "questionIndex": 0,
        "question": "What is velocity?",
        "userAnswer": "Speed with direction",
        "correctAnswer": "Speed with direction",
        "isCorrect": true
      }
    ]
  }
}
```

### Get Content Statistics
**GET** `/api/content/stats`

Get user's content consumption statistics.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "videosWatched": 10,
    "quizzesAttempted": 8,
    "averageQuizScore": 85,
    "totalPoints": 1250,
    "currentStreak": 5,
    "recentActivity": [
      {
        "score": 4,
        "total_questions": 5,
        "subject_name": "Physics",
        "chapter_name": "Motion",
        "attempted_at": "2024-01-01T00:00:00.000Z"
      }
    ]
  }
}
```

---

## Error Responses

### Validation Error (400)
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "field": "email",
      "message": "Please provide a valid email"
    }
  ]
}
```

### Unauthorized (401)
```json
{
  "success": false,
  "message": "Access token required"
}
```

### Not Found (404)
```json
{
  "success": false,
  "message": "Chapter not found"
}
```

### Server Error (500)
```json
{
  "success": false,
  "message": "Internal server error"
}
```

---

## Rate Limiting

- **Limit:** 100 requests per 15 minutes per IP
- **Headers:** Rate limit information included in response headers
- **Exceeded:** Returns 429 status with retry-after header

## Health Check

### Get Server Status
**GET** `/health`

Check server health and status.

**Response (200):**
```json
{
  "status": "OK",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "environment": "development"
}
```
