import 'package:flutter/material.dart';

import '../../dominio/comparador.dart';

/// Muestra cada palabra con color: verde bien, naranja casi, rojo mal u omitida,
/// gris sobrante. También usa texto y tachado: no depende solo del color.
class PalabrasColoreadas extends StatelessWidget {
  final ResultadoComparacion resultado;
  const PalabrasColoreadas(this.resultado, {super.key});

  Color _color(EstadoPalabra e) => switch (e) {
        EstadoPalabra.correcta => Colors.green.shade700,
        EstadoPalabra.parecida => Colors.orange.shade800,
        EstadoPalabra.sustituida => Colors.red.shade700,
        EstadoPalabra.omitida => Colors.red.shade700,
        EstadoPalabra.sobrante => Colors.grey.shade600,
      };

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(spacing: 6, runSpacing: 4, children: [
          for (final p in resultado.palabras)
            Chip(
              label: Text(
                p.estado == EstadoPalabra.sobrante ? '+ ${p.dicha}' : (p.esperada ?? ''),
                style: TextStyle(
                  color: _color(p.estado),
                  fontWeight: FontWeight.bold,
                  decoration:
                      p.estado == EstadoPalabra.omitida ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
        ]),
        const SizedBox(height: 8),
        Text(
          'Puntaje: ${(resultado.puntaje * 100).round()}% '
          '${resultado.aprobado ? "✅ ¡Muy bien!" : "💪 Inténtalo otra vez"}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (resultado.porPracticar.isNotEmpty)
          Text('Practica: ${resultado.porPracticar.join(", ")}'),
      ]);
}

/// Tarjeta de aviso (errores amables). Si [texto] es null no ocupa espacio.
class Aviso extends StatelessWidget {
  final String? texto;
  const Aviso(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    final t = texto;
    if (t == null) return const SizedBox.shrink();
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(padding: const EdgeInsets.all(12), child: Text(t)),
    );
  }
}
