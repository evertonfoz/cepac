import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateAccountModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for display_name widget.
  TextEditingController? displayNameController;
  String? Function(BuildContext, String?)? displayNameControllerValidator;
  String? _displayNameControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Informe seu nome completo';
    }

    if (!RegExp('^[\\w\'\\-,.][^0-9_!¡?÷?¿/\\\\+=@#\$%ˆ&*(){}|~<>;:[\\]]{3,}\$')
        .hasMatch(val)) {
      return 'Informe seu nome completo';
    }
    return null;
  }

  // State field(s) for email widget.
  TextEditingController? emailController;
  String? Function(BuildContext, String?)? emailControllerValidator;
  String? _emailControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Informe seu email';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Email inválido';
    }
    return null;
  }

  // State field(s) for password widget.
  TextEditingController? passwordController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordControllerValidator;
  String? _passwordControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Informe sua senha';
    }

    if (val.length < 6) {
      return 'Mínimo 6 caracteres';
    }

    return null;
  }

  // State field(s) for password_confirm widget.
  TextEditingController? passwordConfirmController;
  late bool passwordConfirmVisibility;
  String? Function(BuildContext, String?)? passwordConfirmControllerValidator;
  String? _passwordConfirmControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Digite novamente sua senha';
    }

    return null;
  }

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    displayNameControllerValidator = _displayNameControllerValidator;
    emailControllerValidator = _emailControllerValidator;
    passwordVisibility = false;
    passwordControllerValidator = _passwordControllerValidator;
    passwordConfirmVisibility = false;
    passwordConfirmControllerValidator = _passwordConfirmControllerValidator;
  }

  void dispose() {
    displayNameController?.dispose();
    emailController?.dispose();
    passwordController?.dispose();
    passwordConfirmController?.dispose();
  }

  /// Additional helper methods are added here.

}
