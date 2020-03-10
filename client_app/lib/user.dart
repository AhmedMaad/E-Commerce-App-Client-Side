class User {
  String _email;
  String _password;
  String _confirmPassword;
  static String userID;

  void setEmail(String email) {
    this._email = email;
  }

  void setPassword(String password) {
    this._password = password;
  }

  void setConfirmPassword(String confirmPassword) {
    this._confirmPassword = confirmPassword;
  }

  String getEmail() {
    return _email;
  }

  String getPassword() {
    return _password;
  }

  String getConfirmPassword() {
    return _confirmPassword;
  }

}
