-- Jalankan di Supabase: menu SQL Editor > New query > tempel > Run

create table if not exists laporan (
  id text primary key,
  tgl date not null,
  data jsonb not null,
  foto jsonb default '[]'::jsonb,
  created_at timestamptz default now()
);
create index if not exists laporan_tgl_idx on laporan (tgl);

create table if not exists master (
  id text primary key,
  data jsonb not null
);

alter table laporan enable row level security;
alter table master enable row level security;

-- Driver (tanpa login) boleh MELIHAT dan MENAMBAH laporan, tidak boleh mengubah/menghapus
create policy "baca laporan" on laporan for select to anon using (true);
create policy "tambah laporan" on laporan for insert to anon with check (true);

-- Menu Master (daftar crew, armada, dll.)
create policy "baca master" on master for select to anon using (true);
create policy "tambah master" on master for insert to anon with check (true);
create policy "ubah master" on master for update to anon using (true) with check (true);

-- OPSIONAL: aktifkan hanya jika Anda mau tombol hapus lewat web (kurang aman).
-- Secara bawaan laporan dihapus/dikoreksi admin lewat Supabase > Table Editor.
-- create policy "hapus laporan" on laporan for delete to anon using (true);

-- Izin akses untuk Data API (diperlukan jika "Automatically expose new tables" dimatikan; aman jika dibiarkan aktif)
grant usage on schema public to anon;
grant select, insert on public.laporan to anon;
grant select, insert, update on public.master to anon;
