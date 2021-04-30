class Place_Details {

  String name = '';
  String details ='';
  int number;
  bool kosher;

  Place_Details({required this.name, required this.number, required this.kosher, required this.details});

  String getName(){
    return this.name;
  }

  String getDetails(){
      return this.details;
   }

  int getNumber(){
    return this.number;
  }

  bool getKosher(){
    return this.kosher;
  }

}