import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() => runApp(LiveIraqApp());

class LiveIraqApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Color(0xFF0F0F0F)), home: MainScreen());
  }
}

class MainScreen extends StatefulWidget { @override _MainScreenState createState() => _MainScreenState(); }
class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  void _openPlayer(Map match) { Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(match: match))); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: [HomeScreen(onPlay: _openPlayer), LiveScreen(onPlay: _openPlayer), MatchesScreen(onPlay: _openPlayer), FavScreen(), AccountScreen()]),
      bottomNavigationBar: BottomNavigationBar(currentIndex: _index, onTap: (i)=>setState(()=>_index=i), backgroundColor: Color(0xFF1E1E1E), type: BottomNavigationBarType.fixed, selectedItemColor: Color(0xFFE41E20), unselectedItemColor: Colors.grey, items: [BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'), BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'مباشر'), BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'المباريات'), BottomNavigationBarItem(icon: Icon(Icons.star), label: 'المفضلة'), BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي')]),
    );
  }
}

List<Map> todayMatches = [
  {"t1": "العراق", "t2": "السعودية", "e1": "🇮🇶", "e2": "🇸🇦", "time": "16:30", "hour": 16, "minute": 30, "league": "كأس العرب", "channel": "beIN", "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
  {"t1": "الزوراء", "t2": "القوة الجوية", "e1": "🦁", "e2": "✈️", "time": "18:30", "hour": 18, "minute": 30, "league": "دوري نجوم العراق", "channel": "العراقية", "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
  {"t1": "سالزبورج", "t2": "ميلان", "e1": "🇦🇹", "e2": "🇮🇹", "time": "19:45", "hour": 19, "minute": 45, "league": "الدوري الأوروبي", "channel": "beIN HD1", "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
  {"t1": "سيلتا فيجو", "t2": "يوفنتوس", "e1": "🇪🇸", "e2": "🇮🇹", "time": "22:00", "hour": 22, "minute": 0, "league": "الدوري الأوروبي", "channel": "beIN HD1", "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"},
];
String getMatchStatus(Map m) { final now=DateTime.now(); final mt=DateTime(now.year,now.month,now.day,m["hour"],m["minute"]); final d=now.difference(mt).inMinutes; if(d>=-15&&d<=120) return "مباشر"; if(d<-15) return "لم تبدأ"; return "انتهت"; }

// واجهة فخمة بعلم العراق بدون صور
class FancyIraqHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      width: double.infinity,
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 12)], border: Border.all(color: Color(0xFFFFD700).withOpacity(0.6), width: 1.2)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(children: [
          Column(children: [Expanded(child: Container(color: Color(0xFFE41E20))), Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Colors.black))]),
          Container(color: Colors.black.withOpacity(0.25)),
          Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("أشهد أن لا إله إلا الله", style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 16, shadows: [Shadow(color: Colors.black, blurRadius: 10)])),
            SizedBox(height: 2),
            Text("وأشهد أن محمد رسول الله", style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 15, shadows: [Shadow(color: Colors.black, blurRadius: 10)])),
            SizedBox(height: 2),
            Text("وأشهد أن علياً ولي الله", style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 15, shadows: [Shadow(color: Colors.black, blurRadius: 10)])),
            SizedBox(height: 6),
            Container(height: 2, width: 80, color: Color(0xFFFFD700).withOpacity(0.7)),
            SizedBox(height: 4),
            Text("لايف عراق - البصرة", style: TextStyle(color: Colors.white70, fontSize: 10)),
          ])),
        ]),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Function(Map) onPlay; HomeScreen({required this.onPlay});
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(children: [
      FancyIraqHeader(),
      Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Row(children: [Icon(Icons.sports_soccer, color: Color(0xFFE41E20)), SizedBox(width: 8), Text("مباريات اليوم", style: TextStyle(fontWeight: FontWeight.bold))])),
      SizedBox(height: 8),
      Expanded(child: ListView.builder(padding: EdgeInsets.all(12), itemCount: todayMatches.length, itemBuilder: (c,i){var m=todayMatches[i]; String s=getMatchStatus(m); bool live=s=="مباشر"; return GestureDetector(onTap: ()=>onPlay(m), child: Container(margin: EdgeInsets.only(bottom: 12), padding: EdgeInsets.all(14), decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16), border: live? Border.all(color: Colors.red.withOpacity(0.5)): Border.all(color: Color(0xFFFFD700).withOpacity(0.15))), child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("${m["league"]} - ${m["channel"]}", style: TextStyle(color: Colors.grey, fontSize: 11)), Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: live? Colors.red: s=="لم تبدأ"? Colors.orange: Colors.grey, borderRadius: BorderRadius.circular(10)), child: Text(s, style: TextStyle(fontSize: 11)))]), SizedBox(height: 12), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Text(m["e1"], style: TextStyle(fontSize: 28)), SizedBox(width: 8), Text(m["t1"], style: TextStyle(fontWeight: FontWeight.bold))]), Text("VS", style: TextStyle(color: Colors.grey)), Row(children: [Text(m["t2"], style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(width: 8), Text(m["e2"], style: TextStyle(fontSize: 28))])]), SizedBox(height: 8), Row(children: [Icon(Icons.access_time, size: 14, color: live? Colors.red: Colors.grey), SizedBox(width: 4), Text("${m["time"]} بتوقيت بغداد - ${live? "اضغط للمشاهدة":"$s"}", style: TextStyle(color: live? Colors.red: Colors.grey, fontSize: 12))])])));}))
    ]));
  }
}

class PlayerScreen extends StatefulWidget { final Map match; PlayerScreen({required this.match}); @override _PlayerScreenState createState() => _PlayerScreenState(); }
class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? _c; bool _load=true; bool _noNet=false; String _com="فراس عوض"; List<String> comms=["فراس عوض","عصام الشوالي","حفيظ الدراجي"];
  @override void initState() { super.initState(); _check(); }
  Future<void> _check() async { var conn=await Connectivity().checkConnectivity(); if(conn==ConnectivityResult.none){setState((){_load=false; _noNet=true;}); return;} _c=VideoPlayerController.network(widget.match["url"]); try{await _c!.initialize(); setState(()=>_load=false); _c!.play();} catch(e){setState(()=>_load=false);} }
  @override void dispose() { _c?.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) { return Scaffold(backgroundColor: Colors.black, appBar: AppBar(backgroundColor: Color(0xFF1E1E1E), title: Text("${widget.match["e1"]} ${widget.match["t1"]} vs ${widget.match["t2"]} ${widget.match["e2"]}", style: TextStyle(fontSize: 13))), body: Column(children: [AspectRatio(aspectRatio: 16/9, child: Container(color: Colors.black, child: _load? Center(child: CircularProgressIndicator(color: Colors.red)): _noNet? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.wifi_off, size: 50, color: Colors.red), Text("انت مطفي النت!"), ElevatedButton(onPressed: (){setState((){_load=true; _noNet=false;}); _check();}, child: Text("اعادة المحاولة"))])) : _c==null||!_c!.value.isInitialized? Center(child: Text("البث سيبدأ")): Stack(children: [VideoPlayer(_c!), Positioned(bottom: 8, left: 8, child: Container(padding: EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)), child: Text("🎙️ $_com", style: TextStyle(fontSize: 11))))]))), SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: comms.map((n){bool sel=n==_com; return GestureDetector(onTap: ()=>setState(()=>_com=n), child: Container(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: sel? Colors.red: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(20)), child: Text(n, style: TextStyle(fontSize: 12))));}).toList())])); }
}
class LiveScreen extends StatelessWidget { final Function(Map) onPlay; LiveScreen({required this.onPlay}); @override Widget build(BuildContext context) { var live=todayMatches.where((m)=>getMatchStatus(m)=="مباشر").toList(); if(live.isEmpty) return Center(child: Text("لا توجد مباريات مباشرة الان")); return ListView.builder(padding: EdgeInsets.all(12), itemCount: live.length, itemBuilder: (c,i){var m=live[i]; return ListTile(leading: Text(m["e1"], style: TextStyle(fontSize: 24)), title: Text("${m["t1"]} vs ${m["t2"]}"), trailing: ElevatedButton(onPressed: ()=>onPlay(m), child: Text("مشاهدة")));}); } }
class MatchesScreen extends StatelessWidget { final Function(Map) onPlay; MatchesScreen({required this.onPlay}); @override Widget build(BuildContext context) => HomeScreen(onPlay: onPlay); }
class FavScreen extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Text("المفضلة")); }
class AccountScreen extends StatefulWidget { @override _AccountScreenState createState() => _AccountScreenState(); }
class _AccountScreenState extends State<AccountScreen> {
  final GoogleSignIn _gs=GoogleSignIn(); GoogleSignInAccount? _u; bool _log=false;
  @override void initState() { super.initState(); _gs.onCurrentUserChanged.listen((a){setState((){_u=a; _log=a!=null;});}); _gs.signInSilently(); }
  Future<void> _in() async { try{var a=await _gs.signIn(); if(a!=null){setState((){_u=a; _log=true;});}} catch(e){} }
  Future<void> _out() async { await _gs.signOut(); setState((){_u=null; _log=false;}); }
  @override Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.all(16), children: [
      SizedBox(height: 20), FancyIraqHeader(),
      CircleAvatar(radius: 40, backgroundImage: _u?.photoUrl!=null? NetworkImage(_u!.photoUrl!): null, child: _u?.photoUrl==null? Icon(Icons.person, size: 40): null),
      SizedBox(height: 10), Center(child: Text(_u?.displayName??"زائر", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFD700)))), Center(child: Text(_u?.email??"سجل بايميلك الشخصي", style: TextStyle(color: Colors.grey, fontSize: 12))),
      SizedBox(height: 15), if(!_log) ElevatedButton(onPressed: _in, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black), child: Text("تسجيل بـ Google الحقيقي")) else ElevatedButton(onPressed: _out, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: Text("خروج ${_u?.email}")),
      Divider(color: Color(0xFFFFD700).withOpacity(0.2)), ListTile(leading: Icon(Icons.flag, color: Color(0xFFFFD700)), title: Text("واجهة فخمة بدون صور"), subtitle: Text("علم العراق مرسوم بالكود")),
    ]);
  }
}