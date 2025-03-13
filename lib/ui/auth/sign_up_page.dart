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

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      User? user = await _auth.signUp(emailController.text, passwordController.text);
      if (user != null) {
        await _firebaseStore.collection('users').doc(user.uid).set({
          'email': emailController.text,
          'name': nameController.text,
        });
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Register success! ${user.email}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 218,
              color: Colors.amber,
              child: Center(
                child: Image.asset('assets/image/image_app.png', height: 150),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    const Text('Register',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(hintText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email cannot be empty';
                        if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}").hasMatch(value)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(hintText: 'Name'),
                      keyboardType: TextInputType.name,
                      validator: (value) => value == null || value.isEmpty ? 'Name cannot be empty' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => isObscurePassword = !isObscurePassword),
                          icon: Icon(isObscurePassword ? Icons.visibility_off : Icons.visibility),
                        ),
                      ),
                      obscureText: isObscurePassword,
                      validator: (value) => value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => isObscureConfirmPassword = !isObscureConfirmPassword),
                          icon: Icon(isObscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                        ),
                      ),
                      obscureText: isObscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Confirm password cannot be empty';
                        if (value != passwordController.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Register', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text('Sign In', style: TextStyle(color: Colors.amber)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
