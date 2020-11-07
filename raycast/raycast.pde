// Daniel Shiffman
// https://thecodingtrain.com/CodingChallenges/145-2d-ray-casting.html
// https://youtu.be/TOEi6T2mtHo

// 2D Ray Casting
// https://editor.p5js.org/codingtrain/sketches/Nqsq3DFv-

Boundary[] walls;
Ray ray;
Particle particle;
float xoff = 0;
float yoff = 10000;

void setup() {
  mapC2 map = new mapC2();
  System.out.println(map.toBin("255", -1));
  System.out.println(map.toInt("010101010"));
  
  String mapdat =  "010101010";
  int mapw = 3;
  
  String enc = map.toInt(mapdat);
  System.out.println("Encoded: " + enc);
  
  String dec = map.parseMap(enc, mapw-1, mapdat.length());
  System.out.println("Decoded map: \n" + dec);
  System.out.println("Packed:" + map.pack(enc, mapw, mapdat.length()));
  
  //load
  String code = "5#0x01060000#25";
  System.out.println("Packed map: \n" + code);
  String data = map.unpack_d(code);
  mapw = map.unpack_w(code);
  int fsize = map.unpack_f(code);
  System.out.println("Unpacked map: " + mapw + " : " + data + " : " + fsize);
  boolean[][] dat = map.dataFromPacked(data, mapw, fsize);
  
  String outp = "";
  for(boolean[] row : dat){
      for(boolean it : row){
          if(it){
              outp += "1";
          }
          else{
              outp += "0";
          }
      }
      outp += "\n";
  }
  System.out.println(outp);
  
  //Actual loading
  int size = width/mapw;
  walls = new Boundary[fsize*2+4];
  for(int x=0;x<fsize;x++){
      for(int y=0;y<fsize;y++){
          if(dat[x][y]){
              int xo = x*size;
              int yo = y*size;
              Integer offsetsx[] = new Integer[]{
                xo, xo+size, xo+size, xo, /**/xo
              };
              Integer offsetsy[] = new Integer[]{
                yo, yo, yo+size, yo+size, /**/yo
              };
              for(int i=0;i<4;i++){
                  int xp = offsetsx[i];
                  int yp = offsetsy[i];
                  int xp2 = offsetsx[i+1];
                  int yp2 = offsetsy[i+1];
                  walls[i] = new Boundary(xp, yp, xp2, yp2);
              }
          }
      }
  }
  
  //Start
  size(400, 400);
  /*
  walls = new Boundary[5+4];
  for (int i = 0; i < walls.length; i++) {
    float x1 = random(width);
    float x2 = random(width);
    float y1 = random(height);
    float y2 = random(height);
    walls[i] = new Boundary(x1, y1, x2, y2);
  }*/
  walls[walls.length-4] = (new Boundary(0, 0, width, 0));
  walls[walls.length-3] = (new Boundary(width, 0, width, height));
  walls[walls.length-2] = (new Boundary(width, height, 0, height));
  walls[walls.length-1] = (new Boundary(0, height, 0, 0));
  particle = new Particle();
}

void draw() {
  background(0);
  int ind = 0;
  for (Boundary wall : walls) {
    if(wall != null){
      wall.show();
    }
    else{
        walls[ind] = new Boundary(0, 0, 0, 0);
        wall = walls[ind];
        wall.show();
    }
    ind++;
  }
  particle.update(mouseX, mouseY);
  particle.show();
  particle.look(walls);

  xoff += 0.01;
  yoff += 0.01;
}
