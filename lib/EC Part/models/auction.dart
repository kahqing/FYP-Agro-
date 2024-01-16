import 'package:cloud_firestore/cloud_firestore.dart';

class Auction {
  final String productId;
  final String sellerId;
  final String auctionId;
  final double highestBid;
  final DateTime endTime;
  final double startPrice;
  final String status;
  final Map<String, dynamic>? bidderData;
  //can access the bidder data thru auction object

  Auction({
    required this.productId,
    required this.auctionId,
    required this.highestBid,
    required this.endTime,
    required this.sellerId,
    required this.status,
    required this.startPrice,
    this.bidderData,
  });

  factory Auction.fromMap(Map<String, dynamic> data, String auctionId) {
    return Auction(
      auctionId: auctionId,
      productId: data['productId'] ?? '',
      sellerId: data['sellerId'],
      highestBid: (data['highestBid'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'Start',
      endTime: (data['endTime'] as Timestamp).toDate(),
      startPrice: (data['startPrice'] ?? 0.0).toDouble(),
      bidderData: data['bidderData'] as Map<String, dynamic>?,
      //asign null when no bidder data
    );
  }
}

class BidderData {
  final String bidderId;
  final double bidAmount;
  final DateTime timestamp;
  BidderData({
    required this.bidderId,
    required this.bidAmount,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'bidderId': bidderId,
      'bidAmount': bidAmount,
      'timestamp': timestamp,
    };
  }
}
