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
$bad = function ($field) use ($errors) { return isset($errors[$field]); };
$cls = function ($field) use ($input_cls, $input_err, $bad) {
    return $bad($field) ? $input_err : $input_cls;
};
$err = '<p class="text-theme-xs mt-1.5 text-error-500" data-error-for="%s"></p>';
$aktif = (string) $val('is_active', '1');
$chevron = '<span class="pointer-events-none absolute top-1/2 right-4 z-30 -translate-y-1/2 text-gray-500 dark:text-gray-400"><svg class="stroke-current" width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M4.79175 7.39551L10.0001 12.6038L15.2084 7.39551" stroke="" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /></svg></span>';
$btn_cls = 'shadow-theme-xs inline-flex items-center justify-center rounded-lg bg-white px-4 py-3 text-sm font-medium text-gray-700 ring-1 ring-gray-300 transition ring-inset hover:bg-gray-50 dark:bg-gray-800 dark:text-gray-400 dark:ring-gray-700 dark:hover:bg-white/3';
?>
<div x-data="buildingForm()" data-lat="<?= html_escape($val('latitude')) ?>" data-lng="<?= html_escape($val('longitude')) ?>" class="rounded-2xl border border-gray-200 bg-white dark:border-gray-800 dark:bg-white/3">
<div class="px-5 py-4 sm:px-6 sm:py-5">
    <h3 class="text-base font-medium text-gray-800 dark:text-white/90"><?= $is_edit ? 'Edit Gedung' : 'Tambah Gedung' ?></h3>
  </div>

  <form action="<?= $action ?>" method="post" id="building-form" data-confirm-save novalidate>
    <input type="hidden" name="<?= $this->security->get_csrf_token_name() ?>" value="<?= $this->security->get_csrf_hash() ?>" />

    <div class="border-t border-gray-100 p-5 sm:p-6 dark:border-gray-800">
      <div class="grid grid-cols-1 gap-x-6 gap-y-5 lg:grid-cols-2">
        <div>
          <label class="<?= $label_cls ?>">Kode Gedung<span class="text-error-500">*</span></label>
          <input type="text" name="building_code" maxlength="30" value="<?= html_escape($val('building_code')) ?>" placeholder="G-RAWAT" class="<?= $cls('building_code') ?> uppercase" />
          <?= sprintf($err, 'building_code') ?>
        </div>
        <div>
          <label class="<?= $label_cls ?>">Nama Gedung<span class="text-error-500">*</span></label>
          <input type="text" name="building_name" maxlength="150" value="<?= html_escape($val('building_name')) ?>" placeholder="Gedung Rawat Inap" class="<?= $cls('building_name') ?>" />
          <?= sprintf($err, 'building_name') ?>
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
        <div class="lg:col-span-2">
          <label class="<?= $label_cls ?>">Deskripsi</label>
          <textarea name="description_building" rows="3" maxlength="255" placeholder="Deskripsi gedung..." class="<?= $area_cls ?><?= $bad('description_building') ? ' border-error-500 dark:border-error-500' : '' ?>"><?= html_escape($val('description_building')) ?></textarea>
          <?= sprintf($err, 'description_building') ?>
        </div>

        <!-- ===================== LOKASI DI PETA ===================== -->
        <div class="lg:col-span-2">
          <div class="mb-3 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
            <div>
              <h4 class="text-sm font-medium text-gray-800 dark:text-white/90">Lokasi di Peta</h4>
              <p class="text-theme-xs text-gray-500 dark:text-gray-400">Klik peta untuk menaruh penanda, atau geser penanda untuk memindahkan. Koordinat juga bisa diketik manual.</p>
            </div>
            <div class="flex items-center gap-2">
              <button type="button" @click="locate()" :disabled="locating" class="<?= $btn_cls ?> disabled:cursor-not-allowed disabled:opacity-60">
                <span x-text="locating ? 'Mencari lokasi...' : 'Lokasi saya'"></span>
              </button>
              <button type="button" @click="clearPoint()" class="<?= $btn_cls ?>">Hapus titik</button>
            </div>
          </div>

          <div class="grid grid-cols-1 gap-x-6 gap-y-5 sm:grid-cols-2">
            <div>
              <label class="<?= $label_cls ?>">Latitude</label>
              <input type="text" inputmode="decimal" name="latitude" x-ref="lat" @change="syncFromInputs()" value="<?= html_escape($val('latitude')) ?>" placeholder="-7.1234567" class="<?= $cls('latitude') ?>" />
              <?= sprintf($err, 'latitude') ?>
            </div>
            <div>
              <label class="<?= $label_cls ?>">Longitude</label>
              <input type="text" inputmode="decimal" name="longitude" x-ref="lng" @change="syncFromInputs()" value="<?= html_escape($val('longitude')) ?>" placeholder="112.1234567" class="<?= $cls('longitude') ?>" />
              <?= sprintf($err, 'longitude') ?>
            </div>
          </div>

          <div class="relative mt-4 overflow-hidden rounded-xl border border-gray-200 dark:border-gray-800">
            <div x-ref="map" class="isolate z-0 h-96 w-full bg-gray-100 dark:bg-gray-800"></div>
            <div x-show="mapLoading" x-cloak class="absolute inset-0 z-10 flex items-center justify-center gap-3 bg-white/75 text-sm font-medium text-gray-700 dark:bg-gray-900/75 dark:text-gray-200">
              <span class="h-5 w-5 animate-spin rounded-full border-2 border-gray-300 border-t-brand-500"></span>
              Memuat peta...
            </div>
          </div>
          <p x-show="mapError" x-cloak x-text="mapError" class="text-theme-xs mt-2 text-error-500"></p>
        </div>
      </div>

      <div class="mt-6 flex items-center gap-3 lg:justify-end">
        <a href="<?= site_url('master_building') ?>" data-menu-nav class="<?= $btn_cls ?> w-full sm:w-auto">Batal</a>
        <button type="submit" class="bg-brand-500 shadow-theme-xs hover:bg-brand-600 flex w-full justify-center rounded-lg px-4 py-3 text-sm font-medium text-white transition sm:w-auto">Simpan</button>
      </div>
    </div>
  </form>
</div>