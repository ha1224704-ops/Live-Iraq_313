import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(LiveIraqApp());

class LiveIraqApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Color(0xFF0F0F0F)),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [HomeScreen(onPlay: (url) => _openPlayer(url)), LiveScreen(), MatchesScreen(), FavScreen(), AccountScreen()],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFFE41E20),
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: 'مباشر'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'المباريات'),
            BottomNavigationBarItem(icon: Icon(Icons.star_border), label: 'المفضلة'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'حسابي'),
          ],
        ),
      ),
    );
  }

  void _openPlayer(String url) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(url: url)));
  }
}

// الرئيسية مع تحميل تدريجي
class HomeScreen extends StatefulWidget {
  final Function(String) onPlay;
  HomeScreen({required this.onPlay});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loadingMore = false;
  List matches = [
    {"t1": "العراق", "t2": "السعودية", "c1": "IQ", "c2": "SA", "time": "21:00", "league": "كأس الخليج", "live": true, "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
    {"t1": "ريال مدريد", "t2": "برشلونة", "c1": "RM", "c2": "BAR", "time": "23:00", "league": "الليغا", "live": true, "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
    {"t1": "الزوراء", "t2": "القوة الجوية", "c1": "AZ", "c2": "QJ", "time": "18:30", "league": "دوري العراق", "live": true, "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        Container(height: 44, child: Column(children: [
          Expanded(child: Container(color: Color(0xFFE41E20))),
          Expanded(child: Container(color: Colors.white, child: Center(child: Text("الله أكبر", style: TextStyle(color: Color(0xFF00A651), fontWeight: FontWeight.bold))))),
          Expanded(child: Container(color: Colors.black)),
        ])),
        Padding(padding: EdgeInsets.all(16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("لايف عراق", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          Row(children: [Icon(Icons.search, color: Colors.grey), SizedBox(width: 10), Icon(Icons.notifications_none)]),
        ])),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: matches.length + 1,
            itemBuilder: (c, i) {
              if (i == matches.length) {
                return Center(child: Padding(padding: EdgeInsets.all(16), child: _loadingMore? CircularProgressIndicator() : ElevatedButton(onPressed: _loadMore, child: Text("تحميل المزيد من المباريات"))));
              }
              var m = matches[i];
              return GestureDetector(
                onTap: () => widget.onPlay(m["url"]),
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16)),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(m["league"], style: TextStyle(color: Colors.grey, fontSize: 12)),
                      if (m["live"]) Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)), child: Text("● مباشر", style: TextStyle(fontSize: 11))),
                    ]),
                    SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(children: [CircleAvatar(radius: 18, child: Text(m["c1"])), SizedBox(width: 6), Text(m["t1"], style: TextStyle(fontWeight: FontWeight.bold))]),
                      Text("VS", style: TextStyle(color: Colors.amber)),
                      Row(children: [Text(m["t2"], style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(width: 6), CircleAvatar(radius: 18, child: Text(m["c2"]))]),
                    ]),
                    SizedBox(height: 8),
                    Row(children: [Icon(Icons.access_time, size: 14, color: Colors.grey), SizedBox(width: 4), Text(m["time"], style: TextStyle(color: Colors.grey, fontSize: 12))]),
                  ]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }

  void _loadMore() async {
    setState(() => _loadingMore = true);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      matches.addAll([
        {"t1": "مان سيتي", "t2": "ارسنال", "c1": "MC", "c2": "ARS", "time": "18:30", "league": "البريميرليغ", "live": false, "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
        {"t1": "الهلال", "t2": "النصر", "c1": "HIL", "c2": "NAS", "time": "21:00", "league": "دوري روشن", "live": false, "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
      ]);
      _loadingMore = false;
    });
  }
}

// شاشة المشغل مع دقات
class PlayerScreen extends StatefulWidget {
  final String url;
  PlayerScreen({required this.url});
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _controller;
  String _quality = "تلقائي";
  List<String> qualities = ["تلقائي", "1080p", "720p", "480p", "360p", "144p"];
  bool _isBuffering = true;
  String _netSpeed = "يقيس النت...";

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)..initialize().then((_) {
      setState(() => _isBuffering = false);
      _controller.play();
      _checkInternet();
    });
    _controller.addListener(() {
      if (_controller.value.isBuffering!= _isBuffering) setState(() => _isBuffering = _controller.value.isBuffering);
    });
  }

  void _checkInternet() async {
    // فحص سرعة النت بسيط
    await Future.delayed(Duration(seconds: 2));
    // اذا يبفر هواي معناها النت ضعيف
    if (_controller.value.isBuffering) {
      setState(() {
        _netSpeed = "النت ضعيف - تم تقليل الجودة لـ 360p";
        _quality = "360p";
      });
    } else {
      setState(() => _netSpeed = "النت ممتاز - جودة تلقائية HD");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Color(0xFF1E1E1E), title: Text("لايف عراق - بث مباشر"), actions: [
        PopupMenuButton<String>(
          onSelected: (q) => setState(() => _quality = q),
          itemBuilder: (c) => qualities.map((q) => PopupMenuItem(value: q, child: Text(q))).toList(),
          icon: Icon(Icons.high_quality),
        ),
      ]),
      body: Column(children: [
        AspectRatio(
          aspectRatio: _controller.value.isInitialized? _controller.value.aspectRatio : 16 / 9,
          child: Stack(children: [
            _controller.value.isInitialized? VideoPlayer(_controller) : Center(child: CircularProgressIndicator(color: Colors.red)),
            if (_isBuffering) Center(child: CircularProgressIndicator(color: Colors.red)),
            Positioned(bottom: 10, left: 10, child: Container(padding: EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)), child: Text("$_quality | $_netSpeed", style: TextStyle(fontSize: 11)))),
          ]),
        ),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(icon: Icon(Icons.replay_10), onPressed: () => _controller.seekTo(_controller.value.position - Duration(seconds: 10))),
          IconButton(icon: Icon(_controller.value.isPlaying? Icons.pause_circle_filled : Icons.play_circle_filled, size: 50, color: Colors.red), onPressed: () => setState(() => _controller.value.isPlaying? _controller.pause() : _controller.play())),
          IconButton(icon: Icon(Icons.forward_10), onPressed: () => _controller.seekTo(_controller.value.position + Duration(seconds: 10))),
        ]),
        Padding(padding: EdgeInsets.all(12), child: Text("اذا النت ضعيف دوس على ايقونة الجودة فوك واختار 360p او 144p حتى ما يقطع البث", style: TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center)),
      ]),
    );
  }
}

class LiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text("قنوات البث المباشر قريبا", style: TextStyle(fontSize: 18)));
}
class MatchesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text("جدول جميع المباريات - يتم التحميل تدريجيا", style: TextStyle(fontSize: 18)));
}
class FavScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text("المفضلة", style: TextStyle(fontSize: 18)));
}
class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.all(16), children: [
      SizedBox(height: 30),
      CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
      SizedBox(height: 10),
      Center(child: Text("حسابي - ربط Google", style: TextStyle(fontWeight: FontWeight.bold))),
      ListTile(leading: Icon(Icons.settings), title: Text("الإعدادات"), subtitle: Text("جودة الفيديو، اللغة، الاشعارات")),
      ListTile(leading: Icon(Icons.sd_card), title: Text("توفير البيانات"), trailing: Switch(value: false, onChanged: (v) {})),
      ListTile(leading: Icon(Icons.link), title: Text("ربط الحساب"), subtitle: Text("Google / Facebook لحفظ المفضلة")),
      ListTile(leading: Icon(Icons.info), title: Text("لايف عراق v1.0 - صنع في العراق")),
    ]);
  }
}