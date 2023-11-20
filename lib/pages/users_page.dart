import 'package:chat_app/models/users.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _refreshController = RefreshController(initialRefresh: false);
  final userService = UserService();
  List<User> users = <User>[];

  @override
  void initState() {
    super.initState();

    _loadRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(
      context,
    );
    final user = authService.user;

    return Scaffold(
        appBar: AppBar(
          title: Text(user?.name ?? ''),
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('login');
              socketService.disconnect();
              AuthService.deleteToken();
            },
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: socketService.serverStatus == ServerStatus.offline
                  ? const Icon(
                      Icons.offline_bolt,
                      color: Colors.red,
                    )
                  : const Icon(Icons.check_circle, color: Colors.blueAccent),
            )
          ],
        ),
        body: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            onRefresh: _loadRefresh,
            header: WaterDropHeader(
              complete: Icon(
                Icons.check,
                color: Colors.blue[400],
              ),
            ),
            child: _UserList(users: users)));
  }

  _loadRefresh() async {
    final _users = await userService.fetchUsers();
    users = [..._users];

    _refreshController.refreshCompleted();

    setState(() {});
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
      physics: const BouncingScrollPhysics(),
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
      subtitle: Text(user.email),
      leading: CircleAvatar(child: Text(user.name.substring(0, 2))),
      trailing: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.target = user;
        Navigator.of(context).pushNamed('chat');
      },
    );
  }
}
