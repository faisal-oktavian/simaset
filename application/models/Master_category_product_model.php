<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Master_category_product_model extends CI_Model
{
    protected $table = 'master_category_product';

    public function all()
    {
        $this->db->order_by('id' . $this->table . '', 'DESC');
        $this->db->where('status', 1);
        $master_category_product = $this->db->get($this->table);
        // echo "<pre>"; print_r($this->db->last_query());die;

        $data_master_category_product = $master_category_product->result_array();

        return $data_master_category_product;
    }

    public function find($id)
    {
        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $this->db->limit(1);
        $this->db->select('idmaster_category_product, category_name, description_category, is_active');
        $master_category_product = $this->db->get($this->table);
        // echo "<pre>"; print_r($this->db->last_query());die;

        $data_master_category_product = $master_category_product->row_array();

        return $data_master_category_product;
    }

    public function insert($data)
    {
        $data['created'] = date('Y-m-d H:i:s');
        $data['createdby'] = $this->session->userdata('user_nama');
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');
        
        $save = $this->db->insert($this->table, $data);
        $master_category_product = $this->db->insert_id();

        return $master_category_product;
    }

    public function update($id, $data)
    {
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');

        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $update_master_category_product = $this->db->update($this->table, $data);
        
        return $update_master_category_product;
    }

    public function delete($id)
    {
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');
        $data['status'] = 0;

        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $delete_master_category_product = $this->db->update($this->table, $data);
        
        return $delete_master_category_product;
    }
}
