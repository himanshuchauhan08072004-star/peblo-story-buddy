import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => StoryQuizProvider(),
      child: const PebloApp(),
    ),
  );
}

class PebloApp extends StatelessWidget {
  const PebloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peblo Story Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8A4FFF)),
        fontFamily: 'ComicSans', // Will default to a soft system font if ComicSans isn't loaded
      ),
      home: const StoryScreen(),
    );
  }
}

// --- STATE MANAGEMENT (Kept exactly the same) ---
class StoryQuizProvider extends ChangeNotifier {
  final FlutterTts flutterTts = FlutterTts();
  final ConfettiController confettiController = ConfettiController(duration: const Duration(seconds: 3));
  
  bool isPlaying = false;
  bool showQuiz = false;
  bool hasError = false;
  bool isSuccess = false;
  bool shakeQuiz = false;

  final String storyText = "Once upon a time, a clever little robot named Pip lost his shiny blue gear in the Whispering Woods...";
  
  final Map<String, dynamic> quizData = {
    "question": "What colour was Pip the Robot's lost gear?",
    "options": ["Red", "Green", "Blue", "Yellow"],
    "answer": "Blue"
  };

  StoryQuizProvider() {
    _initTts();
  }

  void _initTts() {
    flutterTts.setCompletionHandler(() {
      isPlaying = false;
      showQuiz = true;
      notifyListeners();
    });
    flutterTts.setErrorHandler((msg) {
      hasError = true;
      isPlaying = false;
      notifyListeners();
    });
  }

  Future<void> readStory() async {
    hasError = false;
    showQuiz = false;
    isSuccess = false;
    isPlaying = true;
    notifyListeners();
    
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.7); 
    await flutterTts.speak(storyText);
  }

  void checkAnswer(String selectedOption) async {
    if (selectedOption == quizData["answer"]) {
      isSuccess = true;
      confettiController.play();
      notifyListeners();
    } else {
      shakeQuiz = true;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));
      shakeQuiz = false;
      notifyListeners();
    }
  }
}

// --- UPGRADED UI COMPONENTS ---
class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StoryQuizProvider>();

    return Scaffold(
      body: Container(
        // Soft animated gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
          ),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // The Breathing Robot Avatar
                    AnimatedRobot(isReading: provider.isPlaying),
                    const SizedBox(height: 40),
                    
                    // Bouncy Content Area
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        switchInCurve: Curves.elasticOut, // Gives it a fun bounce
                        switchOutCurve: Curves.easeInBack,
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(scale: animation, child: child);
                        },
                        child: provider.showQuiz 
                            ? ShakeWidget(
                                key: const ValueKey("quiz"),
                                shake: provider.shakeQuiz,
                                child: const QuizCard(),
                              )
                            : const StoryCard(key: ValueKey("story")),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Confetti Overlay
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: provider.confettiController,
                blastDirection: pi / 2,
                maxBlastForce: 6,
                minBlastForce: 2,
                emissionFrequency: 0.08,
                numberOfParticles: 25,
                gravity: 0.2,
                colors: const [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom widget to make the robot breathe/pulse while reading
class AnimatedRobot extends StatefulWidget {
  final bool isReading;
  const AnimatedRobot({super.key, required this.isReading});

  @override
  State<AnimatedRobot> createState() => _AnimatedRobotState();
}

class _AnimatedRobotState extends State<AnimatedRobot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void didUpdateWidget(AnimatedRobot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isReading) {
      _controller.repeat(reverse: true);
    } else {
      _controller.animateTo(0.0, duration: const Duration(milliseconds: 300));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Pulses up by 15% when reading
        final scale = 1.0 + (_controller.value * 0.15); 
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.purpleAccent.withValues(alpha: 0.3 + (_controller.value * 0.3)),
                  blurRadius: 20 + (_controller.value * 20),
                  spreadRadius: 5 + (_controller.value * 10),
                )
              ]
            ),
            child: Icon(
              widget.isReading ? Icons.record_voice_over_rounded : Icons.smart_toy_rounded, 
              size: 80, 
              color: widget.isReading ? Colors.deepPurple : Colors.orangeAccent,
            ),
          ),
        );
      },
    );
  }
}

class StoryCard extends StatelessWidget {
  const StoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StoryQuizProvider>();
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
          ),
          child: Text(
            provider.storyText,
            style: const TextStyle(fontSize: 24, color: Colors.black87, height: 1.6, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 50),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 70,
          width: 250,
          child: ElevatedButton.icon(
            onPressed: provider.isPlaying ? null : () => provider.readStory(),
            icon: provider.isPlaying 
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                : const Icon(Icons.play_arrow_rounded, size: 36),
            label: Text(provider.isPlaying ? "Listening..." : "Read Story", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8A4FFF),
              foregroundColor: Colors.white,
              elevation: provider.isPlaying ? 0 : 8,
              shadowColor: const Color(0xFF8A4FFF).withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
            ),
          ),
        ),
      ],
    );
  }
}

class QuizCard extends StatelessWidget {
  const QuizCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StoryQuizProvider>();
    final options = provider.quizData["options"] as List<dynamic>;

    if (provider.isSuccess) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: const Icon(Icons.stars_rounded, size: 140, color: Colors.amber),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text("Awesome Job!", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white, shadows: [Shadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 8)])),
          const SizedBox(height: 50),
          ElevatedButton.icon(
            onPressed: () => provider.readStory(),
            icon: const Icon(Icons.replay_rounded, size: 28),
            label: const Text("Play Again", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 10,
            ),
          )
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            provider.quizData["question"],
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF2D3142)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ...options.map((option) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton(
                    onPressed: () => provider.checkAnswer(option.toString()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF8A4FFF),
                      elevation: 4,
                      shadowColor: Colors.deepPurple.withValues(alpha: 0.2),
                      side: const BorderSide(color: Color(0xFFE0E7FF), width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(option.toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// (Kept exactly the same)
class ShakeWidget extends StatefulWidget {
  final Widget child;
  final bool shake;

  const ShakeWidget({super.key, required this.child, required this.shake});

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 0), weight: 1),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake && !oldWidget.shake) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}