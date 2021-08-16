import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  SearchBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;
  final ValueNotifier<bool> emptyFiled = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      toolbarHeight: 70,
      floating: true,
      snap: true,
      flexibleSpace: Align(
        alignment: Alignment.center,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).splashColor,
                Theme.of(context).highlightColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.search_outlined,
                  color: Theme.of(context).focusColor,
                ),
              ),
              Flexible(
                child: TextField(
                  controller: controller,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      emptyFiled.value = false;
                    } else {
                      emptyFiled.value = true;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Поиск',
                    hintStyle: Theme.of(context).textTheme.subtitle1,
                    border: InputBorder.none,
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: emptyFiled,
                builder: (context,bool value, child) {
                  if (value) {
                    return const SizedBox.shrink();
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.close),
                      color: Theme.of(context).focusColor,
                      onPressed: () {
                        controller.text = '';
                        emptyFiled.value = true;
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
