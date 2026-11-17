class Umkm {
  const Umkm({
    this.id,
    required this.namaUmkm,
    required this.pemilik,
    required this.alamat,
    required this.kategori,
    required this.kontak,
  });

  final int? id;
  final String namaUmkm;
  final String pemilik;
  final String alamat;
  final String kategori;
  final String kontak;

  // Mengubah JSON menjadi objek Umkm
  factory Umkm.fromJson(Map<String, dynamic> json) => Umkm(
    id: json['id'] == null ? null : int.tryParse(json['id'].toString()),
    namaUmkm: json['nama_umkm'] as String,
    pemilik: json['pemilik'] as String,
    alamat: json['alamat'] as String,
    kategori: json['kategori'] as String,
    kontak: json['kontak'] as String,
  );

  // Mengubah objek Umkm menjadi JSON
  Map<String, dynamic> toJson() => {
    'nama_umkm': namaUmkm,
    'pemilik': pemilik,
    'alamat': alamat,
    'kategori': kategori,
    'kontak': kontak,
  };
}
