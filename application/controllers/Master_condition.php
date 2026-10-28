<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Master Master_condition - CRUD memakai popup modal (AJAX + SweetAlert).
 * Master Condition
 */
class Master_condition extends Admin_Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->require_access('master_condition');
        $this->load->model('Master_condition_model');
    }

    // ------------------------------------------------------------ list
    public function index()
    {
        $data = array(
            'rows'        => $this->Master_condition_model->all(),
        );

        $page_config = array(
            'title'      => 'Master Kondisi Aset',
            'page'       => 'master_condition',
            'breadcrumb' => array('Master Data', 'Master Kondisi'),
            'breadcrumb_links' => array('master_condition'),
        );
        
        $this->render('master_condition/index', $data, $page_config);
    }

    // ------------------------------------------------------------ refresh tabel (AJAX)
    public function table()
    {
        $data = array(
            'rows' => $this->Master_condition_model->all(),
        );

        $html = $this->load->view('master_condition/_rows', $data, TRUE);

        $this->output->set_content_type('text/html')->set_output($html);
    }

    // ------------------------------------------------------------ detail (untuk modal edit)
    public function get($id = 0)
    {
        $row = $this->Master_condition_model->find($id);

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
        $data['condition_code'] = strtoupper(preg_replace('/[^A-Za-z0-9]/', '_', $data['condition_name']));

        if (!$this->Master_condition_model->insert($data)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data Kondisi gagal disimpan.'
            ), 500);
        }

        $return = array(
            'status' => true, 
            'message' => 'Data Kondisi berhasil ditambahkan.'
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

        $row = $this->Master_condition_model->find($id);
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
        $data['condition_code'] = strtoupper(preg_replace('/[^A-Za-z0-9]/', '_', $data['condition_name']));

        if (!$this->Master_condition_model->update($id, $data)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data kondisi gagal diperbarui.'
            ), 500);
        }

        $return = array(
            'status' => true,
            'message' => 'Data kondisi berhasil diperbarui.'
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

        $row = $this->Master_condition_model->find($id);
        if (!$row) {
            $return = array(
                'status' => false,
                'message' => 'Data tidak ditemukan.'
            );

            return $this->json($return, 404);
        }

        if (!$this->Master_condition_model->delete($id)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data kondisi gagal dihapus.'
            ), 500);
        }
        
        $return = array(
            'status' => true,
            'message' => 'Data kondisi berhasil dihapus.'
        );

        return $this->json($return);
    }

    // ============================================================ helpers
    private function apply_rules($id)
    {
        $this->form_validation->set_rules('condition_name', 'Nama Kondisi', 'trim|required|max_length[100]');
        $this->form_validation->set_rules('description_condition', 'Deskripsi Kondisi', 'trim|max_length[255]');
    }

    private function collect()
    {
        return array(
            'condition_name'         => $this->input->post('condition_name', TRUE),
            'description_condition'  => $this->input->post('description_condition', TRUE),
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
