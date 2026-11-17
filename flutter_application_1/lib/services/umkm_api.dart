import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/umkm.dart';

class UmkmApi {
  UmkmApi({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Uri _uri([String suffix = '']) {
    return Uri.parse('$baseUrl/umkm$suffix');
  }

  Map<String, dynamic> _decode(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        body['message'] ?? 'Permintaan API gagal (${response.statusCode})',
      );
    }

    return body;
  }

  // Mengambil semua data UMKM
  Future<List<Umkm>> getAll() async {
    final body = _decode(await _client.get(_uri()));

    return (body['data'] as List<dynamic>)
        .map((item) => Umkm.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Menambahkan data UMKM
  Future<Umkm> create(Umkm item) async {
    final response = await _client.post(
      _uri(),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(item.toJson()),
    );

    return Umkm.fromJson(_decode(response)['data'] as Map<String, dynamic>);
  }

  // Memperbarui data UMKM
  Future<Umkm> update(Umkm item) async {
    final id = item.id;

    if (id == null) {
      throw ArgumentError('ID diperlukan untuk update');
    }

    final response = await _client.put(
      _uri('/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(item.toJson()),
    );

    return Umkm.fromJson(_decode(response)['data'] as Map<String, dynamic>);
  }

  // Menghapus data UMKM
  Future<void> delete(int id) async {
    _decode(await _client.delete(_uri('/$id')));
  }

  // Menutup HTTP Client
  void close() {
    _client.close();
  }
}
