class User{
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String token;
  User({
    this.firstName='',
    this.lastName='',
    this.phone='',
    this.email='',
    this.token=''
  });
  User copy({
    String firstName,
    String lastName,
    String phone,
    String email,
    String token,
  })=>User(firstName: firstName??this.firstName,
      lastName: lastName??this.lastName,
      phone: phone ??this.phone,
      email: email??this.email,
      token: token??this.token);

  static User fromJson(Map <String,dynamic> jsonItem){
    return User(firstName: jsonItem['first_name'],
        lastName: jsonItem['last_name'],
        phone: jsonItem['phone'],
        email: jsonItem['email'],
        token: jsonItem['token']);
  }
  Map<String,dynamic> toJson(){
    return {
      'first_name':firstName,
      'last_name':lastName,
      'phone':phone,
      'email':email,
      'token':token
    };
  }
}