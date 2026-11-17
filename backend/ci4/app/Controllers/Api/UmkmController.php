<?php

namespace App\Controllers\Api;

use App\Controllers\BaseController;
use App\Models\UmkmModel;
use CodeIgniter\HTTP\ResponseInterface;

class UmkmController extends BaseController
{
    private UmkmModel $umkm;

    public function __construct()
    {
        $this->umkm = new UmkmModel();
    }

    private function reply(bool $success, string $message, mixed $data, int $status): ResponseInterface
    {
        return $this->response->setStatusCode($status)->setJSON([
            'success' => $success,
            'message' => $message,
            'data' => $data,
        ]);
    }

    private function inputRules(): array
    {
        return [
            'nama_umkm' => 'required|min_length[2]|max_length[150]',
            'pemilik' => 'required|min_length[2]|max_length[120]',
            'alamat' => 'required|min_length[5]',
            'kategori' => 'required|max_length[80]',
            'kontak' => 'required|max_length[30]',
        ];
    }

    private function validationError(): ResponseInterface
    {
        return $this->response->setStatusCode(400)->setJSON([
            'success' => false,
            'message' => 'Validasi data UMKM gagal',
            'errors' => $this->validator->getErrors(),
        ]);
    }

    public function index(): ResponseInterface
    {
        return $this->reply(true, 'Data UMKM berhasil diambil', $this->umkm->findAll(), 200);
    }

    public function show(int $id): ResponseInterface
    {
        $item = $this->umkm->find($id);
        return $item
            ? $this->reply(true, 'Data UMKM berhasil diambil', $item, 200)
            : $this->reply(false, 'Data UMKM tidak ditemukan', null, 404);
    }

    public function create(): ResponseInterface
    {
        $data = $this->request->getJSON(true) ?? [];
        if (! $this->validateData($data, $this->inputRules())) {
            return $this->validationError();
        }
        $id = $this->umkm->insert($data, true);
        return $this->reply(true, 'Data UMKM berhasil ditambahkan', $this->umkm->find($id), 201);
    }

    public function update(int $id): ResponseInterface
    {
        if (! $this->umkm->find($id)) {
            return $this->reply(false, 'Data UMKM tidak ditemukan', null, 404);
        }
        $data = $this->request->getJSON(true) ?? [];
        if (! $this->validateData($data, $this->inputRules())) {
            return $this->validationError();
        }
        $this->umkm->update($id, $data);
        return $this->reply(true, 'Data UMKM berhasil diperbarui', $this->umkm->find($id), 200);
    }

    public function delete(int $id): ResponseInterface
    {
        $item = $this->umkm->find($id);
        if (! $item) {
            return $this->reply(false, 'Data UMKM tidak ditemukan', null, 404);
        }
        $this->umkm->delete($id);
        return $this->reply(true, 'Data UMKM berhasil dihapus', $item, 200);
    }
}
