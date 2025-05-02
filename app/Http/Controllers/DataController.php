<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\DataMou;
use App\Models\DataPks;
use App\Models\User;
use App\Models\ActivityLog;
use Illuminate\Support\Facades\Auth;

class DataController extends Controller
{
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
            'nama' => 'required',
            'judul' => 'required',
            'tanggal_mulai' => 'required|date',
            'tanggal_berakhir' => 'required|date',
            'tujuan' => 'required',
            'file_mou' => 'nullable|file|mimes:pdf,doc,docs,jpg,jpeg,png|max:5120',
        ]);

        $filePath = null;
        // $fileType = null;

        if ($request->hasFile('file_mou')) {
            $file = $request->file('file_mou');
            $filePath = $file->store('mou_files', 'public');
            // $fileType = $file->getClientMimeType();
        }

        $data = DataMou::create([
            'nomormou' => $request->nomormou,
            'nama' => $request->nama,
            'judul' => $request->judul,
            'tanggal_mulai' => $request->tanggal_mulai,
            'tanggal_berakhir' => $request->tanggal_berakhir,
            'tujuan' => $request->tujuan,
            'file_mou' => $filePath,
            // 'file_type' => $fileType,
        ]);

        ActivityLog::create([
            'user_id' => $user->id,
            'action' => 'Upload MOU',
            'description' => 'Mengunggah data MOU baru dengan nomor ' . $request->nomormou,
        ]);
        
        return response()->json([
            'message' => 'Berhasil upload data MOU!',
            'data' => $data,
        ]);
    }

    public function updatemou(Request $request, $id)
    {
        $user = $request->user();
        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $request->validate([
            'nama' => 'sometimes|required',
            'judul' => 'sometimes|required',
            'tanggal_mulai' => 'sometimes|required|date',
            'tanggal_berakhir' => 'sometimes|required|date',
            'tujuan' => 'sometimes|required',
            'file_mou' => 'nullable|file|mimes:pdf,doc,docs,jpg,jpeg,png|max:5120',
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

        $mou->fill($request->except('file_mou'));
        $changes = $mou->getDirty();

        $mou->save();

        $detailChanges = [];
        foreach ($changes as $field => $newVal) {
            $oldVal = $original[$field] ?? '-';
            $detailChanges[] = "$field: '$oldVal'→'$newVal'";
        }

        $changedFields = implode(', ', array_keys($changes));

        ActivityLog::create([
            'user_id' => $user->id,
            'action' => 'Update MOU',
            'description' => 'Memperbarui data MOU. Perubahan: ' . implode(', ', $detailChanges),
        ]);

        $mou->fill($request->except('file_mou'))->save();

        return response()->json([
            'message' => 'Data MOU berhasil diupdate',
            'data' => $mou
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
            'tujuan' => 'required',
        ]);

        $mou = DataMou::where('nomormou', $validate['nomormou'])->first();

        if (!$mou) {
            return response()->json([
                'message' => 'Data MOU tidak ditemukan',
            ], 404);
        }
        $filePath = null;

        if ($request->hasFile('file_pks')) {
            $file = $request->file('file_pks');
            $filePath = $file->store('pks_files', 'public');
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
            'tujuan' => $validate['tujuan'],
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
            'tujuan' => 'sometimes|required',
            'file_pks' => 'nullable|file|mimes:pdf,doc,docs,jpg,jpeg,png|max:5120',
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

        ActivityLog::create([
            'user_id' => $user->id,
            'action' => 'Update PKS',
            'description' => 'Memperbarui data PKS. Perubahan: ' . implode(', ', $detailChanges),
        ]);

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
}
