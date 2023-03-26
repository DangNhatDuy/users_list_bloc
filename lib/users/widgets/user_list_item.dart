import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_flutter_application/users/models/models.dart';
import 'package:flutter/material.dart';

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(25.0)),
        child: CachedNetworkImage(
          width: 50.0,
          height: 50.0,
          imageUrl: user.avatar ?? '',
          fit: BoxFit.fill,
          placeholder: (context, url) => Container(
            color: Colors.grey,
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.red.shade400,
          ),
        ),
      ),
      title: Text('${user.firstName} ${user.lastName}'),
      subtitle: Text(user.email ?? ''),
      dense: true,
    );
  }
}
