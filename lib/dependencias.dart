import 'package:http/http.dart' as http;

import 'datos/almacen_avance.dart';
import 'datos/tutor_http.dart';
import 'datos/tutor_simulado.dart';
import 'datos/voz_real.dart';
import 'dominio/almacen.dart';
import 'dominio/tutor.dart';
import 'dominio/voz.dart';
import 'presentacion/vm/aprendizaje_vm.dart';

/// Raíz de composición: el único lugar que decide qué implementaciones usar.
///
/// Sin configurar nada, la app usa el TUTOR SIMULADO (sin internet ni costo).
/// Para usar la IA real, arranca tu proxy y ejecuta:
///   flutter run --dart-define=TUTOR_URL=https://tu-servidor.com/tutor --dart-define=TUTOR_TOKEN=...
/// Emulador Android + proxy local en tu computadora:
///   flutter run --dart-define=TUTOR_URL=http://10.0.2.2:8787/tutor --dart-define=TUTOR_HTTP_LOCAL=true
const _urlTutor = String.fromEnvironment('TUTOR_URL');
const _tokenTutor = String.fromEnvironment('TUTOR_TOKEN');
const _httpLocal = bool.fromEnvironment('TUTOR_HTTP_LOCAL');

class Dependencias {
  final TutorIA tutor;
  final Voz voz;
  final AprendizajeViewModel aprendizaje;
  Dependencias(this.tutor, this.voz, this.aprendizaje);

  factory Dependencias.crear({TutorIA? tutor, Voz? voz, AlmacenAvance? almacen}) {
    final TutorIA t = tutor ??
        (_urlTutor.isEmpty
            ? TutorSimulado()
            : TutorHttp(
                Uri.parse(_urlTutor),
                http.Client(),
                tokenApp: _tokenTutor.isEmpty ? null : _tokenTutor,
                permitirHttpLocal: _httpLocal,
              ));
    return Dependencias(
      t,
      voz ?? VozReal(),
      AprendizajeViewModel(almacen ?? AlmacenAvancePrefs()),
    );
  }
}
