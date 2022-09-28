// ignore_for_file: public_member_api_docs, sort_constructors_first

class Contact {
  static const tblContact = 'contacts';
  static const calId = 'id';
  static const callname = 'name';
  static const callmob = 'mobile';

  int? id;
  String? name;
  String? mobile;
  Contact({
    this.id,
    this.name,
    this.mobile,
  });

  Contact.fromMap(Map<String, dynamic> map) {
    id = map[calId];
    name = map[callname];
    mobile = map[callmob];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{callname: name, callmob: mobile};
    if (id != null) {
      map[calId] = id;
    }
    return map;
  }
}
