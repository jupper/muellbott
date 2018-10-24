class PickUpDate {
  DateTime pickupDate;
  String kind;

  PickUpDate(DateTime pickupDate, String kind) {
    this.pickupDate = pickupDate;
    this.kind = kind;
  }

  DateTime getPickUpDate() => this.pickupDate;
  String getKind() => this.kind;

}