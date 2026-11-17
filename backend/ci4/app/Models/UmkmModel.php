<?php

namespace App\Models;

use CodeIgniter\Model;

class UmkmModel extends Model
{
    protected $table = 'umkm';
    protected $primaryKey = 'id';
    protected $returnType = 'array';
    protected $allowedFields = ['nama_umkm', 'pemilik', 'alamat', 'kategori', 'kontak'];
    protected $useTimestamps = true;
    protected $createdField = 'created_at';
    protected $updatedField = 'updated_at';
}
