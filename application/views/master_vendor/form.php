<?php
$input_cls  = 'dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 dark:focus:border-brand-800 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30';
$input_err  = 'dark:bg-dark-900 shadow-theme-xs focus:ring-error-500/10 h-11 w-full rounded-lg border border-error-500 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-error-500 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30';
$select_cls = 'dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 dark:focus:border-brand-800 h-11 w-full appearance-none rounded-lg border border-gray-300 bg-transparent bg-none px-4 py-2.5 pr-11 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30';
$area_cls   = 'dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 dark:focus:border-brand-800 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30';
$label_cls  = 'mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400';
$opt_cls    = 'text-gray-700 dark:bg-gray-900 dark:text-gray-400';
$disabled_cls = 'h-11 w-full cursor-not-allowed rounded-lg border border-gray-200 bg-gray-50 px-4 py-2.5 text-sm text-gray-500 dark:border-gray-800 dark:bg-white/3 dark:text-gray-400';

// nilai: input terakhir (jika form dikirim & validasi gagal) > data record > default
$posted = $this->input->method() === 'post';
$val = function ($field, $default = '') use ($row, $posted) {
    if ($posted) { return set_value($field, '', FALSE); }
    if (is_array($row) && isset($row[$field]) && $row[$field] !== null) { return $row[$field]; }
    return $default;
};
$cls = function ($field) use ($input_cls, $input_err) {
    return form_error($field) ? $input_err : $input_cls;
};
$err = '<p class="text-theme-xs mt-1.5 text-error-500" data-error-for="%s"></p>';
$aktif = (string) $val('is_active', '1');
$tipe  = (string) $val('vendor_type');
$chevron = '<span class="pointer-events-none absolute top-1/2 right-4 z-30 -translate-y-1/2 text-gray-500 dark:text-gray-400"><svg class="stroke-current" width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M4.79175 7.39551L10.0001 12.6038L15.2084 7.39551" stroke="" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /></svg></span>';
?>
<div class="rounded-2xl border border-gray-200 bg-white dark:border-gray-800 dark:bg-white/3">
  <div class="px-5 py-4 sm:px-6 sm:py-5">
    <h3 class="text-base font-medium text-gray-800 dark:text-white/90"><?= $is_edit ? 'Edit Vendor' : 'Tambah Vendor' ?></h3>
  </div>

  <form action="<?= $action ?>" method="post" id="vendor-form" data-confirm-save novalidate>
    <input type="hidden" name="<?= $this->security->get_csrf_token_name() ?>" value="<?= $this->security->get_csrf_hash() ?>" />

    <div class="border-t border-gray-100 p-5 sm:p-6 dark:border-gray-800">
      <div class="grid grid-cols-1 gap-x-6 gap-y-5 lg:grid-cols-2">
        <div>
          <label class="<?= $label_cls ?>">Kode Vendor</label>
          <input type="text" value="<?= html_escape($next_code) ?>" disabled class="<?= $disabled_cls ?>" />
          <p class="text-theme-xs mt-1.5 text-gray-500 dark:text-gray-400"><?= $is_edit ? 'Kode tidak dapat diubah.' : 'Dibuat otomatis saat disimpan.' ?></p>
        </div>
        <div>
          <label class="<?= $label_cls ?>">Nama Vendor<span class="text-error-500">*</span></label>
          <input type="text" name="vendor_name" maxlength="200" value="<?= html_escape($val('vendor_name')) ?>" placeholder="PT Contoh Sejahtera" class="<?= $cls('vendor_name') ?>" />
          <?= sprintf($err, 'vendor_name') ?>
        </div>
        <div>
          <label class="<?= $label_cls ?>">Jenis Vendor</label>
          <div class="relative z-20 bg-transparent">
            <select name="vendor_type" class="<?= $select_cls ?>">
              <option value="" class="<?= $opt_cls ?>">-- Pilih Jenis --</option>
              <?php foreach ($types as $key => $label): ?>
                <option value="<?= html_escape($key) ?>" class="<?= $opt_cls ?>" <?= $tipe === (string) $key ? 'selected' : '' ?>><?= html_escape($label) ?></option>
              <?php endforeach; ?>
            </select>
            <?= $chevron ?>
          </div>
          <?= sprintf($err, 'vendor_type') ?>
        </div>
        <div>
          <label class="<?= $label_cls ?>">Status<span class="text-error-500">*</span></label>
          <div class="relative z-20 bg-transparent">
            <select name="is_active" class="<?= $select_cls ?>">
              <option value="1" class="<?= $opt_cls ?>" <?= $aktif === '1' ? 'selected' : '' ?>>Aktif</option>
              <option value="0" class="<?= $opt_cls ?>" <?= $aktif === '0' ? 'selected' : '' ?>>Nonaktif</option>
            </select>
            <?= $chevron ?>
          </div>
          <?= sprintf($err, 'is_active') ?>
        </div>
        <div>
          <label class="<?= $label_cls ?>">Kontak Person</label>
          <input type="text" name="contact_person" maxlength="100" value="<?= html_escape($val('contact_person')) ?>" placeholder="Nama kontak" class="<?= $cls('contact_person') ?>" />
          <?= sprintf($err, 'contact_person') ?>
        </div>
        <div>
          <label class="<?= $label_cls ?>">Telepon</label>
          <input type="tel" name="phone" maxlength="50" value="<?= html_escape($val('phone')) ?>" placeholder="031-123456" class="<?= $cls('phone') ?>" />
          <?= sprintf($err, 'phone') ?>
        </div>
        <div class="lg:col-span-2">
          <label class="<?= $label_cls ?>">Email</label>
          <input type="email" name="email" maxlength="100" value="<?= html_escape($val('email')) ?>" placeholder="info@contoh.co.id" class="<?= $cls('email') ?>" />
          <?= sprintf($err, 'email') ?>
        </div>
        <div class="lg:col-span-2">
          <label class="<?= $label_cls ?>">Alamat</label>
          <textarea name="address" rows="3" maxlength="255" placeholder="Alamat lengkap vendor..." class="<?= $area_cls ?><?= form_error('address') ? ' border-error-500 dark:border-error-500' : '' ?>"><?= html_escape($val('address')) ?></textarea>
          <?= sprintf($err, 'address') ?>
        </div>
        <div class="lg:col-span-2">
          <label class="<?= $label_cls ?>">Keterangan</label>
          <textarea name="description_vendor" rows="3" maxlength="255" placeholder="Keterangan vendor..." class="<?= $area_cls ?><?= form_error('description_vendor') ? ' border-error-500 dark:border-error-500' : '' ?>"><?= html_escape($val('description_vendor')) ?></textarea>
          <?= sprintf($err, 'description_vendor') ?>
        </div>
      </div>

      <div class="mt-6 flex items-center gap-3 lg:justify-end">
        <a href="<?= site_url('master_vendor') ?>" data-menu-nav class="shadow-theme-xs flex w-full justify-center rounded-lg bg-white px-4 py-3 text-sm font-medium text-gray-700 ring-1 ring-gray-300 transition ring-inset hover:bg-gray-50 sm:w-auto dark:bg-gray-800 dark:text-gray-400 dark:ring-gray-700 dark:hover:bg-white/3">Batal</a>
        <button type="submit" class="bg-brand-500 shadow-theme-xs hover:bg-brand-600 flex w-full justify-center rounded-lg px-4 py-3 text-sm font-medium text-white transition sm:w-auto">Simpan</button>
      </div>
    </div>
  </form>
</div>