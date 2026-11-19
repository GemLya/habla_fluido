import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/almacen.dart';

/// En memoria: para pruebas. Pasa los datos por JSON para imitar lo que hace el disco.
class AlmacenAvanceMemoria implements AlmacenAvance {
  Map<String, Object?>? _datos;

  @override
  Future<Map<String, Object?>?> cargar() async => _datos;

  @override
  Future<void> guardar(Map<String, Object?> datos) async {
    _datos = Map<String, Object?>.from(jsonDecode(jsonEncode(datos)) as Map);
  }
}

/// En el teléfono: shared_preferences (el avance no es un secreto).
class AlmacenAvancePrefs implements AlmacenAvance {
  static const _clave = 'avance_v1';

  @override
  Future<Map<String, Object?>?> cargar() async {
    final t = (await SharedPreferences.getInstance()).getString(_clave);
    if (t == null) return null;
    try {
      final o = jsonDecode(t);
      return o is Map ? Map<String, Object?>.from(o) : null;
    } catch (_) {
      return null; // archivo dañado: empezamos limpio
    }
  }

  @override
  Future<void> guardar(Map<String, Object?> datos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_clave, jsonEncode(datos));
  }
}
