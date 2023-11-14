import 'package:chat_app/models/users.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final users = [
    User(online: true, email: 'user@email.com', name: 'User Name 1', uuid: '1'),
    User(
        online: true, email: 'user1@email.com', name: 'User Name 2', uuid: '2'),
    User(
        online: false,
        email: 'user2@email.com',
        name: 'User Name 3',
        uuid: '3'),
    User(
        online: true, email: 'user3@email.com', name: 'User Name 4', uuid: '4'),
    User(
        online: false,
        email: 'user4@email.com',
        name: 'User Name 5',
        uuid: '5'),
    User(
        online: true, email: 'user5@email.com', name: 'User Name 6', uuid: '6'),
    User(
        online: true, email: 'user6@email.com', name: 'User Name 7', uuid: '7'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mi Name'),
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {},
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.offline_bolt,
                color: Colors.blueAccent,
              ),
            )
          ],
        ),
        body: _UserList(users: users));
  }
}

class _UserList extends StatelessWidget {
  const _UserList({
    required this.users,
  });

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => _ItemUser(user: users[index]),
      itemCount: users.length,
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}

class _ItemUser extends StatelessWidget {
  const _ItemUser({
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      leading: CircleAvatar(child: Text(user.name.substring(0, 2))),
      trailing: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
    );
  }
}
