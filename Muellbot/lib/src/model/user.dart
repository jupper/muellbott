import 'pickup_date.dart';

class User {
  String firstName;
  String lastName;
  String email;
  List<PickUpDate> pickUpDates = new List();

  User(this.firstName, this.lastName, this.email);

  String getFirstName() => this.firstName;
  String getLastName() => this.lastName;
  String getEmail() => this.email;
  List<PickUpDate> getPickUpDates() => this.pickUpDates;

  void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  void setLastName(String lastName) {
    this.lastName = lastName;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void addPickUpDate(PickUpDate pickUpDate) {
    this.pickUpDates.add(pickUpDate);
  }

  void removePickUpDate(PickUpDate pickUpDate) {
    this.pickUpDates.remove(pickUpDate);
  }


}