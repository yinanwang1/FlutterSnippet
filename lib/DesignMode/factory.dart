import 'dart:core';

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

class DataAccess {
  static const String dbNameSqlServer = "sqlServer";
  static const String dbNameAccess = "access";

  static String db = dbNameSqlServer;

  static IUser createUser() {
    switch(db) {
      case dbNameSqlServer:
        return SqlServerUser();
      case dbNameAccess:
        return AccessUser();
    }

    return SqlServerUser();
  }

  static IProject createProject() {
    switch(db) {
      case dbNameSqlServer:
        return SqlServerProject();
      case dbNameAccess:
        return AccessProject();
    }

    return SqlServerProject();
  }
}

