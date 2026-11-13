<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Master Barang - CRUD dengan halaman terpisah (list, tambah, edit), pola sama dengan Supplier.
 * Relasi: Kategori Barang dan KIB (dropdown select2 yang bisa dicari). Enum: Jenis Penggunaan (SERVICE / NON_SERVICE).
 */
class Master_product extends Admin_Controller
{
    /** Pilihan enum service_type (kunci = nilai di DB). */
    private $service_types = array(
        'SERVICE'     => 'Layanan (mendukung pelayanan pasien)',
        'NON_SERVICE' => 'Non Layanan (tidak langsung mendukung pelayanan)',
    );

    /** Data barang yang sedang diedit (dipakai callback validasi relasi). */
    private $current = null;

    public function __construct()
    {
        parent::__construct();
        $this->require_access('master_product');
        $this->load->model('Master_product_model');
    }

    public function index()
    {
        $data = array(
            'rows'          => $this->Master_product_model->all(),
            'service_types' => $this->service_types,
        );

        $page_config = array(
            'title'            => 'Master Barang',
            'page'             => 'master_product',
            'breadcrumb'       => array('Master Data', 'Master Barang'),
            'breadcrumb_links' => array('master_product'),
            'page_data'        => array(
                'success' => $this->session->flashdata('success'),
                'error'   => $this->session->flashdata('error'),
            ),
        );

        $this->render('master_product/index', $data, $page_config);
    }

    public function create()
    {
        $this->form_page(null);
    }

    public function store()
    {
        if ($this->input->method() !== 'post') {
            redirect('master_product');
        }

        $this->apply_rules(0);
        if (!$this->form_validation->run()) {
            return $this->form_page(null, TRUE);
        }

        if (!$this->Master_product_model->insert($this->collect())) {
            $this->session->set_flashdata('error', 'Data barang gagal disimpan.');
            redirect('master_product');
        }

        $this->session->set_flashdata('success', 'Data barang berhasil ditambahkan.');
        redirect('master_product');
    }

    public function edit($id = 0)
    {
        $row = $this->Master_product_model->find($id);
        if (!$row) {
            $this->session->set_flashdata('error', 'Data barang tidak ditemukan.');
            redirect('master_product');
        }
        $this->form_page($row);
    }

    public function update($id = 0)
    {
        if ($this->input->method() !== 'post') {
            redirect('master_product');
        }

        $row = $this->Master_product_model->find($id);
        if (!$row) {
            $this->session->set_flashdata('error', 'Data barang tidak ditemukan.');
            redirect('master_product');
        }

        $this->current = $row;
        $this->apply_rules((int) $id);
        if (!$this->form_validation->run()) {
            return $this->form_page($row, TRUE);
        }

        if (!$this->Master_product_model->update($id, $this->collect())) {
            $this->session->set_flashdata('error', 'Data barang gagal diperbarui.');
            redirect('master_product');
        }

        $this->session->set_flashdata('success', 'Data barang berhasil diperbarui.');
        redirect('master_product');
    }

    public function delete($id = 0)
    {
        if ($this->input->method() !== 'post') {
            return $this->json(array('status' => false, 'message' => 'Metode tidak diizinkan.'), 405);
        }

        if (!$this->Master_product_model->find($id)) {
            return $this->json(array('status' => false, 'message' => 'Data tidak ditemukan.'), 404);
        }

        if (!$this->Master_product_model->delete($id)) {   // soft delete (status = 0)
            return $this->json(array('status' => false, 'message' => 'Data barang gagal dihapus.'), 500);
        }

        $this->session->set_flashdata('success', 'Data barang berhasil dihapus.');
        return $this->json(array('status' => true, 'message' => 'Data barang berhasil dihapus.'));
    }

    // ------------------------------------------------------------ helpers
    private function form_page($row, $has_error = FALSE)
    {
        $is_edit = $row !== null;
        $errors  = $has_error ? $this->form_validation->error_array() : array();

        // Pilihan dropdown = data aktif. Bila barang ini memakai kategori/KIB yang sudah nonaktif,
        // pilihan itu tetap ditampilkan (diberi tanda) agar data lama tidak "hilang" saat edit.
        $categories = $this->Master_product_model->categories();
        $kibs       = $this->Master_product_model->kibs();
        if ($is_edit) {
            $categories = $this->with_current($categories, 'idmaster_category_product', $row['idmaster_category_product'],
                $row['category_code'], $row['category_name']);
            $kibs = $this->with_current($kibs, 'idmaster_kib', $row['idmaster_kib'],
                $row['kib_code'], $row['kib_name']);
        }

        $data = array(
            'row'           => $row,
            'is_edit'       => $is_edit,
            'errors'        => $errors,
            'categories'    => $categories,
            'kibs'          => $kibs,
            'service_types' => $this->service_types,
            'action'        => $is_edit
                ? site_url('master_product/update/' . $row['idmaster_product'])
                : site_url('master_product/store'),
        );

        $page_config = array(
            'title'            => $is_edit ? 'Edit Barang' : 'Tambah Barang',
            'page'             => 'master_product',
            'breadcrumb'       => array('Master Data', 'Master Barang', $is_edit ? 'Edit' : 'Tambah'),
            'breadcrumb_links' => array('master_product', 'master_product'),
            'page_data'        => $has_error ? array(
                'swalError'  => 'Periksa kembali isian Anda.',
                'formErrors' => $errors,
            ) : array(),
        );

        $this->render('master_product/form', $data, $page_config);
    }

    /** Tambahkan pilihan lama (yang nonaktif) ke daftar bila belum ada. $key = nama kolom id. */
    private function with_current($list, $key, $id, $code, $name)
    {
        foreach ($list as $item) {
            if ((int) $item[$key] === (int) $id) {
                return $list;
            }
        }
        $list[] = array($key => $id, 'code' => $code, 'name' => $name . ' (nonaktif)');
        return $list;
    }

    private function apply_rules($id)
    {
        // product_code di DB UNIQUE untuk SEMUA baris (termasuk status=0), jadi cek unik tanpa filter status
        $unique_code = $id
            ? 'edit_unique[master_product.product_code.' . $id . '.idmaster_product]'
            : 'is_unique[master_product.product_code]';

        $this->form_validation->set_rules(
            'product_code', 'Kode barang', 'trim|required|max_length[50]|alpha_dash|' . $unique_code,
            array(
                'alpha_dash'  => '%s hanya boleh berisi huruf, angka, strip (-) dan garis bawah (_).',
                'is_unique'   => '%s sudah dipakai.',
                'edit_unique' => '%s sudah dipakai.',
            )
        );
        $this->form_validation->set_rules('product_name', 'Nama barang', 'trim|required|max_length[200]');
        $this->form_validation->set_rules(
            'idmaster_category_product', 'Kategori barang', 'trim|required|callback_category_valid',
            array('required' => '%s wajib dipilih.')
        );
        $this->form_validation->set_rules(
            'idmaster_kib', 'KIB', 'trim|required|callback_kib_valid',
            array('required' => '%s wajib dipilih.')
        );
        $this->form_validation->set_rules(
            'service_type', 'Jenis penggunaan', 'trim|required|in_list[' . implode(',', array_keys($this->service_types)) . ']',
            array('required' => '%s wajib dipilih.', 'in_list' => '%s tidak valid.')
        );
        $this->form_validation->set_rules('brand', 'Merek', 'trim|max_length[100]');
        $this->form_validation->set_rules('model', 'Model', 'trim|max_length[100]');
        $this->form_validation->set_rules('unit_of_measure', 'Satuan', 'trim|max_length[30]');
        $this->form_validation->set_rules('description_product', 'Deskripsi', 'trim|max_length[2000]');
        $this->form_validation->set_rules('is_active', 'Status', 'trim|required|in_list[0,1]');
    }

    /** Kategori harus ada dan aktif (kecuali itu kategori lama barang ini sendiri). */
    public function category_valid($value)
    {
        $keep = $this->current ? $this->current['idmaster_category_product'] : null;
        if ($this->Master_product_model->category_usable($value, $keep)) {
            return TRUE;
        }
        $this->form_validation->set_message('category_valid', '%s tidak valid.');
        return FALSE;
    }

    /** KIB harus ada dan aktif (kecuali itu KIB lama barang ini sendiri). */
    public function kib_valid($value)
    {
        $keep = $this->current ? $this->current['idmaster_kib'] : null;
        if ($this->Master_product_model->kib_usable($value, $keep)) {
            return TRUE;
        }
        $this->form_validation->set_message('kib_valid', '%s tidak valid.');
        return FALSE;
    }

    private function collect()
    {
        $nullable = function ($v) {
            $v = trim((string) $v);
            return $v === '' ? NULL : $v;
        };

        $unit = $nullable($this->input->post('unit_of_measure', TRUE));

        return array(
            'product_code'              => strtoupper($this->input->post('product_code', TRUE)),
            'product_name'              => $this->input->post('product_name', TRUE),
            'idmaster_category_product' => (int) $this->input->post('idmaster_category_product'),
            'idmaster_kib'              => (int) $this->input->post('idmaster_kib'),
            'service_type'              => $this->input->post('service_type', TRUE),
            'brand'                     => $nullable($this->input->post('brand', TRUE)),
            'model'                     => $nullable($this->input->post('model', TRUE)),
            'unit_of_measure'           => $unit === null ? null : strtoupper($unit),
            'description_product'       => $nullable($this->input->post('description_product', TRUE)),
            'is_active'                 => (int) $this->input->post('is_active'),
        );
    }
}