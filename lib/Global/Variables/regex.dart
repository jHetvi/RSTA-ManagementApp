final RegExp fullNameRgex =
    RegExp(r"^[A-Z][a-zA-Z]*[ A-Z][a-zA-Z]*[ A-Z][a-zA-Z]*$");
final RegExp nameWordRegex = RegExp(r"^[A-Z][a-zA-Z]*");
final RegExp emailRegex =
    RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$");
final RegExp dateRegex = RegExp(r"^\d{1,2}\/\d{1,2}\/\d{4}$");
final RegExp gstinRegex =
    RegExp(r"\d{2}[A-Z]{5}\d{4}[A-Z]{1}[A-Z\d]{1}[Z]{1}[A-Z\d]{1}");
final RegExp tinRegex = RegExp(r"\d{3}-\d{2}-\d{4}|\d{2}-\d{7}");
final RegExp panRegex = RegExp(r"[A-Za-z]{5}\d{4}[A-Za-z]{1}");
final RegExp notEmptyRegex = RegExp(r"^(?!\s*$).+");
final RegExp aadharRegex = RegExp(r"^[2-9]{1}[0-9]{3}[0-9]{4}[0-9]{4}$");
final RegExp passwordRegex =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
