import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
  void _openPlayer(Map match) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(match: match)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onPlay: _openPlayer),
          LiveScreen(onPlay: _openPlayer),
          MatchesScreen(onPlay: _openPlayer),
          FavScreen(),
          AccountScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        backgroundColor: Color(0xFF1E1E1E),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFFE41E20),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'مباشر'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'المباريات'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'المفضلة'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}

// مباريات اليوم
List<Map> todayMatches = [
  {"t1": "العراق", "t2": "السعودية", "e1": "🇮🇶", "e2": "🇸🇦", "time": "16:30", "hour": 16, "minute": 30, "league": "كأس العرب", "channel": "beIN", "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
  {"t1": "الزوراء", "t2": "القوة الجوية", "e1": "🦁", "e2": "✈️", "time": "18:30", "hour": 18, "minute": 30, "league": "دوري نجوم العراق", "channel": "العراقية", "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
  {"t1": "سالزبورج", "t2": "ميلان", "e1": "🇦🇹", "e2": "🇮🇹", "time": "19:45", "hour": 19, "minute": 45, "league": "الدوري الأوروبي", "channel": "beIN HD1", "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
  {"t1": "كوبس", "t2": "طرابزون", "e1": "🇫🇮", "e2": "🇹🇷", "time": "19:45", "hour": 19, "minute": 45, "league": "دوري المؤتمر", "channel": "beIN HD3", "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
  {"t1": "سيلتا فيجو", "t2": "يوفنتوس", "e1": "🇪🇸", "e2": "🇮🇹", "time": "22:00", "hour": 22, "minute": 0, "league": "الدوري الأوروبي", "channel": "beIN HD1", "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
];

String getMatchStatus(Map m) {
  final now = DateTime.now();
  final matchTime = DateTime(now.year, now.month, now.day, m["hour"], m["minute"]);
  final diff = now.difference(matchTime).inMinutes;
  if (diff >= -15 && diff <= 120) return "مباشر";
  if (diff < -15) return "لم تبدأ";
  return "انتهت";
}

class HomeScreen extends StatelessWidget {
  final Function(Map) onPlay;
  HomeScreen({required this.onPlay});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الخلفية الفخمة - علم العراق
        Positioned.fill(
          child: Image.asset("assets/iraq_flag.jpg", fit: BoxFit.cover, errorBuilder: (c,e,s)=>Container(color: Color(0xFF0F0F0F))),
        ),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.75))),
        SafeArea(
          child: Column(
            children: [
              // واجهة فخمة فوق - الشهادة
              Container(
                height: 110,
                width: double.infinity,
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(image: AssetImage("assets/iraq_flag.jpg"), fit: BoxFit.cover),
                  border: Border.all(color: Color(0xFFFFD700).withOpacity(0.5), width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)],
                ),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.black.withOpacity(0.5)),
                  child: Center(
                    child: Text(
                      "أشهد أن لا إله إلا الله\nوأشهد أن محمد رسول الله\nوأشهد أن علياً ولي الله",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 15, height: 1.5, shadows: [Shadow(color: Colors.black, blurRadius: 8)]),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Row(children: [Icon(Icons.sports_soccer, color: Color(0xFFE41E20)), SizedBox(width: 8), Text("مباريات اليوم - بتوقيت بغداد", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))])),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: todayMatches.length,
                  itemBuilder: (c, i) {
                    var m = todayMatches[i];
                    String status = getMatchStatus(m);
                    bool isLive = status == "مباشر";
                    return GestureDetector(
                      onTap: () => onPlay(m),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(color: Color(0xFF1E1E1E).withOpacity(0.9), borderRadius: BorderRadius.circular(16), border: isLive? Border.all(color: Colors.red.withOpacity(0.6)): Border.all(color: Color(0xFFFFD700).withOpacity(0.2))),
                        child: Column(children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text("${m["league"]} - ${m["channel"]}", style: TextStyle(color: Colors.grey, fontSize: 11)),
                            Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: isLive? Colors.red: status=="لم تبدأ"? Colors.orange: Colors.grey, borderRadius: BorderRadius.circular(10)), child: Text(status, style: TextStyle(fontSize: 11))),
                          ]),
                          SizedBox(height: 12),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Row(children: [Text(m["e1"], style: TextStyle(fontSize: 28)), SizedBox(width: 8), Text(m["t1"], style: TextStyle(fontWeight: FontWeight.bold))]),
                            Text("VS", style: TextStyle(color: Colors.grey)),
                            Row(children: [Text(m["t2"], style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(width: 8), Text(m["e2"], style: TextStyle(fontSize: 28))]),
                          ]),
                          SizedBox(height: 8),
                          Row(children: [Icon(Icons.access_time, size: 14, color: isLive? Colors.red: Colors.grey), SizedBox(width: 4), Text("${m["time"]} - ${isLive? "اضغط للمشاهدة":"$status"}", style: TextStyle(color: isLive? Colors.red: Colors.grey, fontSize: 12))]),
                        ]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PlayerScreen extends StatefulWidget {
  final Map match;
  PlayerScreen({required this.match});
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  bool _noInternet = false;
  String _commentator = "فراس عوض";
  List<String> commentators = ["فراس عوض", "عصام الشوالي", "حفيظ الدراجي"];

  @override
  void initState() {
    super.initState();
    _checkAndPlay();
  }
  Future<void> _checkAndPlay() async {
    var conn = await Connectivity().checkConnectivity();
    if (conn == ConnectivityResult.none) {
      setState(() { _isLoading = false; _noInternet = true; });
      return;
    }
    _controller = VideoPlayerController.network(widget.match["url"]);
    try {
      await _controller!.initialize();
      setState(() => _isLoading = false);
      _controller!.play();
    } catch (e) {
      setState(() { _isLoading = false; _noInternet = false; });
    }
  }
  @override
  void dispose() { _controller?.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Color(0xFF1E1E1E), title: Text("${widget.match["e1"]} ${widget.match["t1"]} vs ${widget.match["t2"]} ${widget.match["e2"]}", style: TextStyle(fontSize: 13))),
      body: Column(children: [
        AspectRatio(aspectRatio: 16/9, child: Container(color: Colors.black, child: _isLoading? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(color: Colors.red), SizedBox(height: 10), Text("جاري التحميل...")])) : _noInternet? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.wifi_off, size: 50, color: Colors.red), Text("انت مطفي النت!"), ElevatedButton(onPressed: (){setState((){_isLoading=true; _noInternet=false;}); _checkAndPlay();}, child: Text("اعادة المحاولة"))])) : _controller==null ||!_controller!.value.isInitialized? Center(child: Text("البث سيبدأ قريبا")) : Stack(children: [VideoPlayer(_controller!), Positioned(bottom: 8, left: 8, child: Container(padding: EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)), child: Text("🎙️ $_commentator", style: TextStyle(fontSize: 11))))]))),
        Padding(padding: EdgeInsets.all(12), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(widget.match["e1"], style: TextStyle(fontSize: 24)), SizedBox(width: 8), Text(widget.match["t1"]), SizedBox(width: 12), Text("${widget.match["time"]}", style: TextStyle(color: Colors.red)), SizedBox(width: 12), Text(widget.match["t2"]), SizedBox(width: 8), Text(widget.match["e2"], style: TextStyle(fontSize: 24))])),
        Divider(color: Color(0xFF1E1E1E)),
        Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Align(alignment: Alignment.centerRight, child: Text("🎙️ اختر المعلق:", style: TextStyle(fontWeight: FontWeight.bold)))),
        SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: commentators.map((name){bool sel=name==_commentator; return GestureDetector(onTap: ()=>setState(()=>_commentator=name), child: Container(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10), decoration: BoxDecoration(color: sel? Colors.red: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(20)), child: Text(name, style: TextStyle(color: sel? Colors.white: Colors.grey, fontSize: 13))));}).toList()),
      ]),
    );
  }
}

class LiveScreen extends StatelessWidget {
  final Function(Map) onPlay;
  LiveScreen({required this.onPlay});
  @override
  Widget build(BuildContext context) {
    var live = todayMatches.where((m)=>getMatchStatus(m)=="مباشر").toList();
    if(live.isEmpty) return Center(child: Text("لا توجد مباريات مباشرة الان\nالقادمة 19:45", textAlign: TextAlign.center));
    return ListView.builder(padding: EdgeInsets.all(12), itemCount: live.length, itemBuilder: (c,i){ var m=live[i]; return ListTile(leading: Text(m["e1"], style: TextStyle(fontSize: 24)), title: Text("${m["t1"]} vs ${m["t2"]}"), subtitle: Text(m["league"]), trailing: ElevatedButton(onPressed: ()=>onPlay(m), child: Text("مشاهدة")));});
  }
}
class MatchesScreen extends StatelessWidget {
  final Function(Map) onPlay;
  MatchesScreen({required this.onPlay});
  @override
  Widget build(BuildContext context) => HomeScreen(onPlay: onPlay);
}
class FavScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(child: Image.asset("assets/iraq_flag.jpg", fit: BoxFit.cover, errorBuilder: (_,__,___)=>Container(color: Colors.black))),
      Positioned.fill(child: Container(color: Colors.black.withOpacity(0.8))),
      Center(child: Text("المفضلة - قريبا", style: TextStyle(fontSize: 18))),
    ]);
  }
}

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}
class _AccountScreenState extends State<AccountScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  bool _isLogged = false;
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account){setState((){_currentUser=account; _isLogged=account!=null;});});
    _googleSignIn.signInSilently();
  }
  Future<void> _handleSignIn() async {
    try {
      var account = await _googleSignIn.signIn();
      if(account!=null){setState((){_currentUser=account; _isLogged=true;}); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("اهلا ${account.displayName} - ${account.email}"), backgroundColor: Colors.green));}
    } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("فشل: $e"))); }
  }
  Future<void> _handleSignOut() async { await _googleSignIn.signOut(); setState((){_currentUser=null; _isLogged=false;}); }
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(child: Image.asset("assets/iraq_flag.jpg", fit: BoxFit.cover, errorBuilder: (_,__,___)=>Container(color: Colors.black))),
      Positioned.fill(child: Container(color: Colors.black.withOpacity(0.85))),
      ListView(padding: EdgeInsets.all(16), children: [
        SizedBox(height: 30),
        CircleAvatar(radius: 45, backgroundColor: Color(0xFF1E1E1E), backgroundImage: _currentUser?.photoUrl!=null? NetworkImage(_currentUser!.photoUrl!): null, child: _currentUser?.photoUrl==null? Icon(_isLogged? Icons.person: Icons.person_outline, size: 45): null),
        SizedBox(height: 12),
        Center(child: Text(_currentUser?.displayName?? "زائر", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFFFD700)))),
        Center(child: Text(_currentUser?.email?? "أشهد أن لا إله إلا الله", style: TextStyle(color: Colors.grey, fontSize: 12))),
        SizedBox(height: 20),
        if(!_isLogged)...[ElevatedButton.icon(icon: Icon(Icons.login), label: Text("تسجيل بـ Google بايميلك الحقيقي"), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, padding: EdgeInsets.all(14)), onPressed: _handleSignIn)] else...[ElevatedButton.icon(icon: Icon(Icons.logout), label: Text("خروج ${_currentUser?.email}"), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: _handleSignOut)],
        Divider(height: 30, color: Color(0xFFFFD700).withOpacity(0.3)),
        ListTile(leading: Icon(Icons.flag, color: Color(0xFFFFD700)), title: Text("لايف عراق - واجهة فخمة"), subtitle: Text("علم العراق مع الشهادة")),
        ListTile(leading: Icon(Icons.info_outline), title: Text("v1.3 - تصميم فخم"), subtitle: Text("البصرة - العراق")),
      ]),
    ]);
  }
}