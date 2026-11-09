<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Master_technical_team_model extends CI_Model
{
    protected $table = 'master_technical_team';

    public function all()
    {
        $this->db->select('master_technical_team.*, master_unit.unit_code AS unit_code, master_unit.unit_name AS unit_name');
        $this->db->join('master_unit', 'master_unit.idmaster_unit = master_technical_team.idmaster_unit', 'left');
        $this->db->order_by('master_technical_team.idmaster_technical_team', 'DESC');
        $this->db->where('master_technical_team.status', 1);
        $master_technical_team = $this->db->get($this->table);
        // echo "<pre>"; print_r($this->db->last_query());die;

        $data_master_technical_team = $master_technical_team->result_array();

        return $data_master_technical_team;
    }

    public function find($id)
    {
        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $this->db->limit(1);
        $this->db->select('idmaster_technical_team, team_code, team_name, team_scope, idmaster_unit, is_active');
        $master_technical_team = $this->db->get($this->table);
        // echo "<pre>"; print_r($this->db->last_query());die;

        $data_master_technical_team = $master_technical_team->row_array();

        return $data_master_technical_team;
    }

    public function insert($data)
    {
        $data['created'] = date('Y-m-d H:i:s');
        $data['createdby'] = $this->session->userdata('user_nama');
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');
        
        $save = $this->db->insert($this->table, $data);
        $master_technical_team = $this->db->insert_id();

        return $master_technical_team;
    }

    public function update($id, $data)
    {
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');

        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $update_master_technical_team = $this->db->update($this->table, $data);
        
        return $update_master_technical_team;
    }

    public function delete($id)
    {
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');
        $data['status'] = 0;

        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $delete_master_technical_team = $this->db->update($this->table, $data);
        
        return $delete_master_technical_team;
    }
}
