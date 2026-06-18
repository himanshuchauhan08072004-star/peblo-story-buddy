# Peblo Story Buddy

An interactive, kid-friendly storytelling and quiz application built for the Peblo technical challenge.

## Technical Choices & Architecture

### Framework Selection
**Which framework did you choose and why?**
I chose Flutter. It allows for rapid UI development, creates smooth ~60fps animations easily, and provides a robust ecosystem for Text-to-Speech (TTS) and state management. Its cross-platform nature also means this single codebase can deploy seamlessly to Web, iOS, and Android.

### State Management & Transitions
**How did you manage the transition state between audio ending and the quiz appearing?**
I used Provider (ChangeNotifier) to handle state cleanly outside the UI. I attached a .setCompletionHandler() to the FlutterTts instance. The moment the audio finishes, the handler flips a showQuiz boolean from false to true and calls notifyListeners(). The UI listens to this change and uses an AnimatedSwitcher to seamlessly transition from the story card to the quiz card with a playful bounce effect.

### Data-Driven UI
**How did you build the quiz to be data-driven?**
The quiz UI is not hardcoded. The data is structured as a Map (JSON-like format) containing the question string, an array of options, and the correct answer. The UI uses the .map() function to iterate over the options array. This ensures the UI dynamically scales and renders the exact number of buttons needed, whether the data passes 2, 3, or 4+ options.

### Audio Handling & Caching
**How did you handle audio loading and failure states?**
I managed audio states using isPlaying and hasError booleans within the Provider. When the read button is pressed, it shows a "Listening..." loading state to prevent multiple rapid presses. I also implemented flutterTts.setErrorHandler(), which flips the hasError flag if the engine fails, allowing the UI to react safely without crashing. 

**Your caching approach (and how you'd cache remote audio if applicable):**
Because I utilized local Text-to-Speech generation, the audio is synthesized on the fly, eliminating the need to download large audio payloads. However, if I were pulling pre-recorded MP3s from a remote server, I would use the path_provider and a caching package to download the file to the device's local temporary directory upon the first request. Subsequent plays would check local storage first, completely bypassing network latency and saving bandwidth.

### Performance & Optimization
**How did you optimize to stay lightweight on mid-range Android devices?**
* Shallow Widget Tree: Kept the UI hierarchy as flat as possible to reduce layout calculation times.
* No Heavy Assets: Instead of large image files, the UI relies heavily on built-in vector icons, code-based gradients, and Container decorations to keep the app size minimal and memory footprint low.
* Targeted Rebuilds: Used context.watch and specific AnimatedBuilder controllers so that animations (like the breathing robot or shaking card) only repaint their specific widget nodes, rather than rebuilding the entire screen.

### AI Usage & Judgment
**Where did you use AI assistance?**
I used an AI assistant as a pair-programmer to help troubleshoot local environment errors, navigate OneDrive file-locking issues, and refactor the UI layout for a more polished, kid-friendly look.

**What did you try that didn't work, and how did you resolve it?**
Initially, I tried building a native Windows desktop app, but ran into severe file-locking issues caused by OneDrive syncing the build folders (ios, macos, and .dart_tool). The Flutter compiler kept crashing because it couldn't clean these locked directories. I resolved this by migrating the entire workspace to a clean C:\src directory outside of OneDrive, manually trashing the locked folders, and pivoting the target environment to Web (Microsoft Edge) to bypass missing Visual Studio toolchains and guarantee successful delivery.

**Name one suggestion it gave that you rejected or changed, and why.**
While styling the "Awesome Job" celebration screen, the AI suggested wrapping a TweenAnimationBuilder with a const modifier to improve performance. I had to reject and change this because animations inherently rely on dynamic runtime values (variables changing over time). Applying const to a scaling animation caused a direct compile error. I removed the const tag so the compiler could evaluate the scale dynamically frame-by-frame.
