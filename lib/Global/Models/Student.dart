import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  static const STUDENT_ID = "student_id";
  static const PROFILE_IMAGE_URL = "profile_img_url";
  static const PROFILE_THUMB_IMAGE_URL = "profile_thumb_img_url";
  static const NAME = "nm";
  static const DOB = "dob";
  static const AGE = "age";
  static const WHATS_APP_NUMBER = "whats_app_no";
  static const EMAIL_ID = "email_Id";
  static const BATCH = "batch";
  static const TIME = "timin";
  static const FEES = "fees";
  static const CREATE_TIMESTAMP = "crte_tmstmp";
  static const LAST_UPDATE_DATETIME = "lst_updt_tmstmp";
  static const REMARKS = "remarks";
  static const LAST_FEES_RECEIVED = "Last Received fees";
  static const DATE_TO = "Date(from)";
  static const DATE_FROM = "Date(To)";
  static const MODE_OF_PAYMENT = "Mode of Payment";
  static const RECEIVED_BY = "Received By";

  String studentId;
  String profileImgUrl = "",
      profileThumbImgUrl = "",
      name,
      emailId = "",
      batch,
      time,
      fees,
      remarks,
      age,
      lastFeesReceived,
      modeOfPayment,
      receivedBy;
  String whatsAppNumber = "";
  Timestamp createDateTime, lastUpdateDateTime, dateTo, dateFrom;
  Timestamp dob;

  Student(
      {this.studentId,
      this.name,
      this.emailId,
      this.profileImgUrl,
      this.createDateTime,
      this.lastUpdateDateTime,
      this.profileThumbImgUrl,
      this.age,
      this.dob,
      this.batch,
      this.time,
      this.fees,
      this.dateFrom,
      this.dateTo,
      this.lastFeesReceived,
      this.receivedBy,
      this.modeOfPayment,
      this.remarks,
      this.whatsAppNumber});

  factory Student.fromDocSnap(DocumentSnapshot docSnap) =>
      Student.fromMap(docSnap.data())..studentId = docSnap.id;

  Student.fromMap(Map data) {
    this.studentId = data[STUDENT_ID];
    this.name = data[NAME];
    this.emailId = data[EMAIL_ID];
    this.whatsAppNumber = data[WHATS_APP_NUMBER];
    this.age = data[AGE];
    this.batch = data[BATCH];
    this.time = data[TIME];
    this.dob = data[DOB];
    this.fees = data[FEES];
    this.remarks = data[REMARKS];
    this.profileImgUrl = data[PROFILE_IMAGE_URL];
    this.profileThumbImgUrl = data[PROFILE_THUMB_IMAGE_URL];
    this.createDateTime = data[CREATE_TIMESTAMP];
    this.lastFeesReceived = data[LAST_FEES_RECEIVED];
    this.dateTo = data[DATE_TO];
    this.dateFrom = data[DATE_FROM];
    this.modeOfPayment = data[MODE_OF_PAYMENT];
    this.receivedBy = data[RECEIVED_BY];
  }

  Map<String, dynamic> toJson() => {
        NAME: this.name,
        EMAIL_ID: this.emailId = "",
        WHATS_APP_NUMBER: this.whatsAppNumber,
        AGE: this.age,
        BATCH: this.batch,
        TIME: this.time,
        DOB: this.dob,
        FEES: this.fees,
        REMARKS: this.remarks = "",
        PROFILE_IMAGE_URL: this.profileImgUrl = "",
        PROFILE_THUMB_IMAGE_URL: this.profileThumbImgUrl = "",
        CREATE_TIMESTAMP: this.createDateTime,
        LAST_UPDATE_DATETIME: this.lastUpdateDateTime,
        LAST_FEES_RECEIVED: this.lastFeesReceived,
        DATE_TO: this.dateTo,
        DATE_FROM: this.dateFrom,
        MODE_OF_PAYMENT: this.modeOfPayment,
        RECEIVED_BY: this.receivedBy,
      };
}
