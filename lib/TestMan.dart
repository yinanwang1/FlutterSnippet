void main() {

  Cat a = Cat();
  a.chase(Alligator());

}

class Animal {
  void chase(Animal a) {
    print("eat $a");
  }

  HoneyBadger get parent => HoneyBadger();
}

class HoneyBadger extends Animal {
  @override
  void chase(Object a) {
    print("Honey badger eat $a");
  }

  @override
  HoneyBadger get parent => super.parent;
}

class Mouse extends Animal {

}

class Cat extends Animal {
  @override
  void chase(Object a) {
    print("cat chase $a");

  }
}

class Alligator {

}



