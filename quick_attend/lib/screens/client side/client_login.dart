import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_attend/screens/client%20side/client_home_screen.dart';
import 'package:quick_attend/screens/client%20side/client_registration.dart';


class ClientLoginScreen extends StatefulWidget {
  const ClientLoginScreen({super.key});

  @override
  State<ClientLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<ClientLoginScreen> {
  final TextEditingController _enrollNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

 
Future<void> _loginAdmin() async {
  final enrollNo = _enrollNoController.text;
  final password = _passwordController.text;

  try {
    // Fetch the document from Firestore where the faculty_no matches
    final snapshot = await FirebaseFirestore.instance
        .collection('client_login')
        .where('enroll_no', isEqualTo: enrollNo)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Get the first matching document
      final userDoc = snapshot.docs.first;

      // Check if the password matches
      if (userDoc['password'] == password) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );

        // Navigate to AdminHomeScreen
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(enroll_no: enrollNo)),//give parameters as enroll_no: enrollNo
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect password')),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faculty number not found')),
      );
    }
  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login failed: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Images/Logo.jpg',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text(
                'Log In to your Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _enrollNoController,
                decoration: InputDecoration(
                  labelText: 'Enter your Enroll No.',
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loginAdmin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have an Account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClientRegistrationScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Create an Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
