part of '../pages.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final title = TextEditingController();
  final subtitle = TextEditingController();
  final priority = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  void _addTask() async {
    if (title.text.isNotEmpty && subtitle.text.isNotEmpty) {
      await _firebaseService.addTask(
        title.text,
        subtitle.text,
        priority.text, // Tambahkan priority
      );

      _clearFields();
      Navigator.pop(context); // Pindahkan ke sini agar hanya terjadi setelah task berhasil ditambahkan
    }
  }

  void _clearFields() {
    title.clear();
    subtitle.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Add Tasks',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.blue),
              ),
            ),
            SizedBox(height: 20),
            titleWidget(),
            SizedBox(height: 20),
            subtitleWidget(),
            SizedBox(height: 20),

            // Perbaikan: Radio Button untuk Priority
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text("Priority:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            //       RadioListTile(
            //         title: Text(''),
            //         value: priority,
            //         groupValue: priority,
            //         onChanged: (value) {
            //           setState(() => _selectedPriority = value.toString());
            //         },
            //       ),
            //     ],
            //   ),
            // ),

            buttonAddCancel()
          ],
        ),
      ),
    );
  }

  Widget buttonAddCancel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: Size(170, 48)),
          onPressed: _addTask,
          child: Text('Add Task', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: Size(170, 48)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget titleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: TextFormField(
          controller: title,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: "Title",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black38, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget subtitleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: TextFormField(
          maxLines: 3,
          controller: subtitle,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: "Subtitle",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black38, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
          ),
        ),
      ),
    );
  }
}
