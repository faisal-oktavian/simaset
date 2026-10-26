<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Master Master_acquisition_source - CRUD memakai popup modal (AJAX + SweetAlert).
 * Master Sumber Perolehan Aset
 */
class Master_acquisition_source extends Admin_Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->require_access('master_acquisition_source');
        $this->load->model('Master_acquisition_source_model');
    }

    // ------------------------------------------------------------ list
    public function index()
    {
        $data = array(
            'rows'        => $this->Master_acquisition_source_model->all(),
        );

        $page_config = array(
            'title'      => 'Master Sumber Perolehan Aset',
            'page'       => 'master_acquisition_source',
            'breadcrumb' => array('Master Data', 'Master Sumber Perolehan Aset'),
            'breadcrumb_links' => array('master_acquisition_source'),
        );
        
        $this->render('master_acquisition_source/index', $data, $page_config);
    }

    // ------------------------------------------------------------ refresh tabel (AJAX)
    public function table()
    {
        $data = array(
            'rows' => $this->Master_acquisition_source_model->all(),
        );

        $html = $this->load->view('master_acquisition_source/_rows', $data, TRUE);

        $this->output->set_content_type('text/html')->set_output($html);
    }

    // ------------------------------------------------------------ detail (untuk modal edit)
    public function get($id = 0)
    {
        $row = $this->Master_acquisition_source_model->find($id);

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
        $data['source_code'] = strtoupper(preg_replace('/[^A-Za-z0-9]/', '_', $data['source_name']));

        if (!$this->Master_acquisition_source_model->insert($data)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data sumber perolehan aset gagal disimpan.'
            ), 500);
        }

        $return = array(
            'status' => true, 
            'message' => 'Data Sumber Perolehan Aset berhasil ditambahkan.'
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

        $row = $this->Master_acquisition_source_model->find($id);
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
        $data['source_code'] = strtoupper(preg_replace('/[^A-Za-z0-9]/', '_', $data['source_name']));

        if (!$this->Master_acquisition_source_model->update($id, $data)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data sumber perolehan aset gagal diperbarui.'
            ), 500);
        }

        $return = array(
            'status' => true,
            'message' => 'Data Sumber Perolehan Aset berhasil diperbarui.'
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

        $row = $this->Master_acquisition_source_model->find($id);
        if (!$row) {
            $return = array(
                'status' => false,
                'message' => 'Data tidak ditemukan.'
            );

            return $this->json($return, 404);
        }

        if (!$this->Master_acquisition_source_model->delete($id)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data sumber perolehan aset gagal dihapus.'
            ), 500);
        }
        
        $return = array(
            'status' => true,
            'message' => 'Data Sumber Perolehan Aset berhasil dihapus.'
        );

        return $this->json($return);
    }

    // ============================================================ helpers
    private function apply_rules($id)
    {
        $this->form_validation->set_rules('source_name', 'Nama Sumber Perolehan', 'trim|required|max_length[100]');
        $this->form_validation->set_rules('description_source', 'Deskripsi sumber perolehan', 'trim|max_length[255]');
    }

    private function collect()
    {
        return array(
            'source_name'           => $this->input->post('source_name', TRUE),
            'description_source'    => $this->input->post('description_source', TRUE),
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
