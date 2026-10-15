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

  void _openPlayer(String url) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(url: url)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onPlay: _openPlayer),
          LiveScreen(),
          MatchesScreen(),
          FavScreen(),
          AccountScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
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
}

// ==================== الرئيسية ====================
class HomeScreen extends StatefulWidget {
  final Function(String) onPlay;
  HomeScreen({required this.onPlay});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loadingMore = false;
  List matches = [
    {"t1": "العراق", "t2": "السعودية", "c1": "IQ", "c2": "SA", "time": "21:00", "league": "كأس الخليج العربي", "live": true, "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
    {"t1": "ريال مدريد", "t2": "برشلونة", "c1": "RM", "c2": "BAR", "time": "23:00", "league": "الدوري الإسباني", "live": true, "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
    {"t1": "الزوراء", "t2": "القوة الجوية", "c1": "AZ", "c2": "QJ", "time": "18:30", "league": "دوري نجوم العراق", "live": true, "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
    {"t1": "الشرطة", "t2": "الطلبة", "c1": "SH", "c2": "TL", "time": "19:00", "league": "دوري نجوم العراق", "live": false, "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
    {"t1": "مان سيتي", "t2": "ارسنال", "c1": "MC", "c2": "ARS", "time": "18:30", "league": "البريميرليغ", "live": false, "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
    {"t1": "ليفربول", "t2": "مان يونايتد", "c1": "LIV", "c2": "MUN", "time": "19:45", "league": "البريميرليغ", "live": false, "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
    {"t1": "الهلال", "t2": "النصر", "c1": "HIL", "c2": "NAS", "time": "21:00", "league": "دوري روشن", "live": false, "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // علم العراق
          Container(height: 44, child: Column(children: [
            Expanded(child: Container(color: Color(0xFFE41E20))),
            Expanded(child: Container(color: Colors.white, child: Center(child: Text("الله أكبر", style: TextStyle(color: Color(0xFF00A651), fontWeight: FontWeight.bold, fontSize: 16))))),
            Expanded(child: Container(color: Colors.black)),
          ])),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("لايف عراق", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                Text("LIVE IRAQ - كل المباريات", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ]),
              Row(children: [Icon(Icons.search, color: Colors.grey), SizedBox(width: 12), Icon(Icons.notifications_none)]),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: matches.length + 1,
              itemBuilder: (c, i) {
                if (i == matches.length) {
                  return Center(child: Padding(padding: EdgeInsets.all(16), child: _loadingMore? CircularProgressIndicator(color: Colors.red) : ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1E1E1E)), onPressed: _loadMore, child: Text("تحميل المزيد"))));
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
                        Text(m["league"], style: TextStyle(color: Colors.grey, fontSize: 11)),
                        if (m["live"]) Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)), child: Text("● مباشر", style: TextStyle(fontSize: 11))),
                      ]),
                      SizedBox(height: 10),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Row(children: [CircleAvatar(radius: 18, backgroundColor: Colors.blue, child: Text(m["c1"], style: TextStyle(fontSize: 12))), SizedBox(width: 6), Text(m["t1"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]),
                        Text("VS", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Row(children: [Text(m["t2"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), SizedBox(width: 6), CircleAvatar(radius: 18, backgroundColor: Colors.green, child: Text(m["c2"], style: TextStyle(fontSize: 12)))]),
                      ]),
                      SizedBox(height: 8),
                      Row(children: [Icon(Icons.access_time, size: 14, color: Colors.grey), SizedBox(width: 4), Text(m["time"] + " - اضغط للمشاهدة", style: TextStyle(color: Colors.grey, fontSize: 11))]),
                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _loadMore() async {
    setState(() => _loadingMore = true);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      matches.addAll([
        {"t1": "بايرن ميونخ", "t2": "دورتموند", "c1": "BAY", "c2": "DOR", "time": "20:30", "league": "البوندسليغا", "live": false, "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
        {"t1": "الاهلي", "t2": "الزمالك", "c1": "AHL", "c2": "ZAM", "time": "20:00", "league": "الدوري المصري", "live": false, "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
      ]);
      _loadingMore = false;
    });
  }
}

// ==================== مشغل الفيديو مع معلقين ====================
class PlayerScreen extends StatefulWidget {
  final String url;
  PlayerScreen({required this.url});
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _controller;
  String _quality = "تلقائي";
  String _commentator = "فراس عوض";
  List<String> qualities = ["تلقائي", "1080p", "720p", "480p", "360p", "144p"];
  List<String> commentators = ["فراس عوض", "عصام الشوالي", "حفيظ الدراجي"];
  Map<String, String> commentatorUrls = {
    "فراس عوض": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
    "عصام الشوالي": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
    "حفيظ الدراجي": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
  };
  bool _isBuffering = true;
  String _netStatus = "يقيس سرعة النت...";

  @override
  void initState() {
    super.initState();
    _initPlayer(widget.url);
  }

  void _initPlayer(String url) {
    _controller = VideoPlayerController.network(url)
     ..initialize().then((_) {
        setState(() {
          _isBuffering = false;
          _netStatus = "النت ممتاز - HD";
        });
        _controller.play();
      });
    _controller.addListener(() {
      if (_controller.value.isBuffering!= _isBuffering) {
        setState(() => _isBuffering = _controller.value.isBuffering);
        if (_controller.value.isBuffering) {
          setState(() => _netStatus = "النت ضعيف - جاري تقليل الجودة...");
        }
      }
    });
  }

  void _changeCommentator(String name) async {
    setState(() {
      _commentator = name;
      _isBuffering = true;
    });
    await _controller.pause();
    await _controller.dispose();
    _initPlayer(commentatorUrls[name]!);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🎙️ الان: $name"), backgroundColor: Color(0xFFE41E20), duration: Duration(seconds: 1)));
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
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E1E),
        title: Text("$_commentator", style: TextStyle(fontSize: 14)),
        actions: [
          PopupMenuButton<String>(
            onSelected: (q) => setState(() => _quality = q),
            itemBuilder: (c) => qualities.map((q) => PopupMenuItem(value: q, child: Text(q))).toList(),
            icon: Icon(Icons.high_quality),
          ),
        ],
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: _controller.value.isInitialized? _controller.value.aspectRatio : 16 / 9,
            child: Stack(
              children: [
                _controller.value.isInitialized? VideoPlayer(_controller) : Center(child: CircularProgressIndicator(color: Colors.red)),
                if (_isBuffering) Center(child: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(color: Colors.red), SizedBox(height: 8), Text(_netStatus, style: TextStyle(fontSize: 12))])),
                Positioned(bottom: 8, left: 8, child: Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)), child: Text("$_quality | 🎙️ $_commentator | $_netStatus", style: TextStyle(fontSize: 10)))),
              ],
            ),
          ),
          SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(icon: Icon(Icons.replay_10), onPressed: () => _controller.seekTo(_controller.value.position - Duration(seconds: 10))),
            IconButton(icon: Icon(_controller.value.isPlaying? Icons.pause_circle_filled : Icons.play_circle_filled, size: 55, color: Colors.red), onPressed: () => setState(() => _controller.value.isPlaying? _controller.pause() : _controller.play())),
            IconButton(icon: Icon(Icons.forward_10), onPressed: () => _controller.seekTo(_controller.value.position + Duration(seconds: 10))),
          ]),
          Divider(color: Color(0xFF1E1E1E)),
          Padding(padding: EdgeInsets.all(12), child: Row(children: [Icon(Icons.mic, color: Colors.red, size: 20), SizedBox(width: 6), Text("اختر المعلق:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))])),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: commentators.length,
              itemBuilder: (c, i) {
                var name = commentators[i];
                bool selected = name == _commentator;
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(color: selected? Color(0xFFE41E20).withOpacity(0.25) : Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: selected? Colors.red : Colors.transparent, width: 1.5)),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: selected? Colors.red : Colors.grey[800], child: Text(name[0], style: TextStyle(color: Colors.white))),
                    title: Text(name, style: TextStyle(color: selected? Colors.red : Colors.white, fontWeight: selected? FontWeight.bold : FontWeight.normal, fontSize: 16)),
                    subtitle: Text(selected? "يعمل الان - $_netStatus" : "اضغط للاستماع", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    trailing: selected? Icon(Icons.check_circle, color: Colors.red) : Icon(Icons.play_circle_outline, color: Colors.grey),
                    onTap: () => _changeCommentator(name),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== باقي الشاشات ====================
class LiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.live_tv, size: 60, color: Colors.red), SizedBox(height: 10), Text("قنوات البث المباشر", style: TextStyle(fontSize: 18)), Text("beIN - SSC - الكاس", style: TextStyle(color: Colors.grey))]));
}

class MatchesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text("جدول جميع المباريات - تحديث يومي", style: TextStyle(fontSize: 18)));
}

class FavScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text("المفضلة - فرقك المفضلة", style: TextStyle(fontSize: 18)));
}

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.all(16), children: [
      SizedBox(height: 30),
      CircleAvatar(radius: 40, backgroundColor: Color(0xFF1E1E1E), child: Icon(Icons.person, size: 40, color: Colors.grey)),
      SizedBox(height: 12),
      Center(child: Text("حسابي", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
      Center(child: Text("سجل دخول لحفظ المفضلة", style: TextStyle(color: Colors.grey, fontSize: 12))),
      SizedBox(height: 30),
      ListTile(leading: Icon(Icons.settings), title: Text("الإعدادات"), subtitle: Text("الجودة، اللغة، التوفير"), trailing: Icon(Icons.arrow_forward_ios, size: 16)),
      ListTile(leading: Icon(Icons.sd_card), title: Text("توفير البيانات"), subtitle: Text("تقليل الجودة تلقائيا اذا النت ضعيف"), trailing: Switch(value: true, onChanged: (v) {}, activeColor: Colors.red)),
      ListTile(leading: Icon(Icons.link), title: Text("ربط الحساب"), subtitle: Text("Google / Facebook"), trailing: Icon(Icons.arrow_forward_ios, size: 16)),
      ListTile(leading: Icon(Icons.info_outline), title: Text("لايف عراق v1.0"), subtitle: Text("صنع في العراق - البصرة")),
    ]);
  }
}