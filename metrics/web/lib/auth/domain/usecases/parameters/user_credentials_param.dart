import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the user credentials parameter.
class UserCredentialsParam extends Equatable {
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];

  /// Creates [UserCredentialsParam] with the given [email] and [password].
  ///
  /// Throws an [AssertionError] if either [email] or [password] is null.
  const UserCredentialsParam({
    @required this.email,
    @required this.password,
  })  : assert(email != null),
        assert(password != null);
}