import 'dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:equipment_tracking/services/auth_provider.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  bool _isSignup = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();

  String? _selectedRole;
  List <String> _roles =["Worker", "Supervisor", "Admin"];
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Color craneYellow = const Color.fromARGB(255, 169, 143, 66);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  void _toggleForm() {
    setState(() {
      _isSignup = !_isSignup;
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      if (_isSignup) {
        await authProvider.signUp(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _companyNameController.text.trim(),
          _cityController.text.trim(),
          _provinceController.text.trim(),
          _selectedRole ?? "",
        );
      } else {
        await authProvider.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      }

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/crane_logo.png',
                width: 120,
                height: 120,
                errorBuilder: (context, error, stackTrace) {
                  return const Text("⚠️ Image not found!", style: TextStyle(color: Colors.red));
                },
              ),
              const SizedBox(height: 10),
              Text(
                "Equipment Tracker",
                style: GoogleFonts.roboto(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: craneYellow,
                ),
              ),
              const SizedBox(height: 20),

              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: craneYellow, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: craneYellow.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (_isSignup) _buildTextField(controller: _firstNameController, label: "First Name", icon: Icons.person),
                        if (_isSignup) _buildTextField(controller: _lastNameController, label: "Last Name", icon: Icons.person_outline),
                        if (_isSignup) _buildTextField(controller: _companyNameController, label: "Company Name", icon: Icons.business),
                        if (_isSignup) _buildTextField(controller: _cityController, label: "City", icon: Icons.location_city),
                        if (_isSignup) _buildTextField(controller: _provinceController, label: "Province", icon: Icons.map),

                        if (_isSignup)
                          _buildDropdownField(
                            label: "Role",
                            items: _roles,
                            selectedValue: _selectedRole,
                            onChanged: (value) => setState(() => _selectedRole = value),
                          ),

                        _buildTextField(controller: _emailController, label: "Email", icon: Icons.email),
                        _buildTextField(controller: _passwordController, label: "Password", icon: Icons.lock, obscureText: true),
                        const SizedBox(height: 20),

                        OutlinedButton(
                          onPressed: () => _submitForm(context),
                          style: _buttonStyle(),
                          child: Text(
                            _isSignup ? "Sign Up" : "Login",
                            style: GoogleFonts.roboto(fontSize: 16, color: Colors.black),
                          ),
                        ),

                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: _toggleForm,
                          child: Text(
                            _isSignup ? "Already have an account? Login" : "Don't have an account? Sign Up",
                            style: GoogleFonts.roboto(fontSize: 16, color: craneYellow),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({required String label, required List<String> items, required String? selectedValue, required Function(String?) onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.roboto(fontSize: 16, color: craneYellow),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: craneYellow)),
        ),
        dropdownColor: Colors.black,
        style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
        items: items.map((value) => DropdownMenuItem(value: value, child: Text(value, style: TextStyle(color: Colors.white)))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, bool obscureText = false, bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        obscureText: obscureText,
        style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.roboto(fontSize: 16, color: craneYellow),
          prefixIcon: Icon(icon, color: craneYellow),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: craneYellow),
          ),
        ),
        validator: (value) => value!.isEmpty ? "⚠️ $label is required" : null,
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return OutlinedButton.styleFrom(
      backgroundColor: craneYellow,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
