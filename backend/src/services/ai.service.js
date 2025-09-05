const axios = require('axios');
require('dotenv').config();

class AIService {
  constructor() {
    // Free AI services configuration
    this.huggingFaceApiKey = process.env.HUGGINGFACE_API_KEY || 'hf_your_token_here';
    this.groqApiKey = process.env.GROQ_API_KEY || 'gsk_your_key_here';
    this.runwayApiKey = process.env.RUNWAY_API_KEY || 'your_runway_key';
    
    // API endpoints
    this.huggingFaceBaseUrl = 'https://api-inference.huggingface.co/models';
    this.groqBaseUrl = 'https://api.groq.com/openai/v1';
    this.runwayBaseUrl = 'https://api.runwayml.com/v1';
    
    // Model configurations
    this.quizModel = 'microsoft/DialoGPT-medium'; // Free model for quiz generation
    this.videoModel = 'stabilityai/stable-video-diffusion'; // Free video model
  }

  // Generate quiz questions using Groq (Free tier: 14,400 requests/day)
  async generateQuiz(chapterName, subjectName, classNumber, boardName) {
    try {
      const prompt = `Generate 5 multiple-choice questions for a ${classNumber}th grade ${boardName} student studying ${subjectName} - Chapter: ${chapterName}.

Each question should have:
- A clear, educational question
- 4 answer options (A, B, C, D)
- One correct answer
- Questions should test understanding of key concepts

Return the response as a JSON object with this exact structure:
{
  "questions": [
    {
      "q": "Question text here",
      "options": ["Option A", "Option B", "Option C", "Option D"],
      "answer": "Correct option text"
    }
  ]
}

Make sure the questions are appropriate for ${classNumber}th grade level and cover the main topics of ${chapterName} in ${subjectName}.`;

      const response = await axios.post(
        `${this.groqBaseUrl}/chat/completions`,
        {
          model: 'llama-3.1-8b-instant', // Free model on Groq
          messages: [
            {
              role: 'user',
              content: prompt
            }
          ],
          max_tokens: 2000,
          temperature: 0.7
        },
        {
          headers: {
            'Authorization': `Bearer ${this.groqApiKey}`,
            'Content-Type': 'application/json'
          }
        }
      );

      const content = response.data.choices[0].message.content;
      
      // Try to parse JSON from the response
      let quizData;
      try {
        // Extract JSON from the response (in case it's wrapped in markdown)
        const jsonMatch = content.match(/\{[\s\S]*\}/);
        if (jsonMatch) {
          quizData = JSON.parse(jsonMatch[0]);
        } else {
          quizData = JSON.parse(content);
        }
      } catch (parseError) {
        console.error('Failed to parse quiz JSON:', parseError);
        // Fallback: Generate a simple quiz structure
        quizData = this.generateFallbackQuiz(chapterName, subjectName, classNumber);
      }

      // Validate the structure
      if (!quizData.questions || !Array.isArray(quizData.questions)) {
        quizData = this.generateFallbackQuiz(chapterName, subjectName, classNumber);
      }

      return quizData;
    } catch (error) {
      console.error('Quiz generation error:', error);
      // Fallback to local quiz generation
      return this.generateFallbackQuiz(chapterName, subjectName, classNumber);
    }
  }

  // Fallback quiz generation (100% free, no API required)
  generateFallbackQuiz(chapterName, subjectName, classNumber) {
    const fallbackQuestions = {
      'Motion': [
        {
          q: `What is the definition of motion in ${subjectName}?`,
          options: [
            "Change in position over time",
            "Speed of an object",
            "Force applied to an object",
            "Distance traveled"
          ],
          answer: "Change in position over time"
        },
        {
          q: `What is velocity?`,
          options: [
            "Speed of an object",
            "Speed with direction",
            "Distance traveled",
            "Time taken"
          ],
          answer: "Speed with direction"
        },
        {
          q: `What is acceleration?`,
          options: [
            "Speed of an object",
            "Change in velocity over time",
            "Distance traveled",
            "Force applied"
          ],
          answer: "Change in velocity over time"
        },
        {
          q: `What is the unit of velocity?`,
          options: [
            "m/s²",
            "m/s",
            "kg",
            "N"
          ],
          answer: "m/s"
        },
        {
          q: `What is uniform motion?`,
          options: [
            "Motion with changing speed",
            "Motion with constant speed",
            "Motion with acceleration",
            "Motion at rest"
          ],
          answer: "Motion with constant speed"
        }
      ],
      'Force and Laws of Motion': [
        {
          q: `What is Newton's First Law of Motion?`,
          options: [
            "F = ma",
            "Every action has an equal and opposite reaction",
            "An object at rest stays at rest unless acted upon",
            "Force equals mass times acceleration"
          ],
          answer: "An object at rest stays at rest unless acted upon"
        },
        {
          q: `What is the formula for force?`,
          options: [
            "F = mv",
            "F = ma",
            "F = m/a",
            "F = v/t"
          ],
          answer: "F = ma"
        },
        {
          q: `What is inertia?`,
          options: [
            "Force applied to an object",
            "Resistance to change in motion",
            "Speed of an object",
            "Mass of an object"
          ],
          answer: "Resistance to change in motion"
        },
        {
          q: `What is the unit of force?`,
          options: [
            "kg",
            "m/s",
            "N (Newton)",
            "J"
          ],
          answer: "N (Newton)"
        },
        {
          q: `What is Newton's Third Law?`,
          options: [
            "F = ma",
            "Every action has an equal and opposite reaction",
            "An object at rest stays at rest",
            "Force equals mass times acceleration"
          ],
          answer: "Every action has an equal and opposite reaction"
        }
      ]
    };

    // Return questions for the specific chapter, or default questions
    const questions = fallbackQuestions[chapterName] || [
      {
        q: `What is the main topic of ${chapterName} in ${subjectName}?`,
        options: [
          "A fundamental concept",
          "An advanced topic",
          "A simple idea",
          "A complex theory"
        ],
        answer: "A fundamental concept"
      },
      {
        q: `Which grade level is this chapter appropriate for?`,
        options: [
          "Primary school",
          `Grade ${classNumber}`,
          "High school",
          "College"
        ],
        answer: `Grade ${classNumber}`
      },
      {
        q: `What subject does this chapter belong to?`,
        options: [
          "Mathematics",
          subjectName,
          "Science",
          "English"
        ],
        answer: subjectName
      },
      {
        q: `What is the purpose of studying ${chapterName}?`,
        options: [
          "To understand basic concepts",
          "To learn advanced topics",
          "To memorize facts",
          "To solve complex problems"
        ],
        answer: "To understand basic concepts"
      },
      {
        q: `How important is ${chapterName} for ${classNumber}th grade students?`,
        options: [
          "Very important",
          "Somewhat important",
          "Not important",
          "Optional"
        ],
        answer: "Very important"
      }
    ];

    return { questions };
  }

  // Generate video script using Groq (Free tier)
  async generateVideoScript(chapterName, subjectName, classNumber, boardName) {
    try {
      const prompt = `Create a concise, educational script for a 90-second animated video explaining ${chapterName} from ${subjectName} for a ${classNumber}th grade ${boardName} student.

The script should:
- Be engaging and age-appropriate
- Cover the main concepts clearly
- Use simple, understandable language
- Include key points and examples
- Be structured for visual presentation
- Be exactly 90 seconds when spoken at normal pace

Format the response as a clear, well-structured script that can be used for video generation.`;

      const response = await axios.post(
        `${this.groqBaseUrl}/chat/completions`,
        {
          model: 'llama-3.1-8b-instant',
          messages: [
            {
              role: 'user',
              content: prompt
            }
          ],
          max_tokens: 1500,
          temperature: 0.7
        },
        {
          headers: {
            'Authorization': `Bearer ${this.groqApiKey}`,
            'Content-Type': 'application/json'
          }
        }
      );

      return response.data.choices[0].message.content;
    } catch (error) {
      console.error('Script generation error:', error);
      // Fallback to local script generation
      return this.generateFallbackScript(chapterName, subjectName, classNumber);
    }
  }

  // Fallback script generation (100% free)
  generateFallbackScript(chapterName, subjectName, classNumber) {
    const fallbackScripts = {
      'Motion': `Welcome to our lesson on Motion! 

Motion is when something changes its position over time. Imagine you're walking to school - you're in motion!

There are different types of motion:
- Linear motion: moving in a straight line
- Circular motion: moving in a circle
- Random motion: moving in no particular pattern

Speed tells us how fast something is moving. If you run faster than you walk, you have more speed!

Velocity is speed with direction. If you're running north at 5 meters per second, that's your velocity.

Acceleration is when your speed changes. When you start running, you accelerate!

Remember: Motion is all around us - from cars on the road to planets in space. Understanding motion helps us understand how our world works!`,

      'Force and Laws of Motion': `Let's learn about Force and Laws of Motion!

Force is a push or pull that can make things move, stop, or change direction. When you kick a ball, you're applying force!

Newton's First Law says: Objects at rest stay at rest, and objects in motion stay in motion, unless acted upon by a force.

This is called inertia - the tendency to resist change. A heavy box is hard to push because it has more inertia!

Newton's Second Law: Force equals mass times acceleration (F = ma). The more force you apply, the more acceleration you get!

Newton's Third Law: For every action, there's an equal and opposite reaction. When you jump, you push down on the ground, and the ground pushes back up!

Forces are everywhere - gravity pulls us down, friction slows us down, and our muscles push and pull to help us move!`
    };

    return fallbackScripts[chapterName] || `Welcome to our lesson on ${chapterName}!

Today we'll learn about ${chapterName} in ${subjectName}. This is an important topic for ${classNumber}th grade students.

Key concepts we'll cover:
- Basic definitions and terms
- Important principles and laws
- Real-world examples and applications
- How this relates to your daily life

${chapterName} is fundamental to understanding ${subjectName}. By the end of this lesson, you'll have a clear understanding of these concepts.

Let's start exploring ${chapterName} together!`;
  }

  // Generate video using RunwayML (Free tier: 125 seconds/month)
  async generateVideo(script, chapterName, subjectName) {
    try {
      const response = await axios.post(
        `${this.runwayBaseUrl}/generate`,
        {
          prompt: `Educational animated video about ${chapterName} in ${subjectName}. ${script}`,
          duration: 90,
          aspect_ratio: '16:9',
          style: 'educational',
          quality: 'high'
        },
        {
          headers: {
            'Authorization': `Bearer ${this.runwayApiKey}`,
            'Content-Type': 'application/json'
          }
        }
      );

      // Poll for completion
      const taskId = response.data.id;
      let attempts = 0;
      const maxAttempts = 30; // 5 minutes max

      while (attempts < maxAttempts) {
        await new Promise(resolve => setTimeout(resolve, 10000)); // Wait 10 seconds
        
        const statusResponse = await axios.get(
          `${this.runwayBaseUrl}/generate/${taskId}`,
          {
            headers: {
              'Authorization': `Bearer ${this.runwayApiKey}`
            }
          }
        );

        if (statusResponse.data.status === 'completed') {
          return {
            videoUrl: statusResponse.data.video_url,
            duration: 90
          };
        }

        if (statusResponse.data.status === 'failed') {
          throw new Error('Video generation failed');
        }

        attempts++;
      }

      throw new Error('Video generation timeout');
    } catch (error) {
      console.error('Video generation error:', error);
      // Fallback to placeholder video
      return this.generatePlaceholderVideo(chapterName, subjectName);
    }
  }

  // Fallback: Generate a placeholder video URL for development
  async generatePlaceholderVideo(chapterName, subjectName) {
    // For development/testing purposes - use free educational videos
    const placeholderVideos = {
      'Motion': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      'Force and Laws of Motion': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'Gravitation': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
      'Work and Energy': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'Sound': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_5mb.mp4'
    };

    return {
      videoUrl: placeholderVideos[chapterName] || 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      duration: 90
    };
  }

  // Alternative: Use Hugging Face for quiz generation (Free tier: 30,000 requests/month)
  async generateQuizWithHuggingFace(chapterName, subjectName, classNumber, boardName) {
    try {
      const prompt = `Generate 5 multiple-choice questions for ${chapterName} in ${subjectName} for grade ${classNumber} students. Return as JSON with questions array.`;

      const response = await axios.post(
        `${this.huggingFaceBaseUrl}/${this.quizModel}`,
        {
          inputs: prompt,
          parameters: {
            max_length: 1000,
            temperature: 0.7
          }
        },
        {
          headers: {
            'Authorization': `Bearer ${this.huggingFaceApiKey}`,
            'Content-Type': 'application/json'
          }
        }
      );

      // Process the response and extract quiz data
      const content = response.data[0].generated_text;
      // Parse and return quiz data
      return this.parseQuizResponse(content, chapterName, subjectName, classNumber);
    } catch (error) {
      console.error('Hugging Face quiz generation error:', error);
      return this.generateFallbackQuiz(chapterName, subjectName, classNumber);
    }
  }

  parseQuizResponse(content, chapterName, subjectName, classNumber) {
    // Simple parsing logic for Hugging Face response
    // This would need to be customized based on the actual model output
    return this.generateFallbackQuiz(chapterName, subjectName, classNumber);
  }
}

module.exports = new AIService();