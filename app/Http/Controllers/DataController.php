<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\DataMou;
use App\Models\DataPks;
use App\Models\pkl;
use App\Models\User;
use App\Models\ActivityLog;
use App\Models\DetailProgress;
use Illuminate\Support\Facades\Auth;

class DataController extends Controller
{
    public function getmou()
    {
        $data = DataMou::all();
        return response()->json($data);
    }

    public function getmouid($id)
    {
        $mou = DataMou::find($id);
        if (!$mou) {
            return response()->json(['message' => 'Data MOU tidak ditemukan'], 404);
        }
        return response()->json($mou);
    }

    public function uploadmou(Request $request)
    {
        // $user = auth()->user();
        // if (!$user) {
        //     return response()->json(['message' => 'Unauthorized'], 401);
        // }
        $user = $request->user();
        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $request->validate([
            'nomormou' => 'required',
            'nomormou2' => 'required',
            'nama' => 'required',
            'judul' => 'required',
            'tanggal_mulai' => 'required|date',
            'tanggal_berakhir' => 'required|date',
            'ruanglingkup' => 'required',
            'file_mou' => 'nullable|file|mimes:pdf,doc,docs,docx,jpg,jpeg,png|max:5120',

            'nama1' => 'required',
            'jabatan1' => 'required',
            'alamat1' => 'required',
            'nama2' => 'required',
            'jabatan2' => 'required',
            'alamat2' => 'required',
        ]);

        $filePath = null;
        $fileName = null;
        // $fileType = null;

        if ($request->hasFile('file_mou')) {
            $file = $request->file('file_mou');
            $fileName = $file->getClientOriginalName();
            $filePath = $file->storeAs('mou_files',$fileName,'public');
            // $fileType = $file->getClientMimeType();
        }

        $data = DataMou::create([
            'nomormou' => $request->nomormou,
            'nomormou2' => $request->nomormou2,
            'nama' => $request->nama,
            'judul' => $request->judul,
            'tanggal_mulai' => $request->tanggal_mulai,
            'tanggal_berakhir' => $request->tanggal_berakhir,
            'ruanglingkup' => $request->ruanglingkup,
            'file_mou' => $filePath,
            'file_name' => $fileName,
            'pihak1' => [
                'nama' => $request->nama1,
                'jabatan' => $request->jabatan1,
                'alamat' => $request->alamat1,
            ],
            'pihak2' => [
                'nama' => $request->nama2,
                'jabatan' => $request->jabatan2,
                'alamat' => $request->alamat2,
            ],
        ]);

        $progress = DetailProgress::create([
            'data_mou_id' => $data->id,
            'tanggal' => now()->toDateString(),
            'aktivitas' => 'Draft MOU dikirim ke mitra',
        ]);

        ActivityLog::create([
            'user_id' => $user->id,
            'action' => 'Upload MOU',
            'description' => 'Mengunggah data MOU baru dengan nomor ' . $request->nomormou,
        ]);
        
        return response()->json([
            'message' => 'Berhasil upload data MOU!',
            'data' => $data,
            'progress' => $progress,
        ]);
    }

    public function updatemou(Request $request, $id)
    {
        $user = $request->user();
        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $request->validate([
            'nomormou2' => 'sometimes|required',
            'nama' => 'sometimes|required',
            'judul' => 'sometimes|required',
            'tanggal_mulai' => 'sometimes|required|date',
            'tanggal_berakhir' => 'sometimes|required|date',
            'ruanglingkup' => 'sometimes|required',
            'file_mou' => 'nullable|file|mimes:pdf,doc,docs,jpg,jpeg,png|max:5120',
            'file_name' => 'sometimes|required',
            'keterangan' => 'sometimes|required|in:Diajukan,Disetujui,Dibatalkan',

            'nama1' => 'sometimes|required',
            'jabatan1' => 'sometimes|required',
            'alamat1' => 'sometimes|required',
            'nama2' => 'sometimes|required',
            'jabatan2' => 'sometimes|required',
            'alamat2' => 'sometimes|required',
        ]);

        $mou = DataMou::find($id);
        if(!$mou) {
            return response()->json(['message' => 'Data MOU tidak ditemukan'], 404);
        }

        $original = $mou->getOriginal();
        
        if ($request->hasFile('file_mou')) {
            $file = $request->file('file_mou');
            $filePath = $file->store('mou_files','public');
            $mou->file_mou = $filePath;
        }

        $mou->fill($request->except('file_mou', 'pihak1', 'pihak2'));

        //Update pihak1
        if ($request->hasAny(['nama1', 'jabatan1', 'alamat1'])) {
            $pihak1 = $mou->pihak1 ?? [];
            $mou->pihak1 = [
                'nama' => $request->nama1 ?? $pihak1['nama'] ?? null,
                'jabatan' => $request->jabatan1 ?? $pihak1['jabatan'] ?? null,
                'alamat' => $request->alamat1 ?? $pihak1['alamat'] ?? null,
            ];
        }

        //Update pihak2
        if($request->hasAny(['nama2', 'jabatan2', 'alamat2'])) {
            $pihak2 = $mou->pihak2 ?? [];
            $mou->pihak2 = [
                'nama' => $request->nama2 ?? $pihak2['nama'] ?? null,
                'jabatan' => $request->jabatan2 ?? $pihak2['jabatan'] ?? null,
                'alamat' => $request->alamat2 ?? $pihak2['alamat'] ?? null,
            ];
        }

        $changes = $mou->getDirty();

        $mou->save();

        $detailChanges = [];
        foreach ($changes as $field => $newVal) {
            $oldVal = $original[$field] ?? '-';
            $detailChanges[] = "$field: '$oldVal'→'$newVal'";
        }

        $changedFields = implode(', ', array_keys($changes));

        $progress = DetailProgress::create([
            'data_mou_id' => $mou->id,
            'tanggal' => now()->toDateString(),
            'aktivitas' => 'Revisi dokumen diterima dengan perubahan: ' . implode(', ', $detailChanges),
        ]);

        // ActivityLog::create([
        //     'user_id' => $user->id,
        //     'action' => 'Update MOU',
        //     'description' => 'Memperbarui data MOU. Perubahan: ' . implode(', ', $detailChanges),
        // ]);

        $mou->fill($request->except('file_mou'))->save();

        return response()->json([
            'message' => 'Data MOU berhasil diupdate',
            'progress' => $progress,
            'data' => $mou,
        ]);
    }

    public function patchKeteranganMou(Request $request, $id)
{
    $user = $request->user();
    if (!$user) {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    $request->validate([
        'keterangan' => 'required|in:Diajukan,Disetujui,Dibatalkan',
    ]);

    $mou = DataMou::find($id);
    if (!$mou) {
        return response()->json(['message' => 'Data MOU tidak ditemukan'], 404);
    }

    $oldValue = $mou->keterangan;
    $mou->keterangan = $request->keterangan;
    $mou->save();

    // Tambahkan log progress
    $progress = DetailProgress::create([
        'data_mou_id' => $mou->id,
        'tanggal' => now()->toDateString(),
        'aktivitas' => "Status MOU diubah dari '$oldValue' menjadi '{$request->keterangan}'",
    ]);

    // Tambahkan log aktivitas
    ActivityLog::create([
        'user_id' => $user->id,
        'action' => 'Update Keterangan MOU',
        'description' => "Mengubah status keterangan MOU dengan nomor {$mou->nomormou} dari '$oldValue' ke '{$request->keterangan}'",
    ]);

    return response()->json([
        'message' => 'Keterangan MOU berhasil diperbarui',
        'data' => $mou,
        'progress' => $progress,
    ]);
}


    public function deletemou(Request $request, $id)
    {
        $user = $request->user();
        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $mou = DataMou::find($id);

        if (!$mou) {
            return response()->json([
                'message' => 'Data Mou tidak ditemukan'
            ], 404);
        }

        if ($mou->file_mou) {
            \Storage::disk('public')->delete($mou->file_mou);
        }

        $mou->delete();

        ActivityLog::create([
            'user_id' => $user->id,
            'action' => 'Hapus MOU',
            'description' => 'Hapus data MOU dengan nomor ' . $mou->nomormou,
        ]);

        return response()->json([
            'message' => 'Data MOU berhasil dihapus'
        ]);
    }

    public function getpks()
    {
        $data = DataPks::all();
        return response()->json($data);
    }

    public function getpksid($id)
    {
        $pks = DataPks::find($id);
        if (!$pks) {
            return response()->json(['message' => 'Data PKS tidak ditemukan'], 404);
        }
        return response()->json($pks);
    }

    public function uploadpks(Request $request)
    {
        $user = $request->user();
        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $validate = $request->validate([
            'nomormou' => 'required',
            'nomorpks' => 'required',
            'judul' => 'required',
            'tanggal_mulai' => 'required|date',
            'tanggal_berakhir' => 'required|date',
            'namaunit' => 'required',
            'file_pks' => 'nullable|file|mimes:pdf,doc,docs,jpg,jpeg,png|max:5120',
            'ruanglingkup' => 'required',
        ]);

        $mou = DataMou::where('nomormou', $validate['nomormou'])->first();

        if (!$mou) {
            return response()->json([
                'message' => 'Data MOU tidak ditemukan',
            ], 404);
        }
        $filePath = null;
        $fileName = null;

        if ($request->hasFile('file_pks')) {
            $file = $request->file('file_pks');
            $fileName = $file->getClientOriginalName();
            $filePath = $file->storeAs('pks_files',$fileName,'public');
            // $fileType = $file->getClientMimeType();
        }

        $data = DataPks::create([
            'nomormou' => $validate['nomormou'],
            'nomorpks' => $validate['nomorpks'],
            'judul' => $validate['judul'],
            'tanggal_mulai' => $validate['tanggal_mulai'],
            'tanggal_berakhir' => $validate['tanggal_berakhir'],
            'namaunit' => $validate['namaunit'],
            'file_pks' => $filePath,
            'file_name' => $fileName,
            'ruanglingkup' => $validate['ruanglingkup'],
        ]);
        
        ActivityLog::create([
            'user_id' => $user->id,
            'action' => 'Upload PKS',
            'description' => 'Mengunggah data PKS baru dengan nomor ' . $request->nomorpks,
        ]);

        $data->mou()->attach($mou->id);

        return response()->json([
            'message' => 'Berhasil upload data PKS!',
            'data' => $data
        ]);
    }

    public function updatepks(Request $request, $id)
    {
        $user = $request->user();
        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $request->validate([
            'judul' => 'sometimes|required',
            'tanggal_mulai' => 'sometimes|required|date',
            'tanggal_berakhir' => 'sometimes|required|date',
            'namaunit' => 'sometimes|required',
            'ruanglingkup' => 'sometimes|required',
            'file_pks' => 'nullable|file|mimes:pdf,doc,docs,jpg,jpeg,png|max:5120',
            'keterangan' => 'sometimes|required|in:Diajukan,Disetujui,Dibatalkan',
        ]);

        $pks = DataPks::find($id);
        if (!$pks) {
            return response()->json(['message' => 'Data PKS tidak ditemukan'],);
        }

        $original = $pks->getOriginal();

        if ($request->hasFile('file_pks')) {
            $file = $request->file('file_pks');
            $filePath = $file->store('pks_files','public');
            $pks->file_pks = $filePath;
        }
        $pks->fill($request->except('file_pks'));

        $changes = $pks->getDirty();

        $pks->save();

        $detailChanges = [];
        foreach ($changes as $field => $newVal) {
            $oldVal = $original[$field] ?? '-';
            $detailChanges[] = "$field: '$oldVal'→'$newVal'";
        }

        $changedFields = implode(', ', array_keys($changes));

        // ActivityLog::create([
        //     'user_id' => $user->id,
        //     'action' => 'Update PKS',
        //     'description' => 'Memperbarui data PKS. Perubahan: ' . implode(', ', $detailChanges),
        // ]);

        $pks->fill($request->except('file_pks'))->save();

        return response()->json([
            'message' => 'Data PKS berhasil diupdate',
            'data' => $pks
        ]);
    }

    public function deletepks(Request $request, $id)
    {
        $user = $request->user();
        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $pks = DataPks::find($id);

        if (!$pks) {
            return response()->json([
                'message' => 'Data PKS tidak ditemukan'
            ], 404);
        }

        if ($pks->file_pks) {
            \Storage::disk('public')->delete($pks->file_pks);
        }

        $pks->delete();

        ActivityLog::create([
            'user_id' => $user->id,
            'action' => 'Hapus PKS',
            'description' => 'Hapus data MOU dengan nomor ' . $pks->nomorpks,
        ]);

        return response()->json([
            'message' => 'Data PKS berhasil dihapus'
        ]);
    }

    public function getpkl()
    {
        $data = pkl::all();
        return response()->json($data);
    }

    public function getpklid($id)
    {
        $pkl = pkl::find($id);
        if (!$pkl) {
            return response()->json(['message' => 'Data PKL tidak ditemukan'], 404);
        }
        return response()->json($pkl);
    }

    public function uploadpkl(Request $request)
    {
        $user = $request->user();
        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        if ($user->role === 'userpkl') {
            $jumlahPkl = pkl::where('user_id', $user->id)->count();
            if ($jumlahPkl >= 3) {
                return response()->json([
                    'message' => 'Anda hanya bisa mengajukan PKL maksimal 3 NISN.'
                ], 403);
            }
        }

        $request->validate([
            'nisn' => 'required|unique:pkl,nisn',
            'sekolah' => 'required',
            'nama' => 'required',
            'gender' => 'required|in:laki-laki,perempuan',
            'tanggal_mulai' => 'required|date',
            'tanggal_berakhir' => 'required|date',
            'file_pkl' => 'nullable|file|mimes:pdf,doc,docs,jpg,jpeg,png|max:5120',
            'telpemail' => 'required',
            'alamat' => 'required',
        ]);

        $filePath = null;
        $fileName = null;
        // $fileType = null;

        if ($request->hasFile('file_pkl')) {
            $file = $request->file('file_pkl');
            $fileName = $file->getClientOriginalName();
            $filePath = $file->storeAs('pkl_files',$fileName,'public');
            // $fileType = $file->getClientMimeType();
        }

        try{
            $data = pkl::create([
                'user_id' => $user->id,
                'nisn' => $request->nisn,
                'sekolah' => $request->sekolah,
                'nama' => $request->nama,
                'gender' => $request->gender,
                'tanggal_mulai' => $request->tanggal_mulai,
                'tanggal_berakhir' => $request->tanggal_berakhir,
                'file_pkl' => $filePath,
                'file_name' => $fileName,
                'telpemail' => $request->telpemail,
                'alamat' => $request->alamat,
                // 'file_type' => $fileType,
            ]);

            ActivityLog::create([
                'user_id' => $user->id,
                'action' => 'Pengajuan PKL',
                'description' => 'Pengajuan Kegiatan PKL dengan nomor NISN ' . $request->nisn,
            ]);
            
            return response()->json([
                'message' => 'Berhasil mengisi pengajuan PKL',
                'data' => $data,
            ]);
        } catch (\Illuminate\Database\QueryException $e) {
            if ($e->getCode() == 23000) {
                return response()->json([
                    'message' => 'NISN ' . $request->nisn . 'sudah melakukan pengajuan PKL.',
                ], 409);
            }
            return response()->json([
                'message' => 'Terjadi kesalahan saat menyimpan data',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function updatepkl(Request $request, $id)
    {
        $user = $request->user();
        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $request->validate([
            'nisn' => 'sometimes|required',
            'sekolah' => 'sometimes|required',
            'nama' => 'sometimes|required',
            'gender' => 'sometimes|required|in:laki-laki,perempuan',
            'tanggal_mulai' => 'sometimes|required|date',
            'tanggal_berakhir' => 'sometimes|required|date',
            'file_pkl' => 'nullable|file|mimes:pdf,doc,docs,jpg,jpeg,png|max:5120',
            'telpemail' => 'sometimes|required',
            'alamat' => 'sometimes|required',
            'status' => 'sometimes|required|in:Diproses,Disetujui,Ditolak'
        ]);

        $pkl = pkl::find($id);
        if(!$pkl) {
            return response()->json(['message' => 'Data PKL tidak ditemukan'], 404);
        }

        $original = $pkl->getOriginal();
        
        if ($request->hasFile('file_pkl')) {
            $file = $request->file('file_pkl');
            $filePath = $file->store('pkl_files','public');
            $pkl->file_pkl = $filePath;
        }

        $pkl->fill($request->except('file_pkl'));
        $changes = $pkl->getDirty();

        $pkl->save();

        $detailChanges = [];
        foreach ($changes as $field => $newVal) {
            $oldVal = $original[$field] ?? '-';
            $detailChanges[] = "$field: '$oldVal'→'$newVal'";
        }

        $changedFields = implode(', ', array_keys($changes));

        // \Log::info('Perubahan PKL: ', $changes);

        // ActivityLog::create([
        //     'user_id' => $user->id,
        //     'action' => 'Update PKL',
        //     'description' => 'Memperbarui data PKL. Perubahan: ' . implode(', ', $detailChanges),
        // ]);

        $pkl->fill($request->except('file_pkl'))->save();

        return response()->json([
            'message' => 'Data PKL berhasil diupdate',
            'data' => $pkl
        ]);
    }

    public function deletepkl(Request $request, $id)
    {
        $user = $request->user();
        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $pkl = pkl::find($id);

        if (!$pkl) {
            return response()->json([
                'message' => 'Data PKL tidak ditemukan'
            ], 404);
        }

        if ($pkl->file_pkl) {
            \Storage::disk('public')->delete($pkl->file_pkl);
        }

        $pkl->delete();

        ActivityLog::create([
            'user_id' => $user->id,
            'action' => 'Hapus Pengajuan PKL',
            'description' => 'Hapus data pengajuan PKL dengan NISN ' . $pkl->nisn,
        ]);

        return response()->json([
            'message' => 'Data PKL berhasil dihapus'
        ]);
    }
}
