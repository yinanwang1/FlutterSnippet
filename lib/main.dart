import 'package:edge_to_edge/edge_to_edge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snippet/l10n/app_localizations.dart';

final snippetLocaleProvider = NotifierProvider<SnippetLocaleNotifier, Locale>(SnippetLocaleNotifier.new);

class SnippetLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => Locale('zh', "CN");

  void setValue(Locale value) {
    state = value;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _configureEdgeToEdge();
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        locale: ref.watch(snippetLocaleProvider),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: PhotoPoseGuide());
  }
}

void _configureEdgeToEdge() {
  // 每个页面使用SafeArea 在底部导航栏之上
  EdgeToEdge.configure(enableBottom: false);
}

class MyHomePage extends ConsumerStatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///需要注意，这个的AppBar 会影响 overlap 数值，如果没有，会多这部分像素点返回
      appBar: AppBar(title: const Text("Overlap Debug")),
      backgroundColor: Colors.grey[50],
      body: Center(
          child: Column(
        children: [
          Text(AppLocalizations.of(context)?.title ?? ""),
          TextButton(
            onPressed: () {
              var locale = ref.read(snippetLocaleProvider);
              if (locale.countryCode?.toLowerCase() == "cn") {
                ref.read(snippetLocaleProvider.notifier).setValue(Locale('en', 'US'));
              } else {
                ref.read(snippetLocaleProvider.notifier).setValue(Locale('zh', 'CN'));
              }
            },
            child: Text(AppLocalizations.of(context)?.comeOn ?? ""),
          ),
        ],
      )),
    );
  }
}

class PhotoPoseGuide extends StatelessWidget {
  const PhotoPoseGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Container(
          width: 350,
          height: 600,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            image: DecorationImage(
              // 这里模拟了背景图片的效果，实际使用时替换为你的照片
              image: NetworkImage(
                  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
            ),
          ),
          child: Stack(
            children: [
              // 顶部说明文字
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTag('建议姿势：漫步回眸'),
                      _buildTag('构图：三分法'),
                    ],
                  ),
                ),
              ),

              // 模拟人物位置 (使用自定义绘制的人物剪影)
              Positioned(
                bottom: 120, // 站在沙滩上
                right: 80, // 位于右侧三分之一处
                child: Container(
                  width: 80,
                  height: 180,
                  // 绘制人物示意图
                  child: CustomPaint(
                    painter: PosePainter(),
                  ),
                ),
              ),

              // 头部细节标注
              Positioned(
                bottom: 280,
                right: 95,
                child: _buildLabel('头：微侧，看向镜头或远方', Colors.yellow[700]!),
              ),

              // 身体细节标注
              Positioned(
                bottom: 200,
                right: 20,
                child: _buildLabel('身体：放松，侧对镜头', Colors.blue[700]!),
              ),

              // 手部细节标注
              Positioned(
                bottom: 240,
                right: 10,
                child: _buildLabel('手：自然摆动或遮阳', Colors.pink[700]!),
              ),

              // 脚部细节标注
              Positioned(
                bottom: 110,
                right: 70,
                child: _buildLabel('脚：前后站立，重心在后脚', Colors.green[700]!),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// 自定义绘制一个简单的火柴人姿势来示意
class PosePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, 30); // 头部中心

    // 1. 头 (Head)
    canvas.drawCircle(center, 10, paint);

    // 2. 身体 (Body) - 稍微倾斜表示动态
    final neck = Offset(center.dx, center.dy + 10);
    final hip = Offset(center.dx + 5, center.dy + 60); // 臀部稍微偏右，表示胯部送出
    canvas.drawLine(neck, hip, paint);

    // 3. 手 (Arms)
    // 左手自然下垂
    canvas.drawLine(neck, Offset(center.dx - 15, center.dy + 50), paint);
    // 右手稍微抬起或放在身侧
    canvas.drawLine(neck, Offset(center.dx + 25, center.dy + 45), paint);

    // 4. 腿 (Legs)
    // 后腿 (支撑腿)
    final kneeBack = Offset(hip.dx - 5, hip.dy + 30);
    canvas.drawLine(hip, kneeBack, paint);
    canvas.drawLine(kneeBack, Offset(kneeBack.dx - 5, kneeBack.dy + 40), paint);

    // 前腿 (迈步腿)
    final kneeFront = Offset(hip.dx + 5, hip.dy + 35);
    canvas.drawLine(hip, kneeFront, paint);
    canvas.drawLine(kneeFront, Offset(kneeFront.dx + 5, kneeFront.dy + 35), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
