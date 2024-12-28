import 'package:flutter/material.dart';
import 'package:focusflow/main.dart';

import 'components/language_select.dart';

class GuidelineScreen extends StatelessWidget {
  final List<Map<String, Map<String, String>>> techniques = [
    {
      'en': {
        'title': 'Pomodoro Technique',
        'description':
            'The Pomodoro Technique is a time management method that helps improve productivity by breaking work into 25-minute intervals, called "pomodoros", followed by a 5-minute break. This process is repeated, and after four pomodoros, a longer break of 15 to 30 minutes is taken. This technique not only helps manage time effectively but also reduces burnout and enhances focus by ensuring regular breaks. It is ideal for tasks that require sustained concentration, such as studying, writing, or coding.',
      },
      'tr': {
        'title': 'Pomodoro Tekniği',
        'description':
            'Pomodoro Tekniği, işi 25 dakikalık aralıklara bölen bir zaman yönetimi yöntemidir. Her 25 dakikalık çalışmadan sonra 5 dakikalık kısa bir mola verilir. Dört pomodoro tamamlandığında ise 15-30 dakikalık daha uzun bir mola alınır. Bu teknik, zamanı etkili bir şekilde yönetmeye yardımcı olmakla kalmaz, aynı zamanda düzenli molalar sayesinde tükenmişliği azaltır ve odaklanmayı artırır. Özellikle uzun süreli dikkat gerektiren görevler için idealdir, örneğin ders çalışmak, yazı yazmak veya kod yazmak.',
      },
      'fr': {
        'title': 'Technique Pomodoro',
        'description':
            'La Technique Pomodoro est une méthode de gestion du temps qui améliore la productivité en divisant le travail en intervalles de 25 minutes appelés "pomodoros", suivis d\'une pause de 5 minutes. Ce processus est répété, et après quatre pomodoros, une pause plus longue de 15 à 30 minutes est prise. Cette technique aide non seulement à gérer le temps efficacement, mais elle réduit aussi le burnout et améliore la concentration en assurant des pauses régulières. Elle est idéale pour les tâches nécessitant une concentration soutenue, comme l\'étude, l\'écriture ou la programmation.',
      },
      'de': {
        'title': 'Pomodoro-Technik',
        'description':
            'Die Pomodoro-Technik ist eine Zeitmanagementmethode, die die Arbeit in 25-minütige Intervalle, sogenannte "Pomodoros", unterteilt, gefolgt von einer 5-minütigen Pause. Dieser Prozess wird wiederholt, und nach vier Pomodoros wird eine längere Pause von 15 bis 30 Minuten eingelegt. Diese Technik hilft nicht nur, die Zeit effektiv zu verwalten, sondern reduziert auch das Burnout-Risiko und fördert die Konzentration durch regelmäßige Pausen. Sie eignet sich besonders gut für Aufgaben, die eine anhaltende Konzentration erfordern, wie Lernen, Schreiben oder Programmieren.',
      },
      'es': {
        'title': 'Técnica Pomodoro',
        'description':
            'La Técnica Pomodoro es un método de gestión del tiempo que mejora la productividad al dividir el trabajo en intervalos de 25 minutos, llamados "pomodoros", seguidos de una pausa de 5 minutos. Este proceso se repite, y después de cuatro pomodoros, se toma un descanso más largo de 15 a 30 minutos. Esta técnica no solo ayuda a gestionar el tiempo de manera eficaz, sino que también reduce el agotamiento y mejora la concentración mediante descansos regulares. Es ideal para tareas que requieren concentración sostenida, como estudiar, escribir o programar.',
      },
    },
    {
      'en': {
        'title': 'Time Blocking',
        'description':
            'Time blocking is a time management method where you allocate specific blocks of time to specific tasks or activities. By scheduling dedicated time for each task, you can reduce distractions and multitasking, making it easier to stay focused and accomplish your goals. This technique helps you ensure that enough time is spent on important tasks, and it can be particularly useful for people with busy schedules who need to prioritize different activities throughout the day.',
      },
      'tr': {
        'title': 'Zaman Bloklama',
        'description':
            'Zaman bloklama, belirli görevler veya aktiviteler için belirli zaman dilimlerini ayırdığınız bir zaman yönetimi yöntemidir. Her görev için ayrılmış zaman planlayarak, dikkati dağılmayı ve çoklu görev yapmayı azaltabilirsiniz, bu da odaklanmanızı artırır ve hedeflerinizi başarmanızı kolaylaştırır. Bu teknik, önemli görevlere yeterli zaman ayırmanızı sağlamaya yardımcı olur ve gün boyunca farklı aktiviteleri önceliklendirmesi gereken yoğun programlara sahip kişiler için özellikle faydalıdır.',
      },
      'fr': {
        'title': 'Gestion du Temps par Blocs',
        'description':
            'La gestion du temps par blocs est une méthode de gestion du temps où vous allouez des blocs de temps spécifiques à des tâches ou activités spécifiques. En programmant du temps dédié à chaque tâche, vous pouvez réduire les distractions et le multitâche, ce qui rend plus facile de rester concentré et d\'atteindre vos objectifs. Cette technique vous aide à vous assurer que vous passez suffisamment de temps sur les tâches importantes et peut être particulièrement utile pour les personnes ayant un emploi du temps chargé qui doivent prioriser différentes activités tout au long de la journée.',
      },
      'de': {
        'title': 'Zeitblockierung',
        'description':
            'Zeitblockierung ist eine Zeitmanagementmethode, bei der Sie bestimmte Zeitblöcke für spezifische Aufgaben oder Aktivitäten festlegen. Durch die Planung von dedizierter Zeit für jede Aufgabe können Sie Ablenkungen und Multitasking reduzieren, was es einfacher macht, fokussiert zu bleiben und Ihre Ziele zu erreichen. Diese Technik hilft Ihnen sicherzustellen, dass genügend Zeit für wichtige Aufgaben aufgewendet wird, und kann besonders nützlich für Menschen mit einem vollen Terminkalender sein, die verschiedene Aktivitäten im Laufe des Tages priorisieren müssen.',
      },
      'es': {
        'title': 'Bloques de Tiempo',
        'description':
            'La gestión del tiempo mediante bloques es un método de gestión del tiempo donde se asignan bloques de tiempo específicos a tareas o actividades específicas. Al programar tiempo dedicado para cada tarea, se pueden reducir las distracciones y el multitasking, lo que facilita mantenerse concentrado y lograr los objetivos. Esta técnica te ayuda a asegurarte de que dedicas suficiente tiempo a las tareas importantes y puede ser especialmente útil para personas con horarios ocupados que necesitan priorizar diferentes actividades a lo largo del día.',
      },
    },
    {
      'en': {
        'title': 'Zen Method',
        'description':
            'The Zen method encourages focusing on one task at a time with full mindfulness and simplicity. Instead of spreading your energy across multiple tasks, it suggests dedicating yourself to a single task and finishing it with complete attention. This method reduces stress by minimizing distractions and multitasking, leading to higher quality work and a more peaceful mind. It is an excellent approach for tasks that demand deep concentration, such as writing, painting, or problem-solving.',
      },
      'tr': {
        'title': 'Zen Metodu',
        'description':
            'Zen metodu, her seferinde bir göreve tamamen odaklanmayı ve bunu farkındalık ve sadelikle tamamlamayı teşvik eder. Enerjinizi birden fazla göreve yaymak yerine, bir göreve odaklanarak ve onu tamamlamak için tüm dikkatinizi vererek, bu yöntemi uygulayabilirsiniz. Bu yaklaşım, dikkat dağılmalarını ve çoklu görevi minimize ederek stresin azalmasına yardımcı olur, böylece daha kaliteli işler ve huzurlu bir zihin elde edilir. Özellikle derin odaklanma gerektiren görevler için mükemmel bir yaklaşımdır, örneğin yazı yazmak, resim yapmak veya problem çözmek.',
      },
      'fr': {
        'title': 'Méthode Zen',
        'description':
            'La méthode Zen encourage à se concentrer sur une tâche à la fois, avec une pleine conscience et simplicité. Au lieu de diviser votre énergie entre plusieurs tâches, elle suggère de se consacrer à une tâche unique et de la terminer avec une attention totale. Cette méthode réduit le stress en minimisant les distractions et le multitâche, ce qui conduit à un travail de meilleure qualité et un esprit plus paisible. C\'est une excellente approche pour les tâches qui nécessitent une concentration profonde, comme l\'écriture, la peinture ou la résolution de problèmes.',
      },
      'de': {
        'title': 'Zen-Methode',
        'description':
            'Die Zen-Methode fördert das Fokussieren auf eine Aufgabe nach der anderen mit voller Achtsamkeit und Einfachheit. Anstatt Ihre Energie auf mehrere Aufgaben zu verteilen, schlägt sie vor, sich einer einzigen Aufgabe zu widmen und diese mit vollständiger Aufmerksamkeit zu beenden. Diese Methode reduziert Stress, indem sie Ablenkungen und Multitasking minimiert, was zu höherer Arbeitsqualität und einem ruhigeren Geist führt. Sie eignet sich hervorragend für Aufgaben, die tiefe Konzentration erfordern, wie Schreiben, Malen oder Problemlösung.',
      },
      'es': {
        'title': 'Método Zen',
        'description':
            'El método Zen fomenta la concentración en una tarea a la vez con plena conciencia y simplicidad. En lugar de distribuir tu energía entre varias tareas, sugiere dedicarte a una sola tarea y terminarla con total atención. Este método reduce el estrés al minimizar las distracciones y el multitasking, lo que lleva a trabajos de mejor calidad y una mente más tranquila. Es un enfoque excelente para tareas que requieren concentración profunda, como escribir, pintar o resolver problemas.',
      },
    },
    {
      'en': {
        'title': 'Task Batching',
        'description':
            'Task batching is the practice of grouping similar tasks together and completing them all at once. By focusing on one category of tasks at a time, you can minimize context switching, improve efficiency, and reduce the mental load of constantly shifting between different types of work. It is particularly useful for tasks such as answering emails, organizing files, or making phone calls, where multiple smaller tasks can be completed in one block of time.',
      },
      'tr': {
        'title': 'Görev Gruplama',
        'description':
            'Görev gruplama, benzer görevleri bir araya getirme ve tümünü aynı anda tamamlama pratiğidir. Aynı anda bir görev kategorisine odaklanarak bağlam geçişini minimize edebilir, verimliliği artırabilir ve farklı türdeki işleri sürekli değiştirme yükünü azaltabilirsiniz. E-posta yanıtlamak, dosyaları düzenlemek veya telefon görüşmeleri yapmak gibi birden çok küçük görevin bir zaman diliminde tamamlanabildiği görevler için özellikle faydalıdır.',
      },
      'fr': {
        'title': 'Regroupement des Tâches',
        'description':
            'Le regroupement des tâches consiste à regrouper des tâches similaires et à les accomplir toutes en une seule fois. En vous concentrant sur une catégorie de tâches à la fois, vous pouvez minimiser les changements de contexte, améliorer l\'efficacité et réduire la charge mentale liée au passage constant entre différents types de travail. Il est particulièrement utile pour des tâches telles que répondre aux e-mails, organiser des fichiers ou passer des appels téléphoniques, où plusieurs petites tâches peuvent être effectuées en un seul bloc de temps.',
      },
      'de': {
        'title': 'Aufgabenbündelung',
        'description':
            'Aufgabenbündelung ist die Praxis, ähnliche Aufgaben zusammenzufassen und alle auf einmal zu erledigen. Indem Sie sich jeweils auf eine Aufgabenart konzentrieren, können Sie den Kontextwechsel minimieren, die Effizienz steigern und die geistige Belastung durch ständiges Wechseln zwischen verschiedenen Arbeitsarten reduzieren. Es ist besonders nützlich für Aufgaben wie das Beantworten von E-Mails, das Organisieren von Dateien oder das Führen von Telefonaten, bei denen mehrere kleinere Aufgaben in einem Block erledigt werden können.',
      },
      'es': {
        'title': 'Agrupación de Tareas',
        'description':
            'La agrupación de tareas es la práctica de agrupar tareas similares y completarlas todas a la vez. Al concentrarte en una categoría de tareas a la vez, puedes minimizar el cambio de contexto, mejorar la eficiencia y reducir la carga mental de cambiar constantemente entre diferentes tipos de trabajo. Es especialmente útil para tareas como responder correos electrónicos, organizar archivos o hacer llamadas telefónicas, donde se pueden completar múltiples tareas pequeñas en un solo bloque de tiempo.',
      },
    },
    {
      'en': {
        'title': 'Eat That Frog',
        'description':
            'Eat That Frog is a productivity technique that encourages tackling the most difficult or important task of the day first. By completing the most challenging task early, you not only make the rest of your day easier but also build momentum to keep going. This method helps reduce procrastination and increases overall productivity by ensuring that you address the most pressing issues before moving on to other tasks.',
      },
      'tr': {
        'title': 'Kurbağayı Ye',
        'description':
            'Kurbağayı Ye, günün en zor veya en önemli görevini ilk önce yapmanızı teşvik eden bir verimlilik tekniğidir. En zorlu görevi erken tamamlayarak, günün geri kalan kısmını daha kolay hale getirebilir ve devam etmek için bir ivme kazanabilirsiniz. Bu yöntem, erteleme davranışını azaltmaya yardımcı olur ve en acil işleri öncelikli olarak ele alarak genel verimliliği artırır.',
      },
      'fr': {
        'title': 'Mangez Cette Grenouille',
        'description':
            'Mangez Cette Grenouille est une technique de productivité qui encourage à s\'attaquer d\'abord à la tâche la plus difficile ou importante de la journée. En accomplissant la tâche la plus difficile en premier, vous facilitez le reste de votre journée et gagnez de l\'élan pour continuer. Cette méthode aide à réduire la procrastination et augmente la productivité générale en s\'assurant que vous abordez les problèmes les plus urgents avant de passer à d\'autres tâches.',
      },
      'de': {
        'title': 'Iss den Frosch',
        'description':
            'Iss den Frosch ist eine Produktivitätstechnik, die dazu ermutigt, die schwierigste oder wichtigste Aufgabe des Tages zuerst zu erledigen. Indem Sie die schwierigste Aufgabe zuerst erledigen, machen Sie den Rest des Tages leichter und bauen eine Dynamik auf, um weiterzumachen. Diese Methode hilft, Prokrastination zu reduzieren und steigert die Gesamtproduktivität, indem sie sicherstellt, dass die dringendsten Probleme zuerst angegangen werden.',
      },
      'es': {
        'title': 'Cómese esa Rana',
        'description':
            'Cómese esa Rana es una técnica de productividad que fomenta abordar primero la tarea más difícil o importante del día. Al completar la tarea más desafiante temprano, no solo facilitas el resto del día, sino que también generas impulso para seguir adelante. Este método ayuda a reducir la procrastinación y aumenta la productividad general al asegurar que se aborden los problemas más urgentes antes de pasar a otras tareas.',
      },
    },
    {
      'en': {
        'title': 'Eisenhower Matrix',
        'description':
            'The Eisenhower Matrix is a decision-making tool that helps you prioritize tasks based on their urgency and importance. It divides tasks into four quadrants: urgent and important, important but not urgent, urgent but not important, and neither urgent nor important. By focusing on tasks that are important but not urgent, you can achieve long-term goals and prevent the urgency of less important tasks from overwhelming your schedule.',
      },
      'tr': {
        'title': 'Eisenhower Matrisi',
        'description':
            'Eisenhower Matrisi, görevlerinizi aciliyet ve önemine göre önceliklendirmeye yardımcı olan bir karar verme aracıdır. Görevler dört bölüme ayrılır: acil ve önemli, önemli ancak acil olmayan, acil ancak önemli olmayan ve ne acil ne de önemli. Önemli ancak acil olmayan görevlere odaklanarak uzun vadeli hedeflere ulaşabilir ve daha az önemli görevlerin aciliyetinin programınızı aşmasını engelleyebilirsiniz.',
      },
      'fr': {
        'title': 'Matrice d\'Eisenhower',
        'description':
            'La Matrice d\'Eisenhower est un outil de prise de décision qui vous aide à prioriser les tâches en fonction de leur urgence et de leur importance. Elle divise les tâches en quatre quadrants : urgent et important, important mais non urgent, urgent mais non important, et ni urgent ni important. En vous concentrant sur les tâches importantes mais non urgentes, vous pouvez atteindre vos objectifs à long terme et empêcher l\'urgence des tâches moins importantes de submerger votre emploi du temps.',
      },
      'de': {
        'title': 'Eisenhower-Matrix',
        'description':
            'Die Eisenhower-Matrix ist ein Entscheidungsinstrument, das Ihnen hilft, Aufgaben nach ihrer Dringlichkeit und Wichtigkeit zu priorisieren. Sie unterteilt Aufgaben in vier Quadranten: dringend und wichtig, wichtig aber nicht dringend, dringend aber nicht wichtig und weder dringend noch wichtig. Indem Sie sich auf wichtige, aber nicht dringende Aufgaben konzentrieren, können Sie langfristige Ziele erreichen und verhindern, dass die Dringlichkeit weniger wichtiger Aufgaben Ihren Zeitplan überfordert.',
      },
      'es': {
        'title': 'Matriz Eisenhower',
        'description':
            'La Matriz Eisenhower es una herramienta de toma de decisiones que te ayuda a priorizar tareas según su urgencia e importancia. Divide las tareas en cuatro cuadrantes: urgente e importante, importante pero no urgente, urgente pero no importante, y ni urgente ni importante. Al enfocarte en tareas importantes pero no urgentes, puedes lograr tus objetivos a largo plazo y evitar que la urgencia de tareas menos importantes sobrecargue tu horario.',
      },
    },
  ];

  GuidelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(TextsInApp.getText("guideline_techniques")),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [
                      Colors.black,
                      const Color.fromARGB(255, 27, 12, 115),
                      Colors.black
                    ]
                  : [Colors.deepOrangeAccent, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: techniques.length,
          itemBuilder: (context, index) {
            final technique = techniques[index];
            final colors = [
              Colors.blueAccent,
              Colors.purpleAccent,
              Colors.pinkAccent,
              Colors.deepOrangeAccent.shade400,
              Colors.greenAccent,
              Colors.amber.shade800,
            ];
            final gradientColor = colors[index % colors.length];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TechniqueDetailScreen(
                      title: technique[TextsInApp.getLanguageCode()]!['title']!,
                      description: technique[TextsInApp.getLanguageCode()]![
                          'description']!,
                      gradientColor: gradientColor,
                    ),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [gradientColor.withOpacity(0.9), gradientColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColor.withOpacity(0.6),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ValueListenableBuilder<double>(
                    valueListenable: FontSizeNotifier.fontSizeNotifier,
                    builder: (context, fontSize, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            technique[TextsInApp.getLanguageCode()]!['title']!,
                            style: TextStyle(
                              fontSize: fontSize + 4,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            technique[TextsInApp.getLanguageCode()]![
                                'description']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: fontSize + 1,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TechniqueDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final Color gradientColor;

  const TechniqueDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.gradientColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(TextsInApp.getText("guideline_techniques")), //'Techniques'
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [
                      Colors.black,
                      const Color.fromARGB(255, 27, 12, 115),
                      Colors.black
                    ]
                  : [Colors.deepOrangeAccent, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
          child: ValueListenableBuilder<double>(
            valueListenable: FontSizeNotifier.fontSizeNotifier,
            builder: (context, fontSize, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: fontSize + 8,
                        fontWeight: FontWeight.bold,
                        color: gradientColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: fontSize + 2,
                          height: 1.5,
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
