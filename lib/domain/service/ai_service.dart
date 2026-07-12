import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class AIService {
  static const String apiKey = "WRZPeApzPupgXFip9EcvMfrt5Hk7OMTy";
 static const String chatUrl =
      "https://api.mistral.ai/v1/chat/completions";

  static const String embedUrl =
      "https://api.mistral.ai/v1/embeddings";

  final supabase = Supabase.instance.client;

  /// =========================
  /// CHAT (MISTRAL)
  /// =========================
  Future<String> chat(String prompt) async {
    final response = await http.post(
      Uri.parse(chatUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "model": "mistral-small",
        "messages": [
          {
            "role": "system",
            "content":
                "Kamu adalah AI untuk simulasi manajemen risiko proyek publik."
          },
          {"role": "user", "content": prompt}
        ],
        "temperature": 0.7
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Chat AI gagal: ${response.body}");
    }

    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'];
  }

  /// =========================
  /// EMBEDDING (MISTRAL)
  /// =========================
  Future<List<double>> getEmbedding(String text) async {
    final res = await http.post(
      Uri.parse(embedUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "model": "mistral-embed",
        "input": text
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Embedding gagal: ${res.body}");
    }

    final data = jsonDecode(res.body);
    return List<double>.from(data["data"][0]["embedding"]);
  }

  /// =========================
  /// VECTOR SEARCH (SUPABASE)
  /// =========================
  Future<List<String>> retrieve(String query) async {
    final embedding = await getEmbedding(query);

    final response = await supabase.rpc(
      "match_documents",
      params: {
        "query_embedding": embedding,
        "match_threshold": 0.7,
        "match_count": 5,
      },
    );

    final data = response as List;

    return data.map((e) => e["content"].toString()).toList();
  }

  /// =========================
  /// RAG (RETRIEVE + GENERATE)
  /// =========================
  Future<String> generateWithRAG(String query) async {
    final docs = await retrieve(query);

    final context = docs.join("\n---\n");

    final prompt = """
Gunakan konteks berikut untuk menjawab:

$context

Pertanyaan:
$query

Jawab berdasarkan konteks di atas.
""";

    return await chat(prompt);
  }

  /// =========================
  /// AI AGENT (SMART DECISION)
  /// =========================
  Future<String> agentDecision({
    required String query,
    required String vendorName,
    required double rating,
    required String riskLevel,
  }) async {
    final docs = await retrieve(query);
    final context = docs.join("\n");

    final prompt = """
Kamu adalah AI Agent manajemen risiko proyek publik.

KONTEKS:
$context

DATA VENDOR:
- Nama: $vendorName
- Rating: $rating
- Risk: $riskLevel

TUGAS:
$query

Berikan keputusan terbaik + alasan logis.
""";

    return await chat(prompt);
  }

  /// =========================
  /// SMART AGENT ROUTER
  /// =========================
  Future<String> smartAgent({
    required String query,
    String? vendorName,
    double? rating,
    String? riskLevel,
  }) async {
    if (query.toLowerCase().contains("risiko")) {
      return await agentDecision(
        query: query,
        vendorName: vendorName ?? "Unknown",
        rating: rating ?? 4.0,
        riskLevel: riskLevel ?? "medium",
      );
    } else {
      return await generateWithRAG(query);
    }
  }
}