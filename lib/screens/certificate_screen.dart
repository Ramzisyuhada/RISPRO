import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/rispro_colors.dart';
import '../widgets/rispro_app_bar.dart';
import '../widgets/rispro_button.dart';
import '../widgets/rispro_logo.dart';

class CertificateScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const CertificateScreen({super.key, this.data = const <String, dynamic>{}});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  late final TextEditingController _nameController;
  late final DateTime _issuedAt;
  late final String _certificateId;

  @override
  void initState() {
    super.initState();
    _issuedAt = DateTime.now();
    _certificateId = _buildCertificateId(_issuedAt);
    _nameController = TextEditingController(text: _initialName);
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String get _initialName {
    final raw = widget.data["name"];
    if (raw is String && raw.trim().isNotEmpty) return raw.trim();
    return "Praktisi Manajemen Risiko";
  }

  String get _participantName {
    final value = _nameController.text.trim();
    return value.isEmpty ? "Praktisi Manajemen Risiko" : value;
  }

  int get _score => _readInt(widget.data["score"]);

  int get _completedPosts =>
      _readInt(widget.data["completedPosts"], fallback: 5).clamp(0, 5).toInt();

  String get _profile {
    final raw = widget.data["profile"];
    if (raw is String && raw.trim().isNotEmpty) return raw.trim();
    return "Strategic Risk Master";
  }

  String get _rank {
    final raw = widget.data["rank"];
    if (raw is String && raw.trim().isNotEmpty) return raw.trim();
    if (_score >= 70) return "Sangat Baik";
    if (_score >= 40) return "Cukup";
    return "Perlu Evaluasi";
  }

  Map<String, dynamic> get _total {
    final raw = widget.data["total"];
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return const <String, dynamic>{};
  }

  int _readInt(Object? value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.round();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  String _buildCertificateId(DateTime date) {
    final datePart = "${date.year}${_twoDigits(date.month)}${_twoDigits(date.day)}";
    final uniquePart = date.millisecondsSinceEpoch.remainder(100000).toString().padLeft(5, "0");
    return "RISPRO-$datePart-$uniquePart";
  }

  String _twoDigits(int value) => value.toString().padLeft(2, "0");

  String _formatDate(DateTime date) {
    const months = [
      "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final cost = _readInt(_total["cost"]);
    final time = _readInt(_total["time"]);
    final risk = _readInt(_total["risk"]);

    return Scaffold(
      backgroundColor: RisproColors.background,
      appBar: RisproAppBar(
        title: "Sertifikat Pencapaian",
        onBack: () => Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 32 : 18,
                vertical: 18,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 880),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Participant Name Input Field
                      _buildNameInputField(),

                      const SizedBox(height: 18),

                      // 2. Certificate Frame Card
                      _buildCertificateFrame(
                        isWide: isWide,
                        cost: cost,
                        time: time,
                        risk: risk,
                      ),

                      const SizedBox(height: 24),

                      // 3. Action Buttons
                      _buildActionButtons(context),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNameInputField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: RisproColors.border, width: 1.2),
        boxShadow: RisproColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sesuaikan Nama Penerima Sertifikat:",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: RisproColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: RisproColors.textMain,
            ),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.badge_rounded, color: RisproColors.primary),
              hintText: "Ketik nama lengkap Anda di sini...",
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: RisproColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: RisproColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: RisproColors.secondary, width: 2),
              ),
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 350.ms).slideY(begin: -0.1);
  }

  Widget _buildCertificateFrame({
    required bool isWide,
    required int cost,
    required int time,
    required int risk,
  }) {
    return Container(
      padding: EdgeInsets.all(isWide ? 36 : 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: RisproColors.accent, width: 2.5),
        boxShadow: RisproColors.prominentShadow,
      ),
      child: Stack(
        children: [
          // Subtle watermark background logo
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.04,
              child: const RisproLogoIcon(size: 260),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Certificate Header
              Row(
                children: [
                  const Expanded(
                    child: RisproLogoLockup(
                      iconSize: 34,
                      showSubtitle: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: RisproColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: RisproColors.accent, width: 1),
                    ),
                    child: Text(
                      "TERVERIFIKASI",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: RisproColors.accentDark,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Divider(height: 1, color: RisproColors.border),
              const SizedBox(height: 24),

              Text(
                "SERTIFIKAT KELULUSAN SIMULASI",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: isWide ? 24 : 20,
                  fontWeight: FontWeight.w800,
                  color: RisproColors.primary,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Manajemen Risiko Pengambilan Keputusan Proyek Sektor Publik",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: RisproColors.textSecondary,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                "Diberikan Secara Resmi Kepada:",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: RisproColors.textSecondary,
                ),
              ),

              const SizedBox(height: 8),

              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _participantName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: isWide ? 34 : 26,
                    fontWeight: FontWeight.w800,
                    color: RisproColors.textMain,
                    letterSpacing: -0.2,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Telah menyelesaikan seluruh tahapan studi kasus simulasi pengambilan keputusan (Pos 1 s/d Pos 5) dengan evaluasi tata kelola risiko berbasis standar ISO 31000.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: RisproColors.textMain,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 22),

              // 5 Posts Checklist
              _buildPostCompletionTracker(),

              const SizedBox(height: 24),

              // Stats Grid
              _buildStatsGrid(isWide: isWide, cost: cost, time: time, risk: risk),

              const SizedBox(height: 28),
              Divider(height: 1, color: RisproColors.border),
              const SizedBox(height: 16),

              // Footer Verification
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 20,
                runSpacing: 8,
                children: [
                  _footerItem("Tanggal Penerbitan", _formatDate(_issuedAt)),
                  _footerItem("Nomor Sertifikat", _certificateId),
                  _footerItem("Penyelenggara", "RISPRO Simulation Lab"),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fade(duration: 450.ms).scale(begin: const Offset(0.98, 0.98));
  }

  Widget _buildPostCompletionTracker() {
    const posts = [
      "Pos 1: Klasifikasi",
      "Pos 2: Certainty",
      "Pos 3: Risk",
      "Pos 4: Uncertainty",
      "Pos 5: Evaluasi",
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(posts.length, (index) {
        final isComplete = index < _completedPosts;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isComplete ? RisproColors.successBg : RisproColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isComplete ? RisproColors.success.withValues(alpha: 0.5) : RisproColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isComplete ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                color: isComplete ? RisproColors.success : RisproColors.textSecondary,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                posts[index],
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isComplete ? const Color(0xFF0F5A47) : RisproColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatsGrid({
    required bool isWide,
    required int cost,
    required int time,
    required int risk,
  }) {
    final items = [
      _StatCard("Skor Evaluasi", "$_score / 100", Icons.insights_rounded, RisproColors.primary),
      _StatCard("Predikat Kinerja", _rank, Icons.verified_rounded, RisproColors.success),
      _StatCard("Profil Keputusan", _profile, Icons.psychology_rounded, RisproColors.accentDark),
      _StatCard("Dampak Biaya", "$cost%", Icons.payments_outlined, Colors.red.shade700),
      _StatCard("Dampak Waktu", "$time%", Icons.schedule_rounded, Colors.orange.shade800),
      _StatCard("Eksposur Risiko", "$risk%", Icons.shield_outlined, RisproColors.primary),
    ];

    if (isWide) {
      return GridView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: 64,
        ),
        itemBuilder: (_, index) => items[index],
      );
    }

    return Column(
      children: items
          .map((item) => Padding(padding: const EdgeInsets.only(bottom: 8), child: item))
          .toList(),
    );
  }

  Widget _footerItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 11, color: RisproColors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: RisproColors.textMain,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        RisproButton(
          text: "Menu Utama",
          icon: Icons.home_rounded,
          variant: RisproButtonVariant.primaryCta,
          height: 52,
          fontSize: 15,
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
          },
        ),
        RisproButton(
          text: "Ulangi Simulasi",
          icon: Icons.replay_rounded,
          variant: RisproButtonVariant.secondary,
          height: 52,
          fontSize: 15,
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, "/game", (route) => false);
          },
        ),
        RisproButton(
          text: "Refleksi Pembelajaran",
          icon: Icons.menu_book_rounded,
          variant: RisproButtonVariant.ghost,
          height: 52,
          fontSize: 15,
          onPressed: () => Navigator.pushNamed(context, "/scene8"),
        ),
      ],
    ).animate().fade(duration: 350.ms).slideY(begin: 0.1);
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: RisproColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
