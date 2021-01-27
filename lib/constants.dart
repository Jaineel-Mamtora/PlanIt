const String APP_NAME = 'PlanIt';
const String FONT_NAME = 'OpenSans';
const String PACKAGE_ID = 'com.trailblazing.planit';

class GeneralConstants {
  static const String NO = 'NO';
  static const String YES = 'YES';
  static const String SIGN_OUT = 'SIGN OUT';
  static const String SAVE = 'SAVE';
  static const String NO_ROUTES_DEFINED = 'No route defined for %s';
}

class NotificationConstants {
  static const String DEFAULT_LOCATION = 'America/Detroit';
  static const String NOTIFICATION_CLICK_ERROR = 'Notification Click Error';
  static const String NOTIFICATION_TYPE = 'type';
  static const String PUSH_NOTIFICATION_TITLE = 'Reminder: Priority %s';
  static const String PUSH_NOTIFICATION_BODY_WITH_ONLY_FROM_TIME =
      'Todo: %s at %s';
  static const String PUSH_NOTIFICATION_BODY_WITH_BOTH_FROM_TIME_AND_TO_TIME =
      'Todo: %s from %s to %s';
}

class DatabaseConstants {
  static const String DB_NAME = 'plan_it.sqlite';
  static const String TABLE_NAME = 'plan_it';
  static const String ID = '_id';
  static const String TITLE = 'title';
  static const String FROM_TIME = 'from_time';
  static const String DATE = 'date';
  static const String TO_TIME = 'to_time';
  static const String REMINDER = 'reminder';
  static const String PRIORITY = 'priority';
  static const String STATUS = 'status';
}

class AuthConstants {
  static const String PLEASE_FILL_ALL_THE_DETAILS =
      'Please fill up all the fields.';
  static const String PLEASE_ENTER_A_VALID_EMAIL_ADDRESS =
      'Please enter a valid email address.';
  static const String PASSWORD_DO_NOT_MATCH = 'Passwords do not match.';
  static const String PASSWORD_LENGTH_ATLEAST_SIX_CHARACTERS =
      'Password must be atleast 6 characters long.';
  static const String NOT_VERIFIED = 'Not Verified';
  static const String ERROR_EMAIL_ALREADY_IN_USE = 'ERROR_EMAIL_ALREADY_IN_USE';
  static const String EMAIL_ALREADY_LINKED_TO_ACCOUNT =
      'This email is linked to an existing account.';
  static const String REGISTRATION_PROBLEM = 'Registration Problem!';
  static const String PLEASE_ENTER_YOUR_EMAIL_ADDRESS =
      'Please enter your Email Address!';
  static const String PASSWORD_RESET_MAIL_SENT = 'Password reset mail sent!';
  static const String ERROR_SENDING_MAIL_PLEASE_TRY_LATER =
      'Error sending mail! Please try later.';
  static const String EMAIL_SENT = 'Email sent!';
  static const String LOG_IN = 'LOG IN';
  static const String EMAIL = 'Email';
  static const String PASSWORD = 'Password';
  static const String CONFIRM_PASSWORD = 'Confirm Password';
  static const String FORGOT_PASSWORD = 'Forgot Password?';
  static const String OR = 'OR';
  static const String SIGN_IN_WITH_GOOGLE = 'Sign in with Google';
  static const String DONT_HAVE_AN_ACCOUNT = 'Don\'t have an account?';
  static const String ALREADY_HAVE_AN_ACCOUNT = 'Already have an account?';
  static const String SIGN_UP = 'SIGN UP';
  static const String VERIFICATION_PENDING = 'VERIFICATION PENDING';
  static const String
      PLEASE_CLICK_THE_LINK_IN_THE_VERIFICATION_EMAIL_SENT_TO_YOU =
      'Please click the link in the verification email sent to you.';
  static const String REFRESH = 'REFRESH';
  static const String SEND_MAIL_AGAIN = 'SEND MAIL AGAIN';
  static const String SIGN_OUT = 'SIGN OUT';
  static const String EMAIL_VERIFIED = 'Email Verified!';
  static const String EMAIL_NOT_VERIFIED = 'Email not verified!';
}

class TaskConstants {
  static const String ACHIEVEMENT = 'Achievement!';
  static const String DO_YOU_WANT_TO_MARK_THIS_TASK_AS_COMPLETED =
      'Do you want to mark this task as completed?';
  static const String TASK_MARKED_AS_DONE_SUCCESSFULLY =
      'Task mark as done successfully!';
  static const String ARE_YOU_SURE = 'Are you sure?';
  static const String DO_YOU_WANT_TO_REMOVE_PENDING_TASK =
      'Do you want to remove pending Task?';
  static const String DO_YOU_WANT_TO_REMOVE_COMPLETED_TASK =
      'Do you want to remove the completed Task?';
  static const String TASK_DELETED_SUCESSFULLY = 'Task deleted successfully!';
  static const String CUSTOM_CARD_TO_TIME = ' - %s';
  static const String PLEASE_SELECT_START_TIME = 'Please select Start Time!';
  static const String PLEASE_SELECT_VALID_END_TIME =
      'Please select valid End Time!';
  static const String TITLE = 'Title*';
  static const String REMIND_ME = 'Remind Me';
  static const String PLEASE_SELECT_START_TIME_FIRST =
      'Please select start time first!';
  static const String PLEASE_SELECT_VALID_START_TIME =
      'Please select valid start time.';
  static const String PRIORITY = 'Priority';
  static const String PLEASE_ENTER_TITLE_AND_START_TIME =
      'Please enter Title and Start Time.';
  static const String TIME_SLOT_ALREADY_ADDED = 'Time Slot already added!';
  static const String MODAL_SHEET_FROM_TIME = 'From:* %s';
  static const String MODAL_SHEET_TO_TIME = 'To: %s';
  static const String REMINDER = 'Reminder';
  static const String PENDING = 'Pending';
  static const String COMPLETED = 'Completed';
  static const String WHAT_DO_YOU_NEED_TO_DO = 'What do you need to do?';
  static const String TASK_DETAILS = 'Task Details';
}

class CalendarConstants {
  static const String WEEK = 'Week';
  static const String JUMP_TO_A_PARTICULAR_DATE = 'Jump to a particular date';
}
