/*
    UI views
*/

class View {
  
  int whichView;
  color clr;
  String title;
  String title2;
  String text;
  
  PImage img;
  
  View(int whichView, color clr, String title, String title2) {
    this.whichView = whichView;
    this.clr = clr;
    this.title = title;
    this.title2 = title2;
    this.text = "";
  }
  
  View(int whichView, color clr, String title, String title2, String text) {
    this.whichView = whichView;
    this.clr = clr;
    this.title = title;
    this.title2 = title2;
    this.text = text;
  }
}

/*

1: otsikkonäkymä
    - kuva: speden spelit (netistä)

2: kalibrointi (kamera 1 ja 2)

3: pelaajat

*/