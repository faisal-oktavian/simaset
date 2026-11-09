<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Master Master_technical_team - CRUD memakai popup modal (AJAX + SweetAlert).
 * Master Technical Team
 */
class Master_technical_team extends Admin_Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->require_access('master_technical_team');
        $this->load->model('Master_technical_team_model');
        $this->load->model('Master_unit_model');
    }

    // ------------------------------------------------------------ list
    public function index()
    {
        $data = array(
            'rows'        => $this->Master_technical_team_model->all(),
            'units'       => $this->Master_unit_model->all(),
        );

        $page_config = array(
            'title'      => 'Master Tim Teknis',
            'page'       => 'master_technical_team',
            'breadcrumb' => array('Master Data', 'Master Tim Teknis'),
            'breadcrumb_links' => array('master_technical_team'),
        );
        
        $this->render('master_technical_team/index', $data, $page_config);
    }

    // ------------------------------------------------------------ refresh tabel (AJAX)
    public function table()
    {
        $data = array(
            'rows' => $this->Master_technical_team_model->all(),
        );

        $html = $this->load->view('master_technical_team/_rows', $data, TRUE);

        $this->output->set_content_type('text/html')->set_output($html);
    }

    // ------------------------------------------------------------ detail (untuk modal edit)
    public function get($id = 0)
    {
        $row = $this->Master_technical_team_model->find($id);

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
        if (!$this->valid_unit()) {
            return $this->validation_failed(array(
                'idmaster_unit' => 'Unit yang dipilih tidak valid.',
            ));
        }

        $data = $this->collect();

        if (!$this->Master_technical_team_model->insert($data)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data Technical Team gagal disimpan.'
            ), 500);
        }

        $return = array(
            'status' => true, 
            'message' => 'Data Technical Team berhasil ditambahkan.'
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

        $row = $this->Master_technical_team_model->find($id);
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
        if (!$this->valid_unit()) {
            return $this->validation_failed(array(
                'idmaster_unit' => 'Unit yang dipilih tidak valid.',
            ));
        }

        $data = $this->collect();

        if (!$this->Master_technical_team_model->update($id, $data)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data Technical Team gagal diperbarui.'
            ), 500);
        }

        $return = array(
            'status' => true,
            'message' => 'Data Technical Team berhasil diperbarui.'
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

        $row = $this->Master_technical_team_model->find($id);
        if (!$row) {
            $return = array(
                'status' => false,
                'message' => 'Data tidak ditemukan.'
            );

            return $this->json($return, 404);
        }

        if (!$this->Master_technical_team_model->delete($id)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data Technical Team gagal dihapus.'
            ), 500);
        }
        
        $return = array(
            'status' => true,
            'message' => 'Data Technical Team berhasil dihapus.'
        );

        return $this->json($return);
    }

    // ============================================================ helpers
    private function apply_rules($id)
    {
        $this->form_validation->set_rules('team_code', 'Kode team', 'trim|required|max_length[100]');
        $this->form_validation->set_rules('team_name', 'Nama team', 'trim|required|max_length[100]');
        $this->form_validation->set_rules('team_scope', 'Ruang lingkup', 'trim|max_length[255]');
        $this->form_validation->set_rules('idmaster_unit', 'Unit', 'trim|integer');
    }

    private function collect()
    {
        $unit_id = $this->input->post('idmaster_unit');

        return array(
            'team_code'         => $this->input->post('team_code', TRUE),
            'team_name'         => $this->input->post('team_name', TRUE),
            'team_scope'        => $this->input->post('team_scope', TRUE),
            'idmaster_unit'     => $unit_id === '' || $unit_id === null ? null : (int) $unit_id,
            'is_active'         => $this->input->post('is_active') ? 1 : 0,
        );
    }

    private function valid_unit()
    {
        $unit_id = $this->input->post('idmaster_unit');

        return $unit_id === '' || $unit_id === null || (bool) $this->Master_unit_model->find($unit_id);
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
