class Place_Details {

  String name;
  int number;
  bool kosher;

  Place_Details({required this.name, required this.number, required this.kosher});

  String getName(){
    return this.name;
  }

  int getNumber(){
    return this.number;
  }

  bool getKosher(){
    return this.kosher;
  }

}