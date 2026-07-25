class AppStrings {
  AppStrings._();

  // Global App Info
  static const String appName = 'STEPS';

  // Navigation / Shell
  static const String navDashboard = 'Mission Control';
  static const String navRoutines = 'Routines';
  static const String navTasks = 'Tasks';
  static const String navCalendar = 'Calendar';

  // Dashboard Feature
  static const String dashboardGreeting = 'System Online.';
  static const String dashboardActiveStreaks = 'Active Streaks';
  static const String dashboardUrgentTasks = 'Priority Execution';
  static const String dashboardProgress = 'System Progress';

  // Routines Feature
  static const String routinesTitle = 'Daily Protocols';
  static const String routinesEmpty = 'No protocols established. Initiate a new routine.';
  static const String createRoutine = 'Establish Routine';
  static const String streakMultiplier = 'Multiplier Active';

  // Tasks Feature
  static const String tasksTitle = 'Pending Directives';
  static const String tasksEmpty = 'All directives cleared.';
  static const String createTask = 'New Directive';
  static const String taskDeadline = 'Deadline:';

  // Common UI
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String confirm = 'Confirm';

  // Error States
  static const String errorGeneric = 'System Error. Please reboot sequence.';
  static const String errorDatabase = 'Data retrieval failed.';
  static const String errorValidation = 'Invalid parameters entered.';
}