import 'dart:convert';
import 'package:rispro/data/vendor_data.dart';
import 'package:rispro/domain/service/ai_service.dart';

class SimulationAIService {
  final AIService mistral = AIService();
final randomSeed = DateTime.now().millisecondsSinceEpoch;

  Future<VendorData> generateVendor() async {
  final prompt = """
SEED: $randomSeed

Generate 1 vendor FIKTIF untuk proyek layanan publik digital di Indonesia.

ATURAN UTAMA:
- HANYA boleh menghasilkan 1 object JSON
- DILARANG membuat array (tidak boleh pakai [])
- DILARANG menambahkan teks apapun di luar JSON
- Output HARUS langsung dimulai dengan { dan diakhiri }
- Nilai rating, projects, successRate HARUS berbeda setiap generate
- Gunakan kombinasi nama kreatif (contoh: Arkana, Vistara, Kinarya, dll)



REALISME:
- Nama vendor harus terdengar seperti perusahaan Indonesia (startup, konsultan IT, atau enterprise)
- Gunakan nama yang unik dan tidak generik
- Deskripsi harus singkat (1-2 kalimat) dan relevan dengan layanan digital publik

BATAS NILAI:
- rating: 3.5 - 5.0 (boleh desimal 1 angka, contoh: 4.3)
- successRate: 30 - 98 (integer)
- projects: 10 - 100 (integer)

KARAKTER (WAJIB PILIH SALAH SATU):
- murah tapi berisiko → priceLevel="low", riskLevel="high"
- mahal tapi stabil → priceLevel="high", riskLevel="low"
- cepat tapi kurang pengalaman → priceLevel="medium", riskLevel="medium"

KONSISTENSI:
- Jangan bertentangan (contoh: tidak boleh murah tapi riskLevel rendah)
- Description harus mencerminkan karakter vendor

FORMAT JSON WAJIB (RFC 8259):
- Semua key pakai tanda kutip ganda
- Semua string pakai tanda kutip ganda
- Tidak boleh trailing comma
- Tidak boleh komentar

OUTPUT FORMAT (HARUS SAMA PERSIS STRUKTURNYA):
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
      print(json);
      return VendorData.fromJson(json);
    } catch (e) {
      /// fallback biar tidak crash
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


  Future<Map<String, dynamic>> generateScene3Decision(VendorData vendor) async {
  final prompt = """
Kamu adalah AI decision engine untuk simulasi manajemen risiko proyek publik.
WAJIB:
- Semua key HARUS pakai tanda kutip ganda (")
- Semua string HARUS pakai tanda kutip ganda (")
- Contoh benar: {"scene": "text"}
- Contoh salah: {scene: text}

DATA VENDOR:
- Nama: ${vendor.name}
- Rating: ${vendor.rating}
- Projects: ${vendor.projects}
- SuccessRate: ${vendor.successRate}
- PriceLevel: ${vendor.priceLevel}
- RiskLevel: ${vendor.riskLevel}

KONDISI:
- Ini adalah SCENE 3 (CERTAINTY)
- Semua data vendor sudah lengkap dan terpercaya

TUGAS:
Buatkan:
- narasi singkat (1-2 kalimat)
- 3 pilihan keputusan
- dampak (cost, time, risk)
- feedback tiap pilihan

ATURAN:
- Output HARUS JSON VALID
- Tidak boleh ada teks tambahan
- Tidak boleh markdown

FORMAT:
{
  "scene": "string",
  "choices": [
    {
      "text": "string",
      "impact": {
        "cost": integer,
        "time": integer,
        "risk": integer
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


Future<Map<String, dynamic>> generateScene4Risk(
  VendorData vendor,
  String lastChoice,
  Map impact,
) async {
  final prompt = """
Kamu adalah AI decision engine untuk simulasi manajemen risiko proyek publik.

DATA VENDOR:
- Nama: ${vendor.name}
- Rating: ${vendor.rating}
- SuccessRate: ${vendor.successRate}

KEPUTUSAN SEBELUMNYA:
- Pilihan user: $lastChoice
- Dampak:
  - Cost: ${impact["cost"]}
  - Time: ${impact["time"]}
  - Risk: ${impact["risk"]}

KONDISI:
- Ini adalah SCENE 4 (RISK)
- Terjadi keterlambatan pengiriman material

TUGAS:
Buatkan skenario yang TERHUBUNG dengan keputusan sebelumnya.

LOGIKA:
- Jika user efisien → masalah lebih ringan
- Jika user lambat → masalah lebih parah

OUTPUT JSON VALID:
{
  "scene": "narasi sesuai kondisi sebelumnya",
  "choices": [
    {
      "text": "Tambah anggaran",
      "impact": {"cost": number, "time": number, "risk": number},
      "feedback": "string"
    },
    {
      "text": "Optimasi SDM",
      "impact": {"cost": number, "time": number, "risk": number},
      "feedback": "string"
    },
    {
      "text": "Biarkan saja",
      "impact": {"cost": number, "time": number, "risk": number},
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


Future<Map<String, dynamic>> generateScene5Uncertainty(
  VendorData vendor,
  Map prevImpact,
) async {
  final prompt = """
Kamu adalah AI simulasi manajemen risiko proyek publik.

KONTEKS:
Ini adalah SCENE 5 (UNCERTAINTY).

KONDISI:
- Terjadi cuaca ekstrem yang tidak dapat diprediksi
- Data tidak lengkap
- Tidak ada kepastian

DATA SEBELUMNYA:
Vendor: ${vendor.name}
Impact sebelumnya:
- Cost: ${prevImpact["cost"]}
- Time: ${prevImpact["time"]}
- Risk: ${prevImpact["risk"]}

TUGAS:
Buat:
1. Narasi singkat (1-2 kalimat)
2. 3 pilihan keputusan:
   - Tunda proyek
   - Lanjut dengan mitigasi
   - Ubah desain kerja
3. Setiap pilihan punya:
   - impact (cost, time, risk)
   - feedback

ATURAN:
- Output HARUS JSON VALID
- Tidak boleh teks tambahan
- Semua key pakai tanda kutip

FORMAT:
{
  "scene": "string",
  "choices": [
    {
      "text": "string",
      "impact": {
        "cost": int,
        "time": int,
        "risk": int
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
Future<Map<String, dynamic>> generateFinalAnalysis(Map total) async {
  final prompt = """
Kamu adalah AI evaluator keputusan proyek publik.

DATA:
- Total Cost: ${total["cost"]}
- Total Time: ${total["time"]}
- Total Risk: ${total["risk"]}

TUGAS:
Buat evaluasi dalam format JSON.

ATURAN:
- Output HARUS JSON VALID
- Tidak boleh ada teks tambahan
- Semua key pakai tanda kutip ganda

FORMAT:
{
  "style": "string",
  "riskLevel": "low/medium/high",
  "efficiency": "low/medium/high",
  "summary": "string",
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