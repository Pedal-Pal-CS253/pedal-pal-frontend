class User {
  String email;
  String firstName;
  String lastName;
  String phone;
  bool isSubscribed = false;
  bool isActive = true;
  bool isStaff = false;
  bool isRideActive = false;
  int balance = 0;

  User(
      this.email, this.firstName, this.lastName, this.phone, this.isSubscribed);

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'] as String,
        firstName = json['first_name'] as String,
        lastName = json['last_name'] as String,
        phone = json['phone'] as String,
        isSubscribed = json['is_subscribed'] as bool,
        isActive = json['is_active'] as bool,
        isStaff = json['is_staff'] as bool,
        isRideActive = json['ride_active'] as bool,
        balance = json['balance'] as int;

  Map<String, dynamic> toJson() => {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'is_subscribed': isSubscribed,
        'is_active': isActive,
        'is_staff': isStaff,
        'ride_active': isRideActive,
        'balance': balance
      };
}
