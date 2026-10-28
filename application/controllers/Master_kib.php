<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Master Master_kib - CRUD memakai popup modal (AJAX + SweetAlert).
 * Master Kib
 */
class Master_kib extends Admin_Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->require_access('master_kib');
        $this->load->model('Master_kib_model');
    }

    // ------------------------------------------------------------ list
    public function index()
    {
        $data = array(
            'rows'        => $this->Master_kib_model->all(),
        );

        $page_config = array(
            'title'      => 'Master Kartu Inventaris Barang (KIB)',
            'page'       => 'master_kib',
            'breadcrumb' => array('Master Data', 'Master KIB'),
            'breadcrumb_links' => array('master_kib'),
        );
        
        $this->render('master_kib/index', $data, $page_config);
    }

    // ------------------------------------------------------------ refresh tabel (AJAX)
    public function table()
    {
        $data = array(
            'rows' => $this->Master_kib_model->all(),
        );

        $html = $this->load->view('master_kib/_rows', $data, TRUE);

        $this->output->set_content_type('text/html')->set_output($html);
    }

    // ------------------------------------------------------------ detail (untuk modal edit)
    public function get($id = 0)
    {
        $row = $this->Master_kib_model->find($id);

        if (!$row) {
            $return = array(
                'status' => false, 
                'message' => 'Data tidak ditemukan.'
            );

            return $this->json($return, 404);
        }

        $return = array(
            'status' => true, 
            'data' => $row
        );

        return $this->json($return);
    }

    // ------------------------------------------------------------ create
    public function store()
    {
        if ($this->input->method() !== 'post') {
            $return = array(
                'status' => false, 
                'message' => 'Metode tidak diizinkan.'
            );

            return $this->json($return, 405);
        }

        $this->apply_rules(0);
        if (!$this->form_validation->run()) {
            return $this->validation_failed();
        }

        $data = $this->collect();

        if (!$this->Master_kib_model->insert($data)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data KIB gagal disimpan.'
            ), 500);
        }

        $return = array(
            'status' => true, 
            'message' => 'Data KIB berhasil ditambahkan.'
        );

        return $this->json($return);
    }

    // ------------------------------------------------------------ update
    public function update($id = 0)
    {
        if ($this->input->method() !== 'post') {
            $return = array(
                'status' => false,
                'message' => 'Metode tidak diizinkan.'
            );

            return $this->json($return, 405);
        }

        $row = $this->Master_kib_model->find($id);
        if (!$row) {
            $return = array(
                'status' => false,
                'message' => 'Data tidak ditemukan.'
            );

            return $this->json($return, 404);
        }

        $this->apply_rules((int) $id);
        if (!$this->form_validation->run()) {
            return $this->validation_failed();
        }

        $data = $this->collect();

        if (!$this->Master_kib_model->update($id, $data)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data KIB gagal diperbarui.'
            ), 500);
        }

        $return = array(
            'status' => true,
            'message' => 'Data KIB berhasil diperbarui.'
        );

        return $this->json($return);
    }

    // ------------------------------------------------------------ delete
    public function delete($id = 0)
    {
        if ($this->input->method() !== 'post') {
            $return = array(
                'status' => false,
                'message' => 'Metode tidak diizinkan.'
            );

            return $this->json($return, 405);
        }

        $row = $this->Master_kib_model->find($id);
        if (!$row) {
            $return = array(
                'status' => false,
                'message' => 'Data tidak ditemukan.'
            );

            return $this->json($return, 404);
        }

        if (!$this->Master_kib_model->delete($id)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data KIB gagal dihapus.'
            ), 500);
        }
        
        $return = array(
            'status' => true,
            'message' => 'Data KIB berhasil dihapus.'
        );

        return $this->json($return);
    }

    // ============================================================ helpers
    private function apply_rules($id)
    {
        $this->form_validation->set_rules('kib_code', 'Kode KIB', 'trim|required|max_length[100]');
        $this->form_validation->set_rules('kib_name', 'Nama KIB', 'trim|required|max_length[100]');
        $this->form_validation->set_rules('description_kib', 'Deskripsi KIB', 'trim|max_length[255]');
    }

    private function collect()
    {
        return array(
            'kib_code'         => $this->input->post('kib_code', TRUE),
            'kib_name'         => $this->input->post('kib_name', TRUE),
            'description_kib'  => $this->input->post('description_kib', TRUE),
            'is_active'             => $this->input->post('is_active') ? 1 : 0,
        );
    }

    private function validation_failed($extra = array())
    {
        $errors = array_merge($this->form_validation->error_array(), $extra);
        return $this->json(array(
            'status'  => false,
            'message' => 'Periksa kembali isian Anda.',
            'errors'  => $errors,
        ), 422);
    }
}
