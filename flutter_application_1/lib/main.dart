import 'package:flutter/material.dart';

import 'models/umkm.dart';
import 'services/umkm_api.dart';

void main() {
  runApp(const UmkmApp());
}

class UmkmApp extends StatelessWidget {
  const UmkmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manajemen UMKM',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        scaffoldBackgroundColor: const Color(0xFFF4F7FC),
      ),
      home: const UmkmPage(),
    );
  }
}

class UmkmPage extends StatefulWidget {
  const UmkmPage({super.key});

  @override
  State<UmkmPage> createState() => _UmkmPageState();
}

class _UmkmPageState extends State<UmkmPage> {
  final UmkmApi api = UmkmApi(baseUrl: 'http://localhost:8080/api');

  List<Umkm> daftarUmkm = [];
  bool loading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    ambilData();
  }

  // GET: Mengambil seluruh data UMKM
  Future<void> ambilData() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final data = await api.getAll();

      if (!mounted) return;

      setState(() {
        daftarUmkm = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        errorMessage = e.toString();
      });
    }
  }

  // POST: Menambahkan data UMKM
  Future<void> tambahData() async {
    final hasil = await tampilkanForm();

    if (hasil == null) return;

    try {
      await api.create(hasil);

      if (!mounted) return;

      tampilPesan('Data UMKM berhasil ditambahkan');
      await ambilData();
    } catch (e) {
      if (!mounted) return;
      tampilPesan('Gagal menambahkan data: $e');
    }
  }

  // PUT: Memperbarui data UMKM
  Future<void> editData(Umkm item) async {
    final hasil = await tampilkanForm(item: item);

    if (hasil == null) return;

    try {
      await api.update(hasil);

      if (!mounted) return;

      tampilPesan('Data UMKM berhasil diperbarui');
      await ambilData();
    } catch (e) {
      if (!mounted) return;
      tampilPesan('Gagal memperbarui data: $e');
    }
  }

  // DELETE: Menghapus data UMKM
  Future<void> hapusData(Umkm item) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus UMKM?'),
        content: Text('Yakin ingin menghapus ${item.namaUmkm}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi != true || item.id == null) return;

    try {
      await api.delete(item.id!);

      if (!mounted) return;

      tampilPesan('Data UMKM berhasil dihapus');
      await ambilData();
    } catch (e) {
      if (!mounted) return;
      tampilPesan('Gagal menghapus data: $e');
    }
  }

  // Form tambah dan edit UMKM
  Future<Umkm?> tampilkanForm({Umkm? item}) async {
    final nama = TextEditingController(text: item?.namaUmkm ?? '');

    final pemilik = TextEditingController(text: item?.pemilik ?? '');

    final alamat = TextEditingController(text: item?.alamat ?? '');

    final kategori = TextEditingController(text: item?.kategori ?? '');

    final kontak = TextEditingController(text: item?.kontak ?? '');

    final hasil = await showDialog<Umkm>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? 'Tambah UMKM' : 'Edit UMKM'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              formField(nama, 'Nama UMKM'),
              formField(pemilik, 'Nama Pemilik'),
              formField(alamat, 'Alamat'),
              formField(kategori, 'Kategori'),
              formField(kontak, 'Kontak'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (nama.text.trim().isEmpty ||
                  pemilik.text.trim().isEmpty ||
                  alamat.text.trim().isEmpty ||
                  kategori.text.trim().isEmpty ||
                  kontak.text.trim().isEmpty) {
                return;
              }

              Navigator.pop(
                context,
                Umkm(
                  id: item?.id,
                  namaUmkm: nama.text.trim(),
                  pemilik: pemilik.text.trim(),
                  alamat: alamat.text.trim(),
                  kategori: kategori.text.trim(),
                  kontak: kontak.text.trim(),
                ),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    nama.dispose();
    pemilik.dispose();
    alamat.dispose();
    kategori.dispose();
    kontak.dispose();

    return hasil;
  }

  // Membuat input form
  Widget formField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // Menampilkan pesan
  void tampilPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
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
        title: const Text(
          'Manajemen UMKM',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: ambilData,
            child: const Text('Refresh', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),

      // Tombol tambah UMKM
      floatingActionButton: FloatingActionButton.extended(
        onPressed: tambahData,
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        label: const Text('Tambah UMKM'),
      ),

      body: RefreshIndicator(
        onRefresh: ambilData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data UMKM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Kelola data usaha mikro, kecil, dan menengah.',
                    style: TextStyle(color: Colors.white, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${daftarUmkm.length} UMKM terdaftar',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Daftar Usaha',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172033),
              ),
            ),

            const SizedBox(height: 12),

            // Loading
            if (loading)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: CircularProgressIndicator()),
              )
            // Error
            else if (errorMessage != null)
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Gagal mengambil data',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: ambilData,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              )
            // Data kosong
            else if (daftarUmkm.isEmpty)
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      const Text(
                        'Belum ada data UMKM',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tekan tombol Tambah UMKM untuk memulai.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            // Daftar UMKM
            else
              ...daftarUmkm.map(
                (item) => Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.namaUmkm,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF172033),
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  editData(item);
                                } else if (value == 'hapus') {
                                  hapusData(item);
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem(
                                  value: 'hapus',
                                  child: Text('Hapus'),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const Divider(height: 24),

                        Text('Pemilik: ${item.pemilik}'),
                        const SizedBox(height: 8),

                        Text('Alamat: ${item.alamat}'),
                        const SizedBox(height: 8),

                        Text('Kategori: ${item.kategori}'),
                        const SizedBox(height: 8),

                        Text('Kontak: ${item.kontak}'),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}
