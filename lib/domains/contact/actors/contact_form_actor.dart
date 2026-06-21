import 'package:flutter/foundation.dart';

import '../../../core/error/failure.dart';
import '../application/submit_contact_inquiry_use_case.dart';
import '../domain/contact_inquiry.dart';

/// Enumeration of possible submission lifecycle states.
enum ContactFormStatus {
  /// No submission in progress; ready to accept user input.
  idle,

  /// Submission is in flight; UI should show a spinner and disable the button.
  submitting,

  /// Submission completed successfully; UI should show a success toast.
  success,

  /// Submission failed; [ContactFormActor.failure] describes the error.
  error,
}

/// ChangeNotifier coordinator for the contact form submission flow.
///
/// Exposes [status] and [failure] as observable state.  The widget listens
/// via [addListener] / [AnimatedBuilder] and rebuilds on each notify.
///
/// Lifecycle:
/// 1. Construct with a [SubmitContactInquiryUseCase].
/// 2. Call [submit] — status transitions: idle → submitting → success|error.
/// 3. Call [reset] to return to idle (e.g. before showing a fresh form).
/// 4. [dispose] when the widget is removed to release ChangeNotifier resources.
class ContactFormActor extends ChangeNotifier {
  final SubmitContactInquiryUseCase _useCase;

  /// Current lifecycle status of the submission.
  ContactFormStatus get status => _status;
  ContactFormStatus _status = ContactFormStatus.idle;

  /// The failure from the most recent unsuccessful submission, or `null`.
  Failure? get failure => _failure;
  Failure? _failure;

  ContactFormActor(this._useCase);

  /// Submits [inquiry] through the use case and updates state accordingly.
  ///
  /// Notifies listeners twice: once when submitting starts, once when it ends.
  Future<void> submit(ContactInquiry inquiry) async {
    _status = ContactFormStatus.submitting;
    _failure = null;
    notifyListeners();

    final result = await _useCase(inquiry);

    result.fold(
      (_) {
        _status = ContactFormStatus.success;
        _failure = null;
      },
      (failure) {
        _status = ContactFormStatus.error;
        _failure = failure;
      },
    );

    notifyListeners();
  }

  /// Resets status to [ContactFormStatus.idle] and clears any failure.
  void reset() {
    _status = ContactFormStatus.idle;
    _failure = null;
    notifyListeners();
  }
}
