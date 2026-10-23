<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Master_acquisition_source_model extends CI_Model
{
    protected $table = 'master_acquisition_source';

    public function all()
    {
        $this->db->order_by('id' . $this->table . '', 'DESC');
        $this->db->where('status', 1);
        $master_acquisition_source = $this->db->get($this->table);
        // echo "<pre>"; print_r($this->db->last_query());die;

        $data_master_acquisition_source = $master_acquisition_source->result_array();

        return $data_master_acquisition_source;
    }

    public function find($id)
    {
        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $this->db->limit(1);
        $this->db->select('idmaster_acquisition_source, source_name, description_source, is_active');
        $master_acquisition_source = $this->db->get($this->table);
        // echo "<pre>"; print_r($this->db->last_query());die;

        $data_master_acquisition_source = $master_acquisition_source->row_array();

        return $data_master_acquisition_source;
    }

    public function insert($data)
    {
        $data['created'] = date('Y-m-d H:i:s');
        $data['createdby'] = $this->session->userdata('user_nama');
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');
        
        $save = $this->db->insert($this->table, $data);
        $master_acquisition_source = $this->db->insert_id();

        return $master_acquisition_source;
    }

    public function update($id, $data)
    {
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');

        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $update_master_acquisition_source = $this->db->update($this->table, $data);
        
        return $update_master_acquisition_source;
    }

    public function delete($id)
    {
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');
        $data['status'] = 0;

        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $delete_master_acquisition_source = $this->db->update($this->table, $data);
        
        return $delete_master_acquisition_source;
    }
}
