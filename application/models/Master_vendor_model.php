<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Master_vendor_model extends CI_Model
{
    protected $table = 'master_vendor';

    public function all()
    {
        $this->db->where('status', 1);
        $this->db->order_by('idmaster_vendor', 'DESC');
        return $this->db->get($this->table)->result_array();
    }

    public function find($id)
    {
        $this->db->select('idmaster_vendor, vendor_code, vendor_name, vendor_type, address, phone, email, contact_person, description_vendor, is_active');
        $this->db->where('idmaster_vendor', (int) $id);
        $this->db->where('status', 1);
        $this->db->limit(1);
        return $this->db->get($this->table)->row_array();
    }

    /**
     * Kode berikutnya: VEN-001, VEN-002, ...
     * Dihitung dari SEMUA baris (termasuk status=0) karena vendor_code UNIQUE di DB.
     */
    public function next_code()
    {
        $row = $this->db->query(
            "SELECT MAX(CAST(SUBSTRING(vendor_code, 5) AS UNSIGNED)) AS n FROM {$this->table} WHERE vendor_code REGEXP '^VEN-[0-9]+$'"
        )->row();
        $next = ((int) ($row ? $row->n : 0)) + 1;

        return 'VEN-' . str_pad((string) $next, 3, '0', STR_PAD_LEFT);
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

        $this->db->where('idmaster_vendor', (int) $id);
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

        $this->db->where('idmaster_vendor', (int) $id);
        $this->db->where('status', 1);
        return $this->db->update($this->table, $data);
    }
}