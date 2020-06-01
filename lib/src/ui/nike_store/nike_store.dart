import 'dart:math' as math;

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const Color mainBlack = Color(0xFF383838);
const Color lightGrey = Color(0xFF707070);
const Color lighterGrey = Color(0xFFA0A0A0);
const Color white = Color(0xFFFFFFFF);

double halfOfScreenSize(BuildContext context) =>
    MediaQuery.of(context).size.height / 2;

class PageOffsetNotifier with ChangeNotifier {
  double _offset = 0;
  double _page = 0;

  PageOffsetNotifier(PageController pageController) {
    pageController.addListener(() {
      _offset = pageController.offset;
      _page = pageController.page;
      notifyListeners();
    });
  }

  double get offset => _offset;

  double get page => _page;
}

class MapAnimationNotifier with ChangeNotifier {
  final AnimationController _animationController;

  MapAnimationNotifier(this._animationController) {
    _animationController.addListener(_onAnimationControllerChanged);
  }

  double get value => _animationController.value;

  void forward() => _animationController.forward();

  void _onAnimationControllerChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _animationController.removeListener(_onAnimationControllerChanged);
    super.dispose();
  }
}

class NikeStore extends StatefulWidget {
  @override
  _NikeStoreState createState() => _NikeStoreState();
}

class _NikeStoreState extends State<NikeStore> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  AnimationController _animationController;
  AnimationController _mapAnimationController;

  double get maxHeight => halfOfScreenSize(context) + 32 + 24;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _mapAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PageOffsetNotifier(_pageController),
      child: ListenableProvider.value(
        value: _animationController,
        child: ChangeNotifierProvider(
          create: (_) => MapAnimationNotifier(_mapAnimationController),
          child: Scaffold(
            backgroundColor: Color(0xFF2e2e2e),
            body: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(child: DescriptionBox(), bottom: 0,),
                SafeArea(
                  child: GestureDetector(
                    onVerticalDragUpdate: _handleDragUpdate,
                    onVerticalDragEnd: _handleDragEnd,
                    child: Stack(
                      children: [
                        PageView(
                          physics: ClampingScrollPhysics(),
                          controller: _pageController,
                          children: [
                            NikePage(
                              asset: 'assets/images/n1.png',
                            ),
                            NikePage(
                              value: 180,
                              asset: 'assets/images/n3.png',
                            )
                          ],
                        ),
                        Container(
                          height: 81,
                          child: Container(
                            margin: const EdgeInsets.only(top: 24),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Image.asset('assets/images/logo.png'),
                                Spacer(),
                                Badge(
                                  badgeContent: Text(
                                    '2',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: Colors.white,
                                  ),
                                  position: BadgePosition(left: 10, bottom: 10),
                                )
                              ],
                            ),
                          ),
                        ),
                        PageIndicator(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _animationController.value -= details.primaryDelta / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_animationController.isAnimating ||
        _animationController.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0.0)
      _animationController.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _animationController.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _animationController.fling(
          velocity: _animationController.value < 0.5 ? -2.0 : 2.0);
  }
}

class CenterCircle extends StatelessWidget {
  final int value;
  const CenterCircle({Key key, this.value = 1});

  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Transform.translate(
          offset: Offset(value - 0.5 * notifier.offset, 0),
          child: child,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF2e2e2e),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [Color(0xFF1c1c1c), Color(0xFF383838)],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0XF1c1c1c),
                offset: Offset(5.0, 5.0),
                blurRadius: (10.0),
              ),
              BoxShadow(
                color: Color(0XF404040),
                offset: Offset(-5.0, -5.0),
                blurRadius: (10.0),
              )
            ]),
        child: Padding(
          padding: EdgeInsets.all(1.5),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  colors: [Color(0XFF303030), Color(0xFF1a1a1a)],
                )),
          ),
        ),
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  final String imgUrl;

  const ImageWidget({Key key, this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Image.asset(imgUrl)));
  }
}

class NikePage extends StatelessWidget {
  final String asset;
  final int value;

  const NikePage({Key key, this.asset, this.value = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Transform.scale(
          alignment: Alignment(0.6, 0),
          scale: 1 - 0.1 * animation.value,
          child: Opacity(
            opacity: 1 - 0.9 * animation.value,
            child: child,
          ),
        );
      },
      child: Stack(
        children: [
          CenterCircle(
            value: value,
          ),
          ImageWidget(
            imgUrl: asset,
          ),
          // DescriptionBox()
        ],
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, _) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: notifier.page.round() == 0 ? white : lightGrey,
                  ),
                  height: 6,
                  width: 6,
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: notifier.page.round() != 0 ? white : lightGrey,
                  ),
                  height: 6,
                  width: 6,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DescriptionBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Opacity(
          opacity: animation.value,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notifier.page == 0 ? 'Nike air vapor-max 360':'Nike React Infinity Run Flyknit',
                    style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                        fontSize: 21),
                  ),
                  SizedBox(height: 16,),
                  Text(
                    notifier.page == 0 ? '5,659 EGP':'4,319 EGP',
                    style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                        fontSize: 21),
                  ),
                  SizedBox(height: 16,),
                  Text(notifier.page == 0 ? 'Featuring a full-length foam midsole and VaporMax Air unit, the Nike Air VaporMax 360 gives you remarkable underfoot comfort with bold 2000s style inspired by the Air Max 360.\nFull-length foam midsole offers remarkable underfoot cushioning. VaporMax Air unit provides a lightweight, responsive ride.\nSoft, plush collar contours to the foot for a comfortable fit. Half-bootie tongue construction is snug around the foot.\nLightweight TPU frame wraps the heel and Air unit in a nod to the original Air Max 360. Speeding lacing loops and welded synthetic skins on the upper are also inspired by the Air Max 360.'
                      : 'The Nike React Infinity Run Flyknit is designed to keep you on the run. More foam and improved upper details provide a secure and cushioned feel. Lace up and feel the potential as you hit the road.\nAn all-new version of Flyknit is stronger and more durable than previous versions. Lightweight and flexible, it features 3 distinct layers to help keep your foot secure.\nHigher foam stack heights provide a softer feel. A wider shape provides a more stable ride, helping release energy with every step.\nThe shape of the Nike React foam midsole provides support for the 3 phases of a runner\'s stride. It helps create flexibility at toe-off, a smooth ride at mid-stance and cushioning at contact.',
                    style: TextStyle(color: Colors.white70),),
                  SizedBox(height: 16,),
                  FlatButton(onPressed: (){}, child: Text('Add to cart', style: TextStyle(fontWeight: FontWeight.bold,
                      color: Colors.white),),
                    color: Colors.red,)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
