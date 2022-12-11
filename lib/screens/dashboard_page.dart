import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_check_kidz_dashboard/data/model/page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/eyepair_cubit.dart';
import '../data/model/eyepair.dart';
import '../utils/custom_page_route.dart';
import '../widgets/error_banner.dart';
import '../widgets/eyepair_view.dart';
import '../widgets/pagination_view.dart';
import 'filter_page.dart';
import '../widgets/more_menu_button.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _pageIndex = 0;
  EyepairPage _page = EyepairPage([]);
  bool _filterIsDefault = true;
  int rowsPerPage = 10;
  final _controller = ScrollController();

@override
  void initState() {
    // TODO: implement initState
    
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<EyepairCubit, EyepairState>(
          listener: (context, state) {
            if (state is EyepairsLoaded) {
              setState(() {
                _pageIndex = state.page.pageIndex;
                _page = state.page;
              });
            }
          },
        ),
      ],
      child: BlocBuilder<EyepairCubit, EyepairState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: Icon(_filterIsDefault
                      ? Icons.filter_list_off
                      : Icons.filter_list_sharp),
                  color: theme.appBarTheme.actionsIconTheme != null
                      ? theme.appBarTheme.actionsIconTheme!.color
                      : theme.primaryIconTheme.color,
                  onPressed: () async {
                    final isDefault = await Navigator.of(context)
                        .push(CustomPageRoute(child: const FilterPage()));
                    if (isDefault != _filterIsDefault) {
                      setState(() {
                        _filterIsDefault = isDefault;
                      });
                    }
                  },
                ),
                MoreMenuButton(),
              ],
              title: const Text('KVC Dashboard'),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      if (state is EyepairsError)
                        ErrorBanner(state.errorDescription),
                      Expanded(
                        child: NotificationListener<ScrollUpdateNotification>(
                          onNotification: (scrollNotification) {
                            return false;
                          },
                          child: EyepairListView(_page.eyepairs, _controller),
                        ),
                      ),
                    ],
                  ),
                  if (state is EyepairsLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  PaginationView(
                    _pageIndex,
                    _page.hasNextPage,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class EyepairListView extends StatefulWidget {
  final List<EyePair> eyepairs;
  final ScrollController controller;

  const EyepairListView(this.eyepairs, this.controller, {Key? key})
      : super(key: key);

  @override
  State<EyepairListView> createState() => _EyepairListViewState();
}

class _EyepairListViewState extends State<EyepairListView> {
  int eyeLoadIndex = 0;
  List<EyePair> eyepairs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eyepairs = widget.eyepairs;
  }

  @override
  void didUpdateWidget(covariant EyepairListView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {
      eyepairs = widget.eyepairs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (_, i) =>
          EyepairView(eyepairs[i], key: ValueKey(eyepairs[i].rowKey)),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: eyepairs.length,
      controller: widget.controller,
    );
  }
}






