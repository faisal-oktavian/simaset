<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Master_room_model extends CI_Model
{
    protected $table = 'master_room';

    public function all()
    {
        $this->db->select('master_room.*, master_unit.unit_code AS unit_code, master_unit.unit_name AS unit_name, master_building.building_code AS building_code, master_building.building_name AS building_name');
        $this->db->join('master_unit', 'master_unit.idmaster_unit = master_room.idmaster_unit', 'left');
        $this->db->join('master_building', 'master_building.idmaster_building = master_room.idmaster_building', 'left');
        $this->db->order_by('master_room.idmaster_room', 'DESC');
        $this->db->where('master_room.status', 1);
        $master_room = $this->db->get($this->table);
        // echo "<pre>"; print_r($this->db->last_query());die;

        $data_master_room = $master_room->result_array();

        return $data_master_room;
    }

    public function find($id)
    {
        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $this->db->limit(1);
        $this->db->select('idmaster_room, room_code, room_name, idmaster_unit, idmaster_building, is_active');
        $master_room = $this->db->get($this->table);
        // echo "<pre>"; print_r($this->db->last_query());die;

        $data_master_room = $master_room->row_array();

        return $data_master_room;
    }

    public function insert($data)
    {
        $data['created'] = date('Y-m-d H:i:s');
        $data['createdby'] = $this->session->userdata('user_nama');
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');
        
        $save = $this->db->insert($this->table, $data);
        $master_room = $this->db->insert_id();

        return $master_room;
    }

    public function update($id, $data)
    {
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');

        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $update_master_room = $this->db->update($this->table, $data);
        
        return $update_master_room;
    }

    public function delete($id)
    {
        $data['updated'] = date('Y-m-d H:i:s');
        $data['updatedby'] = $this->session->userdata('user_nama');
        $data['status'] = 0;

        $this->db->where('id' . $this->table . '', (int) $id);
        $this->db->where('status', 1);
        $delete_master_room = $this->db->update($this->table, $data);
        
        return $delete_master_room;
    }
}
