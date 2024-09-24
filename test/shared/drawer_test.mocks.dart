// Mocks generated by Mockito 5.4.4 from annotations
// in lawli/test/shared/drawer_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:firebase_auth/firebase_auth.dart' as _i4;
import 'package:lawli/services/auth.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [AuthService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthService extends _i1.Mock implements _i2.AuthService {
  MockAuthService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<_i4.User?> get userStream => (super.noSuchMethod(
        Invocation.getter(#userStream),
        returnValue: _i3.Stream<_i4.User?>.empty(),
      ) as _i3.Stream<_i4.User?>);

  @override
  bool isGuest() => (super.noSuchMethod(
        Invocation.method(
          #isGuest,
          [],
        ),
        returnValue: false,
      ) as bool);

  @override
  _i3.Future<void> anonLogin() => (super.noSuchMethod(
        Invocation.method(
          #anonLogin,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> googleLogin() => (super.noSuchMethod(
        Invocation.method(
          #googleLogin,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> emailRegistration(
    String? emailAddress,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #emailRegistration,
          [
            emailAddress,
            password,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> emailLogin(
    String? emailAddress,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #emailLogin,
          [
            emailAddress,
            password,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> signOut() => (super.noSuchMethod(
        Invocation.method(
          #signOut,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  String userId() => (super.noSuchMethod(
        Invocation.method(
          #userId,
          [],
        ),
        returnValue: _i5.dummyValue<String>(
          this,
          Invocation.method(
            #userId,
            [],
          ),
        ),
      ) as String);

  @override
  bool isSignedIn() => (super.noSuchMethod(
        Invocation.method(
          #isSignedIn,
          [],
        ),
        returnValue: false,
      ) as bool);
}