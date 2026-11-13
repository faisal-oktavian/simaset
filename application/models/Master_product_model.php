<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Master_product_model extends CI_Model
{
    protected $table = 'master_product';

    /** Kolom status ada di semua tabel, jadi selalu dikualifikasi (t.status). */
    private function base_query()
    {
        $this->db->select(
            't.idmaster_product, t.product_code, t.product_name, t.idmaster_category_product, t.idmaster_kib, '
            . 't.service_type, t.brand, t.model, t.unit_of_measure, t.description_product, t.is_active, '
            . 'c.category_code, c.category_name, k.kib_code, k.kib_name'
        );
        $this->db->from($this->table . ' t');
        $this->db->join('master_category_product c', 'c.idmaster_category_product = t.idmaster_category_product', 'left');
        $this->db->join('master_kib k', 'k.idmaster_kib = t.idmaster_kib', 'left');
        $this->db->where('t.status', 1);
    }

    public function all()
    {
        $this->base_query();
        $this->db->order_by('t.idmaster_product', 'DESC');
        return $this->db->get()->result_array();
    }

    public function find($id)
    {
        $this->base_query();
        $this->db->where('t.idmaster_product', (int) $id);
        $this->db->limit(1);
        return $this->db->get()->row_array();
    }

    /** Pilihan dropdown Kategori: hanya yang aktif. Kolom 'code' & 'name' dipakai view. */
    public function categories()
    {
        $this->db->select('idmaster_category_product, category_code AS code, category_name AS name');
        $this->db->where('status', 1);
        $this->db->where('is_active', 1);
        $this->db->order_by('category_name', 'ASC');
        return $this->db->get('master_category_product')->result_array();
    }

    /** Pilihan dropdown KIB: hanya yang aktif. */
    public function kibs()
    {
        $this->db->select('idmaster_kib, kib_code AS code, kib_name AS name');
        $this->db->where('status', 1);
        $this->db->where('is_active', 1);
        $this->db->order_by('kib_code', 'ASC');
        return $this->db->get('master_kib')->result_array();
    }

    /** Boleh dipakai bila ada, belum dihapus, dan aktif - atau sama dengan nilai lama barang yang diedit. */
    public function category_usable($id, $keep_id = null)
    {
        return $this->usable('master_category_product', 'idmaster_category_product', $id, $keep_id);
    }

    public function kib_usable($id, $keep_id = null)
    {
        return $this->usable('master_kib', 'idmaster_kib', $id, $keep_id);
    }

    private function usable($table, $pk, $id, $keep_id)
    {
        $row = $this->db->select('is_active')->where($pk, (int) $id)->where('status', 1)->limit(1)->get($table)->row();
        if (!$row) {
            return FALSE;
        }
        return (int) $row->is_active === 1 || ($keep_id !== null && (int) $keep_id === (int) $id);
    }

    public function insert($data)
    {
        $data['created']   = date('Y-m-d H:i:s');
        $data['createdby'] = $this->session->userdata('user_nama');
        $data['updated']   = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');

        $this->db->insert($this->table, $data);
        return $this->db->insert_id();
    }

    public function update($id, $data)
    {
        $data['updated']   = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');

        $this->db->where('idmaster_product', (int) $id);
        $this->db->where('status', 1);
        return $this->db->update($this->table, $data);
    }

    public function delete($id)  // soft delete
    {
        $data = array(
            'updated'   => date('Y-m-d H:i:s'),
            'updatedby' => $this->session->userdata('user_nama'),
            'status'    => 0,
        );

        $this->db->where('idmaster_product', (int) $id);
        $this->db->where('status', 1);
        return $this->db->update($this->table, $data);
    }
}