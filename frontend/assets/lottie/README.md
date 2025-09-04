# Lottie Animations Directory

This directory should contain Lottie animation files for enhanced user experience:

## Recommended Animations

### Loading States
- `loading_spinner.json` - Custom loading animation
- `video_loading.json` - Video generation loading
- `quiz_loading.json` - Quiz generation loading

### Success States
- `success_checkmark.json` - Success completion animation
- `points_earned.json` - Points earned celebration
- `level_up.json` - Level up or achievement animation

### Empty States
- `empty_subjects.json` - No subjects available
- `empty_chapters.json` - No chapters available
- `no_internet.json` - No internet connection

### Onboarding
- `welcome_animation.json` - Welcome screen animation
- `curriculum_selection.json` - Curriculum selection animation

## Download Sources

1. **LottieFiles** - https://lottiefiles.com/
2. **After Effects** - Create custom animations
3. **Figma Plugins** - Lottie export plugins

## Integration

Use with the `lottie` package:

```dart
import 'package:lottie/lottie.dart';

Lottie.asset('assets/lottie/loading_spinner.json')
```

## Guidelines

- Keep animations under 500KB when possible
- Use simple animations for better performance
- Test on lower-end devices
- Provide fallback static images if needed

## Current Status

The app currently uses basic Flutter animations and Material loading indicators. Lottie animations can be added for enhanced UX.
