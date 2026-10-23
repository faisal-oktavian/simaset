<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class MY_Form_validation extends CI_Form_validation
{
    /**
     * Unik kecuali untuk baris dengan id tertentu.
     * Pemakaian: edit_unique[tabel.kolom.id] atau edit_unique[tabel.kolom.id.primary_key]
     */
    public function edit_unique($value, $params)
    {
        $parts = explode('.', $params);
        if (count($parts) !== 3 && count($parts) !== 4) {
            return FALSE;
        }
        list($table, $field, $id) = $parts;
        $primary_key = isset($parts[3]) ? $parts[3] : 'id';

        $row = $this->CI->db
            ->limit(1)
            ->get_where($table, array($field => $value, $primary_key . ' !=' => (int) $id))
            ->row();

        return $row === NULL;
    }

    /** URL boleh kosong, kalau diisi harus http(s). */
    public function url_opsional($value)
    {
        if ($value === '' || $value === NULL) {
            return TRUE;
        }
        return (bool) preg_match('#^https?://#i', $value) && filter_var($value, FILTER_VALIDATE_URL) !== FALSE;
    }
}
