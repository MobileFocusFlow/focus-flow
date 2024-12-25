import 'package:flutter/material.dart';

class QuoteManager {
  static final Map<String, List<String>> _quotes = {
    "en": [
      "The secret of getting ahead is getting started.",
      "You don’t have to be great to start, but you have to start to be great.",
      "Don’t watch the clock; do what it does. Keep going.",
      "Success is the sum of small efforts, repeated day in and day out.",
      "Believe you can and you're halfway there.",
      "The harder you work for something, the greater you'll feel when you achieve it.",
      "Dream bigger. Do bigger.",
      "Don’t stop when you’re tired. Stop when you’re done.",
      "Do something today that your future self will thank you for.",
      "Little things make big days.",
      "It’s going to be hard, but hard does not mean impossible.",
      "Don’t wait for opportunity. Create it.",
      "Sometimes we’re tested not to show our weaknesses, but to discover our strengths.",
      "The key to success is to focus on goals, not obstacles.",
      "Dream it. Wish it. Do it.",
      "Great things never come from comfort zones.",
      "Success doesn’t just find you. You have to go out and get it.",
      "Keep your eyes on the stars, and your feet on the ground.",
      "You are capable of amazing things.",
      "The best way to get started is to quit talking and begin doing.",
    ],
    "tr": [
      "İlerlemenin sırrı başlamaktır.",
      "Başlamak için harika olmak zorunda değilsiniz, ama harika olmak için başlamak zorundasınız.",
      "Saati izlemeyin; ne yapıyorsa onu yapın. Devam edin.",
      "Başarı, her gün tekrarlanan küçük çabaların toplamıdır.",
      "Yapabileceğinize inanın ve yolu yarılayın.",
      "Bir şey için ne kadar çok çalışırsanız, başardığınızda o kadar büyük hissedersiniz.",
      "Daha büyük hayal edin. Daha büyüğünü yap.",
      "Yorulduğunuzda durmayın. İşiniz bittiğinde durun.",
      "Bugün, gelecekteki benliğinizin size teşekkür edeceği bir şey yapın.",
      "Küçük şeyler büyük günler yaratır.",
      "Zor olacak, ama zor imkansız demek değildir.",
      "Fırsat beklemeyin. Yaratın.",
      "Bazen zayıflıklarımızı göstermek için değil, güçlü yönlerimizi keşfetmek için sınanırız.",
      "Başarının anahtarı engellere değil, hedeflere odaklanmaktır.",
      "Hayal edin. Dileyin. Yap.",
      "Büyük şeyler asla konfor alanlarından gelmez.",
      "Başarı sizi öylece bulmaz. Dışarı çıkmalı ve onu almalısınız.",
      "Gözlerinizi yıldızlardan ayırmayın, ayaklarınız yere bassın.",
      "İnanılmaz şeyler yapabilirsin.",
      "Başlamanın en iyi yolu konuşmayı bırakıp yapmaya başlamaktır.",
    ]
  };

  static String getRandomQuote(String key) {
    _quotes[key]!.shuffle();
    return _quotes[key]!.first;
  }

  static Stack addQuoteContainer(motivationalQuote, context, changeQuote) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '"$motivationalQuote"',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: changeQuote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
