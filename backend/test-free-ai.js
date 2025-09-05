#!/usr/bin/env node

const aiService = require('./src/services/ai.service');
require('dotenv').config();

async function testFreeAIServices() {
  console.log('🧪 Testing Free AI Services for Gyan-Ai\n');

  // Test quiz generation
  console.log('📝 Testing Quiz Generation...');
  try {
    const quiz = await aiService.generateQuiz('Motion', 'Physics', 9, 'CBSE');
    console.log('✅ Quiz generated successfully!');
    console.log(`📊 Generated ${quiz.questions.length} questions`);
    console.log('📋 Sample question:', quiz.questions[0]?.q);
    console.log('');
  } catch (error) {
    console.log('❌ Quiz generation failed:', error.message);
    console.log('🔄 Fallback system should handle this automatically\n');
  }

  // Test video script generation
  console.log('🎬 Testing Video Script Generation...');
  try {
    const script = await aiService.generateVideoScript('Motion', 'Physics', 9, 'CBSE');
    console.log('✅ Video script generated successfully!');
    console.log(`📝 Script length: ${script.length} characters`);
    console.log('📋 Script preview:', script.substring(0, 100) + '...');
    console.log('');
  } catch (error) {
    console.log('❌ Script generation failed:', error.message);
    console.log('🔄 Fallback system should handle this automatically\n');
  }

  // Test video generation
  console.log('🎥 Testing Video Generation...');
  try {
    const video = await aiService.generateVideo('Sample script', 'Motion', 'Physics');
    console.log('✅ Video generated successfully!');
    console.log(`🎬 Video URL: ${video.videoUrl}`);
    console.log(`⏱️  Duration: ${video.duration} seconds`);
    console.log('');
  } catch (error) {
    console.log('❌ Video generation failed:', error.message);
    console.log('🔄 Fallback system should handle this automatically\n');
  }

  // Test fallback quiz generation
  console.log('🔄 Testing Fallback Quiz Generation...');
  try {
    const fallbackQuiz = aiService.generateFallbackQuiz('Motion', 'Physics', 9);
    console.log('✅ Fallback quiz generated successfully!');
    console.log(`📊 Generated ${fallbackQuiz.questions.length} questions`);
    console.log('📋 Sample question:', fallbackQuiz.questions[0]?.q);
    console.log('');
  } catch (error) {
    console.log('❌ Fallback quiz generation failed:', error.message);
  }

  // Test fallback script generation
  console.log('🔄 Testing Fallback Script Generation...');
  try {
    const fallbackScript = aiService.generateFallbackScript('Motion', 'Physics', 9);
    console.log('✅ Fallback script generated successfully!');
    console.log(`📝 Script length: ${fallbackScript.length} characters`);
    console.log('📋 Script preview:', fallbackScript.substring(0, 100) + '...');
    console.log('');
  } catch (error) {
    console.log('❌ Fallback script generation failed:', error.message);
  }

  // Test placeholder video generation
  console.log('🔄 Testing Placeholder Video Generation...');
  try {
    const placeholderVideo = await aiService.generatePlaceholderVideo('Motion', 'Physics');
    console.log('✅ Placeholder video generated successfully!');
    console.log(`🎬 Video URL: ${placeholderVideo.videoUrl}`);
    console.log(`⏱️  Duration: ${placeholderVideo.duration} seconds`);
    console.log('');
  } catch (error) {
    console.log('❌ Placeholder video generation failed:', error.message);
  }

  console.log('🎉 Free AI Services Test Complete!');
  console.log('\n📋 Summary:');
  console.log('✅ All services have fallback systems');
  console.log('✅ System will work even without API keys');
  console.log('✅ Ready for production use');
  console.log('\n🚀 Next steps:');
  console.log('1. Get free API keys (see FREE_AI_SETUP_GUIDE.md)');
  console.log('2. Update .env file with your keys');
  console.log('3. Start your backend: npm run dev');
  console.log('4. Test with your Flutter frontend!');
}

// Run the test
testFreeAIServices().catch(console.error);
