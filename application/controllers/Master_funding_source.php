<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Master Master_funding_source - CRUD memakai popup modal (AJAX + SweetAlert).
 * Master Sumber Dana
 */
class Master_funding_source extends Admin_Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->require_access('master_funding_source');
        $this->load->model('Master_funding_source_model');
    }

    // ------------------------------------------------------------ list
    public function index()
    {
        $data = array(
            'rows'        => $this->Master_funding_source_model->all(),
        );

        $page_config = array(
            'title'      => 'Master Sumber Dana',
            'page'       => 'master_funding_source',
            'breadcrumb' => array('Master Data', 'Master Sumber Dana'),
            'breadcrumb_links' => array('master_funding_source'),
        );
        
        $this->render('master_funding_source/index', $data, $page_config);
    }

    // ------------------------------------------------------------ refresh tabel (AJAX)
    public function table()
    {
        $data = array(
            'rows' => $this->Master_funding_source_model->all(),
        );

        $html = $this->load->view('master_funding_source/_rows', $data, TRUE);

        $this->output->set_content_type('text/html')->set_output($html);
    }

    // ------------------------------------------------------------ detail (untuk modal edit)
    public function get($id = 0)
    {
        $row = $this->Master_funding_source_model->find($id);

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
        $data['funding_code'] = strtoupper(preg_replace('/[^A-Za-z0-9]/', '_', $data['funding_name']));

        if (!$this->Master_funding_source_model->insert($data)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data Sumber Dana gagal disimpan.'
            ), 500);
        }

        $return = array(
            'status' => true, 
            'message' => 'Data Sumber Dana berhasil ditambahkan.'
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

        $row = $this->Master_funding_source_model->find($id);
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
        $data['funding_code'] = strtoupper(preg_replace('/[^A-Za-z0-9]/', '_', $data['funding_name']));

        if (!$this->Master_funding_source_model->update($id, $data)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data Sumber Dana gagal diperbarui.'
            ), 500);
        }

        $return = array(
            'status' => true,
            'message' => 'Data Sumber Dana berhasil diperbarui.'
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

        $row = $this->Master_funding_source_model->find($id);
        if (!$row) {
            $return = array(
                'status' => false,
                'message' => 'Data tidak ditemukan.'
            );

            return $this->json($return, 404);
        }

        if (!$this->Master_funding_source_model->delete($id)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data Sumber Dana gagal dihapus.'
            ), 500);
        }
        
        $return = array(
            'status' => true,
            'message' => 'Data Sumber Dana berhasil dihapus.'
        );

        return $this->json($return);
    }

    // ============================================================ helpers
    private function apply_rules($id)
    {
        $this->form_validation->set_rules('funding_name', 'Nama Sumber Dana', 'trim|required|max_length[100]');
        $this->form_validation->set_rules('description_funding', 'Deskripsi Sumber Dana', 'trim|max_length[255]');
    }

    private function collect()
    {
        return array(
            'funding_name'          => $this->input->post('funding_name', TRUE),
            'description_funding'   => $this->input->post('description_funding', TRUE),
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
