import 'package:flutter/material.dart';

import 'models/umkm.dart';
import 'services/umkm_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tes API UMKM',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TestApiPage(),
    );
  }
}

class TestApiPage extends StatefulWidget {
  const TestApiPage({super.key});

  @override
  State<TestApiPage> createState() => _TestApiPageState();
}

class _TestApiPageState extends State<TestApiPage> {
  final UmkmApi api = UmkmApi(baseUrl: 'http://localhost:8080/api');

  String hasil = 'Belum melakukan pengujian API';

  // GET: Mengambil semua data UMKM
  Future<void> ambilData() async {
    try {
      final data = await api.getAll();

      setState(() {
        if (data.isEmpty) {
          hasil = 'Berhasil mengambil 0 data UMKM';
        } else {
          hasil = 'Berhasil mengambil ${data.length} data UMKM\n\n';

          for (var item in data) {
            hasil +=
                '''
ID: ${item.id}
Nama: ${item.namaUmkm}
Pemilik: ${item.pemilik}
Alamat: ${item.alamat}
Kategori: ${item.kategori}
Kontak: ${item.kontak}

-------------------------
''';
          }
        }
      });
    } catch (e) {
      setState(() {
        hasil = 'Gagal mengambil data: $e';
      });
    }
  }

  // POST: Menambahkan data UMKM
  Future<void> tambahData() async {
    try {
      final umkmBaru = Umkm(
        namaUmkm: 'Warung Berkah',
        pemilik: 'Budi',
        alamat: 'Jl. Ahmad Yani No. 15',
        kategori: 'Kuliner',
        kontak: '081234567890',
      );

      final hasilTambah = await api.create(umkmBaru);

      setState(() {
        hasil =
            '''
Berhasil menambahkan UMKM!

ID: ${hasilTambah.id}
Nama: ${hasilTambah.namaUmkm}
Pemilik: ${hasilTambah.pemilik}
Alamat: ${hasilTambah.alamat}
Kategori: ${hasilTambah.kategori}
Kontak: ${hasilTambah.kontak}
''';
      });
    } catch (e) {
      setState(() {
        hasil = 'Gagal menambahkan data: $e';
      });
    }
  }

  // PUT: Memperbarui data UMKM
  Future<void> ubahData() async {
    try {
      final umkmUpdate = Umkm(
        id: 3,
        namaUmkm: 'Warung Berkah',
        pemilik: 'Budi',
        alamat: 'Jl. A. Yani No. 25',
        kategori: 'Kuliner',
        kontak: '081234567899',
      );

      final hasilUpdate = await api.update(umkmUpdate);

      setState(() {
        hasil =
            '''
Berhasil memperbarui UMKM!

ID: ${hasilUpdate.id}
Nama: ${hasilUpdate.namaUmkm}
Pemilik: ${hasilUpdate.pemilik}
Alamat: ${hasilUpdate.alamat}
Kategori: ${hasilUpdate.kategori}
Kontak: ${hasilUpdate.kontak}
''';
      });
    } catch (e) {
      setState(() {
        hasil = 'Gagal memperbarui data: $e';
      });
    }
  }

  // DELETE: Menghapus data UMKM
  Future<void> hapusData() async {
    try {
      await api.delete(3);

      setState(() {
        hasil = 'Berhasil menghapus data UMKM dengan ID 3';
      });
    } catch (e) {
      setState(() {
        hasil = 'Gagal menghapus data: $e';
      });
    }
  }

  @override
  void dispose() {
    api.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tes REST API UMKM'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pengujian CRUD REST API',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: ambilData,
              child: const Text('Ambil Data UMKM (GET)'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: tambahData,
              child: const Text('Tambah Data UMKM (POST)'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: ubahData,
              child: const Text('Ubah Data UMKM (PUT)'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: hapusData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus Data UMKM (DELETE)'),
            ),

            const SizedBox(height: 25),

            const Text(
              'Hasil Pengujian:',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    hasil,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
