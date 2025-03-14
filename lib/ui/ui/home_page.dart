part of '../pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

bool isDone = true;

class _HomePageState extends State<HomePage> {
  String? userId;
  late Future<Map<String, dynamic>> userData;

  final FirebaseService _auth = FirebaseService();
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    User? user = _auth.currentUser;

    userId = user!.uid;
    userData = _auth.getUserData(userId!);
  }

  void _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }


  bool show = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('error fetching data'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('User data not found'));
          }
          final userData = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.amber,
              leading: Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.menu_rounded,
                    size: 35,
                    color: Colors.white,
                  ),
                );
              }),
              actions: [
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.notifications_none,
                        size: 35,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: SafeArea(
                child: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                if (notification.direction == ScrollDirection.forward) {
                  setState(() {
                    show = true;
                  });
                }
                if (notification.direction == ScrollDirection.reverse) {
                  setState(() {
                    show = false;
                  });
                }
                return true;
              },
              child: Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firebaseService.getNotes(),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),
                      );
                    }
                    if(snapshot.hasError){
                      return Center(child: Text('Error fetching data'));
                    }
                    if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                      return Center(
                        child: Text('No task found',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        return cardTaskManager(document);
                        });
                  }
                ),
              ),
            )),
            floatingActionButton: Visibility(
              visible: show,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddPage(),
                    ),
                  );
                },
                backgroundColor: Colors.blue,
                child: Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            drawer: Drawer(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.amber,
                    child: DrawerHeader(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome',
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            '${snapshot.data!['name']}',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        ListTile(
                          title: Text("Menu 1"),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text("Menu 2"),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, thickness: 1),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _signOut();
                      },
                      icon: Icon(Icons.logout, color: Colors.white),
                      label: Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget cardTaskManager(DocumentSnapshot document) {
    var data = document.data() as Map<String, dynamic>;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 2))
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              // image
              Container(
                width: 100,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/image/note.png'),
                  ),
                ),
              ),
              SizedBox(width: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['title'] ?? 'No Title',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Checkbox(
                            value: data['isDone'] ?? false,
                            onChanged: (value) {
                              setState(() {
                                isDone = !isDone;
                              });
                            },
                        )
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      data['subtitle'] ?? 'No Description',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade400),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 105,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(18)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    data['time'] is Timestamp
                                        ? DateFormat('HH:mm').format((data['time'] as Timestamp).toDate()) // Format hanya jam & menit
                                        : (data['time'] ?? '--:--').toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditPage()));
                            },
                            child: Container(
                              width: 90,
                              height: 28,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(18)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
