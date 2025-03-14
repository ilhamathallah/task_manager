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
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                // image
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/image/register.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                    height: 20),
                // name
                Text('Register',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),),
                SizedBox(
                  height: 20,),
                // email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.blue,
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        hintText: "Email",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            BorderSide(color: Colors.black38, width: 2.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            BorderSide(color: Colors.blue, width: 2.0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Email cannot be empty';
                        if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}")
                            .hasMatch(value)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.face,
                          color: Colors.blue,
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        hintText: "Name",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            BorderSide(color: Colors.black38, width: 2.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            BorderSide(color: Colors.blue, width: 2.0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'last name cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.password,
                          color: Colors.blue,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() {
                            isObscurePassword = !isObscurePassword;
                          }),
                          icon: Icon(isObscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        hintText: "Password",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black38, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        ),
                      ),
                      obscureText: isObscurePassword,
                      validator: (value) =>
                      value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Confirm Password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.password,
                          color: Colors.blue,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() {
                            isObscureConfirmPassword = !isObscureConfirmPassword;
                          }),
                          icon: Icon(isObscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        hintText: "Confirm Password",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black38, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        ),
                      ),
                      obscureText: isObscureConfirmPassword,
                      validator: (value) =>
                      value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                // text account
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "You have an account?",
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25),
                // button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: isLoading ? Center(
                    child: CircularProgressIndicator(),
                  ) : GestureDetector(
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
                        'Register',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50,)
              ],
            ),
          ),
      ),
    );
  }
}
