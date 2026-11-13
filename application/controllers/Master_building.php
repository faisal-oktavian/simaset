<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Master Gedung - CRUD dengan halaman terpisah (list, tambah, edit), pola sama dengan Supplier.
 * Koordinat (latitude/longitude) dipilih lewat peta di halaman form.
 */
class Master_building extends Admin_Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->require_access('master_building');
        $this->load->model('Master_building_model');
    }

    public function index()
    {
        $data = array(
            'rows' => $this->Master_building_model->all(),
        );

        $page_config = array(
            'title'            => 'Master Gedung',
            'page'             => 'master_building',
            'breadcrumb'       => array('Master Data', 'Master Gedung'),
            'breadcrumb_links' => array('master_building'),
            'page_data'        => array(
                'success' => $this->session->flashdata('success'),
                'error'   => $this->session->flashdata('error'),
            ),
        );

        $this->render('master_building/index', $data, $page_config);
    }

    public function create()
    {
        $this->form_page(null);
    }

    public function store()
    {
        if ($this->input->method() !== 'post') {
            redirect('master_building');
        }

        $this->apply_rules(0);
        $valid = $this->form_validation->run();
        $extra = $this->coordinate_errors();
        if (!$valid || $extra) {
            return $this->form_page(null, TRUE, $extra);
        }

        if (!$this->Master_building_model->insert($this->collect())) {
            $this->session->set_flashdata('error', 'Data gedung gagal disimpan.');
            redirect('master_building');
        }

        $this->session->set_flashdata('success', 'Data gedung berhasil ditambahkan.');
        redirect('master_building');
    }

    public function edit($id = 0)
    {
        $row = $this->Master_building_model->find($id);
        if (!$row) {
            $this->session->set_flashdata('error', 'Data gedung tidak ditemukan.');
            redirect('master_building');
        }
        $this->form_page($row);
    }

    public function update($id = 0)
    {
        if ($this->input->method() !== 'post') {
            redirect('master_building');
        }

        $row = $this->Master_building_model->find($id);
        if (!$row) {
            $this->session->set_flashdata('error', 'Data gedung tidak ditemukan.');
            redirect('master_building');
        }

        $this->apply_rules((int) $id);
        $valid = $this->form_validation->run();
        $extra = $this->coordinate_errors();
        if (!$valid || $extra) {
            return $this->form_page($row, TRUE, $extra);
        }

        if (!$this->Master_building_model->update($id, $this->collect())) {
            $this->session->set_flashdata('error', 'Data gedung gagal diperbarui.');
            redirect('master_building');
        }

        $this->session->set_flashdata('success', 'Data gedung berhasil diperbarui.');
        redirect('master_building');
    }

    public function delete($id = 0)
    {
        if ($this->input->method() !== 'post') {
            return $this->json(array('status' => false, 'message' => 'Metode tidak diizinkan.'), 405);
        }

        if (!$this->Master_building_model->find($id)) {
            return $this->json(array('status' => false, 'message' => 'Data tidak ditemukan.'), 404);
        }

        if (!$this->Master_building_model->delete($id)) {   // soft delete (status = 0)
            return $this->json(array('status' => false, 'message' => 'Data gedung gagal dihapus.'), 500);
        }

        $this->session->set_flashdata('success', 'Data gedung berhasil dihapus.');
        return $this->json(array('status' => true, 'message' => 'Data gedung berhasil dihapus.'));
    }

    // ------------------------------------------------------------ helpers
    private function form_page($row, $has_error = FALSE, $extra_errors = array())
    {
        $is_edit = $row !== null;
        $errors  = $has_error ? array_merge($this->form_validation->error_array(), $extra_errors) : array();

        $data = array(
            'row'     => $row,
            'is_edit' => $is_edit,
            'errors'  => $errors,
            'action'  => $is_edit
                ? site_url('master_building/update/' . $row['idmaster_building'])
                : site_url('master_building/store'),
        );

        $page_config = array(
            'title'            => $is_edit ? 'Edit Gedung' : 'Tambah Gedung',
            'page'             => 'master_building',
            'breadcrumb'       => array('Master Data', 'Master Gedung', $is_edit ? 'Edit' : 'Tambah'),
            'breadcrumb_links' => array('master_building', 'master_building'),
            'page_data'        => $has_error ? array(
                'swalError'  => 'Periksa kembali isian Anda.',
                'formErrors' => $errors,
            ) : array(),
        );

        $this->render('master_building/form', $data, $page_config);
    }

    private function apply_rules($id)
    {
        // building_code di DB UNIQUE untuk SEMUA baris (termasuk status=0), jadi cek unik tanpa filter status
        $unique_code = $id
            ? 'edit_unique[master_building.building_code.' . $id . '.idmaster_building]'
            : 'is_unique[master_building.building_code]';

        $this->form_validation->set_rules(
            'building_code', 'Kode gedung', 'trim|required|max_length[30]|alpha_dash|' . $unique_code,
            array(
                'alpha_dash'  => '%s hanya boleh berisi huruf, angka, strip (-) dan garis bawah (_).',
                'is_unique'   => '%s sudah dipakai.',
                'edit_unique' => '%s sudah dipakai.',
            )
        );
        $this->form_validation->set_rules('building_name', 'Nama gedung', 'trim|required|max_length[150]');
        $this->form_validation->set_rules(
            'latitude', 'Latitude', 'trim|numeric|greater_than_equal_to[-90]|less_than_equal_to[90]',
            array(
                'numeric'               => '%s harus berupa angka.',
                'greater_than_equal_to' => '%s harus antara -90 dan 90.',
                'less_than_equal_to'    => '%s harus antara -90 dan 90.',
            )
        );
        $this->form_validation->set_rules(
            'longitude', 'Longitude', 'trim|numeric|greater_than_equal_to[-180]|less_than_equal_to[180]',
            array(
                'numeric'               => '%s harus berupa angka.',
                'greater_than_equal_to' => '%s harus antara -180 dan 180.',
                'less_than_equal_to'    => '%s harus antara -180 dan 180.',
            )
        );
        $this->form_validation->set_rules('description_building', 'Deskripsi', 'trim|max_length[255]');
        $this->form_validation->set_rules('is_active', 'Status', 'trim|required|in_list[0,1]');
    }

    /** Latitude dan longitude harus diisi berpasangan. */
    private function coordinate_errors()
    {
        $lat = trim((string) $this->input->post('latitude'));
        $lng = trim((string) $this->input->post('longitude'));
        $errors = array();

        if ($lat !== '' && $lng === '') {
            $errors['longitude'] = 'Longitude wajib diisi jika latitude diisi.';
        }
        if ($lng !== '' && $lat === '') {
            $errors['latitude'] = 'Latitude wajib diisi jika longitude diisi.';
        }

        return $errors;
    }

    private function collect()
    {
        $nullable = function ($v) {
            $v = trim((string) $v);
            return $v === '' ? NULL : $v;
        };
        $coord = function ($v) {   // simpan 7 digit desimal sesuai decimal(10,7)
            $v = trim((string) $v);
            return $v === '' ? NULL : number_format((float) $v, 7, '.', '');
        };

        return array(
            'building_code'        => strtoupper($this->input->post('building_code', TRUE)),
            'building_name'        => $this->input->post('building_name', TRUE),
            'latitude'             => $coord($this->input->post('latitude')),
            'longitude'            => $coord($this->input->post('longitude')),
            'description_building' => $nullable($this->input->post('description_building', TRUE)),
            'is_active'            => (int) $this->input->post('is_active'),
        );
    }
}