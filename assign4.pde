int backgroundX, background1X, background2X;
int hpW;
int enemyX, enemyY, enemyWave;
int fighterX, fighterY, speed;  
int treasureX, treasureY;
int gameState;
int numFrames = 5;
final int GAME_START=0, GAME_RUN=1, GAME_OVER=2, FIRST_WAVE=3, SECOND_WAVE=4, THIRD_WAVE=5;
boolean upPressed, downPressed, leftPressed, rightPressed;
PImage background1, background2, start1, start2, end1, end2;
PImage enemy, fighter, hpImg, treasure, shoot;
PImage [] flames = new PImage[numFrames];
int [] currentFrame = new int [8];
float [] flamesX = new float[8];
float [] flamesY = new float[8];
float [] enemysX = new float[8];
float [] enemysY = new float[8];
float [] shootsX = new float[5];
float [] shootsY = new float[5];
boolean [] enemyDestory = new boolean[8];
boolean [] flamesAppear = new boolean[8];

void setup () {
	size(640, 480) ;
    //init variables
    backgroundX = 0;
    hpW         = 40;
    fighterX    = 550;
    fighterY    = 240;
    enemyX      = -61;
    enemyY      = floor(random(0,419));
    treasureX   = floor(random(20,501));
    treasureY   = floor(random(60,401));
    enemyWave   = FIRST_WAVE;
    speed       = 5;
    upPressed = downPressed = leftPressed = downPressed = false;
    for (int i = 0; i < 8; i++){
      enemyDestory[i] = false;
      flamesAppear[i] = false;
      currentFrame[i] = 0;
      enemysX[i] = enemysY[i] = 720;
    }
    for (int j = 0; j < 5; j++){
      shootsX[j] = -960;
      shootsY[j] = -960;
    }
    
    //loadImage
    background1=  loadImage("img/bg1.png");
    background2=  loadImage("img/bg2.png");
    enemy      =  loadImage("img/enemy.png");
    fighter    =  loadImage("img/fighter.png");
    hpImg      =  loadImage("img/hp.png");
    treasure   =  loadImage("img/treasure.png");
    start1     =  loadImage("img/start1.png");
    start2     =  loadImage("img/start2.png");
    end1       =  loadImage("img/end1.png");
    end2       =  loadImage("img/end2.png");
    for (int i=0; i<numFrames; i++){
      flames[i] = loadImage("img/flame" + (i+1) + ".png");
    }
    shoot      =  loadImage("img/shoot.png");
}

void draw() {
  switch (gameState){
      case GAME_START:
         if(mouseY > 375 && mouseY < 420 && mouseX > 200 && mouseX < 450){
           //click
           if(mousePressed){
             gameState = GAME_RUN;
           }
           //hover
           else
             image(start1,0,0);
         }
         else
           image(start2,0,0);
         break;
      case GAME_RUN:
         //bg
         image(background2,background2X,0);
         image(background1,background1X,0);
         background2X = backgroundX + 640;
         background1X = backgroundX ;
         backgroundX += 2;
         background2X = (background2X %= 1280) - 640;
         background1X = (background1X %= 1280) - 640;
         
         //hp volume
         if(hpW <= 0){
           hpW = 0;
           gameState = GAME_OVER;
         }
         stroke(255,0,0);
         fill(255,0,0);
         rect(20,20,hpW,20);
         
         //hpImg
         image(hpImg,15,15);
           
         //treasure
         if(fighterX-treasureX <= 41 && fighterY-treasureY <= 41 && 
            treasureX-fighterX <= 51 && treasureY-fighterY <= 51){
             treasureX = floor(random(20,501));
             treasureY = floor(random(60,401));
             if(hpW >= 200){
               hpW = 200;
             }
             else
               hpW+=20;
         }
         image(treasure,treasureX,treasureY);
         
         //Bullet
         for ( int shootNum=0; shootNum<5; shootNum++){
           image(shoot, shootsX[shootNum], shootsY[shootNum]);
           shootsX[shootNum]-=6;
           if(shootsX[shootNum] < -31)
             shootsX[shootNum] = shootsY[shootNum] = -960;
         }
         
         //check enemy destory or collide
         for(int enemyNumCheck = 0; enemyNumCheck < 8; enemyNumCheck++){
           //enemy destory
           for(int shootNumCheck = 0; shootNumCheck < 5; shootNumCheck++){
             if(shootsX[shootNumCheck]-enemysX[enemyNumCheck] <= 60 && shootsY[shootNumCheck]-enemysY[enemyNumCheck] <= 60 && 
                enemysX[enemyNumCheck]-shootsX[shootNumCheck] <= 30 && enemysY[enemyNumCheck]-shootsY[shootNumCheck] <= 30){
                  shootsX[shootNumCheck] = shootsY[shootNumCheck] = -960;
                  flamesX[enemyNumCheck] = enemysX[enemyNumCheck];
                  flamesY[enemyNumCheck] = enemysY[enemyNumCheck];
                  flamesAppear[enemyNumCheck] = true;
                  enemyDestory[enemyNumCheck] = true;
                  enemysX[enemyNumCheck] = enemysY[enemyNumCheck] = 720;
              }
           }
           //enemy collide
           if(fighterX-enemysX[enemyNumCheck] <= 61 && fighterY-enemysY[enemyNumCheck] <= 61 && 
              enemysX[enemyNumCheck]-fighterX <= 51 && enemysY[enemyNumCheck]-fighterY <= 51){
               flamesX[enemyNumCheck] = enemysX[enemyNumCheck];
               flamesY[enemyNumCheck] = enemysY[enemyNumCheck];
               flamesAppear[enemyNumCheck] = true;
               enemyDestory[enemyNumCheck] = true;
               enemysX[enemyNumCheck] = enemysY[enemyNumCheck] = 720;
               if(hpW < 40)
                 hpW -= hpW;
               else  
                 hpW -= 40;
           }
           //flames appear
           if(flamesAppear[enemyNumCheck] == true){
             image(flames[currentFrame[enemyNumCheck]],flamesX[enemyNumCheck],flamesY[enemyNumCheck]);  
             if(frameCount % (60/10) == 0){
               currentFrame[enemyNumCheck]++;
               if(currentFrame[enemyNumCheck] == numFrames){
                 flamesAppear[enemyNumCheck] = false;
                 currentFrame[enemyNumCheck] = 0;
               }
             }
           }
         }
         
         //fighter
         if(upPressed)
           fighterY -= speed;
         if(downPressed)
           fighterY += speed;
         if(leftPressed)
           fighterX -= speed;
         if(rightPressed)
           fighterX += speed;  
         //Boundary detection
           if(fighterX<0)
             fighterX = 0;
           if(fighterX > 590)
             fighterX = 590;
           if(fighterY < 0)
             fighterY = 0;
           if(fighterY > 430)
             fighterY = 430;
           image(fighter,fighterX,fighterY);
           
         //enemy
         enemyX +=4;  //enemy move
         switch (enemyWave){
           case FIRST_WAVE:
             for(int enemyNumber = 0; enemyNumber < 5; enemyNumber++){
               if(enemyDestory[enemyNumber] == false){
                 enemysX[enemyNumber] = enemyX-65*enemyNumber;
                 enemysY[enemyNumber] = enemyY;
               }
               image(enemy,enemysX[enemyNumber],enemysY[enemyNumber]); 
             }
             //change enemy wave
             if(enemyX > 969){
               enemyX = -61;
               enemyY = floor(random(0,159));
               enemyWave = SECOND_WAVE;
               for (int i = 0; i < 8; i++){
                 enemyDestory[i] = false;
                 flamesAppear[i] = false;
               }
             }
             break;
           case SECOND_WAVE:            
             for(int enemyNumber = 0; enemyNumber < 5; enemyNumber++){
               if(enemyDestory[enemyNumber] == false){
                 enemysX[enemyNumber] = enemyX-65*enemyNumber;
                 enemysY[enemyNumber] = enemyY+65*enemyNumber;
               }
               image(enemy,enemysX[enemyNumber],enemysY[enemyNumber]);
             }
             //change enemy wave
             if(enemyX > 969){
               enemyX = -61; 
               enemyY = floor(random(0,140));
               enemyWave = THIRD_WAVE;
               for (int i = 0; i < 8; i++){
                 enemyDestory[i] = false;
                 flamesAppear[i] = false;
               }
             }
             break;
           case THIRD_WAVE:
             //up 5 enemy
             for(int enemyNumber = 0; enemyNumber < 8; enemyNumber++){
               if(enemyDestory[enemyNumber] == false){  
                 //up 5 enemy
                 enemysX[enemyNumber] = enemyX-65*enemyNumber;
                 if(enemyNumber == 0 || enemyNumber == 4)
                   enemysY[enemyNumber] = enemyY+70*2;
                 else if(enemyNumber == 1 || enemyNumber == 3)
                   enemysY[enemyNumber] = enemyY+70;
                 else
                   enemysY[enemyNumber] = enemyY;
                 //down 3 enemy
                 if(enemyNumber > 4){
                   enemysX[enemyNumber] = enemyX-65*(enemyNumber-4);
                   if(enemyNumber == 5 || enemyNumber == 7)
                     enemysY[enemyNumber] = enemyY+70*3;
                   else
                     enemysY[enemyNumber] = enemyY+70*4;
                 }
               }
               image(enemy,enemysX[enemyNumber],enemysY[enemyNumber]);
             }
             //change enemy wave
             if(enemyX > 969){
               enemyX = -61;
               enemyY = floor(random(0,419));
               enemyWave = FIRST_WAVE;
               for (int i = 0; i < 8; i++){
                 enemyDestory[i] = false;
                 flamesAppear[i] = false;
               }
             }
             break;
         } 
         break;
      case GAME_OVER:
         if(mouseY >305 && mouseY < 350 && mouseX > 205 && mouseX < 440){
           //click
           if(mousePressed){
             fighterX = 550;
             fighterY = 240;
             treasureX = floor(random(20,501));
             treasureY = floor(random(60,401));
             hpW = 40;
             enemyX = -61;
             enemyY = floor(random(0,419));
             enemyWave = FIRST_WAVE;
             for (int i = 0; i < 8; i++){
               enemyDestory[i] = false;
               flamesAppear[i] = false;
               currentFrame[i] = 0;
             }
             for (int j = 0; j < 5; j++){
               shootsX[j] = -960;
               shootsY[j] = -960;
             }
             gameState = GAME_RUN;
           }
           //hover
           else
             image(end1,0,0);
         }
         else
           image(end2,0,0);
         break;
  }
}

void keyPressed(){
  if(key == CODED){
    switch(keyCode){
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
    }
  }
}

void keyReleased(){
  if(key == ' '){
    for(int shootNumC = 0;shootNumC<5;shootNumC++){
      if(shootsY[shootNumC] == -960){
        shootsX[shootNumC] = fighterX+fighter.width/5;
        shootsY[shootNumC] = fighterY+fighter.height/4;
        break;
      }
    }
  }
  if(key == CODED){
    switch(keyCode){
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
    }
  }
}
