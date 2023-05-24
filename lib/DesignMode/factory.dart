import 'package:flutter/cupertino.dart';

// 抽象工厂模式

class User {
  final String name;
  final int id;

  User(this.name, this.id);
}

class Project {
  final String id;
  final String name;

  Project(this.id, this.name);
}

abstract class IUser {
  void insert(User user);

  User getUser(int id);
}

abstract class IProject {
  void insertProject(Project project);

  Project getProject(String id);
}

class SqlServerUser implements IUser {
  @override
  User getUser(int id) {
    debugPrint("在SQL server中根据ID得到User表一条记录");

    return User("name", 0);
  }

  @override
  void insert(User user) {
    debugPrint("在SQL server中给User表增加一条记录");
  }
}

class AccessUser implements IUser {
  @override
  User getUser(int id) {
    debugPrint("在Access中根据ID得到User表一条记录");

    return User("access", 1);
  }

  @override
  void insert(User user) {
    debugPrint("在Access中根据ID得到User表一条记录");
  }
}

class SqlServerProject implements IProject {
  @override
  Project getProject(String id) {
    debugPrint("在sql server中根据ID得到project表一条记录");

    return Project("project", "1");
  }

  @override
  void insertProject(Project project) {
    debugPrint("在sql server中根据ID得到Project表一条记录");
  }

}

class AccessProject implements IProject {
  @override
  Project getProject(String id) {
    debugPrint("在access 中根据ID得到project表一条记录");

    return Project("project", "1");
  }

  @override
  void insertProject(Project project) {
    debugPrint("在access 中根据ID得到Project表一条记录");
  }
}

abstract class IFactory {
  IUser createUser();
  IProject createProject();
}

class SqlServerFactory implements IFactory {
  @override
  IUser createUser() {
    return SqlServerUser();
  }

  @override
  IProject createProject() {
    return SqlServerProject();
  }



}

class AccessFactory implements IFactory {
  @override
  IUser createUser() {
    return AccessUser();
  }

  @override
  IProject createProject() {
   return AccessProject();
  }
}
