class AppValidators {
  AppValidators._();

  /// Validates that a field is not empty.
  static String? requiredField(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required for system execution.';
    }
    return null;
  }

  /// Enforces a maximum character limit (e.g., for task titles)
  static String? maxLength(String? value, int max, [String fieldName = 'Input']) {
    if (value != null && value.length > max) {
      return '$fieldName exceeds maximum length of $max characters.';
    }
    return null;
  }

  /// Combined validator: Required + Max Length
  static String? taskTitleValidator(String? value) {
    final req = requiredField(value, 'Directive Title');
    if (req != null) return req;
    
    return maxLength(value, 64, 'Directive Title');
  }

  /// Validates optional numeric inputs (e.g., target goal counts)
  static String? numericOnly(String? value) {
    if (value == null || value.trim().isEmpty) return null; // Optional
    
    final number = int.tryParse(value);
    if (number == null) {
      return 'System requires a valid numeric integer.';
    }
    if (number < 0) {
      return 'Value cannot be negative.';
    }
    return null;
  }
}