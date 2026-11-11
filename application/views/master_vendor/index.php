<div x-data="vendorList()" class="content">
    <div class="card">
        <div class="toolbar">
            <h3>Daftar Vendor</h3>
            <div class="toolbar-actions">
                <input type="text" x-model.debounce.200ms="query" @input="page = 1" placeholder="Cari vendor..." aria-label="Cari vendor" class="search" />
                <a href="<?= site_url('master_vendor/create') ?>" data-menu-nav data-loading-title="Menyiapkan form..." class="primary-button" >
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M10 3.75C10.4142 3.75 10.75 4.08579 10.75 4.5V9.25H15.5C15.9142 9.25 16.25 9.58579 16.25 10C16.25 10.4142 15.9142 10.75 15.5 10.75H10.75V15.5C10.75 15.9142 10.4142 16.25 10 16.25C9.58579 16.25 9.25 15.9142 9.25 15.5V10.75H4.5C4.08579 10.75 3.75 10.4142 3.75 10C3.75 9.58579 4.08579 9.25 4.5 9.25H9.25V4.5C9.25 4.08579 9.58579 3.75 10 3.75Z" fill=""/></svg>
                Tambah Vendor
                </a>
            </div>
        </div>

        <div class="table-section">
            <div class="table-card">
                <div class="custom-scrollbar table-scroll">
                    <table class="table">
                        <thead>
                            <tr>
                                <th><p>Vendor</p></th>
                                <th><p>Jenis</p></th>
                                <th><p>Kontak</p></th>
                                <th><p>Email</p></th>
                                <th><p>Status</p></th>
                                <th><p>Aksi</p></th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($rows as $r): ?>
                                <tr data-row class="row">
                                    <td class="cell">
                                        <span class="row-text row-text-primary"><?= html_escape($r['vendor_name']) ?></span>
                                        <span class="row-text row-text-secondary"><?= html_escape($r['vendor_code']) ?></span>
                                    </td>
                                    <td class="cell">
                                        <p class="row-text"><?= html_escape(isset($types[$r['vendor_type']]) ? $types[$r['vendor_type']] : ($r['vendor_type'] ?: '-')) ?></p>
                                    </td>
                                    <td class="cell">
                                        <p class="row-text"><?= html_escape($r['contact_person'] ?: '-') ?></p>
                                        <p class="row-subtext"><?= html_escape($r['phone'] ?: '-') ?></p>
                                    </td>
                                    <td class="cell">
                                        <p class="row-text"><?= html_escape($r['email'] ?: '-') ?></p>
                                    </td>
                                    <td class="cell">
                                        <?php if ($r['is_active']): ?>
                                            <p class="status status-active">Aktif</p>
                                        <?php else: ?>
                                            <p class="status status-inactive">Nonaktif</p>
                                        <?php endif; ?>
                                    </td>
                                    <td class="cell">
                                        <div class="action-group">
                                            <a href="<?= site_url('master_vendor/edit/' . (int) $r['idmaster_vendor']) ?>" data-menu-nav data-loading-title="Memuat data..." title="Edit" aria-label="Edit <?= html_escape($r['vendor_name']) ?>" class="action action-edit" >
                                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M16.862 3.487a2.25 2.25 0 1 1 3.182 3.182L7.5 19.213 3 21l1.787-4.5L16.862 3.487Z" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                                            </a>
                                            <button type="button" title="Hapus" aria-label="Hapus <?= html_escape($r['vendor_name']) ?>" data-id="<?= (int) $r['idmaster_vendor'] ?>" data-nama="<?= html_escape($r['vendor_name']) ?>" @click="remove($el.dataset.id, $el.dataset.nama)" class="action action-delete" >
                                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M6 7h12M9 7V5.5A1.5 1.5 0 0 1 10.5 4h3A1.5 1.5 0 0 1 15 5.5V7m2 0-.7 11a2 2 0 0 1-2 1.9H9.7a2 2 0 0 1-2-1.9L7 7m3 4v5m4-5v5" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                            <tr x-show="filteredCount === 0" x-cloak>
                                <td colspan="6" class="empty">Data vendor tidak ditemukan.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

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
</div>
