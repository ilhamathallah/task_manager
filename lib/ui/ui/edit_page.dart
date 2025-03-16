part of '../pages.dart';

class EditPage extends StatefulWidget {
  final String taskId;
  final String title;
  final String subtitle;

  EditPage({required this.taskId, required this.title, required this.subtitle});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final FirebaseService _firebaseService = FirebaseService();
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  bool isLoading = true;
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _subtitleController = TextEditingController(text: widget.subtitle);
  }

  void _editTask() async {
    try {
      await _firebaseService.editTask(widget.taskId, _titleController.text, _subtitleController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task berhasil diperbarui')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengupdate task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Edit Tasks', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.blue),),
            ),
            SizedBox(height: 20),
            // title form
            titleWidget(),
            SizedBox(height: 20),
            // subtitle form
            subtitleWidget(),
            SizedBox(height: 20),
            // button
            buttonAddCancel()
          ],
        ),
      ),
    );
  }

  Widget buttonAddCancel(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: Size(170, 48)
          ),
          onPressed: (){
            _editTask();
          },
          child: Text('Edit task', style: TextStyle(color: Colors.white),),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: Size(170, 48)
          ),
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }

  Widget titleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: TextFormField(
          controller: _titleController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: "title",
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.black38, width: 2.0)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue, width: 2.0)),
          ),
        ),
      ),
    );
  }

  Widget subtitleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: TextFormField(
          maxLines: 3,
          controller: _subtitleController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: "subtitle",
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.black38, width: 2.0)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue, width: 2.0)),
          ),
        ),
      ),
    );
  }
}
