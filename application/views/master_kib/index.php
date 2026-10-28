<?php
  // Kelas input standar TailAdmin (disalin dari form-elements)
  $input_cls  = 'dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 dark:focus:border-brand-800 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30';
  $select_cls = 'dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 dark:focus:border-brand-800 h-11 w-full appearance-none rounded-lg border border-gray-300 bg-transparent bg-none px-4 py-2.5 pr-11 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30';
  $area_cls   = 'dark:bg-dark-900 shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 dark:focus:border-brand-800 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30';
  $file_cls   = 'focus:border-ring-brand-300 shadow-theme-xs focus:file:ring-brand-300 h-11 w-full overflow-hidden rounded-lg border border-gray-300 bg-transparent text-sm text-gray-500 transition-colors file:mr-5 file:border-collapse file:cursor-pointer file:rounded-l-lg file:border-0 file:border-r file:border-solid file:border-gray-200 file:bg-gray-50 file:py-3 file:pr-3 file:pl-3.5 file:text-sm file:text-gray-700 placeholder:text-gray-400 hover:file:bg-gray-100 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-gray-400 dark:file:border-gray-800 dark:file:bg-white/3 dark:file:text-gray-400 dark:placeholder:text-gray-400';
  $label_cls  = 'mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400';
  $opt_cls    = 'text-gray-700 dark:bg-gray-900 dark:text-gray-400';
  $err        = '<p class="text-theme-xs mt-1.5 text-error-500" data-error-for="%s"></p>';
  $chevron    = '<span class="pointer-events-none absolute top-1/2 right-4 z-30 -translate-y-1/2 text-gray-500 dark:text-gray-400"><svg class="stroke-current" width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M4.79175 7.39551L10.0001 12.6038L15.2084 7.39551" stroke="" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /></svg></span>';
  $th_cls     = 'px-5 py-3 text-left sm:px-6 rtl:text-right';
  $th_p       = 'text-theme-xs font-medium text-gray-500 dark:text-gray-400';
?>

<div x-data="masterKibCrud()" class="content">
  <div class="card">
    <div class="toolbar">
      <h3>Daftar Kartu Inventaris Barang</h3>

      <div class="toolbar-actions">
        <input type="text" x-model.debounce.200ms="query" @input="page = 1" placeholder="Cari Kartu Inventaris Barang..." class="search"/>
        <button type="button" @click="openCreate()" class="primary-button">
          <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M10 3.75C10.4142 3.75 10.75 4.08579 10.75 4.5V9.25H15.5C15.9142 9.25 16.25 9.58579 16.25 10C16.25 10.4142 15.9142 10.75 15.5 10.75H10.75V15.5C10.75 15.9142 10.4142 16.25 10 16.25C9.58579 16.25 9.25 15.9142 9.25 15.5V10.75H4.5C4.08579 10.75 3.75 10.4142 3.75 10C3.75 9.58579 4.08579 9.25 4.5 9.25H9.25V4.5C9.25 4.08579 9.58579 3.75 10 3.75Z" fill=""/></svg>
          Tambah Kartu Inventaris Barang
        </button>
      </div>

    </div>

    <div class="table-section">
      <div class="table-card">

        <!-- datatables -->
        <div class="custom-scrollbar table-scroll">
          <table class="table">
            <thead>
              <tr>
                <th><p>Kode Kib</p></th>
                <th><p>Nama Kib</p></th>
                <th><p>Deskripsi</p></th>
                <th><p>Aksi</p></th>
              </tr>
            </thead>
            <tbody>
              <?php $this->load->view('master_kib/_rows', array('rows' => $rows)); ?>

              <tr x-show="filteredCount === 0" x-cloak>
                <td colspan="3" class="empty">Data Kib tidak ditemukan.</td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- animasi load datatables -->
        <div x-show="tableLoading" x-cloak class="loading">
          <span class="spinner"></span>
          Memuat data tabel...
        </div>

      </div>

      <!-- pagination -->
      <div class="pagination" x-show="filteredCount > 0">
        <p class="muted">
          Menampilkan 
          <span x-text="from"></span>&ndash;<span x-text="to"></span> 
          dari <span x-text="filteredCount"></span> data
        </p>

        <div class="pagination-controls">
          <button type="button" @click="prev()" :disabled="page <= 1" class="secondary-button">Sebelumnya</button>
          <span class="muted"><span x-text="page"></span> / <span x-text="totalPages"></span></span>
          <button type="button" @click="next()" :disabled="page >= totalPages" class="secondary-button">Berikutnya</button>
        </div>

      </div>

    </div>
  </div>

  <!-- ===================== MODAL CREATE / EDIT ===================== -->
  <div x-show="open" x-cloak @keydown.escape.window="close()" class="modal" >
    <div class="backdrop" @click="close()"></div>
    
    <div class="no-scrollbar dialog">
      
      <button type="button" @click="close()" class="close-button">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="m6 6 12 12M18 6 6 18" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
      </button>

      <div class="dialog-header">
        <h4 x-text="editId ? 'Edit Kib' : 'Tambah Kib'"></h4>
        <p>Lengkapi data Kib di bawah ini, lalu simpan.</p>
      </div>

      <form x-ref="form" @submit.prevent="submit()" enctype="multipart/form-data" class="form" novalidate autocomplete="off">
        <input type="hidden" name="<?= $this->security->get_csrf_token_name() ?>" value="<?= $this->security->get_csrf_hash() ?>" />

        <div class="custom-scrollbar form-scroll">
          
          <div class="grid grid-cols-1 gap-x-6 gap-y-5 lg:grid-cols-2">

            <div class="col-span-2">
              <label class="<?= $label_cls ?>">Kode Kib<span class="text-error-500">*</span></label>
              <input type="text" name="kib_code" maxlength="100" placeholder="Kode Kib" class="<?= $input_cls ?>" />
              <?= sprintf($err, 'kib_code') ?>
            </div>

            <div class="col-span-2">
              <label class="<?= $label_cls ?>">Nama Kib<span class="text-error-500">*</span></label>
              <input type="text" name="kib_name" maxlength="100" placeholder="Nama Kib" class="<?= $input_cls ?>" />
              <?= sprintf($err, 'kib_name') ?>
            </div>
            
            <div class="col-span-2">
              <label class="<?= $label_cls ?>">Deskripsi Kib</label>
              <textarea name="description_kib" rows="3" maxlength="255" placeholder="Deskripsi Kib..." class="<?= $area_cls ?>"></textarea>
              <?= sprintf($err, 'description_kib') ?>
            </div>

            <div class="col-span-2 lg:col-span-1">
              <label class="<?= $label_cls ?>">Status Aktif</label>
              <label class="relative flex h-11 cursor-pointer items-center gap-3 text-sm font-medium text-gray-700 select-none dark:text-gray-400">
                <input type="checkbox" name="is_active" value="1" checked class="peer custom-switch-input" />
                <span class="mb-switch"></span>
                Aktif
              </label>
            </div>

          </div>

        </div>

        <div class="form-actions">
          <button type="button" @click="close()" class="secondary-button">Batal</button>
          <button type="submit" :disabled="saving" class="primary-button">
            <span x-text="saving ? 'Menyimpan...' : 'Simpan'"></span>
          </button>
        </div>
      </form>
    </div>
  </div>
</div>
