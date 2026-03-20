class VendorData {
  final String name;
  final double rating;
  final int projects;
  final int successRate;
  final String priceLevel;
  final String riskLevel;
  final String description;
  final String image;

  VendorData({
    required this.name,
    required this.rating,
    required this.projects,
    required this.successRate,
    required this.priceLevel,
    required this.riskLevel,
    required this.description,
    required this.image,
  });

  factory VendorData.fromJson(Map<String, dynamic> json) {
    return VendorData(
      name: json['name'],
      rating: (json['rating'] as num).toDouble(),
      projects: json['projects'],
      successRate: json['successRate'],
      priceLevel: json['priceLevel'],
      riskLevel: json['riskLevel'],
      description: json['description'],
      image: json['image'],
    );
  }
}