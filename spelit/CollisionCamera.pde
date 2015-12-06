// Yläkameraan liittyvä koodi tänne

class CollisionCamera {
    Capture             camera;
    ArrayList<PVector>  pinLocations;
    boolean             calibrating;
    PImage img = new PImage(80,60);
    BlobDetection blobDetection = new BlobDetection(img.width, img.height);

    // Constructor
    CollisionCamera(Capture _camera) {
        camera = _camera;
        pinLocations = new ArrayList<PVector>();
        calibrating = false;
    }

    void setupCamera() {
      camera.start();
      blobDetection.setPosDiscrimination(true);
      blobDetection.setThreshold(0.2f); 
    }
    
    
    void computeBlobs() {
      img.copy(camera, 0, 0, camera.width, camera.height, 
       0, 0, img.width, img.height);
      fastblur(img, 2);
      blobDetection.computeBlobs(img.pixels);
    }


    //Methods
    boolean detectCollision() {
      Blob b;
      for (int n=0 ; n < blobDetection.getBlobNb() ; n++) {
        b = blobDetection.getBlob(n);
        if (b!=null) {
        /*strokeWeight(3); //For debugging purposes
        stroke(0,0,255); 
        ellipse(
          b.xMin*width,b.yMin*height,
          b.w*width,b.h*height
          );*/
          for (int i = 0; i < pinLocations.size(); i++) {
            float radius =  pow(30 + b.w/2*width, 2); //This simple radius only works with ellipse that is relatively close to a circle
            float distance =  pow((b.x*width) - (pinLocations.get(i).x),2) + pow((b.y*height) - (pinLocations.get(i).y), 2);
            if (distance <= radius) {
              return true;
            }
          }
        }
      }
      return false;
    }
}

// ==================================================
// Super Fast Blur v1.1
// by Mario Klingemann 
// <http://incubator.quasimondo.com>
// ==================================================
void fastblur(PImage img,int radius)
{
 if (radius<1){
    return;
  }
  int w=img.width;
  int h=img.height;
  int wm=w-1;
  int hm=h-1;
  int wh=w*h;
  int div=radius+radius+1;
  int r[]=new int[wh];
  int g[]=new int[wh];
  int b[]=new int[wh];
  int rsum,gsum,bsum,x,y,i,p,p1,p2,yp,yi,yw;
  int vmin[] = new int[max(w,h)];
  int vmax[] = new int[max(w,h)];
  int[] pix=img.pixels;
  int dv[]=new int[256*div];
  for (i=0;i<256*div;i++){
    dv[i]=(i/div);
  }

  yw=yi=0;

  for (y=0;y<h;y++){
    rsum=gsum=bsum=0;
    for(i=-radius;i<=radius;i++){
      p=pix[yi+min(wm,max(i,0))];
      rsum+=(p & 0xff0000)>>16;
      gsum+=(p & 0x00ff00)>>8;
      bsum+= p & 0x0000ff;
    }
    for (x=0;x<w;x++){

      r[yi]=dv[rsum];
      g[yi]=dv[gsum];
      b[yi]=dv[bsum];

      if(y==0){
        vmin[x]=min(x+radius+1,wm);
        vmax[x]=max(x-radius,0);
      }
      p1=pix[yw+vmin[x]];
      p2=pix[yw+vmax[x]];

      rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
      gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
      bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
      yi++;
    }
    yw+=w;
  }

  for (x=0;x<w;x++){
    rsum=gsum=bsum=0;
    yp=-radius*w;
    for(i=-radius;i<=radius;i++){
      yi=max(0,yp)+x;
      rsum+=r[yi];
      gsum+=g[yi];
      bsum+=b[yi];
      yp+=w;
    }
    yi=x;
    for (y=0;y<h;y++){
      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
      if(x==0){
        vmin[y]=min(y+radius+1,hm)*w;
        vmax[y]=max(y-radius,0)*w;
      }
      p1=x+vmin[y];
      p2=x+vmax[y];

      rsum+=r[p1]-r[p2];
      gsum+=g[p1]-g[p2];
      bsum+=b[p1]-b[p2];

      yi+=w;
    }
  }

}
