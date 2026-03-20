import 'dart:convert';
import 'package:rispro/data/vendor_data.dart';
import 'package:rispro/domain/service/ai_service.dart';

class SimulationAIService {
  final AIService mistral = AIService();
  final randomSeed = DateTime.now().millisecondsSinceEpoch;

  /// =========================
  /// VENDOR GENERATION (IMPROVED)
  /// =========================
  Future<VendorData> generateVendor() async {
    final prompt = """
SEED: $randomSeed

Generate 1 vendor FIKTIF untuk proyek layanan publik digital di Indonesia.

ATURAN:
- Output HARUS JSON VALID
- Tidak boleh ada teks tambahan
- Tidak boleh array
- HARUS dimulai { dan diakhiri }

DISTRIBUSI:
- 30% vendor bagus (rating > 4.5)
- 50% vendor sedang (3.8 - 4.5)
- 20% vendor buruk (< 3.8)

BATAS:
- rating: 3.5 - 5.0
- successRate: 30 - 98
- projects: 10 - 100

KARAKTER:
- low price → high risk
- high price → low risk
- medium → medium

DESKRIPSI HARUS SESUAI karakter

FORMAT:
{
  "name": "string",
  "rating": number,
  "projects": integer,
  "successRate": integer,
  "priceLevel": "low/medium/high",
  "riskLevel": "low/medium/high",
  "description": "string",
  "image": "assets/AssetGame/Vendor.png"
}
""";

    try {
      final result = await mistral.generateScene(prompt);

      final cleaned = result
          .replaceAll("```json", "")
          .replaceAll("```", "")
          .trim();

      final json = jsonDecode(cleaned);
      return VendorData.fromJson(json);
    } catch (e) {
      return VendorData(
        name: "PT Default Vendor",
        rating: 4.0,
        projects: 50,
        successRate: 80,
        priceLevel: "medium",
        riskLevel: "medium",
        description: "Vendor fallback",
        image: "assets/AssetGame/Vendor.png",
      );
    }
  }

  /// =========================
  /// SCENE 3 - CERTAINTY
  /// =========================
  Future<Map<String, dynamic>> generateScene3Decision(
      VendorData vendor) async {
 final prompt = """
Kamu adalah AI decision engine simulasi proyek publik.

⚠️ WAJIB:
- Output hanya JSON VALID
- Tidak boleh ada teks di luar JSON
- Tidak boleh markdown
- HARUS dimulai { dan diakhiri }
- ANGKA tidak boleh pakai tanda + (contoh: 5 bukan +5)

KONDISI:
Semua data vendor VALID dan terpercaya.

DATA:
- Rating: ${vendor.rating}
- SuccessRate: ${vendor.successRate}
- RiskLevel: ${vendor.riskLevel}

TUGAS:
Buat:
- Narasi (1-2 kalimat)
- 3 pilihan:
  1. Langsung kontrak
  2. Audit ulang
  3. Cari vendor baru

BATAS NILAI:
- cost: 0 sampai 30 (TIDAK BOLEH negatif)
- time: -10 sampai 30
- risk: -10 sampai 20

ATURAN PENTING:
- Setiap pilihan HARUS memiliki trade-off
- Tidak boleh semua nilai positif atau semua negatif
- Jika time berkurang → risk harus naik
- Jika risk turun → cost atau time harus naik

LOGIKA PILIHAN:
1. Langsung kontrak:
   - cost rendah
   - time lebih cepat (negatif)
   - risk meningkat

2. Audit ulang:
   - cost meningkat
   - time meningkat
   - risk menurun signifikan

3. Cari vendor baru:
   - cost paling tinggi
   - time paling lama
   - risk paling rendah atau mendekati nol

FORMAT:
{
  "scene": "string",
  "choices": [
    {
      "text": "string",
      "impact": {
        "cost": number,
        "time": number,
        "risk": number
      },
      "feedback": "string"
    }
  ]
}
""";
    final result = await mistral.generateScene(prompt);

    final cleaned = result
        .replaceAll("```json", "")
        .replaceAll("```", "")
        .trim();

    return jsonDecode(cleaned);
  }

  /// =========================
  /// SCENE 4 - RISK (STATEFUL)
  /// =========================
  Future<Map<String, dynamic>> generateScene4Risk(
    VendorData vendor,
    String lastChoice,
    Map impact,
  ) async {
   final prompt = """
Kamu adalah AI simulasi risiko proyek publik.

⚠️ WAJIB:
- Output hanya JSON VALID
- Tidak boleh ada teks selain JSON
- Tidak boleh markdown
- Harus dimulai { dan diakhiri }

KONDISI:
Terjadi keterlambatan material.

DATA:
- Choice: $lastChoice
- Cost: ${impact["cost"]}
- Time: ${impact["time"]}
- Risk: ${impact["risk"]}

LOGIKA:
- Risk tinggi → kondisi makin parah
- Time tinggi → delay berat
- Cost tinggi → tekanan anggaran

PILIHAN:
1. Tambah anggaran
2. Optimasi SDM
3. Biarkan saja

BATAS NILAI IMPACT:
- cost: 0 sampai 30
- time: -10 sampai 30
- risk: -10 sampai 20

ATURAN PENTING:
- Setiap pilihan HARUS memiliki trade-off
- Tidak boleh semua nilai positif atau semua negatif
- Jika time berkurang → cost atau risk harus naik
- Jika risk turun → cost atau time harus naik

LOGIKA PILIHAN:
- Tambah anggaran → cost tinggi, time turun, risk turun
- Optimasi SDM → cost rendah, time sedikit turun, risk naik
- Biarkan saja → cost rendah, time naik besar, risk naik besar

FORMAT:
{
  "scene": "string",
  "choices": [
    {
      "text": "string",
      "impact": {
        "cost": number,
        "time": number,
        "risk": number
      },
      "feedback": "string"
    }
  ]
}
""";

    final result = await mistral.generateScene(prompt);

    final cleaned = result
        .replaceAll("```json", "")
        .replaceAll("```", "")
        .trim();

    return jsonDecode(cleaned);
  }

  /// =========================
  /// SCENE 5 - UNCERTAINTY (STATEFUL)
  /// =========================
  Future<Map<String, dynamic>> generateScene5Uncertainty(
    VendorData vendor,
    Map prevImpact,
  ) async {
    final prompt = """
Kamu adalah AI simulasi proyek publik.

⚠️ WAJIB:
- Output hanya JSON VALID
- Tidak boleh ada teks tambahan
- Tidak boleh markdown (**, ###, dll)
- Tidak boleh penjelasan
- HARUS dimulai { dan diakhiri }

KONDISI:
Terjadi ketidakpastian tinggi akibat cuaca ekstrem yang tidak dapat diprediksi.
Tidak ada data pasti, keputusan harus diambil dalam kondisi tidak jelas.

DATA SEBELUMNYA:
- Vendor: ${vendor.name}
- Cost: ${prevImpact["cost"]}
- Time: ${prevImpact["time"]}
- Risk: ${prevImpact["risk"]}

LOGIKA KONDISI:
- Risk tinggi → dampak semakin tidak terkendali
- Time tinggi → keterlambatan makin kritis
- Cost tinggi → tekanan anggaran meningkat

PILIHAN:
1. Tunda proyek
2. Lanjut dengan mitigasi
3. Ubah desain kerja

BATAS NILAI IMPACT:
- cost: 0 sampai 40
- time: 0 sampai 40
- risk: 0 sampai 40

ATURAN PENTING:
- Semua nilai HARUS positif (karena uncertainty = semua berdampak buruk)
- Tidak boleh ada nilai negatif
- Tidak boleh ada nilai 0 untuk semua (harus ada dampak)
- Setiap pilihan HARUS memiliki trade-off
- Tidak boleh semua pilihan terlihat sama

LOGIKA PILIHAN:

1. Tunda proyek:
   - cost naik sedang
   - time naik paling besar
   - risk sedikit menurun

2. Lanjut dengan mitigasi:
   - cost naik paling tinggi
   - time naik sedang
   - risk menurun cukup besar

3. Ubah desain kerja:
   - cost naik sedang
   - time naik sedikit
   - risk tetap tinggi (karena ketidakpastian belum hilang)

SKALA:
- Scene ini paling berat dibanding sebelumnya
- Gunakan nilai lebih besar dari Scene 4

FORMAT JSON:
{
  "scene": "string (narasi singkat kondisi uncertainty, 1-2 kalimat)",
  "choices": [
    {
      "text": "string",
      "impact": {
        "cost": number,
        "time": number,
        "risk": number
      },
      "feedback": "string"
    }
  ]
}
""";

    final result = await mistral.generateScene(prompt);

    final cleaned = result
        .replaceAll("```json", "")
        .replaceAll("```", "")
        .trim();

    return jsonDecode(cleaned);
  }

  /// =========================
  /// FINAL ANALYSIS (UPGRADED)
  /// =========================
  Future<Map<String, dynamic>> generateFinalAnalysis(Map total) async {
  final prompt = """
Kamu adalah evaluator simulasi manajemen risiko proyek publik.

⚠️ WAJIB:
- Output HARUS JSON VALID
- Tidak boleh teks tambahan
- Tidak boleh markdown
- HARUS dimulai { dan diakhiri }

DATA:
- Cost: ${total["cost"]}
- Time: ${total["time"]}
- Risk: ${total["risk"]}

TUGAS:
Evaluasi hasil keputusan user + buat refleksi pembelajaran.

LOGIKA:
- Risk tinggi → performa buruk
- Cost & time efisien → performa baik

KLASIFIKASI:
- Risk > 60 → Risk Seeker
- Risk 30-60 → Risk Neutral
- Risk < 30 → Risk Averse

WAJIB HASILKAN:

1. profile → tipe keputusan user
2. riskLevel → low/medium/high
3. efficiency → low/medium/high
4. publicScore → 0-100

5. summary → dampak keputusan terhadap proyek
6. mitigation → efektivitas mitigasi
7. recommendation → evaluasi strategi
8. learningInsight → insight pembelajaran simulasi

FORMAT JSON:
{
  "profile": "Risk Averse / Risk Neutral / Risk Seeker",
  "riskLevel": "low/medium/high",
  "efficiency": "low/medium/high",
  "publicScore": number,
  "summary": "string",
  "mitigation": "string",
  "recommendation": "string",
  "learningInsight": "string"
}
""";

  final result = await mistral.generateScene(prompt);

  final cleaned = result
      .replaceAll("```json", "")
      .replaceAll("```", "")
      .trim();

  return jsonDecode(cleaned);
}

  Future<Map<String, dynamic>> generateFinalAnalysisScane7(Map total) async {
  final prompt = """
Kamu adalah AI evaluator dalam simulasi manajemen risiko proyek publik.

⚠️ WAJIB:
- Output HARUS JSON VALID
- Tidak boleh ada teks tambahan
- Tidak boleh markdown
- HARUS dimulai { dan diakhiri }
- Semua key pakai tanda kutip ganda

DATA:
- Total Cost: ${total["cost"]}
- Total Time: ${total["time"]}
- Total Risk: ${total["risk"]}

TUGAS:
Analisis profil risiko user berdasarkan keputusan yang telah diambil.

KATEGORI (WAJIB PILIH SATU):
- Risk Averse
- Risk Neutral
- Risk Seeker

LOGIKA PENILAIAN:
- Risk tinggi → cenderung Risk Seeker
- Risk rendah → cenderung Risk Averse
- Seimbang → Risk Neutral

PERSENTASE (WAJIB TOTAL 100):
- avoidance (penghindaran risiko)
- balance (keputusan seimbang)
- aggressive (keputusan agresif)

ATURAN:
- Semua nilai integer
- Total HARUS = 100
- Harus realistis berdasarkan total risk

INTERPRETASI:
- avoidance dominan → Risk Averse
- balance dominan → Risk Neutral
- aggressive dominan → Risk Seeker

TAMBAHAN:
- publicScore: 0 - 100
- Score tinggi jika risk rendah & efisiensi baik

FORMAT JSON:
{
  "profile": "Risk Averse / Risk Neutral / Risk Seeker",
  "score": {
    "avoidance": number,
    "balance": number,
    "aggressive": number
  },
  "riskLevel": "low/medium/high",
  "efficiency": "low/medium/high",
  "publicScore": number,
  "analysis": "string",
  "impactSummary": "string",
  "recommendation": "string"
}
""";

  final result = await mistral.generateScene(prompt);

  final cleaned = result
      .replaceAll("```json", "")
      .replaceAll("```", "")
      .trim();

  return jsonDecode(cleaned);
}
}