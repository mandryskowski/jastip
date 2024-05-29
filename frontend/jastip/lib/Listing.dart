class Listing {
  Listing({
    required this.source,
    required this.destination,
    required this.dateTime,
    required this.dimensions,
    required this.price,
  });

  static Listing aListing() {
    return Listing(source: "My house", destination: "Your mum", dateTime: DateTime.now(), dimensions: const Dimension(width: 10, height: 10, length: 10), price: 10);
  }
  
  static List<Listing> aLotOfListings() {
    return List.generate(20, (index) => aListing());
  }

  final String source;
  final String destination;
  final DateTime dateTime;
  final Dimension dimensions;
  final double price;

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      source: json['auctionId'].toString(),
      destination: json['bidId'].toString(),
      dateTime: DateTime.parse(json['date']),
      price: json['price'],
      dimensions: Dimension(length: 10, width: 10, height: 10),
    );
  }
}

class Dimension {
  const Dimension({
    required this.length,
    required this.width,
    required this.height,
  });

  static Dimension generic() {
    return Dimension(length: 10, width: 10, height: 10);
  }

  String toString() {
    return "${length}x${width}x${height} cm";
  }

  final int height;
  final int width;
  final int length;
}