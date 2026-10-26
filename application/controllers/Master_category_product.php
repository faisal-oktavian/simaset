<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Master Master_category_product - CRUD memakai popup modal (AJAX + SweetAlert).
 * Master Kelompok Aset
 */
class Master_category_product extends Admin_Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->require_access('master_category_product');
        $this->load->model('Master_category_product_model');
    }

    // ------------------------------------------------------------ list
    public function index()
    {
        $data = array(
            'rows'        => $this->Master_category_product_model->all(),
        );

        $page_config = array(
            'title'      => 'Master Kelompok Aset',
            'page'       => 'master_category_product',
            'breadcrumb' => array('Master Data', 'Master Kelompok Aset'),
            'breadcrumb_links' => array('master_category_product'),
        );
        
        $this->render('master_category_product/index', $data, $page_config);
    }

    // ------------------------------------------------------------ refresh tabel (AJAX)
    public function table()
    {
        $data = array(
            'rows' => $this->Master_category_product_model->all(),
        );

        $html = $this->load->view('master_category_product/_rows', $data, TRUE);

        $this->output->set_content_type('text/html')->set_output($html);
    }

    // ------------------------------------------------------------ detail (untuk modal edit)
    public function get($id = 0)
    {
        $row = $this->Master_category_product_model->find($id);

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
        $data['category_code'] = strtoupper(preg_replace('/[^A-Za-z0-9]/', '_', $data['category_name']));

        if (!$this->Master_category_product_model->insert($data)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data Kelompok Aset gagal disimpan.'
            ), 500);
        }

        $return = array(
            'status' => true, 
            'message' => 'Data Kelompok Aset berhasil ditambahkan.'
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

        $row = $this->Master_category_product_model->find($id);
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
        $data['category_code'] = strtoupper(preg_replace('/[^A-Za-z0-9]/', '_', $data['category_name']));

        if (!$this->Master_category_product_model->update($id, $data)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data Kelompok Aset gagal diperbarui.'
            ), 500);
        }

        $return = array(
            'status' => true,
            'message' => 'Data Kelompok Aset berhasil diperbarui.'
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

        $row = $this->Master_category_product_model->find($id);
        if (!$row) {
            $return = array(
                'status' => false,
                'message' => 'Data tidak ditemukan.'
            );

            return $this->json($return, 404);
        }

        if (!$this->Master_category_product_model->delete($id)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data Kelompok Aset gagal dihapus.'
            ), 500);
        }
        
        $return = array(
            'status' => true,
            'message' => 'Data Kelompok Aset berhasil dihapus.'
        );

        return $this->json($return);
    }

    // ============================================================ helpers
    private function apply_rules($id)
    {
        $this->form_validation->set_rules('category_name', 'Nama Kelompok Aset', 'trim|required|max_length[100]');
        $this->form_validation->set_rules('description_category', 'Deskripsi Kelompok Aset', 'trim|max_length[255]');
    }

    private function collect()
    {
        return array(
            'category_name'         => $this->input->post('category_name', TRUE),
            'description_category'  => $this->input->post('description_category', TRUE),
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
