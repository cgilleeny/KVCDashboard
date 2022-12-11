import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/eyepair_cubit.dart';

class PaginationView extends StatelessWidget {
  final int pageIndex;
  final bool hasNextPage;

  const PaginationView(this.pageIndex, this.hasNextPage, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EyepairCubit, EyepairState>(
      builder: (context, state) {
        final enablePrev = state is! EyepairsLoading && pageIndex > 0;
        final enableNext = state is! EyepairsLoading && hasNextPage;

        return Container(
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ActionChip(
                    elevation: 6.0,
                    backgroundColor: enablePrev
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    padding: const EdgeInsets.all(8.0),
                    labelPadding: const EdgeInsets.all(8.0),
                    avatar: const CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Icon(Icons.arrow_back),
                    ),
                    label: const Text(
                      'Prev Page',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    onPressed: () {
                      if (enablePrev) {
                        BlocProvider.of<EyepairCubit>(context).fetchPage(
                          pageIndex - 1,
                        );
                      }
                    },
                  ),
                ),
                // Text(pageIndex.toString(), style: const TextStyle(
                //         color: Colors.black,
                //         fontSize: 15.0,
                //       ),),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ActionChip(
                    padding: const EdgeInsets.all(8.0),
                    elevation: 6.0,
                    backgroundColor: enableNext
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    labelPadding: const EdgeInsets.all(8.0),
                    avatar: const CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Icon(Icons.arrow_forward),
                    ),
                    label: const Text(
                      'Next Page',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    onPressed: () {
                      if (enableNext) {
                        BlocProvider.of<EyepairCubit>(context)
                            .fetchPage(pageIndex + 1);
                      }
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
