<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Master_building_model extends CI_Model
{
    protected $table = 'master_building';

    public function all()
    {
        $this->db->order_by('id' . $this->table . '', 'DESC');
        $this->db->where('status', 1);
        $master_building = $this->db->get($this->table);
        // echo "<pre>"; print_r($this->db->last_query());die;

        $data_master_building = $master_building->result_array();

        return $data_master_building;
    }

    public function find($id)
    {
        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $this->db->limit(1);
        $this->db->select('idmaster_building, building_code, building_name, description_building, is_active');
        $master_building = $this->db->get($this->table);
        // echo "<pre>"; print_r($this->db->last_query());die;

        $data_master_building = $master_building->row_array();

        return $data_master_building;
    }

    public function insert($data)
    {
        $data['created'] = date('Y-m-d H:i:s');
        $data['createdby'] = $this->session->userdata('user_nama');
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');
        
        $save = $this->db->insert($this->table, $data);
        $master_building = $this->db->insert_id();

        return $master_building;
    }

    public function update($id, $data)
    {
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');

        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $update_master_building = $this->db->update($this->table, $data);
        
        return $update_master_building;
    }

    public function delete($id)
    {
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');
        $data['status'] = 0;

        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $delete_master_building = $this->db->update($this->table, $data);
        
        return $delete_master_building;
    }
}
