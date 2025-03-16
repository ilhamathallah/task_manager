part of '../pages.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isObscurePassword = true;
  bool isObscureConfirmPassword = true;
  bool isLoading = false;

  final _auth = FirebaseService();
  final _firebaseStore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        User? user = await _auth.signUp(emailController.text, passwordController.text);

        if (user != null) {
          await _firebaseStore.collection('users').doc(user.uid).set({
            'email': emailController.text,
            'name': nameController.text,
          });

          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Image.asset('assets/image/register.jpg', width: double.infinity, height: 250, fit: BoxFit.cover),
                  SizedBox(height: 20),
                  Text('Register', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue)),
                  SizedBox(height: 20),

                  // Email
                  _buildTextField(
                    controller: emailController,
                    hint: "Email",
                    icon: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Email cannot be empty';
                      if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}").hasMatch(value)) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),

                  // Name
                  _buildTextField(
                    controller: nameController,
                    hint: "Name",
                    icon: Icons.person,
                    textInputType: TextInputType.text,
                    validator: (value) => value == null || value.isEmpty ? 'Name cannot be empty' : null,
                  ),

                  SizedBox(height: 10),

                  // Password
                  _buildTextField(
                    controller: passwordController,
                    hint: "Password",
                    icon: Icons.lock,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),

                  SizedBox(height: 10),

                  // Confirm Password
                  _buildTextField(
                    controller: confirmPasswordController,
                    hint: "Confirm Password",
                    icon: Icons.lock,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.length < 6) return 'Password must be at least 6 characters';
                      if (value != passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),

                  SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("You have an account?", style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                        child: Text('Login', style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),

                  SizedBox(height: 25),

                  isLoading ? Center(child: CircularProgressIndicator()) : GestureDetector(
                    onTap: () {
                      _signUp();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        'register',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType textInputType = TextInputType.emailAddress,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: isPassword ? isObscurePassword : false,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue),
        suffixIcon: isPassword
            ? IconButton(
          onPressed: () => setState(() {
            if (controller == passwordController) {
              isObscurePassword = !isObscurePassword;
            } else {
              isObscureConfirmPassword = !isObscureConfirmPassword;
            }
          }),
          icon: Icon(controller == passwordController
              ? (isObscurePassword ? Icons.visibility_off : Icons.visibility)
              : (isObscureConfirmPassword ? Icons.visibility_off : Icons.visibility)),
        )
            : null,
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black38, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
      validator: validator,
    );
  }
}
