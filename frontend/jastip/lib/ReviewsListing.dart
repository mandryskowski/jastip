import 'package:flutter/material.dart';
import 'PageHeader.dart';
import 'JsonSerializable.dart';
import 'Constants.dart';
import 'Listing.dart';

class ReviewsListing extends StatelessWidget {
  final UserInfo userInfo;

  ReviewsListing({required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          BackPageHeader(title: 'JASTIP+'),
          Padding(
            padding: EdgeInsets.all(16),
            child: ProfileHeader(userInfo: userInfo),
          ),
          Column(children: [ReviewsSection(userId: userInfo.id)]),
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final UserInfo userInfo;

  const ProfileHeader({Key? key, required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(userInfo.profileImage),
                radius: 50,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150, // You can set a max width based on your design
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userInfo.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.green, size: 25),
                      const SizedBox(width: 4),
                      Text(
                        '${userInfo.rating}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: 4,),
                      Text(
                        '(${userInfo.reviewsCount} reviews)',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Email: ${userInfo.email}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Phone: ${userInfo.phone}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewsSection extends StatelessWidget {
  final int userId;

  ReviewsSection({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding around the entire section
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // Set the background color to gray
          borderRadius: BorderRadius.circular(10), // Add rounded corners
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(8.0), // Add padding around the title
              child: Center(
                child: Text(
                  'Reviews',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            FutureBuilder<List<Review>>(
              future: HttpRequests.fetchData<Review>('reviews', {'about': userId.toString()}),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  List<Review> reviews = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      children: reviews.map((review) => ReviewWidget(review: review)).toList(),
                    ),
                  );
                } else {
                  return Container(); // Handle the case when there is no data
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}





class Review implements JsonSerializable {
  final UserInfo userInfo;
  final int rating;
  final String content;

  Review({
    required this.userInfo,
    required this.rating,
    required this.content,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userInfo: UserInfo.fromJson(json['author']),
      rating: int.parse(json['rating'].toString()),
      content: json['content'].toString(),
    );
  }
}

class ReviewWidget extends StatelessWidget {
  final Review review;

  const ReviewWidget({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(review.userInfo.profileImage),
                radius: 25,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.userInfo.username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        RatingBar(rating: review.rating),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(review.content),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  final int rating;

  const RatingBar({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }
}
