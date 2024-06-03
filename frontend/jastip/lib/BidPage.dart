import 'package:flutter/material.dart';
import 'package:jastip/Constants.dart';
import 'package:jastip/PageHeader.dart';
import 'package:jastip/Listing.dart';
import 'Constants.dart';

class BidPage extends StatelessWidget {
  BidPage({super.key, required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const BackPageHeader(
              title: 'JASTIP+',
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildAvailableSpaceSection(),
                  SizedBox(height: 16),
                  _buildTripPlanSection(),
                  SizedBox(height: 16),
                  _buildNoteFromTravellerSection(),
                  SizedBox(height: 16),
                  _buildUserInfoSection(),
                  SizedBox(height: 16),
                  _buildBidSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableSpaceSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available space',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          _buildSpaceDetailRow('Weight:', '${listing.weight} kg', Icons.scale),
          _buildSpaceDetailRow('Length:', '${listing.dimensions.length} cm', Icons.straighten),
          _buildSpaceDetailRow('Width:', '${listing.dimensions.width} cm', Icons.straighten),
          _buildSpaceDetailRow('Height:', '${listing.dimensions.height} cm', Icons.straighten),
          _buildSpaceDetailRow('Fragile?', listing.fragile ? 'Accepted' : 'Not accepted', Icons.warning),
        ],
      ),
    );
  }

  Widget _buildSpaceDetailRow(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 8),
        Text(value),
      ],
    );
  }

  Widget _buildTripPlanSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip plan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          _buildTripPlanDetail('Mon 9th May', '01:45 (UTC+8)', 'Takeoff from CGK airport'),
          _buildTripPlanDetail('Mon 9th May', '12:25 (UTC+0)', 'Landing at LHR airport'),
          _buildTripPlanDetail('Fri 13th May', '21:00 (UTC+0)', 'Flyer sends parcel'),
          _buildTripPlanDetail('Mon 16th May - Wed 18th May', 'Any time', 'Royal Mail will deliver your parcel'),
        ],
      ),
    );
  }

  Widget _buildTripPlanDetail(String date, String time, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryColorDark,
          ),
        ),
        SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Text(description),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildNoteFromTravellerSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Note from traveller',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(listing.description),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(listing.userInfo.userProfileImage),
          radius: 30,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              listing.userInfo.userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.green, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${listing.userInfo.userRating} (${listing.userInfo.userReviewsCount} reviews)',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBidSection() {
    double bidPrice = listing.bidPrices.lastOrNull ?? listing.price;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current bid: ${bidPrice}GBP',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text('Bids: ${listing.bidPrices.length}'),
        Text('Ends: ${listing.auctionEnd}'),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          child: Text('Bid'),
        ),
      ],
    );
  }
}
