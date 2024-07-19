import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:BlueFace/Model.dart';
import 'package:BlueFace/Services/FaceAuth/FaceAuthentication/size.dart';
import 'package:BlueFace/Services/FaceAuth/FaceAuthentication/snackbar.dart';
import 'package:BlueFace/Services/FaceAuth/FaceAuthentication/themes.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../StudentSide/AttendancePage.dart';
import '../BackgroundProcess/ExtractFaceFeatures.dart';
import 'CameraView.dart';
import 'CustomButton.dart';
import 'animatedView.dart';

class AuthenticateFaceView extends StatefulWidget {
  final StudentLogin student;
  const AuthenticateFaceView({Key? key, required this.student}) : super(key: key);

  @override
  State<AuthenticateFaceView> createState() => _AuthenticateFaceViewState();
}

class _AuthenticateFaceViewState extends State<AuthenticateFaceView> {
  @override
  void initState() {
    super.initState();
    // Initialize the ScreenSizeUtil context here
    ScreenSizeUtil.context = context;
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );
  FaceFeatures? _faceFeatures;
  var image1 = regula.MatchFacesImage();
  var image2 = regula.MatchFacesImage();

  final TextEditingController _nameController = TextEditingController();
  String _similarity = "";
  bool _canAuthenticate = false;
  List<dynamic> users = [];
  bool userExists = false;
  UserModel? loggingUser;
  bool isMatching = false;
  int trialNumber = 1;

  @override
  void dispose() {
    _faceDetector.close();
    _audioPlayer.dispose();
    super.dispose();
  }

  get _playScanningAudio =>
      _audioPlayer
        ..setReleaseMode(ReleaseMode.loop)
        ..play(AssetSource("scan_beep.wav"));

  get _playFailedAudio =>
      _audioPlayer
        ..stop()
        ..setReleaseMode(ReleaseMode.release)
        ..play(AssetSource("failed.mp3"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColor,
        title: const Text("Authenticate Face"),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Ensure constraints is not null before accessing max dimensions
          double maxWidth = ScreenSizeUtil.screenWidth;
          double maxHeight = ScreenSizeUtil.screenHeight;

          return Stack(
            children: [
              Container(
                width: maxWidth,
                height: maxHeight,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      scaffoldTopGradientClr,
                      scaffoldBottomGradientClr,
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 0.82.sh,
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(
                            0.05.sw, 0.025.sh, 0.05.sw, 0),
                        decoration: BoxDecoration(
                          color: overlayContainerClr,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0.03.sh),
                            topRight: Radius.circular(0.03.sh),
                          ),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CameraView(
                                  onImage: (image) {
                                    _setImage(image);
                                  },
                                  onInputImage: (inputImage) async {
                                    setState(() => isMatching = true);
                                    _faceFeatures = await extractFaceFeatures(
                                        inputImage, _faceDetector);
                                    setState(() => isMatching = false);
                                  },
                                ),
                                if (isMatching)
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 0.064.sh),
                                      child: const AnimatedView(),
                                    ),
                                  ),
                              ],
                            ),
                            const Spacer(),
                            if (_canAuthenticate)
                              CustomButton(
                                text: "Authenticate",
                                onTap: () {
                                  setState(() => isMatching = true);
                                  _playScanningAudio;
                                  _fetchUsersAndMatchFace();
                                },
                              ),
                            SizedBox(height: 0.038.sh),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _setImage(Uint8List imageToAuthenticate) async {
    image2.bitmap = base64Encode(imageToAuthenticate);
    image2.imageType = regula.ImageType.PRINTED;

    setState(() {
      _canAuthenticate = true;
    });
  }

  double compareFaces(FaceFeatures face1, FaceFeatures face2) {
    double distEar1 = euclideanDistance(face1.rightEar!, face1.leftEar!);
    double distEar2 = euclideanDistance(face2.rightEar!, face2.leftEar!);

    double ratioEar = distEar1 / distEar2;

    double distEye1 = euclideanDistance(face1.rightEye!, face1.leftEye!);
    double distEye2 = euclideanDistance(face2.rightEye!, face2.leftEye!);

    double ratioEye = distEye1 / distEye2;

    double distCheek1 = euclideanDistance(face1.rightCheek!, face1.leftCheek!);
    double distCheek2 = euclideanDistance(face2.rightCheek!, face2.leftCheek!);

    double ratioCheek = distCheek1 / distCheek2;

    double distMouth1 = euclideanDistance(face1.rightMouth!, face1.leftMouth!);
    double distMouth2 = euclideanDistance(face2.rightMouth!, face2.leftMouth!);

    double ratioMouth = distMouth1 / distMouth2;

    double distNoseToMouth1 = euclideanDistance(
        face1.noseBase!, face1.bottomMouth!);
    double distNoseToMouth2 = euclideanDistance(
        face2.noseBase!, face2.bottomMouth!);

    double ratioNoseToMouth = distNoseToMouth1 / distNoseToMouth2;

    double ratio = (ratioEye + ratioEar + ratioCheek + ratioMouth +
        ratioNoseToMouth) / 5;
    log(ratio.toString(), name: "Ratio");

    return ratio;
  }

  double euclideanDistance(Points p1, Points p2) {
    final sqr = math.sqrt(
        math.pow((p1.x! - p2.x!), 2) + math.pow((p1.y! - p2.y!), 2));
    return sqr;
  }

  Future<void> _fetchUsersAndMatchFace() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys(); // Get all keys from SharedPreferences
    users.clear();

    for (var key in keys) {
      final userJson = prefs.getString(key);
      if (userJson != null) {
        UserModel user = UserModel.fromJson(jsonDecode(userJson));
        double similarity = compareFaces(_faceFeatures!, user.faceFeatures!);
        if (similarity >= 0.8 && similarity <= 1.5) {
          users.add([user, similarity]);
        }
      }
    }

    log(users.length.toString(), name: "Filtered Users");
    setState(() {
      // Sort the users based on similarity.
      users.sort((a, b) => (b[1] as double).compareTo(a[1] as double));
    });

    if (users.isNotEmpty) {
      _matchFaces();
    } else {
      _showFailureDialog(
        title: "No Users Registered",
        description: "Make sure users are registered before Authenticating.",
      );
    }
  }

  Future<void> _matchFaces() async {
    bool faceMatched = false;
    for (List<dynamic> user in users) {
      image1.bitmap = (user[0] as UserModel).image;
      image1.imageType = regula.ImageType.PRINTED;

      var request = regula.MatchFacesRequest();
      request.images = [image1, image2];
      dynamic value = await regula.FaceSDK.matchFaces(jsonEncode(request));

      var response = regula.MatchFacesResponse.fromJson(json.decode(value));
      dynamic str = await regula.FaceSDK.matchFacesSimilarityThresholdSplit(
        jsonEncode(response!.results),
        0.75,
      );

      var split = regula.MatchFacesSimilarityThresholdSplit.fromJson(
          json.decode(str));
      setState(() {
        _similarity = split!.matchedFaces.isNotEmpty
            ? (split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2)
            : "error";
        log("similarity: $_similarity");

        if (_similarity != "error" && double.parse(_similarity) > 90.00) {
          faceMatched = true;
          loggingUser = user[0] as UserModel;
        } else {
          faceMatched = false;
        }
      });

      if (faceMatched) {
        _audioPlayer
          ..stop()
          ..setReleaseMode(ReleaseMode.release)
          ..play(AssetSource("success.mp3"));

        setState(() {
          trialNumber = 1;
          isMatching = false;
        });

        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  UserDetailsView(
                    student: widget.student,
                  ),
            ),
          );
        }
        break;
      }
    }

    if (!faceMatched) {
      if (trialNumber == 4) {
        setState(() => trialNumber = 1);
        _showFailureDialog(
          title: "Redeem Failed",
          description: "Face doesn't match. Please try again.",
        );
      } else if (trialNumber == 3) {
        _audioPlayer.stop();
        setState(() {
          isMatching = false;
          trialNumber++;
        });

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Enter Name"),
              content: TextFormField(
                controller: _nameController,
                cursorColor: accentColor,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 2,
                      color: accentColor,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 2,
                      color: accentColor,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_nameController.text
                        .trim()
                        .isEmpty) {
                      CustomSnackBar.errorSnackBar("Enter a name to proceed");
                    } else {
                      Navigator.of(context).pop();
                      setState(() => isMatching = true);
                      _playScanningAudio;
                      _fetchUserByName(_nameController.text.trim());
                    }
                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(
                      color: accentColor,
                    ),
                  ),
                )
              ],
            );
          },
        );
      } else {
        setState(() => trialNumber++);
        _showFailureDialog(
          title: "Redeem Failed",
          description: "Face doesn't match. Please try again.",
        );
      }
    }
  }

  Future<void> _fetchUserByName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys(); // Get all keys from SharedPreferences
    users.clear();

    for (var key in keys) {
      final userJson = prefs.getString(key);
      if (userJson != null) {
        UserModel user = UserModel.fromJson(jsonDecode(userJson));
        if (user.name!.toLowerCase() == name.toLowerCase()) {
          users.add([user, 1.0]); // Add user with a perfect match similarity
          break;
        }
      }
    }

    if (users.isNotEmpty) {
      _matchFaces();
    } else {
      _showFailureDialog(
        title: "User Not Found",
        description: "No user found with the entered name. Please try again.",
      );
    }
  }

  void _showFailureDialog(
      {required String title, required String description}) {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });

        return AlertDialog(
          title: Text(title),
          content: Text(description),
        );
      },
    );

    setState(() {
      isMatching = false;
      _playFailedAudio;
    });
  }
}