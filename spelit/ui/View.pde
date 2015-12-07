/*
    UI views
*/

class View {
  
  int whichView;
  color clr;
  String title;
  String text;
  
  PImage img;
  
  View(int whichView, color clr, String title, String text) {
    this.whichView = whichView;
    this.clr = clr;
    this.title = title;
    this.text = text;
  }
}

/*

1: otsikkonäkymä
    - kuva: speden spelit (netistä)

2: kalibrointi (kamera 1 ja 2)

3: pelaajat

*/