import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RiveNative.init();
  runApp(const RiveDiagnosticApp());
}

class RiveDiagnosticApp extends StatelessWidget {
  const RiveDiagnosticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const RiveDiagnosticScreen(),
    );
  }
}

class RiveDiagnosticScreen extends StatefulWidget {
  const RiveDiagnosticScreen({super.key});

  @override
  State<RiveDiagnosticScreen> createState() => _RiveDiagnosticScreenState();
}

class _RiveDiagnosticScreenState extends State<RiveDiagnosticScreen> {
  late final Future<String> _diagnostic = _loadAndInspect();

  Future<String> _loadAndInspect() async {
    // In rive 0.14.11 the loaded file class is File, not RiveFile.
    final file = await File.asset(
      'assets/raccoon_budget.riv',
      riveFactory: Factory.rive,
    );

    if (file == null) {
      return 'ОШИБКА: File.asset вернул null.\n'
          'Проверь путь assets/raccoon_budget.riv и pubspec.yaml.';
    }

    try {
      final lines = <String>[
        'Файл успешно загружен.',
        'Проверка Artboard:',
        '',
      ];

      var foundArtboards = 0;

      for (var i = 0; i < 100; i++) {
        final artboard = file.artboardAt(i);
        if (artboard == null) break;

        foundArtboards++;
        lines.add('${i + 1}. Artboard: "${artboard.name}"');

        final machineCount = artboard.stateMachineCount();
        if (machineCount == 0) {
          lines.add('   State Machines: нет');
        } else {
          lines.add('   State Machines:');
          for (var j = 0; j < machineCount; j++) {
            final machine = artboard.stateMachineAt(j);
            if (machine != null) {
              lines.add('   - "${machine.name}"');
            }
          }
        }

        lines.add('');
      }

      if (foundArtboards == 0) {
        lines.add('Artboard не найдены.');
      }

      lines.add('Проверка ожидаемых объектов:');
      lines.add('');

      const expected = <String, List<String>>{
        'BudgetHome': [
          'EnotTimeline100',
          'EnotTimeline60',
          'EnotTimeline30',
          'EnotTimelineZero',
          'EnotTimelinePLUS',
          'EnotTimelineIzRasch',
        ],
        'AccountantRaccoon': ['AccountantSM'],
        'RaccoonVictory': ['VictorySM'],
      };

      for (final entry in expected.entries) {
        final artboard = file.artboard(entry.key);
        lines.add(
          '${artboard == null ? "НЕТ" : "ЕСТЬ"}: Artboard "${entry.key}"',
        );

        if (artboard == null) continue;

        for (final machineName in entry.value) {
          final machine = artboard.stateMachine(machineName);
          lines.add(
            '   ${machine == null ? "НЕТ" : "ЕСТЬ"}: State Machine "$machineName"',
          );
        }
      }

      lines.add('');
      lines.add('View Models: ${file.viewModelCount}');

      return lines.join('\n');
    } catch (error, stackTrace) {
      return 'ОШИБКА ПРИ ПРОВЕРКЕ:\n$error\n\n$stackTrace';
    } finally {
      file.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rive file diagnostic')),
      body: FutureBuilder<String>(
        future: _diagnostic,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              snapshot.data ?? 'Нет диагностических данных.',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                height: 1.45,
              ),
            ),
          );
        },
      ),
    );
  }
}
