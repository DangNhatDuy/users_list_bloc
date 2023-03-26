import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_flutter_application/users/models/models.dart';
import 'package:flutter/material.dart';

class UserGridItem extends StatelessWidget {
  final User user;

  const UserGridItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
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
        const SizedBox(
          height: 8.0,
        ),
        Text(user.email ?? ''),
        const SizedBox(
          height: 8.0,
        ),
        Text('${user.firstName} ${user.lastName}'),
      ],
    );
  }
}
