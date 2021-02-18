import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sample_data/avatars.dart';
import 'package:tasky_app/utils/ui_utils/custom_colors.dart';
import 'package:time_ago_provider/time_ago_provider.dart' as timeAgo;

class InboxView extends StatefulWidget {
  @override
  _InboxViewState createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  final List<String> options = [
    'All',
    'Assigned to me',
    '@Mentioned',
    'Assigned to team'
  ];
  int currentIndex = 0;
  final List<Map<String, dynamic>> data = [
    {
      'avatar': kidsAvatar(),
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce luctus lobortis metus et auctor. Curabitur suscipit, lectus ut pulvinar cursus, dolor arcu iaculis nulla, id dictum ipsum nisl eget dui.',
      'isLiked': Random().nextBool(),
      'teamName': 'Backend team',
      'title': 'Update documentation',
      'timestamp': timeAgo.format(
          DateTime.now().subtract(Duration(days: Random().nextInt(10)))),
      'dueDate': 'Due soon',
      'replies': Random().nextInt(10)
    },
    {
      'avatar': kidsAvatar(),
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce luctus lobortis metus et auctor. ',
      'isLiked': Random().nextBool(),
      'teamName': 'Frontend team',
      'title': 'Mobile View Compartibility',
      'timestamp': timeAgo.format(
          DateTime.now().subtract(Duration(days: Random().nextInt(10)))),
      'dueDate': 'Completed',
      'replies': Random().nextInt(10)
    },
    {
      'avatar': kidsAvatar(),
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce luctus lobortis metus et auctor. Curabitur suscipit, lectus ut pulvinar cursus, dolor arcu iaculis nulla, id dictum ipsum nisl eget dui.',
      'isLiked': Random().nextBool(),
      'teamName': 'UI/UX team',
      'title': 'Make changes to mobile mockup',
      'timestamp': timeAgo.format(
          DateTime.now().subtract(Duration(days: Random().nextInt(10)))),
      'dueDate': 'Due soon',
      'replies': Random().nextInt(10)
    },
    {
      'avatar': kidsAvatar(),
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce luctus lobortis metus et auctor. ',
      'isLiked': Random().nextBool(),
      'teamName': 'Frontend team',
      'title': 'Mobile View Compartibility',
      'timestamp': timeAgo.format(
          DateTime.now().subtract(Duration(days: Random().nextInt(10)))),
      'dueDate': 'Completed',
      'replies': Random().nextInt(10)
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inbox',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize:
              Size(MediaQuery.of(context).size.width, kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    options.length,
                    (index) => Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                            child: Material(
                              color: currentIndex == index
                                  ? customRedColor.withOpacity(.2)
                                  : customGreyColor.withOpacity(.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                  options[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          color: currentIndex == index
                                              ? customRedColor
                                              : customGreyColor),
                                )),
                              ),
                            ),
                          ),
                        )),
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
          padding: EdgeInsets.all(24),
          itemBuilder: (context, index) => InboxItemWidget(
                avatar: data[index]['avatar'],
                description: data[index]['description'],
                isLiked: data[index]['isLiked'],
                teamName: data[index]['teamName'],
                title: data[index]['title'],
                timestamp: data[index]['timestamp'],
                dueDate: data[index]['dueDate'],
                replies: data[index]['replies'],
              ),
          separatorBuilder: (context, index) => Divider(),
          itemCount: data.length),
      floatingActionButton: FloatingActionButton(
        backgroundColor: customRedColor,
        child: Icon(
          MaterialCommunityIcons.chat_outline,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pushNamed('/createInboxView'),
      ),
    );
  }
}

class InboxItemWidget extends StatelessWidget {
  final String teamName;
  final String title;
  final String description;
  final String dueDate;
  final String timestamp;
  final bool isLiked;
  final String avatar;
  final int replies;

  const InboxItemWidget({
    Key key,
    @required this.teamName,
    @required this.title,
    @required this.description,
    @required this.dueDate,
    @required this.timestamp,
    @required this.isLiked,
    @required this.avatar,
    this.replies = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    teamName,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              Text(
                dueDate,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: dueDate == 'Completed'
                        ? Colors.green
                        : customGreyColor),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                        side: BorderSide(
                            color: dueDate == 'Completed'
                                ? Colors.transparent
                                : customGreyColor)),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: dueDate == 'Completed'
                          ? Colors.green
                          : Colors.transparent,
                      child: Icon(
                        Icons.check,
                        color: dueDate == 'Completed'
                            ? Colors.white
                            : customGreyColor,
                        size: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              replies == 0
                  ? SizedBox()
                  : Material(
                      color: customRedColor,
                      borderRadius: BorderRadius.circular(35),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                        child: Row(
                          children: [
                            Text(
                              '$replies',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Icon(
                              Ionicons.ios_chatbubbles,
                              color: Colors.white,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                    )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors
                    .primaries[Random().nextInt(Colors.primaries.length)]
                    .withOpacity(.2),
                radius: 30,
                backgroundImage:
                    ExactAssetImage(kidsAvatar(), package: 'sample_data'),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 120,
                    child: Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '$timestamp - ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: customGreyColor),
                      ),
                      Icon(
                        isLiked ? Icons.thumb_up : Feather.thumbs_up,
                        color: isLiked ? customRedColor : customGreyColor,
                        size: 20,
                      )
                    ],
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
