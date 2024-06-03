import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jastip/Constants.dart';
import 'package:jastip/PageHeader.dart';
import 'package:jastip/Listing.dart';
import 'Constants.dart';
import 'FormElement.dart';

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
        color: backgroundColorData,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _sectionTitle('AvaiableSpace'),
          SizedBox(height: 8),
          _buildSpaceDetailRow('Weight:', '${listing.weight} kg', Icons.scale),
          _buildSpaceDetailRow('Length:', '${listing.dimensions.length} cm', Icons.straighten),
          _buildSpaceDetailRow('Width:', '${listing.dimensions.width} cm', Icons.straighten),
          _buildSpaceDetailRow('Height:', '${listing.dimensions.height} cm', Icons.straighten),
          _buildSpaceDetailRow('Fragile?', listing.fragile ? 'Accepted' : 'Not accepted', Icons.heart_broken),
        ],
      ),
    );
  }

  Widget _buildSpaceDetailRow(String title, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 12),
        Text(value,
          style: TextStyle(
            fontSize: 20,
          ),),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _sectionTitle('Trip Plan'),
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
        Divider(),
        Center(
          child: 
            Text(
            date,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColorDark,
              fontSize: 20,
            ),
          ),
        ),
        Divider(),
        Row(
          children: [
            Text(
              time,
              style: TextStyle(
                color: Color.fromARGB(200, 161,83,83),
                fontSize: 20,
              ),
            ),
          SizedBox(width: 20),
           Flexible( // Add Flexible to allow wrapping of description text
            child: Text(
              description,
              softWrap: true,
              style: TextStyle(fontSize: 20),
              maxLines: null,
            ),
          ),
          ]
        ,)
      ],
    );
  }

  Widget _buildNoteFromTravellerSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColorData,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _sectionTitle('Note from traveller'),
          SizedBox(height: 14),
          Text(listing.description, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection() {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(listing.userInfo.userProfileImage),
          radius: 50,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              listing.userInfo.userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.green, size: 25),
                const SizedBox(width: 4),
                Text(
                  '${listing.userInfo.userRating}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 4,),
                Text(
                  '(${listing.userInfo.userReviewsCount} reviews)',
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
  );
}



  Widget _buildBidSection() {
  double bidPrice = listing.bidPrices.lastOrNull ?? listing.price;
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _bidSectionEntry('Current bid: ', '${bidPrice}GBP'),
        _bidSectionEntry('Bids: ', '${listing.bidPrices.length}'),
        _bidSectionEntry('Ends: ', '${listing.auctionEnd}'),
        SizedBox(height: 16),
        Center(
          child: SubmitButton(onPressed: () => {}, buttonText: 'Bid')
        ),
      ],
    ),
  );
}

Widget _bidSectionEntry(String title, String amount) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        amount,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    ],
  );
}


  Widget _sectionTitle(String title) {
    return Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              decoration: TextDecoration.underline,
            ),
    );
  }
}
