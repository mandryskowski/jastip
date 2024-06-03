class Listing {
  Listing({
    required this.source,
    required this.destination,
    required this.auctionEnd,
    required this.departureDate,
    required this.arrivalDate,
    required this.dimensions,
    this.weight = 1,
    required this.price,
    required this.fragile,
    required this.description,
    this.bidPrices = const [],
    this.userInfo = UserInfo.aUserInfo,
  });

  static Listing aListing() {
    return Listing(
        source: "My house",
        destination: "Your house",
        auctionEnd: DateTime.now(),
        departureDate: DateTime.now(),
        arrivalDate: DateTime.now(),
        dimensions: const Dimension(width: 10, height: 10, length: 10),
        weight: 1.0,
        price: 10,
        fragile: false,
        description: "Yes",
        bidPrices: []);
  }

  static List<Listing> aLotOfListings() {
    return List.generate(20, (index) => aListing());
  }

  final String source;
  final String destination;
  final DateTime auctionEnd;
  final DateTime departureDate;
  final DateTime arrivalDate;
  final Dimension dimensions;
  final double weight;
  final double price;
  final bool fragile;
  final String description;
  final List<double> bidPrices;
  final UserInfo userInfo;

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      source: json['from'].toString(),
      destination: json['to'].toString(),
      auctionEnd: DateTime.parse(json['auctionEnd']),
      departureDate: DateTime.parse(json['departure']),
      arrivalDate: DateTime.parse(json['arrival']),
      price: json['startingPrice'],
      dimensions: Dimension(
          length: json['length'], width: json['width'], height: json['height']),
      weight: double.parse(json['weight'].toString()),
      fragile: bool.parse(json['fragile'].toString()),
      description: json['description'],
      bidPrices: List<double>.from(json['bidPrices'].map((price) => double.parse(price.toString()))),
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

  @override
  String toString() {
    return "${length}x${width}x${height} cm";
  }

  final double height;
  final double width;
  final double length;
}

class UserInfo {
  const UserInfo({
    required this.userName,
    required this.userProfileImage,
    required this.userRating,
    required this.userReviewsCount
  });

  final String userName;
  final String userProfileImage;
  final double userRating;
  final int userReviewsCount;

  static const UserInfo aUserInfo = 
    const UserInfo(
        userName: "topG",
        userProfileImage: "https://cdn-icons-png.flaticon.com/512/3140/3140525.png",
        userRating: 4.0,
        userReviewsCount: 3
      );
}