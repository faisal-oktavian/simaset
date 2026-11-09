<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Master Master_room - CRUD memakai popup modal (AJAX + SweetAlert).
 * Master Ruangan
 */
class Master_room extends Admin_Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->require_access('master_room');
        $this->load->model('Master_room_model');
        $this->load->model('Master_unit_model');
        $this->load->model('Master_building_model');
    }

    // ------------------------------------------------------------ list
    public function index()
    {
        $data = array(
            'rows'        => $this->Master_room_model->all(),
            'units'       => $this->Master_unit_model->all(),
            'buildings'   => $this->Master_building_model->all(),
        );

        $page_config = array(
            'title'      => 'Master Ruangan',
            'page'       => 'master_room',
            'breadcrumb' => array('Master Data', 'Master Ruangan'),
            'breadcrumb_links' => array('master_room'),
        );
        
        $this->render('master_room/index', $data, $page_config);
    }

    // ------------------------------------------------------------ refresh tabel (AJAX)
    public function table()
    {
        $data = array(
            'rows' => $this->Master_room_model->all(),
        );

        $html = $this->load->view('master_room/_rows', $data, TRUE);

        $this->output->set_content_type('text/html')->set_output($html);
    }

    // ------------------------------------------------------------ detail (untuk modal edit)
    public function get($id = 0)
    {
        $row = $this->Master_room_model->find($id);

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
        if (!$this->valid_building()) {
            return $this->validation_failed(array(
                'idmaster_building' => 'Gedung yang dipilih tidak valid.',
            ));
        }

        $data = $this->collect();

        if (!$this->Master_room_model->insert($data)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data Ruangan gagal disimpan.'
            ), 500);
        }

        $return = array(
            'status' => true, 
            'message' => 'Data Ruangan berhasil ditambahkan.'
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

        $row = $this->Master_room_model->find($id);
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
        if (!$this->valid_building()) {
            return $this->validation_failed(array(
                'idmaster_building' => 'Gedung yang dipilih tidak valid.',
            ));
        }

        $data = $this->collect();

        if (!$this->Master_room_model->update($id, $data)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data Ruangan gagal diperbarui.'
            ), 500);
        }

        $return = array(
            'status' => true,
            'message' => 'Data Ruangan berhasil diperbarui.'
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

        $row = $this->Master_room_model->find($id);
        if (!$row) {
            $return = array(
                'status' => false,
                'message' => 'Data tidak ditemukan.'
            );

            return $this->json($return, 404);
        }

        if (!$this->Master_room_model->delete($id)) {
            return $this->json(array(
                'status' => false,
                'message' => 'Data Ruangan gagal dihapus.'
            ), 500);
        }
        
        $return = array(
            'status' => true,
            'message' => 'Data Ruangan berhasil dihapus.'
        );

        return $this->json($return);
    }

    // ============================================================ helpers
    private function apply_rules($id)
    {
        $this->form_validation->set_rules('idmaster_building', 'Gedung', 'trim|integer');
        $this->form_validation->set_rules('idmaster_unit', 'Unit', 'trim|integer');
        $this->form_validation->set_rules('room_code', 'Kode room', 'trim|required|max_length[100]');
        $this->form_validation->set_rules('room_name', 'Nama room', 'trim|required|max_length[100]');
    }

    private function collect()
    {
        $unit_id = $this->input->post('idmaster_unit');
        $building_id = $this->input->post('idmaster_building');

        return array(
            'room_code'         => $this->input->post('room_code', TRUE),
            'room_name'         => $this->input->post('room_name', TRUE),
            'idmaster_unit'     => $unit_id === '' || $unit_id === null ? null : (int) $unit_id,
            'idmaster_building' => $building_id === '' || $building_id === null ? null : (int) $building_id,
            'is_active'         => $this->input->post('is_active') ? 1 : 0,
        );
    }

    private function valid_unit()
    {
        $unit_id = $this->input->post('idmaster_unit');

        return $unit_id === '' || $unit_id === null || (bool) $this->Master_unit_model->find($unit_id);
    }

    private function valid_building()
    {
        $building_id = $this->input->post('idmaster_building');

        return $building_id === '' || $building_id === null || (bool) $this->Master_building_model->find($building_id);
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
