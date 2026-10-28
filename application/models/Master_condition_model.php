<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Master_condition_model extends CI_Model
{
    protected $table = 'master_condition';

    public function all()
    {
        $this->db->order_by('id' . $this->table . '', 'DESC');
        $this->db->where('status', 1);
        $master_condition = $this->db->get($this->table);
        // echo "<pre>"; print_r($this->db->last_query());die;

        $data_master_condition = $master_condition->result_array();

        return $data_master_condition;
    }

    public function find($id)
    {
        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $this->db->limit(1);
        $this->db->select('idmaster_condition, condition_name, description_condition, is_active');
        $master_condition = $this->db->get($this->table);
        // echo "<pre>"; print_r($this->db->last_query());die;

        $data_master_condition = $master_condition->row_array();

        return $data_master_condition;
    }

    public function insert($data)
    {
        $data['created'] = date('Y-m-d H:i:s');
        $data['createdby'] = $this->session->userdata('user_nama');
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');
        
        $save = $this->db->insert($this->table, $data);
        $master_condition = $this->db->insert_id();

        return $master_condition;
    }

    public function update($id, $data)
    {
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');

        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $update_master_condition = $this->db->update($this->table, $data);
        
        return $update_master_condition;
    }

    public function delete($id)
    {
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');
        $data['status'] = 0;

        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $delete_master_condition = $this->db->update($this->table, $data);
        
        return $delete_master_condition;
    }
}
