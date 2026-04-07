class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^[+]?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > 100) {
      return 'Name must be less than 100 characters';
    }
    final nameRegex = RegExp(r"^[a-zA-Z\s\-'\.]+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return 'Name can only contain letters, spaces, hyphens and apostrophes';
    }
    return null;
  }

  static String? validateRequired(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date is required';
    }
    // Accepts DD/MM/YYYY or YYYY-MM-DD format
    final dateRegex1 = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    final dateRegex2 = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex1.hasMatch(value) && !dateRegex2.hasMatch(value)) {
      return 'Please enter a valid date (DD/MM/YYYY)';
    }
    return null;
  }

  static String? validateTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Time is required';
    }
    final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9](\s?(AM|PM|am|pm))?$');
    if (!timeRegex.hasMatch(value.trim())) {
      return 'Please enter a valid time (HH:MM)';
    }
    return null;
  }

  static String? validateLatitude(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // optional
    }
    final lat = double.tryParse(value);
    if (lat == null || lat < -90 || lat > 90) {
      return 'Latitude must be between -90 and 90';
    }
    return null;
  }

  static String? validateLongitude(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // optional
    }
    final lon = double.tryParse(value);
    if (lon == null || lon < -180 || lon > 180) {
      return 'Longitude must be between -180 and 180';
    }
    return null;
  }

  static String? validatePlace(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Place of birth is required';
    }
    if (value.trim().length < 2) {
      return 'Please enter a valid place name';
    }
    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // optional
    }
    final urlRegex = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
    );
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    return null;
  }
}
