import 'dart:convert';
import 'package:rispro/data/vendor_data.dart';
import 'package:rispro/domain/service/ai_service.dart';

class SimulationAIService {
  final AIService mistral = AIService();
  final randomSeed = DateTime.now().millisecondsSinceEpoch;
  final List<Map<String, dynamic>> history = [];

   static final SimulationAIService _instance =
      SimulationAIService._internal();
      

        SimulationAIService._internal();


  factory SimulationAIService() {
    return _instance;
  }
  Map<String, dynamic> totalImpact = {
    "cost": 0,
    "time": 0,
    "risk": 0,
  };

  /// =========================
  /// 🔥 AGENT RULE
  /// =========================
  String buildAgentInstruction(VendorData vendor) {
    if (vendor.riskLevel == "high") {
      return "Prioritaskan mitigasi risiko walaupun cost/time naik.";
    } else if (vendor.rating > 4.5) {
      return "Vendor sangat baik, boleh ambil keputusan cepat.";
    } else {
      return "Gunakan strategi seimbang antara cost, time, dan risk.";
    }
  }

  /// =========================
  /// 🔥 RAG HELPER
  /// =========================
  Future<String> ragContext(String query) async {
    final docs = await mistral.retrieve(query);
    return docs.join("\n---\n");
  }

  /// =========================
  /// 🔥 AGENT + RAG GENERATOR
  /// =========================
  Future<String> agentRAG({
    required String query,
    required VendorData vendor,
  }) async {
    final context = await ragContext(query);
    final instruction = buildAgentInstruction(vendor);

    final prompt = """
Kamu adalah AI Agent simulasi manajemen risiko proyek publik.

KONTEKS:
$context

DATA VENDOR:
- Nama: ${vendor.name}
- Rating: ${vendor.rating}
- Risk: ${vendor.riskLevel}

RULE:
$instruction

TUGAS:
$query

WAJIB:
- Gunakan konteks jika relevan
- Gunakan logika vendor
- Output JSON jika diminta
""";

    return await mistral.chat(prompt);
  }

  /// =========================
  /// 🔥 VENDOR GENERATION (RAG IMPROVED)
  /// =========================
  Future<VendorData> generateVendor() async {
    final context = await ragContext("vendor proyek publik indonesia");

    final prompt = """
SEED: $randomSeed

KONTEKS:
$context

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
      final result = await mistral.chat(prompt);

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
  /// 🔥 SCENE 3 (RAG + AGENT)
  /// =========================
  Future<Map<String, dynamic>> generateScene3Decision(
      VendorData vendor) async {

            final context = await ragContext("manajemen risiko certainty proyek publik");

   final result = await agentRAG(
  vendor: vendor,
  query: """

KONSEP DASAR (WAJIB DIGUNAKAN):

Certainty:
Kondisi dengan informasi lengkap dan pasti (deterministik). Keputusan harus optimal dan efisien.

Risk (ISO 31000):
Risiko adalah efek dari ketidakpastian terhadap tujuan.
Dinilai dari:
- probabilitas (kemungkinan)
- dampak (cost, time, dll)

Uncertainty:
Tidak digunakan di scene ini karena semua data pasti.

KONTEKS:
$context

⚠️ WAJIB:
- Output hanya JSON VALID
- Tidak boleh ada teks di luar JSON
- Tidak boleh markdown
- HARUS dimulai { dan diakhiri }
- ANGKA tidak boleh pakai tanda +

=====================================
DATA VENDOR (PASTI / CERTAINTY)
=====================================
- Rating: ${vendor.rating}
- SuccessRate: ${vendor.successRate}
- RiskLevel: ${vendor.riskLevel}

INTERPRETASI:
- Rating tinggi + success tinggi → vendor sangat reliable
- RiskLevel rendah → risiko kecil
- Karena certainty → keputusan terbaik harus jelas (tidak spekulatif)

Setiap angka HARUS merepresentasikan konsekuensi logis keputusan.

Gunakan prinsip:
- Efisiensi → risk naik
- Keamanan → cost/time naik
- Perubahan besar → semua naik

=====================================
TUGAS
=====================================

1. Buat narasi singkat (maks 2 kalimat) berbasis DATA (bukan asumsi).

2. Buat 3 pilihan keputusan:

1. Langsung kontrak  
→ Efisien (time cepat), risk sedikit naik karena tanpa validasi tambahan  

2. Audit ulang  
→ Lebih aman (risk turun), tapi cost dan time naik  

3. Cari vendor baru  
→ Risk bisa berubah tidak pasti, cost dan time meningkat signifikan  

=====================================
ATURAN NILAI (WAJIB LOGIS & KETAT)
=====================================

BATAS:
- cost: 0 sampai 30
- time: -10 sampai 30
- risk: -10 sampai 20

RULE WAJIB:
- Tidak boleh semua nilai positif
- Tidak boleh semua nilai negatif
- HARUS ADA trade-off nyata

LOGIKA CERTAINTY:
- Keputusan optimal = cost rendah + time cepat + risk terkendali
- Jika terlalu aman → cost/time naik
- Jika terlalu cepat → risk naik

RELASI WAJIB:
- Jika time turun (negatif) → risk HARUS naik (positif)
- Jika risk turun (negatif) → cost ATAU time HARUS naik
- Jika cost rendah → risk atau time harus naik

=====================================
OUTPUT JSON
=====================================

{
  "scene": "Vendor Selection - Certainty",
  "narration": "string",
  "choices": [
    {
      "text": "Langsung kontrak",
      "impact": {
        "cost": number,
        "time": number,
        "risk": number
      },
      "feedback": "string"
    },
    {
      "text": "Audit ulang",
      "impact": {
        "cost": number,
        "time": number,
        "risk": number
      },
      "feedback": "string"
    },
    {
      "text": "Cari vendor baru",
      "impact": {
        "cost": number,
        "time": number,
        "risk": number
      },
      "feedback": "string"
    }
  ]
}

""",
);

    final cleaned = result
        .replaceAll("```json", "")
        .replaceAll("```", "")
        .trim();

    return jsonDecode(cleaned);
  }

  /// =========================
  /// 🔥 SCENE 4 (STATEFUL + RAG)
  /// =========================
  Future<Map<String, dynamic>> generateScene4Risk(
    VendorData vendor,
    String lastChoice,
    Map impact,
  ) async {
        final context = await ragContext("risk proyek keterlambatan material");

    final result = await agentRAG(
      vendor: vendor,
      query: """
KONSEP:
Risk = probabilitas bisa dihitung.

KONTEKS:
$context


KASUS:
Keterlambatan material.


Setiap angka HARUS merepresentasikan konsekuensi logis keputusan.

Gunakan prinsip:
- Efisiensi → risk naik
- Keamanan → cost/time naik
- Perubahan besar → semua naik

⚠️ WAJIB:
- Output hanya JSON VALID
- Tidak boleh ada teks selain JSON
- Tidak boleh markdown
- Harus dimulai { dan diakhiri }
- Ada trade-off jelas
- Risiko meningkat jika efisiensi tinggi


KONDISI:
Terjadi keterlambatan material.

DATA:
- Choice: $lastChoice
- Cost: ${totalImpact["cost"]}
- Time: ${totalImpact["time"]}
- Risk: ${totalImpact["risk"]}

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

Output JSON
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
}.
""",
    );

    final cleaned = result
        .replaceAll("```json", "")
        .replaceAll("```", "")
        .trim();

    return jsonDecode(cleaned);
  }

  /// =========================
  /// 🔥 SCENE 5 (UNCERTAINTY + RAG)
  /// =========================
  Future<Map<String, dynamic>> generateScene5Uncertainty(
    VendorData vendor,
    Map prevImpact,
  ) async {
        final context = await ragContext("uncertainty proyek cuaca ekstrem");

    final result = await agentRAG(
      vendor: vendor,
      query: """
KONSEP:
Uncertainty = tidak ada data pasti.

KONTEKS:
$context


Setiap angka HARUS merepresentasikan konsekuensi logis keputusan.

Gunakan prinsip:
- Efisiensi → risk naik
- Keamanan → cost/time naik
- Perubahan besar → semua naik


KASUS:
Cuaca ekstrem tidak dapat diprediksi.

⚠️ WAJIB:
- Output hanya JSON VALID
- Tidak boleh ada teks tambahan
- Tidak boleh markdown (**, ###, dll)
- Tidak boleh penjelasan
- HARUS dimulai { dan diakhiri }

KONDISI:
Terjadi ketidakpastian tinggi akibat cuaca ekstrem yang tidak dapat diprediksi.
Tidak ada data pasti, keputusan harus diambil dalam kondisi tidak jelas.

DATA :
- Vendor: ${vendor.name}
- Cost: ${totalImpact["cost"]}
- Time: ${totalImpact["time"]}
- Risk: ${totalImpact["risk"]}


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


Buat 3 pilihan dengan dampak buruk (semua positif).

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
""",
    );

    final cleaned = result
        .replaceAll("```json", "")
        .replaceAll("```", "")
        .trim();

    return jsonDecode(cleaned);
  }

  /// =========================
  /// 🔥 FINAL ANALYSIS (RAG)
  /// =========================
  Future<Map<String, dynamic>> generateFinalAnalysis(Map total) async {
        final context = await mistral.retrieve(
        "evaluasi keputusan manajemen risiko proyek publik");
        final historyText = history.map((h) {
      return """
Scene: ${h["scene"]}
Choice: ${h["choice"]}
Cost: ${h["impact"]["cost"]}
Time: ${h["impact"]["time"]}
Risk: ${h["impact"]["risk"]}
""";
    }).join("\n---\n");

      final result = await mistral.generateWithRAG("""
Kamu adalah evaluator simulasi manajemen risiko berbasis ISO 31000.

KONTEKS:
${context.join("\n")}

HISTORY KEPUTUSAN:
$historyText

DATA TOTAL:
- Cost: ${total["cost"]}
- Time: ${total["time"]}
- Risk: ${total["risk"]}

========================
METODE PENILAIAN WAJIB
========================

1. Cost Overrun:
- < 20 = rendah
- 20–50 = sedang
- > 50 = tinggi

2. Risk Exposure:
- Risk = total risk
- < 30 = low
- 30–60 = medium
- > 60 = high

3. Public Accountability:
- Score tinggi jika:
  - Risk rendah
  - Tidak banyak keputusan ekstrem
- Skala 0–100

========================
KLASIFIKASI USER
========================
- Risk > 60 → Risk Seeker
- Risk 30–60 → Risk Neutral
- Risk < 30 → Risk Averse

========================
TUGAS
========================
Hitung dan hasilkan:

1. profile
2. riskLevel
3. costLevel
4. publicScore (0–100)

ANALISIS:
- Pola keputusan user
- Efektivitas mitigasi
- Dampak terhadap proyek

========================
FORMAT JSON (WAJIB)
========================
{
  "profile": "Risk Averse / Risk Neutral / Risk Seeker",
  "riskLevel": "low/medium/high",
  "costLevel": "low/medium/high",
  "publicScore": number,
  "summary": "string",
  "mitigation": "string",
  "recommendation": "string",
  "learningInsight": "string"
}
""");

    final cleaned = result
        .replaceAll("```json", "")
        .replaceAll("```", "")
        .trim();

    return jsonDecode(cleaned);
  }

  /// =========================
  /// 🔥 FINAL ADVANCED ANALYSIS
  /// =========================
  Future<Map<String, dynamic>> generateFinalAnalysisScane7(
      Map total) async {

          final context = await mistral.retrieve("manajemen risiko proyek publik evaluasi");
    final historyText = history.map((h) {
      return """
${h["scene"]} → ${h["choice"]}
""";
    }).join("\n");


    final result = await mistral.generateWithRAG("""
Analisis profil risiko user berdasarkan simulasi manajemen risiko proyek.

HISTORY:
$historyText

DATA:
- Total Risk: ${total["risk"]}

========================
ATURAN PENILAIAN
========================

KLASIFIKASI RISK:
- Risk < 30 → Low
- Risk 30–60 → Medium
- Risk > 60 → High

PROFIL USER:
- High → Risk Seeker
- Medium → Risk Neutral
- Low → Risk Averse

========================
DISTRIBUSI SKOR (%)
========================

Gunakan total risk untuk menentukan distribusi:

Jika Risk tinggi (>60):
- aggressive: 60–80
- balance: 10–30
- avoidance: 0–20

Jika Risk sedang (30–60):
- balance: 40–60
- aggressive: 20–40
- avoidance: 20–40

Jika Risk rendah (<30):
- avoidance: 60–80
- balance: 10–30
- aggressive: 0–20

⚠️ WAJIB:
- Total = 100
- Semua integer
- Tidak boleh negatif

========================
PUBLIC SCORE
========================

- Risk rendah → publicScore tinggi (70–100)
- Risk sedang → publicScore sedang (40–70)
- Risk tinggi → publicScore rendah (0–40)

========================
TUGAS
========================

Hasilkan:
1. profile
2. score (avoidance, balance, aggressive)
3. riskLevel
4. efficiency (berdasarkan keseimbangan keputusan)
5. publicScore
6. analysis
7. impactSummary
8. recommendation

Gunakan HISTORY untuk membaca pola keputusan user.

========================
FORMAT JSON (WAJIB)
========================
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

""");

    final cleaned = result
        .replaceAll("```json", "")
        .replaceAll("```", "")
        .trim();

    return jsonDecode(cleaned);
  }

  void updateImpact(Map<String, dynamic> impact) {
  totalImpact["cost"] += impact["cost"];
  totalImpact["time"] += impact["time"];
  totalImpact["risk"] += impact["risk"];

}

Map<String, dynamic> getTotalImpact() {
    return totalImpact;
  }

  void resetImpact() {
    totalImpact = {
      "cost": 0,
      "time": 0,
      "risk": 0,
    };
  }

void addHistory({
  required String scene,
  required String choice,
  required Map<String, dynamic> impact,
}) {
  history.add({
    "scene": scene,
    "choice": choice,
    "impact": impact,
  });
}


}