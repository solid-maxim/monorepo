// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/jenkins_client.dart';
import 'package:ci_integration/integration/interface/base/config/validation_delegate/validation_delegate.dart';
import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
import 'package:ci_integration/source/jenkins/strings/jenkins_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';

/// A [ValidationDelegate] for the Jenkins source integration.
class JenkinsSourceValidationDelegate implements ValidationDelegate {
  /// A [JenkinsClient] used to perform calls to the Jenkins API.
  final JenkinsClient _client;

  /// Creates a new instance of the [JenkinsSourceValidationDelegate]
  /// with the given [JenkinsClient].
  ///
  /// Throws an [ArgumentError] if the given [JenkinsClient] is `null`.
  JenkinsSourceValidationDelegate(this._client) {
    ArgumentError.checkNotNull(_client, 'client');
  }

  /// Validates the given [jenkinsUrl].
  Future<FieldValidationResult<void>> validateJenkinsUrl(
      String jenkinsUrl) async {
    final instanceInfoInteraction = await _client.fetchJenkinsInstanceInfo(
      jenkinsUrl,
    );

    final instanceInfo = instanceInfoInteraction.result;

    if (instanceInfoInteraction.isError ||
        instanceInfo == null ||
        instanceInfo.version == null) {
      return const FieldValidationResult.failure(
        additionalContext: JenkinsStrings.notAJenkinsUrl,
      );
    }

    return const FieldValidationResult.success();
  }

  /// Validates the given [auth].
  Future<FieldValidationResult<void>> validateAuth(
    AuthorizationBase auth,
  ) async {
    final userInteraction = await _client.fetchJenkinsUser(auth);

    if (userInteraction.isError || userInteraction.result == null) {
      return const FieldValidationResult.failure(
        additionalContext: JenkinsStrings.authInvalid,
      );
    }

    final jenkinsUser = userInteraction.result;

    String authenticationInfo = '';

    final isAnonymous = jenkinsUser.anonymous ?? true;
    if (isAnonymous) {
      authenticationInfo = JenkinsStrings.anonymousUser;
    }

    final isAuthenticated = jenkinsUser.authenticated ?? false;
    if (!isAuthenticated) {
      authenticationInfo =
          '$authenticationInfo ${JenkinsStrings.unauthenticatedUser}';
    }

    if (authenticationInfo.isNotEmpty) {
      final additionalContext = 'Note: $authenticationInfo';

      return FieldValidationResult.success(
        additionalContext: additionalContext,
      );
    }

    return const FieldValidationResult.success();
  }

  /// Validates the given [jobName].
  Future<FieldValidationResult<void>> validateJobName(String jobName) async {
    final jobInteraction = await _client.fetchJob(jobName);

    if (jobInteraction.isError || jobInteraction.result == null) {
      return const FieldValidationResult.failure(
        additionalContext: JenkinsStrings.jobDoesNotExist,
      );
    }

    return const FieldValidationResult.success();
  }
}
