import 'dart:math';

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
    this.lastBid = 0,
    this.bidCnt = 0,
    this.userInfo = UserInfo.aUserInfo,
    this.auctionId = 4
  });

  double getCurrentBid() {
    return max(lastBid, price);
  }

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
        auctionId: 4);
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
  final double lastBid;
  final int bidCnt;
  final UserInfo userInfo;
  final int auctionId;

  factory Listing.fromJson(Map<String, dynamic> json) {
    final bidPrices = List<double>.from(json['bidPrices'].map((price) => double.parse(price.toString())));
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
      bidCnt: bidPrices.length,
      lastBid: bidPrices.length > 0 ? bidPrices.last : 0,
      auctionId: int.parse(json['auctionId'].toString()),
      userInfo: UserInfo.fromJson(json['userInfo'])
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
    required this.id,
    this.username = "topG",
    this.profileImage = "https://cdn-icons-png.flaticon.com/512/3140/3140525.png",
    this.rating = 4.0,
    this.reviewsCount = 3
  });

  final int id;
  final String username;
  final String profileImage;
  final double rating;
  final int reviewsCount;

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      rating: roundOffToXDecimal(double.parse(json['averageRating'].toString())),
      id: int.parse(json['id'].toString()),
      reviewsCount: int.parse(json['ratings'].toString()),
      username: json['username'].toString()
    );
  }

  static double roundOffToXDecimal(double number, {int numberOfDecimal = 2}) {
  // To prevent number that ends with 5 not round up correctly in Dart (eg: 2.275 round off to 2.27 instead of 2.28)
  String numbersAfterDecimal = number.toString().split('.')[1];
  if (numbersAfterDecimal != '0') {
    int existingNumberOfDecimal = numbersAfterDecimal.length;
    double incrementValue = 1 / (10 * pow(10, existingNumberOfDecimal));
    if (number < 0) {
      number -= incrementValue;
    } else {
      number += incrementValue;
    }
  }
  return double.parse(number.toStringAsFixed(numberOfDecimal));
}


  static const UserInfo aUserInfo = 
    const UserInfo(
        id: 4,
        username: "topG",
        profileImage: "https://cdn-icons-png.flaticon.com/512/3140/3140525.png",
        rating: 4.0,
        reviewsCount: 3
    );
}