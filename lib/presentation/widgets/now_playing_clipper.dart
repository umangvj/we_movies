import 'package:flutter/material.dart';

class NowPlayingClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, 0);

    path.lineTo(size.width * 0.8428436, 0);
    path.cubicTo(
        size.width * 0.9139956,
        size.height * -0.0003986782,
        size.width * 0.9139956,
        size.height * -0.0003986782,
        size.width * 0.9411666,
        size.height * 0.02062932);
    path.cubicTo(
        size.width * 0.9564133,
        size.height * 0.03456894,
        size.width * 0.9633088,
        size.height * 0.05099123,
        size.width * 0.9633423,
        size.height * 0.06979045);
    path.cubicTo(
        size.width * 0.9633471,
        size.height * 0.07094460,
        size.width * 0.9633519,
        size.height * 0.07209874,
        size.width * 0.9633569,
        size.height * 0.07328786);
    path.cubicTo(
        size.width * 0.9633706,
        size.height * 0.07716134,
        size.width * 0.9633697,
        size.height * 0.08103471,
        size.width * 0.9633688,
        size.height * 0.08490820);
    path.cubicTo(
        size.width * 0.9633756,
        size.height * 0.08771103,
        size.width * 0.9633832,
        size.height * 0.09051385,
        size.width * 0.9633917,
        size.height * 0.09331668);
    path.cubicTo(
        size.width * 0.9634122,
        size.height * 0.1010241,
        size.width * 0.9634198,
        size.height * 0.1087314,
        size.width * 0.9634253,
        size.height * 0.1164388);
    path.cubicTo(
        size.width * 0.9634333,
        size.height * 0.1247494,
        size.width * 0.9634529,
        size.height * 0.1330600,
        size.width * 0.9634708,
        size.height * 0.1413705);
    path.lineTo(size.width * 0.9634708, size.height * 0.7149383);
    path.cubicTo(
        size.width * 0.9642853,
        size.height * 0.7367183,
        size.width * 0.9603328,
        size.height * 0.7540378,
        size.width * 0.9425755,
        size.height * 0.7704100);
    path.cubicTo(
        size.width * 0.9236264,
        size.height * 0.7853852,
        size.width * 0.9010054,
        size.height * 0.7852039,
        size.width * 0.8765294,
        size.height * 0.7852161);
    path.cubicTo(
        size.width * 0.8491059,
        size.height * 0.7856161,
        size.width * 0.8284292,
        size.height * 0.7935337,
        size.width * 0.8084582,
        size.height * 0.8095136);
    path.cubicTo(
        size.width * 0.7857709,
        size.height * 0.8297398,
        size.width * 0.7801956,
        size.height * 0.8521597,
        size.width * 0.7797096,
        size.height * 0.8792642);
    path.cubicTo(
        size.width * 0.7790315,
        size.height * 0.8985788,
        size.width * 0.7730920,
        size.height * 0.9160830,
        size.width * 0.7563322,
        size.height * 0.9296891);
    path.cubicTo(
        size.width * 0.7416124,
        size.height * 0.9397411,
        size.width * 0.7249798,
        size.height * 0.9443076,
        size.width * 0.7061955,
        size.height * 0.9443199);
    path.cubicTo(
        size.width * 0.7040094,
        size.height * 0.9443256,
        size.width * 0.7018232,
        size.height * 0.9443312,
        size.width * 0.6995708,
        size.height * 0.9443370);
    path.cubicTo(
        size.width * 0.6971814,
        size.height * 0.9443343,
        size.width * 0.6947920,
        size.height * 0.9443316,
        size.width * 0.6923302,
        size.height * 0.9443288);
    path.cubicTo(
        size.width * 0.6885082,
        size.height * 0.9443348,
        size.width * 0.6885082,
        size.height * 0.9443348,
        size.width * 0.6846091,
        size.height * 0.9443409);
    path.cubicTo(
        size.width * 0.6775418,
        size.height * 0.9443500,
        size.width * 0.6704747,
        size.height * 0.9443514,
        size.width * 0.6634074,
        size.height * 0.9443493);
    path.cubicTo(
        size.width * 0.6557831,
        size.height * 0.9443489,
        size.width * 0.6481589,
        size.height * 0.9443586,
        size.width * 0.6405346,
        size.height * 0.9443669);
    path.cubicTo(
        size.width * 0.6255984,
        size.height * 0.9443815,
        size.width * 0.6106622,
        size.height * 0.9443863,
        size.width * 0.59572591,
        size.height * 0.9443873);
    path.cubicTo(
        size.width * 0.58358323,
        size.height * 0.9443881,
        size.width * 0.57144056,
        size.height * 0.9443917,
        size.width * 0.55929789,
        size.height * 0.9443973);
    path.lineTo(size.width * 0.1571564, size.height * 0.9443973);
    path.cubicTo(
        size.width * (1 - 0.9139956),
        size.height * (0.9443973 + 0.0003986782),
        size.width * (1 - 0.9139956),
        size.height * (0.9443973 + 0.0003986782),
        size.width * (1 - 0.9411666),
        size.height * (0.9443973 - 0.02062932));
    path.cubicTo(
        size.width * (1 - 0.9564133),
        size.height * (0.9443973 - 0.03456894),
        size.width * (1 - 0.9633088),
        size.height * (0.9443973 - 0.05099123),
        size.width * (1 - 0.9633423),
        size.height * (0.9443973 - 0.06979045));
    path.cubicTo(
        size.width * (1 - 0.9633471),
        size.height * (0.9443973 - 0.07094460),
        size.width * (1 - 0.9633519),
        size.height * (0.9443973 - 0.07209874),
        size.width * (1 - 0.9633569),
        size.height * (0.9443973 - 0.07328786));
    path.cubicTo(
        size.width * (1 - 0.9633706),
        size.height * (0.9443973 - 0.07716134),
        size.width * (1 - 0.9633697),
        size.height * (0.9443973 - 0.08103471),
        size.width * (1 - 0.9633688),
        size.height * (0.9443973 - 0.08490820));
    path.cubicTo(
        size.width * (1 - 0.9633756),
        size.height * (0.9443973 - 0.08771103),
        size.width * (1 - 0.9633832),
        size.height * (0.9443973 - 0.09051385),
        size.width * (1 - 0.9633917),
        size.height * (0.9443973 - 0.09331668));
    path.cubicTo(
        size.width * (1 - 0.9634122),
        size.height * (0.9443973 - 0.1010241),
        size.width * (1 - 0.9634198),
        size.height * (0.9443973 - 0.1087314),
        size.width * (1 - 0.9634283),
        size.height * (0.9443973 - 0.1164388));
    path.cubicTo(
        size.width * (1 - 0.9634333),
        size.height * (0.9443973 - 0.1247494),
        size.width * (1 - 0.9634529),
        size.height * (0.9443973 - 0.1330600),
        size.width * (1 - 0.9634758),
        size.height * (0.9443973 - 0.1413705));
    path.cubicTo(
        size.width * (1 - 0.9634850),
        size.height * (0.9443973 - 0.1507494),
        size.width * (1 - 0.9634940),
        size.height * (0.9443973 - 0.1580600),
        size.width * (1 - 0.9634999),
        size.height * (0.9443973 - 0.1673705));
    path.lineTo(size.width * (1 - 0.9634999), size.height * 0.23);
    path.cubicTo(
        size.width * 0.0365001,
        size.height * 0.2174688,
        size.width * 0.0365111,
        size.height * 0.2094673,
        size.width * 0.0365181,
        size.height * 0.2014655);
    path.cubicTo(
        size.width * 0.0365231,
        size.height * 0.1985813,
        size.width * 0.0365281,
        size.height * 0.1956971,
        size.width * 0.0365331,
        size.height * 0.1928130);
    path.cubicTo(
        size.width * 0.0365381,
        size.height * 0.1693380,
        size.width * 0.0475431,
        size.height * 0.1470966,
        size.width * 0.0585481,
        size.height * 0.1383048);
    path.cubicTo(
        size.width * 0.0695531,
        size.height * 0.1266595,
        size.width * 0.0705581,
        size.height * 0.1268595,
        size.width * 0.0815631,
        size.height * 0.1199810);
    path.cubicTo(
        size.width * 0.0925681,
        size.height * 0.1143368,
        size.width * 0.1135731,
        size.height * 0.1082096,
        size.width * 0.1245781,
        size.height * 0.1037434);
    path.cubicTo(
        size.width * 0.1355831,
        size.height * 0.1035720,
        size.width * 0.1465881,
        size.height * 0.1005019,
        size.width * 0.1575931,
        size.height * 0.1014894);
    path.lineTo(size.width * 0.4, size.height * 0.1014894);
    path.cubicTo(
        size.width * 0.1685981,
        size.height * 0.1012712,
        size.width * 0.1796031,
        size.height * 0.1012712,
        size.width * 0.1806081,
        size.height * 0.1011527);
    path.cubicTo(
        size.width * 0.1816131,
        size.height * 0.1034481,
        size.width * 0.1926181,
        size.height * 0.1034435,
        size.width * 0.1936231,
        size.height * 0.1034388);
    path.cubicTo(
        size.width * 0.2046281,
        size.height * 0.1034271,
        size.width * 0.2056331,
        size.height * 0.1034154,
        size.width * 0.2166381,
        size.height * 0.1034033);
    path.cubicTo(
        size.width * 0.2176431,
        size.height * 0.1033786,
        size.width * 0.2286481,
        size.height * 0.1033570,
        size.width * 0.2396531,
        size.height * 0.1033402);
    path.cubicTo(
        size.width * 0.2306581,
        size.height * 0.1033130,
        size.width * 0.2416631,
        size.height * 0.1032710,
        size.width * 0.2426681,
        size.height * 0.1032264);
    path.cubicTo(
        size.width * 0.2536731,
        size.height * 0.1031016,
        size.width * 0.2546781,
        size.height * 0.1029970,
        size.width * 0.2656831,
        size.height * 0.1029069);
    path.cubicTo(
        size.width * 0.2711923,
        size.height * 0.1028569,
        size.width * 0.2773510,
        size.height * 0.1027947,
        size.width * 0.2835096,
        size.height * 0.1027197);
    path.cubicTo(
        size.width * 0.2847760,
        size.height * 0.1026732,
        size.width * 0.2930425,
        size.height * 0.1026415,
        size.width * 0.2973087,
        size.height * 0.1026214);
    path.cubicTo(
        size.width * 0.3005407,
        size.height * 0.1026014,
        size.width * 0.3067730,
        size.height * 0.1025592,
        size.width * 0.3110052,
        size.height * 0.1025205);
    path.cubicTo(
        size.width * 0.3184379,
        size.height * 0.1025190,
        size.width * 0.3184379,
        size.height * 0.1025190,
        size.width * 0.3197986,
        size.height * 0.1025174);
    path.cubicTo(
        size.width * 0.3931955,
        size.height * 0.1025781,
        size.width * 0.4231955,
        size.height * 0.1025781,
        size.width * 0.4426061,
        size.height * 0.08795388);
    path.cubicTo(
        size.width * 0.45171154,
        size.height * 0.07775201,
        size.width * 0.45795883,
        size.height * 0.06791194,
        size.width * 0.45846717,
        size.height * 0.05462055);
    path.cubicTo(size.width * 0.46149939, size.height * 0.03514476,
        size.width * 0.47789670, 0, size.width * 0.55984418, 0);
    path.cubicTo(
      size.width * 0.64480753,
      0,
      size.width * 0.76480753,
      0,
      size.width * 0.8428436,
      0,
    );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
