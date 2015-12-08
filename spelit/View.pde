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
  
  CollisionCamera colCam;
  FrontCamera frontCam;
  
  
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
  
  View(int whichView, CollisionCamera colCam, FrontCamera frontCam, String title, String title2, String text) {
    this.whichView = whichView;
    this.colCam = colCam;
    this.frontCam = frontCam;
    this.title = title;
    this.title2 = title2;
    this.text = text;
  }
}