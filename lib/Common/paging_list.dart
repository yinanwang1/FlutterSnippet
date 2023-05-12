import 'package:flutter/material.dart';
import 'package:flutter_snippet/Common/my_colors.dart';
import 'package:flutter_snippet/Common/no_data.dart';

/// 分页列表的页面
/// navigationTitle返回标题，页面展示一个title，一个列表。
/// navigationTitle返回null。页面仅仅为一个列表。此时可以重载build添加其他widgets。

abstract class PagingListWidget extends StatefulWidget {
  const PagingListWidget({Key? key}) : super(key: key);

  @override
  PagingListWidgetState createState();
}

abstract class PagingListWidgetState<T extends PagingListWidget, S> extends State<T> {
  // 实现类 获取数据时使用
  final int pageSize = 20;
  int page = 1;
  final List<S> dataList = [];
  bool showLoadingMore = false;
  int total = 0;
  bool hasInitialed = false;

  bool _disposed = false;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (showLoadingMore) {
        return;
      }
      if (_scrollController.position.pixels > (_scrollController.position.maxScrollExtent - 20) && total > dataList.length) {
        setState(() {
          showLoadingMore = true;
        });
        _loadMore();
      }
    });

    Future.delayed(const Duration(seconds: 0), () {
      _onRefresh();
    });
  }

  @override
  void dispose() {
    _disposed = true;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var title = navigationTitle();
    if (null == title) {
      return _contentWidget();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: _contentWidget(),
    );
  }

// Widget __START__

  Widget _contentWidget() {
    return SafeArea(
      child: !hasInitialed
          ? const MyCircularProgress()
          : RefreshIndicator(
              key: _refreshKey,
              onRefresh: _onRefresh,
              child: dataList.isEmpty
                  ? const NoData()
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        if (index == dataList.length) {
                          return showLoadingMore
                              ? Container(
                                  margin: const EdgeInsets.all(10),
                                  child: const Align(
                                    child: CircularProgressIndicator(
                                      color: MyColors.mainColor,
                                    ),
                                  ),
                                )
                              : total <= dataList.length
                                  ? Container(
                                      margin: const EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: const Text("没有更多数据"),
                                    )
                                  : const SizedBox(
                                      height: 44,
                                    );
                        }
                        return listItem(index);
                      },
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: dataList.length + 1,
                      controller: _scrollController,
                    ),
            ),
    );
  }

// Widget __END__

// Network __START__
  Future<void> _onRefresh() async {
    dataList.clear();

    page = 1;

    if (_disposed) {
      return;
    }

    fetchData();
  }

  Future<void> _loadMore() async {
    page++;

    if (_disposed) {
      return;
    }

    fetchData();
  }

// Network __END__

  // 虚方法 __START__

  // 标题
  // 返回为null 则说明此页面不要包含导航栏，仅仅返回列表页面。
  // 返回标题时，那么直接展示完整的页面
  String? navigationTitle();

  // 获取列表的数据。
  Future<void> fetchData();

  // 列表视图
  Widget listItem(int index);

// 虚方法 __END__
}

// 列表视图的样例
// Widget listItem(int index) {
//   if (index >= _dataList.length) {
//     return Container();
//   }
//
//   DispatcherMaintenanceRecordListDataItems data = _dataList[index];
//   MaintenanceType maintenanceType = MaintenanceType.convert(data.maintenanceType ?? 0);
//   String createdTime =
//   formatDate(DateTime.fromMillisecondsSinceEpoch(data.repairTime ?? 0), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
//
//   return NormalCell(
//     title: Text(
//       data.bikeNo ?? "",
//       style: const TextStyle(fontSize: 16, color: MyColors.title),
//     ),
//     middle: Text(
//       maintenanceType.maintenanceTypeName(),
//       style: TextStyle(color: maintenanceType.maintenanceTypeColor(), fontSize: 14),
//     ),
//     trailing: Row(
//       children: <Widget>[
//         Container(
//           margin: const EdgeInsets.only(right: 8),
//           child: Text(
//             createdTime,
//             style: const TextStyle(fontSize: 14, color: MyColors.title),
//           ),
//         ),
//         const Icon(
//           Icons.arrow_forward_ios,
//           size: 15.0,
//         ),
//       ],
//     ),
//     onTap: () {
//       Navigator.of(context).pushNamed(pathOperationDataDetailDispatcherListRepairRecordDetail, arguments: data);
//     },
//   );
// }

// 获取数据的样例
// Future<void> _fetchData() async {
//   if (_disposed) {
//     return;
//   }
//
//   try {
//     // 时间单位需要转为秒
//     var beginTimeSecond = (int.tryParse(widget.beginTime) ?? 0) ~/ 1000;
//     var endTimeSecond = (int.tryParse(widget.endTime) ?? 0) ~/ 1000;
//     DispatcherMaintenanceRecordListEntity entity = await ApiService.apiService
//         .fetchDispatcherMaintenanceRecordList(widget.uid, "$beginTimeSecond", "$endTimeSecond", _page, _pageSize);
//     List<DispatcherMaintenanceRecordListDataItems>? data = entity.data?.items;
//     _total = entity.data?.total ?? 0;
//
//     if (null != data) {
//       _dataList.addAll(data.toList());
//     }
//
//     EasyLoading.dismiss();
//   } on RequestError catch (e) {
//     EasyLoading.showToast(e.message);
//   } finally {
//     setState(() {
//       showLoadingMore = false;
//       _hasInitialed = true;
//     });
//   }
// }
