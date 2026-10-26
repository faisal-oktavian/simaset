<?php foreach ($rows as $r): ?>
  <tr data-row class="row">
    <td class="cell">
      <p class="row-text"><?= html_escape($r['funding_name']) ?></p>
    </td>
    <td class="cell">
      <p class="row-text"><?= html_escape($r['description_funding']) ?></p>
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
        <button type="button" title="Edit" @click="openEdit(<?= (int) $r['idmaster_funding_source'] ?>)" class="action action-edit">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M16.862 3.487a2.25 2.25 0 1 1 3.182 3.182L7.5 19.213 3 21l1.787-4.5L16.862 3.487Z" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
        </button>
        <button type="button" title="Hapus" data-id="<?= (int) $r['idmaster_funding_source'] ?>" data-nama="<?= html_escape($r['funding_name']) ?>" @click="remove($el.dataset.id, $el.dataset.nama)" class="action action-delete">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M6 7h12M9 7V5.5A1.5 1.5 0 0 1 10.5 4h3A1.5 1.5 0 0 1 15 5.5V7m2 0-.7 11a2 2 0 0 1-2 1.9H9.7a2 2 0 0 1-2-1.9L7 7m3 4v5m4-5v5" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
        </button>
      </div>
    </td>
  </tr>
<?php endforeach; ?>
