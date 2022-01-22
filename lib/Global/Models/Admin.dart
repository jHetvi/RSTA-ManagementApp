import 'package:cloud_firestore/cloud_firestore.dart';

class Admin {
  static const ADMIN_ID = "admin_id";
  static const PROFILE_IMAGE_URL = "profile_img_url";
  static const PROFILE_THUMB_IMAGE_URL = "profile_thumb_img_url";
  static const NAME = "nm";
  static const EMAIL_ID = "emailId";
  static const PHONE_NUMBER = "phn_no";
  static const CREATE_TIMESTAMP = "crte_tmstmp";
  static const LAST_UPDATE_DATETIME = "lst_updt_tmstmp";
  static const PASSWORD = 'password';

  String adminId;
  String profileImgUrl, profileThumbImgUrl, name, emailId;
  String phoneNumber, password;
  Timestamp createDateTime, lastUpdateDateTime;

  Admin({
    this.adminId,
    this.name,
    this.emailId,
    this.phoneNumber,
    this.profileImgUrl,
    this.createDateTime,
    this.lastUpdateDateTime,
    this.password,
    this.profileThumbImgUrl,
  });

  factory Admin.fromDocSnap(DocumentSnapshot docSnap) =>
      Admin.fromMap(docSnap.data())..adminId = docSnap.id;

  // factory Donor.fromDocSnap(DocumentSnapshot docSnap) =>
  //     Donor.fromMap(docSnap.data())..donorId = docSnap.documentID;

  Admin.fromMap(Map data) {
    this.adminId = data[ADMIN_ID];
    this.name = data[NAME];
    this.emailId = data[EMAIL_ID];
    this.phoneNumber = data[PHONE_NUMBER];
    this.profileImgUrl = data[PROFILE_IMAGE_URL];
    this.profileThumbImgUrl = data[PROFILE_THUMB_IMAGE_URL];
    this.createDateTime = data[CREATE_TIMESTAMP];
    this.lastUpdateDateTime = data[LAST_UPDATE_DATETIME];
    this.password = data[PASSWORD];
  }

  Map<String, dynamic> toJson() => {
        ADMIN_ID: adminId,
        NAME: this.name,
        EMAIL_ID: this.emailId,
        PHONE_NUMBER: this.phoneNumber,
        PROFILE_IMAGE_URL: this.profileImgUrl,
        PROFILE_THUMB_IMAGE_URL: this.profileThumbImgUrl,
        CREATE_TIMESTAMP: this.createDateTime,
        LAST_UPDATE_DATETIME: this.lastUpdateDateTime,
        PASSWORD: this.password,
      };
}
