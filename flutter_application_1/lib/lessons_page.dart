import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

// --- Pasha Bank colors ---
const kPashaGreen = Color(0xFF198754);
const kPashaRed = Color(0xFFDA2032);
const kPashaBackground = Color(0xFFF7F9F9);

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  final List<Map<String, dynamic>> lessons = [
    {
      'title': 'Why Save Money?',
      'video': 'https://www.youtube.com/embed/jnQNZIT3y4U',
      'quiz': {
        'question': 'Why is it good to save money?',
        'options': [
          'To buy things you want',
          'To help parents',
          'For fun only',
          'For no reason',
        ],
        'answer': 0,
      },
    },
    {
      'title': 'What is a Bank?',
      'video': 'https://www.youtube.com/embed/A_f6eoIjzu8',
      'quiz': {
        'question': 'What does a bank do?',
        'options': [
          'Keeps your money safe',
          'Eats your money',
          'Gives toys',
          'Makes cakes',
        ],
        'answer': 0,
      },
    },
  ];

  int currentLesson = 0;
  int? selectedOption;
  bool quizAnswered = false;
  bool quizPassed = false;

  @override
  Widget build(BuildContext context) {
    final lesson = lessons[currentLesson];
    final quiz = lesson['quiz'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lessons"),
        backgroundColor: kPashaGreen,
        foregroundColor: Colors.white,
      ),
      backgroundColor: kPashaBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lesson Title
            Text(
              "Lesson ${currentLesson + 1}: ${lesson['title']}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: kPashaGreen,
              ),
            ),
            const SizedBox(height: 18),

            // Video mockup
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kPashaGreen.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.videocam_rounded,
                    color: Colors.white54,
                    size: 110,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.play_circle_fill,
                    size: 54,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _showVideoDialog(context, lesson['video']);
                  },
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Quiz
            Text(
              "Quiz",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kPashaRed,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 12),
            Text(quiz['question'], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            ...List.generate(
              quiz['options'].length,
              (i) => Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  tileColor: selectedOption == i
                      ? (quizAnswered
                            ? (i == quiz['answer']
                                  ? kPashaGreen.withOpacity(0.18)
                                  : kPashaRed.withOpacity(0.13))
                            : kPashaGreen.withOpacity(0.08))
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    quiz['options'][i],
                    style: TextStyle(
                      color: selectedOption == i
                          ? (quizAnswered
                                ? (i == quiz['answer']
                                      ? kPashaGreen
                                      : kPashaRed)
                                : kPashaGreen)
                          : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: Radio<int>(
                    value: i,
                    groupValue: selectedOption,
                    activeColor: kPashaGreen,
                    onChanged: quizAnswered
                        ? null
                        : (val) => setState(() => selectedOption = val),
                  ),
                  onTap: quizAnswered
                      ? null
                      : () => setState(() => selectedOption = i),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Quiz result area
            if (!quizAnswered)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPashaGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: selectedOption == null
                    ? null
                    : () {
                        setState(() {
                          quizAnswered = true;
                          quizPassed = selectedOption == quiz['answer'];
                        });
                      },
                child: const Text("Check Answer"),
              ),
            if (quizAnswered && quizPassed)
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Congratulations! You got it right.",
                    style: TextStyle(
                      color: kPashaGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPashaRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: const Icon(Icons.celebration),
                    label: const Text("Spin the Reward Wheel!"),
                    onPressed: () {
                      _showWheelDialog(context);
                    },
                  ),
                  const SizedBox(height: 32),
                  if (currentLesson < lessons.length - 1)
                    OutlinedButton(
                      child: const Text("Next Lesson"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kPashaGreen,
                        side: BorderSide(color: kPashaGreen),
                      ),
                      onPressed: () {
                        setState(() {
                          currentLesson++;
                          selectedOption = null;
                          quizAnswered = false;
                          quizPassed = false;
                        });
                      },
                    ),
                ],
              ),
            if (quizAnswered && !quizPassed)
              Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "Oops! Try again.",
                    style: TextStyle(
                      color: kPashaRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        quizAnswered = false;
                        selectedOption = null;
                        quizPassed = false;
                      });
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  void _showVideoDialog(BuildContext context, String videoUrl) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Watch Video"),
        content: SizedBox(
          height: 210,
          child: Center(
            child: Text(
              "Video would play here:\n$videoUrl",
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showWheelDialog(BuildContext context) {
    final rewards = [
      "🌟 5 ₼ Bonus",
      "🎨 Sticker",
      "🛒 Toy Store",
      "🔄 Bonus Spin",
      "🏅 Badge",
      "🎲 Try Again",
    ];

    final StreamController<int> controller = StreamController<int>();
    int selected = Random().nextInt(rewards.length);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Reward Wheel",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: kPashaGreen,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                height: 200,
                child: FortuneWheel(
                  selected: controller.stream,
                  items: [
                    for (var r in rewards)
                      FortuneItem(
                        child: Text(
                          r,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: kPashaGreen,
                          ),
                        ),
                      ),
                  ],
                  animateFirst: false,
                  indicators: const <FortuneIndicator>[
                    FortuneIndicator(
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.arrow_drop_down,
                        size: 40,
                        color: kPashaRed,
                      ),
                    ),
                  ],
                  onAnimationEnd: () {
                    Navigator.of(context).pop();
                    controller.close();
                    _showResultDialog(context, rewards[selected]);
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPashaRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () {
                  controller.add(selected);
                },
                child: const Text("Spin!"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResultDialog(BuildContext context, String reward) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Center(
          child: Text("Congratulations!", style: TextStyle(color: kPashaGreen)),
        ),
        content: Text(
          "You won: $reward",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: kPashaRed,
          ),
        ),
        actions: [
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: kPashaGreen,
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ),
        ],
      ),
    );
  }
}
