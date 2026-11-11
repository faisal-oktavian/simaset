<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Master Vendor - CRUD dengan halaman terpisah (list, tambah, edit), pola sama dengan Supplier.
 */
class Master_vendor extends Admin_Controller
{
    /** Pilihan jenis vendor (kunci disimpan ke DB). */
    private $types = array(
        'MEDICAL'  => 'Alat Kesehatan',
        'IT'       => 'Teknologi Informasi',
        'BUILDING' => 'Bangunan / Sarana',
        'OTHER'    => 'Lainnya',
    );

    public function __construct()
    {
        parent::__construct();
        $this->require_access('master_vendor');
        $this->load->model('Master_vendor_model');
    }

    public function index()
    {
        $data = array(
            'rows'  => $this->Master_vendor_model->all(),
            'types' => $this->types,
        );

        $page_config = array(
            'title'            => 'Master Vendor',
            'page'             => 'master_vendor',
            'breadcrumb'       => array('Master Data', 'Master Vendor'),
            'breadcrumb_links' => array('master_vendor'),
            'page_data'        => array(
                'success' => $this->session->flashdata('success'),
                'error'   => $this->session->flashdata('error'),
            ),
        );

        $this->render('master_vendor/index', $data, $page_config);
    }

    public function create()
    {
        $this->form_page(null);
    }

    public function store()
    {
        if ($this->input->method() !== 'post') {
            redirect('master_vendor');
        }

        $this->apply_rules();
        if (!$this->form_validation->run()) {
            return $this->form_page(null, TRUE);
        }

        $data = $this->collect();
        $data['vendor_code'] = $this->Master_vendor_model->next_code(); // otomatis: VEN-001, VEN-002, ...

        if (!$this->Master_vendor_model->insert($data)) {
            $this->session->set_flashdata('error', 'Data vendor gagal disimpan.');
            redirect('master_vendor');
        }

        $this->session->set_flashdata('success', 'Data vendor berhasil ditambahkan.');
        redirect('master_vendor');
    }

    public function edit($id = 0)
    {
        $row = $this->Master_vendor_model->find($id);
        if (!$row) {
            $this->session->set_flashdata('error', 'Data vendor tidak ditemukan.');
            redirect('master_vendor');
        }
        $this->form_page($row);
    }

    public function update($id = 0)
    {
        if ($this->input->method() !== 'post') {
            redirect('master_vendor');
        }

        $row = $this->Master_vendor_model->find($id);
        if (!$row) {
            $this->session->set_flashdata('error', 'Data vendor tidak ditemukan.');
            redirect('master_vendor');
        }

        $this->apply_rules();
        if (!$this->form_validation->run()) {
            return $this->form_page($row, TRUE);
        }

        // kode vendor tidak ikut diubah
        if (!$this->Master_vendor_model->update($id, $this->collect())) {
            $this->session->set_flashdata('error', 'Data vendor gagal diperbarui.');
            redirect('master_vendor');
        }

        $this->session->set_flashdata('success', 'Data vendor berhasil diperbarui.');
        redirect('master_vendor');
    }

    public function delete($id = 0)
    {
        if ($this->input->method() !== 'post') {
            return $this->json(array('status' => false, 'message' => 'Metode tidak diizinkan.'), 405);
        }

        if (!$this->Master_vendor_model->find($id)) {
            return $this->json(array('status' => false, 'message' => 'Data tidak ditemukan.'), 404);
        }

        if (!$this->Master_vendor_model->delete($id)) {   // soft delete (status = 0)
            return $this->json(array('status' => false, 'message' => 'Data vendor gagal dihapus.'), 500);
        }

        $this->session->set_flashdata('success', 'Data vendor berhasil dihapus.');
        return $this->json(array('status' => true, 'message' => 'Data vendor berhasil dihapus.'));
    }

    // ------------------------------------------------------------ helpers
    private function form_page($row, $has_error = FALSE)
    {
        $is_edit = $row !== null;

        $data = array(
            'row'       => $row,
            'is_edit'   => $is_edit,
            'types'     => $this->types,
            'next_code' => $is_edit ? $row['vendor_code'] : $this->Master_vendor_model->next_code(),
            'action'    => $is_edit
                ? site_url('master_vendor/update/' . $row['idmaster_vendor'])
                : site_url('master_vendor/store'),
        );

        $page_config = array(
            'title'            => $is_edit ? 'Edit Vendor' : 'Tambah Vendor',
            'page'             => 'master_vendor',
            'breadcrumb'       => array('Master Data', 'Master Vendor', $is_edit ? 'Edit' : 'Tambah'),
            'breadcrumb_links' => array('master_vendor', 'master_vendor'),
            'page_data'        => $has_error ? array(
                'swalError'  => 'Periksa kembali isian Anda.',
                'formErrors' => $this->form_validation->error_array(),
            ) : array(),
        );

        $this->render('master_vendor/form', $data, $page_config);
    }

    private function apply_rules()
    {
        $this->form_validation->set_rules('vendor_name', 'Nama vendor', 'trim|required|max_length[200]');
        $this->form_validation->set_rules(
            'vendor_type', 'Jenis vendor', 'trim|in_list[' . implode(',', array_keys($this->types)) . ']',
            array('in_list' => '%s tidak valid.')
        );
        $this->form_validation->set_rules('contact_person', 'Kontak person', 'trim|max_length[100]');
        $this->form_validation->set_rules(
            'phone', 'Telepon', 'trim|max_length[50]|regex_match[/^[0-9+()\-\s]*$/]',
            array('regex_match' => '%s hanya boleh berisi angka, spasi, +, -, dan tanda kurung.')
        );
        $this->form_validation->set_rules('email', 'Email', 'trim|valid_email|max_length[100]');
        $this->form_validation->set_rules('address', 'Alamat', 'trim|max_length[255]');
        $this->form_validation->set_rules('description_vendor', 'Keterangan', 'trim|max_length[255]');
        $this->form_validation->set_rules('is_active', 'Status', 'trim|required|in_list[0,1]');
    }

    private function collect()
    {
        // string kosong disimpan sebagai NULL untuk kolom yang boleh kosong
        $nullable = function ($v) {
            $v = trim((string) $v);
            return $v === '' ? NULL : $v;
        };

        return array(
            'vendor_name'        => $this->input->post('vendor_name', TRUE),
            'vendor_type'        => $nullable($this->input->post('vendor_type', TRUE)),
            'address'            => $nullable($this->input->post('address', TRUE)),
            'phone'              => $nullable($this->input->post('phone', TRUE)),
            'email'              => $nullable($this->input->post('email', TRUE)),
            'contact_person'     => $nullable($this->input->post('contact_person', TRUE)),
            'description_vendor' => $nullable($this->input->post('description_vendor', TRUE)),
            'is_active'          => (int) $this->input->post('is_active'),
        );
    }
}