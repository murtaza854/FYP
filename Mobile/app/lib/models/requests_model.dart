class RequestsModel {
  String sender;
  String senderFirstName;
  String senderName;
  String receiver;
  String receiverFirstName;
  String receiverName;
  String relationship;
  bool seenAfterAcceptanceFrom;
  bool status;

  RequestsModel({
    required this.sender,
    required this.senderFirstName,
    required this.senderName,
    required this.receiver,
    required this.receiverFirstName,
    required this.receiverName,
    required this.relationship,
    required this.seenAfterAcceptanceFrom,
    required this.status,
  });

  factory RequestsModel.fromJson(var json) {
    RequestsModel user = RequestsModel(
      sender: json['sender'],
      senderFirstName: json['senderFirstName'],
      senderName: json['senderName'],
      receiver: json['receiver'],
      receiverFirstName: json['receiverFirstName'],
      receiverName: json['receiverName'],
      relationship: json['relationship'],
      seenAfterAcceptanceFrom: json['seenAfterAcceptanceFrom'],
      status: json['status'],
    );
    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'senderFirstName': senderFirstName,
      'senderName': senderName,
      'receiver': receiver,
      'receiverFirstName': receiverFirstName,
      'receiverName': receiverName,
      'relationship': relationship,
      'seenAfterAcceptanceFrom': seenAfterAcceptanceFrom,
      'status': status,
    };
  }
}
