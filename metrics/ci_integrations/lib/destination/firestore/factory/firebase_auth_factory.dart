// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firedart/firedart.dart';

/// A factory class that provides a method for creating a new instance of
/// the [FirebaseAuth].
class FirebaseAuthFactory {
  /// Creates an instance of the [FirebaseAuthFactory].
  const FirebaseAuthFactory();

  /// Creates a new instance of the [FirebaseAuth]
  /// with the given [firebaseApiKey].
  ///
  /// Throws an [ArgumentError] if the given [firebaseApiKey] is `null`.
  FirebaseAuth create(String firebaseApiKey) {
    ArgumentError.checkNotNull(firebaseApiKey, 'firebaseApiKey');

    return FirebaseAuth(
      firebaseApiKey,
      VolatileStore(),
    );
  }
}
