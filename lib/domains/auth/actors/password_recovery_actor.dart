import 'package:flutter/foundation.dart';

import '../../../core/error/failure.dart';
import '../application/request_password_reset_use_case.dart';
import '../application/reset_password_use_case.dart';

/// Lifecycle phases of the password-recovery flow.
enum PasswordRecoveryPhase {
  /// No operation in progress; ready to accept input.
  idle,

  /// [requestReset] is in flight; UI should show a spinner.
  sending,

  /// Reset email was sent successfully; UI should show a confirmation.
  emailSent,

  /// [submitNewPassword] is in flight; UI should show a spinner.
  updating,

  /// Password update completed successfully; UI can redirect.
  done,

  /// Either operation failed; [PasswordRecoveryActor.failure] carries details.
  error,
}

/// ChangeNotifier coordinator for the full forgot-password / reset flow.
///
/// Phase transitions:
/// - [requestReset]: idle → sending → emailSent | error
/// - [submitNewPassword]: (any) → updating → done | error
///
/// Listen via [addListener] / [AnimatedBuilder] and rebuild on each notify.
/// Dispose when the widget is removed to release ChangeNotifier resources.
class PasswordRecoveryActor extends ChangeNotifier {
  final RequestPasswordResetUseCase _requestReset;
  final ResetPasswordUseCase _resetPassword;

  /// Current phase of the recovery flow.
  PasswordRecoveryPhase get phase => _phase;
  PasswordRecoveryPhase _phase = PasswordRecoveryPhase.idle;

  /// The failure from the most recent unsuccessful operation, or `null`.
  Failure? get failure => _failure;
  Failure? _failure;

  PasswordRecoveryActor(this._requestReset, this._resetPassword);

  /// Sends a password-reset email to [email] via [redirectTo].
  ///
  /// Transitions: idle → sending → emailSent | error.
  Future<void> requestReset(String email, {required String redirectTo}) async {
    _phase = PasswordRecoveryPhase.sending;
    _failure = null;
    notifyListeners();

    final result = await _requestReset(email, redirectTo: redirectTo);

    result.fold((_) => _phase = PasswordRecoveryPhase.emailSent, (f) {
      _phase = PasswordRecoveryPhase.error;
      _failure = f;
    });

    notifyListeners();
  }

  /// Validates [pwd] and updates the user's password via the recovery session.
  ///
  /// Transitions: (any) → updating → done | error.
  Future<void> submitNewPassword(String pwd) async {
    _phase = PasswordRecoveryPhase.updating;
    _failure = null;
    notifyListeners();

    final result = await _resetPassword(pwd);

    result.fold((_) => _phase = PasswordRecoveryPhase.done, (f) {
      _phase = PasswordRecoveryPhase.error;
      _failure = f;
    });

    notifyListeners();
  }

  /// Resets the actor back to [PasswordRecoveryPhase.idle] and clears failure.
  void reset() {
    _phase = PasswordRecoveryPhase.idle;
    _failure = null;
    notifyListeners();
  }
}
