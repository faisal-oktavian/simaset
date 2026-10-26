<?php foreach ($rows as $r): ?>
  <tr data-row class="border-b border-gray-100 dark:border-gray-800">
    
    <td class="px-5 py-4 sm:px-6">
      <p class="text-theme-sm text-gray-500 dark:text-gray-400"><?= html_escape($r['funding_name']) ?></p>
    </td>
    <td class="px-5 py-4 sm:px-6">
      <p class="text-theme-sm text-gray-500 dark:text-gray-400"><?= html_escape($r['description_funding']) ?></p>
    </td>
    <td class="px-5 py-4 sm:px-6">
      <?php if ($r['is_active']): ?>
        <p class="bg-success-50 text-theme-xs text-success-700 dark:bg-success-500/15 dark:text-success-500 inline-block rounded-full px-2 py-0.5 font-medium">Aktif</p>
      <?php else: ?>
        <p class="bg-error-50 text-theme-xs text-error-600 dark:bg-error-500/15 dark:text-error-500 inline-block rounded-full px-2 py-0.5 font-medium">Nonaktif</p>
      <?php endif; ?>
    </td>
    
    <td class="px-5 py-4 sm:px-6">
      <div class="flex items-center gap-2">
        <button type="button" title="Edit" @click="openEdit(<?= (int) $r['idmaster_funding_source'] ?>)" class="flex h-9 w-9 items-center justify-center rounded-lg border border-gray-200 text-gray-500 hover:bg-gray-100 hover:text-gray-700 dark:border-gray-800 dark:text-gray-400 dark:hover:bg-white/5 dark:hover:text-gray-200">
          <svg class="stroke-current" width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M16.862 3.487a2.25 2.25 0 1 1 3.182 3.182L7.5 19.213 3 21l1.787-4.5L16.862 3.487Z" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
        </button>
        <button type="button" title="Hapus" data-id="<?= (int) $r['idmaster_funding_source'] ?>" data-nama="<?= html_escape($r['funding_name']) ?>" @click="remove($el.dataset.id, $el.dataset.nama)" class="flex h-9 w-9 items-center justify-center rounded-lg border border-gray-200 text-error-500 hover:bg-error-50 dark:border-gray-800 dark:hover:bg-error-500/15">
          <svg class="stroke-current" width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M6 7h12M9 7V5.5A1.5 1.5 0 0 1 10.5 4h3A1.5 1.5 0 0 1 15 5.5V7m2 0-.7 11a2 2 0 0 1-2 1.9H9.7a2 2 0 0 1-2-1.9L7 7m3 4v5m4-5v5" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
        </button>
      </div>
    </td>
  </tr>
<?php endforeach; ?>
