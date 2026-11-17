<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateUmkm extends Migration
{
    public function up()
    {
        $this->forge->addField([
            'id' => ['type' => 'INT', 'constraint' => 11, 'unsigned' => true, 'auto_increment' => true],
            'nama_umkm' => ['type' => 'VARCHAR', 'constraint' => 150],
            'pemilik' => ['type' => 'VARCHAR', 'constraint' => 120],
            'alamat' => ['type' => 'TEXT'],
            'kategori' => ['type' => 'VARCHAR', 'constraint' => 80],
            'kontak' => ['type' => 'VARCHAR', 'constraint' => 30],
            'created_at' => ['type' => 'DATETIME', 'null' => true],
            'updated_at' => ['type' => 'DATETIME', 'null' => true],
        ]);
        $this->forge->addKey('id', true);
        $this->forge->createTable('umkm', true);
    }

    public function down()
    {
        $this->forge->dropTable('umkm', true);
    }
}
