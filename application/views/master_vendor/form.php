<?php
    $posted = $this->input->method() === 'post';
    $val = function ($field, $default = '') use ($row, $posted) {
        if ($posted) {
            return set_value($field, '', FALSE);
        }
        if (is_array($row) && isset($row[$field]) && $row[$field] !== null) {
            return $row[$field];
        }
        return $default;
    };
    $field_cls = function ($field) {
        return 'field' . (form_error($field) ? ' is-invalid' : '');
    };
    $field_error = function ($field) {
        return form_error($field)
            ? '<p class="error" data-error-for="' . html_escape($field) . '">' . html_escape(strip_tags(form_error($field))) . '</p>'
            : '<p class="error" data-error-for="' . html_escape($field) . '"></p>';
    };
    $aktif = (string) $val('is_active', '1');
    $tipe = (string) $val('vendor_type');
?>
<div class="content">
    <div class="card">
        <div class="toolbar">
            <h3><?= $is_edit ? 'Edit Vendor' : 'Tambah Vendor' ?></h3>
        </div>

        <form action="<?= $action ?>" method="post" id="vendor-form" class="form" data-confirm-save novalidate>
            <input type="hidden" name="<?= $this->security->get_csrf_token_name() ?>" value="<?= $this->security->get_csrf_hash() ?>" />

            <div class="form-section">
                <div class="form-fields">
                    <div class="field-group field-group-single">
                        <label class="field-label" for="vendor-code">Kode Vendor</label>
                        <input id="vendor-code" type="text" value="<?= html_escape($next_code) ?>" disabled class="field" />
                        <p class="field-help"><?= $is_edit ? 'Kode tidak dapat diubah.' : 'Dibuat otomatis saat disimpan.' ?></p>
                    </div>

                    <div class="field-group field-group-single">
                        <label class="field-label" for="vendor-name">Nama Vendor <span class="required">*</span></label>
                        <input id="vendor-name" type="text" name="vendor_name" maxlength="200" value="<?= html_escape($val('vendor_name')) ?>" placeholder="PT Contoh Sejahtera" class="<?= $field_cls('vendor_name') ?>" aria-invalid="<?= form_error('vendor_name') ? 'true' : 'false' ?>" />
                        <?= $field_error('vendor_name') ?>
                    </div>

                    <div class="field-group field-group-single">
                        <label class="field-label" for="vendor-type">Jenis Vendor</label>
                        <div class="field-select-wrap">
                            <select id="vendor-type" name="vendor_type" class="field field-select <?= form_error('vendor_type') ? 'is-invalid' : '' ?>" aria-invalid="<?= form_error('vendor_type') ? 'true' : 'false' ?>">
                                <option value="">Pilih jenis</option>
                                <?php foreach ($types as $key => $label): ?>
                                    <option value="<?= html_escape($key) ?>" <?= $tipe === (string) $key ? 'selected' : '' ?>><?= html_escape($label) ?></option>
                                <?php endforeach; ?>
                            </select>
                            <span class="field-chevron" aria-hidden="true">
                                <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M4.79175 7.39551L10.0001 12.6038L15.2084 7.39551" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /></svg>
                            </span>
                        </div>
                        <?= $field_error('vendor_type') ?>
                    </div>

                    <div class="field-group field-group-single">
                        <label class="field-label" for="vendor-status">Status <span class="required">*</span></label>
                        <div class="field-select-wrap">
                            <select id="vendor-status" name="is_active" class="field field-select <?= form_error('is_active') ? 'is-invalid' : '' ?>" aria-invalid="<?= form_error('is_active') ? 'true' : 'false' ?>">
                                <option value="1" <?= $aktif === '1' ? 'selected' : '' ?>>Aktif</option>
                                <option value="0" <?= $aktif === '0' ? 'selected' : '' ?>>Nonaktif</option>
                            </select>
                            <span class="field-chevron" aria-hidden="true">
                                <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M4.79175 7.39551L10.0001 12.6038L15.2084 7.39551" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /></svg>
                            </span>
                        </div>
                        <?= $field_error('is_active') ?>
                    </div>

                    <div class="field-group field-group-single">
                        <label class="field-label" for="vendor-contact">Kontak Person</label>
                        <input id="vendor-contact" type="text" name="contact_person" maxlength="100" value="<?= html_escape($val('contact_person')) ?>" placeholder="Nama kontak" class="<?= $field_cls('contact_person') ?>" aria-invalid="<?= form_error('contact_person') ? 'true' : 'false' ?>" />
                        <?= $field_error('contact_person') ?>
                    </div>

                    <div class="field-group field-group-single">
                        <label class="field-label" for="vendor-phone">Telepon</label>
                        <input id="vendor-phone" type="tel" name="phone" maxlength="50" value="<?= html_escape($val('phone')) ?>" placeholder="031-123456" class="<?= $field_cls('phone') ?>" aria-invalid="<?= form_error('phone') ? 'true' : 'false' ?>" />
                        <?= $field_error('phone') ?>
                    </div>

                    <div class="field-group">
                        <label class="field-label" for="vendor-email">Email</label>
                        <input id="vendor-email" type="email" name="email" maxlength="100" value="<?= html_escape($val('email')) ?>" placeholder="info@contoh.co.id" class="<?= $field_cls('email') ?>" aria-invalid="<?= form_error('email') ? 'true' : 'false' ?>" />
                        <?= $field_error('email') ?>
                    </div>

                    <div class="field-group">
                        <label class="field-label" for="vendor-address">Alamat</label>
                        <textarea id="vendor-address" name="address" rows="3" maxlength="255" placeholder="Alamat lengkap vendor..." class="field <?= form_error('address') ? 'is-invalid' : '' ?>" aria-invalid="<?= form_error('address') ? 'true' : 'false' ?>"><?= html_escape($val('address')) ?></textarea>
                        <?= $field_error('address') ?>
                    </div>

                    <div class="field-group">
                        <label class="field-label" for="vendor-description">Keterangan</label>
                        <textarea id="vendor-description" name="description_vendor" rows="3" maxlength="255" placeholder="Keterangan vendor..." class="field <?= form_error('description_vendor') ? 'is-invalid' : '' ?>" aria-invalid="<?= form_error('description_vendor') ? 'true' : 'false' ?>"><?= html_escape($val('description_vendor')) ?></textarea>
                        <?= $field_error('description_vendor') ?>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="<?= site_url('master_vendor') ?>" data-menu-nav class="secondary-button">Batal</a>
                    <button type="submit" class="primary-button">Simpan</button>
                </div>
            </div>

        </form>
    </div>
</div>
