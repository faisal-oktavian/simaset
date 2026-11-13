<?php
$input_cls  = 'dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 dark:focus:border-brand-800 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30';
$input_err  = 'dark:bg-dark-900 shadow-theme-xs focus:ring-error-500/10 h-11 w-full rounded-lg border border-error-500 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-error-500 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30';
$select_cls = 'dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 dark:focus:border-brand-800 h-11 w-full appearance-none rounded-lg border border-gray-300 bg-transparent bg-none px-4 py-2.5 pr-11 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30';
$area_cls   = 'dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 dark:focus:border-brand-800 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30';
$label_cls  = 'mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400';
$opt_cls    = 'text-gray-700 dark:bg-gray-900 dark:text-gray-400';

// nilai: input terakhir (jika form dikirim & validasi gagal) > data record > default
$posted = $this->input->method() === 'post';
$val = function ($field, $default = '') use ($row, $posted) {
    if ($posted) { return set_value($field, '', FALSE); }
    if (is_array($row) && isset($row[$field]) && $row[$field] !== null) { return $row[$field]; }
    return $default;
};
$bad = function ($field) use ($errors) { return isset($errors[$field]); };
$cls = function ($field) use ($input_cls, $input_err, $bad) {
    return $bad($field) ? $input_err : $input_cls;
};
$err = '<p class="text-theme-xs mt-1.5 text-error-500" data-error-for="%s"></p>';
$aktif    = (string) $val('is_active', '1');
$kat_val  = (string) $val('idmaster_category_product');
$kib_val  = (string) $val('idmaster_kib');
$svc_val  = (string) $val('service_type', 'SERVICE');
$chevron = '<span class="pointer-events-none absolute top-1/2 right-4 z-30 -translate-y-1/2 text-gray-500 dark:text-gray-400"><svg class="stroke-current" width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M4.79175 7.39551L10.0001 12.6038L15.2084 7.39551" stroke="" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /></svg></span>';
$btn_cls = 'shadow-theme-xs inline-flex items-center justify-center rounded-lg bg-white px-4 py-3 text-sm font-medium text-gray-700 ring-1 ring-gray-300 transition ring-inset hover:bg-gray-50 dark:bg-gray-800 dark:text-gray-400 dark:ring-gray-700 dark:hover:bg-white/3';
?>
<div x-data="productForm()" class="rounded-2xl border border-gray-200 bg-white dark:border-gray-800 dark:bg-white/3">
  <div class="px-5 py-4 sm:px-6 sm:py-5">
    <h3 class="text-base font-medium text-gray-800 dark:text-white/90"><?= $is_edit ? 'Edit Barang' : 'Tambah Barang' ?></h3>
  </div>

  <form action="<?= $action ?>" method="post" id="product-form" x-ref="form" class="form" data-confirm-save novalidate>
    <input type="hidden" name="<?= $this->security->get_csrf_token_name() ?>" value="<?= $this->security->get_csrf_hash() ?>" />

    <div class="border-t border-gray-100 p-5 sm:p-6 dark:border-gray-800">
      <div class="grid grid-cols-1 gap-x-6 gap-y-5 lg:grid-cols-2">
        <div>
          <label class="<?= $label_cls ?>">Kode Barang<span class="text-error-500">*</span></label>
          <input type="text" name="product_code" maxlength="50" value="<?= html_escape($val('product_code')) ?>" placeholder="MED-MON-001" class="<?= $cls('product_code') ?> uppercase" />
          <?= sprintf($err, 'product_code') ?>
        </div>
        <div>
          <label class="<?= $label_cls ?>">Nama Barang<span class="text-error-500">*</span></label>
          <input type="text" name="product_name" maxlength="200" value="<?= html_escape($val('product_name')) ?>" placeholder="Patient Monitor" class="<?= $cls('product_name') ?>" />
          <?= sprintf($err, 'product_name') ?>
        </div>

        <!-- relasi 1: Kategori Barang (select2, bisa dicari) -->
        <div>
          <label class="<?= $label_cls ?>">Kelompok Aset<span class="text-error-500">*</span></label>
          <select name="idmaster_category_product" data-placeholder="Pilih / cari kelompok..." <?= $bad('idmaster_category_product') ? 'data-invalid="1"' : '' ?> class="<?= $select_cls ?>">
            <option value=""></option>
            <?php foreach ($categories as $c): ?>
              <option value="<?= (int) $c['idmaster_category_product'] ?>" <?= $kat_val === (string) $c['idmaster_category_product'] ? 'selected' : '' ?>><?= html_escape($c['code'] . ' - ' . $c['name']) ?></option>
            <?php endforeach; ?>
          </select>
          <?= sprintf($err, 'idmaster_category_product') ?>
        </div>

        <!-- relasi 2: KIB (select2, bisa dicari) -->
        <div>
          <label class="<?= $label_cls ?>">KIB<span class="text-error-500">*</span></label>
          <select name="idmaster_kib" data-placeholder="Pilih / cari KIB..." <?= $bad('idmaster_kib') ? 'data-invalid="1"' : '' ?> class="<?= $select_cls ?>">
            <option value=""></option>
            <?php foreach ($kibs as $k): ?>
              <option value="<?= (int) $k['idmaster_kib'] ?>" <?= $kib_val === (string) $k['idmaster_kib'] ? 'selected' : '' ?>><?= html_escape('KIB ' . $k['code'] . ' - ' . $k['name']) ?></option>
            <?php endforeach; ?>
          </select>
          <?= sprintf($err, 'idmaster_kib') ?>
        </div>

        <!-- enum: Jenis Penggunaan -->
        <div>
          <label class="<?= $label_cls ?>">Jenis Penggunaan<span class="text-error-500">*</span></label>
          <div class="relative z-20 bg-transparent">
            <select name="service_type" class="<?= $select_cls ?>">
              <?php foreach ($service_types as $key => $label): ?>
                <option value="<?= html_escape($key) ?>" class="<?= $opt_cls ?>" <?= $svc_val === (string) $key ? 'selected' : '' ?>><?= html_escape($label) ?></option>
              <?php endforeach; ?>
            </select>
            <?= $chevron ?>
          </div>
          <?= sprintf($err, 'service_type') ?>
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
          <label class="<?= $label_cls ?>">Merek</label>
          <input type="text" name="brand" maxlength="100" value="<?= html_escape($val('brand')) ?>" placeholder="Mindray" class="<?= $cls('brand') ?>" />
          <?= sprintf($err, 'brand') ?>
        </div>
        <div>
          <label class="<?= $label_cls ?>">Model / Tipe</label>
          <input type="text" name="model" maxlength="100" value="<?= html_escape($val('model')) ?>" placeholder="PM-60" class="<?= $cls('model') ?>" />
          <?= sprintf($err, 'model') ?>
        </div>
        
        <div>
          <label class="<?= $label_cls ?>">Satuan</label>
          <input type="text" name="unit_of_measure" maxlength="30" value="<?= html_escape($val('unit_of_measure')) ?>" placeholder="UNIT" class="<?= $cls('unit_of_measure') ?> uppercase" />
          <?= sprintf($err, 'unit_of_measure') ?>
        </div>

        <div class="lg:col-span-2">
          <label class="<?= $label_cls ?>">Deskripsi</label>
          <textarea name="description_product" rows="4" maxlength="2000" placeholder="Deskripsi barang..." class="<?= $area_cls ?><?= $bad('description_product') ? ' border-error-500 dark:border-error-500' : '' ?>"><?= html_escape($val('description_product')) ?></textarea>
          <?= sprintf($err, 'description_product') ?>
        </div>
      </div>

      <div class="mt-6 flex items-center gap-3 lg:justify-end">
        <a href="<?= site_url('master_product') ?>" data-menu-nav class="<?= $btn_cls ?> w-full sm:w-auto">Batal</a>
        <button type="submit" class="bg-brand-500 shadow-theme-xs hover:bg-brand-600 flex w-full justify-center rounded-lg px-4 py-3 text-sm font-medium text-white transition sm:w-auto">Simpan</button>
      </div>
    </div>
  </form>
</div>