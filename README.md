Peblo Story Buddy

An interactive, kid-friendly storytelling and quiz application built for the Peblo technical challenge — redesigned into a story discovery platform with selectable AI narrators, animated scene reading, a retry-friendly quiz, and a local progress/badges system.

LIVE :- https://peblo-web-demo.vercel.app/

Technical Choices & Architecture
Framework Selection

Which framework did you choose and why? I chose Flutter. It allows for rapid UI development, creates smooth ~60fps animations easily, and provides a robust ecosystem for Text-to-Speech (TTS) and state management. Its cross-platform nature also means this single codebase can deploy seamlessly to Web, iOS, and Android.

Project Structure

The app is split into clear responsibility layers instead of one flat file:

lib/
  models/      Story, StoryScene, QuizQuestion, StoryVoice
  data/        story_catalog.dart, voice_catalog.dart — the content
  services/    TtsService, VoiceService, StorageService
  providers/   StoryProvider, VoiceProvider, ProgressProvider, ThemeProvider
  screens/     home, story_reader, voice_selection, quiz, completion, progress
  widgets/     story_card, narrator_card, character_avatar, audio_controls,
               animated_background, quiz_option, celebration_view, common

Adding a new story or narrator means adding one entry to story_catalog.dart / voice_catalog.dart — no screen code changes needed.

State Management & Transitions

How did you manage the transition state between audio ending and the quiz appearing? StoryProvider (a ChangeNotifier) owns a ReaderStage enum — scenes, quiz, complete. I attach onComplete on the shared TtsService; when a scene finishes narrating, the handler either advances to the next scene (auto-continuing narration) or, on the last scene, flips the stage to quiz and calls notifyListeners(). The reader screen switches its body with a Dart 3 switch expression over that stage, so story → quiz → completion all live in one provider-driven flow instead of separate navigation pushes.

Data-Driven UI

How did you build the quiz to be data-driven? QuizQuestion is a plain model (prompt, options, answerIndex, explanation, optional hint/emojis) and Story.quiz is a List<QuizQuestion>. The quiz screen uses List.generate(question.options.length, ...) to render answer cards, so it scales to however many options a question has. Scenes work the same way — Story.scenes is a list the reader iterates, so story length and pacing come entirely from data in story_catalog.dart.

Narrator / Voice System

How did you implement the 6 narrator personalities without faking voice switching? StoryVoice is an abstraction over a real device voice: name, personality label, pitch, rate, and locale/gender hints used for matching. At startup, VoiceService.discover() calls flutterTts.getVoices() and intelligently maps each of the 6 personalities to an actual available platform voice (locale + gender-hint matching first, then any unused voice, then safe reuse as a last resort) — it never claims a distinct voice that isn't there. Each narrator still gets its own pitch/rate even when the platform only exposes one engine voice, so personalities stay audibly distinct. If voice querying returns nothing, the UI shows a small non-intrusive fallback notice instead of pretending otherwise.

Audio Handling & Failure States

How did you handle audio loading and failure states? TtsService wraps FlutterTts and normalizes its start/complete/cancel/error handlers into simple callbacks the rest of the app consumes — no raw plugin calls outside this one file. StoryProvider tracks isPlaying/isPaused to drive the play/pause button and block overlapping speech requests. setErrorHandler sets a friendly fallback message ("Narration hit a snag — you can still read along.") rather than crashing, so a TTS failure never blocks the story or quiz from being used.

One real bug this caught during integration: narrator preview (in the voice picker) and story narration share the same TtsService instance, so the preview's completion handler was overwriting the reader's scene-advance handler. Fixed by having VoiceProvider.preview() save and restore whatever handler was already wired up, so previewing a narrator mid-story never breaks narration.

Caching approach: Audio is synthesized on-device via TTS, so there's no remote payload to cache. If I were instead pulling pre-recorded MP3s from a server, I'd use path_provider plus a caching package to persist each file to local temp storage on first request, and check local storage before any subsequent network call.

Performance & Optimization

How did you optimize to stay lightweight?

No image assets for characters or environments — CharacterAvatar and AnimatedBackground are CustomPaint/emoji-based, so personality and atmosphere come from code, not downloads.
Targeted rebuilds — narration playback, the character's breathing/talking animation, and background particles each use their own AnimationController/AnimatedBuilder, so they repaint only their own widget instead of the whole screen.
Local persistence (shared_preferences) is read once into each provider at startup rather than queried per-frame.
Progress & Replayability

Completed stories, selected narrator, speed, theme, and listening/quiz stats persist locally via StorageService (shared_preferences) — no backend needed. ProgressProvider derives five badges (First Story, Story Explorer, Great Listener, Story Detective, Adventure Master) from those same counters, shown on the "My Progress" tab.

AI Usage & Judgment

Where did you use AI assistance? I used an AI assistant as a pair-programmer for the full redesign pass: restructuring the single-file prototype into the layered architecture above, writing the voice-mapping logic, and troubleshooting the local Windows/PowerShell environment (Flutter not on PATH, missing platform folders, stale analyzer errors) to get a clean build.

What did you try that didn't work, and how did you resolve it? The first flutter analyze after integrating the new code threw an undefined_identifier on CharacterPose in the completion screen — a missing import from splitting the old single-file prototype into separate model/screen files. Fixed by importing models/story.dart there. The default test/widget_test.dart left over from the original scaffold also failed to compile, since it referenced a class name (MyApp) that no longer exists post-redesign; I removed it rather than rewrite a placeholder test around it.

Name one suggestion you rejected or changed, and why. The AI's first draft of narrator preview reused the TTS engine's onComplete callback directly without saving the previous one. I rejected that because it silently broke story narration the moment someone previewed a voice mid-story — any handler already attached (the scene auto-advance logic) would be wiped out. I had it save and restore the prior handler instead, so preview and narration can't clobber each othe