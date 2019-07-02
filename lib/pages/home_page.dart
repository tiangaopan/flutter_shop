import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../routers/application.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  String homePageContent = '正在获取数据';
  int page = 1;
  List<Map> hotGoodsList = [];
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    super.initState();
//    _getHotGoods();
  }

  @override
  Widget build(BuildContext context) {
    var formData = {'lon': '115.02932', 'lat': '35.76189'};

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('百姓生活+'),
      ),
      body: FutureBuilder(
          future: request("homePageContent", formData: formData),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());

              List<Map> swiper = (data['data']['slides'] as List).cast();

              List<Map> navgatorList =
                  (data['data']['category'] as List).cast();

              String adPicture =
                  data['data']['advertesPicture']['PICTURE_ADDRESS'].toString();

              String leaderImage =
                  data['data']['shopInfo']['leaderImage'].toString();
              String leaderPhone =
                  data['data']['shopInfo']['leaderPhone'].toString();

              List<Map> recommendList =
                  (data['data']['recommend'] as List).cast();

              String floor1Title =
                  data['data']['floor1Pic']['PICTURE_ADDRESS'].toString();
              String floor2Title =
                  data['data']['floor2Pic']['PICTURE_ADDRESS'].toString();
              String floor3Title =
                  data['data']['floor3Pic']['PICTURE_ADDRESS'].toString();

              List<Map> floor1 = (data['data']['floor1'] as List).cast();
              List<Map> floor2 = (data['data']['floor2'] as List).cast();
              List<Map> floor3 = (data['data']['floor3'] as List).cast();

              return EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  bgColor: Colors.white,
                  textColor: Colors.pink,
                  moreInfoColor: Colors.pink,
                  showMore: true,
                  noMoreText: "",
                  moreInfo: '加载中...',
                  loadReadyText: '上拉加载...',
                ),
                child: ListView(
                  children: <Widget>[
                    SwiperDiy(swiperDataList: swiper),
                    TopNavigator(navigatorList: navgatorList),
                    AdBanner(
                      adPicture: adPicture,
                    ),
                    LeaderPhone(
                      leaderImage: leaderImage,
                      leaderPhone: leaderPhone,
                    ),
                    Recommend(recommendList: recommendList),
                    FloorTitle(picture_address: floor1Title),
                    FloorContent(
                      floorGoodsList: floor1,
                    ),
                    FloorTitle(picture_address: floor2Title),
                    FloorContent(
                      floorGoodsList: floor2,
                    ),
                    FloorTitle(picture_address: floor3Title),
                    FloorContent(
                      floorGoodsList: floor3,
                    ),
                    _hotGoods()
                  ],
                ),
                loadMore: () async {
                  print('开始加载更多.....');
                  var formPage = {'page': page};
                  await request('homePageBelowContent', formData: formPage)
                      .then((value) {
                    var data = json.decode(value.toString());
                    //新的列表
                    List<Map> newGoodsList = (data['data'] as List).cast();
                    setState(() {
                      hotGoodsList.addAll(newGoodsList);
                      page++;
                    });
                  });
                },
              );
            } else {
              return Center(
                child: Text('加载中.....'),
              );
            }
          }),
    );
  }

  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10),
    alignment: Alignment.center,
    color: Colors.transparent,
    child: Text('火爆专区'),
  );

  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((value) {
        return InkWell(
          onTap: () {
            Application.router
                .navigateTo(context, "/detail?id=${value['goodsId']}");
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 2 - 10,
            color: Colors.white,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 3),
            child: Column(
              children: <Widget>[
                Image.network(
                  value['image'],
                  width: MediaQuery.of(context).size.width / 3 - 5,
                ),
                Text(
                  value['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.pink,
                      fontSize: ScreenUtil.instance.setSp(26)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('¥${value['mallPrice']}'),
                    Text('   '),
                    Text(
                      '¥${value['price']}',
                      style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();
      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('');
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[hotTitle, _wrapList()],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

//首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;

  const SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(403),
      width: ScreenUtil.screenWidth,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Application.router.navigateTo(context, "/detail?id=${swiperDataList[index]['goodsId']}");
            },
            child: Image.network(
              "${swiperDataList[index]['image']}",
              fit: BoxFit.cover,
            ),
          );
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(), //轮播点
        autoplay: true,
      ),
    );
  }
}

//顶部navigator
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  const TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {

      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
            child: Text(item['mallCategoryName']),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.navigatorList.length > 10) {
      navigatorList.removeRange(10, this.navigatorList.length);
    }

    return Container(
      height: ScreenUtil.instance.setHeight(340),
      padding: const EdgeInsets.all(3),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

//广告位
class AdBanner extends StatelessWidget {
  final String adPicture;

  const AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

//店长电话模块
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;

  const LeaderPhone({Key key, this.leaderImage, this.leaderPhone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Image.network(leaderImage),
        onTap: _launchUrl,
      ),
    );
  }

  void _launchUrl() async {
    String url = 'tel:' + leaderPhone;
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      throw 'URL不能进行访问';
//    }
  }
}

//商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend({Key key, this.recommendList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.instance.setHeight(480),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _titlewidget(),
          _recommendList(),
        ],
      ),
    );
  }

  //标题
  Widget _titlewidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  //商品单独项方法
  Widget _item(context, index) {
    return InkWell(
      onTap: (){
        Application.router.navigateTo(context, "/detail?id=${recommendList[index]['goodsId']}");
      },
      child: Container(
        height: ScreenUtil.instance.setHeight(460),
        width: ScreenUtil.instance.setWidth(350),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(left: BorderSide(color: Colors.black12, width: 0.5))),
        child: Column(
          children: <Widget>[
            Image.network("${recommendList[index]['image']}"),
            Text('¥${recommendList[index]['mallPrice']}'),
            Text(
              '¥${recommendList[index]['price']}',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  //横向列表方法
  Widget _recommendList() {
    return Container(
      height: ScreenUtil.instance.setHeight(460),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recommendList.length,
          itemBuilder: (BuildContext context, int index) {
            return _item(context, index);
          }),
    );
  }
}

//楼层标题
class FloorTitle extends StatelessWidget {
  final String picture_address;

  const FloorTitle({Key key, this.picture_address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Image.network(picture_address),
    );
  }
}

//楼层商品
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  const FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(context),
          _otherGoods(context),
        ],
      ),
    );
  }

  Widget _firstRow(context) {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0], context),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1], context),
            _goodsItem(floorGoodsList[2], context),
          ],
        )
      ],
    );
  }

  Widget _otherGoods(context) {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3], context),
        _goodsItem(floorGoodsList[4], context),
      ],
    );
  }

  Widget _goodsItem(Map goods, context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: InkWell(
        onTap: () {
          Application.router.navigateTo(context, "/detail?id=${goods['goodsId']}");
        },
        child: Image.network(goods['image']),
      ),
    );
  }
}
