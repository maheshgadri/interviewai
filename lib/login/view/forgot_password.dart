import 'package:flutter/material.dart';

// class ForgotPasswordScreen extends StatelessWidget {
//   const ForgotPasswordScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Forgot Password'),
//       ),
//       body: const Padding(
//         padding: EdgeInsets.all(20.0),
//         child: ForgotPasswordForm(),
//       ),
//     );
//   }
// }

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  TextEditingController _emailController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your email or mobile number';
    }
    return null;
  }

  void _sendResetPasswordLink() {
    if (Form.of(context)!.validate()) {
      String email = _emailController.text;
      // Implement logic to send reset password link
      // After sending the link, navigate back to login screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Enter registered Email ID or Mobile Number',
            ),
            validator: _validateEmail,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _sendResetPasswordLink,
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}

