part of '../pages.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final title = TextEditingController();
  final subtitle = TextEditingController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Edit Page', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.blue),),
            ),
            SizedBox(height: 20),
            titleWidget(),
            SizedBox(height: 20),
            subtitleWidget(),
            SizedBox(height: 20),
            chooseImage(),
            SizedBox(height: 20),
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
            Navigator.pop(context);
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

  Widget chooseImage(){
    return Container(
      height: 180,
      child: ListView.builder(
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onDoubleTap: (){
                index = index;
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 2,
                      color: index == index ? Colors.blue : Colors.grey
                  ),
                ),
                width: 140,
                margin: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Image.asset('assets/image/note.png'),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget titleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: TextFormField(
          controller: title,
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
          controller: subtitle,
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
