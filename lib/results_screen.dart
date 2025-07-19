import 'package:flutter/material.dart';

import 'package:quiz_app/data/questions.dart';

class ResultsScreen extends StatelessWidget {
  final VoidCallback onRestart;
  final List<String> userAnswers;

  const ResultsScreen({
    super.key,
    required this.onRestart,
    required this.userAnswers,
  });

  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];
    for (var i = 0; i < questions.length; i++) {
      summary.add({
        'question_index': i,
        'question': questions[i].text,
        'correct_answer': questions[i].answers[0],
        'user_answer': userAnswers.length > i ? userAnswers[i] : '',
      });
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final summaryData = getSummaryData();
    final numTotalQuestions = summaryData.length;
    final numCorrectAnswers = summaryData
        .where((data) => data['user_answer'] == data['correct_answer'])
        .length;

    return Center(
      child: SingleChildScrollView(
        child: Card(
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [Colors.purple, Colors.pinkAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Quiz Completed!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'You answered $numCorrectAnswers out of $numTotalQuestions questions correctly!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Your Answers',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.purple[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: summaryData.length,
                        separatorBuilder: (_, __) => const Divider(height: 18),
                        itemBuilder: (ctx, i) {
                          final data = summaryData[i];
                          final isCorrect =
                              data['user_answer'] == data['correct_answer'];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isCorrect
                                  ? Colors.green
                                  : Colors.red,
                              child: Text(
                                '${(data['question_index'] as int) + 1}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              data['question'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your answer: ${data['user_answer']}',
                                  style: TextStyle(
                                    color: isCorrect
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (!isCorrect)
                                  Text(
                                    'Correct answer: ${data['correct_answer']}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onRestart,
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Restart Quiz'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
