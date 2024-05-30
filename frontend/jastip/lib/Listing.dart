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
      source: json['from'].toString(),
      destination: json['to'].toString(),
      dateTime: DateTime.parse(json['auctionEnd']),
      price: json['startingPrice'],
      dimensions: Dimension(length: json['length'], width: json['width'], height: json['height']),
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

  final double height;
  final double width;
  final double length;
}