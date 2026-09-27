// Домашнее задание 1. Шесть виджетов. Выполнила: Тарасова Виктория Андреевна
import 'package:flutter/material.dart';

void main() {
  runApp(const Lab1App());
}

class Lab1App extends StatelessWidget {
  const Lab1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ЛР 1')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Task 1:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                task1(),
                const Divider(),
                const Text('Task 2:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                task2(),
                const Divider(),
                const Text('Task 3:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                task3(),
                const Divider(),
                const Text('Task 4:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                task4(),
                const Divider(),
                const Text('Task 5:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                task5(),
                const Divider(),
                const Text('Task 6:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                task6(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 1. Заголовок
Widget task1() {
  return const Text(
    'Очень длинный заголовок, который не поместится в одну строку',
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );
}

// 2. Подпись
Widget task2() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.grey[800],
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Text(
      'Это небольшая подпись, которая может быть длинной и не поместится в две строки',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 14,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
    ),
  );
}

// 3. Иконка
Widget task3() {
  return const Icon(
    Icons.star,
    color: Colors.amber,
    size: 48,
  );
}

// 4. Кнопка с сердцем
Widget task4() {
  return IconButton(
    onPressed: () {
      print('Вы добавили в избранное');
    },
    icon: const Icon(Icons.favorite),
    iconSize: 64,
    color: Colors.red,
  );
}

// 5. Кнопка «Подробнее»
Widget task5() {
  return ElevatedButton(
    onPressed: () {
      print('Узнать детали');
    },
    style: ElevatedButton.styleFrom(
      side: const BorderSide(color: Colors.blue),
    ),
    child: const Text('Подробнее'),
  );
}

// 6. Polaroid
Widget task6() {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black, width: 2),
    ),
    child: Image.network(
      'https://picsum.photos/200/200',
      width: 200,
      height: 200,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Image error: $error');
        return const Icon(Icons.broken_image);
      },
    ),
  );
}