int btns[9] = {12,14,16,15,8,9,10,11,17};
int soundout = 2;
int i;
int j;
int freqs[9] = {110, 123, 261, 587, 784, 1319, 1397, 1568, 0};
int historyByBtn[9] = {-1,-1,-1,-1,-1,-1,-1,-1,0};
int historyByOrder[9] = {0,0,0,0,0,0,0,0,0};
int numbtns = 0;
int freqvarfactor;
int delaytime = 10;
int cyclelength;
int cyclestep = 0;
int basefreqvarfactor = 10;
int freq;
int isBeat = false;
int beatstep;
int numbeats = 8;
int beatsteplength=24;
int beatfreqs[8]={98,98,196,98,98,98,196,0};
int beatlengths[8] = {4,4,4,4,4,4,4,5};
int beatcountdown = 0;
int stepcountdown = 0;
float rads;
void setup(){
  for (i=0; i<9; i++){
    pinMode(btns[i], INPUT);
  }
  pinMode(soundout, OUTPUT);
  randomSeed(analogRead(4));
//  Serial.begin(9600);
}

void loop() {
  checkbtns();
  if (numbtns==0){
    freq=0;
  }
  else if (numbtns==1){
   freq=freqs[historyByOrder[0]];
  }
  else {
    cyclelength = beatsteplength/(pow(2,(numbtns-2)));
    freqvarfactor=basefreqvarfactor*(numbtns-1);
    if (cyclestep >= cyclelength) {
      cyclestep = 0;
    }
    rads=6.283*cyclestep/cyclelength;
    freq=freqs[historyByOrder[0]]+((freqs[historyByOrder[0]]*freqvarfactor*sin(rads))/100);
    cyclestep++;
  }
  if (isBeat){
    if (stepcountdown <1){
      beatstep++;
      stepcountdown=beatsteplength;
      if (beatstep >=numbeats){
        beatstep=0;
      }
      beatcountdown=beatlengths[beatstep];
    }
    if (beatcountdown>0){
      freq=beatfreqs[beatstep];
    }
    beatcountdown--;
    stepcountdown--;
  }
  if(freq>0){
    tone(soundout,freq);
  }
  else {
    noTone(soundout);
  }
  delay(delaytime);
}

void checkbtns () {
  numbtns = 0;
  for (i=0; i<8; i++){
    if (digitalRead(btns[i])){//button is pressed
      if (historyByBtn[i] < 0){//it is newly pressed
        for (j=0; j<8; j++){
          if (historyByBtn[j] >= 0){
            historyByBtn[j]++;
          }
        }
        historyByBtn[i]=0;
      }
      numbtns++;
    }
    else if (historyByBtn[i] >= 0){//newly released
      for (j=0; j<8; j++){
        if (historyByBtn[j]>historyByBtn[i]){
          historyByBtn[j]--;
        }
      }
      historyByBtn[i] = -1;      
    }
    historyByOrder[i] = 0;
  }
  for (i=0; i<numbtns; i++){
      for (j=0; j<8; j++){
        if (historyByBtn[j]==i){
          historyByOrder[i]=j;
        }
      }
  }
  if (digitalRead(btns[8])){
    if (historyByBtn[8]==0){
      isBeat=isBeat?false:true;
    }
    historyByBtn[8]=1;
  }
  else {
    historyByBtn[8]=0;
  }    
/*  Serial.println(numbtns);
  for(j=0;j<9;j++){
    Serial.print(historyByOrder[j]);
    Serial.print("X");
  }
  Serial.println(" ");*/
}


    
