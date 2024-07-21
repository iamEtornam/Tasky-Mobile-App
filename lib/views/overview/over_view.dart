import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:strings/strings.dart';
import 'package:tasky_mobile_app/managers/task_manager.dart';
import 'package:tasky_mobile_app/models/task.dart';
import 'package:tasky_mobile_app/models/task_statistic.dart';
import 'package:tasky_mobile_app/shared_widgets/custom_appbar_widget.dart';
import 'package:tasky_mobile_app/shared_widgets/empty_widget.dart';
import 'package:tasky_mobile_app/utils/ui_utils/custom_colors.dart';
import 'package:tasky_mobile_app/utils/ui_utils/ui_utils.dart';

class OverView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  OverView({super.key});
  final TaskManager _taskManager = GetIt.I.get<TaskManager>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CustomAppBarWidget(
        title: 'Overview',
      ),
      body: ListView(
        controller: _scrollController,
        children: [
          StreamBuilder<TaskStatistic?>(
              stream: _taskManager.getTaskStatistics().asStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const LinearProgressIndicator(
                    minHeight: 2,
                  );
                }

                if (snapshot.connectionState == ConnectionState.done &&
                    !snapshot.hasData) {
                  return const SizedBox.shrink();
                }

                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data == null) {
                  return const SizedBox.shrink();
                }

                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data!.data!.isEmpty) {
                  return const SizedBox.shrink();
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data!.data![0].todo == 0 &&
                    snapshot.data!.data![0].inProgress == 0 &&
                    snapshot.data!.data![0].completed == 0) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    Container(
                      color: customGreyColor.withOpacity(.1),
                      height: 45,
                      width: size.width,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'My Summary',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            HomeTaskCountCard(
                                size: size,
                                count: snapshot.data!.data![0].todo,
                                desc: 'To Do',
                                image: 'dots.png',
                                color: const Color(0xffff5722)),
                            HomeTaskCountCard(
                                size: size,
                                count: snapshot.data!.data![1].inProgress,
                                desc: 'In Progress',
                                image: 'circles.png',
                                color: const Color(0xff03a9f4)),
                            HomeTaskCountCard(
                              size: size,
                              count: snapshot.data!.data![2].completed,
                              desc: 'Done',
                              image: 'layers.png',
                              color: const Color(0xff4caf50),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
          Container(
            color: customGreyColor.withOpacity(.1),
            height: 45,
            width: size.width,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'My Tasks',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<Task?>(
              stream: _taskManager.getTasks().asStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CupertinoActivityIndicator());
                }

                if (snapshot.connectionState == ConnectionState.done &&
                    !snapshot.hasData) {
                  return const EmptyWidget(
                    imageAsset: 'no_task.png',
                    message:
                        'Tasks aasigned to you and tasks created for you appears here.',
                  );
                }

                if (snapshot.data == null) {
                  return const EmptyWidget(
                    imageAsset: 'no_task.png',
                    message:
                        'Tasks aasigned to you and tasks created for you appears here.',
                  );
                }
                return ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String date = snapshot.data!.data![index].dueDate!;
                      List<String> dateList = date.split(' ');
                      return HomeTaskSummary(
                        onTap: () {
                          showBarModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return ListView(
                                  padding: const EdgeInsets.all(16),
                                  children: [
                                    Text(
                                      'Task:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      snapshot.data!.data![index].description!,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Assignees:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    SizedBox(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) =>
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: ExtendedImage.network(
                                                    snapshot
                                                        .data!
                                                        .data![index]
                                                        .assignees![index]
                                                        .picture!,
                                                    fit: BoxFit.cover,
                                                    width: 60,
                                                    height: 60,
                                                    cache: true,
                                                    loadStateChanged:
                                                        (ExtendedImageState
                                                            state) {
                                                      if (state
                                                              .extendedImageLoadState ==
                                                          LoadState.failed) {
                                                        return Image.asset(
                                                          'assets/avatar.png',
                                                          fit: BoxFit.cover,
                                                          width: 60,
                                                          height: 60,
                                                        );
                                                      } else {
                                                        return ExtendedRawImage(
                                                          image: state
                                                              .extendedImageInfo
                                                              ?.image,
                                                          fit: BoxFit.cover,
                                                          width: 60,
                                                          height: 60,
                                                        );
                                                      }
                                                    },
                                                  )),
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(
                                                width: 4,
                                              ),
                                          itemCount: snapshot.data!.data![index]
                                              .assignees!.length),
                                    )
                                  ],
                                );
                              });
                        },
                        size: size,
                        priority: Strings.toCapitalised(
                            snapshot.data!.data![index].priorityLevel!),
                        time: UiUtilities().twenty4to12conventer(dateList[1]),
                        title: snapshot.data!.data![index].description,
                      );
                    },
                    itemCount: snapshot.data!.data!.length);
              })
        ],
      ),
    );
  }
}

class HomeTaskSummary extends StatelessWidget {
  const HomeTaskSummary({
    super.key,
    required this.size,
    required this.title,
    required this.priority,
    required this.time,
    required this.onTap,
  });

  final Size size;
  final String? title;
  final String priority;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 10),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 0,
          color: brightness == Brightness.dark
              ? customGreyColor.withOpacity(.1)
              : priority == 'Low'
                  ? const Color.fromRGBO(236, 249, 245, 1)
                  : priority == 'Medium'
                      ? const Color.fromRGBO(251, 245, 225, 1)
                      : const Color.fromRGBO(252, 244, 248, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 80,
                  decoration: BoxDecoration(
                      color: priority == 'Low'
                          ? Colors.green
                          : priority == 'Medium'
                              ? Colors.amber
                              : Colors.red,
                      borderRadius: BorderRadius.circular(45)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: size.width - 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '$priority Priority',
                            style:
                                Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: priority == 'Low'
                                        ? Colors.green
                                        : priority == 'Medium'
                                            ? Colors.amber
                                            : Colors.red,
                                    fontWeight: FontWeight.w600),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                AntDesign.clockcircleo,
                                color: customGreyColor,
                                size: 15,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                time,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        color: customGreyColor,
                                        fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: size.width - 90,
                      child: Text(title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeTaskCountCard extends StatelessWidget {
  const HomeTaskCountCard({
    super.key,
    required this.size,
    required this.desc,
    required this.count,
    required this.image,
    this.color,
  });

  final Size size;
  final String desc;
  final int? count;
  final String image;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color!.withOpacity(.4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 130,
        width: size.width / 3 - 32,
        child: Stack(
          children: [
            Positioned(
                top: 2,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/$image',
                      fit: BoxFit.cover,
                    ))),
            Positioned(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 130,
                width: size.width / 3 - 32,
                color: Colors.black87.withOpacity(.3),
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    desc,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  ),
                  Text(
                    '$count',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontWeight: FontWeight.bold, color: color),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
