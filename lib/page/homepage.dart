import 'package:croud/databasehelper/databasehelper.dart';
import 'package:croud/main.dart';
import 'package:croud/model/contact.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _fromkey = GlobalKey<FormState>();

  Contact contact = Contact();
  List<Contact> _contact = [];
  DatabaseHelper? _databaseHelper;

  final _nameControlar = TextEditingController();
  final _mobileControlar = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _databaseHelper = DatabaseHelper.instense;
    });

    refreshlist();
  }

  refreshform() {
    setState(() {
      var fresh = _fromkey.currentState;
      if (fresh != null) {
        fresh.reset();
        _nameControlar.clear();
        _mobileControlar.clear();
        contact.id = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Croud Operation",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_form(), _list()],
          ),
        ),
      ),
    );
  }

  _form() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Form(
          key: _fromkey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameControlar,
                validator: (value) {
                  if (value!.length < 5) {
                    return "Required At list 6 Charectar";
                  } else {
                    return null;
                  }
                },
                onSaved: ((Value) {
                  setState(() {
                    contact.name = Value;
                  });
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Your Name",
                ),
              ),
              TextFormField(
                controller: _mobileControlar,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.length < 11) {
                    return "Required At list 11 number";
                  } else {
                    return null;
                  }
                },
                onSaved: (newValue) => contact.mobile = newValue,
                decoration: const InputDecoration(labelText: "Mobile "),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                color: darkblucolor,
                child: MaterialButton(
                  onPressed: () {
                    _onsubmit();
                  },
                  color: Colors.blue,
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          )),
    );
  }

  _list() => Expanded(
          child: ListView.builder(
        itemCount: _contact.length,
        itemBuilder: ((context, index) {
          return Card(
            margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.account_circle,
                    color: Colors.amberAccent,
                    size: 30,
                  ),
                  title: Text(_contact[index].name.toString().toUpperCase()),
                  subtitle: Text(_contact[index].mobile.toString()),
                  trailing: IconButton(
                    onPressed: (() async {
                      if (_databaseHelper != null) {
                        await _databaseHelper!.delete(_contact[index].id!);
                        refreshlist();
                        refreshform();
                      }
                    }),
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                  ),
                  onTap: () {
                    setState(() {
                      contact = _contact[index];
                      _nameControlar.text = _contact[index].name.toString();
                      _mobileControlar.text = _contact[index].mobile.toString();
                      // refreshform();
                      // refreshlist();
                    });
                  },
                ),
                const Divider(
                  height: 5,
                ),
              ],
            ),
          );
        }),
        padding: const EdgeInsets.all(8),
      ));

  void _onsubmit() async {
    var form = _fromkey.currentState;
    if (form!.validate()) {
      form.save();

      if (_databaseHelper != null) {
        if (contact.id == null) {
          await _databaseHelper!.insert(contact);
        } else {
          await _databaseHelper!.update(contact);
        }
        refreshlist();
        refreshform();
      }

      form.reset();
    }
  }

  refreshlist() async {
    List<Contact> x = await _databaseHelper!.showallData();
    setState(() {
      _contact = x;
    });
  }
}
