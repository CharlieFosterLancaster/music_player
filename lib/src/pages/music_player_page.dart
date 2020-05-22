import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/src/helpers/helpers.dart';
import 'package:music_player/src/models/audioplayer_model.dart';
import 'package:music_player/src/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class MusicPlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(),
          Column(
            children: <Widget>[
              CustomAppBar(), 
              ImagenDiscoDuracion(),
              TituloPlay(),
              Expanded(
                child: Lyrics()
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: screenSize.height * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60.0)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: [
            Color(0xff33333E),
            Color(0xff201E28),
          ]
        )
      ),
    );
  }
}

class Lyrics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final lyrics = getLyrics();

    return Container(
      child: ListWheelScrollView(
        physics: BouncingScrollPhysics(),
        itemExtent: 42,
        diameterRatio: 1.5, 
        children: lyrics.map(
          (linea) => Text(
            linea, 
            style: TextStyle(
              fontSize: 20.0, color: Colors.white.withOpacity(0.6)
            ),
          )
        ).toList()
      ),
    );
  }
}

class TituloPlay extends StatefulWidget {
  @override
  _TituloPlayState createState() => _TituloPlayState();
}

class _TituloPlayState extends State<TituloPlay> with SingleTickerProviderStateMixin {

  bool isPlaying = false;
  bool firstTime = true;
  AnimationController playAnimation;

  final assetAudioPlayer = AssetsAudioPlayer();


  @override
  void initState() {
    this.playAnimation = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() { 
    this.playAnimation?.dispose();
    super.dispose();
  }

  void open() {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);

    assetAudioPlayer.open(Audio('assets/Breaking-Benjamin-Far-Away.mp3'));

    assetAudioPlayer.currentPosition.listen((duration) {
      audioPlayerModel.current = duration;
    });


    assetAudioPlayer.current.listen((playingAudio) {
      audioPlayerModel.songDuration = playingAudio.audio.duration;
    });

  }

  @override
  Widget build(BuildContext context) {

    print(assetAudioPlayer.current.value);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      margin: EdgeInsets.only(top: 40.0),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('Far Away', style: TextStyle(fontSize: 30.0, color: Colors.white.withOpacity(0.8)),),
              Text('Breaking Benjamin', style: TextStyle(fontSize: 15.0, color: Colors.white.withOpacity(0.5)),)
            ],
          ),
          Spacer(),
          FloatingActionButton(
            elevation: 0,
            highlightElevation: 0,
            backgroundColor: Color(0xffF8CB51),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause, 
              progress: playAnimation
            ),
            onPressed: () {

              final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);

              if (isPlaying) {
                playAnimation.reverse();
                isPlaying = false;
                audioPlayerModel.controller.stop();
              } else {
                playAnimation.forward();
                isPlaying = true;
                audioPlayerModel.controller.repeat();
              }

              if (firstTime) {
                this.open();
                firstTime = false;
              } else {
                assetAudioPlayer.playOrPause();
              }
            }
          )
        ],
      ),
    );
  }
}

class ImagenDiscoDuracion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        margin: EdgeInsets.only(top: 70.0),
        child: Row(
          children: <Widget>[
            ImagenDisco(),
            SizedBox(width: 20.0),
            BarraProgreso(),
            SizedBox(width: 5.0),
          ],
        ));
  }
}

class BarraProgreso extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final estilo = TextStyle(color: Colors.white.withOpacity(0.4));
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final porcentaje = audioPlayerModel.porcentaje;


    return Container(
        child: Column(
      children: <Widget>[
        Text(
          '${audioPlayerModel.songTotalDuration}',
          style: estilo,
        ),
        SizedBox(
          height: 10.0,
        ),
        Stack(
          children: <Widget>[
            Container(
              width: 3.0,
              height: 230.0,
              color: Colors.white.withOpacity(0.1),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                width: 3.0,
                height: 230.0 * porcentaje,
                color: Colors.white.withOpacity(0.8),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          '${audioPlayerModel.currentSecond}',
          style: estilo,
        )
      ],
    ));
  }
}

class ImagenDisco extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);

    return Container(
      padding: EdgeInsets.all(20.0),
      width: 250.0,
      height: 250.0,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(200.0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SpinPerfect(
                duration: Duration(seconds: 10),
                infinite: true,
                manualTrigger: true,
                controller: (animationController) => audioPlayerModel.controller = animationController,
                child: Image(
                  image: AssetImage('assets/aurora.jpg')
                ),
              ),
              Container(
                width: 25.0,
                height: 25.0,
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(100.0)),
              ),
              Container(
                width: 18.0,
                height: 18.0,
                decoration: BoxDecoration(
                    color: Color(0xff1C1C25),
                    borderRadius: BorderRadius.circular(100.0)),
              ),
            ],
          )),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200.0),
          gradient: LinearGradient(begin: Alignment.topLeft, colors: [
            Color(0xff484750),
            Color(0xff1E1C24),
          ])),
    );
  }
}