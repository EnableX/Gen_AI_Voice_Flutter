
import 'dart:convert';

import 'package:enx_voice_bot/enx_voice_client.dart';
import 'package:enx_voice_bot/enx_voice_listener.dart';
import 'package:enx_voice_bot/enx_voice_state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class VoiceAgentAnimatedScreen extends StatefulWidget {
  const VoiceAgentAnimatedScreen({super.key});

  @override
  State<VoiceAgentAnimatedScreen> createState() =>
      _VoiceAgentAnimatedScreenState();
}

class _VoiceAgentAnimatedScreenState extends State<VoiceAgentAnimatedScreen>
    with TickerProviderStateMixin
    implements EnxVoiceListener {
  // UI Animations
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  // ✅ Wave animation controller (only bot speaking)
  late AnimationController _waveController;

  // Voice client
  late EnxVoiceClient _voiceClient;

  bool isConnected = false;
  bool isMuted = false;
  bool isPress = false;

  bool isBotSpeaking = false;
  bool isUserSpeaking = false;
  var virtualNumber="";//enter your virtual number

  @override
  void initState() {
    super.initState();

    _voiceClient = EnxVoiceClient().init(virtualNumber).setEnxVoiceListener(this);

    // Pulse animation for outer ring (Always)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    // Breath animation for inner circle (Always)
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    // ✅ Wave animation controller (Start/Stop dynamically)
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _breathController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  // ✅ Dynamic Status Text
  String get statusText {
    if (isConnected) {
      if (isBotSpeaking) return "BOT SPEAKING...";
      if (isUserSpeaking) return "YOU SPEAKING...";
      return "CONNECTED";
    }
    return isPress ? "CONNECTING..." : "READY";
  }

  // ✅ Bot wave widget (starts only on bot speaking)
  Widget botWave() {
    return SizedBox(
      height: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (index) {
          return AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              final v = _waveController.value;
              // each bar has offset
              final phase = (v + index * 0.15) % 1.0;

              // smooth bar height
              final h = (0.35 + (0.65 * (phase < 0.5 ? phase * 2 : (1 - phase) * 2)))
                  .clamp(0.35, 1.0);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  width: 6,
                  height: 26 * h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.88),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Future<String> fetchToken(String virtualNumber) async {
    final url = Uri.parse('https://botsdemo.enablex.io/get-token/?phone=$virtualNumber');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final token = jsonResponse['token'] as String?;

        if (token != null && token.isNotEmpty) {
          debugPrint('✅ Token fetched: $token');
          return token;
        }
      } else {
        debugPrint('❌ HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Network error: $e');
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;

            // Responsive values
            double titleSize = width < 600 ? 20 : 30;
            double subTitleSize = width < 600 ? 12 : 14;
            double circleSize = width < 600 ? 200 : 300;
            double padding = width < 600 ? 18 : 40;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding, vertical: 30),
                child: Column(
                  children: [
                    // Title
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          color: const Color(0xFF111827),
                        ),
                        children: const [
                          TextSpan(text: "Meet Our AI Voice Agent\n"),
                          TextSpan(
                            text: "for Smarter Credit Card Sales",
                            style: TextStyle(color: Color(0xFFE11D48)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      "Simple, fast, and personalised.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: subTitleSize,
                        color: const Color(0xFF6B7280),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "An AI sales agent that listens, recommends, compares, and converts -\nhelping customers find the right card in minutes.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: subTitleSize,
                        color: const Color(0xFF9CA3AF),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 45),

                    // ✅ Animated Voice Agent Circle
                    SizedBox(
                      width: circleSize + 80,
                      height: circleSize + 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer pulse ring
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: circleSize,
                                  height: circleSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF1D9BF0)
                                        .withOpacity(0.10),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Outer pulse ring 2
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value * 1.12,
                                child: Container(
                                  width: circleSize,
                                  height: circleSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF1D9BF0)
                                        .withOpacity(0.06),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Main white circle
                          Container(
                            width: circleSize,
                            height: circleSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 22,
                                  spreadRadius: 3,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                          ),

                          // Inner blue circle breathing animation
                          AnimatedBuilder(
                            animation: _breathController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _breathAnimation.value,
                                child: Container(
                                  width: circleSize * 0.70,
                                  height: circleSize * 0.70,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF1D9BF0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "enablex",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 24,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        "Voice Agent",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),

                                      Text(
                                        statusText,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          letterSpacing: 1.2,
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      // ✅ Show wave only when bot speaking
                                      AnimatedSwitcher(
                                        duration:
                                        const Duration(milliseconds: 250),
                                        child: isBotSpeaking
                                            ? botWave()
                                            : const SizedBox(height: 28),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ✅ Bottom Row Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Connect/Disconnect button
                        SizedBox(
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              if (isConnected || isPress) {
                                _voiceClient.disconnect();
                              } else {
                                setState(() {
                                  isPress = true;
                                });

                                final token = await fetchToken(virtualNumber);

                                if (token.isNotEmpty) {
                                  _voiceClient.connect(token);
                                } else {
                                  setState(() {
                                    isPress = false;
                                  });
                                }
                              }
                            },
                            icon: Icon(
                              (isConnected || isPress)
                                  ? Icons.call_end
                                  : Icons.call,
                              color: (isConnected || isPress)
                                  ? const Color(0xFFE11D48)
                                  : const Color(0xFF1D9BF0),
                              size: 20,
                            ),
                            label: Text(
                              (isConnected || isPress)
                                  ? "Disconnect"
                                  : "Get Started",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding:
                              const EdgeInsets.symmetric(horizontal: 18),
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        // Mute button (Only when connected)
                        if (isConnected)
                          InkWell(
                            onTap: () {
                              _voiceClient.muteAudio(!isMuted);
                            },
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 10,
                                    offset: const Offset(0, 6),
                                  )
                                ],
                              ),
                              child: Icon(
                                isMuted ? Icons.mic_off : Icons.mic,
                                color: isMuted
                                    ? const Color(0xFFE11D48)
                                    : const Color(0xFF1D9BF0),
                                size: 22,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ------------------- EnxVoiceListener callbacks -------------------

  @override
  void onCallConnected() {
    setState(() {
      isConnected = true;
      isPress = false;
      isBotSpeaking = false;
      isUserSpeaking = false;
    });

    debugPrint("✅ onCallConnected");
  }

  @override
  void onCallDisconnect() {
    setState(() {
      isConnected = false;
      isPress = false;
      isMuted = false;
      isBotSpeaking = false;
      isUserSpeaking = false;
    });

    // Stop wave if running
    _waveController.stop();
    _waveController.reset();

    debugPrint("❌ onCallDisconnect");
  }

  @override
  void onBotSpeaking(bool speaking) {
    debugPrint("🎧 onBotSpeaking => $speaking");

    setState(() {
      isBotSpeaking = speaking;
    });

    if (speaking) {
      if (!_waveController.isAnimating) {
        _waveController.repeat();
      }
    } else {
      _waveController.stop();
      _waveController.reset();
    }
  }

  @override
  void onUserSpeaking(bool speaking) {
    debugPrint("🎤 onUserSpeaking => $speaking");

    setState(() {
      isUserSpeaking = speaking;
    });
  }

  @override
  void onMuteStateChanged(bool muted) {
    debugPrint("🔇 onMuteStateChanged => $muted");
    setState(() {
      isMuted = muted;
    });
  }

  @override
  void onStatus(EnxVoiceState state) {
    debugPrint("📡 onStatus => ${state.name}");
  }

  @override
  void onError(String message) {
    debugPrint("❌ onError => $message");
  }
}