import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jastip/PageHeader.dart';
import 'package:jastip/Listing.dart';
import 'Constants.dart';
import 'ReviewsListing.dart';

class DescriptionPageCarrier extends StatelessWidget {
  final List<Widget> overlays;
  final Listing listing;

  const DescriptionPageCarrier({super.key, required this.overlays, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
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
                      // SizedBox(height: 16),
                      // _buildNoteFromTravellerSection(),
                      SizedBox(height: 16),
                      _buildUserInfoSection(context),
                      SizedBox(height: 16),
                      _buildBidSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
          _sectionTitle('Available Space'),
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
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
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
          _sectionTitle('Package information'),
          _buildTripPlanDetail('Mon 9th May', '01:45 (UTC+8)', 'Pickup package', 'Pickup Address: Jl. Kebon Jeruk No.27, Jakarta, Indonesia'),
          _buildTripPlanDetail('Mon 13th May', '12:25 (UTC+0)', 'Drop off package', 'Destination Address: ${listing.address?.line1} ${listing.address?.line2}'),
        ],
      ),
    );
  }

  Widget _buildTripPlanDetail(String date, String time, String description, String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Center(
          child: Text(
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
                color: Color.fromARGB(200, 161, 83, 83),
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
          ],
        ),
        SizedBox(height: 8),
        Text(
          address,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 18,
          ),
        ),
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

  Widget _buildUserInfoSection(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColorData,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _sectionTitle('Auction winner'),
          SizedBox(height: 14),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReviewsListing(userInfo: listing.auctionWinner), settings: RouteSettings(name: '/ReviewsListing')),
              );
            },
            child: ProfileHeader(userInfo: listing.auctionWinner,)
          ),
        ],
      ),
    );
  }

  Widget _buildBidSection() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // _bidSectionEntry('Current bid: ', '${listing.getCurrentBid()}GBP'),
          // _bidSectionEntry('Bids: ', '${listing.bidCnt}'),
          // _bidSectionEntry('Ends: ', '${listing.auctionEnd}'),
          // SizedBox(height: 16),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: overlays,
            )
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