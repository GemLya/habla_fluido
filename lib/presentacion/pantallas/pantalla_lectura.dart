import 'package:flutter/material.dart';

import '../../dependencias.dart';
import '../vm/lectura_vm.dart';

class PantallaLectura extends StatefulWidget {
  final Dependencias deps;
  const PantallaLectura({super.key, required this.deps});

  @override
  State<PantallaLectura> createState() => _EstadoPantalla();
}

class _EstadoPantalla extends State<PantallaLectura> {
  late final LecturaViewModel vm = LecturaViewModel(widget.deps.aprendizaje);

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  IconData _icono(int pregunta, int opcion, int correcta) {
    final elegida = vm.respuestas[pregunta];
    if (elegida == opcion) return correcta == opcion ? Icons.check_circle : Icons.cancel;
    if (elegida != null && correcta == opcion) return Icons.check_circle_outline;
    return Icons.radio_button_unchecked;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Lectura')),
        body: ListenableBuilder(
          listenable: vm,
          builder: (context, _) {
            final t = vm.actual;
            return ListView(padding: const EdgeInsets.all(16), children: [
              Text(t.titulo, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(t.texto, style: const TextStyle(fontSize: 18, height: 1.4)),
              const Divider(height: 32),
              for (var i = 0; i < t.preguntas.length; i++) ...[
                Text(t.preguntas[i].enunciado, style: const TextStyle(fontWeight: FontWeight.bold)),
                for (var o = 0; o < t.preguntas[i].opciones.length; o++)
                  ListTile(
                    dense: true,
                    title: Text(t.preguntas[i].opciones[o]),
                    leading: Icon(_icono(i, o, t.preguntas[i].correcta)),
                    onTap: () => vm.responder(i, o),
                  ),
              ],
              if (vm.terminado) ...[
                Text('Resultado: ${vm.correctas}/${t.preguntas.length}',
                    style: Theme.of(context).textTheme.titleLarge),
                TextButton(onPressed: vm.siguienteTexto, child: const Text('Otro texto')),
              ],
            ]);
          },
        ),
      );
}
